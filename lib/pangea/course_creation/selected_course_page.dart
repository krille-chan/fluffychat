import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:matrix/matrix.dart' as sdk;

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/course_creation/selected_course_view.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/spaces/utils/client_spaces_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SelectedCourse extends StatefulWidget {
  final String courseId;
  const SelectedCourse(this.courseId, {super.key});

  @override
  SelectedCourseController createState() => SelectedCourseController();
}

class SelectedCourseController extends State<SelectedCourse> {
  Future<void> launchCourse(CoursePlanModel course) async {
    final client = Matrix.of(context).client;
    Uint8List? avatar;
    Uri? avatarUrl;
    final imageUrl = course.imageUrl ??
        course.loadedTopics
            .lastWhereOrNull((topic) => topic.imageUrl != null)
            ?.imageUrl;

    if (imageUrl != null) {
      try {
        final Response response = await http.get(
          Uri.parse(imageUrl),
          headers: {
            'Authorization':
                'Bearer ${MatrixState.pangeaController.userController.accessToken}',
          },
        );
        avatar = response.bodyBytes;
        avatarUrl = await client.uploadContent(avatar);
      } catch (e) {
        debugPrint("Error fetching course image: $e");
      }
    }

    final roomId = await client.createPangeaSpace(
      name: course.title,
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
      avatar: avatar,
      avatarUrl: avatarUrl,
      spaceChild: 0,
    );

    if (!mounted) return;
    final room = client.getRoomById(roomId);
    if (room == null) return;
    context.go("/rooms/spaces/${room.id}/details");
  }

  @override
  Widget build(BuildContext context) => SelectedCourseView(
        courseId: widget.courseId,
        launchCourse: launchCourse,
      );
}
