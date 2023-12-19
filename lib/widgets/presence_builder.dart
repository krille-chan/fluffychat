import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/matrix.dart';

class PresenceBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, CachedPresence? presence) builder;
  final String? userId;
  final Client? client;

  const PresenceBuilder({
    required this.builder,
    this.userId,
    this.client,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userId = this.userId;
    if (userId == null) return builder(context, null);

    final client = this.client ?? Matrix.of(context).client;
    return FutureBuilder<CachedPresence>(
      future: client.fetchCurrentPresence(userId),
      builder: (context, cachedPresenceSnapshot) => StreamBuilder(
        stream: client.onPresenceChanged.stream
            .where((cachedPresence) => cachedPresence.userid == userId),
        builder: (context, snapshot) => builder(
          context,
          snapshot.data ?? cachedPresenceSnapshot.data,
        ),
      ),
    );
  }
}
