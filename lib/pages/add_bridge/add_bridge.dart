import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
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
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

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
    continueProcess = false;
    super.dispose();
  }

  void matrixInit() {
    client = Matrix.of(context).client;
    final String fullUrl = client.homeserver!.host;
    hostname = extractHostName(fullUrl);
  }

  Future<String?> _getOrCreateDirectChat(String botUserId) async {
    try {
      String? directChat = client.getDirectChatFromUserId(botUserId);
      directChat ??= await client.startDirectChat(botUserId);
      return directChat;
    } catch (e) {
      Logs().i('Error getting or starting direct chat: $e');
      return null;
    }
  }

  String formatCookiesToJsonString(List<io.Cookie> cookies) {
    Map<String, String> formattedCookies = {};

    for (var cookie in cookies) {
      String decodedValue = Uri.decodeComponent(cookie.value);
      formattedCookies[cookie.name] = decodedValue;
    }

    return json.encode(formattedCookies);
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

    final RegExpPingPatterns patterns = _getPingPatterns(socialNetwork.name);

    final String? directChat = await _getOrCreateDirectChat(botUserId);
    if (directChat == null) {
      _handleError(socialNetwork);
      return;
    }

    final Room? roomBot = client.getRoomById(directChat);
    if (roomBot == null) {
      _handleError(socialNetwork);
      return;
    }

    if (!await _sendPingMessage(roomBot)) {
      _handleError(socialNetwork);
      return;
    }

    await Future.delayed(const Duration(seconds: 2)); // Wait sec

    await _processPingResponse(socialNetwork, directChat, roomBot, patterns);
  }

  RegExpPingPatterns _getPingPatterns(String networkName) {
    switch (networkName) {
      case "WhatsApp":
        return RegExpPingPatterns(
          PingPatterns.whatsAppOnlineMatch,
          PingPatterns.whatsAppNotLoggedMatch,
          PingPatterns.whatsAppLoggedButNotConnectedMatch,
        );
      case "Facebook Messenger":
        return RegExpPingPatterns(
          PingPatterns.facebookOnlineMatch,
          PingPatterns.facebookNotLoggedMatch,
        );
      case "Instagram":
        return RegExpPingPatterns(
          PingPatterns.instagramOnlineMatch,
          PingPatterns.instagramNotLoggedMatch,
        );
      default:
        throw Exception("Unsupported social network: $networkName");
    }
  }

  Future<bool> _sendPingMessage(Room roomBot) async {
    try {
      await roomBot.sendTextEvent("ping");
      return true;
    } catch (e) {
      Logs().i('Error sending ping message: $e');
      return false;
    }
  }

  // TODO: Faire en sorte de relancer si plusieurs ping envoyés d'affilé n'ont pas de reponse
  Future<void> _processPingResponse(SocialNetwork socialNetwork,
      String directChat, Room roomBot, RegExpPingPatterns patterns) async {
    const int maxIterations = 5;
    int currentIteration = 0;

    while (continueProcess && currentIteration < maxIterations) {
      final GetRoomEventsResponse response = await client.getRoomEvents(
        directChat,
        Direction.b, // To get the latest messages
        limit: 1, // Number of messages to obtain
      );

      final List<MatrixEvent> latestMessages = response.chunk ?? [];

      if (latestMessages.isNotEmpty) {
        final String latestMessage =
            latestMessages.first.content['body'].toString() ?? '';

        if (_isOnline(patterns.onlineMatch, latestMessage)) {
          Logs().v("You're logged to ${socialNetwork.name}");
          _updateNetworkStatus(socialNetwork, true, false);
          return;
        }

        if (_isNotLogged(patterns.notLoggedMatch, latestMessage)) {
          Logs().v('Not connected to ${socialNetwork.name}');
          _updateNetworkStatus(socialNetwork, false, false);
          return;
        }

        if (_shouldReconnect(patterns.mQTTNotMatch, latestMessage)) {
          await _sendReconnectEvent(roomBot, socialNetwork.name);
          await Future.delayed(const Duration(seconds: 3)); // Wait sec
        } else {
          await _sendPingMessage(roomBot);
          await Future.delayed(const Duration(seconds: 2)); // Wait sec
        }
      }
      currentIteration++;
    }

    if (currentIteration == maxIterations) {
      Logs().v(
          "Maximum iterations reached, setting result to 'error to ${socialNetwork.name}'");
      _handleError(socialNetwork);
    } else if (!continueProcess) {
      Logs().v(('ping stopping'));
    }
  }

  bool _isOnline(RegExp onlineMatch, String latestMessage) {
    return onlineMatch.hasMatch(latestMessage);
  }

  bool _isNotLogged(RegExp notLoggedMatch, String latestMessage) {
    return notLoggedMatch.hasMatch(latestMessage);
  }

  bool _shouldReconnect(RegExp? mQTTNotMatch, String latestMessage) {
    return mQTTNotMatch?.hasMatch(latestMessage) ?? false;
  }

  Future<void> _sendReconnectEvent(Room roomBot, String networkName) async {
    String eventToSend = networkName == "WhatsApp" ? "reconnect" : "connect";
    await roomBot.sendTextEvent(eventToSend);
  }

  void _updateNetworkStatus(
      SocialNetwork socialNetwork, bool isConnected, bool isError) {
    setState(() {
      socialNetwork.connected = isConnected;
      socialNetwork.loading = false;
      socialNetwork.error = isError;
    });
  }

  void _handleError(SocialNetwork socialNetwork) {
    setState(() {
      socialNetwork.setError(true);
    });
  }

  // Function to logout
  Future<String> disconnectFromNetwork(BuildContext context,
      SocialNetwork network, ConnectionStateModel connectionState) async {
    final String botUserId = '${network.chatBot}$hostname';

    Future.microtask(() {
      connectionState
          .updateConnectionTitle(L10n.of(context)!.loadingDisconnectionDemand);
    });

    final Map<String, RegExp> patterns =
        _getLogoutNetworkPatterns(network.name);
    final String eventName = _getEventName(network.name);

    final String? directChat = await _getOrCreateDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat!);

    await _sendLogoutEvent(roomBot!, eventName);

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
          final MatrixEvent latestEvent = latestMessages.first;
          final String latestMessage =
              latestEvent.content['body'].toString() ?? '';
          final String sender = latestEvent.senderId;
          final String botUserId = '${network.chatBot}$hostname';

          // Check if the message comes from the bot
          if (sender == botUserId) {
            if (_isStillConnected(latestMessage, patterns)) {
              Logs().v("You're still connected to ${network.name}");
              setState(() => network.updateConnectionResult(true));
              return 'Connected';
            }

            if (_isDisconnected(latestMessage, patterns)) {
              Logs().v("You're disconnected from ${network.name}");
              connectionState.updateConnectionTitle(
                  L10n.of(context)!.loadingDisconnectionSuccess);
              connectionState.updateLoading(false);
              await Future.delayed(const Duration(seconds: 1));
              connectionState.reset();
              setState(() => network.updateConnectionResult(false));
              return 'Not Connected';
            }
          }

          await Future.delayed(const Duration(seconds: 3));
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

        await Future.delayed(const Duration(seconds: 1));
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
      await deleteConversationDialog(context, network, this);
    }
  }

  // Function to manage the synchronization of new rooms from the Matrix server
  Future<void> handleNewRoomsSync(
      BuildContext context, SocialNetwork network) async {
    // Retrieve newly added rooms from the Matrix server
    final List<Room> newRooms = client.rooms;

    // Iterating on new rooms
    for (final Room newRoom in newRooms) {
      acceptInvitation(newRoom, context);
    }
  }

  // Create a set to keep track of invitations already processed
  Set<String> acceptedInvitations = {};

  // Function to accept an invitation to a conversation
  void acceptInvitation(Room room, BuildContext context) async {
    try {
      // Check if the invitation has already been processed
      if (!acceptedInvitations.contains(room.id)) {
        // Mark the invitation as processed by adding it to the set of accepted invitations
        acceptedInvitations.add(room.id);

        // Accept invitation
        final waitForRoom = room.client.waitForRoomInSync(
          room.id,
          join: true,
        );
        await room.join();
        await waitForRoom;
      }
    } catch (e) {
      if (kDebugMode) {
        print("error: $e");
      }
    }
  }

  // Function to login Facebook
  Future<void> createBridgeMeta(
    BuildContext context,
    WebviewCookieManager cookieManager,
    ConnectionStateModel connectionState,
    SocialNetwork network,
  ) async {
    final String botUserId = '${network.chatBot}$hostname';

    Future.microtask(() {
      connectionState
          .updateConnectionTitle(L10n.of(context)!.loadingDemandToConnect);
    });

    final RegExp successMatch = LoginRegex.facebookSuccessMatch;
    final RegExp alreadyConnected = LoginRegex.facebookAlreadyConnectedMatch;
    final RegExp pasteCookie = LoginRegex.facebookPasteCookies;

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    await Future.delayed(const Duration(seconds: 1)); // Wait sec

    Future.microtask(() {
      connectionState
          .updateConnectionTitle(L10n.of(context)!.loadingVerification);
    });

    final gotCookies = await cookieManager.getCookies(network.urlRedirect);
    final formattedCookieString = formatCookiesToJsonString(gotCookies);

    // Send the "login" message to the bot
    await roomBot?.sendTextEvent("login");
    await Future.delayed(const Duration(seconds: 5)); // Wait sec

    // Variable for loop limit
    const int maxIterations = 5;
    int currentIteration = 0;

    while (currentIteration < maxIterations) {
      final GetRoomEventsResponse response = await client.getRoomEvents(
        directChat,
        Direction.b, // To get the latest messages
        limit: 1, // Number of messages to obtain
      );

      final List<MatrixEvent> latestMessages = response.chunk ?? [];
      final MatrixEvent latestEvent = latestMessages.first;
      final String latestMessage = latestEvent.content['body'].toString() ?? '';
      final String sender = latestEvent.senderId;
      final String botUserId = '${network.chatBot}$hostname';

      if (latestMessages.isNotEmpty && sender == botUserId) {
        if (kDebugMode) {
          print('latestMessage : $latestMessage');
        }
        if (pasteCookie.hasMatch(latestMessage)) {
          await roomBot?.sendTextEvent(formattedCookieString);
        } else if (alreadyConnected.hasMatch(latestMessage)) {
          Logs().v("Already Connected to ${network.name}");
          break;
        } else if (successMatch.hasMatch(latestMessage)) {
          Logs().v("You're logged to ${network.name}");

          Future.microtask(() {
            connectionState
                .updateConnectionTitle(L10n.of(context)!.loadingRetrieveRooms);
          });
          // await Future.delayed(
          //     const Duration(seconds: 10)); // Wait sec for rooms loading
          // await handleNewRoomsSync(context, network);

          setState(() => network.updateConnectionResult(true));

          Future.microtask(() {
            connectionState.updateConnectionTitle(L10n.of(context)!.connected);
          });

          Future.microtask(() {
            connectionState.updateLoading(false);
          });

          await Future.delayed(const Duration(seconds: 1)); // Wait sec
          Future.microtask(() {
            connectionState.reset();
          });

          break; // Exit the loop once the "login" message has been sent and is success
        }
      }

      await Future.delayed(const Duration(seconds: 3)); // Wait sec
      currentIteration++;
    }

    if (currentIteration == maxIterations) {
      Logs().v("Maximum iterations reached, setting result to 'error'");
    }
  }

  @override
  Widget build(BuildContext context) => AddBridgeBody(controller: this);
}
