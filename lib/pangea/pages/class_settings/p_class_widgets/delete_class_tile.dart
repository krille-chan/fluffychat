import 'package:fluffychat/pangea/utils/delete_room.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

class DeleteSpaceTile extends StatelessWidget {
  final Room room;

  const DeleteSpaceTile({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    bool classNameMatch = true;
    final textController = TextEditingController();
    Future<void> deleteSpace() async {
      final Client client = Matrix.of(context).client;
      final GetSpaceHierarchyResponse spaceHierarchy =
          await client.getSpaceHierarchy(room.id);

      if (spaceHierarchy.rooms.isNotEmpty) {
        final List<Room> spaceChats = spaceHierarchy.rooms
            .where((c) => c.roomId != room.id)
            .map((e) => Matrix.of(context).client.getRoomById(e.roomId))
            .where((c) => c != null && !c.isSpace && !c.isDirectChat)
            .cast<Room>()
            .toList();

        await Future.wait(
          spaceChats.map((c) => deleteRoom(c.id, client)),
        );
      }
      deleteRoom(room.id, client);
      context.go('/rooms');
      return;
    }

    Future<void> deleteChat() {
      context.go('/rooms');
      return deleteRoom(room.id, Matrix.of(context).client);
    }

    Future<void> deleteChatAction() async {
      showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      room.isSpace
                          ? L10n.of(context)!.areYouSureDeleteClass
                          : L10n.of(context)!.areYouSureDeleteGroup,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      L10n.of(context)!.cannotBeReversed,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    if (room.isSpace)
                      Text(
                        L10n.of(context)!.enterDeletedClassName,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
                content: room.isSpace
                    ? TextField(
                        autofocus: true,
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: room.name,
                          errorText: !classNameMatch
                              ? L10n.of(context)!.incorrectClassName
                              : null,
                        ),
                      )
                    : null,
                actions: <Widget>[
                  TextButton(
                    child: Text(L10n.of(context)!.ok),
                    onPressed: () async {
                      if (room.isSpace) {
                        setState(() {
                          classNameMatch = textController.text == room.name;
                        });
                        if (classNameMatch) {
                          Navigator.of(context).pop();
                          await showFutureLoadingDialog(
                            context: context,
                            future: () => deleteSpace(),
                          );
                        }
                      } else {
                        await showFutureLoadingDialog(
                          context: context,
                          future: () => deleteChat(),
                        );
                      }
                    },
                  ),
                  TextButton(
                    child: Text(L10n.of(context)!.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return ListTile(
      trailing: const Icon(Icons.delete_outlined),
      title: Text(
        room.isSpace
            ? L10n.of(context)!.deleteSpace
            : L10n.of(context)!.deleteGroup,
        style: const TextStyle(color: Colors.red),
      ),
      onTap: () => deleteChatAction(),
    );
  }
}
