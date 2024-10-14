import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:tawkie/pages/add_bridge/add_bridge_body.dart';
import 'package:tawkie/pages/add_bridge/service/hostname.dart';
import 'package:tawkie/pages/add_bridge/service/reg_exp_pattern.dart';
import 'package:tawkie/pages/add_bridge/show_bottom_sheet.dart';
import 'package:tawkie/pages/add_bridge/success_message.dart';
import 'package:tawkie/pages/add_bridge/web_view_connection.dart';
import 'package:tawkie/utils/bridge_utils.dart';
import 'package:tawkie/widgets/matrix.dart';
import 'package:tawkie/widgets/notifier_state.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import 'bot_chat_list.dart';
import 'connection_bridge_dialog.dart';
import 'delete_conversation_dialog.dart';
import 'error_message_dialog.dart';
import 'model/social_network.dart';

enum ConnectionStatus {
  connected,
  notConnected,
  error,
}

enum ConnectionError {
  roomNotFound,
  directChatCreationFailed,
  messageSendingFailed,
  timeout,
  unknown,
}

class AddBridge extends StatefulWidget {
  const AddBridge({super.key});

  @override
  BotController createState() => BotController();
}

class BotController extends State<AddBridge> {
  bool loading = true;
  bool continueProcess = true;

  late Client client;
  late String hostname;
  late Map<String, String> headers;

  late Dio dio;

  List<SocialNetwork> socialNetworks = SocialNetworkManager.socialNetworks;

  // Map to store StreamSubscriptions for each social network
  final Map<String, StreamSubscription> _pingSubscriptions = {};

  @override
  void initState() {
    super.initState();
    matrixInit();
    initializeHeaders();
    initializeDio();
    handleRefresh();
  }

  @override
  void dispose() {
    // Cancel all listeners when the widget is destroyed
    _pingSubscriptions.forEach((key, subscription) => subscription.cancel());
    continueProcess = false;
    super.dispose();
  }

  void initializeDio() {
    final serverUrl = AppConfig.server.startsWith(':')
        ? AppConfig.server.substring(1)
        : AppConfig.server;

    dio = Dio(BaseOptions(
      baseUrl: 'https://matrix.$serverUrl/_matrix/',
      headers: headers,
    ));
  }

  /// Initialize Matrix client and extract hostname
  void matrixInit() {
    client = Matrix.of(context).client;

    final String fullUrl = client.homeserver!.host;
    hostname = extractHostName(fullUrl);
  }

  void initializeHeaders() {
    headers = {
      'Authorization': 'Bearer ${client.accessToken}',
      'Content-Type': 'application/json',
    };
  }

  /// Wait for Matrix synchronization
  Future<void> waitForMatrixSync() async {
    await client.sync(
      fullState: true,
      setPresence: PresenceType.online,
    );
  }

  /// Stop the ongoing process
  void stopProcess() {
    continueProcess = false;
  }

  List<String> getBotIds() {
    return SocialNetworkManager.socialNetworks
        .map((sn) => sn.chatBot + hostname)
        .toList();
  }

  List<String> get botIds => getBotIds();

