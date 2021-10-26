import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:uni_links/uni_links.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/pages/views/chat_list_view.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/flutter_matrix_hive_database.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import '../../utils/account_bundles.dart';
import '../main.dart';
import '../utils/matrix_sdk_extensions.dart/matrix_file_extension.dart';
import '../utils/url_launcher.dart';
import '../widgets/matrix.dart';
import 'bootstrap_dialog.dart';

enum SelectMode { normal, share, select }
enum PopupMenuAction {
  settings,
  invite,
  newGroup,
  newSpace,
  setStatus,
  archive,
}

class ChatList extends StatefulWidget {
  const ChatList({Key key}) : super(key: key);

  @override
  ChatListController createState() => ChatListController();
}

class ChatListController extends State<ChatList> {
  StreamSubscription _intentDataStreamSubscription;

  StreamSubscription _intentFileStreamSubscription;

  StreamSubscription _intentUriStreamSubscription;

  String _activeSpaceId;
  String get activeSpaceId => _activeSpaceId;
  final ScrollController scrollController = ScrollController();
  bool scrolledToTop = true;

  void _onScroll() {
    final newScrolledToTop = scrollController.position.pixels <= 0;
    if (newScrolledToTop != scrolledToTop) {
      setState(() {
        scrolledToTop = newScrolledToTop;
      });
    }
  }

  void setActiveSpaceId(BuildContext context, String spaceId) {
    Scaffold.of(context).openEndDrawer();
    setState(() => _activeSpaceId = spaceId);
  }

  void editSpace(BuildContext context, String spaceId) async {
    Scaffold.of(context).openEndDrawer();
    await Matrix.of(context).client.getRoomById(spaceId).postLoad();
    VRouter.of(context).toSegments(['spaces', spaceId]);
  }

  List<Room> get spaces =>
      Matrix.of(context).client.rooms.where((r) => r.isSpace).toList();

  final selectedRoomIds = <String>{};
  Future<bool> crossSigningCachedFuture;
  bool crossSigningCached;
  bool hideChatBackupBanner = false;

  void hideChatBackupBannerAction() =>
      setState(() => hideChatBackupBanner = true);

  void firstRunBootstrapAction() async {
    hideChatBackupBannerAction();
    await BootstrapDialog(
      client: Matrix.of(context).client,
    ).show(context);
    VRouter.of(context).to('/rooms');
  }

  String get activeChat => VRouter.of(context).pathParameters['roomid'];

  SelectMode get selectMode => Matrix.of(context).shareContent != null
      ? SelectMode.share
      : selectedRoomIds.isEmpty
          ? SelectMode.normal
          : SelectMode.select;

  void _processIncomingSharedFiles(List<SharedMediaFile> files) {
    if (files?.isEmpty ?? true) return;
    VRouter.of(context).to('/rooms');
    final file = File(files.first.path);

    Matrix.of(context).shareContent = {
      'msgtype': 'chat.fluffy.shared_file',
      'file': MatrixFile(
        bytes: file.readAsBytesSync(),
        name: file.path,
      ).detectFileType,
    };
  }

  void _processIncomingSharedText(String text) {
    if (text == null) return;
    VRouter.of(context).to('/rooms');
    if (text.toLowerCase().startsWith(AppConfig.inviteLinkPrefix) ||
        (text.toLowerCase().startsWith(AppConfig.schemePrefix) &&
            !RegExp(r'\s').hasMatch(text))) {
      return;
    }
    Matrix.of(context).shareContent = {
      'msgtype': 'm.text',
      'body': text,
    };
  }

  void _processIncomingUris(String text) async {
    if (text == null) return;
    VRouter.of(context).to('/rooms');
    UrlLauncher(context, text).openMatrixToUrl();
    return;
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
  }

