import 'dart:async';

import 'package:flutter/material.dart';

/// this is a workaround to allow navigation of spaces out from any widget.
/// Reason is that we have no reliable way to listen on *query* changes of
/// VRouter.
///
/// Time wasted: 3h
abstract class SpaceNavigator {
  const SpaceNavigator._();

  // TODO(TheOneWithTheBraid): adjust routing table in order to represent spaces
  // ... in any present path
  static final routeObserver = RouteObserver();

  static final StreamController<String?> _controller =
      StreamController.broadcast();

  static Stream<String?> get stream => _controller.stream;

  static void navigateToSpace(String? spaceId) => _controller.add(spaceId);
}
