import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:developer' as dev;

class SmartWattsApp extends StatelessWidget {
  const SmartWattsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const ReportPage(),
    );
  }
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool isLoading = true;

  // Firebase Database Reference
  late DatabaseReference _databaseRef;

  // Helper methods untuk responsive design
  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > 1024;
  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > 600 &&
      MediaQuery.of(context).size.width <= 1024;
  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;

  // Dynamic text styles based on screen size
  TextStyle get whiteTitleStyle => TextStyle(
    color: Colors.white,
    fontSize:
        isMobile(context)
            ? 18
            : isTablet(context)
            ? 24
            : 28,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
  );

  TextStyle get blackLabelStyle => TextStyle(
    color: Colors.black,
    fontSize:
        isMobile(context)
            ? 12
            : isTablet(context)
            ? 14
            : 16,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
  );

  TextStyle get infoLabelStyle => TextStyle(
    color: Colors.black,
    fontSize:
        isMobile(context)
            ? 11
            : isTablet(context)
            ? 12
            : 14,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
  );

  TextStyle get dataValueStyle => TextStyle(
    color: Colors.black,
    fontSize:
        isMobile(context)
            ? 12
            : isTablet(context)
            ? 14
            : 16,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
  );

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.ref();
    _loadReportData();
  }

  void _loadReportData() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);
  }

  Stream<Map<String, double>> _getAverageData() async* {
    while (true) {
      try {
        Map<String, double> totals = {
          'voltage': 0.0,
          'current': 0.0,
          'power': 0.0,
          'powerFactor': 0.0,
          'time': 0.0,
          'energy': 0.0,
          'cost': 0.0,
        };

        int customerCount = 0;

        for (int customerId = 1; customerId <= 4; customerId++) {
          try {
            final DatabaseEvent monitoringEvent =
                await _databaseRef
                    .child('pelanggan/$customerId/monitoring')
                    .once();

            final DatabaseEvent billingEvent =
                await _databaseRef
                    .child('pelanggan/$customerId/billing')
                    .once();

            if (monitoringEvent.snapshot.value != null) {
              final monitoringData = Map<String, dynamic>.from(
                monitoringEvent.snapshot.value as Map,
              );

              totals['voltage'] =
                  totals['voltage']! +
                  (double.tryParse(
                        monitoringData['tegangan']?.toString() ?? '0',
                      ) ??
                      0.0);
              totals['current'] =
                  totals['current']! +
                  (double.tryParse(monitoringData['arus']?.toString() ?? '0') ??
                      0.0);
              totals['power'] =
                  totals['power']! +
                  (double.tryParse(monitoringData['daya']?.toString() ?? '0') ??
                      0.0);
              totals['powerFactor'] =
                  totals['powerFactor']! +
                  (double.tryParse(
                        monitoringData['faktor_daya']?.toString() ?? '0',
                      ) ??
                      0.0);
              totals['time'] =
                  totals['time']! +
                  (double.tryParse(
                        monitoringData['durasi_penggunaan_jam']?.toString() ??
                            '0',
                      ) ??
                      0.0);
              totals['energy'] =
                  totals['energy']! +
                  (double.tryParse(
                        monitoringData['energi']?.toString() ?? '0',
                      ) ??
                      0.0);

              if (billingEvent.snapshot.value != null) {
                final billingData = Map<String, dynamic>.from(
                  billingEvent.snapshot.value as Map,
                );

                double customerCost = 0.0;
                if (billingData['monthly_cost'] != null) {
                  customerCost =
                      double.tryParse(billingData['monthly_cost'].toString()) ??
                      0.0;
                } else {
                  final energy =
                      double.tryParse(
                        billingData['monthly_energy']?.toString() ?? '0',
                      ) ??
                      0.0;
                  const costPerKwh = 1352.0;
                  customerCost = energy * costPerKwh;
                }

                totals['cost'] = totals['cost']! + customerCost;
              }

              customerCount++;
            }
          } catch (e) {
            dev.log('Error getting data for customer $customerId: $e');
          }
        }

        Map<String, double> averages = {
          'voltage':
              customerCount > 0
                  ? totals['voltage']! / customerCount
                  : 220.0 + Random().nextDouble() * 10,
          'current':
              customerCount > 0
                  ? totals['current']! / customerCount
                  : 0.5 + Random().nextDouble() * 0.5,
          'power':
              customerCount > 0
                  ? totals['power']! / customerCount
                  : 100 + Random().nextDouble() * 50,
          'powerFactor':
              customerCount > 0
                  ? totals['powerFactor']! / customerCount
                  : 0.85 + Random().nextDouble() * 0.1,
          'time':
              customerCount > 0
                  ? totals['time']! / customerCount
                  : 8 + Random().nextDouble() * 4,
          'energy':
              customerCount > 0
                  ? totals['energy']! / customerCount
                  : 15 + Random().nextDouble() * 10,
          'cost':
              customerCount > 0
                  ? totals['cost']! / customerCount
                  : 65000 + Random().nextDouble() * 20000,
        };

        yield averages;
      } catch (e) {
        dev.log('Error getting average data: $e');
        yield {
          'voltage': 220.0 + Random().nextDouble() * 10,
          'current': 0.5 + Random().nextDouble() * 0.5,
          'power': 100 + Random().nextDouble() * 50,
          'powerFactor': 0.85 + Random().nextDouble() * 0.1,
          'time': 8 + Random().nextDouble() * 4,
          'energy': 15 + Random().nextDouble() * 10,
          'cost': 65000 + Random().nextDouble() * 20000,
        };
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Stream<Map<String, dynamic>> _getSystemInfo() async* {
    while (true) {
      try {
        final DatabaseEvent systemEvent =
            await _databaseRef.child('system_info').once();

        Map<String, dynamic> systemInfo = {
          'costPerKwh': 1352.0,
          'numberOfSem': 4,
          'rssi': -45.0,
          'latency': 15.0,
          'txPower': 17.0,
          'snr': 69.0,
        };

        if (systemEvent.snapshot.value != null) {
          final data = Map<String, dynamic>.from(
            systemEvent.snapshot.value as Map,
          );

          final rssi =
              (data['rssi'] as num?)?.toDouble() ??
              (-45.0 + Random().nextDouble() * 20);

          systemInfo.addAll({
            'costPerKwh': (data['costPerKwh'] as num?)?.toDouble() ?? 1352.0,
            'numberOfSem': (data['numberOfSem'] as num?)?.toInt() ?? 4,
            'rssi': rssi,
            'latency':
                (data['latency'] as num?)?.toDouble() ??
                (10.0 + Random().nextDouble() * 20),
            'txPower':
                (data['txPower'] as num?)?.toDouble() ??
                (14.0 + Random().nextDouble() * 6),
            'snr': (data['snr'] as num?)?.toDouble() ?? _calculateSNR(rssi),
          });
        } else {
          final rssi = -45.0 + Random().nextDouble() * 20;
          systemInfo.addAll({
            'rssi': rssi,
            'latency': 10.0 + Random().nextDouble() * 20,
            'txPower': 14.0 + Random().nextDouble() * 6,
            'snr': _calculateSNR(rssi),
          });
        }

        await _databaseRef.child('system performance').set({
          'rssi': systemInfo['rssi'],
          'snr': systemInfo['snr'],
          'latency': systemInfo['latency'],
          'txPower': systemInfo['txPower'],
        });

        yield systemInfo;
      } catch (e) {
        dev.log('Error getting system info: $e');
        yield {
          'costPerKwh': 1352.0,
          'numberOfSem': 4,
          'rssi': -45.0,
          'latency': 15.0,
          'txPower': 17.0,
          'snr': 69.0,
        };
      }

      await Future.delayed(const Duration(seconds: 3));
    }
  }

  double _calculateSNR(double rssi) {
    const double assumedNoiseFloor = -100.0;
    return rssi - assumedNoiseFloor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006FBD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile(context) ? 12 : 20),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: isMobile(context) ? 20 : 30),
              StreamBuilder<Map<String, double>>(
                stream: _getAverageData(),
                builder: (context, averageSnapshot) {
                  return StreamBuilder<Map<String, dynamic>>(
                    stream: _getSystemInfo(),
                    builder: (context, systemSnapshot) {
                      final averageData = averageSnapshot.data ?? {};
                      final systemInfo = systemSnapshot.data ?? {};

                      return _buildResponsiveLayout(averageData, systemInfo);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(
    Map<String, double> averageData,
    Map<String, dynamic> systemInfo,
  ) {
    if (isMobile(context)) {
      // Mobile layout: Vertical stack
      return Column(
        children: [
          _buildInformationSection(systemInfo),
          const SizedBox(height: 16),
          _buildAverageSection(averageData),
          const SizedBox(height: 16),
          _buildSystemPerformanceSection(systemInfo),
        ],
      );
    } else if (isTablet(context)) {
      // Tablet layout: 2 kolom atas, 1 kolom bawah
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildInformationSection(systemInfo)),
              const SizedBox(width: 16),
              Expanded(child: _buildAverageSection(averageData)),
            ],
          ),
          const SizedBox(height: 20),
          _buildSystemPerformanceSection(systemInfo),
        ],
      );
    } else {
      // Desktop layout: Vertical stack (sama seperti mobile)
      return Column(
        children: [
          _buildInformationSection(systemInfo),
          const SizedBox(height: 20),
          _buildAverageSection(averageData),
          const SizedBox(height: 20),
          _buildSystemPerformanceSection(systemInfo),
        ],
      );
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile(context) ? 12 : 20,
        horizontal: isMobile(context) ? 16 : 40,
      ),
      decoration: BoxDecoration(
        color: const Color(0xAA099FEA),
        borderRadius: BorderRadius.circular(isMobile(context) ? 12 : 22),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              'Energy Monitoring Report',
              style: whiteTitleStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAverageSection(Map<String, double> averageData) {
    return Container(
      padding: EdgeInsets.all(isMobile(context) ? 12 : 20),
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: isMobile(context) ? 8 : 15),
            decoration: const BoxDecoration(
              color: Color(0xFF2AB0F2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              'Average',
              style: whiteTitleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isMobile(context) ? 12 : 20),
          _buildAverageItem(
            'Voltage',
            '${averageData['voltage']?.toStringAsFixed(2) ?? '--'} V',
          ),
          _buildAverageItem(
            'Current',
            '${averageData['current']?.toStringAsFixed(3) ?? '--'} A',
          ),
          _buildAverageItem(
            'Power',
            '${averageData['power']?.toStringAsFixed(1) ?? '--'} W',
          ),
          _buildAverageItem(
            'Power Factor',
            averageData['powerFactor']?.toStringAsFixed(2) ?? '--',
          ),
          _buildAverageItem(
            'Time',
            '${averageData['time']?.toStringAsFixed(2) ?? '--'} h',
          ),
          _buildAverageItem(
            'Energy',
            '${averageData['energy']?.toStringAsFixed(3) ?? '--'} kWh',
          ),
          _buildAverageItem(
            'Cost',
            'IDR ${NumberFormat('#,###').format(averageData['cost']?.round() ?? 0)}',
          ),
        ],
      ),
    );
  }

  Widget _buildAverageItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile(context) ? 4 : 8),
      child:
          isMobile(context)
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: blackLabelStyle),
                  Text(value, style: dataValueStyle),
                ],
              )
              : Row(
                children: [
                  Expanded(flex: 3, child: Text(label, style: blackLabelStyle)),
                  const Text(' = ', style: TextStyle(color: Colors.black)),
                  Expanded(flex: 2, child: Text(value, style: dataValueStyle)),
                ],
              ),
    );
  }

  Widget _buildInformationSection(Map<String, dynamic> systemInfo) {
    return Container(
      padding: EdgeInsets.all(isMobile(context) ? 12 : 20),
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: isMobile(context) ? 8 : 15),
            decoration: const BoxDecoration(
              color: Color(0xFF2AB0F2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              'Information',
              style: whiteTitleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isMobile(context) ? 12 : 20),
          _buildInfoItem(
            'Cost/Kwh',
            'IDR ${systemInfo['costPerKwh']?.toString() ?? '--'}',
          ),
          _buildInfoItem(
            'Number of Customer',
            systemInfo['numberOfSem']?.toString() ?? '--',
          ),
        ],
      ),
    );
  }

  Widget _buildSystemPerformanceSection(Map<String, dynamic> systemInfo) {
    final rssi = systemInfo['rssi'] ?? 0.0;
    final snr = systemInfo['snr'] ?? 0.0;

    return Container(
      padding: EdgeInsets.all(isMobile(context) ? 12 : 20),
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: isMobile(context) ? 8 : 15),
            decoration: const BoxDecoration(
              color: Color(0xFF2AB0F2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              'System Performance',
              style: whiteTitleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isMobile(context) ? 12 : 20),
          _buildInfoItem('RSSI', '${rssi.toStringAsFixed(0)} dBm'),
          _buildInfoItem('SNR', '${snr.toStringAsFixed(1)} dB'),
          _buildInfoItem(
            'Latency',
            '${systemInfo['latency']?.toStringAsFixed(1) ?? '--'} ms',
          ),
          _buildInfoItem(
            'Transmission Power',
            '${systemInfo['txPower']?.toStringAsFixed(0) ?? '--'} dBm',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile(context) ? 3 : 6),
      child:
          isMobile(context)
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: infoLabelStyle),
                  Text(value, style: dataValueStyle),
                ],
              )
              : Row(
                children: [
                  Expanded(flex: 3, child: Text(label, style: infoLabelStyle)),
                  const Text(' = ', style: TextStyle(color: Colors.black)),
                  Expanded(flex: 2, child: Text(value, style: dataValueStyle)),
                ],
              ),
    );
  }
}
