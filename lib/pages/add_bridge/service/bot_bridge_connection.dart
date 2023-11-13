import 'package:matrix/matrix.dart';
import 'package:uuid/uuid.dart';

class BotBridgeConnection {
  Client client;

  BotBridgeConnection({
    required this.client,
  });

  // Ping to find out if we're connected to Instagram
  Future<bool> instagramPing() async {
    const String botUserId = '@instagrambot:loveto.party';

    // Message to spot when we're online
    final RegExp onlineMatch = RegExp(r"MQTT connection is active");
    final RegExp successfullyMatch = RegExp(r"Successfully logged in");
    final RegExp alreadySuccessMatch = RegExp(r"You're already logged in");

    // Message to spot when we're not online
    final RegExp notLoggedMatch = RegExp(r"You're not logged into Instagram");

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    bool result = false; // Variable to track the result of the connection

    // Get the latest messages from the room (limited to the specified number)
    while (true) {
      final GetRoomEventsResponse response = await client.getRoomEvents(
        directChat,
        Direction.b, // To get the latest messages
        limit: 1, // Number of messages to obtain
      );

      final List<MatrixEvent> latestMessages = response.chunk ?? [];

      if (latestMessages.isNotEmpty) {
        final String latestMessage = latestMessages.first.content['body'].toString() ??
            '';

        // to find out if we're connected
        if (!onlineMatch.hasMatch(latestMessage) && !notLoggedMatch.hasMatch(latestMessage) && !alreadySuccessMatch.hasMatch(latestMessage) && !successfullyMatch.hasMatch(latestMessage)) {

          // Send the "ping" message to the bot
          final Map<String, Object?> messageBody = {
            'msgtype': 'm.text',
            'body': "ping",
          };
          await client.sendMessage(
            directChat,
            'm.room.message',
            const Uuid().v4(),// Generate random txnId
            messageBody,
          );
          await Future.delayed(const Duration(seconds: 1)); // Wait 2 sec

        } else if(onlineMatch.hasMatch(latestMessage) || alreadySuccessMatch.hasMatch(latestMessage) || successfullyMatch.hasMatch(latestMessage)){

          print("You're logged");

          result = true;

          break; // Exit the loop if bridge is connected
        }else if(notLoggedMatch.hasMatch(latestMessage)){
          print('Not connected');

          break; // Exit the loop if bridge is disconnected
        }
      }
    }
    return result;
  }

  // Function for create and login bridge with bot
  Future<String> createBridgeInstagram(String username, String password) async {
    const String botUserId = '@instagrambot:loveto.party';

    // Success phrases to spot
    final RegExp successMatch = RegExp(r"Successfully logged in");
    final RegExp alreadySuccessMatch = RegExp(r"You're already logged in");

    // Error phrase to spot
    final RegExp usernameErrorMatch = RegExp(r"Please check your username and try again");
    final RegExp passwordErrorMatch = RegExp(r"Incorrect password");
    final RegExp rateLimitErrorMatch = RegExp(r"rate_limit_error");

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    String result = ""; // Variable to track the result of the connection


    // Get the latest messages from the room (limited to the specified number)
    while (true) {

      // Send the "login" message to the bot
      final Map<String, Object?> messageBody = {
        'msgtype': 'm.text',
        'body': "login $username $password",
      };
      await client.sendMessage(
        directChat,
        'm.room.message',
        const Uuid().v4(),// Generate random txnId
        messageBody,
      );
      await Future.delayed(const Duration(seconds: 5)); // Wait 5 sec

      final GetRoomEventsResponse response = await client.getRoomEvents(
        directChat,
        Direction.b, // To get the latest messages
        limit: 1, // Number of messages to obtain
      );

      final List<MatrixEvent> latestMessages = response.chunk ?? [];
      final String latestMessage = latestMessages.first.content['body'].toString() ??
          '';

      if (latestMessages.isNotEmpty) {

        if(successMatch.hasMatch(latestMessage) || alreadySuccessMatch.hasMatch(latestMessage)){
          print("You're logged to Instagram");

          result = "success";

          break; // Exit the loop once the "login" message has been sent and is success

        }else if(!successMatch.hasMatch(latestMessage) && usernameErrorMatch.hasMatch(latestMessage)){
          print("Login cannot be found");

          result = "errorUsername";

          break;

        }else if(passwordErrorMatch.hasMatch(latestMessage)){

          print("Password incorrect");

          result = "errorPassword";

          break;

        }else if(rateLimitErrorMatch.hasMatch(latestMessage)){

          print("rate limit error");

          result = "rateLimitError";

          break;

        }
      }
    }
    return result;
  }

  // To disconnect from Instagram
  Future<bool> disconnectToInstagram() async {
    const String botUserId = '@instagrambot:loveto.party';

    final RegExp successMatch = RegExp(r"Successfully logged out");

    // Add a direct chat with the Instagram bot (if you haven't already)
    String? directChat = client.getDirectChatFromUserId(botUserId);
    directChat ??= await client.startDirectChat(botUserId);

    bool result = true; // Variable to track the result of the connection

    // Get the latest messages from the room (limited to the specified number)
    while (true) {
      final GetRoomEventsResponse response = await client.getRoomEvents(
        directChat,
        Direction.b, // To get the latest messages
        limit: 1, // Number of messages to obtain
      );

      final List<MatrixEvent> latestMessages = response.chunk ?? [];

      if (latestMessages.isNotEmpty) {
        final String latestMessage = latestMessages.first.content['body'].toString() ??
            '';

        // to find out if we're connected
        if (!successMatch.hasMatch(latestMessage)) {

          // Send the "logout" message to the bot
          final Map<String, Object?> messageBody = {
            'msgtype': 'm.text',
            'body': "logout",
          };
          await client.sendMessage(
            directChat,
            'm.room.message',
            const Uuid().v4(),// Generate random txnId
            messageBody,
          );
          await Future.delayed(const Duration(seconds: 5)); // Wait 5 sec

        } else if(successMatch.hasMatch(latestMessage)){
          print("You're disconnected");

          result = false;
          break; // Exit the loop if bridge is connected
        }
      }
    }
    return result;
  }

}