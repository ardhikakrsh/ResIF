import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:resif/providers/user_provider.dart';

class HeaderHome extends StatelessWidget {
  const HeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).userData;
    return Row(
      children: [
        // avatar
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            color: Color(0xFF0D1B4D),
            size: 30,
          ),
        ),
        SizedBox(width: 16.w),

        // greeting and name
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hi, Welcome!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            Text(
              userData['name'] ?? 'User',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Spacer(),

        // notif
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: IconButton(
            // 2. Logika onPressed diperbarui
            onPressed: () async {
              // Cek status izin notifikasi saat ini
              var status = await Permission.notification.status;

              if (status.isGranted) {
                // Jika sudah diizinkan, mungkin tampilkan pesan atau buka halaman notifikasi di dalam aplikasi
                print("Izin notifikasi sudah diberikan.");
                // Jika perlu, Anda tetap bisa membuka pengaturan
                await openAppSettings();
              } else if (status.isPermanentlyDenied) {
                // Jika pengguna menolak secara permanen, satu-satunya cara adalah membuka pengaturan
                print("Izin ditolak permanen, membuka pengaturan aplikasi.");
                await openAppSettings();
              } else {
                // Jika belum diminta atau baru ditolak sekali, minta izin lagi.
                print("Meminta izin notifikasi...");
                await Permission.notification.request();
              }
            },
            icon: const Icon(
              IconlyLight.notification,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
