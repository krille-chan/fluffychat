import 'package:flutter/material.dart';

// ChangeNotifier, which will update its content
class ConnectionStateModel extends ChangeNotifier {
  String? _notifierMessage;

  String? get connectionTitle => _notifierMessage;

  void updateConnectionTitle(String message) {
    _notifierMessage = message;
    notifyListeners();
  }
}
