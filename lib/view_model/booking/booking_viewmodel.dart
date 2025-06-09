// File: lib/view_model/booking/booking_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:resif/models/rooms.dart';
import 'package:resif/service/database/firestore.dart';

// Enum untuk merepresentasikan state dari UI dengan lebih jelas
enum ViewState { idle, loading, success, error }

class BookingViewModel extends ChangeNotifier {
  final FirestoreService _db = FirestoreService();

  // State
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  List<Room> _allRooms = [];
  List<Room> _filteredRooms = [];
  List<Room> get filteredRooms => _filteredRooms;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final TextEditingController searchController = TextEditingController();

  BookingViewModel() {
    // Panggil fetchRooms saat ViewModel pertama kali dibuat
    fetchRooms();
    // Tambahkan listener untuk memanggil filter setiap kali ada perubahan di search bar
    searchController.addListener(_filterRooms);
  }

  // Method untuk mengubah state dan memberi tahu listener
  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  // Mengambil data ruangan dari Firestore
  Future<void> fetchRooms() async {
    _setState(ViewState.loading);
    try {
      _allRooms = await _db.fetchRooms();
      _filteredRooms = _allRooms; // Awalnya, tampilkan semua ruangan
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  // Memperbarui kategori yang dipilih dan memfilter ulang
  void updateCategory(String category) {
    _selectedCategory = category;
    _filterRooms(); // Panggil filter setelah kategori berubah
  }

  // Logika utama untuk memfilter ruangan
  void _filterRooms() {
    final query = searchController.text.toLowerCase();

    // 1. Filter berdasarkan kategori
    var roomsByCategory = _selectedCategory == 'All'
        ? _allRooms
        : _allRooms
        .where((room) => room.category == _selectedCategory)
        .toList();

    // 2. Filter berdasarkan query pencarian
    if (query.isNotEmpty) {
      _filteredRooms = roomsByCategory.where((room) {
        final codeMatch = room.code.toLowerCase().contains(query);
        final nameMatch = room.name.toLowerCase().contains(query);
        return codeMatch || nameMatch;
      }).toList();
    } else {
      _filteredRooms = roomsByCategory;
    }

    // Beri tahu UI untuk update dengan data yang sudah difilter
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.removeListener(_filterRooms);
    searchController.dispose();
    super.dispose();
  }
}