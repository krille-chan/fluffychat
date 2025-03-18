import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/stream_extension.dart';
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

  final TextEditingController filterController = TextEditingController();

  // #Pangea
  StreamSubscription? _subscription;
  // Pangea#

  void setFilter([_]) async {
    final filter = filterController.text.toLowerCase().trim();

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

  void refreshMembers() async {
    try {
      setState(() {
        error = null;
      });
      final participants = await Matrix.of(context)
          .client
          .getRoomById(widget.roomId)
          ?.requestParticipants(
        // #Pangea
        // without setting cache to true, each call to requestParticipants will
        // result in a new entry in the roomState stream, because the member roomState is not
        // stored in the database. This causes an infinite loop with the roomState listener.
        [Membership.join, Membership.invite, Membership.knock],
        false,
        true,
        // Pangea#
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

  @override
  void initState() {
    super.initState();
    refreshMembers();
    // #Pangea
    _subscription = Matrix.of(context)
        .client
        .onRoomState
        .stream
        .where((update) => update.roomId == widget.roomId)
        .rateLimit(const Duration(seconds: 1))
        .listen((_) => refreshMembers());
    // Pangea#
  }

  // #Pangea
  @override
  void dispose() {
    _subscription?.cancel();
    filterController.dispose();
    super.dispose();
  }
  // Pangea#

  @override
  Widget build(BuildContext context) => ChatMembersView(this);
}
