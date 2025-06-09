import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:resif/helper/display_message.dart';
import 'package:resif/helper/top_snackbar.dart';
import 'package:resif/service/auth/auth_service.dart';
import 'package:resif/service/database/firestore.dart';
import 'package:resif/view/screens/auth/login_page.dart';

class RegisterViewModel extends ChangeNotifier {
  // Services
  final AuthService _authService = AuthService();
  final FirestoreService _db = FirestoreService();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // State
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _isConfirmPasswordVisible = false;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  Future<void> register(BuildContext context) async {

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showTopSnackbar(
          context: context,
          title: 'Alert',
          message: 'Please fill all fields',
          contentType: ContentType.warning,
          shadowColor: Colors.orange.shade300);
      return;
    }

    if (!emailController.text.contains('@')) {
      showTopSnackbar(
          context: context,
          title: 'Alert',
          message: 'Please enter a valid email address',
          contentType: ContentType.warning,
          shadowColor: Colors.orange.shade300);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showTopSnackbar(
          context: context,
          title: 'Alert',
          message: 'Password and Confirm Password do not match',
          contentType: ContentType.warning,
          shadowColor: Colors.orange.shade300);
      return;
    }

    _setLoading(true);

    try {

      await _authService.signUpWithEmailPassword(
        nameController.text,
        emailController.text,
        passwordController.text,
      );

      await _db.saveUserDataToDatabase(
        nameController.text,
        emailController.text,
        passwordController.text,
        null, // phone
        null, // department
        null, // photoUrl
      );

      if (!context.mounted) return;

      showTopSnackbar(
        context: context,
        title: 'Registration Successful',
        message: 'Please login to continue',
        contentType: ContentType.success,
        shadowColor: Colors.green.shade300,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      if (context.mounted) {
        displayMessage(e.toString(), context);
      }
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}