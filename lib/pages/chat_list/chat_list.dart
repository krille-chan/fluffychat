import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_shortcuts/flutter_shortcuts.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:tawkie/config/setting_keys.dart';
import 'package:tawkie/pages/add_bridge/model/social_network.dart';
import 'package:tawkie/pages/bootstrap/bootstrap_dialog.dart';
import 'package:tawkie/pages/chat/send_file_dialog.dart';
import 'package:tawkie/utils/account_bundles.dart';
import 'package:tawkie/utils/matrix_sdk_extensions/matrix_file_extension.dart';
import 'package:tawkie/utils/show_update_snackbar.dart';
import 'package:tawkie/utils/url_launcher.dart';
import 'package:tawkie/utils/voip/callkeep_manager.dart';
import 'package:tawkie/widgets/avatar.dart';
import 'package:tawkie/widgets/fluffy_chat_app.dart';
import 'package:tawkie/widgets/matrix.dart';
import 'package:uni_links/uni_links.dart';

import 'package:tawkie/config/app_config.dart';
import 'package:tawkie/config/themes.dart';
import 'package:tawkie/pages/chat_list/chat_list_view.dart';
import 'package:tawkie/utils/localized_exception_extension.dart';
import 'package:tawkie/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:tawkie/utils/platform_infos.dart';

import 'package:tawkie/utils/tor_stub.dart'
    if (dart.library.html) 'package:tor_detector_web/tor_detector_web.dart';

