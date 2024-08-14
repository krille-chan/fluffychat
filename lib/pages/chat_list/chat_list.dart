import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list_view.dart';
import 'package:fluffychat/pangea/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/utils/chat_list_handle_space_tap.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/widgets/subscription/subscription_snackbar.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/tor_stub.dart'
    if (dart.library.html) 'package:tor_detector_web/tor_detector_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_shortcuts/flutter_shortcuts.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:uni_links/uni_links.dart';

import '../../../utils/account_bundles.dart';
import '../../config/setting_keys.dart';
import '../../utils/matrix_sdk_extensions/matrix_file_extension.dart';
import '../../utils/url_launcher.dart';
import '../../utils/voip/callkeep_manager.dart';
import '../../widgets/fluffy_chat_app.dart';
import '../../widgets/matrix.dart';

enum SelectMode {
  normal,
  share,
  select,
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
  groups,
  messages,
  spaces,
}

class ChatList extends StatefulWidget {
  static BuildContext? contextForVoip;
  final bool displayNavigationRail;
  final String? activeChat;

  const ChatList({
    super.key,
    this.displayNavigationRail = false,
    required this.activeChat,
  });

  @override
  ChatListController createState() => ChatListController();
}

class ChatListController extends State<ChatList>
    with TickerProviderStateMixin, RouteAware {
  StreamSubscription? _intentDataStreamSubscription;

  StreamSubscription? _intentFileStreamSubscription;

  StreamSubscription? _intentUriStreamSubscription;

  bool get displayNavigationBar =>
      !FluffyThemes.isColumnMode(context) &&
      (spaces.isNotEmpty || AppConfig.separateChatTypes);

  String? activeSpaceId;

  void resetActiveSpaceId() {
    setState(() {
      selectedRoomIds.clear();
      activeSpaceId = null;
      //#Pangea
      context.go("/rooms");
      //Pangea#
    });
  }

  void setActiveSpace(String? spaceId) {
    setState(() {
      selectedRoomIds.clear();
      activeSpaceId = spaceId;
      activeFilter = ActiveFilter.spaces;
      // #Pangea
      // don't show all spaces view if in column mode
      if (spaceId == null && FluffyThemes.isColumnMode(context)) {
        activeFilter = ActiveFilter.allChats;
      }
      // Pangea#
    });
  }

  void createNewSpace() async {
    final spaceId = await context.push<String?>('/rooms/newspace');
    if (spaceId != null) {
      setActiveSpace(spaceId);
    }
  }

  int get selectedIndex {
    switch (activeFilter) {
      case ActiveFilter.allChats:
      case ActiveFilter.messages:
        return 0;
      case ActiveFilter.groups:
        return 1;
      case ActiveFilter.spaces:
        return AppConfig.separateChatTypes ? 2 : 1;
    }
  }

  // #Pangea
  bool isSelected(int i) {
    if (activeFilter == ActiveFilter.spaces && activeSpaceId != null) {
      return false;
    }
    return i == selectedIndex;
  }
  // Pangea#

  ActiveFilter getActiveFilterByDestination(int? i) {
    switch (i) {
      case 1:
        if (AppConfig.separateChatTypes) {
          return ActiveFilter.groups;
        }
        return ActiveFilter.spaces;
      case 2:
        return ActiveFilter.spaces;
      case 0:
      default:
        if (AppConfig.separateChatTypes) {
          return ActiveFilter.messages;
        }
        return ActiveFilter.allChats;
    }
  }

  void onDestinationSelected(int? i) {
    setState(() {
      // #Pangea
      debugPrint('onDestinationSelected $i');
      // Pangea#
      selectedRoomIds.clear();
      activeFilter = getActiveFilterByDestination(i);
      // #Pangea
      if (activeFilter != ActiveFilter.spaces) {
        activeSpaceId = null;
      }
      // Pangea#
    });
    // #Pangea
    final bool clickedAllSpaces = (!AppConfig.separateChatTypes && i == 1) ||
        (AppConfig.separateChatTypes && i == 2);
    if (clickedAllSpaces) {
      setActiveSpace(null);
    }
    // Pangea#
  }

  ActiveFilter activeFilter = AppConfig.separateChatTypes
      ? ActiveFilter.messages
      : ActiveFilter.allChats;

  bool Function(Room) getRoomFilterByActiveFilter(ActiveFilter activeFilter) {
    switch (activeFilter) {
      case ActiveFilter.allChats:
        return (room) =>
            !room.isSpace // #Pangea
            &&
            !room.isAnalyticsRoom;
      // Pangea#;
      case ActiveFilter.groups:
        return (room) =>
            !room.isSpace &&
            !room.isDirectChat // #Pangea
            &&
            !room.isAnalyticsRoom;
      // Pangea#;
      case ActiveFilter.messages:
        return (room) =>
            !room.isSpace &&
            room.isDirectChat // #Pangea
            &&
            !room.isAnalyticsRoom;
      // Pangea#;
      case ActiveFilter.spaces:
        return (r) => r.isSpace;
    }
  }

  List<Room> get filteredRooms => Matrix.of(context)
      .client
      .rooms
      .where(
        getRoomFilterByActiveFilter(activeFilter),
      )
      .toList();

  bool isSearchMode = false;
  Future<QueryPublicRoomsResponse>? publicRoomsResponse;
  String? searchServer;
  Timer? _coolDown;
  SearchUserDirectoryResponse? userSearchResult;
  QueryPublicRoomsResponse? roomSearchResult;

  bool isSearching = false;
  static const String _serverStoreNamespace = 'im.fluffychat.search.server';
  //#Pangea
  final PangeaController pangeaController = MatrixState.pangeaController;
  //Pangea#

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

  final selectedRoomIds = <String>{};

  String? get activeChat => widget.activeChat;

  SelectMode get selectMode => Matrix.of(context).shareContent != null
      ? SelectMode.share
      : selectedRoomIds.isEmpty
          ? SelectMode.normal
          : SelectMode.select;

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

    // #Pangea
    // dependency is outdated and prevents app from building
    // // For sharing or opening urls/text coming from outside the app while the app is in the memory
    // _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream()
    //     .listen(_processIncomingSharedText, onError: print);

    // // For sharing or opening urls/text coming from outside the app while the app is closed
    // ReceiveSharingIntent.getInitialText().then(_processIncomingSharedText);
    // Pangea#

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

  //#Pangea
  StreamSubscription? classStream;
  StreamSubscription? _invitedSpaceSubscription;
  StreamSubscription? _subscriptionStatusStream;
  StreamSubscription? _spaceChildSubscription;
  final Set<String> hasUpdates = {};
  //Pangea#

  @override
  void initState() {
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
      }

      // Workaround for system UI overlay style not applied on app start
      SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).appBarTheme.systemOverlayStyle!,
      );
    });

    _checkTorBrowser();

    //#Pangea
    classStream = pangeaController.classController.stateStream.listen((event) {
      // if (event["activeSpaceId"] != null && mounted) {
      if (mounted) {
        setActiveSpace(event["activeSpaceId"]);
        if (event["activeSpaceId"] != null) {
          context.go("/rooms/${event["activeSpaceId"]}/details");
        }
      }
    });

    _invitedSpaceSubscription = pangeaController
        .matrixState.client.onSync.stream
        .where((event) => event.rooms?.invite != null)
        .listen((event) async {
      for (final inviteEntry in event.rooms!.invite!.entries) {
        if (inviteEntry.value.inviteState == null) continue;
        final bool isSpace = inviteEntry.value.inviteState!.any(
          (event) =>
              event.type == EventTypes.RoomCreate &&
              event.content['type'] == 'm.space',
        );
        final bool isAnalytics = inviteEntry.value.inviteState!.any(
          (event) =>
              event.type == EventTypes.RoomCreate &&
              event.content['type'] == PangeaRoomTypes.analytics,
        );

        if (isSpace) {
          final String spaceId = inviteEntry.key;
          final Room? space = pangeaController.matrixState.client.getRoomById(
            spaceId,
          );
          if (space != null) {
            chatListHandleSpaceTap(
              context,
              this,
              space,
            );
          }
        }

        if (isAnalytics) {
          final Room? analyticsRoom =
              pangeaController.matrixState.client.getRoomById(inviteEntry.key);
          try {
            await analyticsRoom?.join();
          } catch (err, s) {
            ErrorHandler.logError(
              m: "Failed to join analytics room",
              e: err,
              s: s,
            );
          }
          return;
        }
      }
    });

    _subscriptionStatusStream ??= pangeaController
        .subscriptionController.subscriptionStream.stream
        .listen((event) {
      if (mounted) {
        showSubscribedSnackbar(context);
      }
    });

    // listen for space child updates for any space that is not the active space
    // so that when the user navigates to the space that was updated, it will
    // reload any rooms that have been added / removed
    final client = pangeaController.matrixState.client;
    _spaceChildSubscription ??= client.onRoomState.stream.where((u) {
      return u.state.type == EventTypes.SpaceChild && u.roomId != activeSpaceId;
    }).listen((update) {
      hasUpdates.add(update.roomId);
    });
    //Pangea#

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
    //Pangea#
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  // #Pangea
  final StreamController<String> selectionsStream =
      StreamController.broadcast();
  // Pangea#

  void toggleSelection(String roomId) {
    // #Pangea
    // setState(
    //   () => selectedRoomIds.contains(roomId)
    //       ? selectedRoomIds.remove(roomId)
    //       : selectedRoomIds.add(roomId),
    // );
    selectedRoomIds.contains(roomId)
        ? selectedRoomIds.remove(roomId)
        : selectedRoomIds.add(roomId);
    selectionsStream.add(roomId);
    // Pangea#
  }

  Future<void> toggleUnread() async {
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        final markUnread = anySelectedRoomNotMarkedUnread;
        final client = Matrix.of(context).client;
        for (final roomId in selectedRoomIds) {
          final room = client.getRoomById(roomId)!;
          if (room.markedUnread == markUnread) continue;
          await client.getRoomById(roomId)!.markUnread(markUnread);
        }
      },
    );
    cancelAction();
  }

  Future<void> toggleFavouriteRoom() async {
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        final makeFavorite = anySelectedRoomNotFavorite;
        final client = Matrix.of(context).client;
        for (final roomId in selectedRoomIds) {
          final room = client.getRoomById(roomId)!;
          if (room.isFavourite == makeFavorite) continue;
          await client.getRoomById(roomId)!.setFavourite(makeFavorite);
        }
      },
    );
    cancelAction();
  }

  Future<void> toggleMuted() async {
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        final newState = anySelectedRoomNotMuted
            ? PushRuleState.mentionsOnly
            : PushRuleState.notify;
        final client = Matrix.of(context).client;
        for (final roomId in selectedRoomIds) {
          final room = client.getRoomById(roomId)!;
          if (room.pushRuleState == newState) continue;
          await client.getRoomById(roomId)!.setPushRuleState(newState);
        }
      },
    );
    cancelAction();
  }

  Future<void> archiveAction() async {
    final confirmed = await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context)!.areYouSure,
          okLabel: L10n.of(context)!.yes,
          cancelLabel: L10n.of(context)!.cancel,
          message: L10n.of(context)!.archiveRoomDescription,
        ) ==
        OkCancelResult.ok;
    if (!confirmed) return;
    // #Pangea
    final bool archivedActiveRoom =
        selectedRoomIds.contains(Matrix.of(context).activeRoomId);
    // Pangea#
    await showFutureLoadingDialog(
      context: context,
      future: () => _archiveSelectedRooms(),
    );
    // #Pangea
    // setState(() {});
    if (archivedActiveRoom) {
      context.go('/rooms');
    }
    // Pangea#
  }

  // #Pangea
  Future<void> leaveAction() async {
    final bool onlyAdmin = await Matrix.of(context)
            .client
            .getRoomById(selectedRoomIds.first)
            ?.isOnlyAdmin() ??
        false;
    final confirmed = await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context)!.areYouSure,
          okLabel: L10n.of(context)!.yes,
          cancelLabel: L10n.of(context)!.cancel,
          message: onlyAdmin && selectedRoomIds.length == 1
              ? L10n.of(context)!.onlyAdminDescription
              : L10n.of(context)!.leaveRoomDescription,
        ) ==
        OkCancelResult.ok;
    if (!confirmed) return;
    final bool leftActiveRoom =
        selectedRoomIds.contains(Matrix.of(context).activeRoomId);
    await showFutureLoadingDialog(
      context: context,
      future: () => _leaveSelectedRooms(onlyAdmin),
    );
    if (leftActiveRoom) {
      context.go('/rooms');
    }
  }
  // Pangea#

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

  Future<void> _archiveSelectedRooms() async {
    final client = Matrix.of(context).client;
    while (selectedRoomIds.isNotEmpty) {
      final roomId = selectedRoomIds.first;
      try {
        // #Pangea
        // await client.getRoomById(roomId)!.leave();
        await client.getRoomById(roomId)!.archive();
        // Pangea#
      } finally {
        toggleSelection(roomId);
      }
    }
  }

  // #Pangea
  Future<void> _leaveSelectedRooms(bool onlyAdmin) async {
    final client = Matrix.of(context).client;
    while (selectedRoomIds.isNotEmpty) {
      final roomId = selectedRoomIds.first;
      try {
        final room = client.getRoomById(roomId);
        if (!room!.isSpace &&
            room.membership == Membership.join &&
            room.isUnread) {
          await room.markUnread(false);
        }
        onlyAdmin ? await room.archive() : await room.leave();
      } finally {
        toggleSelection(roomId);
      }
    }
  }
  // Pangea#

  Future<void> addToSpace() async {
    // #Pangea
    final firstSelectedRoom =
        Matrix.of(context).client.getRoomById(selectedRoomIds.toList().first);
    // Pangea#
    final selectedSpace = await showConfirmationDialog<String>(
      context: context,
      title: L10n.of(context)!.addToSpace,
      // #Pangea
      // message: L10n.of(context)!.addToSpaceDescription,
      message: L10n.of(context)!.addSpaceToSpaceDescription,
      // Pangea#
      fullyCapitalizedForMaterial: false,
      actions: Matrix.of(context)
          .client
          .rooms
          .where(
            (r) =>
                r.isSpace
                // #Pangea
                &&
                selectedRoomIds
                    .map((id) => Matrix.of(context).client.getRoomById(id))
                    // Only show non-recursion-causing spaces
                    // Performs a few other checks as well
                    .every((e) => r.canAddAsParentOf(e)),
            //Pangea#
          )
          .map(
            (space) => AlertDialogAction(
              key: space.id,
              // #Pangea
              // label: space
              //     .getLocalizedDisplayname(MatrixLocals(L10n.of(context)!)),
              label: space.nameIncludingParents(context),
              // If user is not admin of space, button is grayed out
              textStyle: TextStyle(
                color: (firstSelectedRoom == null)
                    ? Theme.of(context).colorScheme.outline
                    : Theme.of(context).colorScheme.surfaceTint,
              ),
              // Pangea#
            ),
          )
          .toList(),
    );
    if (selectedSpace == null) return;
    final result = await showFutureLoadingDialog(
      context: context,
      future: () async {
        final space = Matrix.of(context).client.getRoomById(selectedSpace)!;
        // #Pangea
        if (firstSelectedRoom == null) {
          throw L10n.of(context)!.nonexistentSelection;
        }

        if (space.canSendDefaultStates) {
          for (final roomId in selectedRoomIds) {
            await space.pangeaSetSpaceChild(roomId, suggested: true);
          }
        }
        // Pangea#
      },
    );
    if (result.error == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // #Pangea
          // content: Text(L10n.of(context)!.chatHasBeenAddedToThisSpace),
          content: Text(L10n.of(context)!.roomAddedToSpace),
          // Pangea#
        ),
      );
    }

    // #Pangea
    // setState(() => selectedRoomIds.clear());
    if (firstSelectedRoom != null) {
      toggleSelection(firstSelectedRoom.id);
    }
    // Pangea#
  }

  bool get anySelectedRoomNotMarkedUnread => selectedRoomIds.any(
        (roomId) =>
            !Matrix.of(context).client.getRoomById(roomId)!.markedUnread,
      );

  bool get anySelectedRoomNotFavorite => selectedRoomIds.any(
        (roomId) => !Matrix.of(context).client.getRoomById(roomId)!.isFavourite,
      );

  bool get anySelectedRoomNotMuted => selectedRoomIds.any(
        (roomId) =>
            Matrix.of(context).client.getRoomById(roomId)!.pushRuleState ==
            PushRuleState.notify,
      );

  bool waitForFirstSync = false;

  Future<void> _waitForFirstSync() async {
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
    MatrixState.pangeaController.myAnalytics.initialize();
    MatrixState.pangeaController.analytics.initialize();
    await _initPangeaControllers(client);
    // Pangea#
    if (!mounted) return;
    setState(() {
      waitForFirstSync = true;
    });
  }

  // #Pangea
  Future<void> _initPangeaControllers(Client client) async {
    if (mounted) {
      GoogleAnalytics.analyticsUserUpdate(client.userID);
      pangeaController.startChatWithBotIfNotPresent();
      await pangeaController.subscriptionController.initialize();
      pangeaController.afterSyncAndFirstLoginInitialization(context);
      await pangeaController.inviteBotToExistingSpaces();
      await pangeaController.setPangeaPushRules();
      client.migrateAnalyticsRooms();
    } else {
      ErrorHandler.logError(
        m: "didn't run afterSyncAndFirstLoginInitialization because not mounted",
      );
    }
  }
  // Pangea#

  void cancelAction() {
    if (selectMode == SelectMode.share) {
      setState(() => Matrix.of(context).shareContent = null);
    } else {
      // #Pangea
      // setState(() => selectedRoomIds.clear());
      for (final roomId in selectedRoomIds.toList()) {
        toggleSelection(roomId);
      }
      // Pangea#
    }
  }

  void setActiveClient(Client client) {
    context.go('/rooms');
    setState(() {
      activeFilter = AppConfig.separateChatTypes
          ? ActiveFilter.messages
          : ActiveFilter.allChats;
      activeSpaceId = null;
      selectedRoomIds.clear();
      Matrix.of(context).setActiveClient(client);
    });
    _clientStream.add(client);
  }

  void setActiveBundle(String bundle) {
    context.go('/rooms');
    setState(() {
      selectedRoomIds.clear();
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
