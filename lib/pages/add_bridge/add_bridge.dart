import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/pages/add_bridge/add_bridge_body.dart';
import 'package:tawkie/pages/add_bridge/service/hostname.dart';
import 'package:tawkie/pages/add_bridge/service/reg_exp_pattern.dart';
import 'package:tawkie/pages/add_bridge/show_bottom_sheet.dart';
import 'package:tawkie/pages/add_bridge/success_message.dart';
import 'package:tawkie/pages/add_bridge/web_view_connection.dart';
import 'package:tawkie/widgets/matrix.dart';
import 'package:tawkie/widgets/notifier_state.dart';

import 'delete_conversation_dialog.dart';
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

  // Function to logout
  Future<String> disconnectFromNetwork(BuildContext context,
      SocialNetwork network, ConnectionStateModel connectionState) async {
    final String botUserId = '${network.chatBot}$hostname';

    connectionState
        .updateConnectionTitle(L10n.of(context)!.loadingDisconnectionDemand);

    final Map<String, RegExp> patterns = _getLogoutNetworkPatterns(network.name);
    final String eventName = _getEventName(network.name);

    final String? directChat = await _getOrCreateDirectChat(botUserId);
    if (directChat == null) return 'error';

    final Room? roomBot = client.getRoomById(directChat);
    if (roomBot == null) return 'error';

    if (!await _sendLogoutEvent(roomBot, eventName)) return 'error';

    return await _waitForDisconnection(
        context, network, connectionState, directChat, patterns);
  }

  Map<String, RegExp> _getLogoutNetworkPatterns(String networkName) {
    switch (networkName) {
      case 'Instagram':
        return {
          'success': LogoutRegex.instagramSuccessMatch,
          'alreadyLogout': LogoutRegex.instagramAlreadyLogoutMatch
        };
      case 'WhatsApp':
        return {
          'success': LogoutRegex.whatsappSuccessMatch,
          'alreadyLogout': LogoutRegex.whatsappAlreadyLogoutMatch
        };
      case 'Facebook Messenger':
        return {
          'success': LogoutRegex.facebookSuccessMatch,
          'alreadyLogout': LogoutRegex.facebookAlreadyLogoutMatch
        };
      default:
        throw ArgumentError('Unsupported network: $networkName');
    }
  }

  String _getEventName(String networkName) {
    switch (networkName) {
      case 'Instagram':
      case 'Facebook Messenger':
        return 'delete-session';
      default:
        return 'logout';
    }
  }

  Future<String?> _getOrCreateDirectChat(String botUserId) async {
    try {
      String? directChat = client.getDirectChatFromUserId(botUserId);
      directChat ??= await client.startDirectChat(botUserId);
      return directChat;
    } catch (e) {
      Logs().v('Error getting or starting direct chat: $e');
      return null;
    }
  }

  Future<bool> _sendLogoutEvent(Room roomBot, String eventName) async {
    try {
      await roomBot.sendTextEvent(eventName);
      await Future.delayed(const Duration(seconds: 3));
      return true;
    } catch (e) {
      Logs().v('Error sending text event: $e');
      return false;
    }
  }

  Future<String> _waitForDisconnection(
      BuildContext context,
      SocialNetwork network,
      ConnectionStateModel connectionState,
      String directChat,
      Map<String, RegExp> patterns) async {
    const int maxIterations = 5;
    int currentIteration = 0;

    while (currentIteration < maxIterations) {
      try {
        final GetRoomEventsResponse response =
            await client.getRoomEvents(directChat, Direction.b, limit: 1);
        final List<MatrixEvent> latestMessages = response.chunk ?? [];

        if (latestMessages.isNotEmpty) {
          final String latestMessage =
              latestMessages.first.content['body'].toString() ?? '';

          if (_isStillConnected(latestMessage, patterns)) {
            Logs().v("You're still connected to ${network.name}");
            return 'Connected';
          }

          if (_isDisconnected(latestMessage, patterns)) {
            Logs().v("You're disconnected from ${network.name}");
            connectionState.updateConnectionTitle(
                L10n.of(context)!.loadingDisconnectionSuccess);
            connectionState.updateLoading(false);
            await Future.delayed(const Duration(seconds: 1));
            connectionState.reset();
            return 'Not Connected';
          }
        }
      } catch (e) {
        Logs().v('Error in matrix related async function call: $e');
        return 'error';
      }
      currentIteration++;
    }

    connectionState.reset();
    return 'error';
  }

  bool _isStillConnected(String message, Map<String, RegExp> patterns) {
    return !patterns['success']!.hasMatch(message) &&
        !patterns['alreadyLogout']!.hasMatch(message);
  }

  bool _isDisconnected(String message, Map<String, RegExp> patterns) {
    return patterns['success']!.hasMatch(message) ||
        patterns['alreadyLogout']!.hasMatch(message);
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

  // Different ways of connecting and disconnecting depending on the social network, for now only Instagram
  void handleSocialNetworkAction(
    SocialNetwork network,
  ) async {
    if (network.loading == false) {
      if (network.connected != true && network.error == false) {
        await handleConnection(context, network);
      } else if (network.connected == true && network.error == false) {
        // Disconnect button, for the moment only this choice
        await handleDisconnection(context, network);
      }

      // If there is a ping error
      if (network.error && network.connected == false) {
        setState(() {
          network.loading = true;
        });

        // Reload pinging
        await pingSocialNetwork(network);
      }
    }
  }

  Future<void> handleConnection(
      BuildContext context, SocialNetwork network) async {
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
                  network.updateConnectionResult(true);
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
                  network.updateConnectionResult(true);
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

  Future<void> handleDisconnection(
      BuildContext context, SocialNetwork network) async {
    final bool success = await showBottomSheetBridge(context, network, this);

    if (success) {
      network.updateConnectionResult(false);
      await deleteConversationDialog(context, network, this);
    } else {
      showCatchErrorDialog(context, L10n.of(context)!.errTimeOut);
    }
  }

  @override
  Widget build(BuildContext context) => AddBridgeBody(controller: this);
}
