import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import '../../../widgets/matrix.dart';
import '../../utils/firebase_analytics.dart';
import 'add_class_and_invite.dart';

//PTODO - auto invite students when you add a space and delete the add_class_and_invite.dart file
class AddToSpaceToggles extends StatefulWidget {
  final String? roomId;
  final bool startOpen;
  final String? activeSpaceId;
  final AddToClassMode mode;

  const AddToSpaceToggles({
    super.key,
    this.roomId,
    this.startOpen = false,
    this.activeSpaceId,
    required this.mode,
  });

  @override
  AddToSpaceState createState() => AddToSpaceState();
}

class AddToSpaceState extends State<AddToSpaceToggles> {
  late Room? room;
  late List<Room> parents;
  late List<Room> possibleParents;
  late bool isOpen;
  late bool isSuggested;

  AddToSpaceState({Key? key});

  @override
  void initState() {
    //if roomId is null, it means this widget is being used in the creation flow
    room = widget.roomId != null
        ? Matrix.of(context).client.getRoomById(widget.roomId!)
        : null;

    isSuggested = true;
    room?.isSuggested().then((value) => isSuggested = value);

    possibleParents = Matrix.of(context)
        .client
        .rooms
        .where(
          widget.mode == AddToClassMode.exchange
              ? (Room r) => r.isPangeaClass && widget.roomId != r.id
              : (Room r) =>
                  (r.isPangeaClass || r.isExchange) && widget.roomId != r.id,
        )
        .toList();

    parents = widget.roomId != null
        ? possibleParents
            .where(
              (r) =>
                  r.spaceChildren.any((room) => room.roomId == widget.roomId),
            )
            .toList()
        : [];

    if (widget.activeSpaceId != null) {
      final activeSpace =
          Matrix.of(context).client.getRoomById(widget.activeSpaceId!);
      if (activeSpace != null && activeSpace.canIAddSpaceChild(null)) {
        parents.add(activeSpace);
      } else {
        ErrorHandler.logError(
          e: Exception('activeSpaceId ${widget.activeSpaceId} not found'),
        );
      }
    }

    //sort possibleParents
    //if possibleParent in parents, put first
    //use sort but use any instead of contains because contains uses == and we want to compare by id
    possibleParents.sort((a, b) {
      if (parents.any((parent) => parent.id == a.id)) {
        return -1;
      } else if (parents.any((parent) => parent.id == b.id)) {
        return 1;
      } else {
        return a.name.compareTo(b.name);
      }
    });

    isOpen = widget.startOpen;
    super.initState();
  }

  Future<void> _addSingleSpace(String roomToAddId, Room newParent) async {
    GoogleAnalytics.addParent(roomToAddId, newParent.classCode);
    await newParent.setSpaceChild(
      roomToAddId,
      suggested: isSuggested,
    );
  }

  Future<void> addSpaces(String roomToAddId) async {
    final List<Future<void>> addFutures = [];
    for (final Room parent in parents) {
      addFutures.add(_addSingleSpace(roomToAddId, parent));
    }
    await addFutures.wait;
  }

  Future<void> handleAdd(bool add, Room possibleParent) async {
    //in this case, the room has already been made so we handle adding as it happens
    if (room != null) {
      await showFutureLoadingDialog(
        context: context,
        future: () => add
            ? _addSingleSpace(room!.id, possibleParent)
            : possibleParent.removeSpaceChild(room!.id),
        onError: (e) {
          // if error occurs, do not change value of toggle
          add = !add;
          return (e as Object?)?.toLocalizedString(context) ??
              e?.toString() ??
              L10n.of(context)!.oopsSomethingWentWrong;
        },
      );
    }

    setState(
      () => add
          ? parents.add(possibleParent)
          : parents.removeWhere(
              (parent) => parent.id == possibleParent.id,
            ),
    );
  }

  Widget getAddToSpaceToggleItem(int index) {
    final Room possibleParent = possibleParents[index];
    final bool canAdd = !(!possibleParent.isRoomAdmin &&
            widget.mode == AddToClassMode.exchange) &&
        possibleParent.canIAddSpaceChild(room);

    return Opacity(
      opacity: canAdd ? 1 : 0.5,
      child: Column(
        children: [
          SwitchListTile.adaptive(
            title: possibleParent.nameAndRoomTypeIcon(),
            activeColor: AppConfig.activeToggleColor,
            value: parents.any((r) => r.id == possibleParent.id),
            onChanged: (bool add) => canAdd
                ? handleAdd(add, possibleParent)
                : ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(L10n.of(context)!.noPermission),
                    ),
                  ),
          ),
          Divider(
            height: 0.5,
            color: Theme.of(context).colorScheme.secondary.withAlpha(25),
          ),
        ],
      ),
    );
  }

  Future<void> setSuggested(bool suggested) async {
    setState(() => isSuggested = suggested);
    if (room != null) {
      await showFutureLoadingDialog(
        context: context,
        future: () async => await room?.setSuggested(suggested),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.mode == AddToClassMode.exchange
        ? L10n.of(context)!.addToClass
        : L10n.of(context)!.addToClassOrExchange;
    final String subtitle = widget.mode == AddToClassMode.exchange
        ? L10n.of(context)!.addToClassDesc
        : L10n.of(context)!.addToClassOrExchangeDesc;

    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(subtitle),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
            child: const Icon(Icons.workspaces_outlined),
          ),
          trailing: Icon(
            isOpen
                ? Icons.keyboard_arrow_down_outlined
                : Icons.keyboard_arrow_right_outlined,
          ),
          onTap: () {
            setState(() => isOpen = !isOpen);
          },
        ),
        if (isOpen) ...[
          const Divider(height: 1),
          possibleParents.isNotEmpty
              ? Column(
                  children: [
                    SwitchListTile.adaptive(
                      title: Text(L10n.of(context)!.suggestToChat),
                      secondary: Icon(
                        isSuggested
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      subtitle: Text(L10n.of(context)!.suggestToChatDesc),
                      activeColor: AppConfig.activeToggleColor,
                      value: isSuggested,
                      onChanged: (bool add) => setSuggested(add),
                    ),
                    Divider(
                      height: 0.5,
                      color:
                          Theme.of(context).colorScheme.secondary.withAlpha(25),
                    ),
                    ...possibleParents.mapIndexed(
                      (index, _) => getAddToSpaceToggleItem(index),
                    ),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      L10n.of(context)!.inNoSpaces,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
        ],
      ],
    );
  }
}
