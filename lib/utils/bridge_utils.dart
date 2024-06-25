import 'dart:convert';
import 'dart:io' as io;

import 'package:matrix/matrix_api_lite/utils/logs.dart';
import 'package:tawkie/pages/add_bridge/model/social_network.dart';
import 'package:tawkie/pages/add_bridge/service/reg_exp_pattern.dart';

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
  return !patterns['success']!.hasMatch(message) &&
      !patterns['alreadyLogout']!.hasMatch(message);
}

/// Check if the message indicates the user is disconnected
bool isDisconnected(String message, Map<String, RegExp> patterns) {
  return patterns['success']!.hasMatch(message) ||
      patterns['alreadyLogout']!.hasMatch(message);
}

/// Get the regular expressions for a specific social network
RegExpPingPatterns getPingPatterns(String networkName) {
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
        PingPatterns.facebookNotLoggedAnymoreMatch,
      );
    case "Instagram":
      return RegExpPingPatterns(
        PingPatterns.instagramOnlineMatch,
        PingPatterns.instagramNotLoggedMatch,
        PingPatterns.instagramNotLoggedAnymoreMatch,
      );
    case "Linkedin":
      return RegExpPingPatterns(
        PingPatterns.linkedinOnlineMatch,
        PingPatterns.linkedinNotLoggedMatch,
      );
    default:
      throw Exception("Unsupported social network: $networkName");
  }
}

/// Get the logout patterns for a specific social network
Map<String, RegExp> getLogoutNetworkPatterns(String networkName) {
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
    case 'Linkedin':
      return {
        'success': LogoutRegex.linkedinSuccessMatch,
        'alreadyLogout': LogoutRegex.linkedinAlreadyLogoutMatch
      };
    default:
      throw ArgumentError('Unsupported network: $networkName');
  }
}
