import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resif/models/rules.dart';

class RuleCard extends StatefulWidget {
  final Rules section;
  const RuleCard({super.key, required this.section});

  @override
  State<RuleCard> createState() => _RuleCardState();
}

class _RuleCardState extends State<RuleCard> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // Atur agar 'Tata Tertib' terbuka secara default
    if (widget.section.title == 'Tata Tertib') {
      _isExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 15.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  // Toggle state untuk kartu yang diklik
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.section.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4.sp),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D1B4D),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              child: Visibility(
                visible: _isExpanded,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: ListView.builder(
                    itemCount: widget.section.content.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final contentItem = widget.section.content[index];

                      bool isImage = contentItem.startsWith('http') &&
                          (contentItem.endsWith('.jpg') ||
                              contentItem.endsWith('.png') ||
                              contentItem.endsWith('.jpeg'));

                      if (isImage) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Image.network(
                            contentItem,
                            width: double.infinity,
                            height: 300.h,
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.0.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index + 1}. ",
                                style: TextStyle(fontSize: 16.sp, height: 1.5),
                              ),
                              Expanded(
                                child: Text(
                                  widget.section.content[index],
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
