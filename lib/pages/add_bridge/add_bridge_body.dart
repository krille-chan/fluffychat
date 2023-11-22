import 'dart:async';

import 'package:fluffychat/pages/add_bridge/service/bot_bridge_connection.dart';
import 'package:fluffychat/pages/add_bridge/service/hostname.dart';
import 'package:fluffychat/pages/add_bridge/show_bottom_sheet.dart';
import 'package:fluffychat/pages/add_bridge/show_delete_conversation_dialog.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/platform_size.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/matrix.dart';
import 'add_bridge_header.dart';
import 'connection_bridge_dialog.dart';
import 'error_message_dialog.dart';
import 'model/social_network.dart';

// Page offering brigde bot connections to social network chats
class AddBridgeBody extends StatefulWidget {
  const AddBridgeBody({
    super.key,
  });

  @override
  State<AddBridgeBody> createState() => _AddBridgeBodyState();
}

class _AddBridgeBodyState extends State<AddBridgeBody> {
  late BotBridgeConnection botConnection;
  late String hostname;
  bool timeoutErrorOccurred = false;

  @override
  void initState() {
    final client = Matrix.of(context).client;
    final String fullUrl = client.homeserver!.host;
    hostname = extractHostName(fullUrl);
    botConnection = BotBridgeConnection(client: client, hostname: hostname);
    super.initState();
    _checkSocialNetworkConnections();
  }

  @override
  void dispose() {
    botConnection.stopProcess();

    // Reset loading values to their original state by exiting the page
    for (final element in socialNetwork) {
      element.loading = true;
    }

    super.dispose();
  }

  // Retrieves the name of each network in the socialNetwork list
  Future<void> _checkSocialNetworkConnections() async {
    for (final network in socialNetwork) {
      await _checkSocialNetworkConnection(network.name);
    }
  }

  // Online status update when page is opened
  Future<void> _checkSocialNetworkConnection(String socialNetworkName) async {
    try {
      final connected = await botConnection.pingWithTimeout(
        context,
        _getSocialNetworkPingFunction(socialNetworkName),
      );
      if (!mounted) return; // Check if the widget is still mounted

      if (connected != 'error') {
        setState(() {
          socialNetwork
              .firstWhere((element) => element.name == socialNetworkName)
              .connected = connected == 'Connected' ? true : false;
          socialNetwork
              .firstWhere((element) => element.name == socialNetworkName)
              .loading = false;
        });
      } else {
        if (mounted) {
          showCatchErrorDialog(
            context,
            "${L10n.of(context)!.err_toConnect} $socialNetworkName",
          );
        }
      }
    } on TimeoutException {
      // To indicate that the time-out error has occurred
      if (mounted) {
        timeoutErrorOccurred = true;
      }
    } catch (error) {
      print("Error pinging $socialNetworkName: $error");
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Precaution to let the page load
      if (mounted && !timeoutErrorOccurred) {
        showCatchErrorDialog(
          context,
          "${L10n.of(context)!.err_toConnect} $socialNetworkName",
        );
      }
    }
  }

  // Switch ping functions to networks
  Future<String> _getSocialNetworkPingFunction(String socialNetworkName) {
    switch (socialNetworkName) {
      case "Instagram":
        return botConnection.instagramPing();
      case "Whatsapp":
        return botConnection.whatsAppPing();
      // case "Facebook Messenger":
      //   return botConnection.facebookPing();
      default:
        throw Exception("Unsupported social network: $socialNetworkName");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildHeaderBridgeText(context),
            buildHeaderBridgeSubText(context),
            Center(
              child: SizedBox(
                width: PlatformInfos.isWeb ? PlatformWidth.webWidth : null,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: socialNetwork.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: socialNetwork[index].logo,
                      title: Text(
                        socialNetwork[index].name,
                      ),
                      // Different build of subtle depending on the social network, for now only Instagram
                      subtitle: buildSubtitle(socialNetwork[index]),
                      trailing: const Icon(
                        CupertinoIcons.right_chevron,
                      ),

                      // Different ways of connecting and disconnecting depending on the social network
                      onTap: () =>
                          handleSocialNetworkAction(socialNetwork[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Different ways of connecting and disconnecting depending on the social network, for now only Instagram
  void handleSocialNetworkAction(SocialNetwork network) async {
    if (network.loading == false) {
      if (network.connected != true) {
        bool success = false;
        switch (network.name) {
          case "Instagram":
            // Trying to connect to Instagram
            success = await connectToInstagram(context, network, botConnection);
            break;

          // For other networks
        }
        if (success) {
          setState(() {
            network.connected = true;
          });
        }
      } else {
        // Disconnect button, for the moment only this choice
        final bool success = await showBottomSheetBridge(
          context,
          network,
          botConnection,
        );

        if (success) {
          setState(() {
            network.connected = false;
          });

          // Show the dialog for deleting the conversation
          await showDeleteConversationDialog(context, network, botConnection);
        } else {
          // Display error message to warn user
          showCatchErrorDialog(context, L10n.of(context)!.err_timeOut);
        }
      }
    }
  }

  // Different build of subtle depending on the social network, for now only Instagram
  Widget buildSubtitle(SocialNetwork network) {
    if (network.loading == true) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: CircularProgressIndicator(
          color: Colors.grey,
        ),
      );
    } else {
      return Text(
        network.connected == true
            ? L10n.of(context)!.connected
            : L10n.of(context)!.notConnected,
        style: TextStyle(
          color: network.connected == true ? Colors.green : Colors.grey,
        ),
      );
    }
  }
}
