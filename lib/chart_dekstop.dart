import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'dart:developer' as dev;
import 'dart:async';
import 'dart:typed_data';

class SmartWattsApp extends StatelessWidget {
  const SmartWattsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const ChartPage(),
    );
  }
}

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  // Chart data
  int selectedCustomer = 1;
  String selectedMetric = 'energy';
  DateTime selectedMonth = DateTime.now();
  List<EnergyData> chartData = [];
  List<EnergyData> energyData = [];
  List<EnergyData> costData = [];
  bool isLoading = true;
  bool isGeneratingPdf = false;

  // Firebase Database Reference
  late DatabaseReference _databaseRef;

  // Timer for periodic data collection
  Timer? _dataCollectionTimer;
  Timer? _realTimeDataTimer;

  // Daily data storage for selected month
  Map<String, List<EnergyData>> dailyData = {'energy': [], 'cost': []};

  // Current Firebase values for today's data update
  double currentFirebaseEnergy = 0.0;
  double currentFirebaseCost = 0.0;

  final Map<String, String> metricLabels = {
    'energy': 'Energy (kWh)',
    'cost': 'Cost (IDR)',
  };

  final Map<String, IconData> metricIcons = {
    'energy': Icons.battery_charging_full,
    'cost': Icons.attach_money,
  };

  final Map<String, String> metricFirebasePaths = {
    'energy': 'calculated_energy',
    'cost': 'tagihan_estimasi',
  };

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.ref();
    selectedMonth = DateTime.now();
    _generateDailyData();
    _startDailyDataCollection();
    _startRealTimeDataListener();
  }

  @override
  void dispose() {
    _dataCollectionTimer?.cancel();
    _realTimeDataTimer?.cancel();
    super.dispose();
  }

  void _startRealTimeDataListener() {
    // Listen to real-time Firebase data for energy
    _databaseRef
        .child('pelanggan/$selectedCustomer/monitoring/calculated_energy')
        .onValue
        .listen((event) {
          if (event.snapshot.value != null) {
            final value =
                double.tryParse(event.snapshot.value.toString()) ?? 0.0;
            setState(() {
              currentFirebaseEnergy = value;
            });
            _updateTodayData();
          }
        });

    // Listen to real-time Firebase data for cost
    _databaseRef
        .child('pelanggan/$selectedCustomer/monitoring/tagihan_estimasi')
        .onValue
        .listen((event) {
          if (event.snapshot.value != null) {
            final value =
                double.tryParse(event.snapshot.value.toString()) ?? 0.0;
            setState(() {
              currentFirebaseCost = value;
            });
            _updateTodayData();
          }
        });

    // Update chart data every minute to incorporate Firebase values
    _realTimeDataTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateTodayData();
    });
  }

  void _updateTodayData() {
    if (!mounted) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Update today's data with Firebase values if available
    if (currentFirebaseEnergy > 0 || currentFirebaseCost > 0) {
      // Find today's entry in energy data
      final energyIndex = dailyData['energy']!.indexWhere(
        (data) =>
            data.date.year == today.year &&
            data.date.month == today.month &&
            data.date.day == today.day,
      );

      if (energyIndex != -1 && currentFirebaseEnergy > 0) {
        dailyData['energy']![energyIndex] = EnergyData(
          today,
          currentFirebaseEnergy,
        );
      }

      // Find today's entry in cost data
      final costIndex = dailyData['cost']!.indexWhere(
        (data) =>
            data.date.year == today.year &&
            data.date.month == today.month &&
            data.date.day == today.day,
      );

      if (costIndex != -1 && currentFirebaseCost > 0) {
        dailyData['cost']![costIndex] = EnergyData(today, currentFirebaseCost);
      }

      _updateChartData();
    }
  }

  void _startDailyDataCollection() {
    // Check for new data every hour
    _dataCollectionTimer = Timer.periodic(const Duration(hours: 1), (timer) {
      _collectDailyData();
    });

    // Initial data collection
    _collectDailyData();
  }

  void _collectDailyData() async {
    if (!mounted) return;

    try {
      final now = DateTime.now();

      // Always use current month
      if (now.year != selectedMonth.year || now.month != selectedMonth.month) {
        selectedMonth = now;
        _generateDailyData();
      } else {
        _updateChartData();
      }
    } catch (e) {
      dev.log('Error collecting daily data: $e');
    }
  }

  void _generateDailyData() {
    // Generate daily data for the selected month
    setState(() => isLoading = true);

    final year = selectedMonth.year;
    final month = selectedMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    // Clear existing data
    dailyData['energy']!.clear();
    dailyData['cost']!.clear();

    // Generate daily data points for the selected month
    for (int day = 1; day <= daysInMonth; day++) {
      final dayDateTime = DateTime(year, month, day);

      // All data should be 0 by default since we only use Firebase data
      // Only today's data will be updated with Firebase values via _updateTodayData()
      double dailyEnergy = 0.0;
      double dailyCost = 0.0;

      dailyData['energy']!.add(EnergyData(dayDateTime, dailyEnergy));
      dailyData['cost']!.add(EnergyData(dayDateTime, dailyCost));
    }

    _updateChartData();
  }

  void _updateChartData() {
    if (!mounted) return;

    setState(() {
      chartData = List.from(dailyData[selectedMetric] ?? []);
      energyData = List.from(dailyData['energy'] ?? []);
      costData = List.from(dailyData['cost'] ?? []);
      isLoading = false;
    });
  }

  // Helper methods for responsive design
  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  EdgeInsets _getResponsivePadding(BuildContext context) {
    if (_isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (_isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
    }
  }

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    if (_isMobile(context)) {
      return baseFontSize * 0.85;
    } else if (_isTablet(context)) {
      return baseFontSize * 0.95;
    } else {
      return baseFontSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Scaffold(
      backgroundColor: const Color(0xFF006FBD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: _getResponsivePadding(context),
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: isMobile ? 20 : 30),
              _buildControls(context),
              SizedBox(height: isMobile ? 20 : 30),
              _buildChartCard(context),
              const SizedBox(height: 20),
              _buildRealTimeCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 16 : 20,
        horizontal: isMobile ? 20 : 40,
      ),
      decoration: BoxDecoration(
        color: const Color(0xAA099FEA),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white),
      ),
      child:
          isMobile
              ? Column(
                children: [
                  Text(
                    'Energy Monitoring Chart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _getResponsiveFontSize(context, 24),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  _buildPdfButton(context),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Energy Monitoring Chart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _getResponsiveFontSize(context, 28),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  _buildPdfButton(context),
                ],
              ),
    );
  }

  Widget _buildPdfButton(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: isGeneratingPdf ? null : _generatePDF,
          icon: Icon(
            Icons.picture_as_pdf,
            color: isGeneratingPdf ? Colors.grey : Colors.white,
            size: _getResponsiveFontSize(context, 28),
          ),
          tooltip:
              isGeneratingPdf ? 'Generating PDF...' : 'Download PDF Report',
        ),
        if (isGeneratingPdf)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chart Settings',
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 20),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          isMobile
              ? Column(
                children: [
                  _buildDropdownField(
                    context,
                    'Customer',
                    selectedCustomer,
                    List.generate(4, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text(
                          'Customer ${index + 1}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }),
                    (value) {
                      setState(() {
                        selectedCustomer = value!;
                        isLoading = true;
                      });
                      _generateDailyData();
                      _startRealTimeDataListener(); // Restart listener for new customer
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildMetricDropdownField(context),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      context,
                      'Customer',
                      selectedCustomer,
                      List.generate(4, (index) {
                        return DropdownMenuItem(
                          value: index + 1,
                          child: Text(
                            'Customer ${index + 1}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }),
                      (value) {
                        setState(() {
                          selectedCustomer = value!;
                          isLoading = true;
                        });
                        _generateDailyData();
                        _startRealTimeDataListener(); // Restart listener for new customer
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(child: _buildMetricDropdownField(context)),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildDropdownField<T>(
    BuildContext context,
    String label,
    T value,
    List<DropdownMenuItem<T>> items,
    void Function(T?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 16),
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          style: const TextStyle(color: Colors.white),
          dropdownColor: const Color.fromARGB(255, 255, 255, 255),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildMetricDropdownField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Variable',
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 16),
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedMetric,
          style: const TextStyle(color: Colors.white),
          dropdownColor: const Color.fromARGB(255, 255, 255, 255),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items:
              metricLabels.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Row(
                    children: [
                      Icon(
                        metricIcons[entry.key],
                        size: 18,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          entry.value,
                          style: const TextStyle(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              selectedMetric = value!;
            });
            _updateChartData();
          },
        ),
      ],
    );
  }

  Widget _buildRealTimeCard(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Real-time Monitoring',
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 15),
          StreamBuilder<DatabaseEvent>(
            stream:
                _databaseRef
                    .child(
                      'pelanggan/$selectedCustomer/monitoring/${metricFirebasePaths[selectedMetric]}',
                    )
                    .onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                final value = snapshot.data!.snapshot.value.toString();
                final unit = _getUnit();
                final displayText =
                    selectedMetric == 'cost' ? 'IDR $value' : '$value $unit';

                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2AB0F2).withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF2AB0F2)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Current ${metricLabels[selectedMetric]}',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(context, 14),
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        displayText.trim(),
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(context, 24),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2AB0F2),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Container(
                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                  child: Text(
                    'Error loading real-time data: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              return Container(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 16),
                    Text('Loading real-time data...'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(BuildContext context) {
    final isMobile = _isMobile(context);
    final chartHeight = isMobile ? 300.0 : 400.0;

    return Container(
      height: chartHeight,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${metricLabels[selectedMetric]} - Customer $selectedCustomer',
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Daily Data - ${DateFormat('MMMM yyyy').format(selectedMonth)}',
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 14),
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '${metricLabels[selectedMetric]} - Customer $selectedCustomer',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 18),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    'Daily Data - ${DateFormat('MMMM yyyy').format(selectedMonth)}',
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 14),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
          SizedBox(height: isMobile ? 16 : 20),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildChart(context),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    if (chartData.isEmpty) {
      return const Center(
        child: Text(
          'No daily data available.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    final isMobile = _isMobile(context);
    final daysInMonth = chartData.length;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: daysInMonth > 15 ? 5 : 2, // Adjust based on days
          getDrawingHorizontalLine: (value) {
            return const FlLine(color: Colors.grey, strokeWidth: 0.5);
          },
          getDrawingVerticalLine: (value) {
            return const FlLine(color: Colors.grey, strokeWidth: 0.5);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < chartData.length) {
                  final day = chartData[index].date.day;
                  // Show every 5th day to avoid crowding
                  if (day % 5 == 1 || day == 1 || day == daysInMonth) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 4,
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 9 : 10,
                        ),
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: isMobile ? 50 : 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatYAxisValue(value),
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 9 : 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 0,
        maxX: (chartData.length - 1).toDouble(),
        minY:
            chartData.isNotEmpty
                ? chartData.map((e) => e.value).reduce(min) * 0.9
                : 0,
        maxY:
            chartData.isNotEmpty
                ? chartData.map((e) => e.value).reduce(max) * 1.1
                : 100,
        lineBarsData: [
          LineChartBarData(
            spots:
                chartData
                    .asMap()
                    .entries
                    .map(
                      (entry) =>
                          FlSpot(entry.key.toDouble(), entry.value.value),
                    )
                    .toList(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Color(0xFF2AB0F2), Color(0xFF006FBD)],
            ),
            barWidth: isMobile ? 2 : 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2AB0F2).withAlpha(77),
                  const Color(0xFF006FBD).withAlpha(26),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatYAxisValue(double value) {
    if (selectedMetric == 'cost') {
      return '${(value / 1000).toStringAsFixed(0)}k';
    }
    return value.toStringAsFixed(1);
  }

  String _getUnit() {
    switch (selectedMetric) {
      case 'energy':
        return 'kWh';
      default:
        return '';
    }
  }

  // Updated PDF generation with daily data
  Future<void> _generatePDF() async {
    if (isGeneratingPdf) return;

    setState(() {
      isGeneratingPdf = true;
    });

    try {
      // Show loading dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text('Generating PDF...'),
                ],
              ),
            );
          },
        );
      }

      // Generate PDF
      final pdfBytes = await _computePDF();

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => Uint8List.fromList(pdfBytes),
        name:
            'daily_energy_monitoring_customer_${selectedCustomer}_${DateFormat('yyyy_MM').format(selectedMonth)}.pdf',
      );
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.of(context).pop();

        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to generate PDF: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }

      dev.log('Error generating PDF: $e');
    } finally {
      if (mounted) {
        setState(() {
          isGeneratingPdf = false;
        });
      }
    }
  }

  Future<List<int>> _computePDF() async {
    final pdf = pw.Document();
    final chartDataCopy = List<EnergyData>.from(chartData);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // HEADER SECTION
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue,
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'SMART ENERGY METER',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Energy Monitoring Chart',
                    style: pw.TextStyle(fontSize: 16, color: PdfColors.white),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 24),

            // REPORT INFO SECTION
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Report Details',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text('Customer: $selectedCustomer'),
                        pw.Text(
                          'Report Period: ${DateFormat('MMMM yyyy').format(selectedMonth)}',
                        ),
                        pw.Text(
                          'Daily Data Points: ${chartDataCopy.length} days',
                        ),
                        pw.Text(
                          'Generated: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 24),

            // DAILY DATA TABLE SECTION
            if (chartDataCopy.isNotEmpty) ...[
              pw.Text(
                'Daily Data for ${metricLabels[selectedMetric]} - ${DateFormat('MMMM yyyy').format(selectedMonth)}',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),

              // Split data into chunks for better PDF layout
              ..._buildPaginatedTable(chartDataCopy),

              pw.SizedBox(height: 24),

              // MONTHLY SUMMARY SECTION
              pw.Text(
                'Monthly Summary',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),

              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.blue50,
                        borderRadius: pw.BorderRadius.circular(8),
                        border: pw.Border.all(color: PdfColors.blue200),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Text(
                            'Daily Average',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue800,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            _formatStatValue(
                              chartDataCopy
                                      .map((e) => e.value)
                                      .reduce((a, b) => a + b) /
                                  chartDataCopy.length,
                            ),
                            style: const pw.TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.green50,
                        borderRadius: pw.BorderRadius.circular(8),
                        border: pw.Border.all(color: PdfColors.green200),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Text(
                            'Peak Day',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green800,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            _formatStatValue(
                              chartDataCopy.map((e) => e.value).reduce(max),
                            ),
                            style: const pw.TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.orange50,
                        borderRadius: pw.BorderRadius.circular(8),
                        border: pw.Border.all(color: PdfColors.orange200),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Text(
                            'Monthly Total',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.orange800,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            _formatStatValue(
                              chartDataCopy
                                  .map((e) => e.value)
                                  .reduce((a, b) => a + b),
                            ),
                            style: const pw.TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 24),

              // WEEKLY BREAKDOWN
              pw.Text(
                'Weekly Breakdown',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              _buildWeeklyBreakdown(chartDataCopy),
            ],

            // FOOTER SECTION
            pw.SizedBox(height: 32),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Center(
                child: pw.Text(
                  'Smart Energy Meter System - Daily Monitoring Report for ${DateFormat('MMMM yyyy').format(selectedMonth)}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  List<pw.Widget> _buildPaginatedTable(List<EnergyData> data) {
    final List<pw.Widget> tables = [];
    const int rowsPerTable = 15; // Limit rows per table for better layout

    for (int i = 0; i < data.length; i += rowsPerTable) {
      final end =
          (i + rowsPerTable < data.length) ? i + rowsPerTable : data.length;
      final chunk = data.sublist(i, end);

      tables.add(
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FixedColumnWidth(1.5),
            1: const pw.FixedColumnWidth(2),
            2: const pw.FixedColumnWidth(2.5),
          },
          children: [
            // Table Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text(
                    'Day',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text(
                    'Date',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text(
                    'Daily ${metricLabels[selectedMetric] ?? selectedMetric}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            // Table Data
            ...chunk.map((data) {
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      data.date.day.toString(),
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      DateFormat('EEE, MMM d').format(data.date),
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      _formatStatValue(data.value),
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      );

      if (i + rowsPerTable < data.length) {
        tables.add(pw.SizedBox(height: 16));
      }
    }

    return tables;
  }

  pw.Widget _buildWeeklyBreakdown(List<EnergyData> data) {
    // Group data by week
    final Map<int, List<EnergyData>> weeklyData = {};

    for (final item in data) {
      final weekOfMonth = ((item.date.day - 1) ~/ 7) + 1;
      weeklyData[weekOfMonth] ??= [];
      weeklyData[weekOfMonth]!.add(item);
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Week',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Days',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Weekly Total',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Daily Average',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        // Data rows
        ...weeklyData.entries.map((entry) {
          final week = entry.key;
          final weekData = entry.value;
          final weekTotal = weekData
              .map((e) => e.value)
              .reduce((a, b) => a + b);
          final weekAverage = weekTotal / weekData.length;
          final dateRange =
              '${weekData.first.date.day}-${weekData.last.date.day}';

          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  'Week $week',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  dateRange,
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  _formatStatValue(weekTotal),
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  _formatStatValue(weekAverage),
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  String _formatStatValue(double value) {
    if (selectedMetric == 'cost') {
      return 'IDR ${NumberFormat('#,###').format(value.round())}';
    }
    return '${value.toStringAsFixed(2)} ${_getUnit()}';
  }
}

class EnergyData {
  final DateTime date;
  final double value;

  EnergyData(this.date, this.value);
}
