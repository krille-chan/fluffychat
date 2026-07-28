// SPDX-FileCopyrightText: 2026 Joshua Schell
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// Named theme presets (schellout-chat fork). Names are deliberately
// hardcoded in English to avoid touching upstream l10n .arb files.
// See BRANDING.md.

import 'package:flutter/material.dart';

class ThemePreset {
  final String name;
  final Color color;

  const ThemePreset(this.name, this.color);
}

const List<ThemePreset> themePresets = [
  ThemePreset('Schellout', Color(0xFFE05432)),
  ThemePreset('Ocean', Color(0xFF0277BD)),
  ThemePreset('Forest', Color(0xFF2E7D32)),
  ThemePreset('Sunset', Color(0xFFE65100)),
  ThemePreset('Rosé', Color(0xFFC2185B)),
  ThemePreset('Slate', Color(0xFF546E7A)),
];
