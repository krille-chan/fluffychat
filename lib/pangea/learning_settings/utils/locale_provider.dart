import 'package:flutter/material.dart';

import 'package:intl/intl.dart' as intl;

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(String? value) {
    final split = value?.split('_');
    if (split == null ||
        split.isEmpty ||
        !intl.DateFormat.localeExists(split[0])) {
      _locale = null;
      notifyListeners();
      return;
    }

    _locale = Locale(split[0], split.length > 1 ? split[1] : null);
    notifyListeners();
  }
}
