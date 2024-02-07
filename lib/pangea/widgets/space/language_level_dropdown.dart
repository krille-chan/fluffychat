import 'package:fluffychat/pangea/constants/language_level_type.dart';
import 'package:fluffychat/pangea/utils/language_level_copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class LanguageLevelDropdown extends StatelessWidget {
  final int? initialLevel;
  final void Function(int?)? onChanged;

  const LanguageLevelDropdown({
    super.key,
    this.initialLevel,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 0.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: DropdownButton(
          // Initial Value
          hint: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              initialLevel == null
                  ? L10n.of(context)!.selectLanguageLevel
                  : LanguageLevelTextPicker.languageLevelText(
                      context,
                      initialLevel!,
                    ),
              style: const TextStyle().copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 14,
              ),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          ),
          isExpanded: true,
          underline: Container(),
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
                style: const TextStyle().copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 14,
                ),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: onChanged,
        ),
      ),
    );
  }
}
