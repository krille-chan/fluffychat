import 'package:flutter/material.dart';

// ChangeNotifier, which will update its content
class ConnectionStateModel extends ChangeNotifier {
  String? _notifierMessage;
  bool _loading = true;

  String? get connectionTitle => _notifierMessage;
  bool get loading => _loading;

  void updateConnectionTitle(String message) {
    _notifierMessage = message;
    notifyListeners();
  }

  // How to update _loading
  void updateLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  // Reset values
  void reset() {
    _notifierMessage = null;
    _loading = true;
    notifyListeners();
  }
}
