import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(String? value) {
    if (value == null || value.isEmpty) {
      _locale = null;
      notifyListeners();
      return;
    }

    final split = value.split('-');
    _locale = Locale(split[0], split.length > 1 ? split[1] : null);
    notifyListeners();
  }
}
