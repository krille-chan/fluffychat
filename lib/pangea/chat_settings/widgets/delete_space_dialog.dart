import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/chat_settings/utils/delete_room.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';

class DeleteSpaceDialog extends StatefulWidget {
  final Room space;
  const DeleteSpaceDialog({
    super.key,
    required this.space,
  });

  @override
  State<DeleteSpaceDialog> createState() => DeleteSpaceDialogState();
}

class DeleteSpaceDialogState extends State<DeleteSpaceDialog> {
  List<SpaceRoomsChunk> _rooms = [];
  final List<SpaceRoomsChunk> _roomsToDelete = [];

  bool _loadingRooms = true;
  String? _roomLoadError;

  bool _deleting = false;
  String? _deleteError;

  @override
  void initState() {
    super.initState();
    _getSpaceChildrenToDelete();
  }

  Future<void> _getSpaceChildrenToDelete() async {
    setState(() {
      _loadingRooms = true;
      _roomLoadError = null;
    });

    try {
      _rooms = await widget.space.getSpaceChildrenToDelete();
    } catch (e, s) {
      _roomLoadError = L10n.of(context).oopsSomethingWentWrong;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "roomID": widget.space.id,
        },
      );
    } finally {
      setState(() {
        _loadingRooms = false;
      });
    }
  }

  void _onRoomSelected(
    bool? selected,
    SpaceRoomsChunk room,
  ) {
    if (selected == null ||
        (selected && _roomsToDelete.contains(room)) ||
        (!selected && !_roomsToDelete.contains(room))) {
      return;
    }

    setState(() {
      selected ? _roomsToDelete.add(room) : _roomsToDelete.remove(room);
    });
  }

  Future<void> _deleteSpace() async {
    setState(() {
      _deleting = true;
      _deleteError = null;
    });

    try {
      final List<Future<void>> deleteFutures = [];
      for (final room in _roomsToDelete) {
        final roomInstance = widget.space.client.getRoomById(room.roomId);
        if (roomInstance != null) {
          deleteFutures.add(roomInstance.delete());
        }
      }
      await Future.wait(deleteFutures);
      await widget.space.delete();
      Navigator.of(context).pop(true);
    } catch (e, s) {
      _deleteError = L10n.of(context).oopsSomethingWentWrong;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "roomID": widget.space.id,
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _deleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              L10n.of(context).areYouSure,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                L10n.of(context).deleteSpaceDesc,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            SizedBox(
              height: 300,
              child: Builder(
                builder: (context) {
                  if (_loadingRooms) {
                    return const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }

                  if (_roomLoadError != null) {
                    return Center(
                      child: Column(
                        spacing: 8.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          Text(L10n.of(context).oopsSomethingWentWrong),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _rooms.length,
                      itemBuilder: (context, index) {
                        final chunk = _rooms[index];

                        final room =
                            widget.space.client.getRoomById(chunk.roomId);
                        final isMember = room != null &&
                            room.membership == Membership.join &&
                            room.isRoomAdmin;

                        final displayname = chunk.name ??
                            chunk.canonicalAlias ??
                            L10n.of(context).emptyChat;

                        return AnimatedOpacity(
                          duration: FluffyThemes.animationDuration,
                          opacity: isMember ? 1 : 0.5,
                          child: CheckboxListTile(
                            value: _roomsToDelete.contains(chunk),
                            onChanged: isMember
                                ? (value) => _onRoomSelected(value, chunk)
                                : null,
                            title: Text(displayname),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
              child: Row(
                spacing: 8.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSize(
                    duration: FluffyThemes.animationDuration,
                    child: OutlinedButton(
                      onPressed: _deleting ? null : _deleteSpace,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(
                          color: _deleting
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).colorScheme.error,
                        ),
                      ),
                      child: _deleting
                          ? const SizedBox(
                              height: 10,
                              width: 100,
                              child: LinearProgressIndicator(),
                            )
                          : Text(L10n.of(context).delete),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: Navigator.of(context).pop,
                    child: Text(L10n.of(context).cancel),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: FluffyThemes.animationDuration,
              child: _deleteError != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(L10n.of(context).oopsSomethingWentWrong),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
