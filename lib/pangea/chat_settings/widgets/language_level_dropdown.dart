import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/themes.dart';
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
    final l10n = L10n.of(context);

    return DropdownButtonFormField2<LanguageLevelTypeEnum>(
      customButton: initialLevel != null &&
              LanguageLevelTypeEnum.values.contains(initialLevel)
          ? CustomDropdownTextButton(text: initialLevel!.title(context))
          : null,
      menuItemStyleData: MenuItemStyleData(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        height: FluffyThemes.isColumnMode(context) ? 100.0 : 150.0,
      ),
      decoration: InputDecoration(
        labelText: l10n.cefrLevelLabel,
      ),
      isExpanded: true,
      dropdownStyleData: DropdownStyleData(
        maxHeight: kIsWeb ? 500 : null,
        decoration: BoxDecoration(
          color: backgroundColor ??
              Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
      items:
          LanguageLevelTypeEnum.values.map((LanguageLevelTypeEnum levelOption) {
        return DropdownMenuItem(
          value: levelOption,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(levelOption.title(context)),
              Flexible(
                child: Text(
                  levelOption.description(context),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: enabled
          ? (value) {
              if (value != null) onChanged?.call(value);
            }
          : null,
      value: initialLevel,
      validator: validator,
    );
  }
}
