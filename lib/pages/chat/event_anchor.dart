// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/widgets.dart';

/// Registers the [BuildContext] of a timeline item under its event ID, so the
/// chat can look up which events are currently on screen.
class EventAnchor extends StatefulWidget {
  final Map<String, BuildContext> registry;
  final String eventId;
  final Widget child;

  const EventAnchor({
    super.key,
    required this.registry,
    required this.eventId,
    required this.child,
  });

  @override
  State<EventAnchor> createState() => _EventAnchorState();
}

class _EventAnchorState extends State<EventAnchor> {
  @override
  void initState() {
    super.initState();
    widget.registry[widget.eventId] = context;
  }

  @override
  void didUpdateWidget(EventAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.eventId != widget.eventId ||
        oldWidget.registry != widget.registry) {
      if (oldWidget.registry[oldWidget.eventId] == context) {
        oldWidget.registry.remove(oldWidget.eventId);
      }
      widget.registry[widget.eventId] = context;
    }
  }

  @override
  void dispose() {
    if (widget.registry[widget.eventId] == context) {
      widget.registry.remove(widget.eventId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
