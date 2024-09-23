import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix_api_lite/utils/logs.dart';
import 'package:tawkie/pages/add_bridge/model/social_network.dart';
import 'package:tawkie/pages/add_bridge/service/reg_exp_pattern.dart';

enum SocialNetworkEnum { WhatsApp, FacebookMessenger, Instagram, Linkedin }

SocialNetworkEnum? getSocialNetworkEnum(String name) {
  switch (name) {
    case "WhatsApp":
      return SocialNetworkEnum.WhatsApp;
    case "Facebook Messenger":
      return SocialNetworkEnum.FacebookMessenger;
    case "Instagram":
      return SocialNetworkEnum.Instagram;
    case "Linkedin":
      return SocialNetworkEnum.Linkedin;
    default:
      return null; // Or throw an exception if you prefer
  }
}

/// Format cookies into a JSON string
String formatCookiesToJsonString(
    List<io.Cookie> cookies, SocialNetwork network) {
  Map<String, String> formattedCookies = {};
  String result;

  if (network.name == "Linkedin") {
    result =
        cookies.map((cookie) => '${cookie.name}="${cookie.value}"').join('; ');
  } else {
    for (var cookie in cookies) {
      String decodedValue = Uri.decodeComponent(cookie.value);
      formattedCookies[cookie.name] = decodedValue;
    }
    result = json.encode(formattedCookies);
  }

  return result;
}

/// Check if the latest message indicates online status
bool isOnline(RegExp onlineMatch, String latestMessage) {
  final isMatch = onlineMatch.hasMatch(latestMessage);
  Logs().v('Checking online status: $latestMessage - Match: $isMatch');
  return isMatch;
}

/// Check if the latest message indicates not logged in status
bool isNotLogged(RegExp notLoggedMatch, String message,
    [RegExp? notLoggedAnymoreMatch]) {
  final isNotLoggedMatch = notLoggedMatch.hasMatch(message);
  final isNotLoggedAnymoreMatch =
      notLoggedAnymoreMatch?.hasMatch(message) ?? false;
  Logs().v(
      'Checking not logged status: $message - Match: $isNotLoggedMatch, Not logged anymore match: $isNotLoggedAnymoreMatch');
  return isNotLoggedMatch || isNotLoggedAnymoreMatch;
}

/// Check if a reconnect event should be sent
bool shouldReconnect(RegExp? mQTTNotMatch, String latestMessage) {
  final shouldReconnect = mQTTNotMatch?.hasMatch(latestMessage) ?? false;
  Logs()
      .v('Checking should reconnect: $latestMessage - Match: $shouldReconnect');
  return shouldReconnect;
}

/// Check if the message indicates the user is still connected
bool isStillConnected(String message, Map<String, RegExp> patterns) {
  return !patterns['logoutSuccess']!.hasMatch(message) &&
      !patterns['alreadyLoggedOut']!.hasMatch(message);
}

/// Get the regular expressions for a specific social network
RegExpPingPatterns getPingPatterns(SocialNetworkEnum network) {
  switch (network) {
    case SocialNetworkEnum.WhatsApp:
      return RegExpPingPatterns(
        PingPatterns.whatsAppOnlineMatch,
        PingPatterns.whatsAppNotLoggedMatch,
        PingPatterns.whatsAppLoggedButNotConnectedMatch,
      );
    case SocialNetworkEnum.FacebookMessenger:
      return RegExpPingPatterns(
        PingPatterns.facebookOnlineMatch,
        PingPatterns.facebookNotLoggedMatch,
        PingPatterns.facebookNotLoggedAnymoreMatch,
      );
    case SocialNetworkEnum.Instagram:
      return RegExpPingPatterns(
        PingPatterns.instagramOnlineMatch,
        PingPatterns.instagramNotLoggedMatch,
        PingPatterns.instagramNotLoggedAnymoreMatch,
      );
    case SocialNetworkEnum.Linkedin:
      return RegExpPingPatterns(
        PingPatterns.linkedinOnlineMatch,
        PingPatterns.linkedinNotLoggedMatch,
      );
    default:
      throw Exception("Unsupported social network: $network");
  }
}

/// Get the logout patterns for a specific social network
Map<String, RegExp> getLogoutNetworkPatterns(SocialNetworkEnum network) {
  switch (network) {
    case SocialNetworkEnum.Instagram:
      return {
        'logoutSuccess': LogoutRegex.instagramSuccessMatch,
        'alreadyLoggedOut': LogoutRegex.instagramAlreadyLogoutMatch
      };
    case SocialNetworkEnum.WhatsApp:
      return {
        'logoutSuccess': LogoutRegex.whatsappSuccessMatch,
        'alreadyLoggedOut': LogoutRegex.whatsappAlreadyLogoutMatch
      };
    case SocialNetworkEnum.FacebookMessenger:
      return {
        'logoutSuccess': LogoutRegex.facebookSuccessMatch,
        'alreadyLoggedOut': LogoutRegex.facebookAlreadyLogoutMatch
      };
    case SocialNetworkEnum.Linkedin:
      return {
        'logoutSuccess': LogoutRegex.linkedinSuccessMatch,
        'alreadyLoggedOut': LogoutRegex.linkedinAlreadyLogoutMatch
      };
    default:
      throw ArgumentError('Unsupported network: $network');
  }
}

Future<void> storeUserInfoMetaInSecureStorage(String message, String networkName) async {
  // Define a regex to capture the name and ID
  final RegExp userInfoRegex = RegExp(r"Logged in as ([\w\s]+) \((\d+)\)");

  // Check if the message matches the pattern
  final match = userInfoRegex.firstMatch(message);

  if (match != null) {
    // Extract the name and ID
    final userName = match.group(1);
    final userId = match.group(2);

    // Combine user ID and name into a single JSON object
    final Map<String, String> userInfo = {
      'userId': userId!,
      'userName': userName!,
    };

    // Serialize the map to JSON string
    final userInfoJson = jsonEncode(userInfo);

    // Store the combined data in SecureStorage
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: '${networkName}_userInfo', value: userInfoJson);

    if (kDebugMode) {
      print("Stored $networkName user info: $userInfoJson");
    }
  } else {
    if (kDebugMode) {
      print("No user info found in message.");
    }
  }
}

