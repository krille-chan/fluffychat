// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
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

  /// Checks if two DateTimes are close enough to belong to the same
  /// environment.
  bool sameEnvironment(DateTime prevTime) =>
      difference(prevTime).abs() < const Duration(minutes: 3) &&
      sameDay(prevTime);

  bool sameDay(DateTime prevTime) =>
      prevTime.year == year && prevTime.month == month && prevTime.day == day;

  /// Returns a simple time String.
  String localizedTimeOfDay(BuildContext context) => use24HourFormat(context)
      ? DateFormat('HH:mm', L10n.of(context).localeName).format(this)
      : DateFormat('h:mm a', L10n.of(context).localeName).format(this);

  String localizedTimeOfDayShort(BuildContext context) {
    final now = DateTime.now();
    if (isAfter(now.subtract(const Duration(minutes: 10)))) {
      final minutes = now.difference(this).inMinutes;
      if (minutes == 0) {
        return 'gerade'; // TODO: Localize
      }
      return '${minutes}m'; // TODO: Localize
    }
    return localizedTimeOfDay(context);
  }

  /// Returns [localizedTimeOfDay()] if the ChatTime is today, the name of the week
  /// day if the ChatTime is this week and a date string else.
  String localizedTimeShort(BuildContext context) {
    final now = DateTime.now();

    final sameYear = now.year == year;

    final sameDay = sameYear && now.month == month && now.day == day;

    final sameWeek =
        sameYear &&
        !sameDay &&
        now.millisecondsSinceEpoch - millisecondsSinceEpoch <
            1000 * 60 * 60 * 24 * 7;

    if (sameDay) {
      return localizedTimeOfDay(context);
    } else if (sameWeek) {
      return DateFormat.E(
        Localizations.localeOf(context).languageCode,
      ).format(this);
    } else if (sameYear) {
      return DateFormat.MMMd(
        Localizations.localeOf(context).languageCode,
      ).format(this);
    }
    return DateFormat.yMMMd(
      Localizations.localeOf(context).languageCode,
    ).format(this);
  }

  String localizedDate(BuildContext context) {
    final now = DateTime.now();

    final sameYear = now.year == year;

    final sameDay = sameYear && now.month == month && now.day == day;

    final sameWeek =
        sameYear &&
        !sameDay &&
        now.millisecondsSinceEpoch - millisecondsSinceEpoch <
            1000 * 60 * 60 * 24 * 7;

    if (sameDay) {
      return L10n.of(context).today;
    } else if (now.difference(this).inDays == 1) {
      return L10n.of(context).yesterday;
    } else if (sameWeek) {
      return DateFormat.EEEE(
        Localizations.localeOf(context).languageCode,
      ).format(this);
    } else if (sameYear) {
      return DateFormat.MMMMd(
        Localizations.localeOf(context).languageCode,
      ).format(this);
    }
    return DateFormat.yMMMMd(
      Localizations.localeOf(context).languageCode,
    ).format(this);
  }

  /// If the DateTime is today, this returns [localizedTimeOfDay()], if not it also
  /// shows the date.
  /// TODO: Add localization
  String localizedTime(BuildContext context) {
    final now = DateTime.now();

    final sameYear = now.year == year;

    final sameDay = sameYear && now.month == month && now.day == day;

    if (sameDay) return localizedTimeOfDay(context);
    return L10n.of(context).dateAndTimeOfDay(
      localizedTimeShort(context),
      localizedTimeOfDay(context),
    );
  }

  /// Check if time needs to be in 24h format
  bool use24HourFormat(BuildContext context) {
    final mediaQuery24h = MediaQuery.alwaysUse24HourFormatOf(context);

    final l10n24h = L10n.of(context).alwaysUse24HourFormat == 'true';

    // https://github.com/krille-chan/fluffychat/pull/1457#discussion_r1836817914
    if (PlatformInfos.isAndroid) {
      return mediaQuery24h;
    } else if (PlatformInfos.isIOS) {
      return mediaQuery24h || l10n24h;
    }

    return l10n24h;
  }
}
