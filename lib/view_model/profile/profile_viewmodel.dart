import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resif/providers/user_provider.dart';
import 'package:resif/service/auth/auth_service.dart';
import 'package:resif/view/components/my_alert_dialog.dart';
import 'package:resif/view/screens/profile/edit_profile.dart';
import 'package:resif/view/screens/welcome_page.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    _setLoading(true);
    try {
      await _authService.signOut();

      if (context.mounted) {
        Provider.of<UserProvider>(context, listen: false).clearUserData();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
              (route) => false,
        );
      }
    } catch (e) {
      debugPrint("Error during logout: $e");
    } finally {
      if (_isLoading) {
        _setLoading(false);
      }
    }
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return MyAlertDialog(
          title: 'Logout',
          titleColor: Colors.redAccent,
          iconTitle: Icons.logout,
          iconColor: Colors.redAccent,
          description: 'Are you sure you want to logout?',
          buttonText1: 'Cancel',
          buttonText2: 'Logout',
          backgroundColor: Colors.redAccent,
          onPressed: () async {
            Navigator.of(dialogContext).pop();
            await logout(context);
          },
        );
      },
    );
  }
}