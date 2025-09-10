import 'package:matrix/matrix.dart';

class ExtendedSpaceRoomsChunk {
  final SpaceRoomsChunk chunk;
  final String activityId;
  final List<String> userIds;

  ExtendedSpaceRoomsChunk({
    required this.chunk,
    required this.activityId,
    required this.userIds,
  });
}
