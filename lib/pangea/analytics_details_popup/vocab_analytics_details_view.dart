import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup_content.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/lemmas/lemma_emoji_row.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_audio_button.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_text_with_audio_button.dart';
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

  /// Get the language code for the current lemma
  String? get _userL2 =>
      MatrixState.pangeaController.languageController.userL2?.langCode;

  @override
  Widget build(BuildContext context) {
    final Color textColor = (Theme.of(context).brightness != Brightness.light
        ? _construct.lemmaCategory.color(context)
        : _construct.lemmaCategory.darkColor(context));

    return AnalyticsDetailsViewContent(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          WordAudioButton(
            text: _construct.lemma,
            size: 24,
          ),
          const SizedBox(width: 4.0),
          Text(
            _construct.lemma,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: textColor,
                ),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MorphIcon(
            morphFeature: MorphFeaturesEnum.Pos,
            morphTag: _construct.category,
          ),
          const SizedBox(width: 4.0),
          Text(
            MorphFeaturesEnum.Pos.getDisplayCopy(context),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: textColor,
                ),
          ),
        ],
      ),
      headerContent: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          spacing: 8.0,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LemmaEmojiRow(
                  cId: constructId,
                  onTap: () => {},
                  removeCallback: null,
                ),
              ],
            ),
            Align(
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
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    L10n.of(context).formSectionHeader,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  ...MatrixState
                      .pangeaController.getAnalytics.constructListModel
                      .getConstructUsesByLemma(_construct.lemma)
                      .map((e) => e.uses)
                      .expand((element) => element)
                      .map((e) => e.form?.toLowerCase())
                      .toSet()
                      .whereType<String>()
                      .map(
                        (form) => WordTextWithAudioButton(
                          text: form,
                          textSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.fontSize ??
                              16,
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
      xpIcon: _construct.lemmaCategory.icon(12),
      constructId: constructId,
    );
  }
}
