import 'dart:async';

import 'package:tawkie/pages/add_bridge/error_message_dialog.dart';
import 'package:tawkie/pages/add_bridge/model/social_network.dart';
import 'package:tawkie/pages/add_bridge/service/reg_exp_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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

  // Send Message Function
  Future<String> sendMessageToBot(String bot, String contentMessage) async {
    final String botUserId = '$bot$hostname';

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    // Send the "contentMessage" message to the bot
    await roomBot?.sendTextEvent(contentMessage.toString());
    await Future.delayed(const Duration(seconds: 5)); // Wait sec

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
      await Future.delayed(const Duration(seconds: 5)); // Wait sec

      if (result != '' && result != contentMessage) {
        break;
      } else {
        currentIteration++;
      }
    }

    if (currentIteration == maxIterations) {
      print("Maximum iterations reached, setting result to 'error'");

      result = 'error';
    } else if (!continueProcess) {
      print(('ping stoping'));
      result = 'stop';
    }

    return result;
  }

  // Ping function for each bot
  Future<String> pingSocialNetwork(SocialNetwork socialNetwork) async {
    final String botUserId = '${socialNetwork.chatBot}$hostname';

    // Messages to spot when we're online
    RegExp? onlineMatch;
    RegExp? successfullyMatch;
    RegExp? alreadySuccessMatch;

    // Messages to spot when we're not online
    RegExp? notLoggedMatch;
    RegExp? disconnectMatch;
    RegExp? connectedButNotLoggedMatch;

    switch (socialNetwork.name) {
      case "WhatsApp":
        onlineMatch = PingPatterns.whatsAppOnlineMatch;
        successfullyMatch = PingPatterns.whatsAppSuccessfullyMatch;
        alreadySuccessMatch = PingPatterns.whatsAppAlreadySuccessMatch;
        notLoggedMatch = PingPatterns.whatsAppNotLoggedMatch;
        disconnectMatch = PingPatterns.whatsAppDisconnectMatch;
        connectedButNotLoggedMatch =
            PingPatterns.whatsAppConnectedButNotLoggedMatch;
        break;
      case "Facebook Messenger":
        onlineMatch = PingPatterns.facebookOnlineMatch;
        successfullyMatch = PingPatterns.facebookSuccessfullyMatch;
        notLoggedMatch = PingPatterns.facebookNotLoggedMatch;
        disconnectMatch = PingPatterns.facebookDisconnectMatch;
        break;
      case "Instagram":
        onlineMatch = PingPatterns.instagramOnlineMatch;
        successfullyMatch = PingPatterns.instagramSuccessfullyMatch;
        alreadySuccessMatch = PingPatterns.instagramAlreadySuccessMatch;
        notLoggedMatch = PingPatterns.instagramNotLoggedMatch;
        disconnectMatch = PingPatterns.instagramDisconnectMatch;
        break;
      default:
        throw Exception("Unsupported social network: ${socialNetwork.name}");
    }

    // Add a direct chat with the bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    // Send the "ping" message to the bot
    await roomBot?.sendTextEvent("ping");
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
        if (onlineMatch.hasMatch(latestMessage) ||
            alreadySuccessMatch?.hasMatch(latestMessage) == true ||
            successfullyMatch.hasMatch(latestMessage) == true) {
          print("You're logged to ${socialNetwork.name}");

          result = 'Connected';

          break; // Exit the loop if the bridge is connected
        } else if (notLoggedMatch.hasMatch(latestMessage) == true ||
            disconnectMatch.hasMatch(latestMessage) == true ||
            connectedButNotLoggedMatch?.hasMatch(latestMessage) == true) {
          print('Not connected to ${socialNetwork.name}');

          result = 'Not Connected';

          break; // Exit the loop if the bridge is disconnected
        }
      }
      currentIteration++;
    }

    if (currentIteration == maxIterations) {
      print(
          "Maximum iterations reached, setting result to 'error to ${socialNetwork.name}'");

      result = 'error';
    } else if (!continueProcess) {
      print(('ping stopping'));
      result = 'stop';
    }

    return result;
  }

  // Function to logout
  Future<String> disconnectFromNetwork(SocialNetwork network) async {
    final String botUserId = '${network.chatBot}$hostname';

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
      default:
        throw ArgumentError('Unsupported network: ${network.name}');
    }

    // Add a direct chat with the network bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    // Send the "logout" message to the bot
    await roomBot?.sendTextEvent("logout");
    await Future.delayed(const Duration(seconds: 5)); // Wait 5 sec

    String result =
        "Connected"; // Variable to track the result of the connection

    // variable for loop limit
    const int maxIterations = 5;
    int currentIteration = 0;

    while (currentIteration < maxIterations) {
      final GetRoomEventsResponse response = await client.getRoomEvents(
        directChat,
        Direction.b, // To get the latest messages
        limit: 1, // Number of messages to obtain
      );

      final List<MatrixEvent> latestMessages = response.chunk ?? [];

      if (latestMessages.isNotEmpty) {
        final String latestMessage =
            latestMessages.first.content['body'].toString() ?? '';

        // to find out if we're connected
        if (!successMatch.hasMatch(latestMessage) &&
            !alreadyLogoutMatch.hasMatch(latestMessage)) {
          print("You're always connected to ${network.name}");
          result = 'Connected';
          break;
        } else if (successMatch.hasMatch(latestMessage) ||
            alreadyLogoutMatch.hasMatch(latestMessage)) {
          print("You're disconnected to ${network.name}");
          result = 'Not Connected';
          break; // Exit the loop if bridge is disconnected
        }
      }
      currentIteration++;
    }

    if (currentIteration == maxIterations) {
      print("Maximum iterations reached, setting result to 'error'");
      result = 'error';
    }

    return result;
  }

  // Instagram
  // Function for create and login bridge with instagram bot
  Future<String> createBridgeInstagram(String username, String password) async {
    final String botUserId = '@instagrambot:$hostname';

    // Success phrases to spot
    final RegExp successMatch = LoginRegex.instagramSuccessMatch;
    final RegExp alreadySuccessMatch = LoginRegex.instagramAlreadySuccessMatch;

    // Error phrase to spot
    final RegExp usernameErrorMatch = LoginRegex.instagramUsernameErrorMatch;
    final RegExp passwordErrorMatch = LoginRegex.instagramPasswordErrorMatch;
    final RegExp nameOrPasswordErrorMatch =
        LoginRegex.instagramNameOrPasswordErrorMatch;
    final RegExp rateLimitErrorMatch = LoginRegex.instagramRateLimitErrorMatch;

    // Code request message for two-factor identification
    final RegExp twoFactorMatch = LoginRegex.instagramTwoFactorMatch;

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    // Send the "login" message to the bot
    await roomBot?.sendTextEvent("login $username $password");
    await Future.delayed(const Duration(seconds: 5)); // Wait 5 sec

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
          print("You're logged to Instagram");

          result = "success";

          break; // Exit the loop once the "login" message has been sent and is success
        } else if (twoFactorMatch.hasMatch(latestMessage)) {
          print("Authenticator two factor demand");

          result = "twoFactorDemand";

          break;
        } else if (!successMatch.hasMatch(latestMessage) &&
                usernameErrorMatch.hasMatch(latestMessage) ||
            nameOrPasswordErrorMatch.hasMatch(latestMessage)) {
          print("Login cannot be found");

          result = "errorUsername";

          break;
        } else if (passwordErrorMatch.hasMatch(latestMessage)) {
          print("Password incorrect");

          result = "errorPassword";

          break;
        } else if (rateLimitErrorMatch.hasMatch(latestMessage)) {
          print("rate limit error");

          result = "rateLimitError";

          break;
        }
      }
      await Future.delayed(const Duration(seconds: 5)); // Wait 5 sec
      currentIteration++;
    }

    if (currentIteration == maxIterations) {
      print("Maximum iterations reached, setting result to 'error'");

      result = 'error';
    }

    return result;
  }

  // To disconnect from Instagram
  Future<String> disconnectToInstagram() async {
    final String botUserId = '@instagrambot:$hostname';

    final RegExp successMatch = RegExp(r"Successfully logged out");
    final RegExp alreadyLogoutMatch =
        RegExp(r"That command requires you to be logged in.");

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    // Send the "logout" message to the bot
    await roomBot?.sendTextEvent("logout");
    await Future.delayed(const Duration(seconds: 5)); // Wait 5 sec

    String result =
        "Connected"; // Variable to track the result of the connection

    // variable for loop limit
    const int maxIterations = 5;
    int currentIteration = 0;

    while (currentIteration < maxIterations) {
      // Get the latest messages from the room (limited to the specified number)
      final GetRoomEventsResponse response = await client.getRoomEvents(
        directChat,
        Direction.b, // To get the latest messages
        limit: 1, // Number of messages to obtain
      );

      final List<MatrixEvent> latestMessages = response.chunk ?? [];

      if (latestMessages.isNotEmpty) {
        final String latestMessage =
            latestMessages.first.content['body'].toString() ?? '';

        // to find out if we're connected
        if (!successMatch.hasMatch(latestMessage) &&
            !alreadyLogoutMatch.hasMatch(latestMessage)) {
          print("You're always connected to Instagram");
          result = 'Connected';
          break;
        } else if (successMatch.hasMatch(latestMessage) ||
            alreadyLogoutMatch.hasMatch(latestMessage)) {
          print("You're disconnected to Instagram");

          result = 'Not Connected';
          break; // Exit the loop if bridge is connected
        }
      }
      currentIteration++;
    }

    if (currentIteration == maxIterations) {
      print("Maximum iterations reached, setting result to 'error'");

      result = 'error';
    }

    return result;
  }

  // WhatsApp
  // Function for create and login bridge with bot ti WhatsApp
  Future<WhatsAppResult> createBridgeWhatsApp(
    String phoneNumber,
  ) async {
    final String botUserId = '@whatsappbot:$hostname';

    // Success phrases to spot
    final RegExp successMatch = LoginRegex.whatsAppSuccessMatch;
    final RegExp alreadySuccessMatch = LoginRegex.whatsAppAlreadySuccessMatch;

    // Message of means of connexion
    final RegExp meansCodeMatch = LoginRegex.whatsAppMeansCodeMatch;

    // Error phrase to spot
    final RegExp timeOutMatch = LoginRegex.whatsAppTimeoutMatch;

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    // Send the "login" message to the bot
    await roomBot?.sendTextEvent("login $phoneNumber");
    await Future.delayed(const Duration(seconds: 5)); // Wait 5 sec

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
          print("You're logged to WhatsApp");

          result = WhatsAppResult("success", "", "");

          break; // Exit the loop once the "login" message has been sent and is success
        } else if (!successMatch.hasMatch(latestMessage) &&
            meansCodeMatch.hasMatch(oldestMessage)) {
          print("scanTheCode");

          // To note the simple code between the ** of the message
          final RegExp regExp = RegExp(r"\*\*(.*?)\*\*");
          final Match? match = regExp.firstMatch(oldestMessage);
          final code = match?.group(1);

          result = WhatsAppResult("scanTheCode", code, latestMessage);

          break;
        } else if (timeOutMatch.hasMatch(latestMessage)) {
          print("Login timed out");

          result = WhatsAppResult("loginTimedOut", "", "");

          break;
        }
      }
    }
    return result;
  }

  Future<String> fetchDataWhatsApp() async {
    print("Starting fetchDataWhatsApp");

    print("ContinuProgress is:$continueProcess");
    const String botUserId = '@whatsappbot:loveto.party';

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
        limit: 2, // Number of messages to obtain
      );

      final List<MatrixEvent> latestMessages = response.chunk ?? [];

      final String latestMessage =
          latestMessages.first.content['body'].toString() ?? '';

      if (latestMessages.isNotEmpty) {
        if (successMatch.hasMatch(latestMessage)) {
          print("You're logged to WhatsApp");

          result = "success";

          break; // Exit the loop once the "login" message has been sent and is success
        } else if (timeOutMatch.hasMatch(latestMessage)) {
          print("Login timed out");

          result = "loginTimedOut";

          break;
        } else if (!successMatch.hasMatch(latestMessage) &&
            !timeOutMatch.hasMatch(latestMessage)) {
          print("waiting");
          await Future.delayed(const Duration(seconds: 2)); // Wait 5 sec
        }
      }

      if (continueProcess == false) {
        print("Stop listening");
        result = "Stop Listening";
      }
    }
    return result;
  }

  //Facebook Messenger
  // Function to login Facebook
  Future<String> createBridgeFacebook(String username, String password) async {
    final String botUserId = '@facebookbot:$hostname';

    // Success phrases to spot
    final RegExp sendPassword = LoginRegex.facebookSendPasswordMatch;

    // Code request message for two-factor identification
    final RegExp twoFactorMatch = LoginRegex.facebookTwoFactorMatch;

    // Error phrases to spot
    final RegExp nameOrPasswordErrorMatch =
        LoginRegex.facebookNameOrPasswordErrorMatch;
    final RegExp rateLimitErrorMatch = LoginRegex.facebookRateLimitErrorMatch;

    final RegExp alreadyConnected = LoginRegex.facebookAlreadyConnectedMatch;

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    String result = ""; // Variable to track the result of the connection

    // Send the "login" message to the bot
    await roomBot?.sendTextEvent("login $username");
    await Future.delayed(const Duration(seconds: 5)); // Wait 5 sec

    // Variable for loop limit
    const int maxIterations = 5;
    int currentIteration = 0;

    // Flag to track whether the password has been sent
    bool passwordSent = false;

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
        if (sendPassword.hasMatch(latestMessage) && !passwordSent) {
          print("Enter Password");

          // Send the password message to the bot
          await roomBot?.sendTextEvent(password);
          await Future.delayed(const Duration(seconds: 5)); // Wait 5 sec

          // Set the flag to true after sending the password
          passwordSent = true;
        } else if (alreadyConnected.hasMatch(latestMessage)) {
          print("Already Connected to Facebook");
          // Set the result to "twoFactorDemand"
          result = "alreadyConnected";
          break;
        }

        // Continue handling other cases...

        if (twoFactorMatch.hasMatch(latestMessage)) {
          print("Authenticator two-factor demand");

          // Set the result to "twoFactorDemand"
          result = "twoFactorDemand";

          // Exit the loop
          break;
        } else if (nameOrPasswordErrorMatch.hasMatch(latestMessage)) {
          print("Incorrect username or password");

          // Set the result to "errorNameOrPassword"
          result = "errorNameOrPassword";

          // Exit the loop
          break;
        } else if (rateLimitErrorMatch.hasMatch(latestMessage)) {
          print("Rate limit error");

          // Set the result to "rateLimitError"
          result = "rateLimitError";

          // Exit the loop
          break;
        }
      }

      await Future.delayed(const Duration(seconds: 3)); // Wait sec
      currentIteration++;
    }

    if (currentIteration == maxIterations) {
      print("Maximum iterations reached, setting result to 'error'");

      result = 'error';
    }

    return result;
  }

  // Function to delete a conversation with a bot
  Future<void> deleteConversation(String chatBot) async {
    final String botUserId = "$chatBot$hostname";
    try {
      final roomId = client.getDirectChatFromUserId(botUserId);
      final room = client.getRoomById(roomId!);
      if (room != null) {
        await room.leave(); // To leave and delete the room (DirectChat only)
        print('Conversation deleted successfully');
      } else {
        print('Room not found');
      }
    } catch (e) {
      print('Error deleting conversation: $e');
    }
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
      print("Ping timeout");

      // Display error message to warn user
      showCatchErrorDialog(context, L10n.of(context)!.err_timeOut);

      throw TimeoutException("Ping timeout");
    } catch (error) {
      print("Error pinging: $error");
      rethrow;
    }
  }
}
