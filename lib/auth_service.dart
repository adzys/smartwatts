import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Create admin account
  Future<User?> createAdminAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        // Save admin data to database
        await _database.ref('users/${user.uid}').set({
          'name': name,
          'email': email,
          'role': 'admin',
          'createdAt': ServerValue.timestamp,
        });
      }

      return user;
    } catch (e) {
      throw Exception('Account creation failed: ${e.toString()}');
    }
  }

  // Create user account with custom customer name
  Future<User?> createUserAccount({
    required String email,
    required String password,
    required String name,
    required int customerId,
    String? customerName, // Optional custom customer name
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        // Determine the customer display name
        String displayName =
            customerName?.trim().isNotEmpty == true
                ? customerName!.trim()
                : 'Customer $customerId';

        // Save user data to database
        await _database.ref('users/${user.uid}').set({
          'name': name,
          'email': email,
          'role': 'user',
          'customerId': customerId,
          'customerName': displayName,
          'createdAt': ServerValue.timestamp,
        });

        // Also save/update the customer name in the pelanggan node
        // This ensures the name is available even if no user is logged in
        await _database.ref('pelanggan/$customerId').update({
          'customer_name': displayName,
          'last_updated': ServerValue.timestamp,
        });

        // Initialize monitoring data structure if it doesn't exist
        await _initializeCustomerMonitoring(customerId);
      }

      return user;
    } catch (e) {
      throw Exception('Account creation failed: ${e.toString()}');
    }
  }

  // Initialize customer monitoring data structure
  Future<void> _initializeCustomerMonitoring(int customerId) async {
    try {
      DatabaseReference customerRef = _database.ref(
        'pelanggan/$customerId/monitoring',
      );

      // Check if monitoring data already exists
      DataSnapshot snapshot = await customerRef.get();

      if (!snapshot.exists) {
        // Initialize with default values
        await customerRef.set({
          'tegangan': 0.0,
          'arus': 0.0,
          'daya': 0.0,
          'faktor_daya': 0.0,
          'calculated_energy': 0.0,
          'durasi_penggunaan_jam': 0.0,
          'tagihan_estimasi': 0.0,
          'tanggal_mulai_penggunaan': '--/--/----',
          'last_updated': ServerValue.timestamp,
        });
      }
    } catch (e) {
      ('Error initializing customer monitoring: $e');
      // Don't throw error here to avoid breaking account creation
    }
  }

  // Get user data including role and customer info
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      DataSnapshot snapshot = await _database.ref('users/${user.uid}').get();

      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
  }

  // Update customer name (for existing users)
  Future<void> updateCustomerName({
    required int customerId,
    required String newName,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Update in users node
      await _database.ref('users/${user.uid}').update({
        'customerName': newName,
      });

      // Update in pelanggan node
      await _database.ref('pelanggan/$customerId').update({
        'customer_name': newName,
        'last_updated': ServerValue.timestamp,
      });
    } catch (e) {
      throw Exception('Failed to update customer name: ${e.toString()}');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  // Check if customer ID is already taken by another user
  Future<bool> isCustomerIdTaken(int customerId) async {
    try {
      Query query = _database
          .ref('users')
          .orderByChild('customerId')
          .equalTo(customerId);

      DataSnapshot snapshot = await query.get();
      return snapshot.exists;
    } catch (e) {
      ('Error checking customer ID: $e');
      return false; // Default to false to allow account creation
    }
  }

  // Get all customers (for admin use)
  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    try {
      DataSnapshot snapshot = await _database.ref('pelanggan').get();
      List<Map<String, dynamic>> customers = [];

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          customers.add({
            'customerId': int.tryParse(key.toString()) ?? 0,
            'customerName': value['customer_name'] ?? 'Customer $key',
            'lastUpdated': value['last_updated'],
            'monitoring': value['monitoring'] ?? {},
          });
        });
      }

      return customers;
    } catch (e) {
      throw Exception('Failed to get customers: ${e.toString()}');
    }
  }

  // Stream for real-time customer data (for monitoring)
  Stream<DatabaseEvent> getCustomerDataStream(int customerId) {
    return _database.ref('pelanggan/$customerId').onValue;
  }

  // Stream for user authentication state
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
