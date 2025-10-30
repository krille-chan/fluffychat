import 'package:matrix/matrix.dart';

class ExtendedSpaceRoomsChunk {
  final SpaceRoomsChunk chunk;
  final List<String> userIds;

  ExtendedSpaceRoomsChunk({
    required this.chunk,
    required this.userIds,
  });
}
