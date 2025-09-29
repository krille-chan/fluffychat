import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/lemmas/construct_xp_widget.dart';
import 'package:fluffychat/pangea/lemmas/lemma_reaction_picker.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_widget.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_audio_button.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_meaning_builder.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/new_word_overlay.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordZoomWidget extends StatelessWidget {
  final PangeaTokenText token;
  final ConstructIdentifier construct;

  final String langCode;
  final VoidCallback onClose;

  final bool wordIsNew;
  final VoidCallback? onDismissNewWordOverlay;
  final Event? event;

  const WordZoomWidget({
    super.key,
    required this.token,
    required this.construct,
    required this.langCode,
    required this.onClose,
    this.wordIsNew = false,
    this.onDismissNewWordOverlay,
    this.event,
  });

  String get transformTargetId => "word-zoom-card-${token.uniqueKey}";

  LayerLink get layerLink =>
      MatrixState.pAnyState.layerLinkAndKey(transformTargetId).link;

  @override
  Widget build(BuildContext context) {
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
                            onTap: onClose,
                            child: const Icon(
                              Icons.close,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          token.content,
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
                        id: construct,
                        onTap: () => context.go(
                          "/rooms/analytics/${ConstructTypeEnum.vocab.string}/${construct.string}",
                        ),
                      ),
                    ],
                  ),
                  LemmaMeaningBuilder(
                    langCode: langCode,
                    constructId: construct,
                    builder: (context, controller) {
                      if (controller.editMode) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${L10n.of(context).pangeaBotIsFallible} ${L10n.of(context).whatIsMeaning(
                                construct.lemma,
                                construct.category,
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
                              .showTranscription)
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
                              child: construct.lemma.toLowerCase() ==
                                      token.content.toLowerCase()
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
                                          TextSpan(text: construct.lemma),
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
                overlayColor: overlayColor,
                transformTargetId: transformTargetId,
                onDismiss: onDismissNewWordOverlay,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
