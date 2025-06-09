import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:resif/view/components/blue_background.dart';
import 'package:resif/view/components/details_tab.dart';
import 'package:resif/view/components/form_tab.dart';
import 'package:resif/models/rooms.dart';
import 'package:resif/view_model/booking/detail_room_viewmodel.dart';

class DetailRoomPage extends StatefulWidget {
  final Room room;
  const DetailRoomPage({super.key, required this.room});

  @override
  State<DetailRoomPage> createState() => _DetailRoomPageState();
}

class _DetailRoomPageState extends State<DetailRoomPage>
    with SingleTickerProviderStateMixin {
  // View sekarang hanya memegang instance ViewModel
  late final DetailRoomViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Buat ViewModel dan inisialisasi TabController-nya
    _viewModel = DetailRoomViewModel(room: widget.room);
    _viewModel.init(this); // 'this' adalah TickerProvider
  }

  @override
  void dispose() {
    // Panggil dispose pada ViewModel untuk membersihkan controller
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sediakan ViewModel ke widget tree di bawahnya
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<DetailRoomViewModel>(
        builder: (context, viewModel, child) {
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 50.h),
                        child: Center(
                          child: Text(
                            // Ambil judul dari ViewModel
                            viewModel.headerTitle,
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
                                  // Gunakan controller dari ViewModel
                                  controller: viewModel.tabController,
                                  indicatorColor: const Color(0xFF0D1B4D),
                                  labelStyle: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  labelColor: Colors.black,
                                  unselectedLabelColor: Colors.grey,
                                  tabs: const [
                                    Tab(text: 'Details'),
                                    Tab(text: 'Form'),
                                  ],
                                ),
                                // TabBarView
                                Expanded(
                                  child: TabBarView(
                                    // Gunakan controller dari ViewModel
                                    controller: viewModel.tabController,
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
        },
      ),
    );
  }
}