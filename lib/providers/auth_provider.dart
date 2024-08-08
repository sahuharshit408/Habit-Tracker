import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  Future<bool> signIn(String email, String password) async {
    // Simulate network request with delay
    await Future.delayed(Duration(seconds: 2));
    return true; // Return true for successful login, false otherwise
  }

  Future<bool> signUp(String email, String password) async {
    // Simulate network request with delay
    await Future.delayed(Duration(seconds: 2));
    return true; // Return true for successful signup, false otherwise
  }

  Future<void> signOut() async {
    // Simulate sign-out operation with delay
    await Future.delayed(Duration(seconds: 1));
  }
}
