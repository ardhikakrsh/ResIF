import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlueBackground extends StatelessWidget {
  final double height;

  const BlueBackground({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF20469B),
            Color(0xFF0B1835),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF0D1B4D),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}
