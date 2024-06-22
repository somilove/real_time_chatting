import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register with email and password
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await _saveUserToPreferences(user);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await _saveUserToPreferences(user);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userEmail');
    } catch (e) {
      print(e.toString());
    }
  }

  // Save user to SharedPreferences
  Future<void> _saveUserToPreferences(User? user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (user != null) {
      await prefs.setString('userEmail', user.email!);
    }
  }

  // Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('userEmail');
    return email != null;
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}