import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
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
    _setKnockingUsers();
  }

  bool _isMemberUpdate(({String roomId, StrippedStateEvent state}) event) =>
      event.roomId == widget.room.id &&
      event.state.type == EventTypes.RoomMember;

  @override
  void dispose() {
    _memberSubscription?.cancel();
    super.dispose();
  }

  Future<void> _setKnockingUsers({bool loadParticipants = false}) async {
    _knockingUsers = loadParticipants
        ? await widget.room.requestParticipants([Membership.knock])
        : widget.room.getParticipants([Membership.knock]);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: 1,
      itemBuilder: (context, i) {
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
                                  ? "1 user is requesting to join your space"
                                  : "${_knockingUsers.length} users are requesting to join your space",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => context.push(
                        "/rooms/${widget.room.id}/details/members",
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
