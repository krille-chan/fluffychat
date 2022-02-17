import 'package:flutter/material.dart';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipe_to_action/swipe_to_action.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_title.dart';
import 'package:fluffychat/pages/chat/encryption_button.dart';
import 'package:fluffychat/pages/chat/pinned_events.dart';
import 'package:fluffychat/pages/chat/reactions_picker.dart';
import 'package:fluffychat/pages/chat/reply_display.dart';
import 'package:fluffychat/pages/chat/seen_by_row.dart';
import 'package:fluffychat/pages/chat/tombstone_display.dart';
import 'package:fluffychat/pages/chat/typing_indicators.dart';
import 'package:fluffychat/pages/user_bottom_sheet/user_bottom_sheet.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:fluffychat/widgets/chat_settings_popup_menu.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/unread_badge_back_button.dart';
import '../../utils/stream_extension.dart';
import 'chat_emoji_picker.dart';
import 'chat_input_row.dart';
import 'events/message.dart';

enum _EventContextAction { info, report }

class ChatView extends StatelessWidget {
  final ChatController controller;

  const ChatView(this.controller, {Key? key}) : super(key: key);

  List<Widget> _appBarActions(BuildContext context) {
    if (controller.selectMode) {
      return [
        if (controller.canEditSelectedEvents)
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: L10n.of(context)!.edit,
            onPressed: controller.editSelectedEventAction,
          ),
        IconButton(
          icon: const Icon(Icons.copy_outlined),
          tooltip: L10n.of(context)!.copy,
          onPressed: controller.copyEventsAction,
        ),
        if (controller.canSaveSelectedEvent)
          IconButton(
            icon: Icon(Icons.adaptive.share),
            tooltip: L10n.of(context)!.share,
            onPressed: controller.saveSelectedEvent,
          ),
        if (controller.canRedactSelectedEvents)
          IconButton(
            icon: const Icon(Icons.delete_outlined),
            tooltip: L10n.of(context)!.redactMessage,
            onPressed: controller.redactEventsAction,
          ),
        IconButton(
          icon: const Icon(Icons.push_pin_outlined),
          onPressed: controller.pinEvent,
          tooltip: L10n.of(context)!.pinMessage,
        ),
        if (controller.selectedEvents.length == 1)
          PopupMenuButton<_EventContextAction>(
            onSelected: (action) {
              switch (action) {
                case _EventContextAction.info:
                  controller.showEventInfo();
                  controller.clearSelectedEvents();
                  break;
                case _EventContextAction.report:
                  controller.reportEventAction();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _EventContextAction.info,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.info_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context)!.messageInfo),
                  ],
                ),
              ),
              PopupMenuItem(
                value: _EventContextAction.report,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Text(L10n.of(context)!.reportMessage),
                  ],
                ),
              ),
            ],
          ),
      ];
    } else {
      return [
        if (Matrix.of(context).webrtcIsSupported &&
            controller.room!.isDirectChat)
          IconButton(
            onPressed: controller.onPhoneButtonTap,
            icon: const Icon(Icons.call_outlined),
            tooltip: L10n.of(context)!.placeCall,
          ),
        EncryptionButton(controller.room!),
        ChatSettingsPopupMenu(controller.room!, !controller.room!.isDirectChat),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.matrix ??= Matrix.of(context);
    final client = controller.matrix!.client;
    controller.sendingClient ??= client;
    controller.room = controller.sendingClient!.getRoomById(controller.roomId!);
    if (controller.room == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(L10n.of(context)!.youAreNoLongerParticipatingInThisChat),
        ),
      );
    }

    if (controller.room!.membership == Membership.invite) {
      showFutureLoadingDialog(
          context: context, future: () => controller.room!.join());
    }
    final bottomSheetPadding = FluffyThemes.isColumnMode(context) ? 16.0 : 8.0;
    final horizontalPadding = FluffyThemes.isColumnMode(context) ? 8.0 : 0.0;

    return VWidgetGuard(
      onSystemPop: (redirector) async {
        if (controller.selectedEvents.isNotEmpty) {
          controller.clearSelectedEvents();
          redirector.stopRedirection();
        }
      },
      child: StreamBuilder(
        stream: controller.room!.onUpdate.stream
            .rateLimit(const Duration(milliseconds: 250)),
        builder: (context, snapshot) => FutureBuilder<bool>(
          future: controller.getTimeline(),
          builder: (BuildContext context, snapshot) {
            return Scaffold(
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
                        tooltip: L10n.of(context)!.close,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : UnreadBadgeBackButton(roomId: controller.roomId!),
                titleSpacing: 0,
                title: ChatAppBarTitle(controller),
                actions: _appBarActions(context),
              ),
              floatingActionButton: controller.showScrollDownButton &&
                      controller.selectedEvents.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 56.0),
                      child: FloatingActionButton(
                        onPressed: controller.scrollDown,
                        foregroundColor:
                            Theme.of(context).textTheme.bodyText2!.color,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        mini: true,
                        child: Icon(Icons.arrow_downward_outlined,
                            color: Theme.of(context).primaryColor),
                      ),
                    )
                  : null,
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: DropTarget(
                onDragDone: controller.onDragDone,
                onDragEntered: controller.onDragEntered,
                onDragExited: controller.onDragExited,
                child: Stack(
                  children: <Widget>[
                    if (Matrix.of(context).wallpaper != null)
                      Image.file(
                        Matrix.of(context).wallpaper!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    SafeArea(
                      child: Column(
                        children: <Widget>[
                          TombstoneDisplay(controller),
                          PinnedEvents(controller),
                          Expanded(
                            child: GestureDetector(
                                onTap: controller.clearSingleSelectedEvent,
                                child: Builder(
                                  builder: (context) {
                                    if (snapshot.hasError) {
                                      SentryController.captureException(
                                        snapshot.error,
                                        StackTrace.current,
                                      );
                                    }
                                    if (controller.timeline == null) {
                                      return const Center(
                                        child:
                                            CircularProgressIndicator.adaptive(
                                                strokeWidth: 2),
                                      );
                                    }

                                    // create a map of eventId --> index to greatly improve performance of
                                    // ListView's findChildIndexCallback
                                    final thisEventsKeyMap = <String, int>{};
                                    for (var i = 0;
                                        i < controller.filteredEvents.length;
                                        i++) {
                                      thisEventsKeyMap[controller
                                          .filteredEvents[i].eventId] = i;
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
                                      keyboardDismissBehavior: PlatformInfos
                                              .isIOS
                                          ? ScrollViewKeyboardDismissBehavior
                                              .onDrag
                                          : ScrollViewKeyboardDismissBehavior
                                              .manual,
                                      childrenDelegate:
                                          SliverChildBuilderDelegate(
                                        (BuildContext context, int i) {
                                          return i ==
                                                  controller.filteredEvents
                                                          .length +
                                                      1
                                              ? controller.timeline!
                                                      .isRequestingHistory
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator
                                                              .adaptive(
                                                                  strokeWidth:
                                                                      2),
                                                    )
                                                  : controller.canLoadMore
                                                      ? Center(
                                                          child: OutlinedButton(
                                                            style:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor,
                                                            ),
                                                            onPressed: controller
                                                                .requestHistory,
                                                            child: Text(L10n.of(
                                                                    context)!
                                                                .loadMore),
                                                          ),
                                                        )
                                                      : Container()
                                              : i == 0
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SeenByRow(controller),
                                                        TypingIndicators(
                                                            controller),
                                                      ],
                                                    )
                                                  : AutoScrollTag(
                                                      key: ValueKey(controller
                                                          .filteredEvents[i - 1]
                                                          .eventId),
                                                      index: i - 1,
                                                      controller: controller
                                                          .scrollController,
                                                      child: Swipeable(
                                                        key: ValueKey(controller
                                                            .filteredEvents[
                                                                i - 1]
                                                            .eventId),
                                                        background:
                                                            const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      12.0),
                                                          child: Center(
                                                            child: Icon(Icons
                                                                .reply_outlined),
                                                          ),
                                                        ),
                                                        direction:
                                                            SwipeDirection
                                                                .endToStart,
                                                        onSwipe: (direction) =>
                                                            controller.replyAction(
                                                                replyTo: controller
                                                                        .filteredEvents[
                                                                    i - 1]),
                                                        child: Message(
                                                            controller.filteredEvents[
                                                                i - 1],
                                                            onInfoTab: controller
                                                                .showEventInfo,
                                                            onAvatarTab:
                                                                (Event event) =>
                                                                    showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (c) =>
                                                                              UserBottomSheet(
                                                                        user: event
                                                                            .sender,
                                                                        outerContext:
                                                                            context,
                                                                        onMention: () => controller
                                                                            .sendController
                                                                            .text += '${event.sender.mention} ',
                                                                      ),
                                                                    ),
                                                            unfold: controller
                                                                .unfold,
                                                            onSelect: controller
                                                                .onSelectMessage,
                                                            scrollToEventId:
                                                                (String eventId) =>
                                                                    controller.scrollToEventId(
                                                                        eventId),
                                                            longPressSelect:
                                                                controller
                                                                    .selectedEvents
                                                                    .isEmpty,
                                                            selected: controller
                                                                .selectedEvents
                                                                .any((e) => e.eventId == controller.filteredEvents[i - 1].eventId),
                                                            timeline: controller.timeline!,
                                                            nextEvent: i < controller.filteredEvents.length ? controller.filteredEvents[i] : null),
                                                      ),
                                                    );
                                        },
                                        childCount:
                                            controller.filteredEvents.length +
                                                2,
                                        findChildIndexCallback: (key) =>
                                            controller.findChildIndexCallback(
                                                key, thisEventsKeyMap),
                                      ),
                                    );
                                  },
                                )),
                          ),
                          if (controller.room!.canSendDefaultMessages &&
                              controller.room!.membership == Membership.join)
                            Container(
                              margin: EdgeInsets.only(
                                bottom: bottomSheetPadding,
                                left: bottomSheetPadding,
                                right: bottomSheetPadding,
                              ),
                              constraints: const BoxConstraints(
                                  maxWidth: FluffyThemes.columnWidth * 2.5),
                              alignment: Alignment.center,
                              child: Material(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(AppConfig.borderRadius),
                                  bottomRight:
                                      Radius.circular(AppConfig.borderRadius),
                                ),
                                elevation: 6,
                                shadowColor: Theme.of(context)
                                    .secondaryHeaderColor
                                    .withAlpha(100),
                                clipBehavior: Clip.hardEdge,
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
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
                    if (controller.dragging)
                      Container(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.9),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.upload_outlined,
                          size: 100,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
