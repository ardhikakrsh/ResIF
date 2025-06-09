import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:resif/helper/top_snackbar.dart';
import 'package:resif/providers/user_provider.dart';
import 'package:resif/service/auth/auth_service.dart';
import 'package:resif/view/widgets/navigation_menu.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Email and password cannot be empty',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    if (!emailController.text.contains('@')) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Please enter a valid email address',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    _setLoading(true);

    try {
      await _authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      if (!context.mounted) return;
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserDataByEmail(emailController.text);
      final userName = userProvider.userData['name'] ?? 'User';

      showTopSnackbar(
        context: context,
        title: 'Login Success',
        message: 'Welcome to ResIF, $userName!',
        contentType: ContentType.success,
        shadowColor: Colors.green.shade300,
      );

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationMenu()),
        );
      }

    } catch (e) {
      if (context.mounted) {
        showTopSnackbar(
          context: context,
          title: 'Login Failed',
          message: 'Email or password is incorrect',
          contentType: ContentType.failure,
          shadowColor: Colors.red.shade300,
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}