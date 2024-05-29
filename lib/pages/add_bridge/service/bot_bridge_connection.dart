import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/pages/add_bridge/error_message_dialog.dart';
import 'package:tawkie/pages/add_bridge/model/social_network.dart';
import 'package:tawkie/pages/add_bridge/service/reg_exp_pattern.dart';
import 'package:tawkie/widgets/notifier_state.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

// For all bot bridge conversations
class BotBridgeConnection {
  Client client;
  String hostname;
  bool continueProcess = true;

  BotBridgeConnection({
    required this.client,
    required this.hostname,
  });

  final StreamController<Map<String, dynamic>> _pingResultsController =
      StreamController<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get pingResults => _pingResultsController.stream;

  // To stop loops (when leaving the page)
  void stopProcess() {
    continueProcess = false;
  }

  Future<void> checkAllSocialNetworksConnections(
    List<SocialNetwork> socialNetwork,
  ) async {
    for (final network in socialNetwork) {
      pingSocialNetwork(network).then((result) {
        _pingResultsController.add({'name': network.name, 'result': result});
      });
    }
  }

  Future<void> checkOnlySocialNetworksConnections(
    SocialNetwork socialNetwork,
  ) async {
    pingSocialNetwork(socialNetwork).then((result) {
      _pingResultsController
          .add({'name': socialNetwork.name, 'result': result});
    });
  }

  // Send Message Function
  Future<String> sendMessageToBot(BuildContext context, String bot,
      String contentMessage, ConnectionStateModel connectionState) async {
    final String botUserId = '$bot$hostname';

    Future.microtask(() {
      connectionState.updateConnectionTitle(L10n.of(context)!.loadingSendCode);
    });

    // Add a direct chat with the bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    await Future.delayed(const Duration(seconds: 1)); // Wait sec

    // Send the "contentMessage" message to the bot
    await roomBot?.sendTextEvent(contentMessage.toString());

    Future.microtask(() {
      connectionState
          .updateConnectionTitle(L10n.of(context)!.loadingVerificationCode);
    });

    await Future.delayed(const Duration(seconds: 3)); // Wait sec

    String result = ''; // Variable to track the result of the connection

    // variable for loop limit
    const int maxIterations = 5;
    int currentIteration = 0;

    while (continueProcess && currentIteration < maxIterations) {
      // To take latest message
      final GetRoomEventsResponse response = await client.getRoomEvents(
        directChat,
        Direction.b, // To get the latest messages
        limit: 1, // Number of messages to obtain
      );

      final List<MatrixEvent> latestMessages = response.chunk ?? [];

      if (latestMessages.isNotEmpty) {
        final String latestMessage =
            latestMessages.first.content['body'].toString() ?? '';

        result = latestMessage;
      }
      await Future.delayed(const Duration(seconds: 2)); // Wait sec

      if (result != '' && result != contentMessage) {
        break;
      } else {
        currentIteration++;
      }
    }

    if (currentIteration == maxIterations) {
      Logs().v("Maximum iterations reached, setting result to 'error'");

      result = 'error';
    } else if (!continueProcess) {
      Logs().v('ping stopping');
      result = 'stop';
    }

    Future.microtask(() {
      connectionState.reset();
    });

    return result;
  }

