/*
 * Copyright (c) 2019 Zender & Kurtz GbR.
 *
 * Authors:
 *   Christian Pauly <krille@famedly.com>
 *   Marcel Radzio <mtrnord@famedly.com>
 *
 * This file is part of famedlysdk.
 *
 * famedlysdk is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * famedlysdk is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with famedlysdk.  If not, see <http://www.gnu.org/licenses/>.
 */

/// Used to localize and present time in a chat application manner.
class ChatTime {
  DateTime dateTime = DateTime.now();

  /// Insert with a timestamp [ts] which represents the milliseconds since
  /// the Unix epoch.
  ChatTime(DateTime ts) {
    if (ts != null) dateTime = ts;
  }

  /// Returns a ChatTime object which represents the current time.
  ChatTime.now() {
    dateTime = DateTime.now();
  }

  /// Returns [toTimeString()] if the ChatTime is today, the name of the week
  /// day if the ChatTime is this week and a date string else.
  String toString() {
    DateTime now = DateTime.now();

    bool sameYear = now.year == dateTime.year;

    bool sameDay =
        sameYear && now.month == dateTime.month && now.day == dateTime.day;

    bool sameWeek = sameYear &&
        !sameDay &&
        now.millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch <
            1000 * 60 * 60 * 24 * 7;

    if (sameDay) {
      return toTimeString();
    } else if (sameWeek) {
      switch (dateTime.weekday) {
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
      return "${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    }
    return "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }

  /// Returns the milliseconds since the Unix epoch.
  num toTimeStamp() {
    return dateTime.millisecondsSinceEpoch;
  }

  operator <(ChatTime other) {
    return this.toTimeStamp() < other.toTimeStamp();
  }

  operator >(ChatTime other) {
    return this.toTimeStamp() > other.toTimeStamp();
  }

  operator >=(ChatTime other) {
    return this.toTimeStamp() >= other.toTimeStamp();
  }

  operator <=(ChatTime other) {
    return this.toTimeStamp() <= other.toTimeStamp();
  }

  /// Two message events can belong to the same environment. That means that they
  /// don't need to display the time they were sent because they are close
  /// enaugh.
  static final minutesBetweenEnvironments = 5;

  /// Checks if two ChatTimes are close enough to belong to the same
  /// environment.
  bool sameEnvironment(ChatTime prevTime) {
    return toTimeStamp() - prevTime.toTimeStamp() <
        1000 * 60 * minutesBetweenEnvironments;
  }

  /// Returns a simple time String.
  String toTimeString() {
    return "${_z(dateTime.hour % 12)}:${_z(dateTime.minute)} ${dateTime.hour > 11 ? 'pm' : 'am'}";
  }

  /// If the ChatTime is today, this returns [toTimeString()], if not it also
  /// shows the date.
  String toEventTimeString() {
    DateTime now = DateTime.now();

    bool sameYear = now.year == dateTime.year;

    bool sameDay =
        sameYear && now.month == dateTime.month && now.day == dateTime.day;

    if (sameDay) return toTimeString();
    return "${toString()}, ${toTimeString()}";
  }

  static String _z(int i) => i < 10 ? "0${i.toString()}" : i.toString();
}
