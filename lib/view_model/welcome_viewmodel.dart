import 'package:flutter/material.dart';
import 'package:resif/view/screens/auth/login_page.dart';
import 'package:resif/view/screens/auth/register_page.dart';

class WelcomeViewModel extends ChangeNotifier {
  // Method untuk menangani navigasi ke halaman register
  void navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  // Method untuk menangani navigasi ke halaman login
  void navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}