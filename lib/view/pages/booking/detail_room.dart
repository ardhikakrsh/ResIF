import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resif/components/blue_background.dart';
import 'package:resif/components/details_tab.dart';
import 'package:resif/components/form_tab.dart';
import 'package:resif/models/rooms.dart';

class DetailRoomPage extends StatefulWidget {
  final Room room;
  const DetailRoomPage({super.key, required this.room});

  @override
  State<DetailRoomPage> createState() => _DetailRoomPageState();
}

class _DetailRoomPageState extends State<DetailRoomPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild untuk update judul header
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Judul berubah berdasarkan tab yang aktif
    String headerTitle = _tabController.index == 0
        ? '${widget.room.code} Room Details'
        : 'Book ${widget.room.code} Room';

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          BlueBackground(height: 150.h),
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
                  child: Center(
                    child: Text(
                      headerTitle,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Main Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          // TabBar
                          TabBar(
                            controller: _tabController,
                            indicatorColor: const Color(0xFF0D1B4D),
                            labelStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            tabs: const [
                              Tab(
                                text: 'Details',
                              ),
                              Tab(text: 'Form'),
                            ],
                          ),

                          // TabBarView
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                DetailsTab(room: widget.room),
                                FormTab(room: widget.room),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          )
        ],
      ),
    );
  }
}
