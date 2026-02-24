import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/chat_settings/utils/room_summary_extension.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/course_creation/public_course_preview_view.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/activity_summaries_provider.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_builder.dart';
import 'package:fluffychat/pangea/join_codes/knock_room_extension.dart';
import 'package:fluffychat/pangea/join_codes/space_code_controller.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PublicCoursePreview extends StatefulWidget {
  final String? roomID;

  const PublicCoursePreview({super.key, required this.roomID});

  @override
  PublicCoursePreviewController createState() =>
      PublicCoursePreviewController();
}

class PublicCoursePreviewController extends State<PublicCoursePreview>
    with CoursePlanProvider, ActivitySummariesProvider {
  RoomSummaryResponse? roomSummary;
  Object? roomSummaryError;
  bool loadingRoomSummary = false;

  @override
  initState() {
    super.initState();
    _loadSummary();
  }

  @override
  void didUpdateWidget(covariant PublicCoursePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.roomID != oldWidget.roomID) {
      _loadSummary();
    }
  }

  bool get loading => loadingCourse || loadingRoomSummary;
  bool get hasError =>
      (courseError != null || (!loadingCourse && course == null)) ||
      (roomSummaryError != null ||
          (!loadingRoomSummary && roomSummary == null));

  Future<void> _loadSummary() async {
    try {
      if (widget.roomID == null) {
        throw Exception("roomID is required");
      }

      setState(() {
        loadingRoomSummary = true;
        roomSummaryError = null;
      });

      await loadRoomSummaries([widget.roomID!]);
      if (roomSummaries == null || !roomSummaries!.containsKey(widget.roomID)) {
        throw Exception("Room summary not found");
      }

      roomSummary = roomSummaries![widget.roomID];
    } catch (e, s) {
      roomSummaryError = e;
      loadingCourse = false;

      ErrorHandler.logError(
        e: e,
        s: s,
        data: {'roomID': widget.roomID, 'roomSummary': roomSummary?.toJson()},
      );
    } finally {
      if (mounted) {
        setState(() {
          loadingRoomSummary = false;
        });
      }
    }

    if (roomSummary?.coursePlan != null) {
      await loadCourse(roomSummary!.coursePlan!.uuid).then((_) => loadTopics());
    } else {
      ErrorHandler.logError(
        e: Exception("No course plan found in room summary"),
        data: {'roomID': widget.roomID, 'roomSummary': roomSummary?.toJson()},
      );
      if (mounted) {
        setState(() {
          roomSummaryError = Exception("No course plan found in room summary");
          loadingCourse = false;
        });
      }
    }
  }

  Future<void> joinWithCode(String code) async {
    if (code.isEmpty) {
      return;
    }

    final roomId = await SpaceCodeController.joinSpaceWithCode(context, code);

    if (roomId != null) {
      final room = Matrix.of(context).client.getRoomById(roomId);
      room?.isSpace ?? true
          ? context.go('/rooms/spaces/$roomId/details')
          : context.go('/rooms/$roomId');
    }
  }

  Future<void> joinCourse() async {
    if (widget.roomID == null) {
      throw Exception("roomID is required");
    }

    final roomID = widget.roomID;

    final client = Matrix.of(context).client;
    final r = client.getRoomById(roomID!);
    if (r != null && r.membership == Membership.join) {
      if (mounted) {
        context.go("/rooms/spaces/${r.id}/details");
      }
      return;
    }

    final knock = roomSummary?.joinRule == JoinRules.knock;
    final resp = await showFutureLoadingDialog(
      context: context,
      future: () async {
        String roomId;
        try {
          roomId = knock
              ? await client.knockAndRecordRoom(widget.roomID!)
              : await client.joinRoom(widget.roomID!);
        } catch (e, s) {
          ErrorHandler.logError(e: e, s: s, data: {'roomID': widget.roomID});
          rethrow;
        }

        Room? room = client.getRoomById(roomId);
        if (!knock && room?.membership != Membership.join) {
          await client.waitForRoomInSync(roomId, join: true);
          room = client.getRoomById(roomId);
        }

        if (knock) return;
        if (room == null) {
          ErrorHandler.logError(
            e: Exception("Failed to load joined room in public course preview"),
            data: {'roomID': widget.roomID},
          );
          throw Exception("Failed to join room");
        }
        context.go("/rooms/spaces/$roomId/details");
      },
    );

    if (!knock || resp.isError) return;
    await showOkAlertDialog(
      context: context,
      title: L10n.of(context).youHaveKnocked,
      message: L10n.of(context).knockDesc,
    );
  }

  @override
  Widget build(BuildContext context) => PublicCoursePreviewView(this);
}
