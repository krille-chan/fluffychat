

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/pages/add_bridge/add_bridge_body.dart';
import 'package:tawkie/pages/add_bridge/service/hostname.dart';
import 'package:tawkie/pages/add_bridge/service/reg_exp_pattern.dart';
import 'package:tawkie/pages/add_bridge/success_message.dart';
import 'package:tawkie/pages/add_bridge/web_view_connection.dart';
import 'package:tawkie/widgets/matrix.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/widgets/notifier_state.dart';
import 'error_message_dialog.dart';
import 'model/social_network.dart';

class AddBridge extends StatefulWidget {
  const AddBridge({super.key});

  @override
  BotController createState() => BotController();
}

class BotController extends State<AddBridge> {
  String? messageError;
  bool loading = true;
  bool continueProcess = true;

  late Client client;
  late String hostname;

  List<SocialNetwork> socialNetworks = SocialNetworkManager.socialNetworks;

  @override
  void initState() {
    super.initState();
    matrixInit();
    handleRefresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void matrixInit() {
    client = Matrix.of(context).client;
    final String fullUrl = client.homeserver!.host;
    hostname = extractHostName(fullUrl);
  }

  void updateNetworkStatus(bool isConnected) {
    setState(() {
      network.connected = isConnected;
      network.loading = false;
      network.error = !isConnected;
    });
  }

  Future<void> handleRefresh() async {
    setState(() {
      // Reset loading values to their original state
      for (final network in socialNetworks) {
        network.loading = true;
        network.connected = false;
        network.error = false;
      }
    });

    // Execute pingSocialNetwork for all social networks in parallel
    await Future.wait(socialNetworks.map((network) {
      return pingSocialNetwork(network);
    }));
  }

  Future<void> pingSocialNetwork(SocialNetwork socialNetwork) async {
    final String botUserId = '${socialNetwork.chatBot}$hostname';

    // Messages to spot when we're online
    RegExp? onlineMatch;

    // Messages to spot when we're not online
    RegExp? notLoggedMatch;
    RegExp? mQTTNotMatch;

    switch (socialNetwork.name) {
      case "WhatsApp":
        onlineMatch = PingPatterns.whatsAppOnlineMatch;
        notLoggedMatch = PingPatterns.whatsAppNotLoggedMatch;
        mQTTNotMatch = PingPatterns.whatsAppLoggedButNotConnectedMatch;
        break;
      case "Facebook Messenger":
        onlineMatch = PingPatterns.facebookOnlineMatch;
        notLoggedMatch = PingPatterns.facebookNotLoggedMatch;
        break;
      case "Instagram":
        onlineMatch = PingPatterns.instagramOnlineMatch;
        notLoggedMatch = PingPatterns.instagramNotLoggedMatch;
        break;
      default:
        throw Exception("Unsupported social network: ${socialNetwork.name}");
    }

    // Add a direct chat with the bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    // Send the "ping" message to the bot
    try {
      await roomBot?.sendTextEvent("ping");
    } catch (error) {
      Logs().i('Error: $error');
      setState(() {
        socialNetwork.setError(true);
      });
    }

    await Future.delayed(const Duration(seconds: 2)); // Wait sec

    String result = ''; // Variable to track the result of the connection

    // Variable for loop limit
    const int maxIterations = 5;
    int currentIteration = 0;

    while (continueProcess && currentIteration < maxIterations) {
      // To take the latest message
      final GetRoomEventsResponse response = await client.getRoomEvents(
        directChat,
        Direction.b, // To get the latest messages
        limit: 1, // Number of messages to obtain
      );

      final List<MatrixEvent> latestMessages = response.chunk ?? [];

      if (latestMessages.isNotEmpty) {
        final String latestMessage =
            latestMessages.first.content['body'].toString() ?? '';

        // To find out if we're connected
        if (onlineMatch.hasMatch(latestMessage)) {
          Logs().v("You're logged to ${socialNetwork.name}");

          setState(() {
            socialNetwork.updateConnectionResult(true);
            socialNetwork.setError(false);
          });

          break; // Exit the loop if the bridge is connected
        }
        if (notLoggedMatch.hasMatch(latestMessage) == true) {
          Logs().v('Not connected to ${socialNetwork.name}');

          setState(() {
            socialNetwork.updateConnectionResult(false);
            socialNetwork.setError(false);
          });

          break; // Exit the loop if the bridge is disconnected
        } else if (mQTTNotMatch?.hasMatch(latestMessage) == true) {
          String eventToSend;

          switch (socialNetwork.name) {
            case "WhatsApp":
              eventToSend = "reconnect";
              break;
            default:
              eventToSend = "connect";
              break;
          }

          await roomBot?.sendTextEvent(eventToSend);

          await Future.delayed(const Duration(seconds: 3)); // Wait sec
        } else {
          // If no new message is received from the bot, we send back a ping
          // Or no expected answer is found
          await roomBot?.sendTextEvent("ping");
          await Future.delayed(const Duration(seconds: 2)); // Wait sec
        }
      }
      currentIteration++;
    }

    if (currentIteration == maxIterations) {
      Logs().v(
          "Maximum iterations reached, setting result to 'error to ${socialNetwork.name}'");

      setState(() {
        socialNetwork.setError(true);
      });
    } else if (!continueProcess) {
      Logs().v(('ping stopping'));
      result = 'stop';
    }
  }

  // Function to delete a conversation with a bot
  Future<void> deleteConversation(BuildContext context, String chatBot,
      ConnectionStateModel connectionState) async {
    final String botUserId = "$chatBot$hostname";
    Future.microtask(() {
      connectionState.updateConnectionTitle(
        L10n.of(context)!.loadingDeleteRoom,
      );
    });
    try {
      final roomId = client.getDirectChatFromUserId(botUserId);
      final room = client.getRoomById(roomId!);
      if (room != null) {
        await room.leave(); // To leave and delete the room (DirectChat only)
        Logs().v('Conversation deleted successfully');

        Future.microtask(() {
          connectionState.updateConnectionTitle(
            L10n.of(context)!.loadingDeleteRoomSuccess,
          );
          connectionState.updateLoading(false);
        });

        await Future.delayed(const Duration(seconds: 1)); // Wait sec
      } else {
        Logs().v('Room not found');
      }
    } catch (e) {
      Logs().v('Error deleting conversation: $e');
    }

    Future.microtask(() {
      connectionState.reset();
    });
  }

  Future<void> handleConnection(BuildContext context, SocialNetwork network) async {
    switch (network.name) {
      case "Instagram":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewConnection(
              controller: this,
              network: network,
              onConnectionResult: (bool success) {
                if (success) {
                  updateNetworkStatus(true);
                  showCatchSuccessDialog(context,
                      "${L10n.of(context)!.youAreConnectedTo} ${network.name}");
                } else {
                  showCatchErrorDialog(context,
                      "${L10n.of(context)!.errToConnect} ${network.name}");
                }
              },
            ),
          ),
        );
        break;
      case "WhatsApp":
      // Replace this with your actual WhatsApp connection logic
      // success = await connectToWhatsApp(context, network, controller);
        break;
      case "Facebook Messenger":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewConnection(
              controller: this,
              network: network,
              onConnectionResult: (bool success) {
                if (success) {
                  updateNetworkStatus(true);
                  showCatchSuccessDialog(context,
                      "${L10n.of(context)!.youAreConnectedTo} ${network.name}");
                } else {
                  showCatchErrorDialog(context,
                      "${L10n.of(context)!.errToConnect} ${network.name}");
                }
              },
            ),
          ),
        );
        break;
    // Add other cases here
    }
  }


  @override
  Widget build(BuildContext context) => AddBridgeBody(controller: this);
}
