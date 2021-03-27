import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/components/contacts_list.dart';
import 'package:fluffychat/components/default_app_bar_search_field.dart';
import 'package:fluffychat/components/list_items/chat_list_item.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import '../utils/localized_exception_extension.dart';

class SearchView extends StatefulWidget {
  final String alias;

  const SearchView({Key key, this.alias}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  Future<PublicRoomsResponse> _publicRoomsResponse;
  String _lastServer;
  Timer _coolDown;
  String _genericSearchTerm;

  void _search(BuildContext context, String query) async {
    setState(() => null);
    _coolDown?.cancel();
    _coolDown = Timer(
      Duration(milliseconds: 500),
      () => setState(() {
        _genericSearchTerm = query;
        _publicRoomsResponse = null;
        searchUser(context, _controller.text);
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
        .joinRoomOrAlias(alias?.isNotEmpty ?? false ? alias : roomId);
    await Matrix.of(context)
        .client
        .onRoomUpdate
        .stream
        .firstWhere((r) => r.id == newRoomId);
    return newRoomId;
  }

  void _joinGroupAction(BuildContext context, PublicRoom room) async {
    if (await showOkCancelAlertDialog(
          context: context,
          okLabel: L10n.of(context).joinRoom,
          title: '${room.name} (${room.numJoinedMembers ?? 0})',
          message: room.topic ?? L10n.of(context).noDescription,
          cancelLabel: L10n.of(context).cancel,
          useRootNavigator: false,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => _joinRoomAndWait(
        context,
        room.roomId,
        room.canonicalAlias ?? room.aliases.first,
      ),
    );
    if (success.error == null) {
      await AdaptivePageLayout.of(context)
          .pushNamedAndRemoveUntilIsFirst('/rooms/${success.result}');
    }
  }

  String _server;

  void _setServer(BuildContext context) async {
    final newServer = await showTextInputDialog(
        title: L10n.of(context).changeTheHomeserver,
        context: context,
        okLabel: L10n.of(context).ok,
        cancelLabel: L10n.of(context).cancel,
        useRootNavigator: false,
        textFields: [
          DialogTextField(
            prefixText: 'https://',
            hintText: Matrix.of(context).client.homeserver.host,
            initialText: _server,
            keyboardType: TextInputType.url,
          )
        ]);
    if (newServer == null) return;
    setState(() {
      _server = newServer.single;
    });
  }

  String currentSearchTerm;
  List<Profile> foundProfiles = [];

  void searchUser(BuildContext context, String text) async {
    if (text.isEmpty) {
      setState(() {
        foundProfiles = [];
      });
    }
    currentSearchTerm = text;
    if (currentSearchTerm.isEmpty) return;
    final matrix = Matrix.of(context);
    UserSearchResult response;
    try {
      response = await matrix.client.searchUser(text, limit: 10);
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
    _genericSearchTerm = widget.alias;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final server = _genericSearchTerm?.isValidMatrixId ?? false
        ? _genericSearchTerm.domain
        : _server;
    if (_lastServer != server) {
      _lastServer = server;
      _publicRoomsResponse = null;
    }
    _publicRoomsResponse ??= Matrix.of(context)
        .client
        .searchPublicRooms(
          server: server,
          genericSearchTerm: _genericSearchTerm,
        )
        .catchError((error) {
      if (widget.alias == null) {
        throw error;
      }
      return PublicRoomsResponse.fromJson({
        'chunk': [],
      });
    }).then((PublicRoomsResponse res) {
      if (widget.alias != null &&
          !res.chunk.any((room) =>
              (room.aliases?.contains(widget.alias) ?? false) ||
              room.canonicalAlias == widget.alias)) {
        // we have to tack on the original alias
        res.chunk.add(PublicRoom.fromJson(<String, dynamic>{
          'aliases': [widget.alias],
          'name': widget.alias,
        }));
      }
      return res;
    });

    final rooms = List<Room>.from(Matrix.of(context).client.rooms);
    rooms.removeWhere(
      (room) =>
          room.lastEvent == null ||
          !room.displayname
              .toLowerCase()
              .contains(_controller.text.toLowerCase()),
    );
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          titleSpacing: 0,
          title: DefaultAppBarSearchField(
            autofocus: true,
            hintText: L10n.of(context).search,
            searchController: _controller,
            suffix: Icon(Icons.search_outlined),
            onChanged: (t) => _search(context, t),
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).accentColor,
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Theme.of(context).textTheme.bodyText1.color,
            labelStyle: TextStyle(fontSize: 16),
            labelPadding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 0,
            ),
            tabs: [
              Tab(child: Text(L10n.of(context).publicGroups, maxLines: 1)),
              Tab(child: Text(L10n.of(context).chats, maxLines: 1)),
              Tab(child: Text(L10n.of(context).people, maxLines: 1)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              children: [
                SizedBox(height: 12),
                ListTile(
                  leading: CircleAvatar(
                    foregroundColor: Theme.of(context).accentColor,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    child: Icon(Icons.edit_outlined),
                  ),
                  title: Text(L10n.of(context).changeTheServer),
                  onTap: () => _setServer(context),
                ),
                FutureBuilder<PublicRoomsResponse>(
                    future: _publicRoomsResponse,
                    builder: (BuildContext context,
                        AsyncSnapshot<PublicRoomsResponse> snapshot) {
                      if (snapshot.hasError) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 32),
                            Icon(
                              Icons.error_outlined,
                              size: 80,
                              color: Colors.grey,
                            ),
                            Center(
                              child: Text(
                                snapshot.error.toLocalizedString(context),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final publicRoomsResponse = snapshot.data;
                      if (publicRoomsResponse.chunk.isEmpty) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 32),
                            Icon(
                              Icons.search_outlined,
                              size: 80,
                              color: Colors.grey,
                            ),
                            Center(
                              child: Text(
                                L10n.of(context).noPublicRoomsFound,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(12),
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: publicRoomsResponse.chunk.length,
                        itemBuilder: (BuildContext context, int i) => Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () => _joinGroupAction(
                              context,
                              publicRoomsResponse.chunk[i],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Avatar(
                                      Uri.parse(publicRoomsResponse
                                              .chunk[i].avatarUrl ??
                                          ''),
                                      publicRoomsResponse.chunk[i].name),
                                  Text(
                                    publicRoomsResponse.chunk[i].name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    L10n.of(context).countParticipants(
                                        publicRoomsResponse
                                                .chunk[i].numJoinedMembers ??
                                            0),
                                    style: TextStyle(fontSize: 10.5),
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    publicRoomsResponse.chunk[i].topic ??
                                        L10n.of(context).noDescription,
                                    maxLines: 4,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
            ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (_, i) => ChatListItem(rooms[i]),
            ),
            foundProfiles.isNotEmpty
                ? ListView.builder(
                    itemCount: foundProfiles.length,
                    itemBuilder: (BuildContext context, int i) {
                      var foundProfile = foundProfiles[i];
                      return ListTile(
                        onTap: () {
                          setState(() {
                            _controller.text = currentSearchTerm =
                                foundProfile.userId.substring(1);
                          });
                        },
                        leading: Avatar(
                          foundProfile.avatarUrl,
                          foundProfile.displayname ?? foundProfile.userId,
                          //size: 24,
                        ),
                        title: Text(
                          foundProfile.displayname ??
                              foundProfile.userId.localpart,
                          style: TextStyle(),
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          foundProfile.userId,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  )
                : ContactsList(searchController: _controller),
          ],
        ),
      ),
    );
  }
}
