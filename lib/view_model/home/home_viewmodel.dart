import 'package:flutter/foundation.dart';
import 'package:resif/models/rules.dart';
import 'package:resif/service/database/firestore.dart';

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
    fetchAllRules();
  }

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

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