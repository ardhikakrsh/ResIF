import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:resif/view/pages/booking/booking_page.dart';
import 'package:resif/view/pages/history/history_page.dart';
import 'package:resif/view/pages/home/home_page.dart';
import 'package:resif/view/pages/profile/profile_page.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    BookingPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: CrystalNavigationBar(
          currentIndex: _currentIndex,
          enablePaddingAnimation: true,
          indicatorColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.5),
          backgroundColor: const Color(0xFF0B1835),
          // outlineBorderColor: Colors.black.withOpacity(0.1),
          // borderWidth: 2,
          // outlineBorderColor: Colors.white,
          onTap: _handleIndexChanged,
          items: [
            /// Home
            CrystalNavigationBarItem(
              icon: IconlyBold.home,
              unselectedIcon: IconlyLight.home,
              selectedColor: Colors.white,
              badge: const Badge(
                label: Text("9+", style: TextStyle(color: Colors.white)),
              ),
            ),

            /// Favourite
            CrystalNavigationBarItem(
              icon: IconlyBold.discovery,
              unselectedIcon: IconlyLight.discovery,
              selectedColor: Colors.white,
            ),

            /// Add
            CrystalNavigationBarItem(
              icon: IconlyBold.bookmark,
              unselectedIcon: IconlyLight.bookmark,
              selectedColor: Colors.white,
            ),

            /// Profile
            CrystalNavigationBarItem(
              icon: IconlyBold.profile,
              unselectedIcon: IconlyLight.profile,
              selectedColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _handleIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
