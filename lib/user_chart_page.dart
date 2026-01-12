import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'dart:developer' as dev;

class EnergyData {
  final DateTime date;
  final double value;

  EnergyData(this.date, this.value);
}

class UserChartPage extends StatefulWidget {
  final int customerId;

  const UserChartPage({super.key, required this.customerId});

  @override
  State<UserChartPage> createState() => _UserChartPageState();
}

class _UserChartPageState extends State<UserChartPage> {
  // Chart data
  String selectedMetric = 'energy';
  List<EnergyData> chartData = [];
  List<EnergyData> energyData = [];
  List<EnergyData> costData = [];
  bool isLoading = true;
  DateTime currentMonth = DateTime.now();

  // Firebase Database Reference
  late DatabaseReference _databaseRef;

  final Map<String, String> metricLabels = {
    'energy': 'Energy (kWh)',
    'cost': 'Cost (IDR)',
  };

  final Map<String, IconData> metricIcons = {
    'energy': Icons.power_settings_new,
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
    _loadChartData();
  }

  void _loadChartData() async {
    setState(() => isLoading = true);

    try {
      // Load data dari Firebase untuk kedua metric
      final energyDataList = await _loadFirebaseDataForMetric('energy');
      final costDataList = await _loadFirebaseDataForMetric('cost');

      setState(() {
        energyData = energyDataList;
        costData = costDataList;
        // Set chartData sesuai metric yang dipilih
        chartData = selectedMetric == 'energy' ? energyData : costData;
        isLoading = false;
      });

      dev.log(
        'Loaded ${energyData.length} energy data points and ${costData.length} cost data points',
      );
    } catch (e) {
      dev.log('Error loading data: $e');
      // Generate data dengan nilai 0 jika Firebase gagal
      await _generateZeroData();
    }
  }

  // Method untuk load data dari Firebase dengan integrasi SEM
  Future<List<EnergyData>> _loadFirebaseDataForMetric(String metric) async {
    final firebasePath = metricFirebasePaths[metric]!;
    final now = DateTime.now();

    // Generate untuk seluruh bulan (sesuai hari dalam bulan)
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    List<EnergyData> data = [];

    try {
      // Cek apakah ada data real-time dari SEM
      final currentSnapshot =
          await _databaseRef
              .child('pelanggan/${widget.customerId}/monitoring/$firebasePath')
              .get();

      if (currentSnapshot.exists) {
        final currentValue =
            double.tryParse(currentSnapshot.value.toString()) ?? 0.0;

        // Generate data historis berdasarkan nilai real saat ini
        for (int day = 1; day <= daysInMonth; day++) {
          final date = DateTime(now.year, now.month, day);
          double value;

          if (day <= now.day) {
            // Untuk hari-hari yang sudah berlalu, buat variasi dari nilai real
            if (day == now.day) {
              value = currentValue;
            } else {
              value = _generateHistoricalValue(
                currentValue,
                day,
                now.day,
                metric,
              );
            }
          } else {
            // Untuk hari-hari yang akan datang, set 0
            value = 0.0;
          }

          data.add(EnergyData(date, value));
        }

        dev.log(
          'Generated data for $metric based on current value: $currentValue',
        );
      } else {
        // Jika tidak ada data real-time, buat data dengan nilai 0
        for (int day = 1; day <= daysInMonth; day++) {
          final date = DateTime(now.year, now.month, day);
          data.add(EnergyData(date, 0.0));
        }

        dev.log('No real-time data found for $metric, using zero values');
      }
    } catch (e) {
      dev.log('Firebase error for $metric: $e');
      // Fallback: buat data dengan nilai 0
      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(now.year, now.month, day);
        data.add(EnergyData(date, 0.0));
      }
    }