enum SelectMode {
  normal,
  share,
}

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
        return L10n.of(context)!.all;
      case ActiveFilter.messages:
        return L10n.of(context)!.messages;
      case ActiveFilter.unread:
        return L10n.of(context)!.unread;
      case ActiveFilter.groups:
        return L10n.of(context)!.groups;
      case ActiveFilter.spaces:
        return L10n.of(context)!.spaces;
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

  void createNewSpace() {
    context.push<String?>('/rooms/newspace');
  }

  ActiveFilter activeFilter = AppConfig.separateChatTypes
      ? ActiveFilter.messages
      : ActiveFilter.allChats;

  String? _activeSpaceId;
  String? get activeSpaceId => _activeSpaceId;

  Set<String> loadingRooms = Set<String>();

  void setActiveSpace(String spaceId) async {
    await Matrix.of(context).client.getRoomById(spaceId)!.postLoad();

    setState(() {
      _activeSpaceId = spaceId;
    });
  }

  void clearActiveSpace() => setState(() {
        _activeSpaceId = null;
      });

  void onChatTap(Room room) async {
    if (room.membership == Membership.invite) {
      final inviterId =
          room.getState(EventTypes.RoomMember, room.client.userID!)?.senderId;
      final inviteAction = await showModalActionSheet<InviteActions>(
        context: context,
        message: room.isDirectChat
            ? L10n.of(context)!.invitePrivateChat
            : L10n.of(context)!.inviteGroupChat,
        title: room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!)),
        actions: [
          SheetAction(
            key: InviteActions.accept,
            label: L10n.of(context)!.accept,
            icon: Icons.check_outlined,
            isDefaultAction: true,
          ),
          SheetAction(
            key: InviteActions.decline,
            label: L10n.of(context)!.decline,
            icon: Icons.close_outlined,
            isDestructiveAction: true,
          ),
          SheetAction(
            key: InviteActions.block,
            label: L10n.of(context)!.block,
            icon: Icons.block_outlined,
            isDestructiveAction: true,
          ),
        ],
      );
      if (inviteAction == null) return;
      if (inviteAction == InviteActions.block) {
        context.go('/rooms/settings/security/ignorelist', extra: inviterId);
        return;
      }
      if (inviteAction == InviteActions.decline) {
        await showFutureLoadingDialog(
          context: context,
          future: room.leave,
        );
        return;
      }
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
      );
      if (joinResult.error != null) return;
    }

    if (room.membership == Membership.ban) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.youHaveBeenBannedFromThisChat),
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
    // Share content into this room
    final shareContent = Matrix.of(context).shareContent;
    if (shareContent != null) {
      final shareFile = shareContent.tryGet<MatrixFile>('file');
      if (shareContent.tryGet<String>('msgtype') == 'chat.fluffy.shared_file' &&
          shareFile != null) {
        await showDialog(
          context: context,
          useRootNavigator: false,
          builder: (c) => SendFileDialog(
            files: [shareFile],
            room: room,
          ),
        );
        Matrix.of(context).shareContent = null;
      } else {
        final consent = await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context)!.forward,
          message: L10n.of(context)!.forwardMessageTo(
            room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!)),
          ),
          okLabel: L10n.of(context)!.forward,
          cancelLabel: L10n.of(context)!.cancel,
        );
        if (consent == OkCancelResult.cancel) {
          Matrix.of(context).shareContent = null;
          return;
        }
        if (consent == OkCancelResult.ok) {
          room.sendEvent(shareContent);
          Matrix.of(context).shareContent = null;
        }
      }
    }

    context.go('/rooms/${room.id}');
  }

  bool Function(Room) getRoomFilterByActiveFilter(ActiveFilter activeFilter) {
    switch (activeFilter) {
      case ActiveFilter.allChats:
        return (room) => true;
      case ActiveFilter.messages:
        return (room) => !room.isSpace && room.isDirectChat;
      case ActiveFilter.groups:
        return (room) => !room.isSpace && !room.isDirectChat;
      case ActiveFilter.unread:
        return (room) => room.isUnreadOrInvited;
      case ActiveFilter.spaces:
        return (room) => room.isSpace;
    }
  }

  // Maps a roomId to a cached boolean value indicating
  // whether the room is a Direct Chat with a bridge bot
  // or a user conversation.
  // false => hide the room (bot conversation)
  // true => display the room (user conversation)
  final Map<String, bool> _roomBotCheckCache = {};

  // Returns false if given room is a Direct Chat with a bridge bot
  bool hideBotsRoomFilter(Room room) {
    // return cached value if available
    final cached = _roomBotCheckCache[room.id];
    if (cached != null) {
      return cached;
    }

    // We check whether Matrix thinks this room is a direct chat
    // with a bot. This is relatively quick but not always accurate.
    final bool quickCheck =
        !SocialNetworkManager.isBridgeBotId(room.directChatMatrixID);

    // update cache
    _roomBotCheckCache[room.id] = quickCheck;

    // For a more accurate check, we need to check the participants
    // of the room. This is more expensive and is done in the background.
    // see preloadRoomBotChecks()
    return quickCheck;
  }

  List<Room> get filteredRooms => Matrix.of(context)
      .client
      .rooms
      .where(getRoomFilterByActiveFilter(activeFilter))
      .where(hideBotsRoomFilter)
      .toList();

  Future<bool> isGroupWithOnlyBotAndUser(Room room) async {
    final client = Matrix.of(context).client;

    // Check that participants are fully charged
    if (!room.participantListComplete && !loadingRooms.contains(room.id)) {
      loadingRooms.add(room.id);
      await room.requestParticipants();
      loadingRooms.remove(room.id);
    }

    final participants = room.getParticipants();

    if (participants.length != 2) {
      // update cache
      _roomBotCheckCache[room.id] = true; // true => displayed
      return false;
    }

    // Check whether participants include the current user and one of the bots
    final userIds = participants
        .map((user) => user.id)
        .toList(); // perf: only 2 participants
    final containsCurrentUser = userIds.contains(client.userID);
    final containsBot = userIds.any((id) =>
        id.contains('bot', 1) && SocialNetworkManager.isBridgeBotId(id));

    final isBotRoom = containsCurrentUser && containsBot;
    // update cache
    _roomBotCheckCache[room.id] = !isBotRoom; // true => displayed
    return isBotRoom;
  }

  Future<void> preloadRoomBotChecks(List<Room> rooms) async {
    for (final room in rooms) {
      await isGroupWithOnlyBotAndUser(room);
      // cache updates are handled in isGroupWithOnlyBotAndUser
    }
  }

  // Method to identify and remove duplicate bot rooms
  Future<void> identifyAndRemoveDuplicates(List<Room> rooms) async {
    final Map<String, List<Room>> roomMap = {};

    for (final room in rooms) {
      // cache should be fully populated by now
      final isBotRoom = _roomBotCheckCache[room.id] == false;

      if (isBotRoom) {
        final botId = room.directChatMatrixID ??
            room
                .getParticipants()
                // perf: room should only contain 2 participants
                .map((matrixUser) => matrixUser.id)
                .firstWhere(
                  (matrixId) => SocialNetworkManager.isBridgeBotId(matrixId),
                  orElse: () => '',
                );

        if (botId.isNotEmpty) {
          if (!roomMap.containsKey(botId)) {
            roomMap[botId] = [];
          }
          roomMap[botId]!.add(room);
        }
      }
    }

    // Check and remove duplicates
    for (final entry in roomMap.entries) {
      final roomList = entry.value;
      if (roomList.length > 1) {
        // Sort by the timestamp of the last event (ascending order)
        roomList.sort((a, b) =>
            a.lastEvent?.originServerTs
                .compareTo(b.lastEvent!.originServerTs) ??
            0);

        // Keep the room with the oldest event and remove all others
        for (int i = 1; i < roomList.length; i++) {
          final room = roomList[i];
          await room.leave();
        }
      }
    }
  }

  bool isSearchMode = false;
  Future<QueryPublicRoomsResponse>? publicRoomsResponse;
  String? searchServer;
  Timer? _coolDown;
  SearchUserDirectoryResponse? userSearchResult;
  QueryPublicRoomsResponse? roomSearchResult;

  bool isSearching = false;
  static const String _serverStoreNamespace = 'im.tawkie.search.server';

  void setServer() async {
    final newServer = await showTextInputDialog(
      useRootNavigator: false,
      title: L10n.of(context)!.changeTheHomeserver,
      context: context,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [
        DialogTextField(
          prefixText: 'https://',
          hintText: Matrix.of(context).client.homeserver?.host,
          initialText: searchServer,
          keyboardType: TextInputType.url,
          autocorrect: false,
          validator: (server) => server?.contains('.') == true
              ? null
              : L10n.of(context)!.invalidServerName,
        ),
      ],
    );
    if (newServer == null) return;
    Matrix.of(context).store.setString(_serverStoreNamespace, newServer.single);
    setState(() {
      searchServer = newServer.single;
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

  SelectMode get selectMode => Matrix.of(context).shareContent != null
      ? SelectMode.share
      : SelectMode.normal;

  void _processIncomingSharedFiles(List<SharedMediaFile> files) {
    if (files.isEmpty) return;
    final file = File(files.first.path.replaceFirst('file://', ''));

    Matrix.of(context).shareContent = {
      'msgtype': 'chat.fluffy.shared_file',
      'file': MatrixFile(
        bytes: file.readAsBytesSync(),
        name: file.path,
      ).detectFileType,
    };
    context.go('/rooms');
  }

  void _processIncomingSharedText(String? text) {
    if (text == null) return;
    if (text.toLowerCase().startsWith(AppConfig.deepLinkPrefix) ||
        text.toLowerCase().startsWith(AppConfig.inviteLinkPrefix) ||
        (text.toLowerCase().startsWith(AppConfig.schemePrefix) &&
            !RegExp(r'\s').hasMatch(text))) {
      return _processIncomingUris(text);
    }
    Matrix.of(context).shareContent = {
      'msgtype': 'm.text',
      'body': text,
    };
    context.go('/rooms');
  }

  void _processIncomingUris(String? text) async {
    if (text == null) return;
    context.go('/rooms');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UrlLauncher(context, text).openMatrixToUrl();
    });
  }

  void _initReceiveSharingIntent() {
    if (!PlatformInfos.isMobile) return;

    // For sharing images coming from outside the app while the app is in the memory
    _intentFileStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen(_processIncomingSharedFiles, onError: print);

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then(_processIncomingSharedFiles);

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream()
        .listen(_processIncomingSharedText, onError: print);

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then(_processIncomingSharedText);

    // For receiving shared Uris
    _intentUriStreamSubscription = linkStream.listen(_processIncomingUris);
    if (FluffyChatApp.gotInitialLink == false) {
      FluffyChatApp.gotInitialLink = true;
      getInitialLink().then(_processIncomingUris);
    }

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

  @override
  void initState() {
    super.initState();

    _initReceiveSharingIntent();
    scrollController.addListener(_onScroll);
    _waitForFirstSync();
    _hackyWebRTCFixForWeb();
    CallKeepManager().initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        searchServer =
            Matrix.of(context).store.getString(_serverStoreNamespace);
        Matrix.of(context).backgroundPush?.setupPush();
        UpdateNotifier.showUpdateSnackBar(context);
      }

      // Workaround for system UI overlay style not applied on app start
      SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).appBarTheme.systemOverlayStyle!,
      );

      await preloadRoomBotChecks(Matrix.of(context).client.rooms);
      await identifyAndRemoveDuplicates(filteredRooms);
      setState(() {}); // Force a rebuild after all futures are completed
    });

    _checkTorBrowser();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    _intentFileStreamSubscription?.cancel();
    _intentUriStreamSubscription?.cancel();
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void chatContextAction(
    Room room,
    BuildContext posContext, [
    Room? space,
  ]) async {
    if (room.membership == Membership.invite) {
      return onChatTap(room);
    }

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
        room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!));

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
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    L10n.of(context)!
                        .goToSpace(space.getLocalizedDisplayname()),
                  ),
                ),
              ],
            ),
          ),
        PopupMenuItem(
          value: ChatContextAction.mute,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                room.pushRuleState == PushRuleState.notify
                    ? Icons.notifications_off_outlined
                    : Icons.notifications_off,
              ),
              const SizedBox(width: 12),
              Text(
                room.pushRuleState == PushRuleState.notify
                    ? L10n.of(context)!.muteChat
                    : L10n.of(context)!.unmuteChat,
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
                    ? L10n.of(context)!.markAsRead
                    : L10n.of(context)!.markAsUnread,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ChatContextAction.favorite,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(room.isFavourite ? Icons.push_pin : Icons.push_pin_outlined),
              const SizedBox(width: 12),
              Text(
                room.isFavourite
                    ? L10n.of(context)!.unpin
                    : L10n.of(context)!.pin,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ChatContextAction.leave,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outlined),
              const SizedBox(width: 12),
              Text(L10n.of(context)!.leave),
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
          useRootNavigator: false,
          context: context,
          title: L10n.of(context)!.areYouSure,
          okLabel: L10n.of(context)!.leave,
          cancelLabel: L10n.of(context)!.no,
          message: L10n.of(context)!.archiveRoomDescription,
          isDestructiveAction: true,
        );
        if (confirmed == OkCancelResult.cancel) return;
        if (!mounted) return;

        await showFutureLoadingDialog(context: context, future: room.leave);

        return;
    }
  }

  void dismissStatusList() async {
    final result = await showOkCancelAlertDialog(
      title: L10n.of(context)!.hidePresences,
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
      title: L10n.of(context)!.setStatus,
      message: L10n.of(context)!.leaveEmptyToClearStatus,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context)!.statusExampleMessage,
          maxLines: 6,
          minLines: 1,
          maxLength: 255,
          initialText: currentPresence.statusMsg,
        ),
      ],
    );
    if (input == null) return;
    if (!mounted) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => client.setPresence(
        client.userID!,
        PresenceType.online,
        statusMsg: input.single,
      ),
    );
  }

  bool waitForFirstSync = false;

  Future<void> _waitForFirstSync() async {
    final client = Matrix.of(context).client;
    await client.roomsLoading;
    await client.accountDataLoading;
    await client.userDeviceKeysLoading;
    if (client.prevBatch == null) {
      await client.onSync.stream.first;

      // Display first login bootstrap if enabled
      if (client.encryption?.keyManager.enabled == true) {
        if (await client.encryption?.keyManager.isCached() == false ||
            await client.encryption?.crossSigning.isCached() == false ||
            client.isUnknownSession && !mounted) {
          await BootstrapDialog(client: client).show(context);
        }
      }
    }
    if (!mounted) return;
    setState(() {
      waitForFirstSync = true;
    });
  }

  void cancelAction() {
    if (selectMode == SelectMode.share) {
      setState(() => Matrix.of(context).shareContent = null);
    }
  }

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
    final l10n = L10n.of(context)!;
    final client = Matrix.of(context)
        .widget
        .clients[Matrix.of(context).getClientIndexByMatrixId(userId!)];
    final action = await showConfirmationDialog<EditBundleAction>(
      context: context,
      title: L10n.of(context)!.editBundlesForAccount,
      actions: [
        AlertDialogAction(
          key: EditBundleAction.addToBundle,
          label: L10n.of(context)!.addToBundle,
        ),
        if (activeBundle != client.userID)
          AlertDialogAction(
            key: EditBundleAction.removeFromBundle,
            label: L10n.of(context)!.removeFromBundle,
          ),
      ],
    );
    if (action == null) return;
    switch (action) {
      case EditBundleAction.addToBundle:
        final bundle = await showTextInputDialog(
          context: context,
          title: l10n.bundleName,
          textFields: [DialogTextField(hintText: l10n.bundleName)],
        );
        if (bundle == null || bundle.isEmpty || bundle.single.isEmpty) return;
        await showFutureLoadingDialog(
          context: context,
          future: () => client.setAccountBundle(bundle.single),
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

  Future<void> dehydrate() => Matrix.of(context).dehydrateAction();
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
}
