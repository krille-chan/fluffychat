import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_links/app_links.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_shortcuts_new/flutter_shortcuts_new.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list_view.dart';
import 'package:fluffychat/pangea/chat_list/utils/app_version_util.dart';
import 'package:fluffychat/pangea/chat_list/utils/chat_list_handle_space_tap.dart';
import 'package:fluffychat/pangea/chat_settings/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/common/constants/local.key.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/subscription/widgets/subscription_snackbar.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/show_scaffold_dialog.dart';
import 'package:fluffychat/utils/show_update_snackbar.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_modal_action_popup.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/share_scaffold_dialog.dart';
import '../../../utils/account_bundles.dart';
import '../../config/setting_keys.dart';
import '../../utils/url_launcher.dart';
import '../../widgets/matrix.dart';

import 'package:fluffychat/utils/tor_stub.dart'
    if (dart.library.html) 'package:tor_detector_web/tor_detector_web.dart';

enum PopupMenuAction {
  settings,
  invite,
  newGroup,
  newSpace,
  setStatus,
  archive,
}

enum ActiveFilter {
  allChats,
  messages,
  groups,
  unread,
  spaces,
}

extension LocalizedActiveFilter on ActiveFilter {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case ActiveFilter.allChats:
        return L10n.of(context).all;
      case ActiveFilter.messages:
        return L10n.of(context).messages;
      case ActiveFilter.unread:
        return L10n.of(context).unread;
      case ActiveFilter.groups:
        return L10n.of(context).groups;
      case ActiveFilter.spaces:
        return L10n.of(context).spaces;
    }
  }
}

class ChatList extends StatefulWidget {
  static BuildContext? contextForVoip;
  final String? activeChat;
  final bool displayNavigationRail;

  const ChatList({
    super.key,
    required this.activeChat,
    this.displayNavigationRail = false,
  });

  @override
  ChatListController createState() => ChatListController();
}

