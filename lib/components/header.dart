import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:resif/providers/user_provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).userData;
    return Row(
      children: [
        // avatar
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            color: Color(0xFF0D1B4D),
            size: 30,
          ),
        ),
        SizedBox(width: 16.w),

        // greeting and name
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userData['name'] ?? 'User',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              userData['email'] ?? 'Email',
              style: const TextStyle(
                color: Color(0xFF59A7FF),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const Spacer(),

        // notif
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              IconlyLight.notification,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
