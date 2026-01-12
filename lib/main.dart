import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'auth_service.dart';

import 'package:smartwatts/login_dekstop.dart';
import 'package:smartwatts/sign_dekstop.dart';
import 'package:smartwatts/forgot_dekstop.dart';
import 'package:smartwatts/dasboard_dekstop.dart';
import 'package:smartwatts/user_dashboard.dart';
import 'package:smartwatts/sem_dekstop.dart';
import 'package:smartwatts/report_dekstop.dart';
import 'package:smartwatts/chart_dekstop.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const Sign(),
        '/forgot': (context) => const ForgotPasswordPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/user_dashboard': (context) => const UserDashboard(),
        '/sem': (context) => const SemPage(),
        '/report': (context) => const ReportPage(),
        '/logout': (context) => const LogoutHandler(),
        '/Chart': (context) => const ChartPage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            return const RoleBasedRouter();
          } else {
            return const MainHome();
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class RoleBasedRouter extends StatefulWidget {
  const RoleBasedRouter({super.key});

  @override
  State<RoleBasedRouter> createState() => _RoleBasedRouterState();
}

class _RoleBasedRouterState extends State<RoleBasedRouter> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    try {
      final userData = await _authService.getUserData();
      if (mounted) {
        setState(() {
          _userRole = userData?['role'] ?? 'user';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _userRole = 'user'; // Default to user if error
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_userRole == 'admin') {
      return const DashboardPage();
    } else {
      return const UserDashboard();
    }
  }
}

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    // Deteksi device type
    bool isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0A4C86),
      body: SafeArea(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child:
              isMobile
                  ? _buildMobileLayout(context, screenWidth, screenHeight)
                  : Stack(
                    children: [
                      // Logo - Responsive positioning untuk desktop
                      Positioned(
                        left: screenWidth > 1200 ? 800 : screenWidth * 0.55,
                        top: screenHeight * 0.25,
                        child: Container(
                          width: screenWidth > 1200 ? 300 : screenWidth * 0.25,
                          height: screenWidth > 1200 ? 300 : screenWidth * 0.25,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/logo_smartwatts.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // Title "SmartWatts"
                      Positioned(
                        left: 50,
                        top: screenHeight * 0.24,
                        child: Text(
                          'SmartWatts',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                screenWidth > 1200 ? 40 : screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),

                      // Subtitle
                      Positioned(
                        left: 50,
                        top: screenHeight * 0.32,
                        child: Text(
                          'TO MONITOR\nYOUR ENERGY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                screenWidth > 1200 ? 70 : screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'League Spartan',
                            height: 1.1,
                          ),
                        ),
                      ),

                      // Login Button
                      Positioned(
                        left: 50,
                        bottom: screenHeight * 0.15,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            width: screenWidth > 1200 ? 250 : screenWidth * 0.2,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    color: const Color(0xFF13072E),
                                    fontSize:
                                        screenWidth > 1200
                                            ? 24
                                            : screenWidth * 0.02,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Color(0xFF3DD9D6),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Sign Up Button
                      Positioned(
                        right: 40,
                        top: 30,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
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
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    screenWidth > 1200
                                        ? 18
                                        : screenWidth * 0.016,
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

  // Layout khusus untuk mobile
  Widget _buildMobileLayout(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Sign Up Button di atas
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Logo di tengah
          Container(
            width: screenWidth * 0.5,
            height: screenWidth * 0.5,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/logo_smartwatts.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Title
          Text(
            'SmartWatts',
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.08,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Subtitle
          Text(
            'TO MONITOR\nYOUR ENERGY',
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.1,
              fontWeight: FontWeight.bold,
              fontFamily: 'League Spartan',
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          // Login Button di bawah
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: screenWidth * 0.8,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Color(0xFF13072E),
                      fontSize: 20,
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

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class LogoutHandler extends StatefulWidget {
  const LogoutHandler({super.key});

  @override
  State<LogoutHandler> createState() => _LogoutHandlerState();
}

class _LogoutHandlerState extends State<LogoutHandler> {
  @override
  void initState() {
    super.initState();

    // Jalankan logout setelah build selesai
    Future.microtask(() async {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainHome()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
