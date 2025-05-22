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
      home: Scaffold(body: SemPage()),
    );
  }
}

class SemPage extends StatelessWidget {
  const SemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const Scaffold(body: Sem()),
    );
  }
}

class Sem extends StatelessWidget {
  const Sem({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenSize.height),
          child: Container(
            width: double.infinity,
            height: 1080,
            color: const Color(0xFF006FBD),
            child: Stack(
              children: [
                Positioned(
                  left: 318,
                  top: 69,
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
                  left: 531,
                  top: 84,
                  child: Text(
                    'Smart Energy Meter',
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
                  left: 378.93,
                  top: 227.67,
                  child: Container(
                    width: 297.02,
                    height: 307.72,
                    decoration: BoxDecoration(color: const Color(0xFFFAFAFB)),
                  ),
                ),
                Positioned(
                  left: 81.91,
                  top: 227.67,
                  child: Container(
                    width: 297.02,
                    height: 307.72,
                    decoration: BoxDecoration(color: const Color(0xFFFAFAFB)),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 161,
                  child: Container(
                    width: 208.07,
                    height: 54.62,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 81.91,
                  top: 188.35,
                  child: Container(
                    width: 594.05,
                    height: 47.01,
                    decoration: BoxDecoration(color: const Color(0xFF2AB0F2)),
                  ),
                ),
                Positioned(
                  left: 264,
                  top: 190,
                  child: SizedBox(
                    width: 209,
                    height: 45,
                    child: Text(
                      'No. Pelanggan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 395.13,
                  top: 161,
                  child: Container(
                    width: 208.07,
                    height: 54.62,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 104.41,
                  top: 256.73,
                  child: Container(
                    width: 72.01,
                    height: 68.38,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Stack(),
                  ),
                ),
                Positioned(
                  left: 410,
                  top: 260,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/faktor_daya.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 110,
                  top: 350,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/daya.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 110,
                  top: 260,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/tegangan.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 1030,
                  top: 620,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/tegangan.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 110,
                  top: 450,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/arus.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 369.03,
                  top: 535.39,
                  child: Container(
                    width: 208.07,
                    height: 54.62,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 195.32,
                  top: 277.25,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 195.32,
                  top: 371.27,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 195.32,
                  top: 465.30,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 493.24,
                  top: 277.25,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 493.24,
                  top: 371.27,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 493.24,
                  top: 465.30,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 410,
                  top: 450,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("Images/biaya.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 110,
                  top: 720,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/tegangan.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 999.93,
                  top: 592.67,
                  child: Container(
                    width: 297.02,
                    height: 307.72,
                    decoration: BoxDecoration(color: const Color(0xFFFAFAFB)),
                  ),
                ),
                Positioned(
                  left: 702.91,
                  top: 592.67,
                  child: Container(
                    width: 297.02,
                    height: 307.72,
                    decoration: BoxDecoration(color: const Color(0xFFFAFAFB)),
                  ),
                ),
                Positioned(
                  left: 702.91,
                  top: 592.67,
                  child: Container(
                    width: 297.02,
                    height: 307.72,
                    decoration: BoxDecoration(color: const Color(0xFFFAFAFB)),
                  ),
                ),
                Positioned(
                  left: 621,
                  top: 526,
                  child: Container(
                    width: 208.07,
                    height: 54.62,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 702.91,
                  top: 553.35,
                  child: Container(
                    width: 594.05,
                    height: 47.01,
                    decoration: BoxDecoration(color: const Color(0xFF2AB0F2)),
                  ),
                ),
                Positioned(
                  left: 885,
                  top: 555,
                  child: SizedBox(
                    width: 209,
                    height: 45,
                    child: Text(
                      'No. Pelanggan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 1016.13,
                  top: 526,
                  child: Container(
                    width: 208.07,
                    height: 54.62,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 725.41,
                  top: 621.73,
                  child: Container(
                    width: 72.01,
                    height: 68.38,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Stack(),
                  ),
                ),
                Positioned(
                  left: 1030,
                  top: 620,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/faktor_daya.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 110,
                  top: 620,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/faktor_daya.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 730,
                  top: 720,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/daya.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 730,
                  top: 820,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/arus.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 730,
                  top: 620,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/tegangan.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 990.03,
                  top: 900.39,
                  child: Container(
                    width: 208.07,
                    height: 54.62,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 816.32,
                  top: 642.25,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 816.32,
                  top: 736.27,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 816.32,
                  top: 830.30,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 1114.24,
                  top: 642.25,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 1114.24,
                  top: 736.27,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 1114.24,
                  top: 830.30,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 1030,
                  top: 820,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("Images/biaya.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 378.93,
                  top: 592.67,
                  child: Container(
                    width: 297.02,
                    height: 307.72,
                    decoration: BoxDecoration(color: const Color(0xFFFAFAFB)),
                  ),
                ),
                Positioned(
                  left: 81.91,
                  top: 592.67,
                  child: Container(
                    width: 297.02,
                    height: 307.72,
                    decoration: BoxDecoration(color: const Color(0xFFFAFAFB)),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 526,
                  child: Container(
                    width: 208.07,
                    height: 54.62,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 81.91,
                  top: 553.35,
                  child: Container(
                    width: 594.05,
                    height: 47.01,
                    decoration: BoxDecoration(color: const Color(0xFF2AB0F2)),
                  ),
                ),
                Positioned(
                  left: 264,
                  top: 555,
                  child: SizedBox(
                    width: 209,
                    height: 45,
                    child: Text(
                      'No. Pelanggan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 395.13,
                  top: 526,
                  child: Container(
                    width: 208.07,
                    height: 54.62,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 104.41,
                  top: 621.73,
                  child: Container(
                    width: 72.01,
                    height: 68.38,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Stack(),
                  ),
                ),
                Positioned(
                  left: 410,
                  top: 620,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/faktor_daya.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 410,
                  top: 720,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/waktu.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 1030,
                  top: 720,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/waktu.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 110,
                  top: 820,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/arus.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 110,
                  top: 620,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/tegangan.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 110,
                  top: 720,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/daya.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 369.03,
                  top: 900.39,
                  child: Container(
                    width: 208.07,
                    height: 54.62,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 195.32,
                  top: 642.25,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 195.32,
                  top: 736.27,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 195.32,
                  top: 830.30,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 493.24,
                  top: 642.25,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 493.24,
                  top: 736.27,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 493.24,
                  top: 830.30,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 410,
                  top: 820,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/biaya.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 999.93,
                  top: 227.67,
                  child: Container(
                    width: 297.02,
                    height: 307.72,
                    decoration: BoxDecoration(color: const Color(0xFFFAFAFB)),
                  ),
                ),
                Positioned(
                  left: 702.91,
                  top: 227.67,
                  child: Container(
                    width: 297.02,
                    height: 307.72,
                    decoration: BoxDecoration(color: const Color(0xFFFAFAFB)),
                  ),
                ),
                Positioned(
                  left: 621,
                  top: 161,
                  child: Container(
                    width: 208.07,
                    height: 54.62,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 702.91,
                  top: 188.35,
                  child: Container(
                    width: 594.05,
                    height: 47.01,
                    decoration: BoxDecoration(color: const Color(0xFF2AB0F2)),
                  ),
                ),
                Positioned(
                  left: 885,
                  top: 190,
                  child: SizedBox(
                    width: 209,
                    height: 45,
                    child: Text(
                      'No. Pelanggan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 1016.13,
                  top: 161,
                  child: Container(
                    width: 208.07,
                    height: 54.62,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 725.41,
                  top: 256.73,
                  child: Container(
                    width: 72.01,
                    height: 68.38,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Stack(),
                  ),
                ),
                Positioned(
                  left: 1030,
                  top: 260,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/faktor_daya.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 730,
                  top: 360,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/daya.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 730,
                  top: 450,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/arus.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 730,
                  top: 260,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/tegangan.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 990.03,
                  top: 535.39,
                  child: Container(
                    width: 208.07,
                    height: 54.62,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 816.32,
                  top: 277.25,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 816.32,
                  top: 371.27,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 816.32,
                  top: 465.30,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 1114.24,
                  top: 277.25,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 1114.24,
                  top: 371.27,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 1114.24,
                  top: 465.30,
                  child: SizedBox(
                    width: 35.10,
                    height: 32.48,
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
                  left: 1030,
                  top: 450,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/biaya.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 1030,
                  top: 350,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/waktu.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 410,
                  top: 350,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/waktu.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
