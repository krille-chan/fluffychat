import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/analytics_details_popup/lemma_usage_dots.dart';
import 'package:fluffychat/pangea/analytics_details_popup/lemma_use_example_messages.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_identifier.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_level_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';
import 'package:fluffychat/pangea/common/widgets/customized_svg.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/lemmas/lemma.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_repo.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_request.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_audio_button.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Displays information about selected lemma, and its usage
class VocabDetailsView extends StatelessWidget {
  final ConstructIdentifier constructId;

  const VocabDetailsView({
    super.key,
    required this.constructId,
  });

  ConstructUses get construct => constructId.constructUses;

  String? get emoji => PangeaToken(
        text: PangeaTokenText(
          offset: 0,
          content: construct.lemma,
          length: construct.lemma.length,
        ),
        lemma: Lemma(
          text: construct.lemma,
          saveVocab: false,
          form: construct.lemma,
        ),
        pos: construct.category,
        morph: {},
      ).getEmoji();

  /// Get string representing forms of the given lemma that have been used
  String? get formString {
    // Get possible forms of lemma
    final constructs = MatrixState
        .pangeaController.getAnalytics.constructListModel
        .getConstructUsesByLemma(construct.lemma);

    final forms = constructs
        .map((e) => e.uses)
        .expand((element) => element)
        .where((use) => use.useType.pointValue > 0)
        .map((e) => e.form?.toLowerCase())
        .toSet()
        .whereType<String>()
        .toList();

    if (forms.isEmpty) return null;
    return forms.join(", ");
  }

  /// Fetch the meaning of the lemma
  Future<String?> getDefinition(BuildContext context) async {
    final lang2 =
        MatrixState.pangeaController.languageController.userL2?.langCode;
    if (lang2 == null) {
      debugPrint("No lang2, cannot retrieve definition");
      return L10n.of(context).meaningNotFound;
    }

    final LemmaInfoRequest lemmaDefReq = LemmaInfoRequest(
      partOfSpeech: construct.category,
      lemmaLang: lang2,
      userL1:
          MatrixState.pangeaController.languageController.userL1?.langCode ??
              LanguageKeys.defaultLanguage,
      lemma: construct.lemma,
    );
    final LemmaInfoResponse res = await LemmaInfoRepo.get(lemmaDefReq);
    return res.meaning;
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).brightness != Brightness.light
        ? construct.lemmaCategory.color
        : construct.lemmaCategory.darkColor;

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 42,
              child: emoji == null
                  ? Tooltip(
                      message: L10n.of(context).noEmojiSelectedTooltip,
                      child: Icon(
                        Icons.add_reaction_outlined,
                        size: 24,
                        color: textColor.withValues(alpha: 0.7),
                      ),
                    )
                  : Text(emoji!),
            ),
            const SizedBox(width: 10.0),
            Text(
              construct.lemma,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 10.0),
            WordAudioButton(
              text: construct.lemma,
              ttsController: TtsController(),
              size: 24,
            ),
            const SizedBox(width: 24),
          ],
        ),
        centerTitle: true,
        // leading: SizedBox(
        //   width: 24,
        //   child: BackButton(onPressed: onClose),
        // ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Tooltip(
                    message: L10n.of(context).grammarCopyPOS,
                    child: Icon(
                      Symbols.toys_and_games,
                      size: 23,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    getGrammarCopy(
                          category: "pos",
                          lemma: construct.category,
                          context: context,
                        ) ??
                        construct.category,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: FutureBuilder(
                    future: getDefinition(context),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<String?> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        return RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: L10n.of(context).meaningSectionHeader,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              TextSpan(
                                text: "  ${snapshot.data!}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Wrap(
                          children: [
                            Text(
                              L10n.of(context).meaningSectionHeader,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: <TextSpan>[
                        TextSpan(
                          text: L10n.of(context).formSectionHeader,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "  ${formString ?? L10n.of(context).formsNotFound}",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  height: 3,
                  color: textColor.withValues(alpha: 0.7),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CustomizedSvg(
                      svgUrl: construct.lemmaCategory.svgURL,
                      colorReplacements: const {},
                      errorIcon: Text(
                        construct.lemmaCategory.emoji,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "${construct.points} XP",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LemmaUseExampleMessages(construct: construct),
              // Writing exercise section
              LemmaUsageDots(
                construct: construct,
                category: LearningSkillsEnum.writing,
                tooltip: L10n.of(context).writingExercisesTooltip,
                icon: Symbols.edit_square,
              ),
              // Listening exercise section
              LemmaUsageDots(
                construct: construct,
                category: LearningSkillsEnum.hearing,
                tooltip: L10n.of(context).listeningExercisesTooltip,
                icon: Symbols.hearing,
              ),
              // Reading exercise section
              LemmaUsageDots(
                construct: construct,
                category: LearningSkillsEnum.reading,
                tooltip: L10n.of(context).readingExercisesTooltip,
                icon: Symbols.two_pager,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
