import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message.dart';
import 'package:fluffychat/pages/chat/seen_by_row.dart';
import 'package:fluffychat/pages/chat/typing_indicators.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_user_summaries_widget.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/utils/account_config.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/filtered_timeline_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';

class ChatEventList extends StatelessWidget {
  final ChatController controller;

  const ChatEventList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final timeline = controller.timeline;

    if (timeline == null) {
      return const Center(child: CupertinoActivityIndicator());
    }
    final theme = Theme.of(context);

    final colors = [theme.secondaryBubbleColor, theme.bubbleColor];

    final horizontalPadding = FluffyThemes.isColumnMode(context) ? 8.0 : 0.0;

    final events = timeline.events.filterByVisibleInGui(
      threadId: controller.activeThreadId,
    );
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
      // #Pangea
      // child: ListView.custom(
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            try {
              final scrollable =
                  controller.scrollController.position.maxScrollExtent > 0;
              controller.scrollableNotifier.value = scrollable;
            } catch (e, s) {
              ErrorHandler.logError(e: e, s: s, data: {});
            }
          });
          return true;
        },
        child: ListView.custom(
          // Pangea#
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
                if (timeline.canRequestFuture) {
                  return Center(
                    child: TextButton.icon(
                      onPressed: timeline.isRequestingFuture
                          ? null
                          : controller.requestFuture,
                      // #Pangea
                      // icon: timeline.isRequestingFuture
                      //     ? CircularProgressIndicator.adaptive(strokeWidth: 2)
                      //     : const Icon(Icons.arrow_downward_outlined),
                      icon: SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: timeline.isRequestingFuture
                            ? CircularProgressIndicator.adaptive(strokeWidth: 2)
                            : const Icon(Icons.arrow_downward_outlined),
                      ),
                      // Pangea#
                      label: Text(L10n.of(context).loadMore),
                    ),
                  );
                }
                return Column(
                  mainAxisSize: .min,
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
                if (controller.activeThreadId != null) {
                  return const SizedBox.shrink();
                }
                return Builder(
                  builder: (context) {
                    final visibleIndex = timeline.events.lastIndexWhere(
                      (event) =>
                          !event.isCollapsedState && event.isVisibleInGui,
                    );
                    if (visibleIndex > timeline.events.length - 50) {
                      // #Pangea
                      // WidgetsBinding.instance.addPostFrameCallback(
                      //   controller.requestHistory,
                      // );
                      // Pangea#
                    }
                    return Center(
                      child: TextButton.icon(
                        onPressed: timeline.isRequestingHistory
                            ? null
                            : controller.requestHistory,
                        // #Pangea
                        // icon: timeline.isRequestingHistory
                        //     ? CircularProgressIndicator.adaptive(strokeWidth: 2)
                        //     : const Icon(Icons.arrow_upward_outlined),
                        icon: SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: timeline.isRequestingHistory
                              ? CircularProgressIndicator.adaptive(
                                  strokeWidth: 2,
                                )
                              : const Icon(Icons.arrow_upward_outlined),
                        ),
                        // Pangea#
                        label: Text(L10n.of(context).loadMore),
                      ),
                    );
                  },
                );
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
              final animateIn =
                  animateInEventIndex != null &&
                  timeline.events.length > animateInEventIndex &&
                  event == timeline.events[animateInEventIndex];

              final nextEvent = i + 1 < events.length ? events[i + 1] : null;
              final previousEvent = i > 0 ? events[i - 1] : null;

              // Collapsed state event
              final canExpand =
                  event.isCollapsedState &&
                  nextEvent?.isCollapsedState == true &&
                  previousEvent?.isCollapsedState != true;
              final isCollapsed =
                  event.isCollapsedState &&
                  previousEvent?.isCollapsedState == true &&
                  !controller.expandedEventIds.contains(event.eventId);

              // #Pangea
              final nextIsCollapsed =
                  nextEvent?.isCollapsedState == true &&
                  !controller.expandedEventIds.contains(nextEvent?.eventId);
              // Pangea#

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
                  controller: controller,
                  isButton: event.eventId == controller.buttonEventID,
                  canRefresh: event.eventId == controller.refreshEventID,
                  // Pangea#
                  selected: controller.selectedEvents.any(
                    (e) => e.eventId == event.eventId,
                  ),
                  singleSelected:
                      controller.selectedEvents.singleOrNull?.eventId ==
                      event.eventId,
                  onEdit: () => controller.editSelectedEventAction(),
                  timeline: timeline,
                  displayReadMarker:
                      i > 0 && controller.readMarkerEventId == event.eventId,
                  nextEvent: nextEvent,
                  previousEvent: previousEvent,
                  wallpaperMode: hasWallpaper,
                  scrollController: controller.scrollController,
                  colors: colors,
                  isCollapsed: isCollapsed,
                  enterThread: controller.activeThreadId == null
                      ? controller.enterThread
                      : null,
                  onExpand: canExpand
                      ? () => controller.expandEventsFrom(
                          event,
                          !controller.expandedEventIds.contains(event.eventId),
                        )
                      : null,
                  // #Pangea
                  moreEventButtonExpands: nextIsCollapsed,
                  // Pangea#
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
      ),
    );
  }
}
