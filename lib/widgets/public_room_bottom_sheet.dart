import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_matrix_html/flutter_html.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/content_banner.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../utils/localized_exception_extension.dart';

class PublicRoomBottomSheet extends StatelessWidget {
  final String roomAlias;
  final BuildContext outerContext;
  final PublicRoomsChunk chunk;
  const PublicRoomBottomSheet({
    @required this.roomAlias,
    @required this.outerContext,
    this.chunk,
    Key key,
  }) : super(key: key);

  void _joinRoom(BuildContext context) async {
    final client = Matrix.of(context).client;
    final result = await showFutureLoadingDialog<String>(
      context: context,
      future: () => client.joinRoom(roomAlias),
    );
    if (result.error == null) {
      if (client.getRoomById(result.result) == null) {
        await client.onSync.stream.firstWhere(
            (sync) => sync.rooms?.join?.containsKey(result.result) ?? false);
      }
      VRouter.of(context).toSegments(['rooms', result.result]);
      Navigator.of(context, rootNavigator: false).pop();
      return;
    }
  }

  bool _testRoom(PublicRoomsChunk r) =>
      r.canonicalAlias == roomAlias ||
      (r.aliases?.contains(roomAlias) ?? false);

  Future<PublicRoomsChunk> _search(BuildContext context) async {
    if (chunk != null) return chunk;
    final query = await Matrix.of(context).client.queryPublicRooms(
          server: roomAlias.domain,
          filter: PublicRoomQueryFilter(
            genericSearchTerm: roomAlias,
          ),
        );
    if (!query.chunk.any(_testRoom) ?? true) {
      throw (L10n.of(context).noRoomsFound);
    }
    return query.chunk.firstWhere(_testRoom);
  }

  @override
  Widget build(BuildContext context) {
    final roomAlias =
        this.roomAlias ?? chunk.canonicalAlias ?? chunk.aliases?.first ?? '';
    return Center(
      child: SizedBox(
        width: min(
            MediaQuery.of(context).size.width, FluffyThemes.columnWidth * 1.5),
        child: Material(
          elevation: 4,
          child: SafeArea(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                title: Text(roomAlias),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_downward_outlined),
                  onPressed: Navigator.of(context, rootNavigator: false).pop,
                  tooltip: L10n.of(context).close,
                ),
              ),
              body: FutureBuilder<PublicRoomsChunk>(
                  future: _search(context),
                  builder: (context, snapshot) {
                    final profile = snapshot.data;
                    return Column(
                      children: [
                        Expanded(
                          child: profile == null
                              ? Container(
                                  alignment: Alignment.center,
                                  color: Theme.of(context).secondaryHeaderColor,
                                  child: snapshot.hasError
                                      ? Text(snapshot.error
                                          .toLocalizedString(context))
                                      : const CircularProgressIndicator
                                          .adaptive(strokeWidth: 2),
                                )
                              : ContentBanner(
                                  profile.avatarUrl,
                                  defaultIcon: Icons.person_outline,
                                  client: Matrix.of(context).client,
                                ),
                        ),
                        ListTile(
                          title: Text(profile?.name ?? roomAlias.localpart),
                          subtitle: Text(
                              '${L10n.of(context).participant}: ${profile?.numJoinedMembers ?? 0}'),
                          trailing: const Icon(Icons.account_box_outlined),
                        ),
                        if (profile?.topic != null && profile.topic.isNotEmpty)
                          ListTile(
                            subtitle: Html(data: profile.topic),
                          ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          child: ElevatedButton.icon(
                            onPressed: () => _joinRoom(context),
                            label: Text(L10n.of(context).joinRoom),
                            icon: const Icon(Icons.login_outlined),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
