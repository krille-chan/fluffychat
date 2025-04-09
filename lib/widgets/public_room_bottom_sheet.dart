import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/qr_code_viewer.dart';

class PublicRoomBottomSheet extends StatelessWidget {
  final String? roomAlias;
  final BuildContext outerContext;
  final PublicRoomsChunk? chunk;
  final List<String>? via;

  PublicRoomBottomSheet({
    this.roomAlias,
    required this.outerContext,
    this.chunk,
    this.via,
    super.key,
  }) {
    assert(roomAlias != null || chunk != null);
  }

  void _joinRoom(BuildContext context) async {
    final client = Matrix.of(outerContext).client;
    final chunk = this.chunk;
    final knock = chunk?.joinRule == 'knock';
    final result = await showFutureLoadingDialog<String>(
      context: context,
      future: () async {
        if (chunk != null && client.getRoomById(chunk.roomId) != null) {
          return chunk.roomId;
        }
        final roomId = chunk != null && knock
            ? await client.knockRoom(chunk.roomId, via: via)
            : await client.joinRoom(
                roomAlias ?? chunk!.roomId,
                via: via,
              );

        if (!knock && client.getRoomById(roomId) == null) {
          await client.waitForRoomInSync(roomId);
        }
        return roomId;
      },
    );
    if (knock) {
      return;
    }
    if (result.error == null) {
      Navigator.of(context).pop<bool>(true);
      // don't open the room if the joined room is a space
      if (chunk?.roomType != 'm.space' &&
          !client.getRoomById(result.result!)!.isSpace) {
        outerContext.go('/rooms/${result.result!}');
      }
      return;
    }
  }

  bool _testRoom(PublicRoomsChunk r) => r.canonicalAlias == roomAlias;

  Future<PublicRoomsChunk> _search() async {
    final chunk = this.chunk;
    if (chunk != null) return chunk;
    final query = await Matrix.of(outerContext).client.queryPublicRooms(
          server: roomAlias!.domain,
          filter: PublicRoomQueryFilter(
            genericSearchTerm: roomAlias,
          ),
        );
    if (!query.chunk.any(_testRoom)) {
      throw (L10n.of(outerContext).noRoomsFound);
    }
    return query.chunk.firstWhere(_testRoom);
  }

  @override
  Widget build(BuildContext context) {
    final roomAlias = this.roomAlias ?? chunk?.canonicalAlias;
    final roomLink = roomAlias ?? chunk?.roomId;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            chunk?.name ?? roomAlias ?? chunk?.roomId ?? 'Unknown',
            overflow: TextOverflow.fade,
          ),
          leading: Center(
            child: CloseButton(
              onPressed: Navigator.of(context, rootNavigator: false).pop,
            ),
          ),
          actions: roomAlias == null
              ? null
              : [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton(
                      icon: const Icon(Icons.qr_code_rounded),
                      onPressed: () => showQrCodeViewer(
                        context,
                        roomAlias,
                      ),
                    ),
                  ),
                ],
        ),
        body: FutureBuilder<PublicRoomsChunk>(
          future: _search(),
          builder: (context, snapshot) {
            final theme = Theme.of(context);

            final profile = snapshot.data;
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: profile == null
                          ? const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : Avatar(
                              client: Matrix.of(outerContext).client,
                              mxContent: profile.avatarUrl,
                              name: profile.name ?? roomAlias,
                              size: Avatar.defaultSize * 3,
                            ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            onPressed: roomLink != null
                                ? () => FluffyShare.share(
                                      roomLink,
                                      context,
                                      copyOnly: true,
                                    )
                                : null,
                            icon: const Icon(
                              Icons.copy_outlined,
                              size: 14,
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.onSurface,
                              iconColor: theme.colorScheme.onSurface,
                            ),
                            label: Text(
                              roomLink ?? '...',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.groups_3_outlined,
                              size: 14,
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.onSurface,
                              iconColor: theme.colorScheme.onSurface,
                            ),
                            label: Text(
                              L10n.of(context).countParticipants(
                                profile?.numJoinedMembers ?? 0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _joinRoom(context),
                    label: Text(
                      chunk?.joinRule == 'knock' &&
                              Matrix.of(outerContext)
                                      .client
                                      .getRoomById(chunk!.roomId) ==
                                  null
                          ? L10n.of(context).knock
                          : chunk?.roomType == 'm.space'
                              ? L10n.of(context).joinSpace
                              : L10n.of(context).joinRoom,
                    ),
                    icon: const Icon(Icons.navigate_next),
                  ),
                ),
                const SizedBox(height: 16),
                if (profile?.topic?.isNotEmpty ?? false)
                  ListTile(
                    subtitle: SelectableLinkify(
                      text: profile!.topic!,
                      linkStyle: TextStyle(
                        color: theme.colorScheme.primary,
                        decorationColor: theme.colorScheme.primary,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                      options: const LinkifyOptions(humanize: false),
                      onOpen: (url) =>
                          UrlLauncher(context, url.url).launchUrl(),
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
