import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';

// TODO Use the icons that Khue is creating
IconData getIconForMorphFeature(String feature) {
  // Define a function to get the icon based on the universal dependency morphological feature (key)
  switch (feature.toLowerCase()) {
    case 'number':
      // google material 123 icon
      return Icons.format_list_numbered;
    case 'gender':
      return Icons.wc;
    case 'tense':
      return Icons.access_time;
    case 'mood':
      return Icons.mood;
    case 'person':
      return Icons.person;
    case 'case':
      return Icons.format_list_bulleted;
    case 'degree':
      return Icons.trending_up;
    case 'verbform':
      return Icons.text_format;
    case 'voice':
      return Icons.record_voice_over;
    case 'aspect':
      return Icons.aspect_ratio;
    case 'prontype':
      return Icons.text_fields;
    case 'numtype':
      return Icons.format_list_numbered;
    case 'poss':
      return Icons.account_balance;
    case 'reflex':
      return Icons.refresh;
    case 'foreign':
      return Icons.language;
    case 'abbr':
      return Icons.text_format;
    case 'nountype':
      return Symbols.abc;
    case 'pos':
      return Symbols.toys_and_games;
    case 'polarity':
      return Icons.swap_vert;
    case 'definite':
      return Icons.check_circle_outline;
    case 'prepcase':
      return Icons.location_on_outlined;
    case 'conjtype':
      return Icons.compare_arrows;
    default:
      return Icons.help_outline;
  }
}
