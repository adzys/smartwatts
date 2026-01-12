import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserSemPage extends StatefulWidget {
  final int customerId;

  const UserSemPage({super.key, required this.customerId});

  @override
  State<UserSemPage> createState() => _UserSemPageState();
}

class _UserSemPageState extends State<UserSemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006FBD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF006FBD),
        title: const Text(
          'Smart Energy Meter',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildCustomerCard(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: ShapeDecoration(
        color: const Color(0xAA099FEA),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      child: const Center(
        child: Text(
          'Smart Energy Meter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Check if screen width is mobile size
          final isMobile = constraints.maxWidth < 600;

          return CustomerCard(
            customerId: widget.customerId,
            customerName: 'Energy Monitor',
            isMobile: isMobile,
          );
        },
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  final int customerId;
  final String customerName;
  final bool isMobile;

  const CustomerCard({
    super.key,
    required this.customerId,
    required this.customerName,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
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
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF2AB0F2),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(
              customerName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildStartDate(),
          const SizedBox(height: 15),
          _buildMeasurementsGrid(),
        ],
      ),
    );
  }

  Widget _buildStartDate() {
    return Row(
      children: [
        const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
        const SizedBox(width: 8),
        const Text(
          'Start Date: ',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: StreamBuilder<DatabaseEvent>(
            stream:
                FirebaseDatabase.instance
                    .ref(
                      'pelanggan/$customerId/monitoring/tanggal_mulai_penggunaan',
                    )
                    .onValue,
            builder: (context, snapshot) {
              return _buildDataDisplay(
                snapshot: snapshot,
                defaultText: '--/--/----',
                unit: '',
                fontSize: 14,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementsGrid() {
    if (isMobile) {
      // Mobile layout: 2 columns instead of 3x2 grid
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildVoltageCard()),
              const SizedBox(width: 15),
              Expanded(child: _buildPowerFactorCard()),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildCurrentCard()),
              const SizedBox(width: 15),
              Expanded(child: _buildUsageTimeCard()),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildPowerCard()),
              const SizedBox(width: 15),
              Expanded(child: _buildEnergyCard()),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildCostCard()),
              const SizedBox(width: 15),
              Expanded(child: Container()), // Empty space for balance
            ],
          ),
        ],
      );
    } else {
      // Desktop layout: original 2x2 + 2x1 grid
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildVoltageCard()),
              const SizedBox(width: 15),
              Expanded(child: _buildPowerFactorCard()),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildCurrentCard()),
              const SizedBox(width: 15),
              Expanded(child: _buildUsageTimeCard()),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildPowerCard()),
              const SizedBox(width: 15),
              Expanded(child: _buildEnergyCard()),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildCostCard()),
              const SizedBox(width: 15),
              Expanded(child: Container()), // Empty space for balance
            ],
          ),
        ],
      );
    }
  }

  Widget _buildVoltageCard() {
    return _buildMeasurementCard(
      icon: Icons.electric_bolt,
      title: 'Voltage',
      stream:
          FirebaseDatabase.instance
              .ref('pelanggan/$customerId/monitoring/tegangan')
              .onValue,
      unit: 'V',
    );
  }

  Widget _buildPowerFactorCard() {
    return _buildMeasurementCard(
      icon: Icons.power,
      title: 'Power Factor',
      stream:
          FirebaseDatabase.instance
              .ref('pelanggan/$customerId/monitoring/faktor_daya')
              .onValue,
      unit: '',
    );
  }

  Widget _buildCurrentCard() {
    return _buildMeasurementCard(
      icon: Icons.electrical_services,
      title: 'Current',
      stream:
          FirebaseDatabase.instance
              .ref('pelanggan/$customerId/monitoring/arus')
              .onValue,
      unit: 'A',
    );
  }

  Widget _buildUsageTimeCard() {
    return _buildMeasurementCard(
      icon: Icons.access_time,
      title: 'Usage Time',
      stream:
          FirebaseDatabase.instance
              .ref('pelanggan/$customerId/monitoring/durasi_penggunaan_jam')
              .onValue,
      unit: 'h',
    );
  }

  Widget _buildPowerCard() {
    return _buildMeasurementCard(
      icon: Icons.power_settings_new,
      title: 'Power',
      stream:
          FirebaseDatabase.instance
              .ref('pelanggan/$customerId/monitoring/daya')
              .onValue,
      unit: 'W',
    );
  }

  Widget _buildEnergyCard() {
    return _buildMeasurementCard(
      icon: Icons.battery_charging_full,
      title: 'Energy',
      stream:
          FirebaseDatabase.instance
              .ref('pelanggan/$customerId/monitoring/calculated_energy')
              .onValue,
      unit: 'kWh',
    );
  }

  Widget _buildCostCard() {
    return _buildMeasurementCard(
      icon: Icons.attach_money,
      title: 'Cost',
      stream:
          FirebaseDatabase.instance
              .ref('pelanggan/$customerId/monitoring/tagihan_estimasi')
              .onValue,
      unit: 'IDR',
      unitPrefix: true,
    );
  }

  Widget _buildMeasurementCard({
    required IconData icon,
    required String title,
    required Stream<DatabaseEvent> stream,
    required String unit,
    bool unitPrefix = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF006FBD), size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          StreamBuilder<DatabaseEvent>(
            stream: stream,
            builder: (context, snapshot) {
              return _buildDataDisplay(
                snapshot: snapshot,
                unit: unit,
                unitPrefix: unitPrefix,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataDisplay({
    required AsyncSnapshot<DatabaseEvent> snapshot,
    required String unit,
    String defaultText = '--',
    bool unitPrefix = false,
    double fontSize = 16,
  }) {
    if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
      final value = snapshot.data!.snapshot.value.toString();
      final displayText = unitPrefix ? '$unit $value' : '$value $unit';

      return Text(
        displayText.trim(),
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (snapshot.hasError) {
      return Text(
        'Error',
        style: TextStyle(color: Colors.red, fontSize: fontSize),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006FBD)),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          defaultText,
          style: TextStyle(color: Colors.grey, fontSize: fontSize),
        ),
      ],
    );
  }
}
