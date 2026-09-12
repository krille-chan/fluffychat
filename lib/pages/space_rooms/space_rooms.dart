// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'space_rooms_view.dart';

enum SpaceChildAction {
  mute,
  unmute,
  markAsUnread,
  markAsRead,
  removeFromSpace,
  leave,
}

class SpaceRoomsPage extends StatefulWidget {
  final String spaceId;

  const SpaceRoomsPage({required this.spaceId, super.key});

  @override
  State<SpaceRoomsPage> createState() => SpaceRoomsController();
}

class SpaceRoomsController extends State<SpaceRoomsPage> {
  final List<SpaceRoomsChunk$2> discoveredChildren = [];
  List<SpaceRoomsChunk$2> visibleChildren = [];
  final TextEditingController filterController = TextEditingController();
  String? _nextBatch;
  String? spaceId;
  bool noMoreRooms = false;
  bool isLoading = false;

  StreamSubscription? childStateSub;

  @override
  void initState() {
    spaceId = widget.spaceId;
    loadHierarchy();
    childStateSub = Matrix.of(context).client.onSync.stream
        .where(
          (syncUpdate) =>
              syncUpdate.rooms?.join?[widget.spaceId]?.timeline?.events?.any(
                (event) => event.type == EventTypes.SpaceChild,
              ) ??
              false,
        )
        .listen(loadHierarchy);
    super.initState();
  }

  @override
  void dispose() {
    childStateSub?.cancel();
    super.dispose();
  }

