import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/widgets/matrix.dart';
import '../common/controllers/pangea_controller.dart';

class PAuthGaurd {
  static bool isPublicLeaving = false;
  static PangeaController? pController;

  /// Redirect for /home routes
  static FutureOr<String?> homeRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (pController == null) {
      return Matrix.of(context).client.isLogged() ? '/rooms' : null;
    }

    final isLogged =
        Matrix.of(context).widget.clients.any((client) => client.isLogged());
    if (!isLogged) return null;

    // If user hasn't set their L2,
    // and their URL doesn’t include ‘course,’ redirect
    final bool hasSetL2 = await pController!.userController.isUserL2Set;
    final langCode = state.pathParameters['langcode'];
    return !hasSetL2
        ? langCode != null
            ? '/registration/$langCode'
            : '/registration'
        : '/rooms';
  }

  /// Redirect for /rooms routes
  static FutureOr<String?> roomsRedirect(
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

    // If user hasn't set their L2,
    // and their URL doesn’t include ‘course,’ redirect
    final bool hasSetL2 = await pController!.userController.isUserL2Set;

    final langCode = state.pathParameters['langcode'];
    return !hasSetL2
        ? langCode != null
            ? '/registration/$langCode'
            : '/registration'
        : null;
  }

  /// Redirect for onboarding routes
  static FutureOr<String?> onboardingRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (pController == null) {
      return Matrix.of(context).client.isLogged() ? null : '/home';
    }

    final isLogged = Matrix.of(context).widget.clients.any(
          (client) => client.isLogged(),
        );
    if (!isLogged) {
      return '/home';
    }

    return null;
  }
}
