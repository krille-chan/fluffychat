import 'dart:math';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
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
  late List<SuggestionStatus> parents;
  late List<Room> possibleParents;
  late bool isOpen;

  AddToSpaceState({Key? key});

  @override
  void initState() {
    //if roomId is null, it means this widget is being used in the creation flow
    room = widget.roomId != null
        ? Matrix.of(context).client.getRoomById(widget.roomId!)
        : null;

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
            .map((r) => SuggestionStatus(false, r))
            .cast<SuggestionStatus>()
            .toList()
        : [];

    if (widget.activeSpaceId != null) {
      final activeSpace =
          Matrix.of(context).client.getRoomById(widget.activeSpaceId!);
      if (activeSpace != null) {
        parents.add(SuggestionStatus(false, activeSpace));
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
      if (parents.any((suggestionStatus) => suggestionStatus.room.id == a.id)) {
        return -1;
      } else if (parents
          .any((suggestionStatus) => suggestionStatus.room.id == b.id)) {
        return 1;
      } else {
        return a.name.compareTo(b.name);
      }
    });

    isOpen = widget.startOpen;
    initSuggestedParents();
    super.initState();
  }

  Future<void> initSuggestedParents() async {
    if (room != null) {
      for (var i = 0; i < parents.length; i++) {
        final parent = parents[i];
        final bool suggested =
            await room?.suggestedInSpace(parent.room) ?? false;
        parents[i].suggested = suggested;
      }
      setState(() {});
    }
  }

  Future<void> _addSingleSpace(String roomToAddId, Room newParent) {
    GoogleAnalytics.addParent(roomToAddId, newParent.classCode);
    return newParent.setSpaceChild(
      roomToAddId,
      suggested: isSuggestedInSpace(newParent),
    );
  }

  Future<void> addSpaces(String roomToAddId) async {
    final List<Future<void>> addFutures = [];
    for (final SuggestionStatus newParent in parents) {
      addFutures.add(_addSingleSpace(roomToAddId, newParent.room));
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
      );
    }

    setState(
      () => add
          ? parents.add(SuggestionStatus(false, possibleParent))
          : parents.removeWhere(
              (suggestionStatus) =>
                  suggestionStatus.room.id == possibleParent.id,
            ),
    );
  }

  Future<void> setSuggested(bool suggest, Room possibleParent) async {
    if (room != null) {
      await showFutureLoadingDialog(
        context: context,
        future: () => room!.setSuggestedInSpace(suggest, possibleParent),
      );
    }

    for (final SuggestionStatus suggestionStatus in parents) {
      if (suggestionStatus.room.id == possibleParent.id) {
        suggestionStatus.suggested = suggest;
      }
    }

    setState(() {});
  }

  bool isSuggestedInSpace(Room parent) =>
      parents.firstWhereOrNull((r) => r.room.id == parent.id)?.suggested ??
      false;

  Widget getAddToSpaceToggleItem(int index) {
    final Room possibleParent = possibleParents[index];
    final String possibleParentName = possibleParent.getLocalizedDisplayname();
    final bool canAdd = possibleParent.canIAddSpaceChild(room);

    return Opacity(
      opacity: canAdd ? 1 : 0.5,
      child: Column(
        children: [
          SwitchListTile.adaptive(
            title: possibleParent.nameAndRoomTypeIcon(),
            activeColor: AppConfig.activeToggleColor,
            value: parents.any((r) => r.room.id == possibleParent.id),
            onChanged: (bool add) => canAdd
                ? handleAdd(add, possibleParent)
                : ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(L10n.of(context)!.noPermission),
                    ),
                  ),
          ),
          if (parents.any((r) => r.room.id == possibleParent.id))
            SwitchListTile.adaptive(
              title: Text(
                L10n.of(context)!.suggestTo(possibleParentName),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              subtitle: Text(
                widget.mode == AddToClassMode.chat
                    ? L10n.of(context)!.suggestChatDesc(possibleParentName)
                    : L10n.of(context)!.suggestExchangeDesc(possibleParentName),
              ),
              activeColor: AppConfig.activeToggleColor,
              value: isSuggestedInSpace(possibleParent),
              onChanged: (bool suggest) =>
                  setSuggested(suggest, possibleParent),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.mode == AddToClassMode.exchange
        ? L10n.of(context)!.addToClass
        : L10n.of(context)!.addToClassOrExchange;
    final String subtitle = widget.mode == AddToClassMode.exchange
        ? L10n.of(context)!.addToClassDesc
        : L10n.of(context)!.addToClassOrExchangeDesc;
    final scrollController = ScrollController();

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
              ? Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        const Divider(height: 1),
                        SizedBox(
                          height: min(possibleParents.length * 55, 500),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: possibleParents.length,
                            itemBuilder: (BuildContext context, int i) {
                              return getAddToSpaceToggleItem(i);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
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

class SuggestionStatus {
  bool suggested;
  final Room room;

  SuggestionStatus(this.suggested, this.room);
}
