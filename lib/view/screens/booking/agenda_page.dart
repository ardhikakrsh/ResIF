import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:resif/models/rooms.dart';
import 'package:resif/view/components/blue_background.dart';
import 'package:resif/view/components/secondary_button.dart';
import 'package:resif/view_model/booking/agenda_viewmodel.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaPage extends StatelessWidget {
  final Room room;
  const AgendaPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AgendaViewModel(room: room),
      child: Consumer<AgendaViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Stack(
              children: [
                const BlueBackground(height: 150.0),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 50.0.h,
                          left: 20.0.w,
                          right: 20.0.w,
                          bottom: 20.0.h,
                        ),
                        child: Center(
                          child: Text(
                            'Agenda ${room.code}',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(20.0.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TableCalendar(
                                locale: 'en_US',
                                headerStyle: HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                  titleTextStyle: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                calendarStyle: CalendarStyle(
                                  todayDecoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  selectedDecoration: const BoxDecoration(
                                    color: Color(0xFF0D1B4D),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                focusedDay: viewModel.focusedDay,
                                selectedDayPredicate: (day) =>
                                    isSameDay(viewModel.selectedDay, day),
                                firstDay: DateTime.utc(2020, 1, 1),
                                lastDay: DateTime.utc(2030, 12, 31),
                                onDaySelected: viewModel.onDaySelected,
                                onPageChanged: viewModel.onPageChanged,
                              ),
                              SizedBox(height: 20.h),
                              Consumer<AgendaViewModel>(
                                builder: (context, viewModel, child) {
                                  if (viewModel.state == ViewState.loading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (viewModel.state ==
                                      ViewState.error) {
                                    return Center(
                                      child: Text(
                                        'Error: ${viewModel.errorMessage}',
                                        style: TextStyle(fontSize: 16.sp),
                                      ),
                                    );
                                  }

                                  if (viewModel.bookings.isEmpty) {
                                    return const Center(
                                      child: Text('No bookings found.'),
                                    );
                                  }

                                  return Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                viewModel.bookings.length,
                                            itemBuilder: (context, index) {
                                              final booking =
                                                  viewModel.bookings[index];
                                              return Card(
                                                elevation: 5,
                                                color: const Color(0xFFEDEDED),
                                                margin: EdgeInsets.only(
                                                    bottom: 10.h),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.w,
                                                      vertical: 12.h),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              booking.acara,
                                                              style: TextStyle(
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                                height: 8.h),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .access_time_filled_rounded,
                                                                  color: Color(
                                                                      0xFF0D1B4D),
                                                                ),
                                                                SizedBox(
                                                                    width: 8.w),
                                                                Text(
                                                                  'Waktu: ${booking.mulai} - ${booking.selesai}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Chip(
                                                        label: Text(
                                                          'Approved',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        backgroundColor: Colors
                                                            .green.shade100,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 8.w,
                                                        ),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                          side: BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 1.5.w,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20.h),
                              const SecondaryButton(text1: 'Back'),
                            ],
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
