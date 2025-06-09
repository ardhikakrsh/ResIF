import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:resif/view/components/blue_background.dart';
import 'package:resif/view/components/header_home.dart';
import 'package:resif/view/components/rule_card.dart';
import 'package:resif/view_model/home/home_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Scaffold(
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

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Consumer<HomeViewModel>(
                            builder: (context, viewModel, child) {
                              switch (viewModel.state) {
                                case ViewState.loading:
                                  return const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  );
                                case ViewState.error:
                                  return Center(
                                    child: Text(
                                      'Error: ${viewModel.errorMessage}',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  );
                                case ViewState.success:
                                  if (viewModel.rules.isEmpty) {
                                    return const Center(
                                      child: Text('Tidak ada aturan tersedia.'),
                                    );
                                  }
                                  return ListView.builder(
                                    itemCount: viewModel.rules.length,
                                    shrinkWrap: true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final section = viewModel.rules[index];
                                      return RuleCard(section: section);
                                    },
                                  );
                                case ViewState.idle:
                                default:
                                  return const SizedBox.shrink();
                              }
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
      ),
    );
  }
}