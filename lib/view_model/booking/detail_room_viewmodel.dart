import 'package:flutter/material.dart';
import 'package:resif/models/rooms.dart';

class DetailRoomViewModel extends ChangeNotifier {
  final Room room;
  late TabController tabController;

  DetailRoomViewModel({required this.room});

  // Inisialisasi TabController memerlukan TickerProvider dari View
  void init(TickerProvider vsync) {
    tabController = TabController(length: 2, vsync: vsync);
    // Tambahkan listener untuk memberi tahu View agar di-rebuild saat tab berubah
    tabController.addListener(() {
      notifyListeners();
    });
  }

  // State yang diturunkan (derived state) untuk judul header
  String get headerTitle {
    return tabController.index == 0
        ? '${room.code} Room Details'
        : 'Book ${room.code} Room';
  }

  // Pastikan untuk membersihkan controller saat ViewModel tidak lagi digunakan
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}