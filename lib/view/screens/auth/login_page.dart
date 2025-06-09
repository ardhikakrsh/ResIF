import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:resif/view/components/handle_bar.dart';
import 'package:resif/view/components/normal_text_field.dart';
import 'package:resif/view/components/pass_text_field.dart';
import 'package:resif/view/components/separator.dart';
import 'package:resif/view/components/square_tile.dart';
import 'package:resif/view/screens/auth/register_page.dart';
import 'package:resif/view_model/auth/login_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLoginSheet(context);
    });
  }

  void _showLoginSheet(BuildContext pageContext) {
    showModalBottomSheet(
      context: pageContext,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) {
        return ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  height: 0.65.sh,
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF20469B), Color(0xFF0B1835)],
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
                        const HandleBar(),
                        SizedBox(height: 30.h),
                        NormalTextField(
                          controller: viewModel.emailController,
                          hintText: 'Email',
                          prefixIcon: Icons.email,
                        ),
                        SizedBox(height: 16.h),
                        PassTextField(
                          controller: viewModel.passwordController,
                          hintText: 'Password',
                          isPasswordVisible: viewModel.isPasswordVisible,
                          onVisibilityToggle: viewModel.togglePasswordVisibility,
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {},
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
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF20469B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              disabledBackgroundColor: const Color(0xFF0B1835),
                            ),
                            onPressed: viewModel.isLoading
                                ? null
                                : () => viewModel.login(context),
                            child: viewModel.isLoading
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : Text(
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
                        const Separator(),
                        SizedBox(height: 30.h),
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: 0.45.sh,
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
}