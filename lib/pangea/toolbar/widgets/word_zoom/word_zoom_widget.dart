import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/lemmas/construct_xp_widget.dart';
import 'package:fluffychat/pangea/lemmas/lemma_reaction_picker.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_widget.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_audio_button.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_meaning_builder.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/new_word_overlay.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordZoomWidget extends StatelessWidget {
  final PangeaToken token;
  final PangeaMessageEvent messageEvent;
  final MessageOverlayController overlayController;
  final bool wordIsNew;

  const WordZoomWidget({
    super.key,
    required this.token,
    required this.messageEvent,
    required this.overlayController,
    required this.wordIsNew,
  });

  PangeaToken get _selectedToken => overlayController.selectedToken!;

  bool get hasEmojiActivity =>
      overlayController.practiceSelection?.hasActiveActivityByToken(
            ActivityTypeEnum.emoji,
            _selectedToken,
          ) ==
          true &&
      overlayController.hideWordCardContent;

  String get transformTargetId => "newer-word-overlay-${token.text.uniqueKey}";

  LayerLink get layerLink =>
      MatrixState.pAnyState.layerLinkAndKey(transformTargetId).link;

  @override
  Widget build(BuildContext context) {
    // final GlobalKey cardKey = MatrixState.pAnyState
    //     .layerLinkAndKey("word-zoom-card-${token.text.uniqueKey}")
    //     .key;
    final overlayColor = Theme.of(context).scaffoldBackgroundColor;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          constraints: const BoxConstraints(
            minHeight: AppConfig.toolbarMinHeight - 8,
            maxHeight: AppConfig.toolbarMaxHeight - 8,
            maxWidth: AppConfig.toolbarMinWidth,
          ),
          child: CompositedTransformTarget(
            link: layerLink,
            child: SingleChildScrollView(
              child: Column(
                spacing: 12.0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () =>
                                overlayController.updateSelectedSpan(null),
                            child: const Icon(
                              Icons.close,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          token.text.content,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? AppConfig.yellowDark
                                    : AppConfig.yellowLight,
                          ),
                        ),
                      ),
                      ConstructXpWidget(
                        id: token.vocabConstructID,
                        onTap: () => context.go(
                          "/rooms/analytics?mode=vocab",
                          extra: token.vocabConstructID,
                        ),
                      ),
                    ],
                  ),
                  LemmaMeaningBuilder(
                    langCode: messageEvent.messageDisplayLangCode,
                    constructId: token.vocabConstructID,
                    builder: (context, controller) {
                      if (controller.editMode) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${L10n.of(context).pangeaBotIsFallible} ${L10n.of(context).whatIsMeaning(
                                token.vocabConstructID.lemma,
                                token.vocabConstructID.category,
                              )}",
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                minLines: 1,
                                maxLines: 3,
                                controller: controller.controller,
                                decoration: InputDecoration(
                                  hintText: controller.lemmaInfo?.meaning,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      controller.toggleEditMode(false),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                  ),
                                  child: Text(L10n.of(context).cancel),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () => controller.controller.text !=
                                              controller.lemmaInfo?.meaning &&
                                          controller.controller.text.isNotEmpty
                                      ? controller.editLemmaMeaning(
                                          controller.controller.text,
                                        )
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                  ),
                                  child: Text(L10n.of(context).saveChanges),
                                ),
                              ],
                            ),
                          ],
                        );
                      }

                      return Column(
                        spacing: 12.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (MatrixState.pangeaController.languageController
                              .showTrancription)
                            PhoneticTranscriptionWidget(
                              text: token.text.content,
                              textLanguage: PLanguageStore.byLangCode(
                                    messageEvent.messageDisplayLangCode,
                                  ) ??
                                  LanguageModel.unknown,
                              style: const TextStyle(fontSize: 14.0),
                              iconSize: 24.0,
                            )
                          else
                            WordAudioButton(
                              text: token.text.content,
                              uniqueID: "lemma-content-${token.text.content}",
                              langCode: messageEvent.messageDisplayLangCode,
                              iconSize: 24.0,
                            ),
                          LemmaReactionPicker(
                            cId: _selectedToken.vocabConstructID,
                            event: messageEvent.event,
                            controller: overlayController.widget.chatController,
                          ),
                          if (controller.error != null)
                            ErrorIndicator(
                              message: L10n.of(context).errorFetchingDefinition,
                              style: const TextStyle(fontSize: 14.0),
                            )
                          else if (controller.isLoading ||
                              controller.lemmaInfo == null)
                            const CircularProgressIndicator.adaptive()
                          else
                            GestureDetector(
                              onLongPress: () =>
                                  controller.toggleEditMode(true),
                              onDoubleTap: () =>
                                  controller.toggleEditMode(true),
                              child: token.lemma.text.toLowerCase() ==
                                      token.text.content.toLowerCase()
                                  ? Text(
                                      controller.lemmaInfo!.meaning,
                                      style: const TextStyle(fontSize: 14.0),
                                      textAlign: TextAlign.center,
                                    )
                                  : RichText(
                                      text: TextSpan(
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .copyWith(
                                              fontSize: 14.0,
                                            ),
                                        children: [
                                          TextSpan(text: token.lemma.text),
                                          const WidgetSpan(
                                            child: SizedBox(width: 8.0),
                                          ),
                                          const TextSpan(text: ":"),
                                          const WidgetSpan(
                                            child: SizedBox(width: 8.0),
                                          ),
                                          TextSpan(
                                            text: controller.lemmaInfo!.meaning,
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        wordIsNew
            ? NewWordOverlay(
                key: ValueKey(transformTargetId),
                token: token,
                overlayColor: overlayColor,
                overlayController: overlayController,
                transformTargetId: transformTargetId,
                //cardKey: cardKey,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