  @override
  void initState() {
    _initReceiveSharingIntent();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => waitForFirstSync().then((_) => checkBootstrap()),
    );
    scrollController.addListener(_onScroll);
    super.initState();
  }

  void checkBootstrap() async {
    if (!Matrix.of(context).client.encryptionEnabled) return;
    if ((Matrix.of(context).client.database as FlutterMatrixHiveStore)
            .get(SettingKeys.dontAskForBootstrapKey) ==
        true) {
      return;
    }
    final crossSigning = await crossSigningCachedFuture;
    final needsBootstrap =
        Matrix.of(context).client.encryption?.crossSigning?.enabled == false ||
            crossSigning == false;
    final isUnknownSession = Matrix.of(context).client.isUnknownSession;
    if (needsBootstrap || isUnknownSession) {
      firstRunBootstrapAction();
    }
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    _intentFileStreamSubscription?.cancel();
    _intentUriStreamSubscription?.cancel();
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  bool roomCheck(Room room) {
    if (room.isSpace && room.membership == Membership.join && !room.isUnread) {
      return false;
    }
    if (activeSpaceId != null) {
      final space = Matrix.of(context).client.getRoomById(activeSpaceId);
      if (space.spaceChildren?.any((child) => child.roomId == room.id) ??
          false) {
        return true;
      }
      if (room.spaceParents?.any((parent) => parent.roomId == activeSpaceId) ??
          false) {
        return true;
      }
      if (room.isDirectChat &&
          room.summary?.mHeroes != null &&
          room.summary.mHeroes.any((userId) {
            final user = space.getState(EventTypes.RoomMember, userId)?.asUser;
            return user != null && user.membership == Membership.join;
          })) {
        return true;
      }
      return false;
    }
    return true;
  }

  void toggleSelection(String roomId) {
    setState(() => selectedRoomIds.contains(roomId)
        ? selectedRoomIds.remove(roomId)
        : selectedRoomIds.add(roomId));
  }

  Future<void> toggleUnread() {
    final room = Matrix.of(context).client.getRoomById(selectedRoomIds.single);
    return showFutureLoadingDialog(
      context: context,
      future: () => room.setUnread(!room.isUnread),
    );
  }

  Future<void> toggleFavouriteRoom() {
    final room = Matrix.of(context).client.getRoomById(selectedRoomIds.single);
    return showFutureLoadingDialog(
      context: context,
      future: () => room.setFavourite(!room.isFavourite),
    );
  }

  Future<void> toggleMuted() {
    final room = Matrix.of(context).client.getRoomById(selectedRoomIds.single);
    return showFutureLoadingDialog(
      context: context,
      future: () => room.setPushRuleState(
          room.pushRuleState == PushRuleState.notify
              ? PushRuleState.mentionsOnly
              : PushRuleState.notify),
    );
  }

  Future<void> archiveAction() async {
    final confirmed = await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context).areYouSure,
          okLabel: L10n.of(context).yes,
          cancelLabel: L10n.of(context).cancel,
        ) ==
        OkCancelResult.ok;
    if (!confirmed) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => _archiveSelectedRooms(),
    );
    setState(() => null);
  }

  void setStatus() async {
    final input = await showTextInputDialog(
        useRootNavigator: false,
        context: context,
        title: L10n.of(context).setStatus,
        okLabel: L10n.of(context).ok,
        cancelLabel: L10n.of(context).cancel,
        textFields: [
          DialogTextField(
            hintText: L10n.of(context).statusExampleMessage,
          ),
        ]);
    if (input == null) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.setPresence(
            Matrix.of(context).client.userID,
            PresenceType.online,
            statusMsg: input.single,
          ),
    );
  }

  void onPopupMenuSelect(action) {
    switch (action) {
      case PopupMenuAction.setStatus:
        setStatus();
        break;
      case PopupMenuAction.settings:
        VRouter.of(context).to('/settings');
        break;
      case PopupMenuAction.invite:
        FluffyShare.share(
            L10n.of(context).inviteText(Matrix.of(context).client.userID,
                'https://matrix.to/#/${Matrix.of(context).client.userID}'),
            context);
        break;
      case PopupMenuAction.newGroup:
        VRouter.of(context).to('/newgroup');
        break;
      case PopupMenuAction.newSpace:
        VRouter.of(context).to('/newspace');
        break;
      case PopupMenuAction.archive:
        VRouter.of(context).to('/archive');
        break;
    }
  }

  Future<void> _archiveSelectedRooms() async {
    final client = Matrix.of(context).client;
    while (selectedRoomIds.isNotEmpty) {
      final roomId = selectedRoomIds.first;
      try {
        await client.getRoomById(roomId).leave();
      } finally {
        toggleSelection(roomId);
      }
    }
  }

  Future<void> addOrRemoveToSpace() async {
    if (activeSpaceId != null) {
      final space = Matrix.of(context).client.getRoomById(activeSpaceId);
      final result = await showFutureLoadingDialog(
        context: context,
        future: () => space.removeSpaceChild(selectedRoomIds.single),
      );
      if (result.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(L10n.of(context).chatHasBeenRemovedFromThisSpace),
          ),
        );
      }
    } else {
      final selectedSpace = await showConfirmationDialog<String>(
          context: context,
          title: L10n.of(context).addToSpace,
          actions: Matrix.of(context)
              .client
              .rooms
              .where((r) => r.isSpace)
              .map(
                (space) => AlertDialogAction(
                  key: space.id,
                  label: space.displayname,
                ),
              )
              .toList());
      if (selectedSpace == null) return;
      final result = await showFutureLoadingDialog(
        context: context,
        future: () => Matrix.of(context)
            .client
            .getRoomById(selectedSpace)
            .setSpaceChild(selectedRoomIds.single),
      );
      if (result.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(L10n.of(context).chatHasBeenAddedToThisSpace),
          ),
        );
      }
    }
    setState(() => selectedRoomIds.clear());
  }

  Future<void> waitForFirstSync() async {
    final client = Matrix.of(context).client;
    if (client.prevBatch?.isEmpty ?? true) {
      await client.onFirstSync.stream.first;
    }
    // Load space members to display DM rooms
    if (activeSpaceId != null) {
      final space = client.getRoomById(activeSpaceId);
      final localMembers = space.getParticipants().length;
      final actualMembersCount = (space.summary?.mInvitedMemberCount ?? 0) +
          (space.summary?.mJoinedMemberCount ?? 0);
      if (localMembers < actualMembersCount) {
        await space.requestParticipants();
      }
    }
    return true;
  }

  void cancelAction() {
    if (selectMode == SelectMode.share) {
      setState(() => Matrix.of(context).shareContent = null);
    } else {
      setState(() => selectedRoomIds.clear());
    }
  }

  void setActiveClient(Client client) {
    VRouter.of(context).to('/rooms');
    setState(() {
      _activeSpaceId = null;
      selectedRoomIds.clear();
      Matrix.of(context).setActiveClient(client);
    });
  }

  void setActiveBundle(String bundle) {
    VRouter.of(context).to('/rooms');
    setState(() {
      _activeSpaceId = null;
      selectedRoomIds.clear();
      Matrix.of(context).activeBundle = bundle;
      if (!Matrix.of(context)
          .currentBundle
          .any((client) => client == Matrix.of(context).client)) {
        Matrix.of(context)
            .setActiveClient(Matrix.of(context).currentBundle.first);
      }
    });
  }

  void editBundlesForAccount(String userId) async {
    final client = Matrix.of(context)
        .widget
        .clients[Matrix.of(context).getClientIndexByMatrixId(userId)];
    final action = await showConfirmationDialog<EditBundleAction>(
      context: context,
      title: L10n.of(context).editBundlesForAccount,
      actions: [
        AlertDialogAction(
          key: EditBundleAction.addToBundle,
          label: L10n.of(context).addToBundle,
        ),
        if (Matrix.of(context).activeBundle != null)
          AlertDialogAction(
            key: EditBundleAction.removeFromBundle,
            label: L10n.of(context).removeFromBundle,
          ),
      ],
    );
    if (action == null) return;
    switch (action) {
      case EditBundleAction.addToBundle:
        final bundle = await showTextInputDialog(
            context: context,
            title: L10n.of(context).bundleName,
            textFields: [
              DialogTextField(hintText: L10n.of(context).bundleName)
            ]);
        if (bundle.isEmpty && bundle.single.isEmpty) return;
        await showFutureLoadingDialog(
          context: context,
          future: () => client.setAccountBundle(bundle.single),
        );
        break;
      case EditBundleAction.removeFromBundle:
        await showFutureLoadingDialog(
          context: context,
          future: () =>
              client.removeFromAccountBundle(Matrix.of(context).activeBundle),
        );
    }
  }

  bool get displayBundles =>
      Matrix.of(context).hasComplexBundles &&
      Matrix.of(context).accountBundles.keys.length > 1;

  String get secureActiveBundle {
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
  Widget build(BuildContext context) {
    Matrix.of(context).navigatorContext = context;
    crossSigningCachedFuture ??= Matrix.of(context)
        .client
        .encryption
        ?.crossSigning
        ?.isCached()
        ?.then((c) {
      if (mounted) setState(() => crossSigningCached = c);
      return c;
    });
    return ChatListView(this);
  }
}

enum EditBundleAction { addToBundle, removeFromBundle }
