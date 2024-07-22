import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/config/themes.dart';
import 'package:tawkie/pages/add_bridge/model/social_network.dart';

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

bool containsDiscord(List<User> participants) {
  return participants.any((user) => user.id.contains('@discord'));
}

bool containsSignal(List<User> participants) {
  return participants.any((user) => user.id.contains('@signal'));
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

SocialNetwork identifySocialNetwork(Room room) {
  final List<User> participants = room.getParticipants();

  return SocialNetworkManager.socialNetworks.firstWhere(
    (network) =>
        participants.any((user) => user.id.startsWith(network.mxidPrefix)),
  ); // Should default to Tawkie
}

Future<RoomDisplayInfo> loadRoomInfo(BuildContext context, Room room) async {
  final SocialNetwork socialNetwork = identifySocialNetwork(room);
  final String displayname =
      room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!));

  return RoomDisplayInfo(
    networkColor: socialNetwork.color,
    networkImage: Image.asset(
      socialNetwork.chatIconPath,
      color: socialNetwork.color,
      filterQuality: FilterQuality.high,
    ),
    displayname: socialNetwork.removeSuffix(displayname),
  );
}
