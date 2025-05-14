import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import '../../config/themes.dart';
import '../../utils/url_launcher.dart';
import '../avatar.dart';
import '../future_loading_dialog.dart';
import '../hover_builder.dart';
import '../matrix.dart';
import '../mxc_image_viewer.dart';
import 'adaptive_dialog_action.dart';

// #Pangea
// class PublicRoomDialog extends StatelessWidget {
class PublicRoomDialog extends StatefulWidget {
  // Pangea#
  final String? roomAlias;
  final PublicRoomsChunk? chunk;
  final List<String>? via;

  const PublicRoomDialog({super.key, this.roomAlias, this.chunk, this.via});
  // #Pangea
  static Future<bool?> show({
    required BuildContext context,
    String? roomAlias,
    PublicRoomsChunk? chunk,
    List<String>? via,
  }) async {
    final room = MatrixState.pangeaController.matrixState.client
        .getRoomById(chunk!.roomId);

    if (room != null && room.membership == Membership.join) {
      context.go("/rooms?spaceId=${room.id}");
      return null;
    }

    return showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => PublicRoomDialog(
        roomAlias: roomAlias,
        chunk: chunk,
        via: via,
      ),
    );
  }

  @override
  State<PublicRoomDialog> createState() => PublicRoomDialogState();
}

class PublicRoomDialogState extends State<PublicRoomDialog> {
  PublicRoomsChunk? get chunk => widget.chunk;
  String? get roomAlias => widget.roomAlias;
  List<String>? get via => widget.via;

  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
  // Pangea#

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

        // #Pangea
        // if (!knock && client.getRoomById(roomId) == null) {
        //   await client.waitForRoomInSync(roomId);
        // }
        final room = client.getRoomById(roomId);
        if (!knock && (room == null || room.membership != Membership.join)) {
          await client.waitForRoomInSync(roomId, join: true);
        }
        // Pangea#

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
    // #Pangea
    else {
      context.go('/rooms?spaceId=$roomId');
    }
    // Pangea#
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

  // #Pangea
  Future<void> _joinWithCode() async {
    final resp =
        await MatrixState.pangeaController.classController.joinClasswithCode(
      context,
      _codeController.text,
      notFoundError: L10n.of(context).notTheCodeError,
    );
    if (!resp.isError) {
      Navigator.of(context).pop(true);
    }
  }
  // Pangea#

  @override
  Widget build(BuildContext context) {
    final roomAlias = this.roomAlias ?? chunk?.canonicalAlias;
    // #Pangea
    // final roomLink = roomAlias ?? chunk?.roomId;
    String? roomLink = roomAlias ?? chunk?.roomId;
    if (roomLink != null) {
      roomLink =
          "${Environment.frontendURL}/#/join_with_alias?alias=${Uri.encodeComponent(roomLink)}";
    }
    // Pangea#
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
        // #Pangea
        // constraints: const BoxConstraints(maxWidth: 256, maxHeight: 256),
        constraints: const BoxConstraints(
          maxWidth: 256,
          maxHeight: 300,
        ),
        // Pangea#
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
                                // #Pangea
                                // ClipboardData(text: roomLink),
                                ClipboardData(text: roomLink!),
                                // Pangea#
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
                                  // #Pangea
                                  // TextSpan(text: roomLink),
                                  TextSpan(
                                    text: L10n.of(context).shareSpaceLink,
                                  ),
                                  // Pangea#
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
                  // #Pangea
                  Material(
                    type: MaterialType.transparency,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              controller: _codeController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: L10n.of(context).enterSpaceCode,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                labelStyle: const TextStyle(
                                  fontSize: 12,
                                ),
                                hintStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 12,
                                ),
                                isDense: true,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: _joinWithCode,
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.zero,
                                    bottomLeft: Radius.zero,
                                    topRight: Radius.circular(24),
                                    bottomRight: Radius.circular(24),
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                L10n.of(context).join,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Pangea#
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
                // #Pangea
                // ? L10n.of(context).knock
                ? L10n.of(context).askToJoin
                // Pangea#
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
