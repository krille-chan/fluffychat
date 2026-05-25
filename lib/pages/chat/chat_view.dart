// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:ui' as ui;

import 'package:desktop_drop/desktop_drop.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_list_tile.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_title.dart';
import 'package:fluffychat/pages/chat/chat_event_list.dart';
import 'package:fluffychat/pages/chat/jitsi_popup_button.dart';
import 'package:fluffychat/pages/chat/pinned_events.dart';
import 'package:fluffychat/pages/chat/reply_display.dart';
import 'package:fluffychat/utils/account_config.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/chat_settings_popup_menu.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../utils/stream_extension.dart';
import 'chat_emoji_picker.dart';
import 'chat_input_row.dart';

enum _EventContextAction { info, report }

class ChatView extends StatelessWidget {
  final ChatController controller;

  const ChatView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (controller.room.membership == Membership.invite) {
      showFutureLoadingDialog(
        context: context,
        future: () => controller.room.join(),
        exceptionContext: ExceptionContext.joinRoom,
      );
    }
    final bottomSheetPadding = FluffyThemes.isColumnMode(context) ? 16.0 : 8.0;
    final scrollUpBannerEventId = controller.scrollUpBannerEventId;

    final accountConfig = Matrix.of(context).client.applicationAccountConfig;

    return PopScope(
      canPop:
          controller.selectedEvents.isEmpty &&
          !controller.showEmojiPicker &&
          controller.activeThreadId == null,
      onPopInvokedWithResult: (pop, _) async {
        if (pop) return;
        if (controller.selectedEvents.isNotEmpty) {
          controller.clearSelectedEvents();
        } else if (controller.showEmojiPicker) {
          controller.emojiPickerAction();
        } else if (controller.activeThreadId != null) {
          controller.closeThread();
        }
      },
      child: StreamBuilder(
        stream: controller.room.client.onRoomState.stream
            .where((update) => update.roomId == controller.room.id)
            .rateLimit(const Duration(seconds: 1)),
        builder: (context, snapshot) => FutureBuilder(
          future: controller.loadTimelineFuture,
          builder: (BuildContext context, snapshot) {
            var appbarBottomHeight = 0.0;
            final activeThreadId = controller.activeThreadId;
            if (activeThreadId != null) {
              appbarBottomHeight += ChatAppBarListTile.fixedHeight;
            }
            if (controller.room.pinnedEventIds.isNotEmpty &&
                activeThreadId == null) {
              appbarBottomHeight += ChatAppBarListTile.fixedHeight;
            }
            if (scrollUpBannerEventId != null && activeThreadId == null) {
              appbarBottomHeight += ChatAppBarListTile.fixedHeight;
            }
            return Scaffold(
              key: Key('chat_page'),
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 4,
                scrolledUnderElevation: 4,
                actionsIconTheme: IconThemeData(
                  color: controller.selectedEvents.isEmpty
                      ? null
                      : theme.colorScheme.onTertiaryContainer,
                ),
                backgroundColor: controller.selectedEvents.isEmpty
                    ? controller.activeThreadId != null
                          ? theme.colorScheme.secondaryContainer
                          : theme.colorScheme.surfaceBright.withAlpha(240)
                    : theme.colorScheme.tertiaryContainer,
                automaticallyImplyLeading: false,
                leading: controller.selectMode
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: controller.clearSelectedEvents,
                        tooltip: L10n.of(context).close,
                        color: theme.colorScheme.onTertiaryContainer,
                      )
                    : activeThreadId != null
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: controller.closeThread,
                        tooltip: L10n.of(context).backToMainChat,
                        color: theme.colorScheme.onSecondaryContainer,
                      )
                    : FluffyThemes.isColumnMode(context)
                    ? null
                    : const Center(child: BackButton()),
                titleSpacing: FluffyThemes.isColumnMode(context) ? 24 : 0,
                title: ChatAppBarTitle(controller),
                actions: [
                  if (controller.selectMode) ...[
                    if (controller.canEditSelectedEvents)
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: L10n.of(context).edit,
                        onPressed: controller.editSelectedEventAction,
                      ),
                    if (controller.selectedEvents.length == 1 &&
                        controller.activeThreadId == null &&
                        controller.room.canSendDefaultMessages)
                      IconButton(
                        icon: const Icon(Icons.message_outlined),
                        tooltip: L10n.of(context).replyInThread,
                        onPressed: () => controller.enterThread(
                          controller.selectedEvents.single.eventId,
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.copy_outlined),
                      tooltip: L10n.of(context).copyToClipboard,
                      onPressed: controller.copyEventsAction,
                    ),
                    if (controller.canRedactSelectedEvents)
                      IconButton(
                        icon: const Icon(Icons.delete_outlined),
                        tooltip: L10n.of(context).redactMessage,
                        onPressed: controller.redactEventsAction,
                      ),
                    if (controller.selectedEvents.length == 1)
                      PopupMenuButton<_EventContextAction>(
                        useRootNavigator: true,
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
                          if (controller.canPinSelectedEvents)
                            PopupMenuItem(
                              onTap: controller.pinEvent,
                              value: null,
                              child: Row(
                                mainAxisSize: .min,
                                children: [
                                  const Icon(Icons.push_pin_outlined),
                                  const SizedBox(width: 12),
                                  Text(L10n.of(context).pinMessage),
                                ],
                              ),
                            ),
                          if (controller.canSaveSelectedEvent)
                            PopupMenuItem(
                              onTap: () =>
                                  controller.saveSelectedEvent(context),
                              value: null,
                              child: Row(
                                mainAxisSize: .min,
                                children: [
                                  const Icon(Icons.download_outlined),
                                  const SizedBox(width: 12),
                                  Text(L10n.of(context).downloadFile),
                                ],
                              ),
                            ),
                          PopupMenuItem(
                            value: _EventContextAction.info,
                            child: Row(
                              mainAxisSize: .min,
                              children: [
                                const Icon(Icons.info_outlined),
                                const SizedBox(width: 12),
                                Text(L10n.of(context).messageInfo),
                              ],
                            ),
                          ),
                          if (controller.selectedEvents.single.status.isSent)
                            PopupMenuItem(
                              value: _EventContextAction.report,
                              child: Row(
                                mainAxisSize: .min,
                                children: [
                                  const Icon(
                                    Icons.shield_outlined,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(L10n.of(context).reportMessage),
                                ],
                              ),
                            ),
                        ],
                      ),
                  ] else if (!controller.room.isArchived) ...[
                    if ((AppSettings.experimentalVoip.value &&
                        Matrix.of(context).voipPlugin != null &&
                        controller.room.isDirectChat))
                      IconButton(
                        onPressed: controller.onPhoneButtonTap,
                        icon: const Icon(Icons.call_outlined),
                        tooltip: L10n.of(context).placeCall,
                      )
                    else if (AppSettings.jitsiFeature.value)
                      JitsiPopupButton(controller.room),
                    ChatSettingsPopupMenu(controller.room, true),
                  ],
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(appbarBottomHeight),
                  child: Column(
                    mainAxisSize: .min,
                    children: [
                      PinnedEvents(controller),
                      if (activeThreadId != null)
                        SizedBox(
                          height: ChatAppBarListTile.fixedHeight,
                          child: Center(
                            child: TextButton.icon(
                              onPressed: () =>
                                  controller.scrollToEventId(activeThreadId),
                              icon: const Icon(Icons.message),
                              label: Text(L10n.of(context).replyInThread),
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    theme.colorScheme.onSecondaryContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (scrollUpBannerEventId != null &&
                          activeThreadId == null)
                        ChatAppBarListTile(
                          leading: IconButton(
                            color: theme.colorScheme.onSurfaceVariant,
                            icon: const Icon(Icons.close),
                            tooltip: L10n.of(context).close,
                            onPressed: () {
                              controller.discardScrollUpBannerEventId();
                              controller.setReadMarker();
                            },
                          ),
                          title: L10n.of(context).jumpToLastReadMessage,
                          trailing: TextButton(
                            onPressed: () {
                              controller.scrollToEventId(scrollUpBannerEventId);
                              controller.discardScrollUpBannerEventId();
                            },
                            child: Text(L10n.of(context).jump),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              floatingActionButton:
                  controller.showScrollDownButton &&
                      controller.selectedEvents.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(
                        bottom: theme.appBarTheme.toolbarHeight ?? 56,
                      ),
                      child: FloatingActionButton(
                        onPressed: controller.scrollDown,
                        heroTag: null,
                        mini: true,
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.colorScheme.onSurface,
                        child: const Icon(Icons.arrow_downward_outlined),
                      ),
                    )
                  : null,
              body: NotificationListener<SizeChangedLayoutNotification>(
                onNotification: (SizeChangedLayoutNotification notification) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => controller.updateInputBarHeight(),
                  );
                  return true;
                },
                child: DropTarget(
                  onDragDone: controller.onDragDone,
                  onDragEntered: controller.onDragEntered,
                  onDragExited: controller.onDragExited,
                  child: SafeArea(
                    top: false,
                    child: Stack(
                      children: <Widget>[
                        if (accountConfig.wallpaperUrl != null)
                          Opacity(
                            opacity: accountConfig.wallpaperOpacity ?? 0.5,
                            child: ImageFiltered(
                              imageFilter: ui.ImageFilter.blur(
                                sigmaX: accountConfig.wallpaperBlur ?? 0.0,
                                sigmaY: accountConfig.wallpaperBlur ?? 0.0,
                              ),
                              child: MxcImage(
                                cacheKey: accountConfig.wallpaperUrl.toString(),
                                uri: accountConfig.wallpaperUrl,
                                fit: BoxFit.cover,
                                height: MediaQuery.sizeOf(context).height,
                                width: MediaQuery.sizeOf(context).width,
                                isThumbnail: false,
                                placeholder: (_) => Container(),
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: controller.clearSingleSelectedEvent,
                          child: ChatEventList(controller: controller),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SizeChangedLayoutNotifier(
                            child: Container(
                              key: controller.inputBarKey,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.surface.withAlpha(0),
                                    theme.colorScheme.surface.withAlpha(0),
                                    theme.colorScheme.surface,
                                    theme.colorScheme.surface,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.all(bottomSheetPadding),
                                constraints: const BoxConstraints(
                                  maxWidth: FluffyThemes.maxTimelineWidth,
                                ),
                                child: controller.room.isExtinct
                                    ? ElevatedButton.icon(
                                        icon: const Icon(Icons.chevron_right),
                                        label: Text(
                                          L10n.of(context).enterNewChat,
                                        ),
                                        onPressed: controller.goToNewRoomAction,
                                      )
                                    : controller.room.canSendDefaultMessages &&
                                          controller.room.membership ==
                                              Membership.join
                                    ? Material(
                                        clipBehavior: Clip.hardEdge,
                                        color:
                                            controller.selectedEvents.isNotEmpty
                                            ? theme
                                                  .colorScheme
                                                  .tertiaryContainer
                                            : theme
                                                  .colorScheme
                                                  .surfaceContainer,
                                        borderRadius: BorderRadius.circular(32),
                                        child:
                                            controller.room.isAbandonedDMRoom ==
                                                true
                                            ? Row(
                                                mainAxisAlignment: .spaceEvenly,
                                                children: [
                                                  TextButton.icon(
                                                    style: TextButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            16,
                                                          ),
                                                      foregroundColor: theme
                                                          .colorScheme
                                                          .error,
                                                    ),
                                                    icon: const Icon(
                                                      Icons.archive_outlined,
                                                    ),
                                                    onPressed:
                                                        controller.leaveChat,
                                                    label: Text(
                                                      L10n.of(context).leave,
                                                    ),
                                                  ),
                                                  TextButton.icon(
                                                    style: TextButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            16,
                                                          ),
                                                    ),
                                                    icon: const Icon(
                                                      Icons.forum_outlined,
                                                    ),
                                                    onPressed:
                                                        controller.recreateChat,
                                                    label: Text(
                                                      L10n.of(
                                                        context,
                                                      ).reopenChat,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                mainAxisSize: .min,
                                                children: [
                                                  ReplyDisplay(controller),
                                                  ChatInputRow(controller),
                                                  ChatEmojiPicker(controller),
                                                ],
                                              ),
                                      )
                                    : SizedBox.shrink(),
                              ),
                            ),
                          ),
                        ),
                        if (controller.dragging)
                          Container(
                            color: theme.scaffoldBackgroundColor.withAlpha(230),
                            alignment: Alignment.center,
                            child: const Icon(Icons.upload_outlined, size: 100),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
