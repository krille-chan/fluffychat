import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/course_creation/selected_course_view.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/spaces/utils/client_spaces_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SelectedCourse extends StatefulWidget {
  final String courseId;
  final String? spaceId;
  const SelectedCourse(this.courseId, {super.key, this.spaceId});

  @override
  SelectedCourseController createState() => SelectedCourseController();
}

class SelectedCourseController extends State<SelectedCourse> {
  Future<void> launchCourse(CoursePlanModel course) async {
    final client = Matrix.of(context).client;
    final Completer<String> completer = Completer<String>();
    client
        .createPangeaSpace(
          name: course.title,
          topic: course.description,
          introChatName: L10n.of(context).introductions,
          announcementsChatName: L10n.of(context).announcements,
          visibility: sdk.Visibility.private,
          joinRules: sdk.JoinRules.knock,
          initialState: [
            sdk.StateEvent(
              type: PangeaEventTypes.coursePlan,
              content: {
                "uuid": course.uuid,
              },
            ),
          ],
          avatarUrl: course.imageUrl,
          spaceChild: 0,
        )
        .then((spaceId) => completer.complete(spaceId))
        .catchError((error) => completer.completeError(error));

    context.go(
      "/rooms/course/own/${widget.courseId}/invite",
      extra: completer,
    );
  }

  Future<void> addCourseToSpace(CoursePlanModel course) async {
    if (widget.spaceId == null) return;
    final space = Matrix.of(context).client.getRoomById(widget.spaceId!);

    if (space == null) {
      throw Exception("Space not found");
    }

    await space.addCourseToSpace(widget.courseId);

    if (space.name.isEmpty) {
      await space.setName(course.title);
    }

    if (space.topic.isEmpty) {
      await space.setDescription(course.description);
    }

    if (!mounted) return;
    context.go("/rooms/spaces/${space.id}/details");
  }

  @override
  Widget build(BuildContext context) => SelectedCourseView(this);
}
