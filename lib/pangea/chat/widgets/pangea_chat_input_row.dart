import 'dart:async';

import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/input_bar.dart';
import 'package:fluffychat/pangea/choreographer/widgets/send_button.dart';
import 'package:fluffychat/pangea/choreographer/widgets/start_igc_button.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/reading_assistance_input_bar.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/utils/error_reporter.dart';
import 'package:fluffychat/utils/platform_infos.dart';

class PangeaChatInputRow extends StatefulWidget {
  final ChatController controller;
  final MessageOverlayController? overlayController;

  const PangeaChatInputRow({
    required this.controller,
    this.overlayController,
    super.key,
  });

  @override
  State<PangeaChatInputRow> createState() => PangeaChatInputRowState();
}

class PangeaChatInputRowState extends State<PangeaChatInputRow> {
  StreamSubscription? _choreoSub;

  @override
  void initState() {
    // Rebuild the widget each time there's an update from choreo
    _choreoSub = widget.controller.choreographer.stateStream.stream.listen((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _choreoSub?.cancel();
    super.dispose();
  }

  ChatController get _controller => widget.controller;

  LanguageModel? get activel1 =>
      _controller.pangeaController.languageController.activeL1Model();
  LanguageModel? get activel2 =>
      _controller.pangeaController.languageController.activeL2Model();

  String hintText() {
    if (_controller.choreographer.itController.willOpen) {
      return L10n.of(context).buildTranslation;
    }
    return activel1 != null &&
            activel2 != null &&
            activel1!.langCode != LanguageKeys.unknownLanguage &&
            activel2!.langCode != LanguageKeys.unknownLanguage
        ? L10n.of(context).writeAMessageLangCodes(
            activel1!.displayName,
            activel2!.displayName,
          )
        : L10n.of(context).writeAMessage;
  }

  void _deleteErrorEventsAction() async {
    try {
      if (widget.overlayController == null ||
          widget.overlayController!.event.status != EventStatus.error) {
        throw Exception(
          'Tried to delete failed to send events but one event is not failed to sent',
        );
      }
      await widget.overlayController!.event.cancelSend();
      _controller.clearSelectedEvents();
    } catch (e, s) {
      ErrorReporter(
        context,
        'Error while delete error events action',
      ).onErrorCallback(e, s);
    }
  }

  void _sendAgainAction() {
    if (widget.overlayController == null) {
      ErrorHandler.logError(
        e: "No selected events in send again action",
        s: StackTrace.current,
        data: {"roomId": _controller.room.id},
      );
      _controller.clearSelectedEvents();
      return;
    }

    final event = widget.overlayController!.event;
    if (event.status.isError) {
      event.sendAgain();
    }

    final allEditEvents = event
        .aggregatedEvents(
          _controller.timeline!,
          RelationshipTypes.edit,
        )
        .where((e) => e.status.isError);
    for (final e in allEditEvents) {
      e.sendAgain();
    }

    _controller.clearSelectedEvents();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_controller.showEmojiPicker &&
        _controller.emojiPickerType == EmojiPickerType.reaction) {
      return const SizedBox.shrink();
    }
    const height = 48.0;

    return Column(
      children: [
        // if (!controller.selectMode) WritingAssistanceInputRow(controller),
        CompositedTransformTarget(
          link: _controller.choreographer.inputLayerLinkAndKey.link,
          child: Container(
            padding:
                EdgeInsets.all(widget.overlayController != null ? 8.0 : 0.0),
            decoration: BoxDecoration(
              color: widget.overlayController != null
                  ? Theme.of(context).cardColor
                  : null,
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: Row(
              key: widget.overlayController != null
                  ? null
                  : _controller.choreographer.inputLayerLinkAndKey.key,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: widget.overlayController != null
                  ? <Widget>[
                      if (widget.overlayController!.event.status ==
                          EventStatus.error)
                        SizedBox(
                          height: height,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.error,
                            ),
                            onPressed: _deleteErrorEventsAction,
                            child: Row(
                              children: <Widget>[
                                const Icon(Icons.delete),
                                Text(L10n.of(context).delete),
                              ],
                            ),
                          ),
                        ),
                      if (widget.overlayController!.event
                          .getDisplayEvent(_controller.timeline!)
                          .status
                          .isSent)
                        ReadingAssistanceInputBar(
                          _controller,
                          widget.overlayController!,
                        ),
                      if (widget.overlayController!.event
                          .getDisplayEvent(_controller.timeline!)
                          .status
                          .isError)
                        SizedBox(
                          height: height,
                          child: TextButton(
                            onPressed: _sendAgainAction,
                            child: Row(
                              children: <Widget>[
                                Text(L10n.of(context).tryToSendAgain),
                                const SizedBox(width: 4),
                                const Icon(Icons.send_outlined, size: 16),
                              ],
                            ),
                          ),
                        ),
                    ]
                  : <Widget>[
                      const SizedBox(width: 4),
                      AnimatedContainer(
                        duration: FluffyThemes.animationDuration,
                        curve: FluffyThemes.animationCurve,
                        height: height,
                        width: _controller.sendController.text.isEmpty
                            ? height
                            : 0,
                        alignment: Alignment.center,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(),
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.add_outlined),
                          onSelected: _controller.onAddPopupMenuButtonSelected,
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'file',
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  child: Icon(Icons.attachment_outlined),
                                ),
                                title: Text(L10n.of(context).sendFile),
                                contentPadding: const EdgeInsets.all(0),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'image',
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
                              PopupMenuItem<String>(
                                value: 'camera',
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.purple,
                                    foregroundColor: Colors.white,
                                    child: Icon(Icons.camera_alt_outlined),
                                  ),
                                  title: Text(L10n.of(context).openCamera),
                                  contentPadding: const EdgeInsets.all(0),
                                ),
                              ),
                            if (PlatformInfos.isMobile)
                              PopupMenuItem<String>(
                                value: 'camera-video',
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    child: Icon(Icons.videocam_outlined),
                                  ),
                                  title: Text(L10n.of(context).openVideoCamera),
                                  contentPadding: const EdgeInsets.all(0),
                                ),
                              ),
                            if (PlatformInfos.isMobile)
                              PopupMenuItem<String>(
                                value: 'location',
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.brown,
                                    foregroundColor: Colors.white,
                                    child: Icon(Icons.gps_fixed_outlined),
                                  ),
                                  title: Text(L10n.of(context).shareLocation),
                                  contentPadding: const EdgeInsets.all(0),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (FluffyThemes.isColumnMode(context))
                        Container(
                          height: height,
                          width: height,
                          alignment: Alignment.center,
                          child: IconButton(
                            tooltip: L10n.of(context).emojis,
                            icon: PageTransitionSwitcher(
                              transitionBuilder: (
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
                                _controller.showEmojiPicker
                                    ? Icons.keyboard
                                    : Icons.add_reaction_outlined,
                                key: ValueKey(_controller.showEmojiPicker),
                              ),
                            ),
                            onPressed: _controller.emojiPickerAction,
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: InputBar(
                            room: _controller.room,
                            minLines: 1,
                            maxLines: 8,
                            autofocus: !PlatformInfos.isMobile,
                            keyboardType: TextInputType.multiline,
                            textInputAction: AppConfig.sendOnEnter ??
                                    true && PlatformInfos.isMobile
                                ? TextInputAction.send
                                : null,
                            onSubmitted: (String value) =>
                                _controller.onInputBarSubmitted(value, context),
                            onSubmitImage: _controller.sendImageFromClipBoard,
                            focusNode: _controller.inputFocus,
                            controller: _controller.sendController,
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
                            onChanged: _controller.onInputBarChanged,
                            hintText: hintText(),
                          ),
                        ),
                      ),
                      StartIGCButton(
                        controller: _controller,
                      ),
                      Container(
                        height: height,
                        width: height,
                        alignment: Alignment.center,
                        child: PlatformInfos.platformCanRecord &&
                                _controller.sendController.text.isEmpty &&
                                !_controller.choreographer.itController.willOpen
                            ? FloatingActionButton.small(
                                tooltip: L10n.of(context).voiceMessage,
                                onPressed: _controller.voiceMessageAction,
                                elevation: 0,
                                heroTag: null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(height),
                                ),
                                backgroundColor: theme.bubbleColor,
                                foregroundColor: theme.onBubbleColor,
                                child: const Icon(Icons.mic_none_outlined),
                              )
                            : ChoreographerSendButton(controller: _controller),
                      ),
                    ],
            ),
          ),
        ),
      ],
    );
  }
}
