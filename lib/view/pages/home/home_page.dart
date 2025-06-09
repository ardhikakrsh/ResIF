import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resif/components/blue_background.dart';
import 'package:resif/components/header_home.dart';
import 'package:resif/components/rule_card.dart';
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
          BlueBackground(height: 300.h),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 30.0.h, left: 20.0.w, right: 20.0.w, bottom: 20.0.h),
                  child: const HeaderHome(),
                ),
                SizedBox(height: 20.h),

                // content
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
                                    color: Colors.white),
                              );
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
                                return RuleCard(section: section);
                              },
                            );
                          },
                        ),
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
  }
}
