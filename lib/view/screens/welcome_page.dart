import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
// Impor ViewModel
import 'package:resif/view_model/welcome_viewmodel.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Membuat dan menyediakan ViewModel untuk widget tree di bawahnya
    return ChangeNotifierProvider(
      create: (_) => WelcomeViewModel(),
      child: Scaffold(
        body: Stack(
          children: [
            // Fullscreen Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF20469B),
                    Color(0xFF0B1835),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Background Lottie Animation
            Lottie.asset('assets/lotties/resif.json',
                height: double.infinity, width: double.infinity, repeat: false),

            // Foreground Content
            // Consumer digunakan untuk mendapatkan akses ke ViewModel
            Consumer<WelcomeViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      children: [], // Optional center content
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 40.0,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: const Size(double.infinity, 40.0),
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                side: const BorderSide(color: Colors.white),
                              ),
                              // Panggil method dari ViewModel
                              onPressed: () => viewModel.navigateToRegister(context),
                              child: const Text(
                                'REGISTER',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: const Color(0xFFD9D9D9),
                                elevation: 5,
                                minimumSize: const Size(double.infinity, 40.0),
                              ),
                              // Panggil method dari ViewModel
                              onPressed: () => viewModel.navigateToLogin(context),
                              child: const Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF20469B),
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}