import 'dart:async';

import 'package:fluffychat/pages/add_bridge/service/bot_bridge_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'error_message_dialog.dart';
import 'model/social_network.dart';

// Disconnect button display
Future<bool> showBottomSheetBridge(
  BuildContext context,
  SocialNetwork network,
  BotBridgeConnection botConnection,
) async {
  final Completer<bool> completer = Completer<bool>();

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
                bool result = true;
                Navigator.pop(context);

                await showFutureLoadingDialog(
                  context: context,
                  future: () async {

                    if (network.name == "Instagram") {
                      result = await botConnection.disconnectToInstagram();
                    }

                    if(result != false){
                      completer.complete(false);
                    }
                  },
                );

                completer.complete(true);

              } catch (e) {
                print("error: $e");

                Navigator.of(context).pop();
                //To view other catch-related errors
                showCatchErrorDialog(context, L10n.of(context)!.err_timeOut);
              }
            },
          ),
        ],
      );
    },
  );

  return completer.future;
}
