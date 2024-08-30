import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../enum/message_mode_enum.dart';

class MessageUnsubscribedCard extends StatelessWidget {
  final String languageTool;
  final MessageMode mode;
  final MessageToolbarState controller;

  const MessageUnsubscribedCard({
    super.key,
    required this.languageTool,
    required this.mode,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool inTrialWindow =
        MatrixState.pangeaController.userController.inTrialWindow;

    void onButtonPress() {
      if (inTrialWindow) {
        MatrixState.pangeaController.subscriptionController
            .activateNewUserTrial();
        controller.updateMode(mode);
      } else {
        MatrixState.pangeaController.subscriptionController
            .showPaywall(context);
      }
    }

    return Column(
      children: [
        Text(
          style: BotStyle.text(context),
          "${L10n.of(context)!.subscribedToUnlockTools} $languageTool",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onButtonPress,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                (AppConfig.primaryColor).withOpacity(0.1),
              ),
            ),
            child: Text(
              inTrialWindow
                  ? L10n.of(context)!.activateTrial
                  : L10n.of(context)!.getAccess,
            ),
          ),
        ),
      ],
    );
  }
}
