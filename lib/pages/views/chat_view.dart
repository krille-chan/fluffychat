import 'dart:math';
import 'dart:ui';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/pages/chat.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/chat_settings_popup_menu.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import 'package:fluffychat/widgets/input_bar.dart';
import 'package:fluffychat/widgets/unread_badge_back_button.dart';
import 'package:fluffychat/config/themes.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/widgets/encryption_button.dart';
import 'package:fluffychat/widgets/event_content/message.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/event_content/reply_content.dart';
import 'package:fluffychat/pages/user_bottom_sheet.dart';
import 'package:fluffychat/config/app_emojis.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/room_status_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipe_to_action/swipe_to_action.dart';
import 'package:vrouter/vrouter.dart';

class ChatView extends StatelessWidget {
  final ChatController controller;

  const ChatView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.matrix = Matrix.of(context);
    final client = controller.matrix.client;
    controller.room ??= client.getRoomById(controller.roomId);
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
    controller.matrix.client.activeRoomId = controller.roomId;

    if (controller.room.membership == Membership.invite) {
      showFutureLoadingDialog(
          context: context, future: () => controller.room.join());
    }

    return Scaffold(
      appBar: AppBar(
        leading: controller.selectMode
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: controller.clearSelectedEvents,
                tooltip: L10n.of(context).close,
              )
            : UnreadBadgeBackButton(roomId: controller.roomId),
        title: controller.selectedEvents.isEmpty
            ? StreamBuilder(
                stream: controller.room.onUpdate.stream,
                builder: (context, snapshot) => ListTile(
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
                                      '${controller.room.directChatMatrixID} ',
                                ),
                              )
                          : () => VRouter.of(context)
                              .push('/rooms/${controller.room.id}/details'),
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
                                      controller.room.directChatMatrixID),
                              builder: (context, snapshot) => Text(
                                    controller.room.getLocalizedStatus(context),
                                    maxLines: 1,
                                    //overflow: TextOverflow.ellipsis,
                                  ))
                          : Row(
                              children: <Widget>[
                                Icon(Icons.edit_outlined,
                                    color: Theme.of(context).accentColor,
                                    size: 13),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    controller.room
                                        .getLocalizedTypingText(context),
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ))
            : Text(L10n.of(context)
                .numberSelected(controller.selectedEvents.length.toString())),
        actions: controller.selectMode
            ? <Widget>[
                if (controller.selectedEvents.length == 1 &&
                    controller.selectedEvents.first.status > 0 &&
                    controller.selectedEvents.first.senderId == client.userID)
                  IconButton(
                    icon: Icon(Icons.edit_outlined),
                    tooltip: L10n.of(context).edit,
                    onPressed: controller.editSelectedEventAction,
                  ),
                PopupMenuButton(
                  onSelected: controller.onEventActionPopupMenuSelected,
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'copy',
                      child: Text(L10n.of(context).copy),
                    ),
                    if (controller.canRedactSelectedEvents)
                      PopupMenuItem(
                        value: 'redact',
                        child: Text(
                          L10n.of(context).redactMessage,
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    if (controller.selectedEvents.length == 1)
                      PopupMenuItem(
                        value: 'report',
                        child: Text(
                          L10n.of(context).reportMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ]
            : <Widget>[
                if (controller.room.canSendDefaultStates)
                  IconButton(
                    tooltip: L10n.of(context).videoCall,
                    icon: Icon(Icons.video_call_outlined),
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
                foregroundColor: Theme.of(context).textTheme.bodyText2.color,
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
                ConnectionStatusHeader(),
                if (controller.room.getState(EventTypes.RoomTombstone) != null)
                  Container(
                    height: 72,
                    child: Material(
                      color: Theme.of(context).secondaryHeaderColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          foregroundColor: Theme.of(context).accentColor,
                          backgroundColor: Theme.of(context).backgroundColor,
                          child: Icon(Icons.upgrade_outlined),
                        ),
                        title: Text(
                          controller.room
                              .getState(EventTypes.RoomTombstone)
                              .parsedTombstoneContent
                              .body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(L10n.of(context).goToTheNewRoom),
                        onTap: controller.goToNewRoomAction,
                      ),
                    ),
                  ),
                Expanded(
                  child: FutureBuilder<bool>(
                    future: controller.getTimeline(),
                    builder: (BuildContext context, snapshot) {
                      if (controller.timeline == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // create a map of eventId --> index to greatly improve performance of
                      // ListView's findChildIndexCallback
                      final thisEventsKeyMap = <String, int>{};
                      for (var i = 0;
                          i < controller.filteredEvents.length;
                          i++) {
                        thisEventsKeyMap[controller.filteredEvents[i].eventId] =
                            i;
                      }

                      final horizontalPadding = max(
                              0,
                              (MediaQuery.of(context).size.width -
                                      FluffyThemes.columnWidth * (3.5)) /
                                  2)
                          .toDouble();

                      return ListView.custom(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 4,
                          left: horizontalPadding,
                          right: horizontalPadding,
                        ),
                        reverse: true,
                        controller: controller.scrollController,
                        childrenDelegate: SliverChildBuilderDelegate(
                          (BuildContext context, int i) {
                            return i == controller.filteredEvents.length + 1
                                ? controller.timeline.isRequestingHistory
                                    ? Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(8),
                                        child: CircularProgressIndicator(),
                                      )
                                    : controller.canLoadMore
                                        ? TextButton(
                                            onPressed:
                                                controller.requestHistory,
                                            child: Text(
                                              L10n.of(context).loadMore,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          )
                                        : Container()
                                : i == 0
                                    ? StreamBuilder(
                                        stream: controller.room.onUpdate.stream,
                                        builder: (_, __) {
                                          final seenByText = controller.room
                                              .getLocalizedSeenByText(
                                            context,
                                            controller.timeline,
                                            controller.filteredEvents,
                                            controller.unfolded,
                                          );
                                          return AnimatedContainer(
                                            height: seenByText.isEmpty ? 0 : 24,
                                            duration: seenByText.isEmpty
                                                ? Duration(milliseconds: 0)
                                                : Duration(milliseconds: 300),
                                            alignment: controller.filteredEvents
                                                        .first.senderId ==
                                                    client.userID
                                                ? Alignment.topRight
                                                : Alignment.topLeft,
                                            padding: EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              bottom: 8,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
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
                                                      .accentColor,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : AutoScrollTag(
                                        key: ValueKey(controller
                                            .filteredEvents[i - 1].eventId),
                                        index: i - 1,
                                        controller: controller.scrollController,
                                        child: Swipeable(
                                          key: ValueKey(controller
                                              .filteredEvents[i - 1].eventId),
                                          background: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Center(
                                              child: Icon(Icons.reply_outlined),
                                            ),
                                          ),
                                          direction: SwipeDirection.endToStart,
                                          onSwipe: (direction) =>
                                              controller.replyAction(
                                                  replyTo: controller
                                                      .filteredEvents[i - 1]),
                                          child: Message(
                                              controller.filteredEvents[i - 1],
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
                                                          '${event.senderId} ',
                                                    ),
                                                  ),
                                              unfold: controller.unfold,
                                              onSelect:
                                                  controller.onSelectMessage,
                                              scrollToEventId:
                                                  (String eventId) => controller
                                                      .scrollToEventId(eventId),
                                              longPressSelect: controller
                                                  .selectedEvents.isEmpty,
                                              selected: controller
                                                  .selectedEvents
                                                  .contains(controller
                                                      .filteredEvents[i - 1]),
                                              timeline: controller.timeline,
                                              nextEvent: i >= 2
                                                  ? controller
                                                      .filteredEvents[i - 2]
                                                  : null),
                                        ),
                                      );
                          },
                          childCount: controller.filteredEvents.length + 2,
                          findChildIndexCallback: (key) => controller
                              .findChildIndexCallback(key, thisEventsKeyMap),
                        ),
                      );
                    },
                  ),
                ),
                if (!controller.showEmojiPicker)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: (controller.editEvent == null &&
                            controller.replyEvent == null &&
                            controller.room.canSendDefaultMessages &&
                            controller.selectedEvents.length == 1)
                        ? 56
                        : 0,
                    child: Material(
                      color: Theme.of(context).secondaryHeaderColor,
                      child: Builder(builder: (context) {
                        if (!(controller.editEvent == null &&
                            controller.replyEvent == null &&
                            controller.selectedEvents.length == 1)) {
                          return Container();
                        }
                        final emojis = List<String>.from(AppEmojis.emojis);
                        final allReactionEvents = controller
                            .selectedEvents.first
                            .aggregatedEvents(
                                controller.timeline, RelationshipTypes.reaction)
                            ?.where((event) =>
                                event.senderId == event.room.client.userID &&
                                event.type == 'm.reaction');

                        allReactionEvents.forEach((event) {
                          try {
                            emojis.remove(event.content['m.relates_to']['key']);
                          } catch (_) {}
                        });
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: emojis.length + 1,
                          itemBuilder: (c, i) => i == emojis.length
                              ? InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () => controller
                                      .pickEmojiAction(allReactionEvents),
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    alignment: Alignment.center,
                                    child: Icon(Icons.add_outlined),
                                  ),
                                )
                              : InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () =>
                                      controller.sendEmojiAction(emojis[i]),
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    alignment: Alignment.center,
                                    child: Text(
                                      emojis[i],
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),
                        );
                      }),
                    ),
                  ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: controller.editEvent != null ||
                          controller.replyEvent != null
                      ? 56
                      : 0,
                  child: Material(
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          tooltip: L10n.of(context).close,
                          icon: Icon(Icons.close),
                          onPressed: controller.cancelReplyEventAction,
                        ),
                        Expanded(
                          child: controller.replyEvent != null
                              ? ReplyContent(controller.replyEvent,
                                  timeline: controller.timeline)
                              : _EditContent(controller.editEvent
                                  ?.getDisplayEvent(controller.timeline)),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                if (controller.room.canSendDefaultMessages &&
                    controller.room.membership == Membership.join &&
                    !controller.showEmojiPicker)
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: controller.selectMode
                          ? <Widget>[
                              Container(
                                height: 56,
                                child: TextButton(
                                  onPressed: controller.forwardEventsAction,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.keyboard_arrow_left_outlined),
                                      Text(L10n.of(context).forward),
                                    ],
                                  ),
                                ),
                              ),
                              controller.selectedEvents.length == 1
                                  ? controller.selectedEvents.first
                                              .getDisplayEvent(
                                                  controller.timeline)
                                              .status >
                                          0
                                      ? Container(
                                          height: 56,
                                          child: TextButton(
                                            onPressed: controller.replyAction,
                                            child: Row(
                                              children: <Widget>[
                                                Text(L10n.of(context).reply),
                                                Icon(
                                                    Icons.keyboard_arrow_right),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 56,
                                          child: TextButton(
                                            onPressed:
                                                controller.sendAgainAction,
                                            child: Row(
                                              children: <Widget>[
                                                Text(L10n.of(context)
                                                    .tryToSendAgain),
                                                SizedBox(width: 4),
                                                Icon(Icons.send_outlined,
                                                    size: 16),
                                              ],
                                            ),
                                          ),
                                        )
                                  : Container(),
                            ]
                          : <Widget>[
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                height: 56,
                                width: controller.inputText.isEmpty ? 56 : 0,
                                alignment: Alignment.center,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(),
                                child: PopupMenuButton<String>(
                                  icon: Icon(Icons.add_outlined),
                                  onSelected:
                                      controller.onAddPopupMenuButtonSelected,
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'file',
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          child:
                                              Icon(Icons.attachment_outlined),
                                        ),
                                        title: Text(L10n.of(context).sendFile),
                                        contentPadding: EdgeInsets.all(0),
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'image',
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          child: Icon(Icons.image_outlined),
                                        ),
                                        title: Text(L10n.of(context).sendImage),
                                        contentPadding: EdgeInsets.all(0),
                                      ),
                                    ),
                                    if (PlatformInfos.isMobile)
                                      PopupMenuItem<String>(
                                        value: 'camera',
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.purple,
                                            foregroundColor: Colors.white,
                                            child:
                                                Icon(Icons.camera_alt_outlined),
                                          ),
                                          title:
                                              Text(L10n.of(context).openCamera),
                                          contentPadding: EdgeInsets.all(0),
                                        ),
                                      ),
                                    if (PlatformInfos.isMobile)
                                      PopupMenuItem<String>(
                                        value: 'voice',
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            child:
                                                Icon(Icons.mic_none_outlined),
                                          ),
                                          title: Text(
                                              L10n.of(context).voiceMessage),
                                          contentPadding: EdgeInsets.all(0),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 56,
                                alignment: Alignment.center,
                                child: EncryptionButton(controller.room),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: InputBar(
                                    room: controller.room,
                                    minLines: 1,
                                    maxLines: kIsWeb ? 1 : 8,
                                    autofocus: !PlatformInfos.isMobile,
                                    keyboardType: !PlatformInfos.isMobile
                                        ? TextInputType.text
                                        : TextInputType.multiline,
                                    onSubmitted: controller.onInputBarSubmitted,
                                    focusNode: controller.inputFocus,
                                    controller: controller.sendController,
                                    decoration: InputDecoration(
                                      hintText: L10n.of(context).writeAMessage,
                                      hintMaxLines: 1,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      filled: false,
                                    ),
                                    onChanged: controller.onInputBarChanged,
                                  ),
                                ),
                              ),
                              if (PlatformInfos.isMobile &&
                                  controller.inputText.isEmpty)
                                Container(
                                  height: 56,
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    tooltip: L10n.of(context).voiceMessage,
                                    icon: Icon(Icons.mic_none_outlined),
                                    onPressed: controller.voiceMessageAction,
                                  ),
                                ),
                              if (!PlatformInfos.isMobile ||
                                  controller.inputText.isNotEmpty)
                                Container(
                                  height: 56,
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    icon: Icon(Icons.send_outlined),
                                    onPressed: controller.send,
                                    tooltip: L10n.of(context).send,
                                  ),
                                ),
                            ],
                    ),
                  ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: controller.showEmojiPicker
                      ? MediaQuery.of(context).size.height / 2
                      : 0,
                  child: controller.showEmojiPicker
                      ? EmojiPicker(
                          onEmojiSelected: controller.onEmojiSelected,
                          onBackspacePressed: controller.cancelEmojiPicker,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditContent extends StatelessWidget {
  final Event event;

  _EditContent(this.event);

  @override
  Widget build(BuildContext context) {
    if (event == null) {
      return Container();
    }
    return Row(
      children: <Widget>[
        Icon(
          Icons.edit,
          color: Theme.of(context).primaryColor,
        ),
        Container(width: 15.0),
        Text(
          event?.getLocalizedBody(
                MatrixLocals(L10n.of(context)),
                withSenderNamePrefix: false,
                hideReply: true,
              ) ??
              '',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText2.color,
          ),
        ),
      ],
    );
  }
}
