// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

void showEditFieldDialog(BuildContext context, String title) async {
  // final room = Matrix.of(context).client.getRoomById(roomId!)!;
  final input = await showTextInputDialog(
    useRootNavigator: false,
    context: context,
    title: title,
    okLabel: L10n.of(context)!.ok,
    cancelLabel: L10n.of(context)!.cancel,
    textFields: [
      DialogTextField(
        hintText: title,
        //  initialText: room.topic,
        minLines: 1,
        maxLines: 4,
      )
    ],
  );
  if (input == null) return;
  final success = await showFutureLoadingDialog(
    context: context,
    // TODO change this later
    future: () async => null,
  );
  if (success.error == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(L10n.of(context)!.groupDescriptionHasBeenChanged)));
  }
}
