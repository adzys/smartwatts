import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'auth_service.dart';
import 'package:smartwatts/user_chart_page.dart';
import 'package:smartwatts/user_sem_page.dart';
import 'package:smartwatts/login_dekstop.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  bool _isLoggingOut = false;
  final AuthService _authService = AuthService();
  String _userName = '';
  int? _customerId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _authService.getUserData();
      if (userData != null && mounted) {
        setState(() {
          _userName = userData['name'] ?? 'User';
          _customerId = userData['customerId'];
        });
      }
    } catch (e) {
      developer.log('Error loading user data: $e');
    }
  }

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
      await _authService.signOut();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );

      developer.log('Logout failed: $e', name: 'UserDashboard');
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
                Text(
                  'SmartWatts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile(context) ? 12 : 28,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
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
        _buildNavButton('Chart', () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserChartPage(customerId: _customerId ?? 1),
            ),
          );
        }),
        _buildNavButton('SEM', () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserSemPage(customerId: _customerId ?? 1),
            ),
          );
        }),
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
        } else if (value == 'chart') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserChartPage(customerId: _customerId ?? 1),
            ),
          );
        } else if (value == 'sem') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserSemPage(customerId: _customerId ?? 1),
            ),
          );
        }
      },
      itemBuilder:
          (BuildContext context) => [
            const PopupMenuItem(value: 'chart', child: Text('Chart')),
            const PopupMenuItem(value: 'sem', child: Text('SEM')),
            const PopupMenuItem(value: 'logout', child: Text('Logout')),
          ],
    );
  }

  Widget _buildNavButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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

          // Welcome message
          Text(
            'Welcome, $_userName!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.1,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 50),

          // Dashboard title
          const Text(
            'Energy Monitoring Dashboard',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
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
          const Text(
            'Easily monitor your energy consumption and find complete reports on your electricity usage.',
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
                  'Welcome, $_userName!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop(context) ? 48 : 36,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                    letterSpacing: 1.0,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Monitor your energy consumption and view detailed reports of your electrical usage. Access your personalized dashboard with real-time data and analytics.',
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
              constraints: const BoxConstraints(maxWidth: 450, maxHeight: 450),
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
