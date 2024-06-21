import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

// To view other catch-related errors
void showCatchErrorDialog(BuildContext context, Object e) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            L10n.of(context)!.err_,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(L10n.of(context)!.errDesc),
              const SizedBox(height: 8.0),
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
  });
}
