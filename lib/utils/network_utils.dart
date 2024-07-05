import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/config/themes.dart';

import 'matrix_sdk_extensions/matrix_locals.dart';

bool containsFacebook(List<String> participantsIds) {
  return participantsIds.any((id) => id.contains('@messenger2'));
}

bool containsInstagram(List<String> participantsIds) {
  return participantsIds.any((id) => id.contains('@instagram2_'));
}

bool containsWhatsApp(List<String> participantsIds) {
  return participantsIds.any((id) => id.contains('@whatsapp'));
}

bool containsLinkedin(List<String> participantsIds) {
  return participantsIds.any((id) => id.contains('@linkedin'));
}

bool containsDiscord(List<String> participantsIds) {
  return participantsIds.any((id) => id.contains('@discord'));
}

bool containsSignal(List<String> participantsIds) {
  return participantsIds.any((id) => id.contains('@signal'));
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
  if (displayname.contains('(WA)')) {
    displayname = displayname.replaceAll('(WA)', ''); // Delete (WA)
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

Future<List<dynamic>> loadRoomInfo(BuildContext context, Room room) async {
  List<User> participants = room.getParticipants();
  Color? networkColor;
  Image? networkImage;
  final participantsIds = participants.map((member) => member.id).toList();
  String displayname =
      room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!));

  if (containsFacebook(participantsIds)) {
    networkColor = FluffyThemes.facebookColor;
    networkImage = Image.asset(
      'assets/facebook-messenger.png',
      color: networkColor,
      filterQuality: FilterQuality.high,
    );
    displayname = removeFacebookTag(displayname);
  } else if (containsInstagram(participantsIds)) {
    networkColor = FluffyThemes.instagramColor;
    networkImage = Image.asset(
      'assets/instagram.png',
      color: networkColor,
      filterQuality: FilterQuality.high,
    );
    displayname = removeInstagramTag(displayname);
  } else if (containsWhatsApp(participantsIds)) {
    networkColor = FluffyThemes.whatsAppColor;
    networkImage = Image.asset(
      'assets/whatsapp.png',
      color: networkColor,
      filterQuality: FilterQuality.high,
    );
    displayname = removeWhatsAppTag(displayname);
  } else if (containsLinkedin(participantsIds)) {
    networkColor = FluffyThemes.linkedinColor;
    networkImage = Image.asset(
      'assets/linkedin.png',
      color: networkColor,
      filterQuality: FilterQuality.high,
    );
    displayname = removeLinkedinTag(displayname);
  } else if (containsDiscord(participantsIds)) {
    networkColor = FluffyThemes.dicordColor;
    networkImage = Image.asset(
      'assets/discord.png',
      color: networkColor,
      filterQuality: FilterQuality.high,
    );
    displayname = removeDiscordTag(displayname);
  } else if (containsSignal(participantsIds)) {
    networkColor = FluffyThemes.signalColor;
    networkImage = Image.asset(
      'assets/signal.png',
      color: networkColor,
      filterQuality: FilterQuality.high,
    );
    displayname = removeSignalTag(displayname);
  }

  return [networkColor, networkImage, displayname];
}
