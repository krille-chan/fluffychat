// Creation of a FormKey for entering identifiers for Connection ShowDialog
import 'dart:async';

import 'package:tawkie/pages/add_bridge/service/bot_bridge_connection.dart';
import 'package:tawkie/pages/add_bridge/service/reg_exp_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

import '../../widgets/future_loading_dialog_custom.dart';
import '../../widgets/notifier_state.dart';
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

  final connectionStateModel =
      Provider.of<ConnectionStateModel>(context, listen: false);

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
                      await showCustomLoadingDialog(
                        context: context,
                        future: () async {
                          //Send the code by message to the bots
                          result = await botConnection.sendMessageToBot(context,
                              network.chatBot, code!, connectionStateModel);
                        },
                      );

                      // Retrieves the answer to the code according to the social network
                      switch (network.name) {
                        // Response for Instgram
                        case "Instagram":
                          final successfullyMatch =
                              LoginRegex.instagramSuccessMatch;
                          final invalidMatch =
                              LoginRegex.instagramIncorrectTwoFactorMatch;
                          final RegExp alreadySuccessMatch =
                              LoginRegex.instagramAlreadySuccessMatch;
                          if (successfullyMatch.hasMatch(result) ||
                              alreadySuccessMatch.hasMatch(result) &&
                                  !invalidMatch.hasMatch(result)) {
                            Logs().v('connected to Instagram');
                            Navigator.of(context).pop();
                            completer.complete(
                              true,
                            ); // returns True if the connection is successful
                          } else if (invalidMatch.hasMatch(result)) {
                            showCatchErrorDialog(context,
                                L10n.of(context)!.err_invalidTwoFactorCode);
                            result = "";
                          } else {
                            showCatchErrorDialog(
                              context,
                              L10n.of(context)!.err_timeOut,
                            );
                            result = "";
                          }
                          break;

                        // Response for Facebook Messenger
                        case "Facebook Messenger":
                          final successfullyMatch =
                              LoginRegex.facebookSuccessMatch;
                          final invalidMatch =
                              LoginRegex.facebookIncorrectTwoFactorMatch;
                          final RegExp alreadySuccessMatch =
                              LoginRegex.facebookAlreadyConnectedMatch;
                          if (successfullyMatch.hasMatch(result) ||
                              alreadySuccessMatch.hasMatch(result) &&
                                  !invalidMatch.hasMatch(result)) {
                            Logs().v('connected to Facebook Messenger');
                            Navigator.of(context).pop();
                            completer.complete(
                              true,
                            ); // returns True if the connection is successful
                          } else if (invalidMatch.hasMatch(result)) {
                            showCatchErrorDialog(
                              context,
                              L10n.of(context)!.err_invalidTwoFactorCode,
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
