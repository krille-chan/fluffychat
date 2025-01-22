import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/chat_settings/utils/language_level_copy.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';

class LanguageLevelDropdown extends StatelessWidget {
  final int? initialLevel;
  final void Function(int?)? onChanged;
  final String? Function(int?)? validator;
  final bool enabled;

  const LanguageLevelDropdown({
    super.key,
    this.initialLevel,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      decoration: InputDecoration(labelText: L10n.of(context).cefrLevelLabel),
      hint: Text(
        L10n.of(context).selectLanguageLevel,
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
      ),
      value: initialLevel,
      items: LanguageLevelType.allInts.map((int levelOption) {
        return DropdownMenuItem(
          value: levelOption,
          child: Text(
            LanguageLevelTextPicker.languageLevelText(
              context,
              levelOption,
            ),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
    );
  }
}
