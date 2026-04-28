import 'dart:async';

import 'package:collection/collection.dart';
import 'package:cross_file/cross_file.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list_view.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shortcuts_new/flutter_shortcuts_new.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/account_bundles.dart';
import '../../config/setting_keys.dart';
import '../../utils/url_launcher.dart';
import '../../widgets/matrix.dart';

enum ActiveFilter { allChats, messages, groups, unread, spaces, tag }

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
      case ActiveFilter.tag:
        throw 'Tags should not directly be displayed!';
    }
  }
}

class ChatList extends StatefulWidget {
  static BuildContext? contextForVoip;
  final String? activeChat;
  final String? activeSpace;
  final bool displayNavigationRail;

  const ChatList({
    super.key,
    required this.activeChat,
    this.activeSpace,
    this.displayNavigationRail = false,
  });

  @override
  ChatListController createState() => ChatListController();
}

class ChatListController extends State<ChatList>
    with TickerProviderStateMixin, RouteAware {
  StreamSubscription? _intentDataStreamSubscription;

  StreamSubscription? _intentFileStreamSubscription;

  late ActiveFilter activeFilter;
  String? activeTag;

  String? _activeSpaceId;
  String? get activeSpaceId => _activeSpaceId;

  Future<void> setActiveSpace(String spaceId) async {
    await Matrix.of(context).client.getRoomById(spaceId)!.postLoad();

    setState(() {
      _activeSpaceId = spaceId;
    });
  }

  void clearActiveSpace() => setState(() {
    _activeSpaceId = null;
  });

  Future<void> onChatTap(Room room) async {
    final l10n = L10n.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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
    if (!mounted) return;

    if (room.membership == Membership.ban) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.youHaveBeenBannedFromThisChat)),
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
        return (room) => true;
      case ActiveFilter.messages:
        return (room) => !room.isSpace && room.isDirectChat;
      case ActiveFilter.groups:
        return (room) => !room.isSpace && !room.isDirectChat;
      case ActiveFilter.unread:
        return (room) => room.isUnreadOrInvited;
      case ActiveFilter.spaces:
        return (room) => room.isSpace;
      case ActiveFilter.tag:
        return (room) => room.tags.keys.contains(activeTag);
    }
  }

  List<Room> get filteredRooms => Matrix.of(
    context,
  ).client.rooms.where(getRoomFilterByActiveFilter(activeFilter)).toList();

  bool isSearchMode = false;
  Future<QueryPublicRoomsResponse>? publicRoomsResponse;
  String? searchServer;
  Timer? _coolDown;
  SearchUserDirectoryResponse? userSearchResult;
  QueryPublicRoomsResponse? roomSearchResult;

  bool isSearching = false;
  static const String _serverStoreNamespace = 'im.fluffychat.search.server';

  Future<void> setServer() async {
    final matrix = Matrix.of(context);
    final l10n = L10n.of(context);
    final newServer = await showTextInputDialog(
      useRootNavigator: false,
      title: l10n.changeTheHomeserver,
      context: context,
      okLabel: l10n.ok,
      cancelLabel: l10n.cancel,
      prefixText: 'https://',
      hintText: matrix.client.homeserver?.host,
      initialText: searchServer,
      keyboardType: TextInputType.url,
      autocorrect: false,
      validator: (server) =>
          server.contains('.') == true ? null : l10n.invalidServerName,
    );
    if (newServer == null) return;
    if (!mounted) return;
    matrix.store.setString(_serverStoreNamespace, newServer);
    setState(() {
      searchServer = newServer;
    });
    _coolDown?.cancel();
    _coolDown = Timer(const Duration(milliseconds: 500), _search);
  }

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  Future<void> _search() async {
    final client = Matrix.of(context).client;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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
          roomSearchResult.chunk.any(
                (room) => room.canonicalAlias == searchQuery,
              ) ==
              false) {
        final response = await client.getRoomIdByAlias(searchQuery);
        final roomId = response.roomId;
        if (roomId != null) {
          roomSearchResult.chunk.add(
            PublishedRoomsChunk(
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
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(e.toLocalizedString(context))),
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

  Future<void> editSpace(BuildContext context, String spaceId) async {
    await Matrix.of(context).client.getRoomById(spaceId)!.postLoad();
    if (!context.mounted) return;
    context.push('/rooms/$spaceId/details');
  }

  // Needs to match GroupsSpacesEntry for 'separate group' checking.
  List<Room> get spaces =>
      Matrix.of(context).client.rooms.where((r) => r.isSpace).toList();

  String? get activeChat => widget.activeChat;

  void _processIncomingSharedMedia(List<SharedMediaFile> files) {
    files.removeWhere(
      (file) => file.path.startsWith(AppConfig.deepLinkPrefix) == true,
    );
    if (files.isEmpty) return;

    showScaffoldDialog(
      context: context,
      builder: (context) => ShareScaffoldDialog(
        items: files.map((file) {
          if ({SharedMediaType.text, SharedMediaType.url}.contains(file.type)) {
            return TextShareItem(file.path);
          }
          return FileShareItem(
            XFile(
              file.path.replaceFirst('file://', ''),
              mimeType: file.mimeType,
            ),
          );
        }).toList(),
      ),
    );
  }

  void _initReceiveSharingIntent() {
    if (!PlatformInfos.isMobile) return;

    // For sharing images coming from outside the app while the app is in the memory
    _intentFileStreamSubscription = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen(_processIncomingSharedMedia, onError: print);

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.instance.getInitialMedia().then(
      _processIncomingSharedMedia,
    );

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

  StreamSubscription? _onRoomTagUpdate;

  @override
  void initState() {
    _initReceiveSharingIntent();
    _activeSpaceId = widget.activeSpace;

    scrollController.addListener(_onScroll);
    _waitForFirstSync();
    _hackyWebRTCFixForWeb();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showLastSeenSupportBanner();
        searchServer = Matrix.of(
          context,
        ).store.getString(_serverStoreNamespace);
        Matrix.of(context).backgroundPush?.setupPush();
        UpdateNotifier.showUpdateSnackBar(context);
      }

      // Workaround for system UI overlay style not applied on app start
      SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).appBarTheme.systemOverlayStyle!,
      );
    });

    _updateRoomTags();
    _onRoomTagUpdate = Matrix.of(context).client.onSync.stream
        .where(
          (syncUpdate) =>
              syncUpdate.rooms?.join?.values.any(
                (roomUpdate) =>
                    roomUpdate.accountData?.any(
                      (accountData) => accountData.type == 'm.tag',
                    ) ??
                    false,
              ) ??
              false,
        )
        .listen(_updateRoomTags);

    if (roomTags.containsKey(AppSettings.chatFilter.value)) {
      activeFilter = ActiveFilter.tag;
      activeTag = AppSettings.chatFilter.value;
    } else {
      activeFilter =
          ActiveFilter.values.singleWhereOrNull(
            (filter) => AppSettings.chatFilter.value == filter.name,
          ) ??
          ActiveFilter.allChats;
    }

    super.initState();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    _intentFileStreamSubscription?.cancel();
    _onRoomTagUpdate?.cancel();
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  Future<void> _showLastSeenSupportBanner() async {
    if (AppSettings.supportBannerOptOut.value) return;

    if (AppSettings.lastSeenSupportBanner.value == 0) {
      await AppSettings.lastSeenSupportBanner.setItem(
        DateTime.now().millisecondsSinceEpoch,
      );
      return;
    }

    final lastSeenSupportBanner = DateTime.fromMillisecondsSinceEpoch(
      AppSettings.lastSeenSupportBanner.value,
    );

    if (DateTime.now().difference(lastSeenSupportBanner) >=
        Duration(days: 6 * 7)) {
      final theme = Theme.of(context);
      final messenger = ScaffoldMessenger.of(context);
      messenger.showMaterialBanner(
        MaterialBanner(
          backgroundColor: theme.colorScheme.errorContainer,
          leading: CloseButton(
            color: theme.colorScheme.onErrorContainer,
            onPressed: () async {
              final okCancelResult = await showOkCancelAlertDialog(
                context: context,
                title: L10n.of(context).skipSupportingFluffyChat,
                message: L10n.of(context).fluffyChatSupportBannerMessage,
                okLabel: L10n.of(context).iDoNotWantToSupport,
                cancelLabel: L10n.of(context).iAlreadySupportFluffyChat,
                isDestructive: true,
              );
              switch (okCancelResult) {
                case null:
                  return;
                case OkCancelResult.ok:
                  messenger.clearMaterialBanners();
                  return;
                case OkCancelResult.cancel:
                  messenger.clearMaterialBanners();
                  await AppSettings.supportBannerOptOut.setItem(true);
                  return;
              }
            },
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              L10n.of(context).fluffyChatSupportBannerMessage,
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                messenger.clearMaterialBanners();
                launchUrlString(
                  'https://fluffychat.im/faq/#how_can_i_support_fluffychat',
                );
              },
              child: Text(
                L10n.of(context).support,
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
            ),
          ],
        ),
      );
      await AppSettings.lastSeenSupportBanner.setItem(
        DateTime.now().millisecondsSinceEpoch,
      );
    }

    return;
  }

  Future<void> chatContextAction(
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

    final displayname = room.getLocalizedDisplayname(
      MatrixLocals(L10n.of(context)),
    );

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
            spacing: 12.0,
            children: [
              Avatar(mxContent: room.avatar, name: displayname, size: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(displayname, maxLines: 1, overflow: .ellipsis),
              ),
            ],
          ),
        ),
        if (space != null)
          PopupMenuItem(
            value: ChatContextAction.goToSpace,
            child: Row(
              mainAxisSize: .min,
              children: [
                Avatar(
                  mxContent: space.avatar,
                  size: Avatar.defaultSize / 2,
                  name: space.getLocalizedDisplayname(),
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
              mainAxisSize: .min,
              children: [
                Icon(
                  room.pushRuleState == PushRuleState.notify
                      ? Icons.notifications_off_outlined
                      : Icons.notifications_off,
                ),
                const SizedBox(width: 12),
                Text(
                  room.pushRuleState == PushRuleState.notify
                      ? L10n.of(context).muteChat
                      : L10n.of(context).unmuteChat,
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: ChatContextAction.markUnread,
            child: Row(
              mainAxisSize: .min,
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
          if (!room.isLowPriority)
            PopupMenuItem(
              value: ChatContextAction.favorite,
              child: Row(
                mainAxisSize: .min,
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
          if (!room.isFavourite)
            PopupMenuItem(
              value: ChatContextAction.lowPriority,
              child: Row(
                mainAxisSize: .min,
                children: [
                  Icon(
                    room.isLowPriority
                        ? Icons.low_priority
                        : Icons.low_priority_outlined,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    room.isLowPriority
                        ? L10n.of(context).unsetLowPriority
                        : L10n.of(context).setLowPriority,
                  ),
                ],
              ),
            ),
          if (activeTag == null)
            PopupMenuItem(
              value: ChatContextAction.addTag,
              child: Row(
                mainAxisSize: .min,
                children: [
                  Icon(Icons.bookmark_add_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context).addTag),
                ],
              ),
            )
          else
            PopupMenuItem(
              value: ChatContextAction.removeTag,
              child: Row(
                mainAxisSize: .min,
                children: [
                  Icon(Icons.bookmark_remove_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context).removeTag),
                ],
              ),
            ),
          if (spacesWithPowerLevels.isNotEmpty)
            PopupMenuItem(
              value: ChatContextAction.addToSpace,
              child: Row(
                mainAxisSize: .min,
                children: [
                  const Icon(Icons.group_work_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context).addToSpace),
                ],
              ),
            ),
        ],
        PopupMenuItem(
          value: ChatContextAction.leave,
          child: Row(
            mainAxisSize: .min,
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
        if (room.membership == Membership.invite)
          PopupMenuItem(
            value: ChatContextAction.block,
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(
                  Icons.block_outlined,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 12),
                Text(
                  L10n.of(context).block,
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
      case ChatContextAction.block:
        final inviteEvent = room.getState(
          EventTypes.RoomMember,
          room.client.userID!,
        );
        context.go(
          '/rooms/settings/security/ignorelist',
          extra: inviteEvent?.senderId,
        );
      case ChatContextAction.leave:
        final confirmed = await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).areYouSure,
          message: L10n.of(context).archiveRoomDescription,
          okLabel: L10n.of(context).leave,
          cancelLabel: L10n.of(context).cancel,
          isDestructive: true,
        );
        if (confirmed == OkCancelResult.cancel) return;
        if (!mounted) return;

        await showFutureLoadingDialog(context: context, future: room.leave);

        return;
      case ChatContextAction.addToSpace:
        final space = await showModalActionPopup(
          context: context,
          title: L10n.of(context).space,
          actions: spacesWithPowerLevels
              .map(
                (space) => AdaptiveModalAction(
                  value: space,
                  label: space.getLocalizedDisplayname(
                    MatrixLocals(L10n.of(context)),
                  ),
                ),
              )
              .toList(),
        );
        if (space == null) return;
        if (!mounted) return;
        await showFutureLoadingDialog(
          context: context,
          future: () => space.setSpaceChild(room.id),
        );
      case ChatContextAction.lowPriority:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.setLowPriority(!room.isLowPriority),
        );
        return;
      case ChatContextAction.addTag:
        final existingTags = List.of(roomTags.keys);
        existingTags.removeWhere(room.tags.containsKey);
        String? tag;
        if (existingTags.isNotEmpty) {
          tag = await showModalActionPopup<String?>(
            context: context,
            actions: [
              ...existingTags.map((tag) {
                final displayTag = tag.replaceFirst('u.', '');
                return AdaptiveModalAction(
                  label: displayTag,
                  value: displayTag,
                );
              }),
              AdaptiveModalAction(
                label: L10n.of(context).createNewTag,
                value: null,
              ),
            ],
          );
          if (!mounted) return;
        }
        tag ??= await showTextInputDialog(
          context: context,
          title: L10n.of(context).addTag,
          hintText: L10n.of(context).tagName,
        );
        final newTag = tag;
        if (!mounted) return;
        if (newTag == null) return;
        await showFutureLoadingDialog(
          context: context,
          future: () => room.addTag('u.$newTag'),
        );
        return;
      case ChatContextAction.removeTag:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.removeTag(activeTag!),
        );
        return;
    }
  }

  Map<String, int> roomTags = {};

  void _updateRoomTags([_]) {
    roomTags.clear();
    for (final room in Matrix.of(context).client.rooms) {
      for (final tag in room.tags.keys) {
        if (tag.startsWith('u.')) roomTags[tag] = (roomTags[tag] ?? 0) + 1;
      }
    }
    setState(() {
      if (activeTag != null && !roomTags.keys.contains(activeTag)) {
        activeTag = null;
        activeFilter = ActiveFilter.allChats;
      }
    });
  }

  Future<void> dismissStatusList() async {
    final result = await showOkCancelAlertDialog(
      title: L10n.of(context).hidePresences,
      context: context,
    );
    if (result == OkCancelResult.ok) {
      AppSettings.showPresences.setItem(false);
      setState(() {});
    }
  }

  Future<void> setStatus() async {
    final l10n = L10n.of(context);
    final client = Matrix.of(context).client;
    final currentPresence = await client.fetchCurrentPresence(client.userID!);
    if (!mounted) return;
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: l10n.setStatus,
      message: l10n.leaveEmptyToClearStatus,
      okLabel: l10n.ok,
      cancelLabel: l10n.cancel,
      hintText: l10n.statusExampleMessage,
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
    final router = GoRouter.of(context);
    final client = Matrix.of(context).client;
    await client.roomsLoading;
    await client.accountDataLoading;
    await client.userDeviceKeysLoading;
    if (client.prevBatch == null) {
      await client.onSyncStatus.stream.firstWhere(
        (status) => status.status == SyncStatus.finished,
      );

      if (!mounted) return;
      setState(() {
        waitForFirstSync = true;
      });
    }
    if (!mounted) return;
    setState(() {
      waitForFirstSync = true;
    });

    if (client.userDeviceKeys[client.userID!]?.deviceKeys.values.any(
          (device) => !device.verified && !device.blocked,
        ) ??
        false) {
      late final ScaffoldFeatureController controller;
      final theme = Theme.of(context);
      controller = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 15),
          showCloseIcon: true,
          backgroundColor: theme.colorScheme.errorContainer,
          closeIconColor: theme.colorScheme.onErrorContainer,
          content: Text(
            L10n.of(context).oneOfYourDevicesIsNotVerified,
            style: TextStyle(color: theme.colorScheme.onErrorContainer),
          ),
          action: SnackBarAction(
            onPressed: () {
              controller.close();
              router.go('/rooms/settings/devices');
            },
            textColor: theme.colorScheme.onErrorContainer,
            label: L10n.of(context).settings,
          ),
        ),
      );
    }
  }

  void setActiveFilter(ActiveFilter filter, String? tag) {
    if (filter == ActiveFilter.tag && tag == null) {
      throw ('Must set a tag when setting filter to tags!');
    }
    setState(() {
      activeTag = tag;
      activeFilter = filter;
    });
    AppSettings.chatFilter.setItem(
      filter == ActiveFilter.tag ? tag! : filter.name,
    );
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
      if (!Matrix.of(
        context,
      ).currentBundle!.any((client) => client == Matrix.of(context).client)) {
        Matrix.of(
          context,
        ).setActiveClient(Matrix.of(context).currentBundle!.first);
      }
    });
  }

  Future<void> editBundlesForAccount(
    String? userId,
    String? activeBundle,
  ) async {
    final l10n = L10n.of(context);
    final client = Matrix.of(
      context,
    ).widget.clients[Matrix.of(context).getClientIndexByMatrixId(userId!)];
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
        if (!mounted) return;
        final bundle = await showTextInputDialog(
          context: context,
          title: l10n.bundleName,
          hintText: l10n.bundleName,
        );
        if (bundle == null || bundle.isEmpty || bundle.isEmpty) return;
        if (!mounted) return;
        await showFutureLoadingDialog(
          context: context,
          future: () => client.setAccountBundle(bundle),
        );
        break;
      case EditBundleAction.removeFromBundle:
        if (!mounted) return;
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
        !Matrix.of(
          context,
        ).accountBundles.keys.contains(Matrix.of(context).activeBundle)) {
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

  Future<void> dehydrate() => Matrix.of(context).dehydrateAction(context);
}

enum EditBundleAction { addToBundle, removeFromBundle }

enum ChatContextAction {
  open,
  goToSpace,
  favorite,
  lowPriority,
  addTag,
  removeTag,
  markUnread,
  mute,
  leave,
  addToSpace,
  block,
}
