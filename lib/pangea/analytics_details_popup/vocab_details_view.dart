import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup_content.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_identifier.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_level_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
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

  ConstructUses get _construct => constructId.constructUses;

  String? get _emoji => PangeaToken(
        text: PangeaTokenText(
          offset: 0,
          content: _construct.lemma,
          length: _construct.lemma.length,
        ),
        lemma: Lemma(
          text: _construct.lemma,
          saveVocab: false,
          form: _construct.lemma,
        ),
        pos: _construct.category,
        morph: {},
      ).getEmoji();

  /// Get string representing forms of the given lemma that have been used
  String? get _formString {
    // Get possible forms of lemma
    final constructs = MatrixState
        .pangeaController.getAnalytics.constructListModel
        .getConstructUsesByLemma(_construct.lemma);

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
  Future<String?> _getDefinition(BuildContext context) async {
    final lang2 =
        MatrixState.pangeaController.languageController.userL2?.langCode;
    if (lang2 == null) {
      debugPrint("No lang2, cannot retrieve definition");
      return L10n.of(context).meaningNotFound;
    }

    final LemmaInfoRequest lemmaDefReq = LemmaInfoRequest(
      partOfSpeech: _construct.category,
      lemmaLang: lang2,
      userL1:
          MatrixState.pangeaController.languageController.userL1?.langCode ??
              LanguageKeys.defaultLanguage,
      lemma: _construct.lemma,
    );
    final LemmaInfoResponse res = await LemmaInfoRepo.get(lemmaDefReq);
    return res.meaning;
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).brightness != Brightness.light
        ? _construct.lemmaCategory.color
        : _construct.lemmaCategory.darkColor;

    return AnalyticsDetailsViewContent(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 42,
            child: _emoji == null
                ? Tooltip(
                    message: L10n.of(context).noEmojiSelectedTooltip,
                    child: Icon(
                      Icons.add_reaction_outlined,
                      size: 24,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  )
                : Text(_emoji!),
          ),
          const SizedBox(width: 10.0),
          Text(
            _construct.lemma,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(width: 10.0),
          WordAudioButton(
            text: _construct.lemma,
            ttsController: TtsController(),
            size: 24,
          ),
        ],
      ),
      subtitle: Row(
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
                  lemma: _construct.category,
                  context: context,
                ) ??
                _construct.category,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                ),
          ),
        ],
      ),
      headerContent: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: FutureBuilder(
                  future: _getDefinition(context),
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
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                            "  ${_formString ?? L10n.of(context).formsNotFound}",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      xpIcon: CustomizedSvg(
        svgUrl: _construct.lemmaCategory.svgURL,
        colorReplacements: const {},
        errorIcon: Text(
          _construct.lemmaCategory.emoji,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      constructId: constructId,
    );
  }
}
