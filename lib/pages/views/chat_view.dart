import 'dart:ui';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:matrix/matrix.dart';
import 'package:fluffychat/pages/chat.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/chat_settings_popup_menu.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import 'package:fluffychat/widgets/input_bar.dart';
import 'package:fluffychat/widgets/unread_badge_back_button.dart';

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

import '../../utils/stream_extension.dart';

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
                    if (controller.room.getState(EventTypes.RoomTombstone) !=
                        null)
                      SizedBox(
                        height: 72,
                        child: Material(
                          color: Theme.of(context).secondaryHeaderColor,
                          elevation: 1,
                          child: ListTile(
                            leading: CircleAvatar(
                              foregroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              child: const Icon(Icons.upgrade_outlined),
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
                    const ConnectionStatusHeader(),
                    if (!controller.showEmojiPicker)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
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
                                .aggregatedEvents(controller.timeline,
                                    RelationshipTypes.reaction)
                                ?.where((event) =>
                                    event.senderId ==
                                        event.room.client.userID &&
                                    event.type == 'm.reaction');

                            for (final event in allReactionEvents) {
                              try {
                                emojis.remove(
                                    event.content['m.relates_to']['key']);
                              } catch (_) {}
                            }
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
                                        child: const Icon(Icons.add_outlined),
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
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                      ),
                                    ),
                            );
                          }),
                        ),
                      ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
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
                              icon: const Icon(Icons.close),
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
                    const Divider(height: 1),
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
                                  SizedBox(
                                    height: 56,
                                    child: TextButton(
                                      onPressed: controller.forwardEventsAction,
                                      child: Row(
                                        children: <Widget>[
                                          const Icon(Icons
                                              .keyboard_arrow_left_outlined),
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
                                          ? SizedBox(
                                              height: 56,
                                              child: TextButton(
                                                onPressed:
                                                    controller.replyAction,
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                        L10n.of(context).reply),
                                                    const Icon(Icons
                                                        .keyboard_arrow_right),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              height: 56,
                                              child: TextButton(
                                                onPressed:
                                                    controller.sendAgainAction,
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(L10n.of(context)
                                                        .tryToSendAgain),
                                                    const SizedBox(width: 4),
                                                    const Icon(
                                                        Icons.send_outlined,
                                                        size: 16),
                                                  ],
                                                ),
                                              ),
                                            )
                                      : Container(),
                                ]
                              : <Widget>[
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    height: 56,
                                    width:
                                        controller.inputText.isEmpty ? 56 : 0,
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: const BoxDecoration(),
                                    child: PopupMenuButton<String>(
                                      icon: const Icon(Icons.add_outlined),
                                      onSelected: controller
                                          .onAddPopupMenuButtonSelected,
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'file',
                                          child: ListTile(
                                            leading: const CircleAvatar(
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                              child: Icon(
                                                  Icons.attachment_outlined),
                                            ),
                                            title:
                                                Text(L10n.of(context).sendFile),
                                            contentPadding:
                                                const EdgeInsets.all(0),
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
                                            title: Text(
                                                L10n.of(context).sendImage),
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                          ),
                                        ),
                                        if (PlatformInfos.isMobile)
                                          PopupMenuItem<String>(
                                            value: 'camera',
                                            child: ListTile(
                                              leading: const CircleAvatar(
                                                backgroundColor: Colors.purple,
                                                foregroundColor: Colors.white,
                                                child: Icon(
                                                    Icons.camera_alt_outlined),
                                              ),
                                              title: Text(
                                                  L10n.of(context).openCamera),
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                            ),
                                          ),
                                        if (controller.room
                                            .getImagePacks(
                                                ImagePackUsage.sticker)
                                            .isNotEmpty)
                                          PopupMenuItem<String>(
                                            value: 'sticker',
                                            child: ListTile(
                                              leading: const CircleAvatar(
                                                backgroundColor: Colors.orange,
                                                foregroundColor: Colors.white,
                                                child: Icon(Icons
                                                    .emoji_emotions_outlined),
                                              ),
                                              title: Text(
                                                  L10n.of(context).sendSticker),
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                            ),
                                          ),
                                        if (PlatformInfos.isMobile)
                                          PopupMenuItem<String>(
                                            value: 'voice',
                                            child: ListTile(
                                              leading: const CircleAvatar(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                child: Icon(
                                                    Icons.mic_none_outlined),
                                              ),
                                              title: Text(L10n.of(context)
                                                  .voiceMessage),
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                            ),
                                          ),
                                        if (PlatformInfos.isMobile)
                                          PopupMenuItem<String>(
                                            value: 'location',
                                            child: ListTile(
                                              leading: const CircleAvatar(
                                                backgroundColor: Colors.brown,
                                                foregroundColor: Colors.white,
                                                child: Icon(
                                                    Icons.gps_fixed_outlined),
                                              ),
                                              title: Text(L10n.of(context)
                                                  .shareLocation),
                                              contentPadding:
                                                  const EdgeInsets.all(0),
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
                                  if (controller.matrix.isMultiAccount &&
                                      controller.matrix.hasComplexBundles &&
                                      controller.matrix.currentBundle.length >
                                          1)
                                    Container(
                                      height: 56,
                                      alignment: Alignment.center,
                                      child: _ChatAccountPicker(controller),
                                    ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: InputBar(
                                        room: controller.room,
                                        minLines: 1,
                                        maxLines: 8,
                                        autofocus: !PlatformInfos.isMobile,
                                        keyboardType: TextInputType.multiline,
                                        textInputAction: AppConfig.sendOnEnter
                                            ? TextInputAction.send
                                            : null,
                                        onSubmitted:
                                            controller.onInputBarSubmitted,
                                        focusNode: controller.inputFocus,
                                        controller: controller.sendController,
                                        decoration: InputDecoration(
                                          hintText:
                                              L10n.of(context).writeAMessage,
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
                                        icon:
                                            const Icon(Icons.mic_none_outlined),
                                        onPressed:
                                            controller.voiceMessageAction,
                                      ),
                                    ),
                                  if (!PlatformInfos.isMobile ||
                                      controller.inputText.isNotEmpty)
                                    Container(
                                      height: 56,
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        icon: const Icon(Icons.send_outlined),
                                        onPressed: controller.send,
                                        tooltip: L10n.of(context).send,
                                      ),
                                    ),
                                ],
                        ),
                      ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
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
        ),
      ),
    );
  }
}

