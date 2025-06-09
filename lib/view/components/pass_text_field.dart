import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPasswordVisible;
  final VoidCallback onVisibilityToggle;

  const PassTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isPasswordVisible,
    required this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, size: 22.r, color: Colors.white70),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          onPressed: onVisibilityToggle,
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            size: 22.r,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
