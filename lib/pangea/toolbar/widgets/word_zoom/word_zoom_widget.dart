import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
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
import 'package:fluffychat/widgets/matrix.dart';

class WordZoomWidget extends StatelessWidget {
  final PangeaToken token;
  final PangeaMessageEvent messageEvent;
  final MessageOverlayController overlayController;

  const WordZoomWidget({
    super.key,
    required this.token,
    required this.messageEvent,
    required this.overlayController,
  });

  PangeaToken get _selectedToken => overlayController.selectedToken!;

  bool get hasEmojiActivity =>
      overlayController.practiceSelection?.hasActiveActivityByToken(
            ActivityTypeEnum.emoji,
            _selectedToken,
          ) ==
          true &&
      overlayController.hideWordCardContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      constraints: const BoxConstraints(
        minHeight: AppConfig.toolbarMinHeight - 8,
        maxHeight: AppConfig.toolbarMaxHeight - 8,
        maxWidth: AppConfig.toolbarMinWidth,
      ),
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
                      onTap: () => overlayController.updateSelectedSpan(
                        token.text,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
                Text(
                  token.text.content,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppConfig.yellowDark
                        : AppConfig.yellowLight,
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
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                            onPressed: () => controller.toggleEditMode(false),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                    if (MatrixState
                        .pangeaController.languageController.showTrancription)
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
                      controller: overlayController.widget.chatController,
                    ),
                    if (controller.error != null)
                      Text(
                        L10n.of(context).oopsSomethingWentWrong,
                        textAlign: TextAlign.center,
                      )
                    else if (controller.isLoading ||
                        controller.lemmaInfo == null)
                      const CircularProgressIndicator.adaptive()
                    else
                      GestureDetector(
                        onLongPress: () => controller.toggleEditMode(true),
                        onDoubleTap: () => controller.toggleEditMode(true),
                        child: token.lemma.text == token.text.content
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
    );
  }
}
