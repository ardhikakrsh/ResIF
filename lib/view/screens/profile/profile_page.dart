import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:resif/view/components/account_info_row.dart';
import 'package:resif/view/components/blue_background.dart';
import 'package:resif/view/components/header.dart';
import 'package:resif/view/components/main_button.dart';
import 'package:resif/providers/user_provider.dart';
// Impor ViewModel
import 'package:resif/view_model/profile/profile_viewmodel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).userData;

    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Scaffold(
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.0.h),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.0.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child:
                          Consumer<ProfileViewModel>(
                            builder: (context, viewModel, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Account Details',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0D1B4D),
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
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
                                  MainButton(
                                    text: 'Edit Profile',
                                    textColor: Colors.white,
                                    icon: Icons.edit,
                                    iconColor: Colors.white,
                                    backgroundColor: const Color(0xFF0D1B4D),
                                    shadowColor: const Color(0xFF0D1B4D),
                                    onPressed: () => viewModel.navigateToEditProfile(context),
                                  ),
                                  SizedBox(height: 8.h),
                                  MainButton(
                                    text: 'Logout',
                                    textColor: Colors.white,
                                    icon: Icons.logout,
                                    iconColor: Colors.white,
                                    backgroundColor: Colors.redAccent,
                                    shadowColor: Colors.redAccent,
                                    onPressed: () => viewModel.showLogoutDialog(context),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}