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
import 'package:fluffychat/pangea/lemmas/lemma.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_audio_button.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_meaning_widget.dart';
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

  /// Get the language code for the current lemma
  String? get _userL2 =>
      MatrixState.pangeaController.languageController.userL2?.langCode;

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
                child: _userL2 == null
                    ? Text(L10n.of(context).meaningNotFound)
                    : LemmaMeaningWidget(
                        constructUse: _construct,
                        langCode: _userL2!,
                        controller: null,
                        token: null,
                        style: Theme.of(context).textTheme.bodyLarge,
                        leading: TextSpan(
                          text: L10n.of(context).meaningSectionHeader,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text(
                      L10n.of(context).formSectionHeader,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      "  ${_formString ?? L10n.of(context).formsNotFound}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
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
