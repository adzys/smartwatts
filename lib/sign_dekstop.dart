import 'package:flutter/material.dart';
import 'auth_service.dart';

class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  String? _error;
  bool _isLoading = false;
  String _selectedRole = 'user'; // Default to user
  int _selectedCustomerId = 1; // Default customer ID

  Future<void> _signUp() async {
    if (_isLoading) return;

    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() {
        _error = 'Please fill in all fields.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (_selectedRole == 'admin') {
        await _authService.createAdminAccount(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
        );
      } else {
        await _authService.createUserAccount(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          customerId: _selectedCustomerId,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Navigator.pop(context); // Kembali ke halaman login
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Deteksi device type
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth < 1024;

    return Scaffold(
      backgroundColor: const Color(0xFF0A4C86),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: screenHeight,
          child:
              isMobile
                  ? _buildMobileLayout(screenWidth, screenHeight)
                  : Row(
                    children: [
                      buildLeftPanel(
                        screenWidth,
                        screenHeight,
                        isMobile,
                        isTablet,
                      ),
                      buildRightPanel(
                        screenWidth,
                        screenHeight,
                        isMobile,
                        isTablet,
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  // Layout khusus untuk mobile - Fixed overflow issue
  Widget _buildMobileLayout(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenHeight),
        child: IntrinsicHeight(
          child: Column(
            children: [
              // Header mobile dengan logo kecil - Made more compact
              Container(
                width: double.infinity,
                color: const Color(0xFF0A4C86),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Container(
                      width: screenWidth * 0.25, // Reduced from 0.3
                      height: screenWidth * 0.25, // Reduced from 0.3
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: const DecorationImage(
                          image: AssetImage('images/logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Reduced from 15
                    Text(
                      'SmartWatts',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05, // Reduced from 0.06
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5), // Reduced from 10
                    Text(
                      'Create your account',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // Reduced from 0.045
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Form section - Made more compact
              Expanded(
                child: Container(
                  color: const Color(0xFFFAFAFB),
                  padding: const EdgeInsets.all(20), // Reduced from 30
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInputLabel('Name', isMobile: true),
                      buildTextField(
                        _nameController,
                        'Enter your name',
                        isMobile: true,
                      ),
                      const SizedBox(height: 15), // Reduced spacing
                      buildInputLabel('E-mail', isMobile: true),
                      buildTextField(
                        _emailController,
                        'Enter your e-mail',
                        isMobile: true,
                      ),
                      const SizedBox(height: 15), // Reduced spacing
                      buildInputLabel('Password', isMobile: true),
                      buildTextField(
                        _passwordController,
                        'Enter your password',
                        obscureText: _obscurePassword,
                        toggleVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        isMobile: true,
                      ),
                      const SizedBox(height: 15), // Reduced spacing
                      _buildRoleSelection(isMobile: true),
                      const SizedBox(height: 20), // Reduced from 30
                      if (_error != null) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(25),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      const Spacer(), // Push button to bottom
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D8BDC),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ), // Reduced padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _isLoading ? null : _signUp,
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 16, // Reduced from 18
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLeftPanel(
    double screenWidth,
    double screenHeight,
    bool isMobile,
    bool isTablet,
  ) {
    return Expanded(
      flex: 1,
      child: Container(
        color: const Color(0xFF0A4C86),
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 30 : 50,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome To',
              style: TextStyle(
                fontSize: isTablet ? 40 : 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: isTablet ? 200 : 300,
              height: isTablet ? 200 : 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: AssetImage('images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'SmartWatts',
              style: TextStyle(
                fontSize: isTablet ? 24 : 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'SmartWatts is an electrical energy monitoring system website that helps monitor electrical energy consumption efficiently. With smart energy meter technology, SmartWatts allows users to monitor, electrical energy usage in real-time.',
              style: TextStyle(
                fontSize: isTablet ? 14 : 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRightPanel(
    double screenWidth,
    double screenHeight,
    bool isMobile,
    bool isTablet,
  ) {
    return Expanded(
      flex: 1,
      child: Container(
        color: const Color(0xFFFAFAFB),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight,
              maxWidth: isTablet ? 350 : 400,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 30,
                vertical: 40,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildInputLabel('Name', isTablet: isTablet),
                  buildTextField(
                    _nameController,
                    'Enter your name',
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 20),
                  buildInputLabel('E-mail', isTablet: isTablet),
                  buildTextField(
                    _emailController,
                    'Enter your e-mail',
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 20),
                  buildInputLabel('Password', isTablet: isTablet),
                  buildTextField(
                    _passwordController,
                    'Enter your password',
                    obscureText: _obscurePassword,
                    toggleVisibility: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 20),
                  _buildRoleSelection(isTablet: isTablet),
                  const SizedBox(height: 30),
                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(25),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D8BDC),
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 30 : 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _isLoading ? null : _signUp,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                              : Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: isTablet ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelection({bool isMobile = false, bool isTablet = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInputLabel('Account Type', isMobile: isMobile, isTablet: isTablet),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedRole,
          style: TextStyle(
            color: Colors.black,
            fontSize: isMobile ? 14 : (isTablet ? 14 : 16),
          ),
          dropdownColor: const Color(0xFFFAFAFB), // Sesuaikan dengan background
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'user', child: Text('User (Customer)')),
            DropdownMenuItem(value: 'admin', child: Text('Admin')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedRole = value!;
            });
          },
        ),
        if (_selectedRole == 'user') ...[
          const SizedBox(height: 15), // Reduced spacing for mobile
          buildInputLabel(
            'Customer ID',
            isMobile: isMobile,
            isTablet: isTablet,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: _selectedCustomerId,
            style: TextStyle(
              color: Colors.black,
              fontSize: isMobile ? 14 : (isTablet ? 14 : 16),
            ),
            dropdownColor: const Color(0xFFFAFAFB),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            items: List.generate(4, (index) {
              return DropdownMenuItem(
                value: index + 1,
                child: Text('Customer ${index + 1}'),
              );
            }),
            onChanged: (value) {
              setState(() {
                _selectedCustomerId = value!;
              });
            },
          ),
        ],
      ],
    );
  }

  Widget buildInputLabel(
    String label, {
    bool isMobile = false,
    bool isTablet = false,
  }) {
    return Text(
      label,
      style: TextStyle(
        fontSize:
            isMobile ? 14 : (isTablet ? 16 : 18), // Reduced mobile font size
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String hint, {
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    bool isMobile = false,
    bool isTablet = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: Colors.black,
        fontSize:
            isMobile ? 13 : (isTablet ? 14 : 16), // Reduced mobile font size
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize:
              isMobile ? 13 : (isTablet ? 14 : 16), // Reduced mobile font size
        ),
        suffixIcon:
            toggleVisibility != null
                ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                    size: isMobile ? 18 : 24, // Reduced mobile icon size
                  ),
                  onPressed: toggleVisibility,
                )
                : null,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }
}
