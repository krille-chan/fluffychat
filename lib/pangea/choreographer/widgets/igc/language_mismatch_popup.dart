import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/utils/bot_style.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';
import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/card_header.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LanguageMismatchPopup extends StatelessWidget {
  final String targetLanguage;
  final Choreographer choreographer;
  final VoidCallback onUpdate;

  const LanguageMismatchPopup({
    super.key,
    required this.targetLanguage,
    required this.choreographer,
    required this.onUpdate,
  });

  Future<void> _onConfirm(BuildContext context) async {
    await MatrixState.pangeaController.userController.updateProfile(
      (profile) {
        profile.userSettings.targetLanguage = targetLanguage;
        return profile;
      },
      waitForDataInSync: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CardHeader(
          text: L10n.of(context).languageMismatchTitle,
          botExpression: BotExpression.addled,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            spacing: 12.0,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                L10n.of(context).languageMismatchDesc,
                style: BotStyle.text(context),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    await showFutureLoadingDialog(
                      context: context,
                      future: () => _onConfirm(context),
                    );
                    MatrixState.pAnyState.closeOverlay();
                    onUpdate();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      (Theme.of(context).colorScheme.primary).withAlpha(25),
                    ),
                  ),
                  child: Text(L10n.of(context).confirm),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
