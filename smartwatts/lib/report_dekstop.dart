import 'package:flutter/material.dart';

class SmartWattsApp extends StatelessWidget {
  const SmartWattsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(body: ReportPage()),
    );
  }
}

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF006FBD),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenSize.height),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 1080,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Positioned(
                      left: 318,
                      top: 91,
                      child: Container(
                        width: 715,
                        height: 65,
                        decoration: ShapeDecoration(
                          color: const Color(0xAA099FEA),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 627,
                      top: 106,
                      child: Text(
                        'Report',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 116,
                      top: 220,
                      child: Container(
                        width: 555,
                        height: 713,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFB),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 245,
                      top: 630,
                      child: SizedBox(
                        width: 187,
                        height: 44,
                        child: Text(
                          'Faktor Daya',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 245,
                      top: 330,
                      child: SizedBox(
                        width: 160,
                        height: 48,
                        child: Text(
                          'Tegangan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 512,
                      top: 330,
                      child: SizedBox(
                        width: 94,
                        height: 48,
                        child: Text(
                          '... volt',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 512,
                      top: 530,
                      child: SizedBox(
                        width: 68,
                        height: 48,
                        child: Text(
                          '... W',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 512,
                      top: 830,
                      child: SizedBox(
                        width: 105,
                        height: 48,
                        child: Text(
                          '... kWh',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 512,
                      top: 630,
                      child: SizedBox(
                        width: 30,
                        height: 48,
                        child: Text(
                          '... ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 512,
                      top: 430,
                      child: SizedBox(
                        width: 65,
                        height: 48,
                        child: Text(
                          '... A',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 464,
                      top: 330,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 467,
                      top: 630,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 464,
                      top: 530,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 464,
                      top: 430,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 245,
                      top: 530,
                      child: SizedBox(
                        width: 87,
                        height: 44,
                        child: Text(
                          'Daya',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 245,
                      top: 430,
                      child: SizedBox(
                        width: 80,
                        height: 38,
                        child: Text(
                          'Arus',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 681,
                      top: 220,
                      child: Container(
                        width: 555,
                        height: 220,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFB),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 116,
                      top: 219,
                      child: Container(
                        width: 555,
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2AB0F2),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 326,
                      top: 227,
                      child: Text(
                        'Rata-rata',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 681,
                      top: 220,
                      child: Container(
                        width: 555,
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2AB0F2),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 892,
                      top: 230,
                      child: Text(
                        'Informasi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 681,
                      top: 448,
                      child: Container(
                        width: 555,
                        height: 485,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFB),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 681,
                      top: 448,
                      child: Container(
                        width: 555,
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2AB0F2),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 841,
                      top: 458,
                      child: Text(
                        'Performa sistem',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 694,
                      top: 530,
                      child: SizedBox(
                        width: 374,
                        child: Text(
                          'Received Signal Strengt Indicator (RSSI)',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 694,
                      top: 290,
                      child: Text(
                        'Biaya/Kwh',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 694,
                      top: 390,
                      child: Text(
                        'Estimasi Biaya Perbulan (IDR)',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 693,
                      top: 705,
                      child: Text(
                        'Latensi',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 694,
                      top: 340,
                      child: Text(
                        'Jumlah SEM',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 693,
                      top: 635,
                      child: Text(
                        'Noise Signal',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 693,
                      top: 775,
                      child: Text(
                        'Transmission Power',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 694,
                      top: 845,
                      child: Text(
                        'Signal-to-Noise Ration \n(SNR)',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 1068,
                      top: 285,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 1068,
                      top: 335,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 1068,
                      top: 385,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 1068,
                      top: 545,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 1068,
                      top: 630,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 1068,
                      top: 700,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 1068,
                      top: 770,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 1068,
                      top: 840,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 512,
                      top: 730,
                      child: SizedBox(
                        width: 33,
                        height: 48,
                        child: Text(
                          '... ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 467,
                      top: 730,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 245,
                      top: 730,
                      child: SizedBox(
                        width: 101,
                        height: 48,
                        child: Text(
                          'Waktu ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 467,
                      top: 830,
                      child: SizedBox(
                        width: 39,
                        height: 38,
                        child: Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 245,
                      top: 830,
                      child: SizedBox(
                        width: 201,
                        height: 43,
                        child: Text(
                          'Energi Listrik',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 150,
                      top: 310,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/tegangan.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 150,
                      top: 410,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/arus.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 150,
                      top: 610,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/faktor_daya.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 150,
                      top: 510,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/daya.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 150,
                      top: 710,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/waktu.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 150,
                      top: 810,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/energi.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
