import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resif/components/header_home.dart';
import 'package:resif/models/rules.dart';
import 'package:resif/service/database/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService db = FirestoreService();
  late Future<List<Rules>> _rulesFuture;
  // Map untuk melacak status expand dari setiap kartu berdasarkan judulnya
  final Map<String, bool> _expandedState = {
    // Inisialisasi dengan judul-judul yang ada
    'Tata Tertib': true,
  };

  @override
  void initState() {
    super.initState();
    _rulesFuture = db.fetchAllRules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Biru
          Container(
            height: 300.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF20469B),
                  Color(0xFF0B1835),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF0D1B4D),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
            ),
          ),

          // Konten Utama
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 40.h),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: HeaderHome(),
                ),
                SizedBox(height: 20.h),

                // Gunakan FutureBuilder untuk menampilkan data rules
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder<List<Rules>>(
                          future: _rulesFuture,
                          builder: (context, snapshot) {
                            // 1. Saat data sedang dimuat
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white));
                            }
                            // 2. Jika terjadi error
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Error: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            // 3. Jika tidak ada data
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('Tidak ada aturan tersedia.'),
                              );
                            }

                            // 4. Jika data berhasil dimuat
                            final sections = snapshot.data!;
                            return ListView.builder(
                              itemCount: sections.length,
                              shrinkWrap:
                                  true, // Penting di dalam SingleChildScrollView
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final section = sections[index];
                                return _buildExpandableCard(section);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membuat setiap kartu yang bisa di-expand
  Widget _buildExpandableCard(Rules section) {
    // Mengecek status expand dari map, defaultnya false
    bool isExpanded = _expandedState[section.title] ?? false;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 15.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
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
                  _expandedState[section.title] = !isExpanded;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      section.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4.sp),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D1B4D),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isExpanded
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
                visible: isExpanded,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: ListView.builder(
                    itemCount: section.content.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
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
                                section.content[index],
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
