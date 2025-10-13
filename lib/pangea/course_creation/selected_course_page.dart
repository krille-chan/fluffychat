import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/course_creation/selected_course_view.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_builder.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/spaces/utils/client_spaces_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum SelectedCourseMode { launch, addToSpace, join }

class SelectedCourse extends StatefulWidget {
  final String courseId;
  final SelectedCourseMode mode;

  /// In addToSpace mode, the ID of the space to add the course to.
  /// In join mode, the ID of the space to join that already has this course.
  final String? spaceId;

  /// In join mode, the room info for the space that already has this course.
  final PublicRoomsChunk? roomChunk;

  const SelectedCourse(
    this.courseId,
    this.mode, {
    super.key,
    this.spaceId,
    this.roomChunk,
  });

  @override
  SelectedCourseController createState() => SelectedCourseController();
}

class SelectedCourseController extends State<SelectedCourse>
    with CoursePlanProvider {
  @override
  initState() {
    super.initState();
    loadCourse(widget.courseId).then((_) => loadTopics());
  }

  @override
  void didUpdateWidget(covariant SelectedCourse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.courseId != widget.courseId) {
      loadCourse(widget.courseId).then((_) => loadTopics());
    }
  }

  String get title {
    switch (widget.mode) {
      case SelectedCourseMode.launch:
        return L10n.of(context).newCourse;
      case SelectedCourseMode.addToSpace:
        return L10n.of(context).addCoursePlan;
      case SelectedCourseMode.join:
        return L10n.of(context).joinWithClassCode;
    }
  }

  String get buttonText {
    switch (widget.mode) {
      case SelectedCourseMode.launch:
        return L10n.of(context).createCourse;
      case SelectedCourseMode.addToSpace:
        return L10n.of(context).addCoursePlan;
      case SelectedCourseMode.join:
        return L10n.of(context).joinWithClassCode;
    }
  }

  Future<void> submit(CoursePlanModel course) async {
    switch (widget.mode) {
      case SelectedCourseMode.launch:
        return launchCourse(widget.courseId, course);
      case SelectedCourseMode.addToSpace:
        return addCourseToSpace(course);
      case SelectedCourseMode.join:
        return joinCourse();
    }
  }

  Future<void> launchCourse(
    String courseId,
    CoursePlanModel course,
  ) async {
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
                "uuid": courseId,
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
    if (widget.spaceId == null) {
      throw Exception("Space ID is null");
    }

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

  Future<void> joinCourse() async {
    if (widget.roomChunk == null) {
      throw Exception("Room chunk is null");
    }

    final client = Matrix.of(context).client;
    final roomId = await client.joinRoom(
      widget.roomChunk!.roomId,
    );

    final room = client.getRoomById(roomId);
    if (room == null || room.membership != Membership.join) {
      await client.waitForRoomInSync(roomId, join: true);
    }

    if (client.getRoomById(roomId) == null) {
      throw Exception("Failed to join room");
    }

    if (mounted) {
      context.go("/rooms/spaces/$roomId/details");
    }
  }

  @override
  Widget build(BuildContext context) => SelectedCourseView(this);
}
