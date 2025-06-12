import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resif/view/components/row_button.dart';
import 'package:resif/models/rooms.dart';
import 'package:resif/view/screens/booking/agenda_page.dart';

class DetailsTab extends StatelessWidget {
  final Room room;
  const DetailsTab({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // room details
          Text(
            "Room Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
          SizedBox(height: 20.h),

          // info rooms
          _buildInfoRow("Room Code", room.code),
          _buildInfoRow("Room Name", room.name),
          _buildInfoRow("Technician", room.technician),
          _buildInfoRow("Phone Number", room.phoneNumber),
          SizedBox(height: 30.h),

          // buttons
          RowButton(
            text1: "Back",
            text2: "Agenda",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgendaPage(room: room),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // Helper widget untuk baris info di tab Details
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
