import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import '../../../widgets/matrix.dart';
import '../../utils/error_handler.dart';
import '../../utils/firebase_analytics.dart';

enum AddToClassMode { exchange, chat }

class AddToClassAndInviteToggles extends StatefulWidget {
  final String? roomId;
  final bool startOpen;
  final Function? setParentState;
  final AddToClassMode mode;

  const AddToClassAndInviteToggles({
    super.key,
    this.roomId,
    this.startOpen = false,
    this.setParentState,
    required this.mode,
  });

  @override
  AddToClassAndInviteState createState() => AddToClassAndInviteState();
}

class AddToClassAndInviteState extends State<AddToClassAndInviteToggles> {
  late Room? room;
  late List<Room> parents;
  late List<Room> possibleParents;
  late bool isOpen;

  AddToClassAndInviteState({Key? key});

  @override
  void initState() {
    room = widget.roomId != null
        ? Matrix.of(context).client.getRoomById(widget.roomId!)
        : null;

    if (room != null && room!.isPangeaClass) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "should not be able to add class to space, not yet at least",
      );
      context.go('/rooms');
    }

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

    isOpen = widget.startOpen;

    super.initState();
  }

  Future<void> addParents(String roomToAddId) async {
    final List<Future<void>> addFutures = [];
    for (final Room newParent in parents) {
      addFutures.add(_addSingleParent(roomToAddId, newParent));
    }
    await addFutures.wait;
  }

  Future<void> _addSingleParent(String roomToAddId, Room newParent) async {
    GoogleAnalytics.addParent(roomToAddId, newParent.classCode);
    final List<List<User>> existingMembers = await Future.wait([
      room!.requestParticipants(),
      newParent.requestParticipants(),
    ]);
    final List<User> roomMembers = existingMembers[0];
    final List<User> spaceMembers = existingMembers[1];

    final List<Future<void>> inviteFutures = [
      newParent.setSpaceChild(roomToAddId, suggested: true),
    ];
    for (final spaceMember
        in spaceMembers.where((element) => element.id != room!.client.userID)) {
      if (!roomMembers.any(
        (m) => m.id == spaceMember.id && m.membership == Membership.join,
      )) {
        inviteFutures.add(_inviteSpaceMember(spaceMember));
      } else {
        debugPrint('User ${spaceMember.id} is already in the room');
      }
    }
    await Future.wait(inviteFutures);
    return;
  }

  //function for kicking single student and haandling error
  Future<void> _kickSpaceMember(User spaceMember) async {
    try {
      await room!.kick(spaceMember.id);
      debugPrint('Kicked ${spaceMember.id}');
    } catch (e) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e);
    }
  }

  //function for adding single student and haandling error
  Future<void> _inviteSpaceMember(User spaceMember) async {
    try {
      await room!.invite(spaceMember.id);
      debugPrint('added ${spaceMember.id}');
    } catch (e) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e);
    }
  }

  //remove single class
  Future<void> _removeSingleSpaceFromParents(
    String roomToRemoveId,
    Room spaceToRemove,
  ) async {
    GoogleAnalytics.removeChatFromClass(
      roomToRemoveId,
      spaceToRemove.classCode,
    );

    if (room == null) {
      ErrorHandler.logError(m: 'Room is null in kickSpaceMembers');
      debugger(when: kDebugMode);
      return;
    }
    final List<List<User>> roomsMembers = await Future.wait([
      room!.requestParticipants(),
      spaceToRemove.requestParticipants(),
    ]);

    final List<User> toKick = roomsMembers[1]
        .where(
          (element) =>
              element.id != room!.client.userID &&
              roomsMembers[0].any((m) => m.id == element.id),
        )
        .toList();

    final List<Future<void>> kickFutures = [
      spaceToRemove.removeSpaceChild(roomToRemoveId),
    ];
    for (final spaceMember in toKick) {
      kickFutures.add(_kickSpaceMember(spaceMember));
    }
    await Future.wait(kickFutures);

    // if (widget.setParentState != null) {
    //   widget.setParentState!();
    // }
    await room!.requestParticipants();

    GoogleAnalytics.kickClassFromExchange(room!.id, spaceToRemove.id);
    return;
  }

  // ignore: curly_braces_in_flow_control_structures
  Future<void> _handleAdd(bool add, Room possibleParent) async {
    //in this case, the room has already been made so we handle adding as it happens
    if (room != null) {
      await showFutureLoadingDialog(
        context: context,
        future: () async {
          await (add
              ? _addSingleParent(room!.id, possibleParent)
              : _removeSingleSpaceFromParents(room!.id, possibleParent));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                add
                    ? L10n.of(context)!.youAddedToSpace(
                        room!.name,
                        possibleParent.name,
                      )
                    : L10n.of(context)!.youRemovedFromSpace(
                        room!.name,
                        possibleParent.name,
                      ),
              ),
            ),
          );
        },
      );
    }
    setState(
      () => add
          ? parents.add(possibleParent)
          : parents.removeWhere((r) => r.id == possibleParent.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.startOpen)
          ListTile(
            enableFeedback: !widget.startOpen,
            title: Text(
              widget.mode == AddToClassMode.exchange
                  ? L10n.of(context)!.addToClass
                  : L10n.of(context)!.addToClassOrExchange,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
              child: const Icon(
                Icons.workspaces_outline,
              ),
            ),
            trailing: !widget.startOpen
                ? Icon(
                    isOpen
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.keyboard_arrow_right_outlined,
                  )
                : null,
            onTap: () => setState(() => isOpen = !isOpen),
          ),
        if (isOpen)
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
            child: Column(
              children: [
                if (possibleParents.isEmpty)
                  ListTile(
                    title: Text(L10n.of(context)!.noEligibleSpaces),
                  ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: possibleParents.length,
                  itemBuilder: (BuildContext context, int i) {
                    final bool canIAddSpaceChildren =
                        possibleParents[i].canIAddSpaceChild(room) &&
                            (room?.canIAddSpaceParents ?? true);
                    return Column(
                      children: [
                        Opacity(
                          opacity: canIAddSpaceChildren ? 1 : 0.5,
                          child: SwitchListTile.adaptive(
                            title: possibleParents[i].nameAndRoomTypeIcon(),
                            activeColor: AppConfig.activeToggleColor,
                            value: parents
                                .any((r) => r.id == possibleParents[i].id),
                            onChanged: (bool add) => canIAddSpaceChildren
                                ? _handleAdd(add, possibleParents[i])
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text(L10n.of(context)!.noPermission),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
