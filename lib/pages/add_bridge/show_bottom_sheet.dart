import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';
import 'package:tawkie/pages/add_bridge/add_bridge.dart';
import 'package:tawkie/widgets/future_loading_dialog_custom.dart';
import 'package:tawkie/widgets/notifier_state.dart';

import 'error_message_dialog.dart';
import 'model/social_network.dart';

// Disconnect button display
Future<bool> showBottomSheetBridge(
  BuildContext context,
  SocialNetwork network,
  BotController controller,
) async {
  final Completer<bool> completer = Completer<bool>();

  final connectionStateModel =
      Provider.of<ConnectionStateModel>(context, listen: false);

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              L10n.of(context)!.logout,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: () async {
              try {
                ConnectionStatus?
                    result; // Variable to store the result of the connection

                // To show Loading while executing the function
                await showCustomLoadingDialog(
                  context: context,
                  future: () async {
                    result = await controller.disconnectFromNetwork(
                        context, network, connectionStateModel);
                  },
                );

                if (result == ConnectionStatus.notConnected) {
                  Navigator.of(context).pop();

                  // returns true if is not connected
                  completer.complete(result == ConnectionStatus.notConnected);
                }

                if (result == ConnectionStatus.error ||
                    result == ConnectionStatus.connected) {
                  // Display a showDialog with an unknown error message
                  showCatchErrorDialog(
                    context,
                    L10n.of(context)!.errTryAgain,
                  );
                }
              } catch (e) {
                Navigator.of(context).pop();
                Logs().v('Error: $e');

                //To view other catch-related errors
                showCatchErrorDialog(context, e);
              }
            },
          ),
        ],
      );
    },
  );

  return completer.future;
}
