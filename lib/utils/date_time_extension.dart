import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl/intl.dart';

/// Provides extra functionality for formatting the time.
extension DateTimeExtension on DateTime {
  bool operator <(DateTime other) {
    return millisecondsSinceEpoch < other.millisecondsSinceEpoch;
  }

  bool operator >(DateTime other) {
    return millisecondsSinceEpoch > other.millisecondsSinceEpoch;
  }

  bool operator >=(DateTime other) {
    return millisecondsSinceEpoch >= other.millisecondsSinceEpoch;
  }

  bool operator <=(DateTime other) {
    return millisecondsSinceEpoch <= other.millisecondsSinceEpoch;
  }

  /// Two message events can belong to the same environment. That means that they
  /// don't need to display the time they were sent because they are close
  /// enaugh.
  static const minutesBetweenEnvironments = 10;

  /// Checks if two DateTimes are close enough to belong to the same
  /// environment.
  bool sameEnvironment(DateTime prevTime) {
    return millisecondsSinceEpoch - prevTime.millisecondsSinceEpoch <
        1000 * 60 * minutesBetweenEnvironments;
  }

  /// Returns a simple time String.
  String localizedTimeOfDay(BuildContext context) =>
      L10n.of(context)!.alwaysUse24HourFormat == 'true'
          ? DateFormat('HH:mm', L10n.of(context)!.localeName).format(this)
          : DateFormat('h:mm a', L10n.of(context)!.localeName).format(this);

  /// Returns [localizedTimeOfDay()] if the ChatTime is today, the name of the week
  /// day if the ChatTime is this week and a date string else.
  String localizedTimeShort(BuildContext context) {
    final now = DateTime.now();

    final sameYear = now.year == year;

    final sameDay = sameYear && now.month == month && now.day == day;

    final sameWeek = sameYear &&
        !sameDay &&
        now.millisecondsSinceEpoch - millisecondsSinceEpoch <
            1000 * 60 * 60 * 24 * 7;

    if (sameDay) {
      return localizedTimeOfDay(context);
    } else if (sameWeek) {
      return DateFormat.EEEE(Localizations.localeOf(context).languageCode)
          .format(this);
    } else if (sameYear) {
      return L10n.of(context)!.dateWithoutYear(
        month.toString().padLeft(2, '0'),
        day.toString().padLeft(2, '0'),
      );
    }
    return L10n.of(context)!.dateWithYear(
      year.toString(),
      month.toString().padLeft(2, '0'),
      day.toString().padLeft(2, '0'),
    );
  }

  /// If the DateTime is today, this returns [localizedTimeOfDay()], if not it also
  /// shows the date.
  /// TODO: Add localization
  String localizedTime(BuildContext context) {
    final now = DateTime.now();

    final sameYear = now.year == year;

    final sameDay = sameYear && now.month == month && now.day == day;

    if (sameDay) return localizedTimeOfDay(context);
    return L10n.of(context)!.dateAndTimeOfDay(
      localizedTimeShort(context),
      localizedTimeOfDay(context),
    );
  }
}
