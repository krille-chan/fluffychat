import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/widgets/word_audio_button.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/languages/language_model.dart';
import 'package:fluffychat/pangea/languages/p_language_store.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_widget.dart';
import 'package:fluffychat/pangea/phonetic_transcription/pt_v2_models.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance/new_word_overlay.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance/tokens_util.dart';
import 'package:fluffychat/pangea/toolbar/word_card/lemma_meaning_display.dart';
import 'package:fluffychat/pangea/toolbar/word_card/lemma_reaction_picker.dart';
import 'package:fluffychat/pangea/toolbar/word_card/message_unsubscribed_card.dart';
import 'package:fluffychat/pangea/toolbar/word_card/token_feedback_button.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordZoomWidget extends StatelessWidget {
  final PangeaTokenText token;
  final ConstructIdentifier construct;

  final String langCode;
  final VoidCallback? onClose;

  final Event? event;

  /// POS tag for PT v2 disambiguation (e.g. "VERB").
  final String pos;

  /// Morph features for PT v2 disambiguation (e.g. {"Tense": "Past"}).
  final Map<String, String>? morph;

  final bool enableEmojiSelection;
  final VoidCallback? onDismissNewWordOverlay;
  final Function(LemmaInfoResponse, PTRequest, PTResponse)? onFlagTokenInfo;
  final ValueNotifier<int>? reloadNotifier;
  final double? maxWidth;

  const WordZoomWidget({
    super.key,
    required this.token,
    required this.construct,
    required this.langCode,
    required this.pos,
    this.onClose,
    this.event,
    this.morph,
    this.enableEmojiSelection = true,
    this.onDismissNewWordOverlay,
    this.onFlagTokenInfo,
    this.reloadNotifier,
    this.maxWidth,
  });

  String get transformTargetId => "word-zoom-card-${token.uniqueKey}";

  LayerLink get layerLink =>
      MatrixState.pAnyState.layerLinkAndKey(transformTargetId).link;

  @override
  Widget build(BuildContext context) {
    final bool? subscribed =
        MatrixState.pangeaController.subscriptionController.isSubscribed;
    final overlayColor = Theme.of(context).scaffoldBackgroundColor;
    final showTranscript =
        MatrixState.pangeaController.userController.showTranscription;

    final Widget content = subscribed != null && !subscribed
        ? MessageUnsubscribedCard(token: token, onClose: onClose)
        : Stack(
            children: [
              Container(
                height: AppConfig.toolbarMaxHeight - 8,
                padding: const EdgeInsets.all(12.0),
                constraints: BoxConstraints(
                  maxWidth: maxWidth ?? AppConfig.toolbarMinWidth,
                ),
                child: CompositedTransformTarget(
                  link: layerLink,
                  child: Column(
                    spacing: 12.0,
                    children: [
                      SizedBox(
                        height: 40.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            onClose != null
                                ? IconButton(
                                    color: Theme.of(context).iconTheme.color,
                                    icon: const Icon(Icons.close),
                                    onPressed: onClose,
                                  )
                                : const SizedBox(width: 40.0, height: 40.0),
                            Flexible(
                              child: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 40.0,
                                ),
                                alignment: Alignment.center,
                                child: SelectableText(
                                  token.content,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? AppConfig.yellowDark
                                        : AppConfig.yellowLight,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            onFlagTokenInfo != null
                                ? TokenFeedbackButton(
                                    textLanguage:
                                        PLanguageStore.byLangCode(langCode) ??
                                        LanguageModel.unknown,
                                    constructId: construct,
                                    text: token.content,
                                    onFlagTokenInfo: onFlagTokenInfo!,
                                    messageInfo: event?.content ?? {},
                                  )
                                : const SizedBox(width: 40.0, height: 40.0),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 4.0,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            showTranscript
                                ? PhoneticTranscriptionWidget(
                                    text: token.content,
                                    textLanguage:
                                        PLanguageStore.byLangCode(langCode) ??
                                        LanguageModel.unknown,
                                    pos: pos,
                                    morph: morph,
                                    style: const TextStyle(fontSize: 14.0),
                                    iconSize: 24.0,
                                    maxLines: 2,
                                    reloadNotifier: reloadNotifier,
                                  )
                                : WordAudioButton(
                                    text: token.content,
                                    pos: pos,
                                    morph: morph,
                                    uniqueID: "lemma-content-${token.content}",
                                    langCode: langCode,
                                    iconSize: 24.0,
                                  ),
                            LemmaReactionPicker(
                              constructId: construct,
                              langCode: langCode,
                              event: event,
                              enabled: enableEmojiSelection,
                              form: token.content,
                            ),
                            LemmaMeaningDisplay(
                              langCode: langCode,
                              constructId: construct,
                              text: token.content,
                              messageInfo: event?.content ?? {},
                              reloadNotifier: reloadNotifier,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TokensUtil.isRecentlyCollected(token)
                  ? NewWordOverlay(
                      key: ValueKey(transformTargetId),
                      overlayColor: overlayColor,
                      transformTargetId: transformTargetId,
                      onDismiss: onDismissNewWordOverlay,
                    )
                  : const SizedBox.shrink(),
            ],
          );

    return GestureDetector(
      onTap: () {
        // Absorb taps to prevent them from propagating
        // to widgets below and closing the overlay.
      },
      child: Material(
        type: MaterialType.transparency,
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
            children: [content],
          ),
        ),
      ),
    );
  }
}
