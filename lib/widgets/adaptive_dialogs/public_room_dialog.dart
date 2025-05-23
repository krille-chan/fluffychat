import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import '../../config/themes.dart';
import '../../utils/url_launcher.dart';
import '../avatar.dart';
import '../future_loading_dialog.dart';
import '../hover_builder.dart';
import '../matrix.dart';
import '../mxc_image_viewer.dart';
import 'adaptive_dialog_action.dart';

class PublicRoomDialog extends StatelessWidget {
  final String? roomAlias;
  final PublicRoomsChunk? chunk;
  final List<String>? via;

  const PublicRoomDialog({super.key, this.roomAlias, this.chunk, this.via});

  void _joinRoom(BuildContext context) async {
    final client = Matrix.of(context).client;
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
    final roomId = result.result;
    if (roomId == null) return;
    if (knock && client.getRoomById(roomId) == null) {
      Navigator.of(context).pop<bool>(true);
      await showOkAlertDialog(
        context: context,
        title: L10n.of(context).youHaveKnocked,
        message: L10n.of(context).pleaseWaitUntilInvited,
      );
      return;
    }
    if (result.error != null) return;
    if (!context.mounted) return;
    Navigator.of(context).pop<bool>(true);
    // don't open the room if the joined room is a space
    if (chunk?.roomType != 'm.space' &&
        !client.getRoomById(result.result!)!.isSpace) {
      context.go('/rooms/$roomId');
    }
    return;
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
      throw (L10n.of(context).noRoomsFound);
    }
    return query.chunk.firstWhere(_testRoom);
  }

  @override
  Widget build(BuildContext context) {
    final roomAlias = this.roomAlias ?? chunk?.canonicalAlias;
    final roomLink = roomAlias ?? chunk?.roomId;
    var copied = false;
    return AlertDialog.adaptive(
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256),
        child: Text(
          chunk?.name ?? roomAlias?.localpart ?? chunk?.roomId ?? 'Unknown',
          textAlign: TextAlign.center,
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256, maxHeight: 256),
        child: FutureBuilder<PublicRoomsChunk>(
          future: _search(context),
          builder: (context, snapshot) {
            final theme = Theme.of(context);

            final profile = snapshot.data;
            final avatar = profile?.avatarUrl;
            final topic = profile?.topic;
            return SingleChildScrollView(
              child: Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (roomLink != null)
                    HoverBuilder(
                      builder: (context, hovered) => StatefulBuilder(
                        builder: (context, setState) => MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: roomLink),
                              );
                              setState(() {
                                copied = true;
                              });
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: AnimatedScale(
                                        duration:
                                            FluffyThemes.animationDuration,
                                        curve: FluffyThemes.animationCurve,
                                        scale: hovered
                                            ? 1.33
                                            : copied
                                                ? 1.25
                                                : 1.0,
                                        child: Icon(
                                          copied
                                              ? Icons.check_circle
                                              : Icons.copy,
                                          size: 12,
                                          color: copied ? Colors.green : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextSpan(text: roomLink),
                                ],
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(fontSize: 10),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: Avatar(
                      mxContent: avatar,
                      name: profile?.name ?? roomLink,
                      size: Avatar.defaultSize * 2,
                      onTap: avatar != null
                          ? () => showDialog(
                                context: context,
                                builder: (_) => MxcImageViewer(avatar),
                              )
                          : null,
                    ),
                  ),
                  if (profile?.numJoinedMembers != null)
                    Text(
                      L10n.of(context).countParticipants(
                        profile?.numJoinedMembers ?? 0,
                      ),
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  if (topic != null && topic.isNotEmpty)
                    SelectableLinkify(
                      text: topic,
                      textScaleFactor:
                          MediaQuery.textScalerOf(context).scale(1),
                      textAlign: TextAlign.center,
                      options: const LinkifyOptions(humanize: false),
                      linkStyle: TextStyle(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: theme.colorScheme.primary,
                      ),
                      onOpen: (url) =>
                          UrlLauncher(context, url.url).launchUrl(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        AdaptiveDialogAction(
          bigButtons: true,
          onPressed: () => _joinRoom(context),
          child: Text(
            chunk?.joinRule == 'knock' &&
                    Matrix.of(context).client.getRoomById(chunk!.roomId) == null
                ? L10n.of(context).knock
                : chunk?.roomType == 'm.space'
                    ? L10n.of(context).joinSpace
                    : L10n.of(context).joinRoom,
          ),
        ),
        AdaptiveDialogAction(
          bigButtons: true,
          onPressed: Navigator.of(context).pop,
          child: Text(L10n.of(context).close),
        ),
      ],
    );
  }
}
