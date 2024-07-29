import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:tawkie/pages/add_bridge/add_bridge.dart';
import 'package:tawkie/pages/add_bridge/qr_code_connect.dart';
import 'package:tawkie/widgets/notifier_state.dart';

import '../../widgets/future_loading_dialog_custom.dart';
import 'error_message_dialog.dart';
import 'login_form.dart';
import 'model/social_network.dart';

// Creation of a FormKey for entering identifiers for Connection ShowDialog
GlobalKey<FormState> formKey = GlobalKey<FormState>();

// ShowDialog for WhatsApp connection
Future<void> connectToWhatsApp(
  BuildContext context,
  SocialNetwork network,
  BotController botConnection,
) async {
  final Completer<bool> completer = Completer<bool>();

  final TextEditingController controller = TextEditingController();

  // login functions for whatsApp
  Future<void> whatsAppLoginFunction({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String? phoneNumber,
    required BotController botConnection,
  }) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save(); // Save form values

      final connectionStateModel =
          Provider.of<ConnectionStateModel>(context, listen: false);

      try {
        WhatsAppResult?
            result; // Variable to store the result of the connection

        // To show Loading while executing the function
        await showCustomLoadingDialog(
          context: context,
          future: () async {
            result = await botConnection.createBridgeWhatsApp(
                context, phoneNumber!, connectionStateModel);
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
                    socialNetwork: network,
                  ),
                ),
              ) ??
              false;

          if (success == true) {
            Navigator.of(context).pop();
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
                  if (controller.text.isNotEmpty) {
                    await whatsAppLoginFunction(
                      context: context,
                      formKey: formKey,
                      phoneNumber: controller.text,
                      botConnection: botConnection,
                    );
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
}
