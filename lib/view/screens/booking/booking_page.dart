import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:resif/view/components/blue_background.dart';
import 'package:resif/view/components/header.dart';
import 'package:resif/view/components/room_card.dart';
import 'package:resif/view/components/search_field.dart';
import 'package:resif/view_model/booking/booking_viewmodel.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingViewModel(),
      child: Consumer<BookingViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Stack(
              children: [
                BlueBackground(height: 150.h),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            padding: EdgeInsets.all(20.0.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SearchField(
                                  text: 'Search Room',
                                  controller: viewModel.searchController,
                                ),
                                SizedBox(height: 20.h),
                                Text(
                                  'Categories',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _buildCategoryFilters(viewModel),
                                SizedBox(height: 20.h),
                                _buildBody(context, viewModel),
                              ],
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

  // Helper widget untuk membangun body utama (loading, error, atau daftar ruangan)
  Widget _buildBody(BuildContext context, BookingViewModel viewModel) {
    switch (viewModel.state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());
      case ViewState.error:
        return Center(child: Text("Error: ${viewModel.errorMessage}"));
      case ViewState.success:
        if (viewModel.filteredRooms.isEmpty) {
          return const Center(child: Text("Tidak ada ruangan yang ditemukan."));
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: viewModel.filteredRooms.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final room = viewModel.filteredRooms[index];
            return RoomCard(room: room);
          },
        );
      case ViewState.idle:
      default:
        return const SizedBox.shrink();
    }
  }

  // Widget untuk filter kategori
  Widget _buildCategoryFilters(BookingViewModel viewModel) {
    const categories = ['All', 'Lab', 'Kelas', 'Lainnya'];
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = viewModel.selectedCategory == category;
          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                viewModel.updateCategory(category);
              }
            },
            backgroundColor: Colors.white,
            selectedColor: const Color(0xFF0D1B4D),
            labelStyle: TextStyle(
              fontSize: 14.sp,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
              side: const BorderSide(color: Color(0xFF0D1B4D)),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}