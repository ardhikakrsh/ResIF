import 'package:flutter/foundation.dart';
import 'package:resif/models/booking.dart';
import 'package:resif/service/database/firestore.dart';

enum ViewState { idle, loading, success, error }

class HistoryViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  // State
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  List<BookingModel> _bookings = [];
  List<BookingModel> get bookings => _bookings;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  HistoryViewModel() {
    fetchBookings();
  }

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> fetchBookings() async {
    _setState(ViewState.loading);
    try {
      _bookings = await _firestoreService.fetchBookings();
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }
}