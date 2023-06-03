import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message.dart';
import 'package:fluffychat/pages/chat/seen_by_row.dart';
import 'package:fluffychat/pages/chat/typing_indicators.dart';
import 'package:fluffychat/pages/user_bottom_sheet/user_bottom_sheet.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/filtered_timeline_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';

class ChatEventList extends StatelessWidget {
  final ChatController controller;
  const ChatEventList({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = FluffyThemes.isColumnMode(context) ? 8.0 : 0.0;

    // create a map of eventId --> index to greatly improve performance of
    // ListView's findChildIndexCallback
    final thisEventsKeyMap = <String, int>{};
    for (var i = 0; i < controller.timeline!.events.length; i++) {
      thisEventsKeyMap[controller.timeline!.events[i].eventId] = i;
    }

    return ListView.custom(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 4,
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
          if (i == controller.timeline!.events.length + 1) {
            if (controller.timeline!.isRequestingHistory) {
              return const Center(
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              );
            }
            if (controller.timeline!.canRequestHistory) {
              return Center(
                child: IconButton(
                  onPressed: controller.requestHistory,
                  icon: const Icon(Icons.refresh_outlined),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          // The message at this index:
          final event = controller.timeline!.events[i - 1];

          return AutoScrollTag(
            key: ValueKey(event.eventId),
            index: i - 1,
            controller: controller.scrollController,
            child: event.isVisibleInGui
                ? Message(
                    event,
                    onSwipe: (direction) =>
                        controller.replyAction(replyTo: event),
                    onInfoTab: controller.showEventInfo,
                    onAvatarTab: (Event event) => showAdaptiveBottomSheet(
                      context: context,
                      builder: (c) => UserBottomSheet(
                        user: event.senderFromMemoryOrFallback,
                        outerContext: context,
                        onMention: () => controller.sendController.text +=
                            '${event.senderFromMemoryOrFallback.mention} ',
                      ),
                    ),
                    onSelect: controller.onSelectMessage,
                    scrollToEventId: (String eventId) =>
                        controller.scrollToEventId(eventId),
                    longPressSelect: controller.selectedEvents.isEmpty,
                    selected: controller.selectedEvents
                        .any((e) => e.eventId == event.eventId),
                    timeline: controller.timeline!,
                    displayReadMarker:
                        controller.readMarkerEventId == event.eventId &&
                            controller.timeline?.allowNewEvent == false,
                    nextEvent: i < controller.timeline!.events.length
                        ? controller.timeline!.events[i]
                        : null,
                  )
                : const SizedBox.shrink(),
          );
        },
        childCount: controller.timeline!.events.length + 2,
        findChildIndexCallback: (key) =>
            controller.findChildIndexCallback(key, thisEventsKeyMap),
      ),
    );
  }
}
