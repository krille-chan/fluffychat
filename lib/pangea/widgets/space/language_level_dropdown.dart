import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/utils/language_level_copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class LanguageLevelDropdown extends StatelessWidget {
  final int? initialLevel;
  final void Function(int?)? onChanged;
  final String? Function(int?)? validator;

  const LanguageLevelDropdown({
    super.key,
    this.initialLevel,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      // Initial Value
      hint: Text(
        L10n.of(context)!.selectLanguageLevel,
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
      ),
      value: initialLevel,
      isExpanded: true,
      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),
      // Array list of items
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
      onChanged: onChanged,
      validator: validator,
    );
  }
}
