import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

// Display a showDialog with an error message related to the identifier
void showErrorUsernameDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
          L10n.of(context)!.usernameNotFound,
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

// Display a showDialog with an error message related to the password
void showErrorPasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
          L10n.of(context)!.passwordIncorrect,
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

// Display a showDialog with an error message related to the rate limit
void showRateLimitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
          L10n.of(context)!.rateLimit,
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

// To view other catch-related errors
void showCatchErrorDialog(BuildContext context, Object e) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          L10n.of(context)!.err_,
        ),
        content: Text('${L10n.of(context)!.err_desc} $e'),
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
