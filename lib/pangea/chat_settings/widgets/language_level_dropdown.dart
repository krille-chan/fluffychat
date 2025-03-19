import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/chat_settings/utils/language_level_copy.dart';
import 'package:fluffychat/pangea/common/widgets/dropdown_text_button.dart';
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
      customButton: initialLevel != null &&
              LanguageLevelTypeEnum.values.contains(initialLevel)
          ? CustomDropdownTextButton(
              text: LanguageLevelTextPicker.languageLevelText(
                context,
                initialLevel!,
              ),
            )
          : null,
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.zero, // Remove default padding
      ),
      decoration: InputDecoration(
        labelText: L10n.of(context).cefrLevelLabel,
      ),
      isExpanded: true,
      dropdownStyleData: DropdownStyleData(
        maxHeight: kIsWeb ? 500 : null,
        decoration: BoxDecoration(
          color: backgroundColor ??
              Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
      ),
      items:
          LanguageLevelTypeEnum.values.map((LanguageLevelTypeEnum levelOption) {
        return DropdownMenuItem(
          value: levelOption,
          child: DropdownTextButton(
            text: LanguageLevelTextPicker.languageLevelText(
              context,
              levelOption,
            ),
            isSelected: initialLevel == levelOption,
          ),
        );
      }).toList(),
      onChanged: enabled
          ? (value) => onChanged?.call(value as LanguageLevelTypeEnum)
          : null,
      value: initialLevel,
      validator: validator,
    );
  }
}
