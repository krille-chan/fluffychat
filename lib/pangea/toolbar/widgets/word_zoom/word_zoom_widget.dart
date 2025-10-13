import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/lemmas/lemma_reaction_picker.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_widget.dart';
import 'package:fluffychat/pangea/token_info_feedback/token_info_feedback_button.dart';
import 'package:fluffychat/pangea/token_info_feedback/token_info_feedback_request.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_unsubscribed_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_audio_button.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_meaning_builder.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/new_word_overlay.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordZoomWidget extends StatelessWidget {
  final PangeaTokenText token;
  final ConstructIdentifier construct;

  final String langCode;
  final VoidCallback? onClose;

  final bool wordIsNew;
  final VoidCallback? onDismissNewWordOverlay;
  final Event? event;

  final TokenInfoFeedbackRequestData? requestData;
  final PangeaMessageEvent? pangeaMessageEvent;

  const WordZoomWidget({
    super.key,
    required this.token,
    required this.construct,
    required this.langCode,
    this.onClose,
    this.wordIsNew = false,
    this.onDismissNewWordOverlay,
    this.event,
    this.requestData,
    this.pangeaMessageEvent,
  });

  String get transformTargetId => "word-zoom-card-${token.uniqueKey}";

  LayerLink get layerLink =>
      MatrixState.pAnyState.layerLinkAndKey(transformTargetId).link;

  @override
  Widget build(BuildContext context) {
    final bool? subscribed =
        MatrixState.pangeaController.subscriptionController.isSubscribed;
    final overlayColor = Theme.of(context).scaffoldBackgroundColor;

    final Widget content = subscribed != null && !subscribed
        ? const MessageUnsubscribedCard()
        : Stack(
            children: [
              Container(
                height: AppConfig.toolbarMaxHeight - 8,
                padding: const EdgeInsets.all(12.0),
                constraints: const BoxConstraints(
                  maxWidth: AppConfig.toolbarMinWidth,
                ),
                child: CompositedTransformTarget(
                  link: layerLink,
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 12.0,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            onClose != null
                                ? SizedBox(
                                    width: 24.0,
                                    height: 24.0,
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: onClose,
                                        child: const Icon(
                                          Icons.close,
                                          size: 16.0,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    width: 24.0,
                                    height: 24.0,
                                  ),
                            Flexible(
                              child: Text(
                                token.content,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? AppConfig.yellowDark
                                      : AppConfig.yellowLight,
                                ),
                              ),
                            ),
                            requestData != null && pangeaMessageEvent != null
                                ? TokenInfoFeedbackButton(
                                    requestData: requestData!,
                                    langCode: langCode,
                                    event: pangeaMessageEvent!,
                                    onUpdate: () {
                                      // close the zoom when updating
                                      if (onClose != null) {
                                        onClose!();
                                      }
                                    },
                                  )
                                : const SizedBox(
                                    width: 24.0,
                                    height: 24.0,
                                  ),
                          ],
                        ),
                        LemmaMeaningBuilder(
                          langCode: langCode,
                          constructId: construct,
                          builder: (context, controller) {
                            return Column(
                              spacing: 12.0,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (MatrixState.pangeaController
                                    .languageController.showTranscription)
                                  PhoneticTranscriptionWidget(
                                    text: token.content,
                                    textLanguage: PLanguageStore.byLangCode(
                                          langCode,
                                        ) ??
                                        LanguageModel.unknown,
                                    style: const TextStyle(fontSize: 14.0),
                                    iconSize: 24.0,
                                  )
                                else
                                  WordAudioButton(
                                    text: token.content,
                                    uniqueID: "lemma-content-${token.content}",
                                    langCode: langCode,
                                    iconSize: 24.0,
                                  ),
                                LemmaReactionPicker(
                                  emojis: controller.lemmaInfo?.emoji ?? [],
                                  loading: controller.isLoading,
                                  event: event,
                                ),
                                if (controller.error != null)
                                  ErrorIndicator(
                                    message: L10n.of(context)
                                        .errorFetchingDefinition,
                                    style: const TextStyle(fontSize: 14.0),
                                  )
                                else if (controller.isLoading ||
                                    controller.lemmaInfo == null)
                                  const CircularProgressIndicator.adaptive()
                                else
                                  construct.lemma.toLowerCase() ==
                                          token.content.toLowerCase()
                                      ? Text(
                                          controller.lemmaInfo!.meaning,
                                          style:
                                              const TextStyle(fontSize: 14.0),
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
                                              TextSpan(text: construct.lemma),
                                              const WidgetSpan(
                                                child: SizedBox(width: 8.0),
                                              ),
                                              const TextSpan(text: ":"),
                                              const WidgetSpan(
                                                child: SizedBox(width: 8.0),
                                              ),
                                              TextSpan(
                                                text: controller
                                                    .lemmaInfo!.meaning,
                                              ),
                                            ],
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
                      overlayColor: overlayColor,
                      transformTargetId: transformTargetId,
                      onDismiss: onDismissNewWordOverlay,
                    )
                  : const SizedBox.shrink(),
            ],
          );

    return Material(
      type: MaterialType.transparency,
      child: SelectionArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 4.0,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(AppConfig.borderRadius),
            ),
          ),
          height: AppConfig.toolbarMaxHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              content,
            ],
          ),
        ),
      ),
    );
  }
}