class ChatListController extends State<ChatList>
    with TickerProviderStateMixin, RouteAware {
  StreamSubscription? _intentDataStreamSubscription;

  StreamSubscription? _intentFileStreamSubscription;

  StreamSubscription? _intentUriStreamSubscription;

  ActiveFilter activeFilter = AppConfig.separateChatTypes
      ? ActiveFilter.messages
      : ActiveFilter.allChats;

  String? _activeSpaceId;
  String? get activeSpaceId => _activeSpaceId;

  void setActiveSpace(String spaceId) async {
    await Matrix.of(context).client.getRoomById(spaceId)!.postLoad();

    // #Pangea
    if (FluffyThemes.isColumnMode(context)) {
      context.push("/rooms/$spaceId/details");
    }
    // Pangea#

    setState(() {
      _activeSpaceId = spaceId;
    });
  }

  // #Pangea
  // void clearActiveSpace() => setState(() {
  //       _activeSpaceId = null;
  //     });
  void clearActiveSpace() {
    setState(() {
      _activeSpaceId = null;
    });
    context.go("/rooms");
  }
  // Pangea#

  void onChatTap(Room room) async {
    if (room.membership == Membership.invite) {
      final joinResult = await showFutureLoadingDialog(
        context: context,
        future: () async {
          final waitForRoom = room.client.waitForRoomInSync(
            room.id,
            join: true,
          );
          await room.join();
          await waitForRoom;
        },
        exceptionContext: ExceptionContext.joinRoom,
      );
      if (joinResult.error != null) return;
    }

    if (room.membership == Membership.ban) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context).youHaveBeenBannedFromThisChat),
        ),
      );
      return;
    }

    if (room.membership == Membership.leave) {
      context.go('/rooms/archive/${room.id}');
      return;
    }

    if (room.isSpace) {
      setActiveSpace(room.id);
      return;
    }

    context.go('/rooms/${room.id}');
  }

  bool Function(Room) getRoomFilterByActiveFilter(ActiveFilter activeFilter) {
    switch (activeFilter) {
      case ActiveFilter.allChats:
        // #Pangea
        // return (room) => true;
        return (room) => !room.isAnalyticsRoom;
      // Pangea#
      case ActiveFilter.messages:
        return (room) =>
            !room.isSpace &&
            room.isDirectChat // #Pangea
            &&
            !room.isAnalyticsRoom;
      // Pangea#
      case ActiveFilter.groups:
        return (room) =>
            !room.isSpace &&
            !room.isDirectChat // #Pangea
            &&
            !room.isAnalyticsRoom;
      // Pangea#
      case ActiveFilter.unread:
        return (room) =>
            room.isUnreadOrInvited // #Pangea
            &&
            !room.isAnalyticsRoom;
      // Pangea#
      case ActiveFilter.spaces:
        return (room) => room.isSpace;
    }
  }

  List<Room> get filteredRooms => Matrix.of(context)
      .client
      .rooms
      .where(getRoomFilterByActiveFilter(activeFilter))
      .toList();

  bool isSearchMode = false;
  Future<QueryPublicRoomsResponse>? publicRoomsResponse;
  String? searchServer;
  Timer? _coolDown;
  SearchUserDirectoryResponse? userSearchResult;
  QueryPublicRoomsResponse? roomSearchResult;

  bool isSearching = false;
  static const String _serverStoreNamespace = 'im.fluffychat.search.server';

  void setServer() async {
    final newServer = await showTextInputDialog(
      useRootNavigator: false,
      title: L10n.of(context).changeTheHomeserver,
      context: context,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      prefixText: 'https://',
      hintText: Matrix.of(context).client.homeserver?.host,
      initialText: searchServer,
      keyboardType: TextInputType.url,
      autocorrect: false,
      validator: (server) => server.contains('.') == true
          ? null
          : L10n.of(context).invalidServerName,
    );
    if (newServer == null) return;
    Matrix.of(context).store.setString(_serverStoreNamespace, newServer);
    setState(() {
      searchServer = newServer;
    });
    _coolDown?.cancel();
    _coolDown = Timer(const Duration(milliseconds: 500), _search);
  }

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  void _search() async {
    final client = Matrix.of(context).client;
    if (!isSearching) {
      setState(() {
        isSearching = true;
      });
    }
    SearchUserDirectoryResponse? userSearchResult;
    QueryPublicRoomsResponse? roomSearchResult;
    final searchQuery = searchController.text.trim();
    try {
      roomSearchResult = await client.queryPublicRooms(
        server: searchServer,
        filter: PublicRoomQueryFilter(genericSearchTerm: searchQuery),
        limit: 20,
      );

      if (searchQuery.isValidMatrixId &&
          searchQuery.sigil == '#' &&
          roomSearchResult.chunk
                  .any((room) => room.canonicalAlias == searchQuery) ==
              false) {
        final response = await client.getRoomIdByAlias(searchQuery);
        final roomId = response.roomId;
        if (roomId != null) {
          roomSearchResult.chunk.add(
            PublicRoomsChunk(
              name: searchQuery,
              guestCanJoin: false,
              numJoinedMembers: 0,
              roomId: roomId,
              worldReadable: false,
              canonicalAlias: searchQuery,
            ),
          );
        }
      }
      userSearchResult = await client.searchUserDirectory(
        searchController.text,
        limit: 20,
      );
    } catch (e, s) {
      Logs().w('Searching has crashed', e, s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toLocalizedString(context),
          ),
        ),
      );
    }
    if (!isSearchMode) return;
    setState(() {
      isSearching = false;
      this.roomSearchResult = roomSearchResult;
      this.userSearchResult = userSearchResult;
    });
  }

  void onSearchEnter(String text, {bool globalSearch = true}) {
    if (text.isEmpty) {
      cancelSearch(unfocus: false);
      return;
    }

    setState(() {
      isSearchMode = true;
    });
    _coolDown?.cancel();
    if (globalSearch) {
      _coolDown = Timer(const Duration(milliseconds: 500), _search);
    }
  }

  void startSearch() {
    setState(() {
      isSearchMode = true;
    });
    searchFocusNode.requestFocus();
    _coolDown?.cancel();
    _coolDown = Timer(const Duration(milliseconds: 500), _search);
  }

  void cancelSearch({bool unfocus = true}) {
    setState(() {
      searchController.clear();
      isSearchMode = false;
      roomSearchResult = userSearchResult = null;
      isSearching = false;
    });
    if (unfocus) searchFocusNode.unfocus();
  }

  bool isTorBrowser = false;

  BoxConstraints? snappingSheetContainerSize;

  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> scrolledToTop = ValueNotifier(true);

  final StreamController<Client> _clientStream = StreamController.broadcast();

  Stream<Client> get clientStream => _clientStream.stream;

  void addAccountAction() => context.go('/rooms/settings/account');

  void _onScroll() {
    final newScrolledToTop = scrollController.position.pixels <= 0;
    if (newScrolledToTop != scrolledToTop.value) {
      scrolledToTop.value = newScrolledToTop;
    }
  }

  void editSpace(BuildContext context, String spaceId) async {
    await Matrix.of(context).client.getRoomById(spaceId)!.postLoad();
    if (mounted) {
      context.push('/rooms/$spaceId/details');
    }
  }

  // Needs to match GroupsSpacesEntry for 'separate group' checking.
  List<Room> get spaces =>
      Matrix.of(context).client.rooms.where((r) => r.isSpace).toList();

  String? get activeChat => widget.activeChat;

  void _processIncomingSharedMedia(List<SharedMediaFile> files) {
    if (files.isEmpty) return;

    showScaffoldDialog(
      context: context,
      builder: (context) => ShareScaffoldDialog(
        items: files.map(
          (file) {
            if ({
              SharedMediaType.text,
              SharedMediaType.url,
            }.contains(file.type)) {
              return TextShareItem(file.path);
            }
            return FileShareItem(
              XFile(
                file.path.replaceFirst('file://', ''),
                mimeType: file.mimeType,
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  void _processIncomingUris(Uri? uri) async {
    if (uri == null) return;
    context.go('/rooms');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UrlLauncher(context, uri.toString()).openMatrixToUrl();
    });
  }

  void _initReceiveSharingIntent() {
    if (!PlatformInfos.isMobile) return;

    // For sharing images coming from outside the app while the app is in the memory
    _intentFileStreamSubscription = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen(_processIncomingSharedMedia, onError: print);

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then(_processIncomingSharedMedia);

    // For receiving shared Uris
    _intentUriStreamSubscription =
        AppLinks().uriLinkStream.listen(_processIncomingUris);

    if (PlatformInfos.isAndroid) {
      final shortcuts = FlutterShortcuts();
      shortcuts.initialize().then(
            (_) => shortcuts.listenAction((action) {
              if (!mounted) return;
              UrlLauncher(context, action).launchUrl();
            }),
          );
    }
  }

  //#Pangea
  StreamSubscription? classStream;
  StreamSubscription? _invitedSpaceSubscription;
  StreamSubscription? _subscriptionStatusStream;
  StreamSubscription? _spaceChildSubscription;
  StreamSubscription? _roomCapacitySubscription;
  final Set<String> hasUpdates = {};
  //Pangea#

  @override
  void initState() {
    _initReceiveSharingIntent();

    scrollController.addListener(_onScroll);
    _waitForFirstSync();
    _hackyWebRTCFixForWeb();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        searchServer =
            Matrix.of(context).store.getString(_serverStoreNamespace);
        Matrix.of(context).backgroundPush?.setupPush();
        UpdateNotifier.showUpdateSnackBar(context);
        // #Pangea
        AppVersionUtil.showAppVersionDialog(context);
        // Pangea#
      }

      // Workaround for system UI overlay style not applied on app start
      SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).appBarTheme.systemOverlayStyle!,
      );
    });

    _checkTorBrowser();

    //#Pangea
    classStream = MatrixState.pangeaController.classController.stateStream
        .listen((event) {
      if (mounted) {
        event["activeSpaceId"] != null
            ? setActiveSpace(event["activeSpaceId"])
            : clearActiveSpace();
        if (event["activeSpaceId"] != null) {
          context.push("/rooms/${event["activeSpaceId"]}/details");
        }
      }
    });

    _invitedSpaceSubscription = MatrixState
        .pangeaController.matrixState.client.onSync.stream
        .where((event) => event.rooms?.invite != null)
        .listen((event) async {
      for (final inviteEntry in event.rooms!.invite!.entries) {
        if (inviteEntry.value.inviteState == null) continue;
        final isSpace = inviteEntry.value.inviteState!.any(
          (event) =>
              event.type == EventTypes.RoomCreate &&
              event.content['type'] == 'm.space',
        );
        final isAnalytics = inviteEntry.value.inviteState!.any(
          (event) =>
              event.type == EventTypes.RoomCreate &&
              event.content['type'] == PangeaRoomTypes.analytics,
        );

        if (isSpace) {
          final spaceId = inviteEntry.key;
          final space =
              MatrixState.pangeaController.matrixState.client.getRoomById(
            spaceId,
          );

          // #Pangea
          final String? justInputtedCode =
              MatrixState.pangeaController.classController.chatBox.read(
            PLocalKey.justInputtedCode,
          );
          final newSpaceCode = space?.classCode(context);
          if (newSpaceCode == justInputtedCode) return;

          if (space != null) {
            chatListHandleSpaceTap(
              context,
              this,
              space,
            );
          }
        }

        if (isAnalytics) {
          final analyticsRoom = MatrixState.pangeaController.matrixState.client
              .getRoomById(inviteEntry.key);
          try {
            await analyticsRoom?.join();
          } catch (err, s) {
            ErrorHandler.logError(
              m: "Failed to join analytics room",
              e: err,
              s: s,
              data: {"analyticsRoom": analyticsRoom?.id},
            );
          }
          return;
        }
      }
    });

    _subscriptionStatusStream ??= MatrixState
        .pangeaController.subscriptionController.subscriptionStream.stream
        .listen((event) {
      if (mounted) {
        showSubscribedSnackbar(context);
      }
    });

    // listen for space child updates for any space that is not the active space
    // so that when the user navigates to the space that was updated, it will
    // reload any rooms that have been added / removed
    final client = MatrixState.pangeaController.matrixState.client;
    _spaceChildSubscription ??= client.onRoomState.stream.where((u) {
      return u.state.type == EventTypes.SpaceChild && u.roomId != activeSpaceId;
    }).listen((update) {
      hasUpdates.add(update.roomId);
    });

    // listen for room join events and leave room if over capacity
    _roomCapacitySubscription ??= client.onSync.stream
        .where((u) => u.rooms?.join != null)
        .listen((update) async {
      final roomUpdates = update.rooms!.join!.entries;
      for (final entry in roomUpdates) {
        final roomID = entry.key;
        final roomUpdate = entry.value;
        if (roomUpdate.timeline?.events == null) continue;
        final events = roomUpdate.timeline!.events;
        final memberEvents = events!.where(
          (event) =>
              event.type == EventTypes.RoomMember &&
              event.senderId == client.userID,
        );
        if (memberEvents.isEmpty) continue;
        final room = client.getRoomById(roomID);
        if (room == null ||
            room.isSpace ||
            room.isAnalyticsRoom ||
            room.capacity == null ||
            (room.summary.mJoinedMemberCount ?? 1) <= room.capacity!) {
          continue;
        }

        await showFutureLoadingDialog(
          context: context,
          future: () async {
            await room.leave();
            if (GoRouterState.of(context).uri.toString().contains(roomID)) {
              context.go("/rooms");
            }
            throw L10n.of(context).roomFull;
          },
        );
      }
    });
    // Pangea#

    super.initState();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    _intentFileStreamSubscription?.cancel();
    _intentUriStreamSubscription?.cancel();
    //#Pangea
    classStream?.cancel();
    _invitedSpaceSubscription?.cancel();
    _subscriptionStatusStream?.cancel();
    _spaceChildSubscription?.cancel();
    _roomCapacitySubscription?.cancel();
    //Pangea#
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void chatContextAction(
    Room room,
    BuildContext posContext, [
    Room? space,
  ]) async {
    final overlay =
        Overlay.of(posContext).context.findRenderObject() as RenderBox;

    final button = posContext.findRenderObject() as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(const Offset(0, -65), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + const Offset(-50, 0),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final displayname =
        room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)));

    final spacesWithPowerLevels = room.client.rooms
        .where(
          (space) =>
              space.isSpace &&
              space.canChangeStateEvent(EventTypes.SpaceChild) &&
              !space.spaceChildren.any((c) => c.roomId == room.id),
        )
        .toList();

    final action = await showMenu<ChatContextAction>(
      context: posContext,
      position: position,
      items: [
        PopupMenuItem(
          value: ChatContextAction.open,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Avatar(
                mxContent: room.avatar,
                size: Avatar.defaultSize / 2,
                name: displayname,
                // #Pangea
                presenceUserId: room.directChatMatrixID,
                // Pangea#
              ),
              const SizedBox(width: 12),
              Text(
                displayname,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        if (space != null)
          PopupMenuItem(
            value: ChatContextAction.goToSpace,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Avatar(
                  mxContent: space.avatar,
                  size: Avatar.defaultSize / 2,
                  name: space.getLocalizedDisplayname(),
                  // #Pangea
                  presenceUserId: space.directChatMatrixID,
                  // Pangea#
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    L10n.of(context).goToSpace(space.getLocalizedDisplayname()),
                  ),
                ),
              ],
            ),
          ),
        if (room.membership == Membership.join) ...[
          PopupMenuItem(
            value: ChatContextAction.mute,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  // #Pangea
                  // room.pushRuleState == PushRuleState.notify
                  //     ? Icons.notifications_off_outlined
                  //     : Icons.notifications_off,
                  room.pushRuleState == PushRuleState.notify
                      ? Icons.notifications_on_outlined
                      : Icons.notifications_off_outlined,
                  // Pangea#
                ),
                const SizedBox(width: 12),
                Text(
                  // #Pangea
                  // room.pushRuleState == PushRuleState.notify
                  //     ? L10n.of(context).muteChat
                  //     : L10n.of(context).unmuteChat,
                  room.pushRuleState == PushRuleState.notify
                      ? L10n.of(context).notificationsOn
                      : L10n.of(context).notificationsOff,
                  // Pangea#
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: ChatContextAction.markUnread,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  room.markedUnread
                      ? Icons.mark_as_unread
                      : Icons.mark_as_unread_outlined,
                ),
                const SizedBox(width: 12),
                Text(
                  room.markedUnread
                      ? L10n.of(context).markAsRead
                      : L10n.of(context).markAsUnread,
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: ChatContextAction.favorite,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  room.isFavourite ? Icons.push_pin : Icons.push_pin_outlined,
                ),
                const SizedBox(width: 12),
                Text(
                  room.isFavourite
                      ? L10n.of(context).unpin
                      : L10n.of(context).pin,
                ),
              ],
            ),
          ),
          if (spacesWithPowerLevels.isNotEmpty
                  // #Pangea
                  &&
                  !room.isSpace
              // Pangea#
              )
            PopupMenuItem(
              value: ChatContextAction.addToSpace,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.group_work_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context).addToSpace),
                ],
              ),
            ),
          // #Pangea
          // if the room has a parent for which the user has a high enough power level
          // to set parent's space child events, show option to remove the room from the space
          if (room.spaceParents.isNotEmpty &&
              room.pangeaSpaceParents.any(
                (r) => r.canChangeStateEvent(EventTypes.SpaceChild),
              ) &&
              activeSpaceId != null)
            PopupMenuItem(
              value: ChatContextAction.removeFromSpace,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.delete_sweep_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context).removeFromSpace),
                ],
              ),
            ),
          // Pangea#
        ],
        if (room.membership == Membership.invite)
          PopupMenuItem(
            value: ChatContextAction.block,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.block_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 12),
                Text(
                  L10n.of(context).block,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ),
          ),
        PopupMenuItem(
          value: ChatContextAction.leave,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_outlined,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 12),
              Text(
                room.membership == Membership.invite
                    ? L10n.of(context).delete
                    : L10n.of(context).leave,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (action == null) return;
    if (!mounted) return;

    switch (action) {
      case ChatContextAction.open:
        onChatTap(room);
        return;
      case ChatContextAction.goToSpace:
        setActiveSpace(space!.id);
        return;
      case ChatContextAction.favorite:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.setFavourite(!room.isFavourite),
        );
        return;
      case ChatContextAction.markUnread:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.markUnread(!room.markedUnread),
        );
        return;
      case ChatContextAction.mute:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.setPushRuleState(
            room.pushRuleState == PushRuleState.notify
                ? PushRuleState.mentionsOnly
                : PushRuleState.notify,
          ),
        );
        return;
      case ChatContextAction.leave:
        final confirmed = await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).areYouSure,
          // #Pangea
          // message: L10n.of(context).archiveRoomDescription,
          message: room.isSpace
              ? L10n.of(context).leaveSpaceDescription
              : L10n.of(context).archiveRoomDescription,
          // Pangea#
          okLabel: L10n.of(context).leave,
          cancelLabel: L10n.of(context).cancel,
          isDestructive: true,
        );
        if (confirmed == OkCancelResult.cancel) return;
        if (!mounted) return;

        // #Pangea
        // await showFutureLoadingDialog(context: context, future: room.leave);
        await showFutureLoadingDialog(
          context: context,
          future: room.isSpace ? room.leaveSpace : room.leave,
        );
        // Pangea#

        return;
      case ChatContextAction.addToSpace:
        final space = await showModalActionPopup(
          context: context,
          title: L10n.of(context).space,
          actions: spacesWithPowerLevels
              .map(
                (space) => AdaptiveModalAction(
                  value: space,
                  label: space
                      .getLocalizedDisplayname(MatrixLocals(L10n.of(context))),
                ),
              )
              .toList(),
        );
        if (space == null) return;
        // #Pangea
        if (room.isSpace) {
          final resp = await showOkCancelAlertDialog(
            context: context,
            title: L10n.of(context).addSubspaceWarning,
          );
          if (resp == OkCancelResult.cancel) return;
        }
        // Pangea#
        await showFutureLoadingDialog(
          context: context,
          // #Pangea
          // future: () => space.setSpaceChild(room.id),
          future: () async {
            try {
              await space.pangeaSetSpaceChild(room.id);
            } catch (err) {
              if (err is NestedSpaceError) {
                throw L10n.of(context).nestedSpaceError;
              } else {
                rethrow;
              }
            }
          },
          // Pangea#
        );
        // #Pangea
        return;
      case ChatContextAction.removeFromSpace:
        await showFutureLoadingDialog(
          context: context,
          future: () async {
            final futures = room.pangeaSpaceParents
                .where((r) => r.canChangeStateEvent(EventTypes.SpaceChild))
                .map((space) => removeSpaceChild(space, room.id));
            await Future.wait(futures);
          },
        );
        return;
      // Pangea#
      case ChatContextAction.block:
        final userId =
            room.getState(EventTypes.RoomMember, room.client.userID!)?.senderId;
        context.go('/rooms/settings/security/ignorelist', extra: userId);
    }
  }

  // #Pangea
  /// Remove a room from a space. Often, the user will have permission to set
  /// the SpaceChild event for the parent space, but not the SpaceParent event.
  /// This would cause a permissions error, but the child will still be removed
  /// via the SpaceChild event. If that's the case, silence the error.
  Future<void> removeSpaceChild(Room space, String roomId) async {
    try {
      await space.removeSpaceChild(roomId);
    } catch (err) {
      if ((err as MatrixException).error != MatrixError.M_FORBIDDEN) {
        rethrow;
      }
    }
  }
  // Pangea#

  void dismissStatusList() async {
    final result = await showOkCancelAlertDialog(
      title: L10n.of(context).hidePresences,
      context: context,
    );
    if (result == OkCancelResult.ok) {
      await Matrix.of(context).store.setBool(SettingKeys.showPresences, false);
      AppConfig.showPresences = false;
      setState(() {});
    }
  }

  void setStatus() async {
    final client = Matrix.of(context).client;
    final currentPresence = await client.fetchCurrentPresence(client.userID!);
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context).setStatus,
      message: L10n.of(context).leaveEmptyToClearStatus,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      hintText: L10n.of(context).statusExampleMessage,
      maxLines: 6,
      minLines: 1,
      maxLength: 255,
      initialText: currentPresence.statusMsg,
    );
    if (input == null) return;
    if (!mounted) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => client.setPresence(
        client.userID!,
        PresenceType.online,
        statusMsg: input,
      ),
    );
  }

  bool waitForFirstSync = false;

  Future<void> _waitForFirstSync() async {
    // #Pangea
    // final router = GoRouter.of(context);
    // Pangea#
    final client = Matrix.of(context).client;
    await client.roomsLoading;
    await client.accountDataLoading;
    await client.userDeviceKeysLoading;
    // #Pangea
    // See here for explanation of this change: https://github.com/pangeachat/client/pull/539
    // if (client.prevBatch == null) {
    if (client.onSync.value?.nextBatch == null) {
      // Pangea#
      await client.onSync.stream.first;

      // Display first login bootstrap if enabled
      // #Pangea
      // if (client.encryption?.keyManager.enabled == true) {
      //   if (await client.encryption?.keyManager.isCached() == false ||
      //       await client.encryption?.crossSigning.isCached() == false ||
      //       client.isUnknownSession && !mounted) {
      //     await BootstrapDialog(client: client).show(context);
      //   }
      // }
      // Pangea#
    }

    // #Pangea
    _initPangeaControllers(client);
    // Pangea#
    if (!mounted) return;
    setState(() {
      waitForFirstSync = true;
    });

    // #Pangea
    // if (client.userDeviceKeys[client.userID!]?.deviceKeys.values
    //         .any((device) => !device.verified && !device.blocked) ??
    //     false) {
    //   late final ScaffoldFeatureController controller;
    //   final theme = Theme.of(context);
    //   controller = ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       duration: const Duration(seconds: 15),
    //       showCloseIcon: true,
    //       backgroundColor: theme.colorScheme.errorContainer,
    //       closeIconColor: theme.colorScheme.onErrorContainer,
    //       content: Text(
    //         L10n.of(context).oneOfYourDevicesIsNotVerified,
    //         style: TextStyle(
    //           color: theme.colorScheme.onErrorContainer,
    //         ),
    //       ),
    //       action: SnackBarAction(
    //         onPressed: () {
    //           controller.close();
    //           router.go('/rooms/settings/devices');
    //         },
    //         textColor: theme.colorScheme.onErrorContainer,
    //         label: L10n.of(context).settings,
    //       ),
    //     ),
    //   );
    // }
    // Pangea#
  }

  // #Pangea
  void _initPangeaControllers(Client client) {
    GoogleAnalytics.analyticsUserUpdate(client.userID);
    MatrixState.pangeaController.initControllers();
    if (mounted) {
      MatrixState.pangeaController.classController.joinCachedSpaceCode(context);
    }
  }
  // Pangea#

  void setActiveFilter(ActiveFilter filter) {
    setState(() {
      activeFilter = filter;
    });
  }

  void setActiveClient(Client client) {
    context.go('/rooms');
    setState(() {
      activeFilter = ActiveFilter.allChats;
      _activeSpaceId = null;
      Matrix.of(context).setActiveClient(client);
    });
    _clientStream.add(client);
  }

  void setActiveBundle(String bundle) {
    context.go('/rooms');
    setState(() {
      _activeSpaceId = null;
      Matrix.of(context).activeBundle = bundle;
      if (!Matrix.of(context)
          .currentBundle!
          .any((client) => client == Matrix.of(context).client)) {
        Matrix.of(context)
            .setActiveClient(Matrix.of(context).currentBundle!.first);
      }
    });
  }

  void editBundlesForAccount(String? userId, String? activeBundle) async {
    final l10n = L10n.of(context);
    final client = Matrix.of(context)
        .widget
        .clients[Matrix.of(context).getClientIndexByMatrixId(userId!)];
    final action = await showModalActionPopup<EditBundleAction>(
      context: context,
      title: L10n.of(context).editBundlesForAccount,
      cancelLabel: L10n.of(context).cancel,
      actions: [
        AdaptiveModalAction(
          value: EditBundleAction.addToBundle,
          label: L10n.of(context).addToBundle,
        ),
        if (activeBundle != client.userID)
          AdaptiveModalAction(
            value: EditBundleAction.removeFromBundle,
            label: L10n.of(context).removeFromBundle,
          ),
      ],
    );
    if (action == null) return;
    switch (action) {
      case EditBundleAction.addToBundle:
        final bundle = await showTextInputDialog(
          context: context,
          title: l10n.bundleName,
          hintText: l10n.bundleName,
        );
        if (bundle == null || bundle.isEmpty || bundle.isEmpty) return;
        await showFutureLoadingDialog(
          context: context,
          future: () => client.setAccountBundle(bundle),
        );
        break;
      case EditBundleAction.removeFromBundle:
        await showFutureLoadingDialog(
          context: context,
          future: () => client.removeFromAccountBundle(activeBundle!),
        );
    }
  }

  bool get displayBundles =>
      Matrix.of(context).hasComplexBundles &&
      Matrix.of(context).accountBundles.keys.length > 1;

  String? get secureActiveBundle {
    if (Matrix.of(context).activeBundle == null ||
        !Matrix.of(context)
            .accountBundles
            .keys
            .contains(Matrix.of(context).activeBundle)) {
      return Matrix.of(context).accountBundles.keys.first;
    }
    return Matrix.of(context).activeBundle;
  }

  void resetActiveBundle() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        Matrix.of(context).activeBundle = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) => ChatListView(this);

  void _hackyWebRTCFixForWeb() {
    ChatList.contextForVoip = context;
  }

  Future<void> _checkTorBrowser() async {
    if (!kIsWeb) return;
    final isTor = await TorBrowserDetector.isTorBrowser;
    isTorBrowser = isTor;
  }

  Future<void> dehydrate() => Matrix.of(context).dehydrateAction(context);
}

enum EditBundleAction { addToBundle, removeFromBundle }

enum InviteActions {
  accept,
  decline,
  block,
}

enum ChatContextAction {
  open,
  goToSpace,
  favorite,
  markUnread,
  mute,
  leave,
  addToSpace,
  block,
  // #Pangea
  removeFromSpace,
  // Pangea#
}
