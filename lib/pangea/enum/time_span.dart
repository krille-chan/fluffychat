import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

enum TimeSpan { day, week, month, sixmonths, year, forever }

extension TimeSpanFunctions on TimeSpan {
  String string(BuildContext context) {
    switch (this) {
      case TimeSpan.day:
        return L10n.of(context).oneday;
      case TimeSpan.week:
        return L10n.of(context).oneweek;
      case TimeSpan.month:
        return L10n.of(context).onemonth;
      case TimeSpan.sixmonths:
        return L10n.of(context).sixmonth;
      case TimeSpan.year:
        return L10n.of(context).oneyear;
      default:
        return "Invalid time span";
    }
  }

  int get numberOfIntervals {
    switch (this) {
      case TimeSpan.day:
        return 24;
      case TimeSpan.week:
        return 7;
      case TimeSpan.month:
        return DateTime.now().month == 2 ? 26 : 28;
      case TimeSpan.sixmonths:
        return 6;
      case TimeSpan.year:
        return 12;
      case TimeSpan.forever:
        return 0;
    }
  }

  DateTime get cutOffDate {
    switch (this) {
      case TimeSpan.day:
        return DateTime.now().subtract(Duration(hours: numberOfIntervals));
      case TimeSpan.week:
        return DateTime.now().subtract(Duration(days: numberOfIntervals));
      case TimeSpan.month:
        //PTODO - get onee month agoo
        return DateTime.now().subtract(Duration(days: numberOfIntervals));
      case TimeSpan.sixmonths:
        //PTODO - get six months ago
        return DateTime.now().subtract(Duration(days: numberOfIntervals * 30));
      case TimeSpan.year:
        return DateTime.now().subtract(const Duration(days: 365));
      case TimeSpan.forever:
        return DateTime(2020);
    }
  }
}
