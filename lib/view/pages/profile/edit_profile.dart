import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:resif/components/blue_background.dart';
import 'package:resif/components/header.dart';
import 'package:resif/components/main_button.dart';
import 'package:resif/components/row_button.dart';
import 'package:resif/helper/top_snackbar.dart';
import 'package:resif/providers/user_provider.dart';
import 'package:resif/service/auth/auth_service.dart';
import 'package:resif/service/database/firestore.dart';
import 'package:resif/view/pages/welcome_page.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController departmentController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers di initState
    final userData = Provider.of<UserProvider>(context, listen: false).userData;
    nameController = TextEditingController(text: userData['name'] ?? '-');
    emailController = TextEditingController(text: userData['email'] ?? '-');
    phoneController = TextEditingController(text: userData['phone'] ?? '-');
    departmentController =
        TextEditingController(text: userData['department'] ?? '-');
  }

  @override
  void dispose() {
    // Jangan lupa dispose controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).userData;

    return Scaffold(
      body: Stack(
        children: [
          BlueBackground(height: 150.h),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 30.0.h, left: 20.0.w, right: 20.0.w, bottom: 20.0.h),
                  child: const Header(),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20.0.w),
                      child: Container(
                        padding: EdgeInsets.all(20.0.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Details',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0D1B4D),
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Name field
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Email field
                            TextField(
                              enabled: false,
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                hintText: userData['email'] ?? 'No Email',
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Phone field
                            TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Phone',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                hintText: userData['phone'] ?? 'No Phone',
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Department field
                            TextField(
                              controller: departmentController,
                              decoration: InputDecoration(
                                labelText: 'Department',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                hintText:
                                    userData['department'] ?? 'No Department',
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // delete account button
                            MainButton(
                              text: 'Delete Account',
                              textColor: Colors.white,
                              icon: Icons.delete,
                              iconColor: Colors.white,
                              backgroundColor: Colors.redAccent,
                              shadowColor: Colors.redAccent,
                              onPressed: () => onDeleteAccountPressed(
                                context,
                                userData['email'] ?? '',
                              ),
                            ),

                            const SizedBox(height: 50),
                            // back & edit button
                            RowButton(
                              text1: 'Back',
                              text2: 'Save Changes',
                              onPressed: onSaveChangesPressed,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onSaveChangesPressed() {
    final FirestoreService db = FirestoreService();
    final userData = Provider.of<UserProvider>(context, listen: false).userData;

    // Validate input fields
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        departmentController.text.isEmpty) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Please fill in all fields',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    // phone number validation
    if (phoneController.text.length < 10 || phoneController.text.length > 15) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Phone number must be between 10 and 15 digits',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    // no changes detected
    if (nameController.text == userData['name'] &&
        emailController.text == userData['email'] &&
        phoneController.text == userData['phone'] &&
        departmentController.text == userData['department']) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'No changes detected',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    // Prepare data to update
    final updatedData = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'department': departmentController.text,
      'photoUrl': userData['photoUrl'] ?? '',
    };

    // Update user data in Firestore
    db.updateUserData(
      userData['email'] ?? '',
      updatedData['name'],
      updatedData['phone'],
      updatedData['department'],
      updatedData['photoUrl'],
    );

    // Update user data in UserProvider
    Provider.of<UserProvider>(
      context,
      listen: false,
    ).updateUserData(userData['email'] ?? '', updatedData);
    // top snackbar
    showTopSnackbar(
      context: context,
      title: 'Success',
      message: 'Profile updated successfully',
      contentType: ContentType.success,
      shadowColor: Colors.green.shade300,
    );

    Navigator.pop(context);
  }

  void onDeleteAccountPressed(BuildContext context, String email) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0D1B4D),
          shadowColor: const Color(0xFF0D1B4D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              SizedBox(width: 10.w),
              const Text(
                'Delete Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please confirm your password to delete this account permanently.',
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Color(0xFFA7A7A7)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 1.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () async {
                if (passwordController.text.isEmpty) {
                  showTopSnackbar(
                    context: context,
                    title: 'Alert',
                    message: 'Please enter your password',
                    contentType: ContentType.warning,
                    shadowColor: Colors.orange.shade300,
                  );
                  return;
                }

                try {
                  await AuthService().reauthenticateUser(
                    email,
                    passwordController.text,
                  );
                  await AuthService().deleteAccount();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomePage()),
                  );
                } catch (e) {
                  showTopSnackbar(
                    context: context,
                    title: 'Delete Account Failed',
                    message: 'Password is incorrect',
                    contentType: ContentType.failure,
                    shadowColor: Colors.red.shade300,
                  );
                  return;
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
