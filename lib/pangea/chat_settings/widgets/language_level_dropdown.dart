import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/chat_settings/utils/language_level_copy.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';

class LanguageLevelDropdown extends StatelessWidget {
  final LanguageLevelTypeEnum? initialLevel;
  final Function(LanguageLevelTypeEnum)? onChanged;
  final FormFieldValidator<Object>? validator;
  final bool enabled;
  final Color? backgroundColor;

  const LanguageLevelDropdown({
    super.key,
    this.initialLevel = LanguageLevelTypeEnum.a1,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<LanguageLevelTypeEnum>(
      decoration: InputDecoration(labelText: L10n.of(context).cefrLevelLabel),
      hint: Text(
        L10n.of(context).selectLanguageLevel,
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
      ),
      value: initialLevel,
      items:
          LanguageLevelTypeEnum.values.map((LanguageLevelTypeEnum levelOption) {
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
      onChanged: enabled
          ? (value) => onChanged?.call(value as LanguageLevelTypeEnum)
          : null,
      validator: validator,
      dropdownStyleData: DropdownStyleData(
        maxHeight: kIsWeb ? 500 : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: backgroundColor ??
              Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
      ),
    );
  }
}
