import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/stream_extension.dart';

class KnockingUsersIndicator extends StatefulWidget {
  final Room room;
  const KnockingUsersIndicator({
    super.key,
    required this.room,
  });

  @override
  KnockingUsersIndicatorState createState() => KnockingUsersIndicatorState();
}

class KnockingUsersIndicatorState extends State<KnockingUsersIndicator> {
  List<User> _knockingUsers = [];
  StreamSubscription? _memberSubscription;

  KnockingUsersIndicatorState();

  @override
  void initState() {
    super.initState();
    _memberSubscription ??= widget.room.client.onRoomState.stream
        .where(_isMemberUpdate)
        .rateLimit(const Duration(seconds: 1))
        .listen((_) => _setKnockingUsers());

    widget.room.requestParticipants(
      [Membership.join, Membership.invite, Membership.knock],
      false,
      true,
    ).then((_) => _setKnockingUsers());
  }

  bool _isMemberUpdate(({String roomId, StrippedStateEvent state}) event) =>
      event.roomId == widget.room.id &&
      event.state.type == EventTypes.RoomMember;

  @override
  void dispose() {
    _memberSubscription?.cancel();
    super.dispose();
  }

  void _setKnockingUsers() {
    if (mounted) {
      setState(() {
        _knockingUsers = widget.room.getParticipants([Membership.knock]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: FluffyThemes.animationDuration,
      child: _knockingUsers.isEmpty || !widget.room.isRoomAdmin
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 1,
              ),
              child: Material(
                borderRadius: BorderRadius.circular(
                  AppConfig.borderRadius,
                ),
                clipBehavior: Clip.hardEdge,
                child: ListTile(
                  minVerticalPadding: 0,
                  trailing: Icon(
                    Icons.adaptive.arrow_forward_outlined,
                    size: 16,
                  ),
                  title: Row(
                    spacing: 8.0,
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      Expanded(
                        child: Text(
                          _knockingUsers.length == 1
                              ? L10n.of(context).aUserIsKnocking
                              : L10n.of(context)
                                  .usersAreKnocking(_knockingUsers.length),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  onTap: () => context.push(
                    "/rooms/spaces/${widget.room.id}/details/members?filter=knock",
                  ),
                ),
              ),
            ),
    );
  }
}
