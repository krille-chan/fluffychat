import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message.dart';
import 'package:fluffychat/pages/chat/seen_by_row.dart';
import 'package:fluffychat/pages/chat/typing_indicators.dart';
import 'package:fluffychat/pages/user_bottom_sheet/user_bottom_sheet.dart';
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
    for (var i = 0; i < controller.filteredEvents.length; i++) {
      thisEventsKeyMap[controller.filteredEvents[i].eventId] = i;
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
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SeenByRow(controller),
                TypingIndicators(controller),
              ],
            );
          }

          // Request history button or progress indicator:
          if (i == controller.filteredEvents.length + 1) {
            if (controller.timeline!.isRequestingHistory) {
              return const Center(
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              );
            }
            if (controller.canLoadMore) {
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  onPressed: controller.requestHistory,
                  child: Text(L10n.of(context)!.loadMore),
                ),
              );
            }
            return Container();
          }

          // The message at this index:
          return AutoScrollTag(
            key: ValueKey(controller.filteredEvents[i - 1].eventId),
            index: i - 1,
            controller: controller.scrollController,
            child: Message(controller.filteredEvents[i - 1],
                onSwipe: (direction) => controller.replyAction(
                    replyTo: controller.filteredEvents[i - 1]),
                onInfoTab: controller.showEventInfo,
                onAvatarTab: (Event event) => showModalBottomSheet(
                      context: context,
                      builder: (c) => UserBottomSheet(
                        user: event.senderFromMemoryOrFallback,
                        outerContext: context,
                        onMention: () => controller.sendController.text +=
                            '${event.senderFromMemoryOrFallback.mention} ',
                      ),
                    ),
                unfold: controller.unfold,
                onSelect: controller.onSelectMessage,
                scrollToEventId: (String eventId) =>
                    controller.scrollToEventId(eventId),
                longPressSelect: controller.selectedEvents.isEmpty,
                selected: controller.selectedEvents.any((e) =>
                    e.eventId == controller.filteredEvents[i - 1].eventId),
                timeline: controller.timeline!,
                nextEvent: i < controller.filteredEvents.length
                    ? controller.filteredEvents[i]
                    : null),
          );
        },
        childCount: controller.filteredEvents.length + 2,
        findChildIndexCallback: (key) =>
            controller.findChildIndexCallback(key, thisEventsKeyMap),
      ),
    );
  }
}
