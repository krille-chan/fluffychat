import 'dart:math';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message_content.dart';
import 'package:fluffychat/pages/chat/events/reply_content.dart';
import 'package:fluffychat/pangea/common/utils/async_state.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/common/widgets/feedback_dialog.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/layout/reading_assistance_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance/select_mode_buttons.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance/select_mode_controller.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance/stt_transcript_tokens.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/file_description.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class OverlayMessage extends StatelessWidget {
  final Event event;
  final MessageOverlayController overlayController;
  final ChatController controller;
  final Event? nextEvent;
  final Event? previousEvent;
  final Timeline timeline;

  final Animation<Size>? sizeAnimation;
  final double? messageWidth;
  final double? messageHeight;

  final bool isTransitionAnimation;
  final ReadingAssistanceMode? readingAssistanceMode;
  final String overlayKey;
  final bool canRefresh;

  const OverlayMessage(
    this.event, {
    required this.overlayController,
    required this.controller,
    required this.timeline,
    required this.messageWidth,
    required this.messageHeight,
    required this.overlayKey,
    this.nextEvent,
    this.previousEvent,
    this.sizeAnimation,
    this.isTransitionAnimation = false,
    this.readingAssistanceMode,
    this.canRefresh = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool ownMessage = event.senderId == Matrix.of(context).client.userID;

    final displayTime =
        event.type == EventTypes.RoomCreate ||
        nextEvent == null ||
        !event.originServerTs.sameEnvironment(nextEvent!.originServerTs);

    final nextEventSameSender =
        nextEvent != null &&
        {
          EventTypes.Message,
          EventTypes.Sticker,
          EventTypes.Encrypted,
        }.contains(nextEvent!.type) &&
        nextEvent!.senderId == event.senderId &&
        !displayTime;

    final previousEventSameSender =
        previousEvent != null &&
        {
          EventTypes.Message,
          EventTypes.Sticker,
          EventTypes.Encrypted,
        }.contains(previousEvent!.type) &&
        previousEvent!.senderId == event.senderId &&
        previousEvent!.originServerTs.sameEnvironment(event.originServerTs);

    final textColor = event.isActivityMessage
        ? ThemeData.light().colorScheme.onPrimary
        : ownMessage
        ? ThemeData.dark().colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    final linkColor = theme.brightness == Brightness.light
        ? theme.colorScheme.primary
        : ownMessage
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    final displayEvent = event.getDisplayEvent(timeline);
    const hardCorner = Radius.circular(4);
    const roundedCorner = Radius.circular(AppConfig.borderRadius);
    final borderRadius = BorderRadius.only(
      topLeft: !ownMessage && nextEventSameSender ? hardCorner : roundedCorner,
      topRight: ownMessage && nextEventSameSender ? hardCorner : roundedCorner,
      bottomLeft: !ownMessage && previousEventSameSender
          ? hardCorner
          : roundedCorner,
      bottomRight: ownMessage && previousEventSameSender
          ? hardCorner
          : roundedCorner,
    );

    var color = theme.colorScheme.surfaceContainerHigh;
    if (ownMessage) {
      color = displayEvent.status.isError
          ? Colors.redAccent
          : Color.alphaBlend(
              Colors.white.withAlpha(180),
              ThemeData.dark().colorScheme.primary,
            );
    }

    if (event.isActivityMessage) {
      color = theme.brightness == Brightness.dark
          ? theme.colorScheme.onSecondary
          : theme.colorScheme.primary;
    }

    final noBubble =
        ({
              MessageTypes.Video,
              MessageTypes.Image,
              MessageTypes.Sticker,
            }.contains(event.messageType) &&
            event.fileDescription == null &&
            !event.redacted) ||
        (event.messageType == MessageTypes.Text &&
            event.relationshipType == null &&
            event.onlyEmotes &&
            event.numberEmotes > 0 &&
            event.numberEmotes <= 3);

    final isSubscribed =
        MatrixState.pangeaController.subscriptionController.isSubscribed;

    final selectModeController = overlayController.selectModeController;

    final content = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      ),
      width: messageWidth,
      height: messageHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (event.inReplyToEventId(includingFallback: false) != null)
            FutureBuilder<Event?>(
              future: event.getReplyEvent(timeline),
              builder: (BuildContext context, snapshot) {
                final replyEvent = snapshot.hasData
                    ? snapshot.data!
                    : Event(
                        eventId: event.relationshipEventId!,
                        content: {'msgtype': 'm.text', 'body': '...'},
                        senderId: "",
                        type: 'm.room.message',
                        room: event.room,
                        status: EventStatus.sent,
                        originServerTs: DateTime.now(),
                      );
                return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: ReplyContent.borderRadius,
                    child: InkWell(
                      borderRadius: ReplyContent.borderRadius,
                      onTap: () =>
                          controller.scrollToEventId(replyEvent.eventId),
                      child: AbsorbPointer(
                        child: ReplyContent(
                          replyEvent,
                          ownMessage: ownMessage,
                          timeline: timeline,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          Flexible(
            child: MessageContent(
              displayEvent,
              textColor: textColor,
              linkColor: linkColor,
              borderRadius: borderRadius,
              timeline: timeline,
              pangeaMessageEvent: overlayController.pangeaMessageEvent,
              overlayController: overlayController,
              controller: controller,
              nextEvent: nextEvent,
              prevEvent: previousEvent,
              isTransitionAnimation: isTransitionAnimation,
              readingAssistanceMode: readingAssistanceMode,
              selected: true,
            ),
          ),
          if (event.hasAggregatedEvents(timeline, RelationshipTypes.edit))
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4.0,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: textColor.withAlpha(164),
                    size: 14,
                  ),
                  Text(
                    displayEvent.originServerTs.localizedTimeShort(context),
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      color: textColor.withAlpha(164),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );

    final maxWidth = min(
      FluffyThemes.columnWidth * 1.5,
      MediaQuery.widthOf(context) -
          (ownMessage ? 0 : Avatar.defaultSize) -
          32.0 -
          (FluffyThemes.isColumnMode(context)
              ? FluffyThemes.columnWidth + FluffyThemes.navRailWidth
              : 0.0),
    );

    final style = AppConfig.messageTextStyle(event, textColor);

    return Material(
      key: MatrixState.pAnyState.layerLinkAndKey(overlayKey).key,
      type: MaterialType.transparency,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: noBubble ? Colors.transparent : color,
          borderRadius: borderRadius,
        ),
        constraints: const BoxConstraints(
          maxWidth: FluffyThemes.columnWidth * 1.5,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MessageBubbleTranscription(
                controller: selectModeController,
                enabled:
                    event.messageType == MessageTypes.Audio &&
                    !event.redacted &&
                    isSubscribed != false,
                maxWidth: maxWidth,
                style: style,
                eventId: event.eventId,
                onTokenSelected: overlayController.onClickOverlayMessageToken,
                isTokenSelected: overlayController.isTokenSelected,
              ),
              sizeAnimation != null
                  ? AnimatedBuilder(
                      animation: sizeAnimation!,
                      builder: (context, child) {
                        return SizedBox(
                          height: sizeAnimation!.value.height,
                          width: sizeAnimation!.value.width,
                          child: content,
                        );
                      },
                    )
                  : content,
              _MessageSelectModeContent(
                controller: selectModeController,
                style: style,
                maxWidth: maxWidth,
                minWidth: messageWidth ?? 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageSelectModeContent extends StatelessWidget {
  final SelectModeController controller;
  final TextStyle style;
  final double maxWidth;
  final double minWidth;

  const _MessageSelectModeContent({
    required this.controller,
    required this.style,
    required this.maxWidth,
    required this.minWidth,
  });

  Future<void> onFlagTranslation(BuildContext context) async {
    final resp = await showDialog<String?>(
      context: context,
      builder: (context) => FeedbackDialog(
        title: L10n.of(context).translationFeedback,
        onSubmit: (feedback) => Navigator.of(context).pop(feedback),
      ),
    );

    if (resp == null || resp.isEmpty) {
      return;
    }

    await controller.fetchTranslation(feedback: resp);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        controller.selectedMode,
        controller.currentModeStateNotifier,
      ]),
      builder: (context, _) {
        final mode = controller.selectedMode.value;
        if (mode == null) {
          return const SizedBox();
        }

        final sub = MatrixState.pangeaController.subscriptionController;
        if (sub.isSubscribed == false) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ErrorIndicator(
              message: L10n.of(context).subscribeReadingAssistance,
              onTap: () => sub.showPaywall(context),
              style: style,
            ),
          );
        }

        if (![
          SelectMode.translate,
          SelectMode.speechTranslation,
        ].contains(mode)) {
          return const SizedBox();
        }

        final AsyncState<String> state = mode == SelectMode.translate
            ? controller.translationState.value
            : controller.speechTranslationState.value;

        return Container(
          padding: const EdgeInsets.all(12.0),
          constraints: BoxConstraints(
            minHeight: 40.0,
            maxWidth: maxWidth,
            minWidth: minWidth,
          ),
          child: switch (state) {
            AsyncLoading() => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator.adaptive(
                  backgroundColor: style.color,
                ),
              ],
            ),
            AsyncError(error: final _) => ErrorIndicator(
              message: L10n.of(context).translationError,
              style: style.copyWith(fontStyle: FontStyle.italic),
            ),
            AsyncLoaded(value: final value) => Row(
              spacing: 8.0,
              mainAxisSize: .min,
              mainAxisAlignment: .spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    value,
                    textScaler: TextScaler.noScaling,
                    style: style.copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
                if (mode == SelectMode.translate)
                  InkWell(
                    onTap: () => onFlagTranslation(context),
                    child: Icon(
                      Icons.flag_outlined,
                      color: style.color,
                      size: 16.0,
                    ),
                  ),
              ],
            ),
            _ => const SizedBox(),
          },
        );
      },
    );
  }
}

