import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

void showCatchSuccessDialog(BuildContext context, Object e) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          L10n.of(context)!.wellDone,
          style: const TextStyle(
            color: Colors.green,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e.toString()),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              L10n.of(context)!.ok,
            ),
          ),
        ],
      );
    },
  );
}
