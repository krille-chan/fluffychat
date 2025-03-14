import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/learning_settings/pages/settings_learning.dart';

class ErrorCopy {
  final String title;
  final String? description;

  ErrorCopy(this.title, [this.description]);
}

class LanguagePermissionsButtons extends StatelessWidget {
  final String? roomID;
  final Choreographer choreographer;

  const LanguagePermissionsButtons({
    super.key,
    required this.roomID,
    required this.choreographer,
  });

  @override
  Widget build(BuildContext context) {
    if (roomID == null) return const SizedBox.shrink();
    final ErrorCopy? copy = getCopy(context);
    if (copy == null) return const SizedBox.shrink();

    final Widget text = RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: copy.title,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          if (copy.description != null)
            TextSpan(
              text: copy.description,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (c) => const SettingsLearning(),
                    barrierDismissible: false,
                  );
                },
            ),
        ],
      ),
    );

    return FloatingActionButton(
      mini: true,
      child: const Icon(Icons.history_edu_outlined),
      onPressed: () => showMessage(context, text),
    );
  }

  ErrorCopy? getCopy(BuildContext context) {
    final bool itDisabled = !choreographer.itEnabled;
    final bool igcDisabled = !choreographer.igcEnabled;
    if (roomID == null) {
      ErrorHandler.logError(
        e: Exception("Room ID is null in language permissions"),
        data: {},
      );
      return null;
    }

    if (igcDisabled && itDisabled) {
      return ErrorCopy(
        L10n.of(context).errorDisableLanguageAssistance,
        " ${L10n.of(context).errorDisableLanguageAssistanceUserDesc}",
      );
    }

    if (itDisabled) {
      return ErrorCopy(
        L10n.of(context).errorDisableIT,
        " ${L10n.of(context).errorDisableITUserDesc}",
      );
    }

    if (igcDisabled) {
      return ErrorCopy(
        L10n.of(context).errorDisableIGC,
        " ${L10n.of(context).errorDisableIGCUserDesc}",
      );
    }

    debugger(when: kDebugMode);
    ErrorHandler.logError(
      e: Exception("Unhandled case in language permissions"),
      data: {
        "roomID": roomID,
      },
    );
    return null;
  }

  void showMessage(BuildContext context, Widget text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: text,
      ),
    );
  }
}
