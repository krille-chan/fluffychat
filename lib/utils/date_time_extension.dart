import 'package:flutter/material.dart';

/// Provides extra functionality for formatting the time.
extension DateTimeExtension on DateTime {
  @Deprecated('Use [millisecondsSinceEpoch] instead.')
  num toTimeStamp() => this.millisecondsSinceEpoch;

  @deprecated
  String toTimeString() => localizedTimeOfDay(null);
  @deprecated
  String toEventTimeString() => localizedTime(null);

  operator <(DateTime other) {
    return this.millisecondsSinceEpoch < other.millisecondsSinceEpoch;
  }

  operator >(DateTime other) {
    return this.millisecondsSinceEpoch > other.millisecondsSinceEpoch;
  }

  operator >=(DateTime other) {
    return this.millisecondsSinceEpoch >= other.millisecondsSinceEpoch;
  }

  operator <=(DateTime other) {
    return this.millisecondsSinceEpoch <= other.millisecondsSinceEpoch;
  }

  /// Two message events can belong to the same environment. That means that they
  /// don't need to display the time they were sent because they are close
  /// enaugh.
  static final minutesBetweenEnvironments = 5;

  /// Checks if two DateTimes are close enough to belong to the same
  /// environment.
  bool sameEnvironment(DateTime prevTime) {
    return millisecondsSinceEpoch - prevTime.millisecondsSinceEpoch <
        1000 * 60 * minutesBetweenEnvironments;
  }

  /// Returns a simple time String.
  /// TODO: Add localization
  String localizedTimeOfDay(BuildContext context) {
    return "${_z(this.hour % 12)}:${_z(this.minute)} ${this.hour > 11 ? 'pm' : 'am'}";
  }

  /// Returns [localizedTimeOfDay()] if the ChatTime is today, the name of the week
  /// day if the ChatTime is this week and a date string else.
  String localizedTimeShort(BuildContext context) {
    DateTime now = DateTime.now();

    bool sameYear = now.year == this.year;

    bool sameDay = sameYear && now.month == this.month && now.day == this.day;

    bool sameWeek = sameYear &&
        !sameDay &&
        now.millisecondsSinceEpoch - this.millisecondsSinceEpoch <
            1000 * 60 * 60 * 24 * 7;

    if (sameDay) {
      return localizedTimeOfDay(context);
    } else if (sameWeek) {
      switch (this.weekday) {
        case 1:
          return "Monday";
        case 2:
          return "Tuesday";
        case 3:
          return "Wednesday";
        case 4:
          return "Thursday";
        case 5:
          return "Friday";
        case 6:
          return "Saturday";
        case 7:
          return "Sunday";
      }
    } else if (sameYear) {
      return "${this.month.toString().padLeft(2, '0')}-${this.day.toString().padLeft(2, '0')}";
    }
    return "${this.year.toString()}-${this.month.toString().padLeft(2, '0')}-${this.day.toString().padLeft(2, '0')}";
  }

  /// If the DateTime is today, this returns [localizedTimeOfDay()], if not it also
  /// shows the date.
  /// TODO: Add localization
  String localizedTime(BuildContext context) {
    DateTime now = DateTime.now();

    bool sameYear = now.year == this.year;

    bool sameDay = sameYear && now.month == this.month && now.day == this.day;

    if (sameDay) return localizedTimeOfDay(context);
    return "${localizedTimeShort(context)}, ${localizedTimeOfDay(context)}";
  }

  static String _z(int i) => i < 10 ? "0${i.toString()}" : i.toString();
}
