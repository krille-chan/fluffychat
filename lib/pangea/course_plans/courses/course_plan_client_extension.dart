import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/course_plans/courses/course_plan_room_extension.dart';

extension CoursePlanClientExtension on Client {
  Room? getRoomByCourseId(String courseId) => rooms.firstWhereOrNull(
        (room) => room.coursePlan?.uuid == courseId,
      );
}
