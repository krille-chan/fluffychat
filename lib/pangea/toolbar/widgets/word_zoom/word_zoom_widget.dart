import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/lemmas/construct_xp_widget.dart';
import 'package:fluffychat/pangea/lemmas/lemma_emoji_row.dart';
import 'package:fluffychat/pangea/morphs/edit_morph_widget.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_audio_button.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_meaning_widget.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_widget.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/morphological_list_item.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordZoomWidget extends StatelessWidget {
  final PangeaToken token;
  final PangeaMessageEvent messageEvent;
  final TtsController tts;
  final MessageOverlayController overlayController;
  final Function(MorphFeaturesEnum?) editMorph;

  final MorphFeaturesEnum? selectedEditMorphFeature;

  const WordZoomWidget({
    super.key,
    required this.token,
    required this.messageEvent,
    required this.tts,
    required this.overlayController,
    required this.editMorph,
    required this.selectedEditMorphFeature,
  });

  PangeaToken get _selectedToken => overlayController.selectedToken!;

  void _onEditDone() => overlayController.initializeTokensAndMode();

  bool get hasEmojiActivity =>
      overlayController.practiceSelection?.hasActiveActivityByToken(
            ActivityTypeEnum.emoji,
            _selectedToken,
          ) ==
          true &&
      overlayController.hideWordCardContent;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: AppConfig.toolbarMinHeight,
        maxHeight: AppConfig.toolbarMaxHeight,
        maxWidth: AppConfig.toolbarMinWidth,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(
                minHeight: 40,
              ),
              color: Theme.of(context).colorScheme.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //@ggurdin - might need to play with size to properly center
                  IconButton(
                    onPressed: () =>
                        overlayController.onClickOverlayMessageToken(token),
                    icon: const Icon(Icons.close),
                  ),
                  LemmaWidget(
                    token: _selectedToken,
                    pangeaMessageEvent: messageEvent,
                    // onEdit: () => _setHideCenterContent(true),
                    onEdit: () {
                      debugPrint("what are we doing edits with?");
                    },
                    onEditDone: () {
                      debugPrint("what are we doing edits with?");
                      _onEditDone();
                    },
                    tts: tts,
                    overlayController: overlayController,
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
            const SizedBox(
              height: 8.0,
            ),
            if (selectedEditMorphFeature == null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      minHeight: 40,
                    ),
                    alignment: Alignment.center,
                    child: LemmaEmojiRow(
                      cId: _selectedToken.vocabConstructID,
                      onTapOverride: overlayController.hideWordCardContent &&
                              hasEmojiActivity
                          ? () => overlayController.updateToolbarMode(
                                MessageMode.wordEmoji,
                              )
                          : null,
                      isSelected: overlayController.toolbarMode ==
                          MessageMode.wordEmoji,
                      emojiSetCallback: () => overlayController.setState(() {}),
                      shouldShowEmojis: !hasEmojiActivity,
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 8.0,
            ),
            if (selectedEditMorphFeature == null)
              Container(
                constraints: const BoxConstraints(
                  minHeight: 40,
                ),
                alignment: Alignment.center,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    LemmaMeaningWidget(
                      constructUse: token.vocabConstructID.constructUses,
                      langCode: MatrixState.pangeaController.languageController
                              .userL2?.langCodeShort ??
                          LanguageKeys.defaultLanguage,
                      token: overlayController.selectedToken!,
                      controller: overlayController,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              )
            else
              EditMorphWidget(
                token: token,
                pangeaMessageEvent: overlayController.pangeaMessageEvent!,
                morphFeature: selectedEditMorphFeature!,
                onClose: () {
                  editMorph(null);
                  overlayController.setState(() {});
                },
              ),
            const SizedBox(
              height: 8.0,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (!_selectedToken.doesLemmaTextMatchTokenText) ...[
                  Text(
                    _selectedToken.text.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  WordAudioButton(
                    text: _selectedToken.text.content,
                    isSelected:
                        MessageMode.listening == overlayController.toolbarMode,
                    baseOpacity: 0.4,
                    callbackOverride: overlayController.hideWordCardContent &&
                            overlayController.practiceSelection
                                    ?.hasActiveActivityByToken(
                                  MessageMode.listening.associatedActivityType!,
                                  _selectedToken,
                                ) ==
                                true &&
                            overlayController.hideWordCardContent
                        ? () => overlayController
                            .updateToolbarMode(MessageMode.listening)
                        : null,
                    uniqueID: "word-zoom-audio-${_selectedToken.text.content}",
                    langCode: overlayController
                        .pangeaMessageEvent?.messageDisplayLangCode,
                  ),
                ],
                ..._selectedToken.morphsBasicallyEligibleForPracticeByPriority
                    .map(
                  (cId) => MorphologicalListItem(
                    morphFeature: MorphFeaturesEnumExtension.fromString(
                      cId.category,
                    ),
                    token: _selectedToken,
                    overlayController: overlayController,
                    editMorph: () => editMorph(
                      MorphFeaturesEnumExtension.fromString(cId.category),
                    ),
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
    );
  }
}
