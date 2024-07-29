import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
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

SocialNetwork identifySocialNetwork(Room room) {
  // Assume that the first 5 participants are enough to identify the social network
  // to avoid going through all participants in large rooms
  final Iterable<User> participants = room.getParticipants().take(5);

  return SocialNetworkManager.socialNetworks.firstWhere(
    (network) => participants.any(
      (user) =>
          user.id.startsWith(network.mxidPrefix) ||
          user.id.startsWith(network.chatBot),
    ),
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
