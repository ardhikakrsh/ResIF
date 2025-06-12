import 'package:flutter/foundation.dart';
import 'package:resif/models/booking.dart';
import 'package:resif/models/rooms.dart';
import 'package:resif/service/database/firestore.dart';
import 'package:table_calendar/table_calendar.dart';

enum ViewState { idle, loading, success, error }

class AgendaViewModel extends ChangeNotifier {
  final FirestoreService db = FirestoreService();
  final Room room; // Simpan informasi ruangan

  // State
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  List<BookingModel> _bookings = [];
  List<BookingModel> get bookings => _bookings;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;

  AgendaViewModel({required this.room}) {
    fetchAgenda();
  }

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      notifyListeners();
      fetchAgenda();
    }
  }

  // Method untuk handle ganti bulan di kalender
  void onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
    notifyListeners();
  }

  Future<void> fetchAgenda() async {
    _setState(ViewState.loading);
    try {
      _bookings = await db.fetchBookingsForRoomByDate(room.code, _selectedDay);
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }
}
