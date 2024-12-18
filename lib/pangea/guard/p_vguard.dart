import 'dart:async';

import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/pangea_controller.dart';

class PAuthGaurd {
  static bool isPublicLeaving = false;
  static PangeaController? pController;

  static FutureOr<String?> loggedInRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (pController != null) {
      if (Matrix.of(context).client.isLogged()) {
        final bool dobIsSet =
            await pController!.userController.isUserDataAvailableAndL2Set;
        return dobIsSet ? '/rooms' : '/user_age';
      }
      return null;
    } else {
      debugPrint("controller is null in pguard check");
      Matrix.of(context).client.isLogged() ? '/rooms' : null;
    }
    return null;
  }

  static FutureOr<String?> loggedOutRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (pController != null) {
      if (!Matrix.of(context).client.isLogged()) {
        return '/home';
      }
      final bool dobIsSet =
          await pController!.userController.isUserDataAvailableAndL2Set;
      return dobIsSet ? null : '/user_age';
    } else {
      debugPrint("controller is null in pguard check");
      return Matrix.of(context).client.isLogged() ? null : '/home';
    }
  }

  // static const defaultRoute = '/home';

  // static Future<void> onPublicEnter() async {
  // final bool setDob =
  //     await pController!.userController.isUserDataAvailableAndDateOfBirthSet;
  //   if (_isLogged != null && _isLogged! && setDob) {
  //     vRedirector.to('/rooms');
  //   }
  // }

  // static Future<void> onPublicUpdate(VRedirector vRedirector) async {
  //   final bool setDob =
  //       await pController!.userController.isUserDataAvailableAndDateOfBirthSet;
  //   if (_isLogged != null && _isLogged! && setDob) {
  //     vRedirector.to('/rooms');
  //   }
  //   bool oldHaveParms = false;

  //   final bool haveData = vRedirector.previousVRouterData != null;
  //   if (haveData) {
  //     final bool isPublicRoute =
  //         vRedirector.newVRouterData!.url!.startsWith(defaultRoute);
  //     if (!isPublicRoute) {
  //       return;
  //     }
  //     oldHaveParms =
  //         vRedirector.previousVRouterData!.queryParameters.isNotEmpty;
  //     if (oldHaveParms) {
  //       if (vRedirector.newVRouterData!.queryParameters.isEmpty) {
  //         vRedirector.to(
  //           vRedirector.toUrl!,
  //           queryParameters: vRedirector.previousVRouterData!.queryParameters,
  //         );
  //       }
  //     }
  //   }

  //   return;
  // }

  // static Future<void> onPublicLeave(
  //   VRedirector vRedirector,
  //   Function(Map<String, String> onLeave) callback,
  // ) async {
  //   final bool haveData = vRedirector.previousVRouterData != null;

  //   if (haveData) {
  //     try {
  //       if (vRedirector.previousVRouterData!.queryParameters['redirect'] ==
  //           'true') {
  //         if (!isPublicLeaving) {
  //           isPublicLeaving = true;
  //           vRedirector.to(
  //             vRedirector.previousVRouterData!.queryParameters['redirectPath']!,
  //           );
  //         }
  //       }
  //     } catch (e, s) {
  //       ErrorHandler.logError(e: e, s: s);
  //     }
  //   }
  //   return;
  // }

  // static Future<void> onPrivateUpdate(VRedirector vRedirector) async {
  //   if (_isLogged == null) {
  //     return;
  //   }
  //   final Map<String, String> redirectParm = {};
  //   final bool haveData = vRedirector.newVRouterData != null;
  //   if (haveData) {
  //     if (vRedirector.newVRouterData!.queryParameters.isNotEmpty) {
  //       redirectParm['redirect'] = 'true';
  //       redirectParm['redirectPath'] = vRedirector.newVRouterData!.url!;
  //     }
  //   }
  //   if (!_isLogged!) {
  //     debugPrint("onPrivateUpdate with user not logged in");
  //     ErrorHandler.logError(
  //       e: Exception("onPrivateUpdate with user not logged in"),
  //       s: StackTrace.current,
  //     );
  //     // vRedirector.to(defaultRoute, queryParameters: redirectParm);
  //   } else {
  //     if (pController != null) {
  //       if (!await pController!
  //           .userController.isUserDataAvailableAndDateOfBirthSet) {
  //         debugPrint("reroute to user_age");
  //         vRedirector.to(
  //           '/home/connect/user_age',
  //           queryParameters: redirectParm,
  //         );
  //       }
  // } else {
  //   debugPrint("controller is null in pguard check");
  // }
  //   }

  //   isPublicLeaving = false;
  //   return;
  // }
}
