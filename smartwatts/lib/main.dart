import 'package:flutter/material.dart';
import 'package:smartwatts/login_dekstop.dart';
import 'package:smartwatts/sign_dekstop.dart';
import 'package:smartwatts/forgot_dekstop.dart';
import 'package:smartwatts/dasboard_dekstop.dart';
import 'package:smartwatts/sem_dekstop.dart';
import 'package:smartwatts/report_dekstop.dart';

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
        scaffoldBackgroundColor: const Color(0xFF0F5081),
      ),
      home: const MainHome(),
      routes: {
        '/Login': (_) => const LoginPage(),
        '/Sign Up': (_) => const Sign(),
        '/forgot': (_) => const ForgotPasswordPage(),
        '/login': (context) => const DasboardPage(),
        '/sem': (context) => const SemPage(),
        '/report': (context) => const ReportPage(),
        '/logout': (context) => const LoginPage(),
      },
    );
  }
}

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0A4C86),
      body: SafeArea(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            children: [
              // Logo
              Positioned(
                left: screenWidth * 0.35,
                top: screenHeight * 0.1,
                child: Image.asset(
                  'Images/logo.png',
                  width: screenWidth * 0.7,
                  fit: BoxFit.contain,
                ),
              ),

              // Judul SmartWatts
              Positioned(
                left: screenWidth * 0.05,
                top: screenHeight * 0.3,
                child: const Text(
                  'SmartWatts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),

              // Subtitle
              Positioned(
                left: screenWidth * 0.05,
                top: screenHeight * 0.4,
                child: const Text(
                  'TO MONITOR\nYOUR ENERGY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 81,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'League Spartan',
                    height: 1.2,
                  ),
                ),
              ),

              // Tombol Login
              Positioned(
                left: screenWidth * 0.05,
                bottom: screenHeight * 0.2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/Login');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: 250,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFF13072E),
                            fontSize: 24,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF3DD9D6),
                          child: Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Tombol Sign Up di pojok kanan atas
              // Tombol Sign Up di pojok kanan atas
              Positioned(
                right: 40,
                top: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/Sign Up');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
