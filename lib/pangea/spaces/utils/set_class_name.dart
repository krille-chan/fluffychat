import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../../utils/matrix_sdk_extensions/matrix_locals.dart';

void setClassDisplayname(BuildContext context, String? roomId) async {
  if (roomId == null) return;
  final room = Matrix.of(context).client.getRoomById(roomId);
  if (room == null) return;
  final TextEditingController textFieldController = TextEditingController(
    text: room.getLocalizedDisplayname(
      MatrixLocals(
        L10n.of(context),
      ),
    ),
  );

  showDialog(
    context: context,
    useRootNavigator: false,
    builder: (BuildContext context) => AlertDialog(
      title: Text(
        room.isSpace
            ? L10n.of(context).changeTheNameOfTheClass
            : L10n.of(context).changeTheNameOfTheChat,
      ),
      content: TextField(
        maxLength: 64,
        controller: textFieldController,
      ),
      actions: [
        TextButton(
          child: Text(L10n.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(L10n.of(context).ok),
          onPressed: () async {
            if (textFieldController.text == "") return;
            final success = await showFutureLoadingDialog(
              context: context,
              future: () => room.setName(textFieldController.text),
            );
            if (success.error == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(L10n.of(context).displaynameHasBeenChanged),
                ),
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    ),
  );
}
