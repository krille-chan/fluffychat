import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:badges/badges.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_list_tile.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_title.dart';
import 'package:fluffychat/pages/chat/chat_event_list.dart';
import 'package:fluffychat/pages/chat/pinned_events.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_chat/activity_finished_status_message.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_chat/activity_menu_button.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_chat/activity_session_popup_menu.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_chat/activity_stats_menu.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_chat/load_activity_summary_widget.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_start/activity_session_start_page.dart';
import 'package:fluffychat/pangea/analytics_misc/level_up/star_rain_widget.dart';
import 'package:fluffychat/pangea/chat/widgets/chat_floating_action_button.dart';
import 'package:fluffychat/pangea/chat/widgets/chat_input_bar.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/navigation/navigation_util.dart';
import 'package:fluffychat/utils/account_config.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import 'package:fluffychat/widgets/unread_rooms_badge.dart';
import '../../utils/stream_extension.dart';

// #Pangea
// enum _EventContextAction { info, report }
// Pangea#

class ChatView extends StatelessWidget {
  final ChatController controller;

  const ChatView(this.controller, {super.key});

  List<Widget> _appBarActions(BuildContext context) {
    // #Pangea
    // if (controller.selectMode) {
    //   return [
    //     if (controller.canEditSelectedEvents)
    //       IconButton(
    //         icon: const Icon(Icons.edit_outlined),
    //         tooltip: L10n.of(context).edit,
    //         onPressed: controller.editSelectedEventAction,
    //       ),
    //     if (controller.selectedEvents.length == 1 &&
    //         controller.activeThreadId == null &&
    //         controller.room.canSendDefaultMessages)
    //       IconButton(
    //         icon: const Icon(Icons.message_outlined),
    //         tooltip: L10n.of(context).replyInThread,
    //         onPressed: () => controller.enterThread(
    //           controller.selectedEvents.single.eventId,
    //         ),
    //       ),
    //     IconButton(
    //       icon: const Icon(Icons.copy_outlined),
    //       tooltip: L10n.of(context).copyToClipboard,
    //       onPressed: controller.copyEventsAction,
    //     ),
    //     if (controller.canRedactSelectedEvents)
    //       IconButton(
    //         icon: const Icon(Icons.delete_outlined),
    //         tooltip: L10n.of(context).redactMessage,
    //         onPressed: controller.redactEventsAction,
    //       ),
    //     if (controller.selectedEvents.length == 1)
    //       PopupMenuButton<_EventContextAction>(
    //         useRootNavigator: true,
    //         onSelected: (action) {
    //           switch (action) {
    //             case _EventContextAction.info:
    //               controller.showEventInfo();
    //               controller.clearSelectedEvents();
    //               break;
    //             case _EventContextAction.report:
    //               controller.reportEventAction();
    //               break;
    //           }
    //         },
    //         itemBuilder: (context) => [
    //           if (controller.canPinSelectedEvents)
    //             PopupMenuItem(
    //               onTap: controller.pinEvent,
    //               value: null,
    //               child: Row(
    //                 mainAxisSize: .min,
    //                 children: [
    //                   const Icon(Icons.push_pin_outlined),
    //                   const SizedBox(width: 12),
    //                   Text(L10n.of(context).pinMessage),
    //                 ],
    //               ),
    //             ),
    //           if (controller.canSaveSelectedEvent)
    //             PopupMenuItem(
    //               onTap: () => controller.saveSelectedEvent(context),
    //               value: null,
    //               child: Row(
    //                 mainAxisSize: .min,
    //                 children: [
    //                   const Icon(Icons.download_outlined),
    //                   const SizedBox(width: 12),
    //                   Text(L10n.of(context).downloadFile),
    //                 ],
    //               ),
    //             ),
    //           PopupMenuItem(
    //             value: _EventContextAction.info,
    //             child: Row(
    //               mainAxisSize: .min,
    //               children: [
    //                 const Icon(Icons.info_outlined),
    //                 const SizedBox(width: 12),
    //                 Text(L10n.of(context).messageInfo),
    //               ],
    //             ),
    //           ),
    //           if (controller.selectedEvents.single.status.isSent)
    //             PopupMenuItem(
    //               value: _EventContextAction.report,
    //               child: Row(
    //                 mainAxisSize: .min,
    //                 children: [
    //                   const Icon(Icons.shield_outlined, color: Colors.red),
    //                   const SizedBox(width: 12),
    //                   Text(L10n.of(context).reportMessage),
    //                 ],
    //               ),
    //             ),
    //         ],
    //       ),
    //   ];
    // } else if (!controller.room.isArchived) {
    //   return [
    //     if (AppSettings.experimentalVoip.value &&
    //         Matrix.of(context).voipPlugin != null &&
    //         controller.room.isDirectChat)
    //       IconButton(
    //         onPressed: controller.onPhoneButtonTap,
    //         icon: const Icon(Icons.call_outlined),
    //         tooltip: L10n.of(context).placeCall,
    //       ),
    //     EncryptionButton(controller.room),
    //     ChatSettingsPopupMenu(controller.room, true),
    //   ];
    // }
    // return [];
    if (controller.room.isArchived || controller.room.hasArchivedActivity) {
      return [];
    }

    if (controller.room.showActivityChatUI) {
      return [
        ActivityMenuButton(controller: controller),
        ActivitySessionPopupMenu(controller.room, onLeave: controller.onLeave),
      ];
    }

    return [
      IconButton(
        icon: const Icon(Icons.search_outlined),
        tooltip: L10n.of(context).search,
        onPressed: () {
          NavigationUtil.goToSpaceRoute(controller.room.id, [
            'search',
          ], context);
        },
      ),
      IconButton(
        icon: const Icon(Icons.settings_outlined),
        tooltip: L10n.of(context).chatDetails,
        onPressed: () {
          if (GoRouterState.of(context).uri.path.endsWith('/details')) {
            NavigationUtil.goToSpaceRoute(controller.room.id, [], context);
          } else {
            NavigationUtil.goToSpaceRoute(controller.room.id, [
              'details',
            ], context);
          }
        },
      ),
    ];
    // Pangea#
  }

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
            // #Pangea
            if (controller.room.isActivitySession &&
                !controller.room.isActivityStarted) {
              return ActivitySessionStartPage(
                activityId: controller.room.activityId!,
                roomId: controller.roomId,
                parentId: controller.room.courseParent?.id,
              );
            }
            // Pangea#
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
              appBar: AppBar(
                // #Pangea
                // actionsIconTheme: IconThemeData(
                //   color: controller.selectedEvents.isEmpty
                //       ? null
                //       : theme.colorScheme.onTertiaryContainer,
                // ),
                // backgroundColor: controller.selectedEvents.isEmpty
                //     ? controller.activeThreadId != null
                //           ? theme.colorScheme.secondaryContainer
                //           : null
                //     : theme.colorScheme.tertiaryContainer,
                // Pangea#
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
                    // #Pangea
                    : controller.widget.backButton != null
                    ? controller.widget.backButton!
                    // : FluffyThemes.isColumnMode(context)
                    // ? null
                    // Pangea#
                    : StreamBuilder<Object>(
                        stream: Matrix.of(context).client.onSync.stream.where(
                          (syncUpdate) => syncUpdate.hasRoomUpdate,
                        ),
                        // #Pangea
                        // builder: (context, _) => UnreadRoomsBadge(
                        //   filter: (r) => r.id != controller.roomId,
                        //   badgePosition: BadgePosition.topEnd(end: 8, top: 4),
                        //   child: const Center(child: BackButton()),
                        // ),
                        builder: (context, _) => Center(
                          child: SizedBox(
                            height: kToolbarHeight,
                            child: UnreadRoomsBadge(
                              filter: (r) => r.id != controller.roomId,
                              badgePosition: BadgePosition.topEnd(
                                end: 8,
                                top: 9,
                              ),
                              child: const Center(child: BackButton()),
                            ),
                          ),
                        ),
                        // Pangea#
                      ),
                titleSpacing: FluffyThemes.isColumnMode(context) ? 24 : 0,
                title: ChatAppBarTitle(controller),
                actions: _appBarActions(context),
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
              // #Pangea
              // floatingActionButton:
              //     controller.showScrollDownButton &&
              //         controller.selectedEvents.isEmpty
              //     ? Padding(
              //         padding: const EdgeInsets.only(bottom: 56.0),
              //         child: FloatingActionButton(
              //           onPressed: controller.scrollDown,
              //           heroTag: null,
              //           mini: true,
              //           backgroundColor: theme.colorScheme.surface,
              //           foregroundColor: theme.colorScheme.onSurface,
              //           child: const Icon(Icons.arrow_downward_outlined),
              //         ),
              //       )
              //     : null,
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 56.0),
                child: ChatFloatingActionButton(controller: controller),
              ),
              // body: DropTarget(
              //   onDragDone: controller.onDragDone,
              //   onDragEntered: controller.onDragEntered,
              //   onDragExited: controller.onDragExited,
              //   child: Stack(
              body: SafeArea(
                child: Stack(
                  // Pangea#
                  children: <Widget>[
                    // #Pangea
                    // if (accountConfig.wallpaperUrl != null)
                    // Only use activity image as chat background if enabled in AppConfig
                    if (controller.room.activityPlan != null &&
                        controller.room.activityPlan!.imageURL != null &&
                        AppConfig.useActivityImageAsChatBackground)
                      Opacity(
                        opacity: 0.25,
                        child: ImageFiltered(
                          imageFilter: ui.ImageFilter.blur(
                            sigmaX: accountConfig.wallpaperBlur ?? 0.0,
                            sigmaY: accountConfig.wallpaperBlur ?? 0.0,
                          ),
                          child:
                              controller.room.activityPlan!.imageURL!
                                  .toString()
                                  .startsWith('mxc')
                              ? MxcImage(
                                  uri: controller.room.activityPlan!.imageURL!,
                                  fit: BoxFit.cover,
                                  height: MediaQuery.sizeOf(context).height,
                                  width: MediaQuery.sizeOf(context).width,
                                  cacheKey: controller
                                      .room
                                      .activityPlan!
                                      .imageURL
                                      .toString(),
                                  isThumbnail: false,
                                )
                              : Image.network(
                                  controller.room.activityPlan!.imageURL
                                      .toString(),
                                  fit: BoxFit.cover,
                                  height: MediaQuery.sizeOf(context).height,
                                  width: MediaQuery.sizeOf(context).width,
                                  headers:
                                      controller.room.activityPlan!.imageURL
                                          .toString()
                                          .contains(Environment.cmsApi)
                                      ? {
                                          'Authorization':
                                              'Bearer ${MatrixState.pangeaController.userController.accessToken}',
                                        }
                                      : null,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(),
                                ),
                        ),
                      )
                    // If not enabled, fall through to default wallpaper logic
                    else if (accountConfig.wallpaperUrl != null)
                      // Pangea#
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
                    SafeArea(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              // #Pangea
                              // onTap: controller.clearSingleSelectedEvent,
                              // child: ChatEventList(controller: controller),
                              child: ListenableBuilder(
                                listenable: controller.timelineUpdateNotifier,
                                builder: (context, _) {
                                  return ChatEventList(controller: controller);
                                },
                              ),
                              // Pangea#
                            ),
                          ),
                          // #Pangea
                          // if (controller.showScrollDownButton)
                          //   Divider(height: 1, color: theme.dividerColor),
                          ListenableBuilder(
                            listenable: controller.scrollController,
                            builder: (context, _) {
                              if (controller.scrollController.hasClients &&
                                  controller.scrollController.position.pixels >
                                      0) {
                                return Divider(
                                  height: 1,
                                  color: theme.dividerColor,
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                          // Pangea#
                          if (controller.room.isExtinct)
                            Container(
                              margin: EdgeInsets.all(bottomSheetPadding),
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.chevron_right),
                                label: Text(L10n.of(context).enterNewChat),
                                onPressed: controller.goToNewRoomAction,
                              ),
                            )
                          // #Pangea
                          // else if (controller.room.canSendDefaultMessages &&
                          //     controller.room.membership == Membership.join)
                          //   Container(
                          //     margin: EdgeInsets.all(bottomSheetPadding),
                          //     constraints: const BoxConstraints(
                          //       maxWidth: FluffyThemes.maxTimelineWidth,
                          //     ),
                          //     alignment: Alignment.center,
                          //     child: Material(
                          //       clipBehavior: Clip.hardEdge,
                          //       color: controller.selectedEvents.isNotEmpty
                          //           ? theme.colorScheme.tertiaryContainer
                          //           : theme.colorScheme.surfaceContainerHigh,
                          //       borderRadius: const BorderRadius.all(
                          //         Radius.circular(24),
                          //       ),
                          //       child: controller.room.isAbandonedDMRoom == true
                          //           ? Row(
                          //               mainAxisAlignment: .spaceEvenly,
                          //               children: [
                          //                 TextButton.icon(
                          //                   style: TextButton.styleFrom(
                          //                     padding: const EdgeInsets.all(16),
                          //                     foregroundColor:
                          //                         theme.colorScheme.error,
                          //                   ),
                          //                   icon: const Icon(
                          //                     Icons.archive_outlined,
                          //                   ),
                          //                   onPressed: controller.leaveChat,
                          //                   label: Text(L10n.of(context).leave),
                          //                 ),
                          //                 TextButton.icon(
                          //                   style: TextButton.styleFrom(
                          //                     padding: const EdgeInsets.all(16),
                          //                   ),
                          //                   icon: const Icon(
                          //                     Icons.forum_outlined,
                          //                   ),
                          //                   onPressed: controller.recreateChat,
                          //                   label: Text(
                          //                     L10n.of(context).reopenChat,
                          //                   ),
                          //                 ),
                          //               ],
                          //             )
                          //           : Column(
                          //               mainAxisSize: .min,
                          //               children: [
                          //                 ReplyDisplay(controller),
                          //                 ChatInputRow(controller),
                          //                 ChatEmojiPicker(controller),
                          //               ],
                          //             ),
                          //     ),
                          //   ),
                          else if (controller.room.canSendDefaultMessages &&
                              controller.room.membership == Membership.join &&
                              (controller.room.activityPlan == null ||
                                  !controller.room.showActivityChatUI ||
                                  controller.room.isActiveInActivity))
                            ChatInputBar(
                              controller: controller,
                              padding: bottomSheetPadding,
                            )
                          else if (controller.room.activityPlan != null &&
                              controller.room.showActivityChatUI &&
                              !controller.room.isActiveInActivity)
                            ActivityFinishedStatusMessage(
                              controller: controller,
                            ),
                          if (controller.room.isActivityFinished)
                            LoadActivitySummaryWidget(room: controller.room),
                          // Pangea#
                        ],
                      ),
                    ),
                    // #Pangea
                    ActivityStatsMenu(controller),
                    if (controller.room.activitySummary?.summary != null)
                      ValueListenableBuilder(
                        valueListenable:
                            controller.activityController.hasRainedConfetti,
                        builder: (context, hasRained, _) {
                          return hasRained
                              ? const SizedBox()
                              : StarRainWidget(
                                  showBlast: true,
                                  onFinished: () => controller
                                      .activityController
                                      .setHasRainedConfetti(true),
                                );
                        },
                      ),
                    // if (controller.dragging)
                    //   Container(
                    //     color: theme.scaffoldBackgroundColor.withAlpha(230),
                    //     alignment: Alignment.center,
                    //     child: const Icon(Icons.upload_outlined, size: 100),
                    //   ),
                    // Pangea#
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
