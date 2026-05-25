// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

extension BeautifyStringExtension on String {
  String get beautifiedOneLine {
    var beautifiedStr = '';
    for (var i = 0; i < length; i++) {
      beautifiedStr += substring(i, i + 1);
      if (i % 4 == 3) {
        beautifiedStr += ' ';
      }
    }
    return beautifiedStr;
  }

  String get beautified {
    var beautifiedStr = '';
    for (var i = 0; i < length; i++) {
      beautifiedStr += substring(i, i + 1);
      if (i % 4 == 3) {
        beautifiedStr += ' ';
      }
      if (i % 16 == 15) {
        beautifiedStr += '\n';
      }
    }
    return beautifiedStr;
  }
}
