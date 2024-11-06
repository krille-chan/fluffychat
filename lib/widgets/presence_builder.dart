import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/matrix.dart';

class PresenceBuilder extends StatefulWidget {
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
  State<PresenceBuilder> createState() => _PresenceBuilderState();
}

class _PresenceBuilderState extends State<PresenceBuilder> {
  CachedPresence? _presence;
  StreamSubscription<CachedPresence>? _sub;

  @override
  void initState() {
    final client = widget.client ?? Matrix.of(context).client;
    final userId = widget.userId;
    if (userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final presence = await client.fetchCurrentPresence(userId);
        setState(() {
          _presence = presence;
          _sub = client.onPresenceChanged.stream.listen((presence) {
            if (!mounted) return;
            setState(() {
              _presence = presence;
            });
          });
        });
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _presence);
}
