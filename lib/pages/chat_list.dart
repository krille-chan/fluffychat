import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/pages/views/chat_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:uni_links/uni_links.dart';
import '../main.dart';
import '../widgets/matrix.dart';
import '../utils/matrix_file_extension.dart';
import '../utils/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

enum SelectMode { normal, share, select }
enum PopupMenuAction { settings, invite, newGroup, setStatus, archive }

class ChatList extends StatefulWidget {
  final String activeChat;

  const ChatList({this.activeChat, Key key}) : super(key: key);

  @override
  ChatListController createState() => ChatListController();
}

class ChatListController extends State<ChatList> {
  StreamSubscription _intentDataStreamSubscription;

  StreamSubscription _intentFileStreamSubscription;

  StreamSubscription _intentUriStreamSubscription;

  final selectedRoomIds = <String>{};

  void _processIncomingSharedFiles(List<SharedMediaFile> files) {
    if (files?.isEmpty ?? true) return;
    AdaptivePageLayout.of(context).popUntilIsFirst();
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
    AdaptivePageLayout.of(context).popUntilIsFirst();
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
    if (text == null || !text.startsWith(AppConfig.appOpenUrlScheme)) return;
    if (text.toLowerCase().startsWith(AppConfig.inviteLinkPrefix) ||
        (text.toLowerCase().startsWith(AppConfig.schemePrefix) &&
            !RegExp(r'\s').hasMatch(text))) {
      AdaptivePageLayout.of(context).popUntilIsFirst();
      UrlLauncher(context, text).openMatrixToUrl();
      return;
    }
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
    _intentDataStreamSubscription = linkStream.listen(_processIncomingUris);
    if (FluffyChatApp.gotInitialLink == false) {
      FluffyChatApp.gotInitialLink = true;
      getInitialLink().then(_processIncomingUris);
    }
  }

  @override
  void initState() {
    _initReceiveSharingIntent();
    super.initState();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    _intentFileStreamSubscription?.cancel();
    _intentUriStreamSubscription?.cancel();
    super.dispose();
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
          context: context,
          title: L10n.of(context).areYouSure,
          okLabel: L10n.of(context).yes,
          cancelLabel: L10n.of(context).cancel,
          useRootNavigator: false,
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
        context: context,
        title: L10n.of(context).setStatus,
        okLabel: L10n.of(context).ok,
        cancelLabel: L10n.of(context).cancel,
        useRootNavigator: false,
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
        AdaptivePageLayout.of(context).pushNamed('/settings');
        break;
      case PopupMenuAction.invite:
        FluffyShare.share(
            L10n.of(context).inviteText(Matrix.of(context).client.userID,
                'https://matrix.to/#/${Matrix.of(context).client.userID}'),
            context);
        break;
      case PopupMenuAction.newGroup:
        AdaptivePageLayout.of(context).pushNamed('/newgroup');
        break;
      case PopupMenuAction.archive:
        AdaptivePageLayout.of(context).pushNamed('/archive');
        break;
    }
  }

  Future<void> _archiveSelectedRooms() async {
    final client = Matrix.of(context).client;
    while (selectedRoomIds.isNotEmpty) {
      final roomId = selectedRoomIds.first;
      await client.getRoomById(roomId).leave();
      toggleSelection(roomId);
    }
  }

  Future<void> waitForFirstSync() async {
    final client = Matrix.of(context).client;
    if (client.prevBatch?.isEmpty ?? true) {
      await client.onFirstSync.stream.first;
    }
    return true;
  }

  void cancelAction() {
    final selectMode = Matrix.of(context).shareContent != null
        ? SelectMode.share
        : selectedRoomIds.isEmpty
            ? SelectMode.normal
            : SelectMode.select;
    if (selectMode == SelectMode.share) {
      setState(() => Matrix.of(context).shareContent = null);
    } else {
      setState(() => selectedRoomIds.clear());
    }
  }

  @override
  Widget build(BuildContext context) => ChatListUI(this);
}

enum ChatListPopupMenuItemActions {
  createGroup,
  discover,
  setStatus,
  inviteContact,
  settings,
}
