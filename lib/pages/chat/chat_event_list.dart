import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message.dart';
import 'package:fluffychat/pages/chat/seen_by_row.dart';
import 'package:fluffychat/pages/chat/typing_indicators.dart';
import 'package:fluffychat/pages/user_bottom_sheet/user_bottom_sheet.dart';
import 'package:fluffychat/pangea/enum/instructions_enum.dart';
import 'package:fluffychat/utils/account_config.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/filtered_timeline_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatEventList extends StatelessWidget {
  final ChatController controller;
  const ChatEventList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = FluffyThemes.isColumnMode(context) ? 8.0 : 0.0;

    final events = controller.timeline!.events
        .where((event) => event.isVisibleInGui)
        .toList();
    final animateInEventIndex = controller.animateInEventIndex;

    // create a map of eventId --> index to greatly improve performance of
    // ListView's findChildIndexCallback
    final thisEventsKeyMap = <String, int>{};
    for (var i = 0; i < events.length; i++) {
      thisEventsKeyMap[events[i].eventId] = i;
    }

    final hasWallpaper =
        controller.room.client.applicationAccountConfig.wallpaperUrl != null;

    // #Pangea
    // after the chat event list mounts, if the user hasn't yet seen this instruction
    // card, attach it on top of the first shown message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final msgEvents = events
          .where(
            (event) => event.type == EventTypes.Message,
          )
          .toList();
      if (msgEvents.isEmpty) return;
      controller.pangeaController.instructions.showInstructionsPopup(
        context,
        InstructionsEnum.clickMessage,
        msgEvents[0].eventId,
      );
    });
    // Pangea#

    return SelectionArea(
      child: ListView.custom(
        padding: EdgeInsets.only(
          top: 16,
          bottom: 8,
          left: horizontalPadding,
          right: horizontalPadding,
        ),
        reverse: true,
        controller: controller.scrollController,
        keyboardDismissBehavior: PlatformInfos.isIOS
            ? ScrollViewKeyboardDismissBehavior.onDrag
            : ScrollViewKeyboardDismissBehavior.manual,
        childrenDelegate: SliverChildBuilderDelegate(
          (BuildContext context, int i) {
            // Footer to display typing indicator and read receipts:
            if (i == 0) {
              if (controller.timeline!.isRequestingFuture) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                );
              }
              if (controller.timeline!.canRequestFuture) {
                return Center(
                  child: IconButton(
                    onPressed: controller.requestFuture,
                    icon: const Icon(Icons.refresh_outlined),
                  ),
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SeenByRow(controller),
                  TypingIndicators(controller),
                ],
              );
            }

            // Request history button or progress indicator:
            if (i == events.length + 1) {
              if (controller.timeline!.isRequestingHistory) {
                // #Pangea
                // return const Center(
                //   child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                // );
                return const Column(
                  children: [
                    SizedBox(height: AppConfig.toolbarMaxHeight),
                    Center(
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    ),
                  ],
                );
                // Pangea#
              }
              if (controller.timeline!.canRequestHistory) {
                return Builder(
                  builder: (context) {
                    // #Pangea
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => controller.requestHistory);
                    // WidgetsBinding.instance
                    //     .addPostFrameCallback(controller.requestHistory);
                    return Column(
                      children: [
                        const SizedBox(height: AppConfig.toolbarMaxHeight),
                        Center(
                          child: IconButton(
                            onPressed: controller.requestHistory,
                            icon: const Icon(Icons.refresh_outlined),
                          ),
                        ),
                      ],
                    );
                    // return Center(
                    //   child: IconButton(
                    //     onPressed: controller.requestHistory,
                    //     icon: const Icon(Icons.refresh_outlined),
                    //   ),
                    // );
                    // Pangea#
                  },
                );
              }
              // #Pangea
              // return const SizedBox.shrink();
              return const SizedBox(height: AppConfig.toolbarMaxHeight);
              // Pangea#
            }
            i--;

            final event = events[i];
            final animateIn = animateInEventIndex != null &&
                controller.timeline!.events.length > animateInEventIndex &&
                event == controller.timeline!.events[animateInEventIndex];

            return AutoScrollTag(
              key: ValueKey(event.eventId),
              index: i,
              controller: controller.scrollController,
              child: Message(
                event,
                animateIn: animateIn,
                resetAnimateIn: () {
                  controller.animateInEventIndex = null;
                },
                onSwipe: () => controller.replyAction(replyTo: event),
                // #Pangea
                onInfoTab: (_) => {},
                // onInfoTab: controller.showEventInfo,
                // Pangea#
                onAvatarTab: (Event event) => showAdaptiveBottomSheet(
                  context: context,
                  builder: (c) => UserBottomSheet(
                    user: event.senderFromMemoryOrFallback,
                    outerContext: context,
                    onMention: () => controller.sendController.text +=
                        '${event.senderFromMemoryOrFallback.mention} ',
                  ),
                ),
                highlightMarker:
                    controller.scrollToEventIdMarker == event.eventId,
                // #Pangea
                // onSelect: controller.onSelectMessage,
                onSelect: (_) {},
                // Pangea#
                scrollToEventId: (String eventId) =>
                    controller.scrollToEventId(eventId),
                longPressSelect: controller.selectedEvents.isNotEmpty,
                // #Pangea
                immersionMode: controller.choreographer.immersionMode,
                controller: controller,
                isButton: event.eventId == controller.buttonEventID,
                // Pangea#
                selected: controller.selectedEvents
                    .any((e) => e.eventId == event.eventId),
                timeline: controller.timeline!,
                displayReadMarker:
                    i > 0 && controller.readMarkerEventId == event.eventId,
                nextEvent: i + 1 < events.length ? events[i + 1] : null,
                previousEvent: i > 0 ? events[i - 1] : null,
                avatarPresenceBackgroundColor:
                    hasWallpaper ? Colors.transparent : null,
              ),
            );
          },
          childCount: events.length + 2,
          findChildIndexCallback: (key) =>
              controller.findChildIndexCallback(key, thisEventsKeyMap),
        ),
      ),
    );
  }
}
