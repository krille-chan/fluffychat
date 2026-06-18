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
      ? DateFormat(
          'HH:mm',
          Localizations.localeOf(context).languageCode,
        ).format(this)
      : DateFormat(
          'h:mm a',
          Localizations.localeOf(context).languageCode,
        ).format(this);

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

  DateTime get dateOnly => DateTime(year, month, day);

  String localizedDate(BuildContext context) {
    final date = dateOnly;
    final now = DateTime.now().dateOnly;

    final sameYear = now.year == date.year;

    final sameDay = now == date;

    final sameWeek =
        sameYear &&
        !sameDay &&
        now.millisecondsSinceEpoch - millisecondsSinceEpoch <
            1000 * 60 * 60 * 24 * 7;

    if (sameDay) {
      return L10n.of(context).today;
    } else if (now.difference(date).inDays == 1) {
      return L10n.of(context).yesterday;
    } else if (sameWeek) {
      return DateFormat.EEEE(
        Localizations.localeOf(context).languageCode,
      ).format(date);
    } else if (sameYear) {
      return DateFormat.MMMMd(
        Localizations.localeOf(context).languageCode,
      ).format(date);
    }
    return DateFormat.yMMMMd(
      Localizations.localeOf(context).languageCode,
    ).format(date);
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

    // For Android this should always work.
    if (PlatformInfos.isAndroid) return mediaQuery24h;

    final locale = Localizations.localeOf(context).languageCode;
    // Note: I don't like maintaining my own list but I haven't found a way to
    // check this completely in Flutter side, as `alwaysUse24HourFormatOf()`
    // doesn't seem to work on web or desktop.
    const languages24Hour = {
      'de',
      'fr',
      'es',
      'it',
      'nl',
      'pt',
      'ru',
      'zh',
      'ja',
      'ko',
      'ar',
      'pl',
      'cs',
      'hu',
      'sv',
      'no',
      'da',
      'fi',
      'el',
      'he',
      'tr',
      'lt',
    };
    final l10n24h = languages24Hour.contains(locale);

    // https://github.com/krille-chan/fluffychat/pull/1457#discussion_r1836817914
    if (PlatformInfos.isIOS) {
      return mediaQuery24h || l10n24h;
    }

    return l10n24h;
  }
}
