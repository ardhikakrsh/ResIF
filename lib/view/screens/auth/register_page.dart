import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:resif/view/components/handle_bar.dart';
import 'package:resif/view/components/normal_text_field.dart';
import 'package:resif/view/components/pass_text_field.dart';
import 'package:resif/view/screens/auth/login_page.dart';
import 'package:resif/view_model/auth/register_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showRegisterSheet(context);
    });
  }

  void _showRegisterSheet(BuildContext pageContext) {
    showModalBottomSheet(
      context: pageContext,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      barrierColor: Colors.transparent,
      builder: (_) {
        return ChangeNotifierProvider(
          create: (_) => RegisterViewModel(),
          child: Consumer<RegisterViewModel>(
            builder: (context, viewModel, child) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  height: 0.65.sh,
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.r),
                      topRight: Radius.circular(35.r),
                    ),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF20469B), Color(0xFF0B1835)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),
                        const HandleBar(),
                        SizedBox(height: 30.h),
                        NormalTextField(
                          controller: viewModel.nameController,
                          hintText: 'Full Name',
                          prefixIcon: Icons.person,
                        ),
                        SizedBox(height: 16.h),
                        NormalTextField(
                          controller: viewModel.emailController,
                          hintText: 'Email',
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16.h),
                        PassTextField(
                          controller: viewModel.passwordController,
                          hintText: 'Password',
                          isPasswordVisible: viewModel.isPasswordVisible,
                          onVisibilityToggle: viewModel.togglePasswordVisibility,
                        ),
                        SizedBox(height: 16.h),
                        PassTextField(
                          controller: viewModel.confirmPasswordController,
                          hintText: 'Confirm Password',
                          isPasswordVisible: viewModel.isConfirmPasswordVisible,
                          onVisibilityToggle: viewModel.toggleConfirmPasswordVisibility,
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
                                : () => viewModel.register(context),
                            child: viewModel.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.white)),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
                              },
                              child: Text(
                                ' Login here',
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
}