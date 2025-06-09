import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:provider/provider.dart';
import 'package:resif/components/handle_bar.dart';
import 'package:resif/components/normal_text_field.dart';
import 'package:resif/components/pass_text_field.dart';
import 'package:resif/components/separator.dart';
import 'package:resif/components/square_tile.dart';
import 'package:resif/helper/top_snackbar.dart';
import 'package:resif/providers/user_provider.dart';
import 'package:resif/service/auth/auth_service.dart';
import 'package:resif/view/pages/auth/register_page.dart';
import 'package:resif/view/widgets/navigation_menu.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Panggil bottom sheet setelah frame pertama selesai di-render.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLoginSheet(context);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showLoginSheet(BuildContext pageContext) {
    // State untuk password visibility dikelola di sini
    bool isPasswordVisible = false;

    showModalBottomSheet(
      context: pageContext,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent, // Membuat background tidak gelap
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: 0.65.sh, // Sesuaikan tinggi sheet untuk login
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF20469B),
                      Color(0xFF0B1835),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.r),
                    topRight: Radius.circular(35.r),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      // Handlebar
                      const HandleBar(),
                      SizedBox(height: 30.h),

                      // Email Field
                      NormalTextField(
                        controller: emailController,
                        hintText: 'Email',
                        prefixIcon: Icons.email,
                      ),
                      SizedBox(height: 16.h),

                      // Password Field
                      PassTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        isPasswordVisible: isPasswordVisible,
                        onVisibilityToggle: () {
                          setModalState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const ForgotPasswordPage()));
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF20469B), // Warna biru cerah
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: onLoginPressed,
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),

                      // Separator
                      const Separator(),
                      SizedBox(height: 30.h),

                      // Social Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SquareTile(
                              imagePath: 'assets/images/google.png',
                              onTap: () {}),
                          SizedBox(width: 25.w),
                          SquareTile(
                              imagePath: 'assets/images/apple.png',
                              onTap: () {}),
                        ],
                      ),
                      SizedBox(height: 30.h),

                      // Don't have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.white)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterPage()),
                              );
                            },
                            child: Text(
                              ' Register here',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.blueAccent[100],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
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
    // Build method utama hanya menampilkan header.
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: 0.45.sh, // Tinggi area header
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WELCOME BACK',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please login to your account',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  void onLoginPressed() async {
    final authService = AuthService();

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

    try {
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserDataByEmail(emailController.text);
      final userName = userProvider.userData['name'] ?? 'User';

      showTopSnackbar(
        context: context,
        title: 'Login Success',
        message: 'Welcome to VoCalendar, $userName!',
        contentType: ContentType.success,
        shadowColor: Colors.green.shade300,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationMenu()),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopSnackbar(
          context: context,
          title: 'Login Failed',
          message: 'Email or password is incorrect',
          contentType: ContentType.failure,
          shadowColor: Colors.red.shade300,
        );
      }
    }
  }
}
