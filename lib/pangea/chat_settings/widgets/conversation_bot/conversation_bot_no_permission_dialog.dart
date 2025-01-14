import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

Future<void> showNoPermissionDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(L10n.of(context).botConfigNoPermissionTitle),
        content: Text(L10n.of(context).botConfigNoPermissionMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(L10n.of(context).ok),
          ),
        ],
      );
    },
  );
}