class _EditContent extends StatelessWidget {
  final Event event;

  const _EditContent(this.event);

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

class _ChatAccountPicker extends StatelessWidget {
  final ChatController controller;

  const _ChatAccountPicker(this.controller, {Key key}) : super(key: key);

  void _popupMenuButtonSelected(String mxid) {
    final client = controller.matrix.currentBundle
        .firstWhere((cl) => cl.userID == mxid, orElse: () => null);
    if (client == null) {
      Logs().w('Attempted to switch to a non-existing client $mxid');
      return;
    }
    controller.setSendingClient(client);
  }

  @override
  Widget build(BuildContext context) {
    controller.matrix ??= Matrix.of(context);
    final clients = controller.currentRoomBundle;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<Profile>(
        future: controller.sendingClient.ownProfile,
        builder: (context, snapshot) => PopupMenuButton<String>(
          onSelected: _popupMenuButtonSelected,
          itemBuilder: (BuildContext context) => clients
              .map((client) => PopupMenuItem<String>(
                    value: client.userID,
                    child: FutureBuilder<Profile>(
                      future: client.ownProfile,
                      builder: (context, snapshot) => ListTile(
                        leading: Avatar(
                          snapshot.data?.avatarUrl,
                          snapshot.data?.displayName ?? client.userID.localpart,
                          size: 20,
                        ),
                        title:
                            Text(snapshot.data?.displayName ?? client.userID),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                  ))
              .toList(),
          child: Avatar(
            snapshot.data?.avatarUrl,
            snapshot.data?.displayName ??
                controller.matrix.client.userID.localpart,
            size: 20,
          ),
        ),
      ),
    );
  }
}
