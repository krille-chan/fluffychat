import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:flutter/material.dart';

import '../matrix.dart';

class RedactMessageDialog extends StatelessWidget {
  final Event event;
  const RedactMessageDialog(this.event);

  void removeAction(BuildContext context) {
    Matrix.of(context).tryRequestWithLoadingDialog(event.redact());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(I18n.of(context).messageWillBeRemovedWarning),
      actions: <Widget>[
        FlatButton(
          child: Text("Close".toUpperCase(),
              style: TextStyle(color: Colors.blueGrey)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text(
            I18n.of(context).remove.toUpperCase(),
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () => removeAction(context),
        ),
      ],
    );
  }
}
