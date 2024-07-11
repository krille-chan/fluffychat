import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/config/themes.dart';

import 'matrix_sdk_extensions/matrix_locals.dart';

class RoomDisplayInfo {
  final Color? networkColor;
  final Image? networkImage;
  final String displayname;

  RoomDisplayInfo({
    required this.networkColor,
    required this.networkImage,
    required this.displayname,
  });
}

bool containsFacebook(List<User> participants) {
  return participants.any((user) => user.id.contains('@messenger2'));
}

bool containsInstagram(List<User> participants) {
  return participants.any((user) => user.id.contains('@instagram2'));
}

bool containsWhatsApp(List<User> participants) {
  return participants.any((user) => user.id.contains('@whatsapp'));
}

bool containsLinkedin(List<User> participants) {
  return participants.any((user) => user.id.contains('@linkedin'));
}

bool containsDiscord(List<User> participants) {
  return participants.any((user) => user.id.contains('@discord'));
}

bool containsSignal(List<User> participants) {
  return participants.any((user) => user.id.contains('@signal'));
}

bool allNetworksAbsent(List<User> participants) {
  return !containsFacebook(participants) &&
      !containsInstagram(participants) &&
      !containsWhatsApp(participants) &&
      !containsLinkedin(participants) &&
      !containsDiscord(participants) &&
      !containsSignal(participants);
}

String removeFacebookTag(String displayname) {
  if (displayname.contains('(FB)')) {
    displayname = displayname.replaceAll('(FB)', ''); // Delete (FB)
  }
  return displayname;
}

String removeInstagramTag(String displayname) {
  if (displayname.contains('(IG)')) {
    displayname = displayname.replaceAll('(IG)', ''); // Delete (Instagram)
  }
  return displayname;
}

String removeWhatsAppTag(String displayname) {
  if (displayname.contains('(WhatsApp)')) {
    displayname = displayname.replaceAll('(WhatsApp)', ''); // Delete (WhatsApp)
  }
  return displayname;
}

String removeLinkedinTag(String displayname) {
  if (displayname.contains('(LinkedIn)')) {
    displayname = displayname.replaceAll('(LinkedIn)', ''); // Delete (LinkedIn)
  }
  return displayname;
}

String removeDiscordTag(String displayname) {
  if (displayname.contains('(Discord)')) {
    displayname = displayname.replaceAll('(Discord)', ''); // Delete (Discord)
  }
  return displayname;
}

String removeSignalTag(String displayname) {
  if (displayname.contains('(Signal)')) {
    displayname = displayname.replaceAll('(Signal)', ''); // Delete (Signal)
  }
  return displayname;
}

Future<RoomDisplayInfo> loadRoomInfo(BuildContext context, Room room) async {
  List<User> participants = room.getParticipants();
  Color? networkColor;
  Image? networkImage;
  String displayname =
      room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!));

  if(participants.isNotEmpty){
    if (containsFacebook(participants)) {
      networkColor = FluffyThemes.facebookColor;
      networkImage = Image.asset(
        'assets/facebook-messenger.png',
        color: networkColor,
        filterQuality: FilterQuality.high,
      );
      displayname = removeFacebookTag(displayname);
    } else if (containsInstagram(participants)) {
      networkColor = FluffyThemes.instagramColor;
      networkImage = Image.asset(
        'assets/instagram.png',
        color: networkColor,
        filterQuality: FilterQuality.high,
      );
      displayname = removeInstagramTag(displayname);
    } else if (containsWhatsApp(participants)) {
      networkColor = FluffyThemes.whatsAppColor;
      networkImage = Image.asset(
        'assets/whatsapp.png',
        color: networkColor,
        filterQuality: FilterQuality.high,
      );
      displayname = removeWhatsAppTag(displayname);
    } else if (containsLinkedin(participants)) {
      networkColor = FluffyThemes.linkedinColor;
      networkImage = Image.asset(
        'assets/linkedin.png',
        color: networkColor,
        filterQuality: FilterQuality.high,
      );
      displayname = removeLinkedinTag(displayname);
    } else if (containsDiscord(participants)) {
      networkColor = FluffyThemes.dicordColor;
      networkImage = Image.asset(
        'assets/discord.png',
        color: networkColor,
        filterQuality: FilterQuality.high,
      );
      displayname = removeDiscordTag(displayname);
    } else if (containsSignal(participants)) {
      networkColor = FluffyThemes.signalColor;
      networkImage = Image.asset(
        'assets/signal.png',
        color: networkColor,
        filterQuality: FilterQuality.high,
      );
      displayname = removeSignalTag(displayname);
    } else if (allNetworksAbsent(participants)) {
      networkColor = FluffyThemes.tawkieColor;
      networkImage = Image.asset(
        'assets/tawkie.png',
        color: networkColor,
        filterQuality: FilterQuality.high,
      );
    }
  }

  return RoomDisplayInfo(
    networkColor: networkColor,
    networkImage: networkImage,
    displayname: displayname,
  );
}
