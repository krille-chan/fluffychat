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
  ThemePreset('Schellout', schelloutSeed),
  ThemePreset('Ocean', Color(0xFF0277BD)),
  ThemePreset('Forest', Color(0xFF2E7D32)),
  ThemePreset('Sunset', Color(0xFFE65100)),
  ThemePreset('Rosé', Color(0xFFC2185B)),
  ThemePreset('Slate', Color(0xFF546E7A)),
];

/// Seed for the Schellout preset — the dashboard's vermillion accent.
const Color schelloutSeed = Color(0xFFE05432);

/// Exact schellout-dashboard palette (globals.css vermillion-dark /
/// vermillion-light) overlaid on the seeded scheme when the Schellout
/// preset is active. Only the surfaces/accents the dashboard defines are
/// pinned; everything else keeps the seed-derived value.
ColorScheme applySchelloutPalette(ColorScheme base, Brightness brightness) {
  if (brightness == Brightness.dark) {
    // --background #0e1117, --foreground #e6edf3, --card #161b22,
    // --card-border #262c36, --accent #e05432, --accent-dim #1f1210,
    // --muted #7d8590
    return base.copyWith(
      primary: const Color(0xFFE05432),
      onPrimary: const Color(0xFFFFFFFF),
      primaryContainer: const Color(0xFF1F1210),
      onPrimaryContainer: const Color(0xFFE6EDF3),
      secondary: const Color(0xFFE05432),
      secondaryContainer: const Color(0xFF161B22),
      onSecondaryContainer: const Color(0xFFE6EDF3),
      tertiaryContainer: const Color(0xFF1F1210),
      onTertiaryContainer: const Color(0xFFE6EDF3),
      surface: const Color(0xFF0E1117),
      onSurface: const Color(0xFFE6EDF3),
      onSurfaceVariant: const Color(0xFF7D8590),
      surfaceContainerLowest: const Color(0xFF0B0E13),
      surfaceContainerLow: const Color(0xFF12161D),
      surfaceContainer: const Color(0xFF161B22),
      surfaceContainerHigh: const Color(0xFF1C222B),
      surfaceContainerHighest: const Color(0xFF262C36),
      outline: const Color(0xFF7D8590),
      outlineVariant: const Color(0xFF262C36),
    );
  }
  // --background #e8eaed, --foreground #1c2028, --card #f0f1f4,
  // --card-border #cdd1d8, --accent #c9401e, --accent-dim #f0d8d2,
  // --muted #565e68
  return base.copyWith(
    primary: const Color(0xFFC9401E),
    onPrimary: const Color(0xFFFFFFFF),
    primaryContainer: const Color(0xFFF0D8D2),
    onPrimaryContainer: const Color(0xFF1C2028),
    secondary: const Color(0xFFC9401E),
    secondaryContainer: const Color(0xFFF0F1F4),
    onSecondaryContainer: const Color(0xFF1C2028),
    tertiaryContainer: const Color(0xFFF0D8D2),
    onTertiaryContainer: const Color(0xFF1C2028),
    surface: const Color(0xFFE8EAED),
    onSurface: const Color(0xFF1C2028),
    onSurfaceVariant: const Color(0xFF565E68),
    surfaceContainerLowest: const Color(0xFFF8F9FA),
    surfaceContainerLow: const Color(0xFFF4F5F7),
    surfaceContainer: const Color(0xFFF0F1F4),
    surfaceContainerHigh: const Color(0xFFDDE0E5),
    surfaceContainerHighest: const Color(0xFFCDD1D8),
    outline: const Color(0xFF565E68),
    outlineVariant: const Color(0xFFCDD1D8),
  );
}
