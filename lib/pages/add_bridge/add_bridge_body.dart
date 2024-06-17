import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/pages/add_bridge/delete_conversation_dialog.dart';
import 'package:tawkie/pages/add_bridge/service/bot_bridge_connection.dart';
import 'package:tawkie/pages/add_bridge/service/hostname.dart';
import 'package:tawkie/pages/add_bridge/show_bottom_sheet.dart';
import 'package:tawkie/pages/add_bridge/success_message.dart';
import 'package:tawkie/pages/add_bridge/web_view_connection.dart';
import 'package:tawkie/utils/platform_infos.dart';
import 'package:tawkie/utils/platform_size.dart';
import 'package:tawkie/widgets/matrix.dart';

import 'add_bridge_header.dart';
import 'bot_chat_list.dart';
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
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ce code sera exécuté après que le premier rendu de la frame soit terminé

      final client = Matrix.of(context).client;
      final String fullUrl = client.homeserver!.host;
      hostname = extractHostName(fullUrl);
      botConnection = BotBridgeConnection(client: client, hostname: hostname);

      if (PlatformInfos.isWeb) {
        // Call the method that manages stream listening
        setupPingResultsListener();

        // Calling the ping method
        botConnection.checkAllSocialNetworksConnections(socialNetwork);
      } else {
        // Call the method that manages stream listening
        setupPingResultsListener();

        // Calling the ping method
        botConnection.checkAllSocialNetworksConnections(socialNetwork);
      }
    });
  }

  @override
  void dispose() {
    botConnection.stopProcess();

    // Reset loading values to their original state by exiting the page
    for (final element in socialNetwork) {
      element.loading = true;
      element.error = false;
    }

    super.dispose();
  }

  // Method for managing the ping results stream
  void setupPingResultsListener() {
    botConnection.pingResults.listen((result) {
      final String name = result['name'];
      String pingResult = result['result'];

      SocialNetwork network =
          socialNetwork.firstWhere((network) => network.name == name);

      // Updated connection results for each social network
      if (pingResult == 'Connected') {
        setState(() {
          network.updateConnectionResult(true);
          network.setError(false);
        });
      } else if (pingResult == 'Not Connected') {
        setState(() {
          network.updateConnectionResult(false);
          network.setError(false);
        });
      } else if (pingResult == 'error') {
        // Error management
        setState(() {
          network.setError(true);
        });
        showCatchErrorDialog(
            context, "${L10n.of(context)!.errToConnect} ${result['name']}");
      }
    });
  }

  Future<void> handleRefresh() async {
    // Simulate a delay for demonstration purposes
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Reset loading values to their original state by exiting the page
      for (final element in socialNetwork) {
        element.loading = true;
      }

      // Calling the ping method
      botConnection.checkAllSocialNetworksConnections(socialNetwork);
    });
  }

  Future<void> onlyNetworkRefresh(SocialNetwork network) async {
    setState(() {
      // Reset loading values to their original state by exiting the page
      network.loading = true;

      // Calling the ping method
      botConnection.checkOnlySocialNetworksConnections(network);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showPopupMenu(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildHeaderBridgeText(context),
            buildHeaderBridgeSubText(context),
            PlatformInfos.isWeb ||
                    PlatformInfos.isDesktop ||
                    PlatformInfos.isWindows ||
                    PlatformInfos.isMacOS
                ? ElevatedButton(
                    onPressed: handleRefresh,
                    child: Text(L10n.of(context)!.refreshList),
                  )
                : Container(),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: SizedBox(
                width: PlatformInfos.isWeb ? PlatformWidth.webWidth : null,
                child: RefreshIndicator(
                  onRefresh: handleRefresh,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: socialNetwork.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: socialNetwork[index].logo,
                        title: Text(
                          socialNetwork[index].name,
                        ),
                        // Different build of subtle depending on the social network, for now only Instagram
                        subtitle: buildSubtitle(socialNetwork[index]),
                        trailing: socialNetwork[index].error == false
                            ? const Icon(
                                CupertinoIcons.right_chevron,
                              )
                            : const Icon(
                                CupertinoIcons.refresh_bold,
                              ),
                        // Different ways of connecting and disconnecting depending on the social network
                        onTap: () => socialNetwork[index].error != false
                            ? onlyNetworkRefresh(socialNetwork[index])
                            : handleSocialNetworkAction(socialNetwork[index]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getHostName() {
    final client = Matrix.of(context).client;
    final userId = client.userID;
    final userHostName = extractHostName(userId!.split(':')[1]);
    return userHostName;
  }

  List<String> getBotIds() {
    final hostName = getHostName();
    return socialNetwork.map((sn) => sn.chatBot + hostName).toList();
  }

  List<String> get botIds => getBotIds();

  // Method to show popup menu
  void _showPopupMenu(BuildContext context) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 80, 0, 100),
      items: [
        PopupMenuItem(
          value: 'see_bots',
          child: Text('Voir les bots'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BotChatListPage(botUserIds: botIds),
              ),
            );
          },
        ),
      ],
      elevation: 8.0,
    );
  }

  // Different ways of connecting and disconnecting depending on the social network, for now only Instagram
  void handleSocialNetworkAction(
    SocialNetwork network,
  ) async {
    if (network.loading == false) {
      if (network.connected != true && network.error == false) {
        bool success = false;
        switch (network.name) {
          case "Instagram":
            // Navigate to WebViewConnection and provide callback function
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewConnection(
                  botBridgeConnection: botConnection,
                  network: network,
                  onConnectionResult: (bool success) {
                    if (success) {
                      setState(() {
                        network.connected = true;
                      });
                      showCatchSuccessDialog(context,
                          "${L10n.of(context)!.youAreConnectedTo} ${network.name}");
                    } else {
                      // Handle connection failure
                      showCatchErrorDialog(context,
                          "${L10n.of(context)!.errToConnect} ${network.name}");
                    }
                  },
                ),
              ),
            );
            break;
          case "WhatsApp":
            // Trying to connect to Instagram
            success = await connectToWhatsApp(context, network, botConnection);
            break;
          case "Facebook Messenger":
            // Trying to connect
            // Navigate to WebViewConnection and provide callback function
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewConnection(
                  botBridgeConnection: botConnection,
                  network: network,
                  onConnectionResult: (bool success) {
                    if (success) {
                      setState(() {
                        network.connected = true;
                      });
                      showCatchSuccessDialog(context,
                          "${L10n.of(context)!.youAreConnectedTo} ${network.name}");
                    } else {
                      // Handle connection failure
                      showCatchErrorDialog(context,
                          "${L10n.of(context)!.errToConnect} ${network.name}");
                    }
                  },
                ),
              ),
            );
            break;

          // For other networks
        }
        if (success) {
          setState(() {
            network.connected = true;
          });
          showCatchSuccessDialog(context,
              "${L10n.of(context)!.youAreConnectedTo} ${network.name}");
        }
      } else if (network.connected == true && network.error == false) {
        // Disconnect button, for the moment only this choice
        final bool success =
            await showBottomSheetBridge(context, network, botConnection);

        if (success) {
          setState(() {
            network.connected = false;
          });

          // Show the dialog for deleting the conversation
          await deleteConversationDialog(context, network, botConnection);
        } else {
          // Display error message to warn user
          showCatchErrorDialog(context, L10n.of(context)!.errTimeOut);
        }
      }

      // If there is a ping error
      if (network.error && network.connected == false) {
        setState(() {
          network.loading = true;
        });

        // Reload pinging
        final String pingResult =
            await botConnection.pingSocialNetwork(network);
        if (pingResult == 'Connected') {
          setState(() {
            network.updateConnectionResult(true);
            network.setError(false); // Reset error if retry successful
          });
        } else if (pingResult == 'Not Connected') {
          setState(() {
            network.updateConnectionResult(false);
            network.setError(false);
          });
        } else if (pingResult == 'error') {
          setState(() {
            network.setError(true);
          });
          // error message
          showCatchErrorDialog(
              context, "${L10n.of(context)!.errToConnect} ${network.name}");
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
      if (!network.error) {
        return Text(
          network.connected == true
              ? L10n.of(context)!.connected
              : L10n.of(context)!.notConnected,
          style: TextStyle(
            color: network.connected == true ? Colors.green : Colors.grey,
          ),
        );
      } else {
        return Text(
          L10n.of(context)!.errLoading,
          style: const TextStyle(
            color: Colors.red,
          ),
        );
      }
    }
  }
}
