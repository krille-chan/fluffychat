import 'package:fluffychat/i18n/i18n.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(
    this.text,
    this.confirmText,
    this.onConfirmed,
  );
  final String text;
  final String confirmText;
  final Function(BuildContext) onConfirmed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(text),
      actions: <Widget>[
        FlatButton(
          child: Text(I18n.of(context).close.toUpperCase(),
              style: TextStyle(color: Colors.blueGrey)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text(
            confirmText.toUpperCase(),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmed(context);
          },
        ),
      ],
    );
  }
}
