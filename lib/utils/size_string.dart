// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

extension SizeString on num {
  String get sizeString {
    var size = toDouble();
    if (size < 1000) {
      return '${size.round()} Bytes';
    }
    if (size < 1000 * 1000) {
      size = size / 1000;
      size = (size * 10).round() / 10;
      return '$size KB';
    }
    if (size < 1000 * 1000 * 1000) {
      size = size / 1000000;
      size = (size * 10).round() / 10;
      return '$size MB';
    }
    size = size / 1000 * 1000 * 1000 * 1000;
    size = (size * 10).round() / 10;
    return '$size GB';
  }
}
