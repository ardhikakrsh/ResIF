import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final Color titleColor;
  final IconData iconTitle;
  final Color iconColor;
  final String description;
  final String buttonText1;
  final String buttonText2;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  const MyAlertDialog({
    super.key,
    required this.title,
    required this.titleColor,
    required this.iconTitle,
    required this.iconColor,
    required this.description,
    required this.buttonText1,
    required this.buttonText2,
    required this.backgroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0D1B4D),
      shadowColor: const Color(0xFF0D1B4D),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      title: Row(
        children: [
          Icon(iconTitle, color: iconColor),
          SizedBox(width: 10.w),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            description,
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
          SizedBox(height: 10.h),
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
          child: Text(
            buttonText1,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          onPressed: onPressed,
          child: Text(buttonText2, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
