import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipe_to_action/swipe_to_action.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/reactions_picker.dart';
import 'package:fluffychat/pages/chat/reply_display.dart';
import 'package:fluffychat/pages/chat/tombstone_display.dart';
import 'package:fluffychat/pages/user_bottom_sheet/user_bottom_sheet.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/room_status_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/chat_settings_popup_menu.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/unread_badge_back_button.dart';
import '../../utils/stream_extension.dart';
import 'chat_emoji_picker.dart';
import 'chat_input_row.dart';
import 'events/message.dart';

class ChatView extends StatelessWidget {
  final ChatController controller;

  const ChatView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.matrix ??= Matrix.of(context);
    final client = controller.matrix.client;
    controller.sendingClient ??= client;
    controller.room = controller.sendingClient.getRoomById(controller.roomId);
    if (controller.room == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(L10n.of(context).youAreNoLongerParticipatingInThisChat),
        ),
      );
    }

    if (controller.room.membership == Membership.invite) {
      showFutureLoadingDialog(
          context: context, future: () => controller.room.join());
    }

    return VWidgetGuard(
      onSystemPop: (redirector) async {
        if (controller.selectedEvents.isNotEmpty) {
          controller.clearSelectedEvents();
          redirector.stopRedirection();
        }
      },
      child: StreamBuilder(
        stream: controller.room.onUpdate.stream
            .rateLimit(const Duration(milliseconds: 250)),
        builder: (context, snapshot) => Scaffold(
          appBar: AppBar(
            actionsIconTheme: IconThemeData(
              color: controller.selectedEvents.isEmpty
                  ? null
                  : Theme.of(context).colorScheme.primary,
            ),
            leading: controller.selectMode
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: controller.clearSelectedEvents,
                    tooltip: L10n.of(context).close,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : UnreadBadgeBackButton(roomId: controller.roomId),
            titleSpacing: 0,
            title: controller.selectedEvents.isEmpty
                ? ListTile(
                    leading: Avatar(
                        controller.room.avatar, controller.room.displayname),
                    contentPadding: EdgeInsets.zero,
                    onTap: controller.room.isDirectChat
                        ? () => showModalBottomSheet(
                              context: context,
                              builder: (c) => UserBottomSheet(
                                user: controller.room.getUserByMXIDSync(
                                    controller.room.directChatMatrixID),
                                outerContext: context,
                                onMention: () => controller
                                        .sendController.text +=
                                    '${controller.room.getUserByMXIDSync(controller.room.directChatMatrixID).mention} ',
                              ),
                            )
                        : () => VRouter.of(context).toSegments(
                            ['rooms', controller.room.id, 'details']),
                    title: Text(
                        controller.room.getLocalizedDisplayname(
                            MatrixLocals(L10n.of(context))),
                        maxLines: 1),
                    subtitle: controller.room
                            .getLocalizedTypingText(context)
                            .isEmpty
                        ? StreamBuilder<Object>(
                            stream: Matrix.of(context)
                                .client
                                .onPresence
                                .stream
                                .where((p) =>
                                    p.senderId ==
                                    controller.room.directChatMatrixID)
                                .rateLimit(const Duration(seconds: 1)),
                            builder: (context, snapshot) => Text(
                                  controller.room.getLocalizedStatus(context),
                                  maxLines: 1,
                                  //overflow: TextOverflow.ellipsis,
                                ))
                        : Row(
                            children: <Widget>[
                              Icon(Icons.edit_outlined,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 13),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  controller.room
                                      .getLocalizedTypingText(context),
                                  maxLines: 1,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  )
                : Text(controller.selectedEvents.length.toString()),
            actions: controller.selectMode
                ? <Widget>[
                    if (controller.canEditSelectedEvents)
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: L10n.of(context).edit,
                        onPressed: controller.editSelectedEventAction,
                      ),
                    IconButton(
                      icon: const Icon(Icons.copy_outlined),
                      tooltip: L10n.of(context).copy,
                      onPressed: controller.copyEventsAction,
                    ),
                    if (controller.selectedEvents.length == 1)
                      IconButton(
                        icon: const Icon(Icons.report_outlined),
                        tooltip: L10n.of(context).reportMessage,
                        onPressed: controller.reportEventAction,
                      ),
                    if (controller.canRedactSelectedEvents)
                      IconButton(
                        icon: const Icon(Icons.delete_outlined),
                        tooltip: L10n.of(context).redactMessage,
                        onPressed: controller.redactEventsAction,
                      ),
                  ]
                : <Widget>[
                    if (controller.room.canSendDefaultStates)
                      IconButton(
                        tooltip: L10n.of(context).videoCall,
                        icon: const Icon(Icons.video_call_outlined),
                        onPressed: controller.startCallAction,
                      ),
                    ChatSettingsPopupMenu(
                        controller.room, !controller.room.isDirectChat),
                  ],
          ),
          floatingActionButton: controller.showScrollDownButton
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 56.0),
                  child: FloatingActionButton(
                    onPressed: controller.scrollDown,
                    foregroundColor:
                        Theme.of(context).textTheme.bodyText2.color,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    mini: true,
                    child: Icon(Icons.arrow_downward_outlined,
                        color: Theme.of(context).primaryColor),
                  ),
                )
              : null,
          body: Stack(
            children: <Widget>[
              if (Matrix.of(context).wallpaper != null)
                Image.file(
                  Matrix.of(context).wallpaper,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              SafeArea(
                child: Column(
                  children: <Widget>[
                    TombstoneDisplay(controller),
                    Expanded(
                      child: FutureBuilder<bool>(
                        future: controller.getTimeline(),
                        builder: (BuildContext context, snapshot) {
                          if (controller.timeline == null) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2),
                            );
                          }

                          // create a map of eventId --> index to greatly improve performance of
                          // ListView's findChildIndexCallback
                          final thisEventsKeyMap = <String, int>{};
                          for (var i = 0;
                              i < controller.filteredEvents.length;
                              i++) {
                            thisEventsKeyMap[
                                controller.filteredEvents[i].eventId] = i;
                          }
                          final seenByText =
                              controller.room.getLocalizedSeenByText(
                            context,
                            controller.timeline,
                            controller.filteredEvents,
                            controller.unfolded,
                          );
                          return ListView.custom(
                            padding: const EdgeInsets.only(
                              top: 16,
                              bottom: 4,
                            ),
                            reverse: true,
                            controller: controller.scrollController,
                            keyboardDismissBehavior: PlatformInfos.isIOS
                                ? ScrollViewKeyboardDismissBehavior.onDrag
                                : ScrollViewKeyboardDismissBehavior.manual,
                            childrenDelegate: SliverChildBuilderDelegate(
                              (BuildContext context, int i) {
                                return i == controller.filteredEvents.length + 1
                                    ? controller.timeline.isRequestingHistory
                                        ? const Center(
                                            child: CircularProgressIndicator
                                                .adaptive(strokeWidth: 2),
                                          )
                                        : controller.canLoadMore
                                            ? Center(
                                                child: OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                  onPressed:
                                                      controller.requestHistory,
                                                  child: Text(L10n.of(context)
                                                      .loadMore),
                                                ),
                                              )
                                            : Container()
                                    : i == 0
                                        ? AnimatedContainer(
                                            height: seenByText.isEmpty ? 0 : 24,
                                            duration: seenByText.isEmpty
                                                ? const Duration(
                                                    milliseconds: 0)
                                                : const Duration(
                                                    milliseconds: 300),
                                            alignment: controller.filteredEvents
                                                        .isNotEmpty &&
                                                    controller.filteredEvents
                                                            .first.senderId ==
                                                        client.userID
                                                ? Alignment.topRight
                                                : Alignment.topLeft,
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              bottom: 8,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor
                                                    .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                seenByText,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                            ),
                                          )
                                        : AutoScrollTag(
                                            key: ValueKey(controller
                                                .filteredEvents[i - 1].eventId),
                                            index: i - 1,
                                            controller:
                                                controller.scrollController,
                                            child: Swipeable(
                                              key: ValueKey(controller
                                                  .filteredEvents[i - 1]
                                                  .eventId),
                                              background: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.0),
                                                child: Center(
                                                  child: Icon(
                                                      Icons.reply_outlined),
                                                ),
                                              ),
                                              direction:
                                                  SwipeDirection.endToStart,
                                              onSwipe: (direction) =>
                                                  controller.replyAction(
                                                      replyTo: controller
                                                              .filteredEvents[
                                                          i - 1]),
                                              child: Message(
                                                  controller
                                                      .filteredEvents[i - 1],
                                                  onAvatarTab: (Event event) =>
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (c) =>
                                                            UserBottomSheet(
                                                          user: event.sender,
                                                          outerContext: context,
                                                          onMention: () => controller
                                                                  .sendController
                                                                  .text +=
                                                              '${event.sender.mention} ',
                                                        ),
                                                      ),
                                                  unfold: controller.unfold,
                                                  onSelect: controller
                                                      .onSelectMessage,
                                                  scrollToEventId: (String eventId) =>
                                                      controller.scrollToEventId(
                                                          eventId),
                                                  longPressSelect: controller
                                                      .selectedEvents.isEmpty,
                                                  selected: controller
                                                      .selectedEvents
                                                      .contains(
                                                          controller.filteredEvents[
                                                              i - 1]),
                                                  timeline: controller.timeline,
                                                  nextEvent: i >= 2
                                                      ? controller.filteredEvents[i - 2]
                                                      : null),
                                            ),
                                          );
                              },
                              childCount: controller.filteredEvents.length + 2,
                              findChildIndexCallback: (key) =>
                                  controller.findChildIndexCallback(
                                      key, thisEventsKeyMap),
                            ),
                          );
                        },
                      ),
                    ),
                    if (controller.showScrollDownButton)
                      const Divider(
                        height: 1,
                      ),
                    if (controller.room.canSendDefaultMessages &&
                        controller.room.membership == Membership.join)
                      Padding(
                        padding: EdgeInsets.all(
                            FluffyThemes.isColumnMode(context) ? 16.0 : 8.0),
                        child: Material(
                          borderRadius:
                              BorderRadius.circular(AppConfig.borderRadius),
                          elevation: 7,
                          clipBehavior: Clip.hardEdge,
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const ConnectionStatusHeader(),
                              ReactionsPicker(controller),
                              ReplyDisplay(controller),
                              ChatInputRow(controller),
                              ChatEmojiPicker(controller),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
