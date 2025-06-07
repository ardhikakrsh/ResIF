import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resif/components/handle_bar.dart';
import 'package:resif/components/normal_text_field.dart';
import 'package:resif/components/pass_text_field.dart';
import 'package:resif/helper/display_message.dart';
import 'package:resif/helper/top_snackbar.dart';
import 'package:resif/service/auth/auth_service.dart';
import 'package:resif/service/database/firestore.dart';
import 'package:resif/view/pages/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Panggil bottom sheet setelah frame pertama selesai di-render.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showRegisterSheet(context);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showRegisterSheet(BuildContext pageContext) {
    bool isPasswordVisible = false;
    bool isConfirmPasswordVisible = false;

    showModalBottomSheet(
      context: pageContext,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        // Gunakan StatefulBuilder agar UI di dalam sheet bisa di-update
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Padding agar form tidak tertutup keyboard
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: 0.6.sh,
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.r),
                    topRight: Radius.circular(35.r),
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF20469B),
                      Color(0xFF0B1835),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      // Handlebar
                      const HandleBar(),
                      SizedBox(height: 30.h),

                      // Full Name Field
                      NormalTextField(
                        controller: nameController,
                        hintText: 'Full Name',
                        prefixIcon: Icons.person,
                      ),
                      SizedBox(height: 16.h),

                      // Email Field
                      NormalTextField(
                        controller: emailController,
                        hintText: 'Email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16.h),

                      // Password Field
                      PassTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        isPasswordVisible: isPasswordVisible,
                        onVisibilityToggle: () {
                          // Gunakan setModalState untuk update UI sheet
                          setModalState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Confirm Password Field
                      PassTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        isPasswordVisible: isConfirmPasswordVisible,
                        onVisibilityToggle: () {
                          // Gunakan setModalState untuk update UI sheet
                          setModalState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                      SizedBox(height: 30.h),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF20469B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: onRegisterPressed,
                          child: Text(
                            'REGISTER',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.white)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                            child: Text(
                              ' Login here',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.blueAccent[100],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build method utama sekarang hanya menampilkan header.
    return Scaffold(
      backgroundColor: Colors.grey[200], // Background abu-abu terang
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: 0.5.sh, // Tinggi area header
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CREATE AN ACCOUNT',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Join us to get started',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  void onRegisterPressed() async {
    final authService = AuthService();
    FirestoreService db = FirestoreService();
    // empty all text field
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Please fill all fields',
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

    // pass and confirm pass not match
    if (passwordController.text != confirmPasswordController.text) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Password and Confirm Password do not match',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    // pass and confirm pass match
    if (passwordController.text == confirmPasswordController.text) {
      try {
        // Sign up with email and password
        await authService.signUpWithEmailPassword(
          nameController.text,
          emailController.text,
          passwordController.text,
        );

        await db.saveUserDataToDatabase(
          nameController.text,
          emailController.text,
          passwordController.text,
          null, // phone
          null, // department
          null, // photoUrl
        );

        showTopSnackbar(
          context: context,
          title: 'Registration Successful',
          message: 'Please login to continue',
          contentType: ContentType.success,
          shadowColor: Colors.green.shade300,
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } catch (e) {
        if (mounted) {
          displayMessage(e.toString(), context);
        }
        return;
      }
    }
  }
}
