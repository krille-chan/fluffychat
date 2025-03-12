import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/gain_points_animation.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/lemmas/construct_xp_widget.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/emoji_practice_button.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_text_with_audio_button.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_meaning_widget.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_widget.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/morphs/morphological_list_item.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordZoomWidget extends StatelessWidget {
  final PangeaToken token;
  final PangeaMessageEvent messageEvent;
  final TtsController tts;
  final MessageOverlayController overlayController;

  const WordZoomWidget({
    super.key,
    required this.token,
    required this.messageEvent,
    required this.tts,
    required this.overlayController,
  });

  PangeaToken get _selectedToken => overlayController.selectedToken!;

  MessageMode get _mode => overlayController.toolbarMode;

  String? get _selectedMorphFeature => overlayController.selectedMorphFeature;

  void onEditDone() => overlayController.initializeTokensAndMode();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: AppConfig.toolbarMinHeight,
        maxHeight: AppConfig.toolbarMaxHeight,
        maxWidth: AppConfig.toolbarMinWidth,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const Positioned(
            child: PointsGainedAnimation(
              origin: AnalyticsUpdateOrigin.wordZoom,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    minHeight: 50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EmojiPracticeButton(
                        token: _selectedToken,
                        onPressed: () => overlayController.updateToolbarMode(
                          MessageMode.wordEmoji,
                        ),
                        isSelected: _mode == MessageMode.wordEmoji,
                      ),
                      Expanded(
                        child: LemmaWidget(
                          token: _selectedToken,
                          pangeaMessageEvent: messageEvent,
                          // onEdit: () => _setHideCenterContent(true),
                          onEdit: () {
                            debugPrint("what are we doing edits with?");
                          },
                          onEditDone: () {
                            debugPrint("what are we doing edits with?");
                            onEditDone();
                          },
                          tts: tts,
                        ),
                      ),
                      ConstructXpWidget(
                        id: token.vocabConstructID,
                        onTap: () => showDialog<AnalyticsPopupWrapper>(
                          context: context,
                          builder: (context) => AnalyticsPopupWrapper(
                            constructZoom: token.vocabConstructID,
                            view: ConstructTypeEnum.vocab,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(
                    minHeight: 50,
                  ),
                  alignment: Alignment.center,
                  child: LemmaMeaningWidget(
                    constructUse: token.vocabConstructID.constructUses,
                    langCode: MatrixState.pangeaController.languageController
                            .userL2?.langCodeShort ??
                        LanguageKeys.defaultLanguage,
                    token: overlayController.selectedToken!,
                    controller: overlayController,
                    style: DefaultTextStyle.of(context).style,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (!_selectedToken.doesLemmaTextMatchTokenText)
                      WordTextWithAudioButton(
                        text: _selectedToken.text.content,
                        textSize:
                            Theme.of(context).textTheme.titleMedium?.fontSize,
                      ),
                    ..._selectedToken.sortedMorphs.map(
                      (featureTagPair) => MorphologicalListItem(
                        onPressed: (feature) =>
                            overlayController.updateToolbarMode(
                          MessageMode.wordMorph,
                          feature,
                        ),
                        morphFeature: featureTagPair.key,
                        morphTag: featureTagPair.value,
                        isUnlocked: !overlayController.pangeaMessageEvent!
                            .shouldDoActivity(
                          token: token,
                          a: ActivityTypeEnum.morphId,
                          feature: featureTagPair.key,
                          tag: featureTagPair.value,
                        ),
                        isSelected: _selectedMorphFeature == featureTagPair.key,
                      ),
                    ),
                  ],
                ),
                // if (_selectedMorphFeature != null)
                //   MorphologicalCenterWidget(
                //     token: token,
                //     morphFeature: _selectedMorphFeature!,
                //     pangeaMessageEvent: messageEvent,
                //     overlayController: overlayController,
                //     onEditDone: onEditDone,
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
