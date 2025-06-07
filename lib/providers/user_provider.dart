import 'package:flutter/material.dart';
import 'package:resif/service/database/firestore.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic> _userData = {};
  Map<String, dynamic> get userData => _userData;

  // Future<void> loadUserData(String uid) async {
  //   final data = await FirestoreService().getUserDataByUid(uid);
  //   _userData = data ?? {};
  //   notifyListeners();
  // }

  Future<void> loadUserDataByEmail(String email) async {
    final data = await FirestoreService().getUserDataByEmail(email);
    _userData = data ?? {};
    notifyListeners();
  }

  Future<void> updateUserData(String email, Map<String, dynamic> data) async {
    await FirestoreService().updateUserData(
      email,
      data['name'],
      data['phone'],
      data['department'],
      data['photoUrl'],
    );
    _userData = {..._userData, ...data};
    notifyListeners();
  }

  // Clear user data
  void clearUserData() {
    _userData = {};
    notifyListeners();
  }
}
