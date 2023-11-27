// Creation of a FormKey for entering identifiers for Connection ShowDialog
import 'dart:async';

import 'package:fluffychat/pages/add_bridge/service/bot_bridge_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

import 'error_message_dialog.dart';
import 'model/social_network.dart';

GlobalKey<FormState> formKey = GlobalKey<FormState>();

// ShowDialog for double-factor code (can be used for each social network)
Future<bool> twoFactorDemandCode(
  BuildContext context,
  SocialNetwork network,
  BotBridgeConnection botConnection,
) async {
  String? code;

  final Completer<bool> completer = Completer<bool>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: Text(
              L10n.of(context)!.twoFactor_title,
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
                  Text(
                    L10n.of(context)!.twoFactor_content,
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    // decoration:
                    // InputDecoration(labelText: 'code'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return L10n.of(context)!.err_emptyField;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      code = value; // Saves the value in the username variable
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
                          //Send the code by message to the bots
                          result = await botConnection.sendMessageToBot(
                            network.chatBot,
                            code!,
                          );
                        },
                      );

                      // Retrieves the answer to the code according to the social network
                      switch (network.name) {
                        case "Instagram":
                          final successfullyMatch =
                              RegExp(r"Successfully logged in");
                          final invalidMatch = RegExp(r"Invalid");
                          final RegExp alreadySuccessMatch =
                              RegExp(r"You're already logged in");
                          if (successfullyMatch.hasMatch(result) ||
                              alreadySuccessMatch.hasMatch(result) &&
                                  !invalidMatch.hasMatch(result)) {
                            Navigator.of(context).pop();
                            print('connected to Instagram');
                            completer.complete(
                              true,
                            ); // returns True if the connection is successful
                          } else if (invalidMatch.hasMatch(result)) {
                            showCatchErrorDialog(context,
                                "Erreur, veuillez rentrer un nouveau code");
                            result = "";
                          } else {
                            showCatchErrorDialog(
                              context,
                              L10n.of(context)!.err_timeOut,
                            );
                            result = "";
                          }
                          break;
                        // For other networks
                      }
                    } catch (e) {
                      Navigator.of(context).pop();
                      //To view other catch-related errors
                      showCatchErrorDialog(context, L10n.of(context)!.tryAgain);
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
