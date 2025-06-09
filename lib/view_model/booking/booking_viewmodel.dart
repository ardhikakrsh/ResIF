import 'package:flutter/material.dart';
import 'package:resif/models/rooms.dart';
import 'package:resif/service/database/firestore.dart';

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
    fetchRooms();
    searchController.addListener(_filterRooms);
  }

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> fetchRooms() async {
    _setState(ViewState.loading);
    try {
      _allRooms = await _db.fetchRooms();
      _filteredRooms = _allRooms;
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  void updateCategory(String category) {
    _selectedCategory = category;
    _filterRooms();
  }

  void _filterRooms() {
    final query = searchController.text.toLowerCase();

    var roomsByCategory = _selectedCategory == 'All'
        ? _allRooms
        : _allRooms
        .where((room) => room.category == _selectedCategory)
        .toList();

    if (query.isNotEmpty) {
      _filteredRooms = roomsByCategory.where((room) {
        final codeMatch = room.code.toLowerCase().contains(query);
        final nameMatch = room.name.toLowerCase().contains(query);
        return codeMatch || nameMatch;
      }).toList();
    } else {
      _filteredRooms = roomsByCategory;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    searchController.removeListener(_filterRooms);
    searchController.dispose();
    super.dispose();
  }
}