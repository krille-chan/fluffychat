import 'dart:async';

import 'package:fluffychat/pages/add_bridge/service/bot_bridge_connection.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'error_message_dialog.dart';
import 'model/social_network.dart';

// Creation of a FormKey for entering identifiers for Connection ShowDialog
GlobalKey<FormState> formKey = GlobalKey<FormState>();

// ShowDialog for Instagram connection
Future<bool> connectToInstagram(BuildContext context, SocialNetwork network,
    BotBridgeConnection botConnection) async {
  String? username;
  String? password;

  final Completer<bool> completer = Completer<bool>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: Text(
              "${L10n.of(context)!.connectYourSocialAccount} ${network.name}",
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                // color: Color(0xFFFAAB22),
              ),
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(L10n.of(context)!.enterYourDetails),
                  const SizedBox(height: 5),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: L10n.of(context)!.username),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return L10n.of(context)!.pleaseEnterYourUsername;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      username =
                          value; // Saves the value in the username variable
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: L10n.of(context)!.password),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return L10n.of(context)!.pleaseEnterPassword;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password =
                          value; // Saves the value in the password variable
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  completer.complete(false);
                },
                child: Text(L10n.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save(); // Save form values

                    try {
                      String result =
                          ""; // Variable to store the result of the connection

                      // To show Loading while executing the function
                      await showFutureLoadingDialog(
                        context: context,
                        future: () async {
                          if (network.name == "Instagram") {
                            result = await botConnection.createBridgeInstagram(
                                username!, password!);
                          }
                        },
                      );

                      if (result == "success") {
                        Navigator.of(context).pop();
                        completer.complete(
                            true); // returns True if the connection is successful
                      } else if (result == "errorUsername") {
                        // Display a showDialog with an error message related to the identifier
                        showErrorUsernameDialog(context);
                      } else if (result == "errorPassword") {
                        // Display a showDialog with an error message related to the password
                        showErrorPasswordDialog(context);
                      } else if (result == "rateLimitError") {
                        // Display a showDialog with an error message related to the rate limit
                        showRateLimitDialog(context);
                      }
                    } catch (e) {
                      Navigator.of(context).pop();
                      //To view other catch-related errors
                      showCatchErrorDialog(context, e);
                    }
                  }
                },
                child: Text(
                  L10n.of(context)!.login,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  return completer.future;
}