  void showPopupMenu(BuildContext context) async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 0, 100),
      items: [
        PopupMenuItem(
          value: 'see_bots',
          child: Text(L10n.of(context)!.seeBotsRoom),
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

  Future<String?> _getOrCreateDirectChat(String botUserId) async {
    try {
      await waitForMatrixSync(); // Make sure all conversations are loaded
      final client = Matrix.of(context).client;
      String? directChat;

      // Check whether a direct conversation already exists for this bot
      final room = client.rooms.firstWhereOrNull(
        (room) => botUserId == room.directChatMatrixID,
      );

      if (room != null) {
        directChat = room.id;
      } else {
        // If the conversation doesn't exist, create a new one
        directChat = await client.startDirectChat(
          botUserId,
          preset: CreateRoomPreset.privateChat,
        );
        final roomBot = client.getRoomById(directChat);
        if (roomBot != null) {
          await waitForBotFirstMessage(roomBot);
        }
      }

      return directChat;
    } catch (e) {
      Logs().i('Error getting or starting direct chat: $e');
      return null;
    }
  }

  /// Wait for the first message from the bot (when the conversation created)
  Future<void> waitForBotFirstMessage(Room room) async {
    const int maxWaitTime = 20;
    int waitedTime = 0;

    while (waitedTime < maxWaitTime) {
      await Future.delayed(const Duration(seconds: 1));
      final Event? lastEvent = room.lastEvent;

      if (lastEvent != null && lastEvent.senderId != client.userID) {
        // Received a message from the bot
        // Wait an additional 2 seconds to ensure other messages are received
        await Future.delayed(const Duration(seconds: 5));
        return;
      }

      waitedTime++;
    }

    // If no message received from the bot within the max wait time
    Logs().i('No message received from bot within the wait time');
  }

  Future<void> pingBridgeAPI(SocialNetwork network) async {
    final userId = client.userID;

    final response = await dio.get('${network.apiPath}/provision/v3/whoami?user_id=$userId');

    final status = interpretBridgeResponse(response);

    switch (status) {
      case ConnectionStatus.connected:
        setState(() => network.updateConnectionResult(true));
        break;
      case ConnectionStatus.notConnected:
        setState(() => network.updateConnectionResult(false));
        break;
      case ConnectionStatus.error:
        _handleError(network, ConnectionError.unknown);
        break;
    }
  }

  ConnectionStatus interpretBridgeResponse(Response response) {
    try {
      final responseJson = response.data;

      final networkName = responseJson['network']?['displayname'];
      if (networkName != null) {
        final logins = responseJson['logins'];
        if (logins != null && logins.isNotEmpty) {
          final stateEvent = logins[0]['state']?['state_event'];
          return stateEvent == 'CONNECTED' ? ConnectionStatus.connected : ConnectionStatus.notConnected;
        }else{
          return ConnectionStatus.notConnected;
        }
      }
    } catch (e) {
      return ConnectionStatus.error;
    }
    return ConnectionStatus.error;
  }

  // Future<void> fetchLoginFlows(SocialNetwork network) async {
  //   final accessToken = client.accessToken;
  //   final userId = client.userID;
  //   final url = '/${network.apiPath}/provision/v3/login/flows?user_id=$userId';
  //
  //   try {
  //     final response = await dio.get(
  //       url,
  //       options: Options(
  //         headers: {'Authorization': 'Bearer $accessToken'},
  //       ),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final responseJson = response.data;
  //       final flows = responseJson['flows'];
  //
  //       if (flows != null) {
  //         if (kDebugMode) {
  //           print('Available login flows for ${network.name}:');
  //         }
  //         for (var flow in flows) {
  //           if (kDebugMode) {
  //             print('Name: ${flow['name']}, Description: ${flow['description']}, ${flow['id']}');
  //           }
  //         }
  //       } else {
  //         _handleError(network, ConnectionError.unknown, "No login flows found.");
  //       }
  //     } else if (response.statusCode == 401) {
  //       _handleError(network, ConnectionError.unknown, "Invalid token for ${network.name}.");
  //     } else {
  //       _handleError(network, ConnectionError.unknown, "Unexpected error: ${response.statusCode}");
  //     }
  //   } catch (error) {
  //     _handleError(network, ConnectionError.unknown, error.toString());
  //   }
  // }

  /// Ping a social network to check connection status
  Future<void> pingSocialNetwork(SocialNetwork socialNetwork) async {
    final String botUserId = '${socialNetwork.chatBot}$hostname';
    final SocialNetworkEnum? networkEnum =
        getSocialNetworkEnum(socialNetwork.name);

    final RegExpPingPatterns patterns = getPingPatterns(networkEnum!);
    final String? directChat = await _getOrCreateDirectChat(botUserId);

    if (directChat == null) {
      _handleError(socialNetwork, ConnectionError.directChatCreationFailed);
      return;
    }

    final Room? roomBot = client.getRoomById(directChat);
    if (roomBot == null) {
      _handleError(socialNetwork, ConnectionError.roomNotFound);
      return;
    }

    // Reset existing listeners
    _pingSubscriptions[socialNetwork.name]?.cancel();

    // Initialize listener before sending ping
    final Completer<void> completer = Completer<void>();
    final subscription = client.onEvent.stream.listen((eventUpdate) {
      if (eventUpdate.content['sender']?.contains(socialNetwork.chatBot)) {
        _onNewPingMessage(
          roomBot,
          socialNetwork,
          patterns,
          completer,
        );
      }
    });

    // Storing the listener in the map
    _pingSubscriptions[socialNetwork.name] = subscription;

    try {
      final successSendingPing = await _sendPingMessage(roomBot, socialNetwork);
      if (!successSendingPing) {
        _handleError(socialNetwork, ConnectionError.messageSendingFailed);
        return;
      }

      await Future.delayed(const Duration(seconds: 2));

      // Wait for the ping response
      await _processPingResponse(socialNetwork, completer);
    } catch (e) {
      Logs().v("Error processing ping response: ${e.toString()}");
      _handleError(socialNetwork, ConnectionError.unknown);
    } finally {
      subscription.cancel();
    }
  }

  /// Handle refresh action for social networks
  Future<void> handleRefresh() async {
    setState(() {
      for (final network in socialNetworks) {
        continueProcess = true;
        network.loading = true;
        network.connected = false;
        network.error = false;
      }
    });

    await Future.wait(socialNetworks.where((network) => network.available).map((network) {
      if (network.apiBridge) {
        // Calling up the ping API function for Messenger
        return pingBridgeAPI(network);
      } else {
        // Continue with existing function for other networks
        return pingSocialNetwork(network);
      }
    }));
  }

  /// Process the ping response from a social network
  Future<void> _processPingResponse(
      SocialNetwork socialNetwork, Completer<void> completer) async {
    final timer = Timer(const Duration(seconds: 30), () {
      if (!completer.isCompleted) {
        completer.completeError(ConnectionError.timeout);
      }
    });

    try {
      await completer.future;
    } catch (e) {
      Logs().v(
          "Timeout reached, setting result to 'error to ${socialNetwork.name}'");
      _handleError(socialNetwork, ConnectionError.timeout);
    } finally {
      timer.cancel();
    }
  }

  Future<void> _onNewPingMessage(
    Room roomBot,
    SocialNetwork socialNetwork,
    RegExpPingPatterns patterns,
    Completer<void> completer,
  ) async {
    if (kDebugMode) {
      print("social network: $socialNetwork");
    }

    final lastEvent = roomBot.lastEvent?.text;

    if (kDebugMode) {
      print("lastest message: $lastEvent");
    }

    if (isOnline(patterns.onlineMatch, lastEvent!)) {
      Logs().v("You're logged to ${socialNetwork.name}");
      _updateNetworkStatus(socialNetwork, true, false);
      if (!completer.isCompleted) {
        completer.complete();
      }
    } else if (isNotLogged(
        patterns.notLoggedMatch, lastEvent, patterns.notLoggedAnymoreMatch)) {
      Logs().v('Not connected to ${socialNetwork.name}');
      _updateNetworkStatus(socialNetwork, false, false);
      if (!completer.isCompleted) {
        completer.complete();
      }
    } else if (shouldReconnect(patterns.mQTTNotMatch, lastEvent)) {
      roomBot.sendTextEvent("reconnect");
    } else  // For Instagram/Facebook Messenger cases
    if (socialNetwork.name == "Instagram" || socialNetwork.name == "Facebook Messenger") {
      if (hasUserInfoPattern(lastEvent)){
        _updateNetworkStatus(socialNetwork, true, false);
      }else{
        Logs().v('Not connected to ${socialNetwork.name}');
        _updateNetworkStatus(socialNetwork, false, false);
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
      if (!completer.isCompleted) {
        completer.complete();
      }
    }
  }

  /// Send a ping message to the bot
  Future<bool> _sendPingMessage(
      Room roomBot, SocialNetwork socialNetwork) async {
    try {
      switch (socialNetwork.name) {
        case "Instagram":
        case "Facebook Messenger":
          await roomBot.sendTextEvent("list-logins");
          break;
        case "Linkedin":
          await roomBot.sendTextEvent("whoami");
          break;
        default:
          await roomBot.sendTextEvent("ping");
      }
      return true;
    } on MatrixException catch (exception) {
      final messageError = exception.errorMessage;
      showCatchErrorDialog(context, messageError);
      return false;
    }
  }

  /// Update the status of a social network
  void _updateNetworkStatus(
      SocialNetwork socialNetwork, bool isConnected, bool isError) {
    setState(() {
      socialNetwork.connected = isConnected;
      socialNetwork.loading = false;
      socialNetwork.error = isError;
    });
  }

  /// Error handling method with a default error type
  void _handleError(SocialNetwork socialNetwork,
      [ConnectionError error = ConnectionError.unknown, String? lastMessage]) {
    setState(() {
      socialNetwork.setError(true);
    });

    String errorMessage;

    switch (error) {
      case ConnectionError.roomNotFound:
        errorMessage = 'Room not found';
        break;
      case ConnectionError.directChatCreationFailed:
        errorMessage = 'Failed to create direct chat';
        break;
      case ConnectionError.messageSendingFailed:
        errorMessage = 'Failed to send message';
        break;
      case ConnectionError.timeout:
        errorMessage = 'Operation timed out';
        break;
      case ConnectionError.unknown:
      default:
        errorMessage = 'An unknown error occurred';
        break;
    }

    Logs().v(errorMessage);

    if (lastMessage != null) {
      showCatchErrorDialog(
          context, "${L10n.of(context)!.errorSendUsProblem} $lastMessage");
    } else {
      showCatchErrorDialog(context,
          "${L10n.of(context)!.errorConnectionText}.\n\n${L10n.of(context)!.errorSendUsProblem} $errorMessage");
    }
  }

  /// Disconnect from a social network
  Future<void> disconnectBridgeApi(
      BuildContext context,
      SocialNetwork network,
      ConnectionStateModel connectionState,
      {String loginId = 'all'}
      ) async {
    final userId = client.userID;
    final logoutUrl = '/${network.apiPath}/provision/v3/logout/$loginId?user_id=$userId';

    Future.microtask(() {
      connectionState.updateConnectionTitle(L10n.of(context)!.loadingDisconnectionDemand);
    });

    try {
      final response = await dio.post(logoutUrl);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Successful disconnection for ${network.name}");
        }
        setState(() => network.updateConnectionResult(false));
      } else {
        _handleError(network, ConnectionError.unknown, "Disconnection error: ${response.statusCode}");
      }
    } catch (error) {
      _handleError(network, ConnectionError.unknown, "Disconnection error: $error");
    } finally {
      Future.microtask(() {
        connectionState.reset();
      });
    }
  }

  Future<void> disconnectFromNetwork(BuildContext context,
      SocialNetwork network, ConnectionStateModel connectionState) async {
    final String botUserId = '${network.chatBot}$hostname';
    final SocialNetworkEnum? networkEnum = getSocialNetworkEnum(network.name);

    Future.microtask(() {
      connectionState
          .updateConnectionTitle(L10n.of(context)!.loadingDisconnectionDemand);
    });

    final Map<String, RegExp> patterns = getLogoutNetworkPatterns(networkEnum!);
    final String eventName = _getEventName(network.name);

    final String? directChat = await _getOrCreateDirectChat(botUserId);
    if (directChat == null) {
      throw ConnectionError.directChatCreationFailed;
    }

    final Room? roomBot = client.getRoomById(directChat);
    if (roomBot == null) {
      throw ConnectionError.roomNotFound;
    }

    await _sendLogoutEvent(roomBot, eventName);

    await _waitForDisconnection(
        context, network, connectionState, directChat, patterns);
  }

  /// Get the event name for logout based on the social network
  String _getEventName(String networkName) {
    switch (networkName) {
      default:
        return 'logout';
    }
  }

  /// Send a logout event to the bot
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

  /// Wait for the disconnection process to complete
  Future<void> _waitForDisconnection(
      BuildContext context,
      SocialNetwork network,
      ConnectionStateModel connectionState,
      String directChat,
      Map<String, RegExp> patterns) async {
    const int maxIterations = 5;
    int currentIteration = 0;

    bool sentLogoutMessage = false;  // To check if we've already sent the logout message (For Meta)

    while (currentIteration < maxIterations) {
      try {
        final GetRoomEventsResponse response =
        await client.getRoomEvents(directChat, Direction.b, limit: 1);
        final List<MatrixEvent> latestMessages = response.chunk ?? [];

        if (latestMessages.isNotEmpty) {
          final MatrixEvent latestEvent = latestMessages.first;
          final String latestMessage = latestEvent.content['body'].toString() ?? '';
          final String sender = latestEvent.senderId;
          final String botUserId = '${network.chatBot}$hostname';

          if (sender == botUserId) {
            // Check for user ID pattern in logout message for Instagram or Facebook Messenger
            if (!sentLogoutMessage && (network.name == "Instagram" || network.name == "Facebook Messenger")) {
              final userId = extractUserId(latestMessage);
              if (userId != null) {
                final room = client.getRoomById(directChat);
                room?.sendTextEvent("logout $userId");
                Logs().v("Sent logout message for user $userId on ${network.name}");
                sentLogoutMessage = true;  // Set the flag to prevent sending the message again
                await Future.delayed(const Duration(seconds: 3));
                continue;  // Skip the rest of the loop to re-check the connection status
              }
            }

            print("latestMessage: $latestMessage");

            // Check if still connected
            if (isStillConnected(latestMessage, patterns)) {
              Logs().v("You're still connected to ${network.name}");
              setState(() => network.updateConnectionResult(true));
              return;
            } else {
              Logs().v("You're disconnected from ${network.name}");
              connectionState.updateConnectionTitle(L10n.of(context)!.loadingDisconnectionSuccess);
              connectionState.updateLoading(false);
              await Future.delayed(const Duration(seconds: 1));
              connectionState.reset();
              setState(() => network.updateConnectionResult(false));
              return;
            }
          }

          await Future.delayed(const Duration(seconds: 3));
        }
      } catch (e) {
        Logs().v('Error in matrix related async function call: $e');
        throw ConnectionError.unknown;
      }
      currentIteration++;
    }

    connectionState.reset();
    throw ConnectionError.timeout;
  }

  /// Delete a conversation with the bot
  Future<void> deleteConversation(BuildContext context, String chatBot,
      ConnectionStateModel connectionState) async {
    final String botUserId = "$chatBot$hostname";

    Future.microtask(() {
      connectionState
          .updateConnectionTitle(L10n.of(context)!.loadingDeleteRoom);
    });

    try {
      final roomId = client.getDirectChatFromUserId(botUserId);
      final room = client.getRoomById(roomId!);

      if (room != null) {
        await room.leave();
        Logs().v('Conversation deleted successfully');

        Future.microtask(() {
          connectionState.updateConnectionTitle(
              L10n.of(context)!.loadingDeleteRoomSuccess);
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

  /// Handle social network action based on its current status
  void handleSocialNetworkAction(SocialNetwork network) async {
    if (!network.loading) {
      if (!network.connected && !network.error) {
        await processSocialNetworkAuthentication(context, network);
      } else if (network.connected && !network.error) {
        try {
          await handleDisconnection(context, network);
        } catch (error) {
          if (error is ConnectionError) {
            _handleError(network, error);
          } else {
            _handleError(network, ConnectionError.unknown);
          }
        }
      }

      if (network.error && !network.connected) {
        setState(() {
          network.loading = true;
        });

        try {
          await pingSocialNetwork(network);
        } catch (error) {
          if (error is ConnectionError) {
            _handleError(network, error);
          } else {
            _handleError(network, ConnectionError.unknown);
          }
        }
      }
    }
  }

  /// Handle connection to a social network
  Future<void> processSocialNetworkAuthentication(
      BuildContext context, SocialNetwork network) async {
    switch (network.name) {
      case "WhatsApp":
        await connectToWhatsApp(context, network, this);
        break;
      case "Instagram":
      case "Facebook Messenger":
      case "Linkedin":
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
    }
  }

  /// Handle disconnection from a social network
  Future<void> handleDisconnection(
      BuildContext context, SocialNetwork network) async {
    final bool success = await showBottomSheetBridge(context, network, this);

    if (success && !network.apiBridge) {
      await deleteConversationDialog(context, network, this);
    }
  }

  // 📌 ***********************************************************************
  // 📌 ************************** Messenger & Instagram **************************
  // 📌 ***********************************************************************

  Future<void> startBridgeLogin(
      BuildContext context,
      WebviewCookieManager cookieManager,
      ConnectionStateModel connectionState,
      SocialNetwork network,
      ) async {
    final flowID = network.flowId;
    final userId = client.userID;

    // Step 1: Start the login process
    final loginStartUrl = '/${network.apiPath}/provision/v3/login/start/$flowID?user_id=$userId';

    try {
      // Initiate the login process
      final startResponse = await dio.post(loginStartUrl);

      if (startResponse.statusCode == 200) {
        final startData = startResponse.data;
        final loginId = startData['login_id'];
        final stepType = startData['type'];
        final stepId = startData['step_id'];

        // Update state if there's a display message
        if (stepType == 'display_and_wait') {
          connectionState.updateConnectionTitle(
            startData['instructions'] ?? 'Waiting for user action...',
          );
        }

        // Step 2: If the next step is user input or cookies, prepare to submit cookies
        if (stepType == 'user_input' || stepType == 'cookies') {
          // Retrieve cookies
          final gotCookies = await cookieManager.getCookies(network.urlRedirect);
          final formattedCookieString = formatCookiesToJsonApi(gotCookies);

          // Submit cookies to the login process step
          final stepUrl = '/${network.apiPath}/provision/v3/login/step/$loginId/$stepId/cookies?user_id=$userId';

          final stepResponse = await dio.post(
            stepUrl,
            data: formattedCookieString,
          );

          if (stepResponse.statusCode == 200) {
            final stepData = stepResponse.data;
            if (stepData['type'] == 'complete') {
              setState(() => network.updateConnectionResult(true));
              if (kDebugMode) {
                print('Login successful for ${network.name}');
              }
            } else {
              network.setError(true);
              if (kDebugMode) {
                print('Unexpected response: ${stepData['type']}');
              }
            }
          } else {
            network.setError(true);
            if (kDebugMode) {
              print('Error submitting step: ${stepResponse.statusCode}');
            }
          }
        } else {
          network.setError(true);
          if (kDebugMode) {
            print('Unexpected step type: $stepType');
          }
        }
      } else {
        network.setError(true);
        if (kDebugMode) {
          print('Login initiation failed with status: ${startResponse.statusCode}');
        }
      }
    } catch (error) {
      network.setError(true);
      if (kDebugMode) {
        print('Error during login process: $error');
      }
    } finally {
      Future.microtask(() {
        connectionState.reset();
      });
    }
  }

  /// Create a bridge for Messenger & Instagram using cookies
  Future<void> createBridgeMeta(
      BuildContext context,
      WebviewCookieManager cookieManager,
      ConnectionStateModel connectionState,
      SocialNetwork network) async {
    final String botUserId = '${network.chatBot}$hostname';

    Future.microtask(() {
      connectionState
          .updateConnectionTitle(L10n.of(context)!.loadingDemandToConnect);
    });

    final gotCookies = await cookieManager.getCookies(network.urlRedirect);

    if (kDebugMode) {
      print("cookies: $gotCookies");
    }

    final formattedCookieString =
        formatCookiesToJsonString(gotCookies, network);

    if (kDebugMode) {
      print("formattedCookie: $formattedCookieString");
    }

    final RegExp successMatch = LoginRegex.facebookSuccessMatch;
    final RegExp alreadyConnected = LoginRegex.facebookAlreadyConnectedMatch;
    final RegExp pasteCookie = LoginRegex.loginUrlMetaMatch;

    final String? directChat = await _getOrCreateDirectChat(botUserId);
    if (directChat == null) {
      _handleError(network, ConnectionError.directChatCreationFailed);
      return;
    }

    final Room? roomBot = client.getRoomById(directChat);
    if (roomBot == null) {
      _handleError(network, ConnectionError.roomNotFound);
      return;
    }

    final completer = Completer<String>();
    final timer = Timer(const Duration(seconds: 20), () {
      if (!completer.isCompleted) {
        completer.completeError(ConnectionError.timeout);
      }
    });

    String? lastMessage;
    StreamSubscription? subscription;
    subscription = client.onEvent.stream.listen((eventUpdate) {
      if (eventUpdate.content['sender']?.contains(network.chatBot)) {
        lastMessage = _onNewMessage(
          roomBot,
          botUserId,
          formattedCookieString,
          pasteCookie,
          successMatch,
          alreadyConnected,
          connectionState,
          network,
          completer,
        );
      }
    });

    try {
      await roomBot.sendTextEvent("login");

      Future.microtask(() {
        connectionState
            .updateConnectionTitle(L10n.of(context)!.loadingVerification);
      });

      final result = await completer.future;
      Logs().v("Result: $result");
    } catch (e) {
      Logs().v(
          "Maximum iterations reached, setting result to 'error to ${network.name}'");
      _handleError(
          network, ConnectionError.unknown, lastMessage ?? e.toString());
    } finally {
      timer.cancel();
      await subscription
          .cancel(); // Cancel the subscription to avoid memory leaks
      Future.microtask(() {
        connectionState.reset();
      });
    }
  }

  bool cookiesSent = false;

  String? _onNewMessage(
      Room roomBot,
      String botUserId,
      String formattedCookieString,
      RegExp pasteCookie,
      RegExp successMatch,
      RegExp alreadyConnected,
      ConnectionStateModel connectionState,
      SocialNetwork network,
      Completer<void> completer) {
    final lastEvent = roomBot.lastEvent;
    final lastMessage = lastEvent?.text;

    if (lastEvent != null && lastEvent.senderId == botUserId) {
      if (pasteCookie.hasMatch(lastMessage!) && !cookiesSent) {
        roomBot.sendTextEvent(formattedCookieString);
        cookiesSent = true;
      } else if (alreadyConnected.hasMatch(lastMessage)) {
        Logs().v("Already Connected to ${network.name}");

        setState(() => network.updateConnectionResult(true));
        connectionState.updateConnectionTitle(L10n.of(context)!.connected);
        connectionState.updateLoading(false);
        connectionState.reset();

        if (!completer.isCompleted) {
          completer.complete(lastMessage);
        }
      } else if (successMatch.hasMatch(lastMessage)) {
        Logs().v("You're logged to ${network.name}");

        cookiesSent = false;

        setState(() => network.updateConnectionResult(true));

        connectionState.updateConnectionTitle(L10n.of(context)!.connected);
        connectionState.updateLoading(false);
        connectionState.reset();

        if (!completer.isCompleted) {
          completer.complete(lastMessage);
        }
      }
    }
    return lastMessage;
  }

  // 📌 ***********************************************************************
  // 📌 ************************** WhatsApp **************************
  // 📌 ***********************************************************************

  /// Create a bridge for WhatsApp
  Future<WhatsAppResult> createBridgeWhatsApp(BuildContext context,
      String phoneNumber, ConnectionStateModel connectionState) async {
    final SocialNetwork? whatsAppNetwork =
        SocialNetworkManager.fromName("WhatsApp");
    if (whatsAppNetwork == null) {
      throw Exception("WhatsApp network not found");
    }

    final String botUserId = '${whatsAppNetwork.chatBot}$hostname';

    Future.microtask(() {
      connectionState
          .updateConnectionTitle(L10n.of(context)!.loadingDemandToConnect);
    });

    final RegExp successMatch = LoginRegex.whatsAppSuccessMatch;
    final RegExp alreadySuccessMatch = LoginRegex.whatsAppAlreadySuccessMatch;
    final RegExp meansCodeMatch = LoginRegex.whatsAppMeansCodeMatch;
    final RegExp timeOutMatch = LoginRegex.whatsAppTimeoutMatch;

    final String? directChat = await _getOrCreateDirectChat(botUserId);
    if (directChat == null) {
      return _handleErrorAndReturnResult(whatsAppNetwork);
    }

    final Room? roomBot = client.getRoomById(directChat!);
    if (roomBot == null) {
      return _handleErrorAndReturnResult(whatsAppNetwork);
    }

    await Future.delayed(const Duration(seconds: 1));

    Future.microtask(() {
      connectionState
          .updateConnectionTitle(L10n.of(context)!.loadingVerificationNumber);
    });

    await roomBot.sendTextEvent("login $phoneNumber");
    await Future.delayed(const Duration(seconds: 5));

    return await _fetchWhatsAppLoginResult(roomBot, successMatch,
        alreadySuccessMatch, meansCodeMatch, timeOutMatch);
  }

  /// Handle error and return result for WhatsApp
  WhatsAppResult _handleErrorAndReturnResult(SocialNetwork network) {
    _handleError(network);
    return WhatsAppResult("error", "", "");
  }

  /// Fetch the login result for WhatsApp
  Future<WhatsAppResult> _fetchWhatsAppLoginResult(
      Room roomBot,
      RegExp successMatch,
      RegExp alreadySuccessMatch,
      RegExp meansCodeMatch,
      RegExp timeOutMatch) async {
    while (true) {
      final GetRoomEventsResponse response =
          await client.getRoomEvents(roomBot.id, Direction.b, limit: 2);
      final List<MatrixEvent> latestMessages = response.chunk ?? [];

      if (latestMessages.isNotEmpty) {
        final String oldestMessage =
            latestMessages.last.content['body'].toString() ?? '';
        final String latestMessage =
            latestMessages.first.content['body'].toString() ?? '';

        if (successMatch.hasMatch(latestMessage) ||
            alreadySuccessMatch.hasMatch(latestMessage)) {
          Logs().v("You're logged to WhatsApp");
          return WhatsAppResult("success", "", "");
        } else if (meansCodeMatch.hasMatch(oldestMessage)) {
          Logs().v("scanTheCode");

          final RegExp regExp = RegExp(r"\*\*(.*?)\*\*");
          final Match? match = regExp.firstMatch(oldestMessage);
          final String? code = match?.group(1);

          return WhatsAppResult("scanTheCode", code, latestMessage);
        } else if (timeOutMatch.hasMatch(latestMessage)) {
          Logs().v("Login timed out");
          return WhatsAppResult("loginTimedOut", "", "");
        }
      }

      await Future.delayed(const Duration(seconds: 2));
    }
  }

  /// Checks and processes the last message received for WhatsApp
  Future<String> fetchDataWhatsApp() async {
    final SocialNetwork? whatsAppNetwork =
        SocialNetworkManager.fromName("WhatsApp");
    if (whatsAppNetwork == null) {
      throw Exception("WhatsApp network not found");
    }

    final String botUserId = '${whatsAppNetwork.chatBot}$hostname';

    final RegExp successMatch = LoginRegex.whatsAppSuccessMatch;
    final RegExp timeOutMatch = LoginRegex.whatsAppTimeoutMatch;

    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Completer<String> completer = Completer<String>();

    StreamSubscription? subscription;
    subscription = client.onEvent.stream.listen((eventUpdate) {
      if (eventUpdate.content['sender']?.contains(whatsAppNetwork.chatBot)) {
        _onWhatsAppMessage(
          directChat!,
          botUserId,
          successMatch,
          timeOutMatch,
          whatsAppNetwork,
          completer,
        );
      }
    });

    try {
      final result = await completer.future;
      return result;
    } finally {
      await subscription
          .cancel(); // Cancel the subscription to avoid memory leaks
    }
  }

  /// Check last received message for WhatsApp
  void _onWhatsAppMessage(
      String directChat,
      String botUserId,
      RegExp successMatch,
      RegExp timeOutMatch,
      SocialNetwork whatsAppNetwork,
      Completer<String> completer) {
    final Room? roomBot = client.getRoomById(directChat);
    if (roomBot == null) {
      if (!completer.isCompleted) {
        completer.completeError(ConnectionError.roomNotFound);
      }
      return;
    }

    final lastEvent = roomBot.lastEvent;
    final lastMessage = lastEvent?.text;
    final senderId = lastEvent?.senderId;

    if (lastEvent != null && senderId == botUserId) {
      if (successMatch.hasMatch(lastMessage!)) {
        Logs().v("You're logged to WhatsApp");

        setState(() => whatsAppNetwork.connected = true);
        if (!completer.isCompleted) {
          completer.complete("success");
        }
      } else if (timeOutMatch.hasMatch(lastMessage)) {
        Logs().v("Login timed out");

        if (!completer.isCompleted) {
          completer.complete("loginTimedOut");
        }
      }
    }
  }

  // 📌 ***********************************************************************
  // 📌 ************************** LinkedIn **************************
  // 📌 ***********************************************************************

  /// Create a bridge for LinkedIn using cookies
  Future<void> createBridgeLinkedin(
      BuildContext context,
      WebviewCookieManager cookieManager,
      ConnectionStateModel connectionState,
      SocialNetwork network) async {
    final String botUserId = '${network.chatBot}$hostname';

    Future.microtask(() {
      connectionState
          .updateConnectionTitle(L10n.of(context)!.loadingDemandToConnect);
    });

    final gotCookies = await cookieManager.getCookies(network.urlRedirect);

    if (kDebugMode) {
      print("cookies: $gotCookies");
    }

    final formattedCookieString =
        formatCookiesToJsonString(gotCookies, network);

    if (kDebugMode) {
      print("formatCookies: $formatCookiesToJsonString");
    }

    final RegExp successMatch = LoginRegex.linkedinSuccessMatch;
    final RegExp alreadySuccessMatch = LoginRegex.linkedinAlreadySuccessMatch;

    final String? directChat = await _getOrCreateDirectChat(botUserId);
    if (directChat == null) {
      _handleError(network, ConnectionError.directChatCreationFailed);
      return;
    }

    final Room? roomBot = client.getRoomById(directChat);
    if (roomBot == null) {
      _handleError(network, ConnectionError.roomNotFound);
      return;
    }

    final completer = Completer<String>();
    final timer = Timer(const Duration(seconds: 20), () {
      if (!completer.isCompleted) {
        completer.completeError(ConnectionError.timeout);
      }
    });

    String? lastMessage;
    StreamSubscription? subscription;
    subscription = client.onEvent.stream.listen((eventUpdate) {
      if (eventUpdate.content['sender']?.contains(network.chatBot)) {
        lastMessage = _onLinkedInMessage(
          roomBot,
          botUserId,
          successMatch,
          alreadySuccessMatch,
          connectionState,
          network,
          completer,
        );
      }
    });

    try {
      await roomBot.sendTextEvent("login $formattedCookieString");

      Future.microtask(() {
        connectionState
            .updateConnectionTitle(L10n.of(context)!.loadingVerification);
      });

      final result = await completer.future;
      Logs().v("Result: $result");
    } catch (e) {
      Logs().v(
          "Maximum iterations reached, setting result to 'error to ${network.name}'");
      _handleError(
          network, ConnectionError.unknown, lastMessage ?? e.toString());
    } finally {
      timer.cancel();
      await subscription
          .cancel(); // Cancel the subscription to avoid memory leaks
      Future.microtask(() {
        connectionState.reset();
      });
    }
  }

  String? _onLinkedInMessage(
      Room roomBot,
      String botUserId,
      RegExp successMatch,
      RegExp alreadySuccessMatch,
      ConnectionStateModel connectionState,
      SocialNetwork network,
      Completer<String> completer) {
    final lastEvent = roomBot.lastEvent;
    final lastMessage = lastEvent?.text;

    final senderId = lastEvent?.senderId;
    if (lastEvent != null && senderId == botUserId) {
      if (successMatch.hasMatch(lastMessage!) ||
          alreadySuccessMatch.hasMatch(lastMessage)) {
        Logs().v("You're logged to Linkedin");

        if (!completer.isCompleted) {
          completer.complete(lastMessage);
        }

        Future.microtask(() {
          connectionState.updateConnectionTitle(L10n.of(context)!.connected);
          connectionState.updateLoading(false);
        });

        setState(() => network.updateConnectionResult(true));
      }
    }
    return lastMessage;
  }

  @override
  Widget build(BuildContext context) => AddBridgeBody(controller: this);
}
