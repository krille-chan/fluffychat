import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/widgets/matrix.dart';
import '../common/controllers/pangea_controller.dart';

class PAuthGaurd {
  static bool isPublicLeaving = false;
  static PangeaController? pController;

  /// Redirect for /home routes
  static FutureOr<String?> loggedInRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (pController == null) {
      return Matrix.of(context).client.isLogged() ? '/rooms' : null;
    }

    final isLogged =
        Matrix.of(context).widget.clients.any((client) => client.isLogged());
    if (!isLogged) return null;

    return _onboardingRedirect(context, state);
  }

  /// Redirect for onboarding and /rooms routes
  static FutureOr<String?> loggedOutRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (pController == null) {
      return Matrix.of(context).client.isLogged() ? null : '/home';
    }

    final isLogged =
        Matrix.of(context).widget.clients.any((client) => client.isLogged());
    if (!isLogged) {
      return '/home';
    }

    return _onboardingRedirect(context, state);
  }

  static Future<String?> _onboardingRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    // If user hasn't set their L2,
    // and their URL doesn’t include ‘course,’ redirect
    final bool hasSetL2 = await pController!.userController.isUserL2Set;
    final bool shouldRedirect =
        !hasSetL2 && !(state.fullPath?.contains('course') ?? false);

    final langCode = state.pathParameters['langcode'];
    return shouldRedirect
        ? langCode != null
            ? '/course/$langCode'
            : '/course'
        : null;
  }
}
