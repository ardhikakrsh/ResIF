import 'package:flutter/material.dart';
import 'package:resif/models/rooms.dart';

class DetailRoomViewModel extends ChangeNotifier {
  final Room room;
  late TabController tabController;

  DetailRoomViewModel({required this.room});

  void init(TickerProvider vsync) {
    tabController = TabController(length: 2, vsync: vsync);
    tabController.addListener(() {
      notifyListeners();
    });
  }

  String get headerTitle {
    return tabController.index == 0
        ? '${room.code} Room Details'
        : 'Book ${room.code} Room';
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}