  // Ping function for each bot
  Future<String> pingSocialNetwork(SocialNetwork socialNetwork) async {
    String botUserId;

    switch (socialNetwork.name) {
      case "Linkedin":
        botUserId = socialNetwork.chatBot;
        break;
      default:
        botUserId = '${socialNetwork.chatBot}$hostname';
    }

    // Messages to spot when we're online
    RegExp? onlineMatch;

    // Messages to spot when we're not online
    RegExp? mQTTNotMatch;

    switch (socialNetwork.name) {
      case "WhatsApp":
        onlineMatch = PingPatterns.whatsAppOnlineMatch;
        mQTTNotMatch = PingPatterns.whatsAppLoggedButNotConnectedMatch;
        break;
      case "Facebook Messenger":
        onlineMatch = PingPatterns.facebookOnlineMatch;
        break;
      case "Instagram":
        onlineMatch = PingPatterns.instagramOnlineMatch;
        break;
      case "Linkedin":
        onlineMatch = PingPatterns.linkedinOnlineMatch;
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
      switch (socialNetwork.name) {
        case "Linkedin":
          await roomBot?.sendTextEvent("whoami");
          break;
        default:
          await roomBot?.sendTextEvent("ping");
      }
    } catch (error) {
      Logs().i('Error: $error');
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

          result = 'Connected';

          break; // Exit the loop if the bridge is connected
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
          Logs().v('Not connected to ${socialNetwork.name}');

          result = 'Not Connected';

          break; // Exit the loop if the bridge is disconnected
        }
      }
      currentIteration++;
    }

    if (currentIteration == maxIterations) {
      Logs().v(
          "Maximum iterations reached, setting result to 'error to ${socialNetwork.name}'");

      result = 'error';
    } else if (!continueProcess) {
      Logs().v(('ping stopping'));
      result = 'stop';
    }

    return result;
  }

  // Function to logout
  Future<String> disconnectFromNetwork(BuildContext context,
      SocialNetwork network, ConnectionStateModel connectionState) async {
    final String? botUserId;

    switch (network.name) {
      case "Linkedin":
        botUserId = network.chatBot;
        break;
      default:
        botUserId = '${network.chatBot}$hostname';
    }

    Future.microtask(() {
      connectionState.updateConnectionTitle(
        L10n.of(context)!.loadingDisconnectionDemand,
      );
    });

    RegExp successMatch;
    RegExp alreadyLogoutMatch;

    switch (network.name) {
      case 'Instagram':
        successMatch = LogoutRegex.instagramSuccessMatch;
        alreadyLogoutMatch = LogoutRegex.instagramAlreadyLogoutMatch;
        break;
      case 'WhatsApp':
        successMatch = LogoutRegex.whatsappSuccessMatch;
        alreadyLogoutMatch = LogoutRegex.whatsappAlreadyLogoutMatch;
        break;
      case 'Facebook Messenger':
        successMatch = LogoutRegex.facebookSuccessMatch;
        alreadyLogoutMatch = LogoutRegex.facebookAlreadyLogoutMatch;
        break;
      case 'Linkedin':
        successMatch = LogoutRegex.linkedinSuccessMatch;
        alreadyLogoutMatch = LogoutRegex.linkedinAlreadyLogoutMatch;
        break;

      default:
        throw ArgumentError('Unsupported network: ${network.name}');
    }

    // Add a direct chat with the network bot (if you haven't already)
    String? directChat;
    try {
      directChat = client.getDirectChatFromUserId(botUserId);
      directChat ??= await client.startDirectChat(botUserId);
    } catch (e) {
      Logs().v('Error getting or starting direct chat: $e');
      // Handle the error, you can log it or return an error message
      return 'error';
    }

    Room? roomBot;
    try {
      roomBot = client.getRoomById(directChat);
    } catch (e) {
      Logs().v('Error getting room by ID: $e');
      // Handle the error, you can log it or return an error message
      return 'error';
    }

    String eventName;

    switch (network.name) {
      case "Facebook Messenger":
        eventName = 'delete-session';
        break;
      case "Instagram":
        eventName = 'delete-session';
        break;
      default:
        eventName = 'logout';
    }

    // Send the "logout" message to the bot
    try {
      await roomBot?.sendTextEvent(eventName);
    } catch (e) {
      Logs().v('Error sending text event: $e');
      // Handle the error, you can log it or return an error message
      return 'error';
    }

    await Future.delayed(const Duration(seconds: 3)); // Wait sec

    String result =
        'Connected'; // Variable to track the result of the connection

    // variable for loop limit
    const int maxIterations = 5;
    int currentIteration = 0;

    while (currentIteration < maxIterations) {
      try {
        final GetRoomEventsResponse response = await client.getRoomEvents(
          directChat,
          Direction.b, // To get the latest messages
          limit: 1, // Number of messages to obtain
        );

        final List<MatrixEvent> latestMessages = response.chunk ?? [];

        if (latestMessages.isNotEmpty) {
          final String latestMessage =
              latestMessages.first.content['body'].toString() ?? '';

          print("latestMessage: $latestMessage");
          // to find out if we're connected
          if (!successMatch.hasMatch(latestMessage) &&
              !alreadyLogoutMatch.hasMatch(latestMessage)) {
            Logs().v("You're always connected to ${network.name}");
            result = 'Connected';
            break;
          } else if (successMatch.hasMatch(latestMessage) ||
              alreadyLogoutMatch.hasMatch(latestMessage)) {
            Logs().v("You're disconnected to ${network.name}");
            result = 'Not Connected';

            Future.microtask(() {
              connectionState.updateConnectionTitle(
                L10n.of(context)!.loadingDisconnectionSuccess,
              );
              connectionState.updateLoading(false);
            });

            await Future.delayed(const Duration(seconds: 1)); // Wait sec

            break; // Exit the loop if bridge is disconnected
          }
        }
      } catch (e) {
        Logs().v('Error in matrix related async function call: $e');
        // Handle the error, you can log it or return an error message
        return 'error';
      }

      currentIteration++;
    }

    if (currentIteration == maxIterations) {
      Logs().v('Maximum iterations reached, setting result to \'error\'');
      result = 'error';
    }

    Future.microtask(() {
      connectionState.reset();
    });

    return result;
  }

  // Instagram
  // Function for create and login bridge with instagram bot
  Future<String> createBridgeInstagram(
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

    final RegExp successMatch = LoginRegex.instagramSuccessMatch;
    final RegExp alreadyConnected = LoginRegex.instagramAlreadySuccessMatch;
    final RegExp pasteCookie = LoginRegex.instagramPasteCookieMatch;

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    String result = ""; // Variable to track the result of the connection

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
      final String latestMessage =
          latestMessages.first.content['body'].toString() ?? '';

      if (latestMessages.isNotEmpty) {
        if (kDebugMode) {
          print('latestMessage : $latestMessage');
        }
        if (pasteCookie.hasMatch(latestMessage)) {
          await roomBot?.sendTextEvent(formattedCookieString);
        } else if (alreadyConnected.hasMatch(latestMessage)) {
          Logs().v("Already Connected to Instagram");
          result = "alreadyConnected";
          break;
        } else if (successMatch.hasMatch(latestMessage)) {
          Logs().v("You're logged to Instagram");

          Future.microtask(() {
            connectionState
                .updateConnectionTitle("Récupération des conversations");
          });
          await Future.delayed(
              const Duration(seconds: 10)); // Wait sec for rooms loading
          await handleNewRoomsSync(context, network);
          result = "success";

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

      result = 'error';
    }

    return result;
  }

  // WhatsApp
  // Function for create and login bridge with bot ti WhatsApp
  Future<WhatsAppResult> createBridgeWhatsApp(BuildContext context,
      String phoneNumber, ConnectionStateModel connectionState) async {
    final String botUserId = '@whatsappbot:$hostname';

    Future.microtask(() {
      connectionState
          .updateConnectionTitle(L10n.of(context)!.loadingDemandToConnect);
    });

    // Success phrases to spot
    final RegExp successMatch = LoginRegex.whatsAppSuccessMatch;
    final RegExp alreadySuccessMatch = LoginRegex.whatsAppAlreadySuccessMatch;

    // Message of means of connexion
    final RegExp meansCodeMatch = LoginRegex.whatsAppMeansCodeMatch;

    // Error phrase to spot
    final RegExp timeOutMatch = LoginRegex.whatsAppTimeoutMatch;

    // Add a direct chat with the bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    await Future.delayed(const Duration(seconds: 1)); // Wait sec

    Future.microtask(() {
      connectionState
          .updateConnectionTitle(L10n.of(context)!.loadingVerificationNumber);
    });
    // Send the "login" message to the bot
    await roomBot?.sendTextEvent("login $phoneNumber");
    await Future.delayed(const Duration(seconds: 5)); // Wait sec

    WhatsAppResult result; // Variable to track the result of the connection

    // Get the latest messages from the room (limited to the specified number)
    while (true) {
      final GetRoomEventsResponse response = await client.getRoomEvents(
        directChat,
        Direction.b, // To get the latest messages
        limit: 2, // Number of messages to obtain
      );

      final List<MatrixEvent> latestMessages = response.chunk ?? [];

      final String oldestMessage =
          latestMessages.last.content['body'].toString() ?? '';

      final String latestMessage =
          latestMessages.first.content['body'].toString() ?? '';

      if (latestMessages.isNotEmpty) {
        if (successMatch.hasMatch(latestMessage) ||
            alreadySuccessMatch.hasMatch(latestMessage)) {
          Logs().v("You're logged to WhatsApp");

          result = WhatsAppResult("success", "", "");

          break; // Exit the loop once the "login" message has been sent and is success
        } else if (!successMatch.hasMatch(latestMessage) &&
            meansCodeMatch.hasMatch(oldestMessage)) {
          Logs().v("scanTheCode");

          // To note the simple code between the ** of the message
          final RegExp regExp = RegExp(r"\*\*(.*?)\*\*");
          final Match? match = regExp.firstMatch(oldestMessage);
          final code = match?.group(1);

          result = WhatsAppResult("scanTheCode", code, latestMessage);

          break;
        } else if (timeOutMatch.hasMatch(latestMessage)) {
          Logs().v("Login timed out");

          result = WhatsAppResult("loginTimedOut", "", "");

          break;
        }
      }
    }
    return result;
  }

  Future<String> fetchDataWhatsApp() async {
    final String botUserId = '@whatsappbot:$hostname';

    // Success phrases to spot
    final RegExp successMatch = LoginRegex.whatsAppSuccessMatch;

    // Error phrase to spot
    final RegExp timeOutMatch = LoginRegex.whatsAppTimeoutMatch;

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    String result =
        "Not logged"; // Variable to track the result of the connection

    // Get the latest messages from the room (limited to the specified message or stopProgress)
    while (continueProcess && true) {
      final GetRoomEventsResponse response = await client.getRoomEvents(
        directChat,
        Direction.b, // To get the latest messages
        limit: 3, // Number of messages to obtain (3 instead of 2)
      );

      final List<MatrixEvent> latestMessages = response.chunk ?? [];

      // Check the last three messages
      for (int i = latestMessages.length - 1; i >= 0; i--) {
        final String messageBody =
            latestMessages[i].content['body'].toString() ?? '';

        if (successMatch.hasMatch(messageBody)) {
          Logs().v("You're logged to WhatsApp");
          result = "success";
          break;
        } else if (timeOutMatch.hasMatch(messageBody)) {
          Logs().v("Login timed out");
          result = "loginTimedOut";
          break;
        } else if (!successMatch.hasMatch(messageBody) &&
            !timeOutMatch.hasMatch(messageBody)) {
          Logs().v("waiting");
          await Future.delayed(const Duration(seconds: 2)); // Wait sec
        }
      }

      if (continueProcess == false) {
        Logs().v("Stop listening");
        result = "Stop Listening";
      }

      if (result != "Not logged") {
        break; // Exit the loop once a result is determined
      }
    }

    return result;
  }

  //Facebook Messenger
  // Function to login Facebook
  Future<String> createBridgeFacebook(
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

    String result = ""; // Variable to track the result of the connection

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
      final String latestMessage =
          latestMessages.first.content['body'].toString() ?? '';

      if (latestMessages.isNotEmpty) {
        if (kDebugMode) {
          print('latestMessage : $latestMessage');
        }
        if (pasteCookie.hasMatch(latestMessage)) {
          await roomBot?.sendTextEvent(formattedCookieString);
        } else if (alreadyConnected.hasMatch(latestMessage)) {
          Logs().v("Already Connected to Facebook");
          result = "alreadyConnected";
          break;
        } else if (successMatch.hasMatch(latestMessage)) {
          Logs().v("You're logged to Messenger");

          Future.microtask(() {
            connectionState
                .updateConnectionTitle("Récupération des conversations");
          });
          await Future.delayed(
              const Duration(seconds: 10)); // Wait sec for rooms loading
          await handleNewRoomsSync(context, network);

          result = "success";

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

      result = 'error';
    }

    return result;
  }

  // Function to delete a conversation with a bot
  Future<void> deleteConversation(BuildContext context, SocialNetwork network,
      ConnectionStateModel connectionState) async {
    String botUserId;
    switch (network.name) {
      case 'Linkedin':
        botUserId = network.chatBot;
        break;
      default:
        botUserId = "${network.chatBot}$hostname";
    }
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

  // Function to manage missed deadlines
  Future<String> pingWithTimeout(
    BuildContext context,
    Future<String> pingFunction,
  ) async {
    try {
      // Future.timeout to define a maximum waiting time
      return await pingFunction.timeout(const Duration(seconds: 15));
    } on TimeoutException {
      Logs().v("Ping timeout");

      // Display error message to warn user
      showCatchErrorDialog(context, L10n.of(context)!.errTimeOut);

      throw TimeoutException("Ping timeout");
    } catch (error) {
      Logs().v("Error pinging: $error");
      rethrow;
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
  Set<String> acceptedInvitations = Set();

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
      print("error: $e");
    }

    // Function to format list cookies
    String formatCookies(List<io.Cookie> cookies) {
      return cookies.map((cookie) {
        return '${cookie.name}="${cookie.value}"';
      }).join('; ');
    }

    // Function to create a LinkedIn connection bridge
    Future<String> createBridgeLinkedin(
        BuildContext context,
        WebviewCookieManager cookieManager,
        ConnectionStateModel connectionState,
        SocialNetwork network) async {
      final String botUserId = network.chatBot;

      Future.microtask(() {
        connectionState
            .updateConnectionTitle(L10n.of(context)!.loadingDemandToConnect);
      });

      final gotCookies = await cookieManager.getCookies(network.urlRedirect);
      final formattedCookieString = formatCookies(gotCookies);

      // Success phrases to spot
      final RegExp successMatch = LoginRegex.linkedinSuccessMatch;
      final RegExp alreadySuccessMatch = LoginRegex.linkedinAlreadySuccessMatch;

      // Add a direct chat with the Instagram bot (if you haven't already)
      String? directChat = client.getDirectChatFromUserId(botUserId);
      directChat ??= await client.startDirectChat(botUserId);

      final Room? roomBot = client.getRoomById(directChat);

      // Send the "login" message to the bot
      await roomBot?.sendTextEvent("login $formattedCookieString");

      await Future.delayed(const Duration(seconds: 3)); // Wait sec

      Future.microtask(() {
        connectionState
            .updateConnectionTitle(L10n.of(context)!.loadingVerification);
      });

      await Future.delayed(const Duration(seconds: 1)); // Wait sec

      String result = ""; // Variable to track the result of the connection

      // variable for loop limit
      const int maxIterations = 5;
      int currentIteration = 0;

      // Get the latest messages from the room (limited to the specified number)
      while (currentIteration < maxIterations) {
        final GetRoomEventsResponse response = await client.getRoomEvents(
          directChat,
          Direction.b, // To get the latest messages
          limit: 1, // Number of messages to obtain
        );

        final List<MatrixEvent> latestMessages = response.chunk ?? [];
        final String latestMessage =
            latestMessages.first.content['body'].toString() ?? '';

        if (latestMessages.isNotEmpty) {
          if (successMatch.hasMatch(latestMessage) ||
              alreadySuccessMatch.hasMatch(latestMessage)) {
            Logs().v("You're logged to Linkedin");

            result = "success";

            Future.microtask(() {
              connectionState
                  .updateConnectionTitle(L10n.of(context)!.connected);
            });

            Future.microtask(() {
              connectionState.updateLoading(false);
            });

            await Future.delayed(const Duration(seconds: 1)); // Wait sec

            break; // Exit the loop once the "login" message has been sent and is success
          }
        }
        await Future.delayed(const Duration(seconds: 5)); // Wait 5 sec
        currentIteration++;
      }

      if (currentIteration == maxIterations) {
        Logs().v("Maximum iterations reached, setting result to 'error'");

        result = 'error';
      }

      Future.microtask(() {
        connectionState.reset();
      });

      return result;
    }
  }
}
