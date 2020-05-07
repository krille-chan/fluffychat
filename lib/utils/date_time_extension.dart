import 'package:fluffychat/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Provides extra functionality for formatting the time.
extension DateTimeExtension on DateTime {
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
    return L10n.of(context).timeOfDay(_z(this.hour % 12), _z(this.hour),
        _z(this.minute), this.hour > 11 ? 'pm' : 'am');
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
          return L10n.of(context).monday;
        case 2:
          return L10n.of(context).tuesday;
        case 3:
          return L10n.of(context).wednesday;
        case 4:
          return L10n.of(context).thursday;
        case 5:
          return L10n.of(context).friday;
        case 6:
          return L10n.of(context).saturday;
        case 7:
          return L10n.of(context).sunday;
      }
    } else if (sameYear) {
      return L10n.of(context).dateWithoutYear(
          this.month.toString().padLeft(2, '0'),
          this.day.toString().padLeft(2, '0'));
    }
    return L10n.of(context).dateWithYear(
        this.year.toString(),
        this.month.toString().padLeft(2, '0'),
        this.day.toString().padLeft(2, '0'));
  }

  /// If the DateTime is today, this returns [localizedTimeOfDay()], if not it also
  /// shows the date.
  /// TODO: Add localization
  String localizedTime(BuildContext context) {
    DateTime now = DateTime.now();

    bool sameYear = now.year == this.year;

    bool sameDay = sameYear && now.month == this.month && now.day == this.day;

    if (sameDay) return localizedTimeOfDay(context);
    return L10n.of(context).dateAndTimeOfDay(
        localizedTimeShort(context), localizedTimeOfDay(context));
  }

  static String _z(int i) => i < 10 ? "0${i.toString()}" : i.toString();
}
