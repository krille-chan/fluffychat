import 'dart:math';

import 'package:matrix/matrix_api_lite/generated/model.dart';

import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';

extension PangeaRoomsChunk on PublicRoomsChunk {
  /// Use Random with a seed to get the default
  /// avatar associated with this space
  String defaultAvatar() {
    final int seed = roomId.hashCode;
    return SpaceConstants.publicSpaceIcons[Random(seed).nextInt(
      SpaceConstants.publicSpaceIcons.length,
    )];
  }
}
