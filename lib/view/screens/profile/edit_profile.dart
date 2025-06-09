// File: lib/view/screens/profile/edit_profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:resif/view/components/blue_background.dart';
import 'package:resif/view/components/header.dart';
import 'package:resif/view/components/main_button.dart';
import 'package:resif/view/components/row_button.dart';
import 'package:resif/providers/user_provider.dart';
import 'package:resif/view_model/profile/edit_profile_viewmodel.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Membuat dan menyediakan ViewModel, dengan menyuntikkan UserProvider
    return ChangeNotifierProvider(
      create: (context) => EditProfileViewModel(
        userProvider: Provider.of<UserProvider>(context, listen: false),
      ),
      child: Consumer<EditProfileViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Stack(
              children: [
                BlueBackground(height: 150.h),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30.0.h, left: 20.0.w, right: 20.0.w, bottom: 20.0.h),
                        child: const Header(),
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(20.0.w),
                            child: Container(
                              padding: EdgeInsets.all(20.0.w),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Account Details', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF0D1B4D))),
                                  SizedBox(height: 20.h),

                                  // Menggunakan controller dari ViewModel
                                  TextField(
                                    controller: viewModel.nameController,
                                    decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r))),
                                  ),
                                  SizedBox(height: 20.h),

                                  TextField(
                                    enabled: false,
                                    controller: viewModel.emailController,
                                    decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r))),
                                  ),
                                  SizedBox(height: 20.h),

                                  TextField(
                                    controller: viewModel.phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(labelText: 'Phone', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r))),
                                  ),
                                  SizedBox(height: 20.h),

                                  TextField(
                                    controller: viewModel.departmentController,
                                    decoration: InputDecoration(labelText: 'Department', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r))),
                                  ),
                                  SizedBox(height: 20.h),

                                  MainButton(
                                    text: 'Delete Account',
                                    textColor: Colors.white,
                                    icon: Icons.delete,
                                    iconColor: Colors.white,
                                    backgroundColor: Colors.redAccent,
                                    shadowColor: Colors.redAccent,
                                    onPressed: () => viewModel.showDeleteAccountDialog(context),
                                  ),
                                  const SizedBox(height: 50),

                                  RowButton(
                                    text1: 'Back',
                                    text2: 'Save Changes',
                                    onPressed: () => viewModel.saveChanges(context),
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
              ],
            ),
          );
        },
      ),
    );
  }
}