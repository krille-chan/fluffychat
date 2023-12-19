import 'dart:async';

import 'package:fluffychat/pages/add_bridge/qr_code_connect.dart';
import 'package:fluffychat/pages/add_bridge/service/bot_bridge_connection.dart';
import 'package:fluffychat/pages/add_bridge/two_factor_demand.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'error_message_dialog.dart';
import 'login_form.dart';
import 'model/social_network.dart';

// Creation of a FormKey for entering identifiers for Connection ShowDialog
GlobalKey<FormState> formKey = GlobalKey<FormState>();

// ShowDialog for 2 fields connection
Future<bool> connectWithTwoFields(
  BuildContext context,
  SocialNetwork network,
  BotBridgeConnection botConnection,
) async {
  final Completer<bool> completer = Completer<bool>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Login function for social networks requiring only 2 fields
  Future<void> twoFieldsLoginFunction({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String? username,
    required String? password,
    required SocialNetwork network,
    required BotBridgeConnection botConnection,
  }) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save(); // Save form values

      try {
        String result = ""; // Variable to store the result of the connection

        // To show Loading while executing the function
        await showFutureLoadingDialog(
          context: context,
          future: () async {
            switch (network.name) {
              case "Instagram":
                result = await botConnection.createBridgeInstagram(
                  username!,
                  password!,
                );
                break;
              // Other network
            }
          },
        );

        if (result == "success") {
          Navigator.of(context).pop();
          completer.complete(
            true,
          ); // returns True if the connection is successful
        } else if (result == "twoFactorDemand") {
          bool success = false;
          // Display a showDialog to request a two-factor identification code
          success = await twoFactorDemandCode(context, network, botConnection);
          if (success) {
            Navigator.of(context).pop();
            completer.complete(
              true,
            ); // returns True if the connection is successful
          }
        } else if (result == "errorUsername") {
          // Display a showDialog with an error message related to the identifier
          showCatchErrorDialog(
            context,
            L10n.of(context)!.usernameNotFound,
          );
        } else if (result == "errorPassword") {
          // Display a showDialog with an error message related to the password
          showCatchErrorDialog(
            context,
            L10n.of(context)!.passwordIncorrect,
          );
        } else if (result == "errorNameOrPassword") {
          // Display a showDialog with an error message related to the User/password error
          showCatchErrorDialog(
            context,
            L10n.of(context)!.err_usernameOrPassword,
          );
        } else if (result == "rateLimitError") {
          // Display a showDialog with an error message related to the rate limit
          showCatchErrorDialog(
            context,
            L10n.of(context)!.rateLimit,
          );
        } else if (result == "error") {
          // Display a showDialog with an unknown error message
          showCatchErrorDialog(
            context,
            L10n.of(context)!.err_tryAgain,
          );
        } else if (result == "alreadyConnected") {
          showCatchErrorDialog(context, L10n.of(context)!.err_alreadyConnected);
          Navigator.of(context).pop();
          completer.complete(
            true,
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        //To view other catch-related errors
        showCatchErrorDialog(context, e);
      }
    }
  }

  //ShowDialog requesting connection information
  showDialog(
    context: context,
    useRootNavigator: false, // Close the showDialog by clicking on Back
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
            content: LoginForm(
              formKey: formKey,
              usernameController: usernameController,
              passwordController: passwordController,
              completerCallback: completer.complete,
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
                  // Calling up the login function
                  await twoFieldsLoginFunction(
                    context: context,
                    formKey: formKey,
                    username: usernameController.text,
                    password: passwordController.text,
                    network: network,
                    botConnection: botConnection,
                  );
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

// ShowDialog for WhatsApp connection
Future<bool> connectToWhatsApp(
  BuildContext context,
  SocialNetwork network,
  BotBridgeConnection botConnection,
) async {
  final Completer<bool> completer = Completer<bool>();

  final TextEditingController controller = TextEditingController();

  // Retrieve the language used in the application
  String initialLanguage = Localizations.localeOf(context).languageCode;

  // login functions for whatsApp
  Future<void> whatsAppLoginFunction({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String? phoneNumber,
    required BotBridgeConnection botConnection,
  }) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save(); // Save form values

      try {
        WhatsAppResult?
            result; // Variable to store the result of the connection

        // To show Loading while executing the function
        await showFutureLoadingDialog(
          context: context,
          future: () async {
            result = await botConnection.createBridgeWhatsApp(phoneNumber!);
          },
        );

        if (result?.result == "success") {
          Navigator.of(context).pop();
          completer.complete(
            true,
          ); // returns True if the connection is successful
        } else if (result?.result == "scanTheCode") {
          // ShowDialog for code and QR Code login
          final bool success = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRCodeConnectPage(
                    qrCode: result!.qrCode!,
                    code: result!.code!,
                    botConnection: botConnection,
                  ),
                ),
              ) ??
              false;

          if (success == true) {
            Navigator.of(context).pop();
            completer.complete(
              true,
            ); // returns True if the connection is successful
          }

          //showQRCodeConnectPage(context, result!.qrCode!, result!.code!, botConnection,);
        } else if (result?.result == "loginTimedOut") {
          // Display a showDialog with an error message related to the password
          showCatchErrorDialog(context, L10n.of(context)!.passwordIncorrect);
        } else if (result?.result == "rateLimitError") {
          // Display a showDialog with an error message related to the rate limit
          showCatchErrorDialog(context, L10n.of(context)!.rateLimit);
        }
      } catch (e) {
        Navigator.of(context).pop();
        //To view other catch-related errors
        showCatchErrorDialog(context, e);
      }
    }
  }

  // ShowDialog of the phone number to connect to WhatsApp
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: Text(
              "${L10n.of(context)!.connectYourSocialAccount} ${network.name}",
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: WhatsAppLoginForm(
              formKey: formKey,
              controller: controller,
              completerCallback: completer.complete,
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
                  await whatsAppLoginFunction(
                    context: context,
                    formKey: formKey,
                    phoneNumber: controller.text,
                    botConnection: botConnection,
                  );
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
