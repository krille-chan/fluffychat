import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

void setClassTopic(Room room, BuildContext context) {
  final TextEditingController textFieldController =
      TextEditingController(text: room.topic);
  showDialog(
    context: context,
    useRootNavigator: false,
    builder: (BuildContext context) => AlertDialog(
      title: Text(
        room.isSpace
            ? L10n.of(context)!.classDescription
            : L10n.of(context)!.chatTopic,
      ),
      content: TextField(
        controller: textFieldController,
      ),
      actions: [
        TextButton(
          child: Text(L10n.of(context)!.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(L10n.of(context)!.ok),
          onPressed: () async {
            if (textFieldController.text == "") return;
            final success = await showFutureLoadingDialog(
              context: context,
              future: () => room.setDescription(textFieldController.text),
            );
            if (success.error == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(L10n.of(context)!.groupDescriptionHasBeenChanged),
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
