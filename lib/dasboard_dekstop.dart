import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

import 'package:smartwatts/sem_dekstop.dart';
import 'package:smartwatts/report_dekstop.dart';
import 'package:smartwatts/login_dekstop.dart';
import 'package:smartwatts/chart_dekstop.dart';

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
        '/': (context) => const DashboardPage(),
        '/sem': (context) => const SemPage(),
        '/report': (context) => const ReportPage(),
        '/login': (context) => const LoginPage(),
        '/Chart': (context) => const ChartPage(),
      },
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLoggingOut = false;

  // Helper method untuk menentukan ukuran perangkat
  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > 1024;
  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > 600 &&
      MediaQuery.of(context).size.width <= 1024;
  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Logout Confirmation',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.black87, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );

      developer.log('Logout failed: $e', name: 'Dashboard');
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.all(isMobile(context) ? 8 : 16),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile(context) ? 12 : 16,
        vertical: isMobile(context) ? 10 : 12,
      ),
      decoration: ShapeDecoration(
        color: const Color(0xAA099FEA),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color.fromARGB(255, 20, 20, 20),
          ),
          borderRadius: BorderRadius.circular(isMobile(context) ? 12 : 22),
        ),
      ),
      child: Row(
        children: [
          // Logo dan nama
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: isMobile(context) ? 45 : 60,
                  height: isMobile(context) ? 45 : 60,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/logo.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: isMobile(context) ? 10 : 12),
                Flexible(
                  child: Text(
                    'SmartWatts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile(context) ? 12 : 28,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Navigation menu
          Expanded(
            flex: 3,
            child:
                isMobile(context)
                    ? Align(
                      alignment: Alignment.centerRight,
                      child: _buildMobileMenu(),
                    )
                    : _buildDesktopMenu(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildNavButton('Chart', '/Chart'),
        _buildNavButton('Report', '/report'),
        _buildNavButton('SEM', '/sem'),
        _buildLogoutButton(),
      ],
    );
  }

  Widget _buildMobileMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu, color: Colors.white, size: 26),
      onSelected: (value) {
        if (value == 'logout') {
          _showLogoutDialog();
        } else {
          Navigator.pushNamed(context, value);
        }
      },
      itemBuilder:
          (BuildContext context) => [
            const PopupMenuItem(value: '/Chart', child: Text('Chart')),
            const PopupMenuItem(value: '/report', child: Text('Report')),
            const PopupMenuItem(value: '/sem', child: Text('SEM')),
            const PopupMenuItem(value: 'logout', child: Text('Logout')),
          ],
    );
  }

  Widget _buildNavButton(String text, String route) {
    return InkWell(
      onTap: () {
        developer.log('$text button tapped', name: 'Dashboard');
        Navigator.pushNamed(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: isDesktop(context) ? 24 : 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: _isLoggingOut ? null : _showLogoutDialog,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
        child: Text(
          'Logout',
          style: TextStyle(
            color: _isLoggingOut ? Colors.white.withAlpha(128) : Colors.white,
            fontSize: isDesktop(context) ? 24 : 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (isMobile(context)) {
      return _buildMobileContent();
    } else {
      return _buildDesktopContent();
    }
  }

  Widget _buildMobileContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Main title
          Text(
            'TO MONITOR\nYOUR ENERGY',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 1.1,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 30),

          // Logo image
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.width * 0.65,
            decoration: ShapeDecoration(
              image: const DecorationImage(
                image: AssetImage("images/logo.png"),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Description
          Text(
            'SmartWatts is an electrical energy monitoring system website that helps monitor electrical energy consumption efficiently. With smart energy meter technology, SmartWatts allows users to monitor electrical energy usage in real-time.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.5,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopContent() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop(context) ? 40 : 30,
        vertical: 15,
      ),
      child: Row(
        children: [
          // Left side - text content
          Expanded(
            flex: isDesktop(context) ? 2 : 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TO MONITOR\nYOUR ENERGY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop(context) ? 72 : 48,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                    letterSpacing: 1.0,
                  ),
                ),

                const SizedBox(height: 25),

                Text(
                  'SmartWatts is an electrical energy monitoring system website that helps monitor electrical energy consumption efficiently. With smart energy meter technology, SmartWatts allows users to monitor electrical energy usage in real-time.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop(context) ? 28 : 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 30),

          // Right side - logo
          Expanded(
            flex: isDesktop(context) ? 3 : 2,
            child: Container(
              constraints: BoxConstraints(maxWidth: 450, maxHeight: 450),
              decoration: ShapeDecoration(
                image: const DecorationImage(
                  image: AssetImage("images/logo.png"),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006FBD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(
                height:
                    MediaQuery.of(context).size.height -
                    (isMobile(context) ? 140 : 120),
                child: _buildMainContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