class _MessageBubbleTranscription extends StatelessWidget {
  final SelectModeController controller;
  final bool enabled;
  final double maxWidth;
  final TextStyle style;
  final String eventId;

  final Function(PangeaToken) onTokenSelected;
  final bool Function(PangeaToken) isTokenSelected;

  const _MessageBubbleTranscription({
    required this.controller,
    required this.enabled,
    required this.maxWidth,
    required this.style,
    required this.eventId,
    required this.onTokenSelected,
    required this.isTokenSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return const SizedBox();
    }

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ValueListenableBuilder(
          valueListenable: controller.transcriptionState,
          builder: (context, transcriptionState, _) {
            switch (transcriptionState) {
              case AsyncLoading():
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator.adaptive(
                      backgroundColor: style.color,
                    ),
                  ],
                );
              case AsyncError(error: final _):
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      L10n.of(context).transcriptionFailed,
                      textScaler: TextScaler.noScaling,
                      style: style.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ],
                );
              case AsyncLoaded(value: final transcription):
                return SingleChildScrollView(
                  child: Column(
                    spacing: 8.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SttTranscriptTokens(
                        eventId: eventId,
                        model: transcription,
                        style: style.copyWith(fontStyle: FontStyle.italic),
                        onClick: onTokenSelected,
                        isSelected: isTokenSelected,
                      ),
                      // if (MatrixState
                      //     .pangeaController.userController.showTranscription)
                      //   PhoneticTranscriptionWidget(
                      //     text: transcription.transcript.text,
                      //     textLanguage: PLanguageStore.byLangCode(
                      //           transcription.langCode,
                      //         ) ??
                      //         LanguageModel.unknown,
                      //     style: style,
                      //     iconColor: style.color,
                      //     onTranscriptionFetched: () =>
                      //         controller.contentChangedStream.add(true),
                      //   ),
                    ],
                  ),
                );
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