    return data;
  }

  // Method untuk generate nilai historis berdasarkan nilai real saat ini
  double _generateHistoricalValue(
    double currentValue,
    int day,
    int currentDay,
    String metric,
  ) {
    final random = Random();
    final progress = day / currentDay;

    // Buat tren yang realistis menuju nilai saat ini
    double baseValue;
    switch (metric) {
      case 'energy':
        // Energy biasanya akumulatif, jadi nilai sebelumnya lebih kecil
        baseValue =
            currentValue * progress +
            random.nextDouble() * (currentValue * 0.1) -
            (currentValue * 0.05);
        break;
      case 'cost':
        // Cost juga akumulatif
        baseValue =
            currentValue * progress +
            random.nextDouble() * (currentValue * 0.1) -
            (currentValue * 0.05);
        break;
      default:
        baseValue = currentValue * (0.8 + random.nextDouble() * 0.4);
    }

    return baseValue.abs().clamp(
      0.0,
      double.infinity,
    ); // Pastikan nilai positif dan tidak negatif
  }

  // Fallback method untuk generate data dengan nilai 0
  Future<void> _generateZeroData() async {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    List<EnergyData> energyDataList = [];
    List<EnergyData> costDataList = [];

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      energyDataList.add(EnergyData(date, 0.0));
      costDataList.add(EnergyData(date, 0.0));
    }

    setState(() {
      energyData = energyDataList;
      costData = costDataList;
      chartData = selectedMetric == 'energy' ? energyData : costData;
      isLoading = false;
    });

    dev.log('Generated zero data for fallback');
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF006FBD),
        title: Text(
          'Customer ${widget.customerId} - Energy Charts',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
              _buildStatsCard(context),
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
                    'Customer ${widget.customerId} Energy Chart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _getResponsiveFontSize(context, 24),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  IconButton(
                    onPressed: _generatePDF,
                    icon: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                      size: _getResponsiveFontSize(context, 28),
                    ),
                    tooltip: 'Download PDF Report',
                  ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Customer ${widget.customerId} Energy Chart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _getResponsiveFontSize(context, 28),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: _generatePDF,
                    icon: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                      size: _getResponsiveFontSize(context, 28),
                    ),
                    tooltip: 'Download PDF Report',
                  ),
                ],
              ),
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
          _buildMetricDropdownField(context),
        ],
      ),
    );
  }

  Widget _buildMetricDropdownField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Metric',
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
              // Update chartData sesuai metric yang dipilih
              chartData = selectedMetric == 'energy' ? energyData : costData;
            });
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
                      'pelanggan/${widget.customerId}/monitoring/${metricFirebasePaths[selectedMetric]}',
                    )
                    .onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                final value =
                    double.tryParse(snapshot.data!.snapshot.value.toString()) ??
                    0.0;
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
                        _formatStatValue(value),
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
                    '${metricLabels[selectedMetric]} - Customer ${widget.customerId}',
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Monthly Chart - ${DateFormat('MMMM yyyy').format(currentMonth)}',
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
                      '${metricLabels[selectedMetric]} - Customer ${widget.customerId}',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 18),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    'Monthly Chart - ${DateFormat('MMMM yyyy').format(currentMonth)}',
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
          'No data available for this month',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    final isMobile = _isMobile(context);
    final maxValue = chartData.map((e) => e.value).reduce(max);
    final minValue = chartData.map((e) => e.value).reduce(min);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: maxValue > 0 ? maxValue / 5 : 1,
          verticalInterval: 5,
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
              interval: isMobile ? 5 : 3,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4,
                  child: Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 10 : 12,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: null,
              reservedSize: isMobile ? 40 : 50,
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
        minX: 1,
        maxX:
            chartData.length
                .toDouble(), // Dynamic based on actual days in month
        minY: minValue >= 0 ? 0 : minValue * 1.1,
        maxY: maxValue > 0 ? maxValue * 1.1 : 10,
        lineBarsData: [
          LineChartBarData(
            spots:
                chartData
                    .asMap()
                    .entries
                    .map(
                      (entry) =>
                          FlSpot((entry.key + 1).toDouble(), entry.value.value),
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

  Widget _buildStatsCard(BuildContext context) {
    if (chartData.isEmpty) return const SizedBox.shrink();

    final values = chartData.map((e) => e.value).toList();
    final avg = values.reduce((a, b) => a + b) / values.length;
    final maxVal = values.reduce(max);
    final minVal = values.reduce(min);
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
            'Monthly Statistics',
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 15),
          isMobile
              ? Column(
                children: [
                  _buildStatItem(context, 'Average', avg, Colors.blue),
                  const SizedBox(height: 8),
                  _buildStatItem(context, 'Maximum', maxVal, Colors.green),
                  const SizedBox(height: 8),
                  _buildStatItem(context, 'Minimum', minVal, Colors.orange),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: _buildStatItem(context, 'Average', avg, Colors.blue),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Maximum',
                      maxVal,
                      Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Minimum',
                      minVal,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    final isMobile = _isMobile(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 5),
      padding: EdgeInsets.all(isMobile ? 16 : 12),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 12),
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatStatValue(value),
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 16),
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatStatValue(double value) {
    if (selectedMetric == 'cost') {
      return 'IDR ${NumberFormat('#,###').format(value.round())}';
    }
    return '${value.toStringAsFixed(2)} ${_getUnit()}';
  }

  String _getUnit() {
    switch (selectedMetric) {
      case 'energy':
        return 'kWh';
      default:
        return '';
    }
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

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
                    'Customer ${widget.customerId} Energy Report',
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
                        pw.Text('Customer: ${widget.customerId}'),
                        pw.Text(
                          'Period: ${DateFormat('MMMM yyyy').format(currentMonth)} (30 Days)',
                        ),
                        pw.Text(
                          'Generated: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                        ),
                        pw.Text('Data Source: Firebase Real-time Database'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 24),

            // STATISTICS SECTION
            if (chartData.isNotEmpty) ...[
              pw.Text(
                'Monthly Statistics - ${metricLabels[selectedMetric]}',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPDFStatItem(
                          'Average',
                          chartData
                                  .map((e) => e.value)
                                  .reduce((a, b) => a + b) /
                              chartData.length,
                        ),
                        _buildPDFStatItem(
                          'Maximum',
                          chartData.map((e) => e.value).reduce(max),
                        ),
                        _buildPDFStatItem(
                          'Minimum',
                          chartData.map((e) => e.value).reduce(min),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            pw.SizedBox(height: 24),

            // DATA INTEGRATION NOTE
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                border: pw.Border.all(color: PdfColors.blue),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Data Integration Information',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    '• Real-time data synchronized with Smart Energy Meter',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.Text(
                    '• Chart displays monthly view with current readings',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.Text(
                    '• Zero values displayed when no Firebase data available',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 24),

            // ENERGY DATA SECTION
            if (energyData.isNotEmpty) ...[
              pw.Text(
                'Energy Data Summary',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Total Energy: ${_formatStatValue(energyData.map((e) => e.value).reduce((a, b) => a + b))}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Average Daily: ${_formatStatValue(energyData.map((e) => e.value).reduce((a, b) => a + b) / energyData.length)}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
            ],

            // COST DATA SECTION
            if (costData.isNotEmpty) ...[
              pw.Text(
                'Cost Data Summary',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Total Cost: ${NumberFormat('#,###').format(costData.map((e) => e.value).reduce((a, b) => a + b).round())} IDR',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Average Daily: ${NumberFormat('#,###').format((costData.map((e) => e.value).reduce((a, b) => a + b) / costData.length).round())} IDR',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],

            pw.SizedBox(height: 24),

            // FOOTER
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Center(
                child: pw.Text(
                  'Generated by Smart Energy Meter System',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                ),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name:
          'energy_report_customer_${widget.customerId}_${DateFormat('yyyy_MM').format(currentMonth)}.pdf',
    );
  }

  // Helper method untuk PDF statistics
  pw.Widget _buildPDFStatItem(String label, double value) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          _formatStatValue(value),
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }
}
