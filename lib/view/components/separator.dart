import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.white30)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text('Or continue with',
              style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
        ),
        const Expanded(child: Divider(color: Colors.white30)),
      ],
    );
  }
}
