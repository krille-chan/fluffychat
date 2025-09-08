import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message.dart';
import 'package:fluffychat/pages/chat/seen_by_row.dart';
import 'package:fluffychat/pages/chat/typing_indicators.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_user_summaries_widget.dart';
import 'package:fluffychat/utils/account_config.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/filtered_timeline_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';

class ChatEventList extends StatelessWidget {
  final ChatController controller;

  const ChatEventList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final timeline = controller.timeline;

    if (timeline == null) {
      return const Center(child: CupertinoActivityIndicator());
    }
    final theme = Theme.of(context);

    final colors = [
      theme.secondaryBubbleColor,
      theme.bubbleColor,
    ];

    final horizontalPadding = FluffyThemes.isColumnMode(context) ? 8.0 : 0.0;

    final events = timeline.events.filterByVisibleInGui();
    final animateInEventIndex = controller.animateInEventIndex;

    // create a map of eventId --> index to greatly improve performance of
    // ListView's findChildIndexCallback
    final thisEventsKeyMap = <String, int>{};
    for (var i = 0; i < events.length; i++) {
      thisEventsKeyMap[events[i].eventId] = i;
    }

    final hasWallpaper =
        controller.room.client.applicationAccountConfig.wallpaperUrl != null;

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
              if (timeline.isRequestingFuture) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                );
              }
              if (timeline.canRequestFuture) {
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
            // #Pangea
            // if (i == events.length + 1) {
            if (i == events.length + 2) {
              // Pangea#
              if (timeline.isRequestingHistory) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                );
              }
              if (timeline.canRequestHistory) {
                return Builder(
                  builder: (context) {
                    // #Pangea
                    // WidgetsBinding.instance
                    //     .addPostFrameCallback(controller.requestHistory);
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => controller.requestHistory(),
                    );
                    // Pangea#
                    return Center(
                      child: IconButton(
                        onPressed: controller.requestHistory,
                        icon: const Icon(Icons.refresh_outlined),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            }

            // #Pangea
            if (i == 1) {
              return ActivityUserSummaries(controller: controller);
            }
            // Pangea#

            // #Pangea
            // i--;
            i = i - 2;
            // Pangea#

            // The message at this index:
            final event = events[i];
            final animateIn = animateInEventIndex != null &&
                timeline.events.length > animateInEventIndex &&
                event == timeline.events[animateInEventIndex];

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
                onMention: () => controller.sendController.text +=
                    '${event.senderFromMemoryOrFallback.mention} ',
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
                singleSelected:
                    controller.selectedEvents.singleOrNull?.eventId ==
                        event.eventId,
                onEdit: () => controller.editSelectedEventAction(),
                timeline: timeline,
                displayReadMarker:
                    i > 0 && controller.readMarkerEventId == event.eventId,
                nextEvent: i + 1 < events.length ? events[i + 1] : null,
                previousEvent: i > 0 ? events[i - 1] : null,
                wallpaperMode: hasWallpaper,
                scrollController: controller.scrollController,
                colors: colors,
              ),
            );
          },
          // #Pangea
          // childCount: events.length + 2,
          childCount: events.length + 3,
          // Pangea#
          findChildIndexCallback: (key) =>
              controller.findChildIndexCallback(key, thisEventsKeyMap),
        ),
      ),
    );
  }
}
