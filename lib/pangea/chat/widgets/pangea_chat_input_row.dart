import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:emoji_picker_flutter/locales/default_emoji_set_locale.dart';

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/input_bar.dart';
import 'package:fluffychat/pages/chat/recording_input_row.dart';
import 'package:fluffychat/pages/chat/recording_view_model.dart';
import 'package:fluffychat/pangea/bot/utils/bot_room_extension.dart';
import 'package:fluffychat/pangea/choreographer/choreo_constants.dart';
import 'package:fluffychat/pangea/choreographer/choreographer_send_button.dart';
import 'package:fluffychat/pangea/choreographer/choreographer_state_extension.dart';
import 'package:fluffychat/pangea/choreographer/igc/start_igc_button.dart';
import 'package:fluffychat/pangea/languages/language_model.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PangeaChatInputRow extends StatelessWidget {
  final ChatController controller;

  const PangeaChatInputRow({required this.controller, super.key});

  LanguageModel? get activel1 =>
      controller.pangeaController.userController.userL1;
  LanguageModel? get activel2 =>
      controller.pangeaController.userController.userL2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const height = 48.0;
    final state = controller.choreographer.assistanceState;

    return Column(
      children: [
        CompositedTransformTarget(
          link: MatrixState.pAnyState
              .layerLinkAndKey(ChoreoConstants.inputTransformTargetKey)
              .link,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: RecordingViewModel(
              builder: (context, recordingViewModel) {
                if (recordingViewModel.isRecording) {
                  return RecordingInputRow(
                    state: recordingViewModel,
                    onSend: controller.onVoiceMessageSend,
                  );
                }
                return Row(
                  key: MatrixState.pAnyState
                      .layerLinkAndKey(ChoreoConstants.inputTransformTargetKey)
                      .key,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(width: 4),
                    ValueListenableBuilder(
                      valueListenable: controller.sendController,
                      builder: (context, text, _) {
                        final isBotDM = controller.room.isBotDM;
                        return AnimatedContainer(
                          duration: FluffyThemes.animationDuration,
                          curve: FluffyThemes.animationCurve,
                          height: height,
                          width: text.text.isEmpty ? height : 0,
                          alignment: Alignment.center,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(),
                          child: PopupMenuButton<AddPopupMenuActions>(
                            useRootNavigator: true,
                            icon: const Icon(Icons.add_outlined),
                            onSelected: controller.onAddPopupMenuButtonSelected,
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<AddPopupMenuActions>>[
                                  if (!isBotDM)
                                    PopupMenuItem(
                                      value: AddPopupMenuActions.poll,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: theme
                                              .colorScheme
                                              .onPrimaryContainer,
                                          foregroundColor: theme
                                              .colorScheme
                                              .primaryContainer,
                                          child: const Icon(
                                            Icons.poll_outlined,
                                          ),
                                        ),
                                        title: Text(L10n.of(context).startPoll),
                                        contentPadding: const EdgeInsets.all(0),
                                      ),
                                    ),
                                  if (!isBotDM)
                                    PopupMenuItem<AddPopupMenuActions>(
                                      value: AddPopupMenuActions.file,
                                      child: ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          child: Icon(
                                            Icons.attachment_outlined,
                                          ),
                                        ),
                                        title: Text(L10n.of(context).sendFile),
                                        contentPadding: const EdgeInsets.all(0),
                                      ),
                                    ),
                                  PopupMenuItem<AddPopupMenuActions>(
                                    value: AddPopupMenuActions.image,
                                    child: ListTile(
                                      leading: const CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        child: Icon(Icons.image_outlined),
                                      ),
                                      title: Text(L10n.of(context).sendImage),
                                      contentPadding: const EdgeInsets.all(0),
                                    ),
                                  ),
                                  if (PlatformInfos.isMobile)
                                    PopupMenuItem<AddPopupMenuActions>(
                                      value: AddPopupMenuActions.photoCamera,
                                      child: ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: Colors.purple,
                                          foregroundColor: Colors.white,
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                          ),
                                        ),
                                        title: Text(
                                          L10n.of(context).openCamera,
                                        ),
                                        contentPadding: const EdgeInsets.all(0),
                                      ),
                                    ),
                                  if (!isBotDM)
                                    if (PlatformInfos.isMobile)
                                      PopupMenuItem<AddPopupMenuActions>(
                                        value: AddPopupMenuActions.videoCamera,
                                        child: ListTile(
                                          leading: const CircleAvatar(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            child: Icon(
                                              Icons.videocam_outlined,
                                            ),
                                          ),
                                          title: Text(
                                            L10n.of(context).openVideoCamera,
                                          ),
                                          contentPadding: const EdgeInsets.all(
                                            0,
                                          ),
                                        ),
                                      ),
                                  if (!isBotDM)
                                    if (PlatformInfos.isMobile)
                                      PopupMenuItem<AddPopupMenuActions>(
                                        value: AddPopupMenuActions.location,
                                        child: ListTile(
                                          leading: const CircleAvatar(
                                            backgroundColor: Colors.brown,
                                            foregroundColor: Colors.white,
                                            child: Icon(
                                              Icons.gps_fixed_outlined,
                                            ),
                                          ),
                                          title: Text(
                                            L10n.of(context).shareLocation,
                                          ),
                                          contentPadding: const EdgeInsets.all(
                                            0,
                                          ),
                                        ),
                                      ),
                                ],
                          ),
                        );
                      },
                    ),
                    if (FluffyThemes.isColumnMode(context))
                      Container(
                        height: height,
                        width: height,
                        alignment: Alignment.center,
                        child: IconButton(
                          tooltip: L10n.of(context).emojis,
                          icon: PageTransitionSwitcher(
                            transitionBuilder:
                                (
                                  Widget child,
                                  Animation<double> primaryAnimation,
                                  Animation<double> secondaryAnimation,
                                ) {
                                  return SharedAxisTransition(
                                    animation: primaryAnimation,
                                    secondaryAnimation: secondaryAnimation,
                                    transitionType:
                                        SharedAxisTransitionType.scaled,
                                    fillColor: Colors.transparent,
                                    child: child,
                                  );
                                },
                            child: Icon(
                              controller.showEmojiPicker
                                  ? Icons.keyboard
                                  : Icons.add_reaction_outlined,
                              key: ValueKey(controller.showEmojiPicker),
                            ),
                          ),
                          onPressed: controller.emojiPickerAction,
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: InputBar(
                          room: controller.room,
                          minLines: 1,
                          maxLines: 8,
                          autofocus: !PlatformInfos.isMobile,
                          keyboardType: TextInputType.multiline,
                          textInputAction:
                              AppSettings.sendOnEnter.value == true &&
                                  PlatformInfos.isMobile
                              ? TextInputAction.send
                              : null,
                          onSubmitted: (_) => controller.onInputBarSubmitted(),
                          onSubmitImage: controller.sendImageFromClipBoard,
                          focusNode: controller.inputFocus,
                          controller: controller.sendController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(
                              left: 6.0,
                              right: 6.0,
                              bottom: 6.0,
                              top: 3.0,
                            ),
                            disabledBorder: InputBorder.none,
                            hintMaxLines: 1,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            filled: false,
                          ),
                          onChanged: controller.onInputBarChanged,
                          choreographer: controller.choreographer,
                          showMatch: (m) => controller.showNextMatch(match: m),
                          onFeedbackSubmitted:
                              controller.onWritingAssistanceFeedback,
                          suggestionEmojis:
                              getDefaultEmojiLocale(
                                AppSettings
                                        .emojiSuggestionLocale
                                        .value
                                        .isNotEmpty
                                    ? Locale(
                                        AppSettings.emojiSuggestionLocale.value,
                                      )
                                    : Localizations.localeOf(context),
                              ).fold(
                                [],
                                (emojis, category) =>
                                    emojis..addAll(category.emoji),
                              ),
                        ),
                      ),
                    ),
                    StartIGCButton(
                      key: ValueKey("start_igc_button_${controller.room.id}"),
                      onPressed: controller.onManualWritingAssistance,
                      choreographer: controller.choreographer,
                      initialState: state,
                      initialForegroundColor: state.stateColor(context),
                    ),
                    ValueListenableBuilder(
                      valueListenable: controller.sendController,
                      builder: (context, text, _) {
                        return Container(
                          height: height,
                          width: height,
                          alignment: Alignment.center,
                          child:
                              PlatformInfos.platformCanRecord &&
                                  text.text.isEmpty
                              ? IconButton(
                                  tooltip: L10n.of(context).voiceMessage,
                                  onPressed: () => recordingViewModel
                                      .startRecording(controller.room),
                                  style: IconButton.styleFrom(
                                    backgroundColor: theme.bubbleColor,
                                    foregroundColor: theme.onBubbleColor,
                                  ),
                                  icon: const Icon(Icons.mic_none_outlined),
                                )
                              : ChoreographerSendButton(controller: controller),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
