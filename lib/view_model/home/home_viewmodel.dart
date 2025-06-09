import 'package:flutter/foundation.dart';
import 'package:resif/models/rules.dart';
import 'package:resif/service/database/firestore.dart';

// Enum untuk merepresentasikan state dari UI dengan lebih jelas.
// Anda bisa memindahkan ini ke file terpisah jika digunakan di banyak ViewModel.
enum ViewState { idle, loading, success, error }

class HomeViewModel extends ChangeNotifier {
  final FirestoreService _db = FirestoreService();

  // State Properties
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  List<Rules> _rules = [];
  List<Rules> get rules => _rules;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  HomeViewModel() {
    // Secara otomatis mengambil data saat ViewModel pertama kali dibuat.
    fetchAllRules();
  }

  // Helper method untuk mengubah state dan memberi tahu listeners.
  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  // Method untuk mengambil semua data aturan dari Firestore.
  Future<void> fetchAllRules() async {
    _setState(ViewState.loading);
    try {
      _rules = await _db.fetchAllRules();
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }
}