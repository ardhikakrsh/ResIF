import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:resif/providers/user_provider.dart';
import 'package:resif/view/components/blue_background.dart';
import 'package:resif/view/components/header.dart';
import 'package:resif/models/booking.dart';
import 'package:resif/view_model/history/history_viewmodel.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Widget _getStatusChip(Status status) {
    Color chipColor;
    String statusText = status.name[0].toUpperCase() + status.name.substring(1);

    switch (status) {
      case Status.approved:
        chipColor = Colors.green.shade100;
        break;
      case Status.rejected:
        chipColor = Colors.red.shade100;
        break;
      case Status.pending:
      default:
        chipColor = Colors.orange.shade100;
        break;
    }

    return Chip(
      label: Text(
        statusText,
        style: TextStyle(
            fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      backgroundColor: chipColor,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(
          color: Colors.transparent,
          width: 1.w,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userEmail =
        Provider.of<UserProvider>(context).userData['email'] ?? '';

    return ChangeNotifierProvider(
      create: (_) => HistoryViewModel(userEmail),
      child: Scaffold(
        body: Stack(
          children: [
            BlueBackground(height: 150.h),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 30.0.h,
                        left: 20.0.w,
                        right: 20.0.w,
                        bottom: 20.0.h),
                    child: const Header(),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20.w, right: 20.w, top: 20.h, bottom: 10.h),
                    child: Text(
                      'History Booking',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Consumer<HistoryViewModel>(
                      builder: (context, viewModel, child) {
                        switch (viewModel.state) {
                          case ViewState.loading:
                            return const Center(
                                child: CircularProgressIndicator());
                          case ViewState.error:
                            return Center(
                                child:
                                    Text('Error: ${viewModel.errorMessage}'));
                          case ViewState.success:
                            if (viewModel.bookings.isEmpty) {
                              return const Center(
                                  child: Text('No booking history found.'));
                            }
                            return ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              itemCount: viewModel.bookings.length,
                              itemBuilder: (context, index) {
                                final booking = viewModel.bookings[index];
                                return Card(
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  color: const Color(0xFFEDEDED),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                booking.roomName,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                            _getStatusChip(booking.status),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.calendar_month_rounded,
                                                color: Color(0xFF0D1B4D)),
                                            SizedBox(width: 8.w),
                                            Text(
                                              "Tanggal: ${booking.tanggal}",
                                              style: TextStyle(fontSize: 14.sp),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4.h),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time_filled,
                                                color: Color(0xFF0D1B4D)),
                                            SizedBox(width: 8.w),
                                            Text(
                                              "Waktu: ${booking.mulai} - ${booking.selesai}",
                                              style: TextStyle(fontSize: 14.sp),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          default:
                            return const SizedBox.shrink();
                        }
                      },
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
