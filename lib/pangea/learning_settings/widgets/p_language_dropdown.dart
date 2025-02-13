// Flutter imports:

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/learning_settings/enums/l2_support_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'flag.dart';

class PLanguageDropdown extends StatefulWidget {
  final List<LanguageModel> languages;
  final LanguageModel? initialLanguage;
  final Function(LanguageModel) onChange;
  final bool showMultilingual;
  final bool isL2List;
  final String decorationText;
  final String? error;
  final String? Function(LanguageModel?)? validator;
  final Color? backgroundColor;

  const PLanguageDropdown({
    super.key,
    required this.languages,
    required this.onChange,
    required this.initialLanguage,
    this.showMultilingual = false,
    required this.decorationText,
    this.isL2List = false,
    this.error,
    this.validator,
    this.backgroundColor,
  });

  @override
  PLanguageDropdownState createState() => PLanguageDropdownState();
}

class PLanguageDropdownState extends State<PLanguageDropdown> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<LanguageModel> sortedLanguages = widget.languages;
    final String systemLang = Localizations.localeOf(context).languageCode;

    // if there is no initial language, the system language should be the first in the list
    // otherwise, display in alphabetical order
    final List<String> languagePriority =
        widget.initialLanguage == null ? [systemLang] : [];

    int sortLanguages(LanguageModel a, LanguageModel b) {
      final String aLang = a.langCode;
      final String bLang = b.langCode;
      if (aLang == bLang) return 0;

      final bool aIsPriority = languagePriority.contains(a.langCode);
      final bool bIsPriority = languagePriority.contains(b.langCode);
      if (!aIsPriority && !bIsPriority) {
        return a.getDisplayName(context)!.compareTo(b.getDisplayName(context)!);
      }

      if (aIsPriority && bIsPriority) {
        final int aPriority = languagePriority.indexOf(a.langCode);
        final int bPriority = languagePriority.indexOf(b.langCode);
        return aPriority - bPriority;
      }

      return aIsPriority ? -1 : 1;
    }

    sortedLanguages.sort((a, b) => sortLanguages(a, b));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField2<LanguageModel>(
          customButton: widget.initialLanguage != null &&
                  sortedLanguages.contains(widget.initialLanguage)
              ? LanguageDropDownEntry(
                  languageModel: widget.initialLanguage!,
                  isL2List: widget.isL2List,
                  isDropdown: true,
                )
              : null,
          decoration: InputDecoration(labelText: widget.decorationText),
          isExpanded: true,
          dropdownStyleData: DropdownStyleData(
            maxHeight: kIsWeb ? 500 : null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: widget.backgroundColor,
            ),
          ),
          items: [
            if (widget.showMultilingual)
              DropdownMenuItem(
                value: LanguageModel.multiLingual(context),
                child: LanguageDropDownEntry(
                  languageModel: LanguageModel.multiLingual(context),
                  isL2List: widget.isL2List,
                ),
              ),
            ...sortedLanguages.map(
              (languageModel) => DropdownMenuItem(
                value: languageModel,
                child: LanguageDropDownEntry(
                  languageModel: languageModel,
                  isL2List: widget.isL2List,
                ),
              ),
            ),
          ],
          onChanged: (value) => widget.onChange(value!),
          value: widget.initialLanguage,
          validator: (value) => widget.validator?.call(value),
          dropdownSearchData: DropdownSearchData(
            searchController: _searchController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: TextField(
                autofocus: true,
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              final displayName = item.value?.displayName.toLowerCase();
              if (displayName == null) return false;

              final search = searchValue.toLowerCase();
              return displayName.startsWith(search);
            },
          ),
          onMenuStateChange: (isOpen) {
            if (!isOpen) _searchController.clear();
          },
        ),
        AnimatedSize(
          duration: FluffyThemes.animationDuration,
          child: widget.error == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 5,
                  ),
                  child: Text(
                    widget.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class LanguageDropDownEntry extends StatelessWidget {
  final LanguageModel languageModel;
  final bool isL2List;
  final bool isDropdown;

  const LanguageDropDownEntry({
    super.key,
    required this.languageModel,
    required this.isL2List,
    this.isDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LanguageFlag(
          language: languageModel,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            children: [
              Text(
                languageModel.getDisplayName(context) ?? "",
                style: const TextStyle().copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 10),
              if (isL2List && languageModel.l2Support != L2SupportEnum.full)
                languageModel.l2Support.toBadge(context),
            ],
          ),
        ),
        if (isDropdown)
          Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
      ],
    );
  }
}
