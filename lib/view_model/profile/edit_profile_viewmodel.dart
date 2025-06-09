import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:provider/provider.dart';
import 'package:resif/helper/top_snackbar.dart';
import 'package:resif/providers/user_provider.dart';
import 'package:resif/service/auth/auth_service.dart';
import 'package:resif/service/database/firestore.dart';
import 'package:resif/view/screens/welcome_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class EditProfileViewModel extends ChangeNotifier {
  final UserProvider _userProvider;
  final FirestoreService _db = FirestoreService();
  final AuthService _auth = AuthService();

  // Controllers
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController departmentController;

  // State
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  EditProfileViewModel({required UserProvider userProvider}) : _userProvider = userProvider {
    _initializeControllers();
  }

  void _initializeControllers() {
    final userData = _userProvider.userData;
    nameController = TextEditingController(text: userData['name'] ?? '');
    emailController = TextEditingController(text: userData['email'] ?? '');
    phoneController = TextEditingController(text: userData['phone'] ?? '');
    departmentController = TextEditingController(text: userData['department'] ?? '');
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> saveChanges(BuildContext context) async {
    final userData = _userProvider.userData;

    if (nameController.text.isEmpty || phoneController.text.isEmpty || departmentController.text.isEmpty) {
      showTopSnackbar(context: context, title: 'Alert', message: 'Please fill in all fields', contentType: ContentType.warning, shadowColor: Colors.orange.shade300);
      return;
    }
    if (phoneController.text.length < 10 || phoneController.text.length > 15) {
      showTopSnackbar(context: context, title: 'Alert', message: 'Phone number must be between 10 and 15 digits', contentType: ContentType.warning, shadowColor: Colors.orange.shade300);
      return;
    }
    if (nameController.text == userData['name'] && phoneController.text == userData['phone'] && departmentController.text == userData['department']) {
      showTopSnackbar(context: context, title: 'Alert', message: 'No changes detected', contentType: ContentType.warning, shadowColor: Colors.orange.shade300);
      return;
    }

    _setLoading(true);

    final updatedData = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'department': departmentController.text,
      'photoUrl': userData['photoUrl'],
    };

    try {
      await _db.updateUserData(emailController.text, updatedData['name'], updatedData['phone'], updatedData['department'], updatedData['photoUrl']);
      _userProvider.updateUserData(emailController.text, updatedData);

      showTopSnackbar(context: context, title: 'Success', message: 'Profile updated successfully', contentType: ContentType.success, shadowColor: Colors.green.shade300);

      if (context.mounted) Navigator.pop(context);

    } catch (e) {
      showTopSnackbar(context: context, title: 'Error', message: 'Failed to update profile: $e', contentType: ContentType.failure, shadowColor: Colors.red.shade300);
    } finally {
      _setLoading(false);
    }
  }

  void showDeleteAccountDialog(BuildContext context) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0D1B4D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              SizedBox(width: 10),
              Text('Delete Account', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please confirm your password to delete this account permanently.', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              SizedBox(height: 10.h),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Color(0xFFA7A7A7)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: Colors.white)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                await _confirmDeleteAccount(context, passwordController.text);
                // Tutup dialog setelah proses selesai
                if(context.mounted) Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context, String password) async {
    if (password.isEmpty) {
      showTopSnackbar(context: context, title: 'Alert', message: 'Please enter your password', contentType: ContentType.warning, shadowColor: Colors.orange.shade300);
      return;
    }

    _setLoading(true);
    try {
      await _auth.reauthenticateUser(emailController.text, password);
      await _auth.deleteAccount();

      if (context.mounted) {
        // Navigasi ke WelcomePage dan hapus semua rute sebelumnya
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      showTopSnackbar(context: context, title: 'Delete Account Failed', message: 'Password is incorrect or an error occurred.', contentType: ContentType.failure, shadowColor: Colors.red.shade300);
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    departmentController.dispose();
    super.dispose();
  }
}