  Future<void> onChatTap(Room room) async {
    final l10n = L10n.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (room.membership == Membership.invite) {
      final joinResult = await showFutureLoadingDialog(
        context: context,
        future: () async {
          final waitForRoom = room.client.waitForRoomInSync(
            room.id,
            join: true,
          );
          await room.join();
          await waitForRoom;
        },
        exceptionContext: ExceptionContext.joinRoom,
      );
      if (joinResult.error != null) return;
    }
    if (!mounted) return;

    if (room.membership == Membership.ban) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.youHaveBeenBannedFromThisChat)),
      );
      return;
    }

    if (room.membership == Membership.leave) {
      context.go('/rooms/archive/${room.id}');
      return;
    }

    context.go('/rooms/${room.id}');
  }

  Future<void> loadHierarchy([_]) async {
    final matrix = Matrix.of(context);
    final room = matrix.client.getRoomById(widget.spaceId);
    if (room == null) return;

    final cacheKey = 'spaces_history_cache${room.id}';
    if (discoveredChildren.isEmpty) {
      final cachedChildren = matrix.store.getStringList(cacheKey);
      if (cachedChildren != null) {
        try {
          discoveredChildren.addAll(
            cachedChildren.map(
              (jsonString) =>
                  SpaceRoomsChunk$2.fromJson(jsonDecode(jsonString)),
            ),
          );
        } catch (e, s) {
          Logs().e('Unable to json decode spaces hierarchy cache!', e, s);
          matrix.store.remove(cacheKey);
        }
      }
    }

    setState(() {
      isLoading = true;
    });

    try {
      final hierarchy = await room.client.getSpaceHierarchy(
        widget.spaceId,
        suggestedOnly: false,
        maxDepth: 2,
        from: _nextBatch,
      );
      if (!mounted) return;
      setState(() {
        if (_nextBatch == null) discoveredChildren.clear();
        _nextBatch = hierarchy.nextBatch;
        if (hierarchy.nextBatch == null) {
          noMoreRooms = true;
        }
        discoveredChildren.addAll(
          hierarchy.rooms.where((room) => room.roomId != widget.spaceId),
        );
        isLoading = false;
      });

      if (_nextBatch == null) {
        matrix.store.setStringList(
          cacheKey,
          discoveredChildren
              .map((child) => jsonEncode(child.toJson()))
              .toList(),
        );
      }
    } catch (e, s) {
      Logs().w('Unable to load hierarchy', e, s);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toLocalizedString(context))));
      setState(() {
        isLoading = false;
      });
    }

    visibleChildren = discoveredChildren;
  }

  bool filterRoom(SpaceRoomsChunk$2 child) {
    final room = Matrix.of(context).client.getRoomById(widget.spaceId);
    final filter = filterController.text.toLowerCase();
    if (room == null) {
      return true;
    }
    final joinedRoom = room.client.getRoomById(child.roomId);
    final displayname =
        child.name ??
        child.canonicalAlias ??
        joinedRoom?.getLocalizedDisplayname() ??
        L10n.of(context).emptyChat;

    return displayname.toLowerCase().contains(filter);
  }

  void setFilter() => setState(() {
    visibleChildren = discoveredChildren.where(filterRoom).toList();
  });

  Future<void> joinChildRoom(SpaceRoomsChunk$2 item) async {
    final client = Matrix.of(context).client;
    final space = client.getRoomById(widget.spaceId);
    final via = space?.spaceChildren
        .firstWhereOrNull((child) => child.roomId == item.roomId)
        ?.via;
    final roomResult = await showFutureLoadingDialog(
      context: context,
      future: () async {
        final waitForRoom = client.waitForRoomInSync(item.roomId, join: true);
        await client.joinRoom(item.roomId, via: via);
        await waitForRoom;
        return client.getRoomById(item.roomId)!;
      },
    );
    final room = roomResult.result;
    if (room != null) onChatTap(room);
  }

  Future<void> showSpaceChildEditMenu(
    BuildContext posContext,
    String roomId,
  ) async {
    final client = Matrix.of(context).client;
    final space = client.getRoomById(widget.spaceId);
    final room = client.getRoomById(roomId);
    if (space == null) return;
    final overlay =
        Overlay.of(posContext).context.findRenderObject() as RenderBox;

    final button = posContext.findRenderObject() as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(const Offset(0, -65), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + const Offset(-50, 0),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final action = await showMenu<SpaceChildAction>(
      context: posContext,
      position: position,
      items: [
        if (room != null && room.membership == Membership.join) ...[
          PopupMenuItem(
            value: room.pushRuleState == PushRuleState.notify
                ? SpaceChildAction.mute
                : SpaceChildAction.unmute,
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(
                  room.pushRuleState == PushRuleState.notify
                      ? Icons.notifications_off_outlined
                      : Icons.notifications_on_outlined,
                ),
                const SizedBox(width: 12),
                Text(
                  room.pushRuleState == PushRuleState.notify
                      ? L10n.of(context).muteChat
                      : L10n.of(context).unmuteChat,
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: room.markedUnread
                ? SpaceChildAction.markAsRead
                : SpaceChildAction.markAsUnread,
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(
                  room.markedUnread
                      ? Icons.mark_as_unread
                      : Icons.mark_as_unread_outlined,
                ),
                const SizedBox(width: 12),
                Text(
                  room.isUnread
                      ? L10n.of(context).markAsRead
                      : L10n.of(context).markAsUnread,
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: SpaceChildAction.leave,
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(
                  Icons.delete_outlined,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 12),
                Text(
                  L10n.of(context).leave,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (space.canChangeStateEvent(EventTypes.SpaceChild) == true)
          PopupMenuItem(
            value: SpaceChildAction.removeFromSpace,
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(
                  Icons.remove,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 12),
                Text(
                  L10n.of(context).removeFromSpace,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
    if (action == null) return;
    if (!mounted) return;
    switch (action) {
      case SpaceChildAction.removeFromSpace:
        final consent = await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).removeFromSpace,
          message: L10n.of(context).removeFromSpaceDescription,
        );
        if (consent != OkCancelResult.ok) return;
        if (!mounted) return;
        final result = await showFutureLoadingDialog(
          context: context,
          future: () => space.removeSpaceChild(roomId),
        );
        if (result.isError) return;
        if (!mounted) return;
        _nextBatch = null;
        return;
      case SpaceChildAction.mute:
        await showFutureLoadingDialog(
          context: context,
          future: () => room!.setPushRuleState(PushRuleState.mentionsOnly),
        );
      case SpaceChildAction.unmute:
        await showFutureLoadingDialog(
          context: context,
          future: () => room!.setPushRuleState(PushRuleState.notify),
        );
      case SpaceChildAction.markAsUnread:
        await showFutureLoadingDialog(
          context: context,
          future: () => room!.markUnread(true),
        );
      case SpaceChildAction.markAsRead:
        await showFutureLoadingDialog(
          context: context,
          future: () => room!.markUnread(false),
        );
      case SpaceChildAction.leave:
        await showFutureLoadingDialog(
          context: context,
          future: () => room!.leave(),
        );
    }
  }

  @override
  Widget build(BuildContext context) => SpaceRoomsView(this);
}
