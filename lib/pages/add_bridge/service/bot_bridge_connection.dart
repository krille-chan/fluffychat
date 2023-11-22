import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../error_message_dialog.dart';

// For all bot bridge conversations
// For the moment, rooms are DirectChat
class BotBridgeConnection {
  Client client;
  String hostname;
  bool continueProcess = true;

  BotBridgeConnection({
    required this.client,
    required this.hostname,
  });

  // To stop loops (when leaving the page)
  void stopProcess() {
    continueProcess = false;
  }

  // Ping to find out if we're connected to Instagram
  Future<String> instagramPing() async {
    final String botUserId = '@instagrambot:$hostname';

    // Message to spot when we're online
    final RegExp onlineMatch = RegExp(r"MQTT connection is active");
    final RegExp successfullyMatch = RegExp(r"Successfully logged in");
    final RegExp alreadySuccessMatch = RegExp(r"You're already logged in");

    // Message to spot when we're not online
    final RegExp notLoggedMatch = RegExp(r"You're not logged into Instagram");
    final RegExp disconnectMatch = RegExp(r"Successfully logged out");

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    String result = ''; // Variable to track the result of the connection

    // variable for loop limit
    const int maxIterations = 5;
    int currentIteration = 0;

    // Get the latest messages from the room (limited to the specified number)
    while (continueProcess && currentIteration < maxIterations) {
      // Send the "ping" message to the bot
      await roomBot?.sendTextEvent("ping");
      await Future.delayed(const Duration(seconds: 2)); // Wait sec

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

        // to find out if we're connected
        if (onlineMatch.hasMatch(latestMessage) ||
            alreadySuccessMatch.hasMatch(latestMessage) ||
            successfullyMatch.hasMatch(latestMessage)) {
          print("You're logged");

          result = 'Connected';

          break; // Exit the loop if bridge is connected
        } else if (notLoggedMatch.hasMatch(latestMessage) ||
            disconnectMatch.hasMatch(latestMessage)) {
          print('Not connected');

          result = 'Not Connected';
          break; // Exit the loop if bridge is disconnected
        }
      }
      currentIteration++;
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

  // Function for create and login bridge with bot
  Future<String> createBridgeInstagram(String username, String password) async {
    final String botUserId = '@instagrambot:$hostname';

    // Success phrases to spot
    final RegExp successMatch = RegExp(r"Successfully logged in");
    final RegExp alreadySuccessMatch = RegExp(r"You're already logged in");

    // Error phrase to spot
    final RegExp usernameErrorMatch =
        RegExp(r"Please check your username and try again");
    final RegExp passwordErrorMatch = RegExp(r"Incorrect password");
    final RegExp rateLimitErrorMatch = RegExp(r"rate_limit_error");

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    String result = ""; // Variable to track the result of the connection

    // variable for loop limit
    const int maxIterations = 5;
    int currentIteration = 0;

    // Get the latest messages from the room (limited to the specified number)
    while (currentIteration < maxIterations) {
      // Send the "login" message to the bot
      await roomBot?.sendTextEvent("login $username $password");
      await Future.delayed(const Duration(seconds: 5)); // Wait 5 sec

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
        } else if (!successMatch.hasMatch(latestMessage) &&
            usernameErrorMatch.hasMatch(latestMessage)) {
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
    final RegExp aldreadyLogoutMatch =
        RegExp(r"That command requires you to be logged in.");

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    final Room? roomBot = client.getRoomById(directChat);

    String result =
        "Connected"; // Variable to track the result of the connection

    // variable for loop limit
    const int maxIterations = 5;
    int currentIteration = 0;

    while (currentIteration < maxIterations) {
      // Send the "logout" message to the bot
      await roomBot?.sendTextEvent("logout");
      await Future.delayed(const Duration(seconds: 5)); // Wait 5 sec

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
            !aldreadyLogoutMatch.hasMatch(latestMessage)) {
          print("You're always connected");
          result = 'Connected';
          break;
        } else if (successMatch.hasMatch(latestMessage) ||
            aldreadyLogoutMatch.hasMatch(latestMessage)) {
          print("You're disconnected");

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

  // Function to delete a conversation with a bot
  Future<void> deleteConversation(String botUserId) async {
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
      BuildContext context, Future<String> pingFunction) async {
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
