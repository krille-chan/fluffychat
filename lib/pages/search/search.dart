import 'dart:async';

import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/widgets/matrix.dart';
import 'search_view.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  SearchController createState() => SearchController();
}

class SearchController extends State<Search> {
  final TextEditingController controller = TextEditingController();
  Future<QueryPublicRoomsResponse> publicRoomsResponse;
  String lastServer;
  Timer _coolDown;
  String genericSearchTerm;

  void search(String query) async {
    setState(() => null);
    _coolDown?.cancel();
    _coolDown = Timer(
      const Duration(milliseconds: 500),
      () => setState(() {
        genericSearchTerm = query;
        publicRoomsResponse = null;
        searchUser(context, controller.text);
      }),
    );
  }

  Future<String> _joinRoomAndWait(
    BuildContext context,
    String roomId,
    String alias,
  ) async {
    if (Matrix.of(context).client.getRoomById(roomId) != null) {
      return roomId;
    }
    final newRoomId = await Matrix.of(context)
        .client
        .joinRoom(alias?.isNotEmpty ?? false ? alias : roomId);
    await Matrix.of(context).client.onSync.stream.firstWhere(
        (update) => update.rooms?.join?.containsKey(newRoomId) ?? false);
    return newRoomId;
  }

  void joinGroupAction(PublicRoomsChunk room) async {
    if (await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          okLabel: L10n.of(context).joinRoom,
          title: '${room.name} (${room.numJoinedMembers ?? 0})',
          message: room.topic ?? L10n.of(context).noDescription,
          cancelLabel: L10n.of(context).cancel,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => _joinRoomAndWait(
        context,
        room.roomId,
        room.canonicalAlias ?? room.aliases?.first,
      ),
    );
    if (success.error == null) {
      VRouter.of(context).toSegments(['rooms', success.result]);
    }
  }

  String server;

  void setServer() async {
    final newServer = await showTextInputDialog(
        useRootNavigator: false,
        title: L10n.of(context).changeTheHomeserver,
        context: context,
        okLabel: L10n.of(context).ok,
        cancelLabel: L10n.of(context).cancel,
        textFields: [
          DialogTextField(
            prefixText: 'https://',
            hintText: Matrix.of(context).client.homeserver.host,
            initialText: server,
            keyboardType: TextInputType.url,
          )
        ]);
    if (newServer == null) return;
    setState(() {
      server = newServer.single;
    });
  }

  String currentSearchTerm;
  List<Profile> foundProfiles = [];

  static const searchUserDirectoryLimit = 10;

  void searchUser(BuildContext context, String text) async {
    if (text.isEmpty) {
      setState(() {
        foundProfiles = [];
      });
    }
    currentSearchTerm = text;
    if (currentSearchTerm.isEmpty) return;
    final matrix = Matrix.of(context);
    SearchUserDirectoryResponse response;
    try {
      response = await matrix.client.searchUserDirectory(
        text,
        limit: searchUserDirectoryLimit,
      );
    } catch (_) {}
    foundProfiles = List<Profile>.from(response?.results ?? []);
    if (foundProfiles.isEmpty && text.isValidMatrixId && text.sigil == '@') {
      foundProfiles.add(Profile.fromJson({
        'displayname': text.localpart,
        'user_id': text,
      }));
    }
    setState(() => null);
  }

  bool _init = false;

  @override
  Widget build(BuildContext context) {
    if (!_init) {
      _init = true;
      controller.text = VRouter.of(context).queryParameters['query'] ?? '';
      WidgetsBinding.instance
          .addPostFrameCallback((_) => search(controller.text));
    }

    return SearchView(this);
  }
}
// #fluffychat:matrix.org
