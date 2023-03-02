import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix_link_text/link_text.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../utils/localized_exception_extension.dart';

class PublicRoomBottomSheet extends StatelessWidget {
  final String? roomAlias;
  final BuildContext outerContext;
  final PublicRoomsChunk? chunk;
  final VoidCallback? onRoomJoined;

  PublicRoomBottomSheet({
    this.roomAlias,
    required this.outerContext,
    this.chunk,
    this.onRoomJoined,
    Key? key,
  }) : super(key: key) {
    assert(roomAlias != null || chunk != null);
  }

  void _joinRoom(BuildContext context) async {
    final client = Matrix.of(context).client;
    final result = await showFutureLoadingDialog<String>(
      context: context,
      future: () => chunk?.joinRule == 'knock'
          ? client.knockRoom(chunk!.roomId)
          : client.joinRoom(roomAlias ?? chunk!.roomId),
    );
    if (result.error == null) {
      if (client.getRoomById(result.result!) == null) {
        await client.onSync.stream.firstWhere(
          (sync) => sync.rooms?.join?.containsKey(result.result) ?? false,
        );
      }
      // don't open the room if the joined room is a space
      if (!client.getRoomById(result.result!)!.isSpace) {
        VRouter.of(context).toSegments(['rooms', result.result!]);
      }
      Navigator.of(context, rootNavigator: false).pop();
      return;
    }
  }

  bool _testRoom(PublicRoomsChunk r) => r.canonicalAlias == roomAlias;

  Future<PublicRoomsChunk> _search(BuildContext context) async {
    final chunk = this.chunk;
    if (chunk != null) return chunk;
    final query = await Matrix.of(context).client.queryPublicRooms(
          server: roomAlias!.domain,
          filter: PublicRoomQueryFilter(
            genericSearchTerm: roomAlias,
          ),
        );
    if (!query.chunk.any(_testRoom)) {
      throw (L10n.of(context)!.noRoomsFound);
    }
    return query.chunk.firstWhere(_testRoom);
  }

  @override
  Widget build(BuildContext context) {
    final roomAlias = this.roomAlias;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            roomAlias ?? chunk!.name ?? chunk!.roomId,
            overflow: TextOverflow.fade,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_downward_outlined),
            onPressed: Navigator.of(context, rootNavigator: false).pop,
            tooltip: L10n.of(context)!.close,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton.icon(
                onPressed: () => _joinRoom(context),
                label: Text(L10n.of(context)!.joinRoom),
                icon: const Icon(Icons.login_outlined),
              ),
            ),
          ],
        ),
        body: FutureBuilder<PublicRoomsChunk>(
          future: _search(context),
          builder: (context, snapshot) {
            final profile = snapshot.data;
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                if (profile == null)
                  Container(
                    height: 156,
                    alignment: Alignment.center,
                    color: Theme.of(context).secondaryHeaderColor,
                    child: snapshot.hasError
                        ? Text(snapshot.error!.toLocalizedString(context))
                        : const CircularProgressIndicator.adaptive(
                            strokeWidth: 2,
                          ),
                  )
                else
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Avatar(
                        mxContent: profile.avatarUrl,
                        name: profile.name ?? roomAlias,
                        size: Avatar.defaultSize * 3,
                        fontSize: 36,
                      ),
                    ),
                  ),
                ListTile(
                  title: Text(
                    profile?.name ??
                        roomAlias?.localpart ??
                        chunk!.roomId.localpart ??
                        '',
                  ),
                  subtitle: Text(
                    '${L10n.of(context)!.participant}: ${profile?.numJoinedMembers ?? 0}',
                  ),
                  trailing: const Icon(Icons.account_box_outlined),
                ),
                if (profile?.topic?.isNotEmpty ?? false)
                  ListTile(
                    title: Text(
                      L10n.of(context)!.groupDescription,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    subtitle: LinkText(
                      text: profile!.topic!,
                      linkStyle: const TextStyle(color: Colors.blueAccent),
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      onLinkTap: (url) => UrlLauncher(context, url).launchUrl(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
