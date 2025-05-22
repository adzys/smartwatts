import 'package:flutter/material.dart';
import 'package:smartwatts/sem_dekstop.dart';
import 'package:smartwatts/report_dekstop.dart';
import 'package:smartwatts/login_dekstop.dart';

void main() {
  runApp(const SmartWattsApp());
}

class SmartWattsApp extends StatelessWidget {
  const SmartWattsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DasboardPage(),
        '/sem': (context) => const SemPage(),
        '/report': (context) => const ReportPage(),
        '/logout': (context) => const LoginPage(),
      },
    );
  }
}

class DasboardPage extends StatelessWidget {
  const DasboardPage({super.key});

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
                width: 1440,
                height: 1024,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(color: Color(0xFF006FBD)),
                child: Stack(
                  children: [
                    Positioned(
                      left: 95,
                      top: 88,
                      child: Container(
                        width: 1200,
                        height: 65,
                        decoration: ShapeDecoration(
                          color: const Color(0xAA099FEA),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 20, 20, 20),
                            ),
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 77,
                      top: 82.13,
                      child: Container(
                        width: 139,
                        height: 78,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/logo.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 216,
                      top: 103.13,
                      child: Text(
                        'SmartWatts',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    //Navigasi Ke SEM
                    Positioned(
                      left: 1004,
                      top: 103.13,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/sem');
                        },
                        child: const Text(
                          'SEM',
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

                    //Navigasi Ke Logout
                    Positioned(
                      left: 1122,
                      top: 103.13,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Logout',
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

                    //Navigasi Ke report
                    Positioned(
                      left: 854,
                      top: 103.13,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/report');
                        },
                        child: const Text(
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
                    ),

                    Positioned(
                      left: 535,
                      top: 249.13,
                      child: Container(
                        width: 1067,
                        height: 600,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage("images/logo.png"),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(122),
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 101,
                      top: 283.13,
                      child: SizedBox(
                        width: 753,
                        height: 232,
                        child: Text(
                          'TO MONITOR \nYOUR ENERGY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 80,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 114,
                      top: 515.13,
                      child: SizedBox(
                        width: 707,
                        child: Text(
                          'SmartWatts is an electrical energy monitoring system website that helps monitor electrical energy consumption efficiently. With smart energy meter technology, SmartWatts allows users to monitor, electrical energy usage in real-time.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 1142,
                      top: 81.13,
                      child: Container(
                        width: 100,
                        height: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
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
