// Flutter imports:

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/enum/l2_support_enum.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import '../../widgets/flag.dart';

class PLanguageDropdown extends StatefulWidget {
  final List<LanguageModel> languages;
  final LanguageModel? initialLanguage;
  final Function(LanguageModel) onChange;
  final bool showMultilingual;
  final bool isL2List;
  final String? error;

  const PLanguageDropdown({
    super.key,
    required this.languages,
    required this.onChange,
    required this.initialLanguage,
    this.showMultilingual = false,
    required this.isL2List,
    this.error,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(36)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: DropdownButton<LanguageModel>(
            hint: Row(
              children: [
                const Icon(Icons.language_outlined),
                const SizedBox(width: 10),
                Text(
                  widget.isL2List
                      ? L10n.of(context).iWantToLearn
                      : L10n.of(context).myBaseLanguage,
                ),
              ],
            ),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            underline: Container(),
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
          ),
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
