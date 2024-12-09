import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import '../controllers/pangea_controller.dart';

void findConversationPartnerDialog(
  BuildContext context,
  PangeaController pangeaController,
) {
  debugPrint(pangeaController.userController.isPublic.toString());
  if (pangeaController.userController.isPublic) {
    context.go('/rooms/partner');
  } else {
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context).setToPublicSettingsTitle),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Text(L10n.of(context).setToPublicSettingsDesc),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(L10n.of(context).cancel),
          ),
        ],
      ),
    );
  }
}
