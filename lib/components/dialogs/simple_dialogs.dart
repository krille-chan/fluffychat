import 'package:fluffychat/i18n/i18n.dart';
import 'package:flutter/material.dart';

class SimpleDialogs {
  final BuildContext context;

  const SimpleDialogs(this.context);

  Future<String> enterText({
    String titleText,
    String confirmText,
    String cancelText,
    String hintText,
    String labelText,
    bool multiLine = false,
  }) async {
    final TextEditingController controller = TextEditingController();
    String input;
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(I18n.of(context).enterAUsername ?? titleText),
        content: TextField(
          controller: controller,
          autofocus: true,
          onSubmitted: (s) {
            input = s;
            Navigator.of(context).pop();
          },
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            border: OutlineInputBorder(),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(cancelText ?? I18n.of(context).close.toUpperCase(),
                style: TextStyle(color: Colors.blueGrey)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text(
              confirmText ?? I18n.of(context).confirm.toUpperCase(),
            ),
            onPressed: () {
              input = controller.text;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
    return input;
  }

  Future<bool> askConfirmation({
    String titleText,
    String confirmText,
    String cancelText,
  }) async {
    bool confirmed = false;
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(I18n.of(context).areYouSure ?? titleText),
        actions: <Widget>[
          FlatButton(
            child: Text(cancelText ?? I18n.of(context).close.toUpperCase(),
                style: TextStyle(color: Colors.blueGrey)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text(
              confirmText ?? I18n.of(context).confirm.toUpperCase(),
            ),
            onPressed: () {
              confirmed = true;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
    return confirmed;
  }
}
