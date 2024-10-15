// Flutter imports:

import 'package:fluffychat/pangea/enum/l2_support_enum.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:flutter/material.dart';

import '../../widgets/flag.dart';

class PLanguageDropdown extends StatefulWidget {
  final List<LanguageModel> languages;
  final LanguageModel initialLanguage;
  final Function(LanguageModel) onChange;
  final bool showMultilingual;
  final bool isL2List;

  const PLanguageDropdown({
    super.key,
    required this.languages,
    required this.onChange,
    required this.initialLanguage,
    this.showMultilingual = false,
    required this.isL2List,
  });

  @override
  State<PLanguageDropdown> createState() => _PLanguageDropdownState();
}

class _PLanguageDropdownState extends State<PLanguageDropdown> {
  @override
  Widget build(BuildContext context) {
    final List<LanguageModel> sortedLanguages = widget.languages;
    final String systemLang = Localizations.localeOf(context).languageCode;
    final List<String> languagePriority = [systemLang, 'en', 'es'];

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

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 0.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: DropdownButton<LanguageModel>(
          // Initial Value
          hint: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: LanguageFlag(
                  language: widget.initialLanguage,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.initialLanguage.getDisplayName(context) ?? "",
                style: const TextStyle().copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 14,
                ),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              ),
            ],
          ),

          isExpanded: true,
          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),
          underline: Container(),
          // Array list of items
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
        ),
      ),
    );
  }
}

class LanguageDropDownEntry extends StatelessWidget {
  final LanguageModel languageModel;
  final bool isL2List;
  const LanguageDropDownEntry({
    super.key,
    required this.languageModel,
    required this.isL2List,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LanguageFlag(
            language: languageModel,
          ),
          const SizedBox(width: 10),
          Text(
            languageModel.getDisplayName(context) ?? "",
            style: const TextStyle().copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 14,
            ),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 10),
          if (isL2List && languageModel.l2Support != L2SupportEnum.full)
            languageModel.l2Support.toBadge(context),
        ],
      ),
    );
  }
}
