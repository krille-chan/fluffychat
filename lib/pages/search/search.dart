import 'dart:async';

import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/utils/famedlysdk_store.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/public_room_bottom_sheet.dart';
import 'search_view.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  SearchController createState() => SearchController();
}

class SearchController extends State<Search> {
  final TextEditingController controller = TextEditingController();
  Future<QueryPublicRoomsResponse>? publicRoomsResponse;
  String? lastServer;
  Timer? _coolDown;
  String? genericSearchTerm;

  void search(String query) async {
    setState(() {});
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

  void joinGroupAction(PublicRoomsChunk room) {
    showModalBottomSheet(
      context: context,
      builder: (c) => PublicRoomBottomSheet(
        roomAlias: room.canonicalAlias ?? room.roomId,
        outerContext: context,
        chunk: room,
      ),
    );
  }

  String? server;

  static const String _serverStoreNamespace = 'im.fluffychat.search.server';

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
              initialText: server,
              keyboardType: TextInputType.url,
              autocorrect: false)
        ]);
    if (newServer == null) return;
    Store().setItem(_serverStoreNamespace, newServer.single);
    setState(() {
      server = newServer.single;
    });
  }

  String? currentSearchTerm;
  List<Profile> foundProfiles = [];

  static const searchUserDirectoryLimit = 10;

  void searchUser(BuildContext context, String text) async {
    if (text.isEmpty) {
      setState(() {
        foundProfiles = [];
      });
    }
    currentSearchTerm = text;
    if (currentSearchTerm?.isEmpty ?? true) return;
    final matrix = Matrix.of(context);
    SearchUserDirectoryResponse? response;
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
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.text = VRouter.of(context).queryParameters['query'] ?? '';
      final server = await Store().getItem(_serverStoreNamespace);
      if (server?.isNotEmpty ?? false) {
        this.server = server;
      }
      search(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) => SearchView(this);
}
