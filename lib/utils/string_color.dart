// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

extension StringColor on String {
  static final _colorSchemeCache = <String, ColorScheme>{};

  ColorScheme get colorScheme =>
      _colorSchemeCache[this] ??= ColorScheme.fromSeed(
        seedColor: _getColorLight(0.3),
        dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
      );

  Color _getColorLight(double light) {
    var number = 0.0;
    for (var i = 0; i < length; i++) {
      number += codeUnitAt(i);
    }
    number = (number % 12) * 25.5;
    return HSLColor.fromAHSL(0.75, number, 1, light).toColor();
  }
}
