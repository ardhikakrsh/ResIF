import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:resif/components/account_info_row.dart';
import 'package:resif/components/blue_background.dart';
import 'package:resif/components/header.dart';
import 'package:resif/components/main_button.dart';
import 'package:resif/components/my_alert_dialog.dart';
import 'package:resif/providers/user_provider.dart';
import 'package:resif/service/auth/auth_service.dart';
import 'package:resif/view/pages/profile/edit_profile.dart';
import 'package:resif/view/pages/welcome_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

                // content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0.w, vertical: 20.0.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0.w, vertical: 20.0.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // account details
                            Text(
                              'Account Details',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0D1B4D),
                              ),
                            ),
                            SizedBox(height: 6.h),

                            // name
                            AccountInfoRow(
                              icon: Icons.person,
                              title: 'Name',
                              value: userData['name'] ?? 'No Name',
                            ),
                            AccountInfoRow(
                              icon: Icons.email,
                              title: 'Email',
                              value: userData['email'] ?? 'No Email',
                            ),
                            AccountInfoRow(
                              icon: Icons.phone,
                              title: 'Phone',
                              value: userData['phone'] ?? '-',
                            ),
                            AccountInfoRow(
                              icon: Icons.work,
                              title: 'Department',
                              value: userData['department'] ?? '-',
                            ),
                            SizedBox(height: 20.h),
                            // Button Edit
                            MainButton(
                              text: 'Edit Profile',
                              textColor: Colors.white,
                              icon: Icons.edit,
                              iconColor: Colors.white,
                              backgroundColor: const Color(0xFF0D1B4D),
                              shadowColor: const Color(0xFF0D1B4D),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfilePage(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 8.h),

                            // Button Logout
                            MainButton(
                              text: 'Logout',
                              textColor: Colors.white,
                              icon: Icons.logout,
                              iconColor: Colors.white,
                              backgroundColor: Colors.redAccent,
                              shadowColor: Colors.redAccent,
                              onPressed: onLogoutPressed,
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

          // content
        ],
      ),
    );
  }

  void onLogoutPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertDialog(
          title: 'Logout',
          titleColor: Colors.redAccent,
          iconTitle: Icons.logout,
          iconColor: Colors.redAccent,
          description: 'Are you sure you want to logout?',
          buttonText1: 'Cancel',
          buttonText2: 'Logout',
          backgroundColor: Colors.redAccent,
          onPressed: () {
            AuthService().signOut().then((value) {
              Provider.of<UserProvider>(context, listen: false).clearUserData();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (route) => false,
              );
            });
          },
        );
      },
    );
  }
}
