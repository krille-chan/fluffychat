import 'package:matrix/matrix.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/contacts_list.dart';
import 'package:fluffychat/widgets/default_app_bar_search_field.dart';
import 'package:fluffychat/widgets/list_items/chat_list_item.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:vrouter/vrouter.dart';
import '../../utils/localized_exception_extension.dart';
import '../search.dart';

class SearchView extends StatelessWidget {
  final SearchController controller;

  const SearchView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final server = controller.genericSearchTerm?.isValidMatrixId ?? false
        ? controller.genericSearchTerm.domain
        : controller.server;
    if (controller.lastServer != server) {
      controller.lastServer = server;
      controller.publicRoomsResponse = null;
    }
    controller.publicRoomsResponse ??= Matrix.of(context)
        .client
        .queryPublicRooms(
          server: server,
          genericSearchTerm: controller.genericSearchTerm,
        )
        .catchError((error) {
      if (controller.alias == null) {
        throw error;
      }
      return PublicRoomsResponse.fromJson({
        'chunk': [],
      });
    }).then((PublicRoomsResponse res) {
      if (controller.alias != null &&
          !res.chunk.any((room) =>
              (room.aliases?.contains(controller.alias) ?? false) ||
              room.canonicalAlias == controller.alias)) {
        // we have to tack on the original alias
        res.chunk.add(PublicRoom.fromJson(<String, dynamic>{
          'aliases': [controller.alias],
          'name': controller.alias,
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
              .contains(controller.controller.text.toLowerCase()),
    );
    return DefaultTabController(
      length: 3,
      initialIndex:
          controller.controller.text?.startsWith('#') ?? false ? 0 : 1,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          titleSpacing: 0,
          title: DefaultAppBarSearchField(
            autofocus: true,
            hintText: L10n.of(context).search,
            searchController: controller.controller,
            suffix: Icon(Icons.search_outlined),
            onChanged: controller.search,
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor: Theme.of(context).textTheme.bodyText1.color,
            labelStyle: TextStyle(fontSize: 16),
            labelPadding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 0,
            ),
            tabs: [
              Tab(child: Text(L10n.of(context).discover, maxLines: 1)),
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
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    child: Icon(Icons.edit_outlined),
                  ),
                  title: Text(L10n.of(context).changeTheServer),
                  onTap: controller.setServer,
                ),
                FutureBuilder<PublicRoomsResponse>(
                    future: controller.publicRoomsResponse,
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
                            onTap: () => controller.joinGroupAction(
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
            controller.foundProfiles.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.foundProfiles.length,
                    itemBuilder: (BuildContext context, int i) {
                      final foundProfile = controller.foundProfiles[i];
                      return ListTile(
                        onTap: () async {
                          final roomID = await showFutureLoadingDialog(
                            context: context,
                            future: () => Matrix.of(context)
                                .client
                                .startDirectChat(foundProfile.userId),
                          );
                          if (roomID.error == null) {
                            VRouter.of(context)
                                .toSegments(['rooms', roomID.result]);
                          }
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
                : ContactsList(searchController: controller.controller),
          ],
        ),
      ),
    );
  }
}
