import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import '../../widgets/matrix.dart';
import 'chat_members_view.dart';

class ChatMembersPage extends StatefulWidget {
  final String roomId;

  const ChatMembersPage({required this.roomId, super.key});

  @override
  State<ChatMembersPage> createState() => ChatMembersController();
}

class ChatMembersController extends State<ChatMembersPage> {
  List<User>? members;
  List<User>? filteredMembers;
  Object? error;
  Membership membershipFilter = Membership.join;

  final TextEditingController filterController = TextEditingController();

  void setMembershipFilter(Membership membership) {
    membershipFilter = membership;
    setFilter();
  }

  void setFilter([_]) async {
    final filter = filterController.text.toLowerCase().trim();

    final members = this
        .members
        ?.where((member) => member.membership == membershipFilter)
        .toList();

    if (filter.isEmpty) {
      setState(() {
        filteredMembers = members
          ?..sort((b, a) => a.powerLevel.compareTo(b.powerLevel));
      });
      return;
    }
    setState(() {
      filteredMembers = members
          ?.where(
            (user) =>
                user.displayName?.toLowerCase().contains(filter) ??
                user.id.toLowerCase().contains(filter),
          )
          .toList()
        ?..sort((b, a) => a.powerLevel.compareTo(b.powerLevel));
    });
  }

  void refreshMembers([_]) async {
    Logs().d('Load room members from', widget.roomId);
    try {
      setState(() {
        error = null;
      });
      final participants = await Matrix.of(context)
          .client
          .getRoomById(widget.roomId)
          ?.requestParticipants(
            [...Membership.values]..remove(Membership.leave),
          );

      if (!mounted) return;

      setState(() {
        members = participants;
      });
      setFilter();
    } catch (e, s) {
      Logs()
          .d('Unable to request participants. Try again in 3 seconds...', e, s);
      setState(() {
        error = e;
      });
    }
  }

  StreamSubscription? _updateSub;

  @override
  void initState() {
    super.initState();
    refreshMembers();

    _updateSub = Matrix.of(context)
        .client
        .onSync
        .stream
        .where(
          (syncUpdate) =>
              syncUpdate.rooms?.join?[widget.roomId]?.timeline?.events
                  ?.any((state) => state.type == EventTypes.RoomMember) ??
              false,
        )
        .listen(refreshMembers);
  }

  @override
  void dispose() {
    _updateSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChatMembersView(this);
}
