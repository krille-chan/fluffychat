import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/chart_analytics_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/common/list_placeholder.dart';
import 'package:fluffychat/pangea/widgets/common/p_circular_loader.dart';
import '../../../../widgets/matrix.dart';
import '../../../controllers/pangea_controller.dart';
import '../../../utils/sync_status_util_v2.dart';
import 'class_analytics_view.dart';

enum AnalyticsPageType { classList, student, classDetails }

class ClassAnalyticsPage extends StatefulWidget {
  // final AnalyticsPageType type;
  const ClassAnalyticsPage({super.key});

  @override
  State<ClassAnalyticsPage> createState() => ClassAnalyticsV2Controller();
}

class ClassAnalyticsV2Controller extends State<ClassAnalyticsPage> {
  final PangeaController _pangeaController = MatrixState.pangeaController;
  bool _initialized = false;
  StreamSubscription<Event>? stateSub;
  Timer? refreshTimer;

  List<Room> chats = [];
  List<User> students = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (classRoom == null || !classRoom!.isSpace) {
        context.go('/rooms');
      }
      stateSub = _pangeaController.matrixState.client.onRoomState.stream
          .where(
            (event) =>
                event.type == PangeaEventTypes.studentAnalyticsSummary &&
                event.roomId == classId,
          )
          .listen(onStateUpdate);
      getChatAndStudents();
    });
  }

  Future<void> getChatAndStudents() async {
    try {
      await classRoom!.requestParticipants();

      students = classRoom!.students;

      chats = classRoom!.spaceChildren
          .where((element) => element.roomId != null)
          .map((e) => Matrix.of(context).client.getRoomById(e.roomId!))
          .where((r) => r != null)
          .cast<Room>()
          .toList();

      setState(() {
        _initialized = true;
      });
    } catch (err, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s);
    }
  }

  void onStateUpdate(Event newState) {
    if (!(refreshTimer?.isActive ?? false)) {
      refreshTimer = Timer(
        const Duration(seconds: 3),
        () => getChatAndStudentAnalytics(context, true),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    refreshTimer?.cancel();
    stateSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const PCircular();
    return PLoadingStatusV2(
      // if we everr want it rebuild the whole thing each time (and run initState again)
      // but this is computationally expensive!
      // key: UniqueKey(),
      shimmerChild: const ListPlaceholder(),
      onFinish: () {
        getChatAndStudentAnalytics(context);
      },
      child: ClassAnalyticsView(this),
    );
  }

  Future<void> getChatAndStudentAnalytics(
    BuildContext context, [
    forceUpdate = false,
  ]) async {
    try {
      if (classRoom == null) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(m: 'classroom should not be null');
      }
      final List<Future<ChartAnalyticsModel?>> analyticsFutures = [];
      for (final student in students) {
        analyticsFutures.add(
          _pangeaController.analytics.getAnalytics(
            classRoom: classRoom,
            studentId: student.id,
            forceUpdate: forceUpdate,
          ),
        );
      }
      for (final chat in chats) {
        analyticsFutures.add(
          _pangeaController.analytics.getAnalytics(
            classRoom: classRoom,
            chatId: chat.id,
            forceUpdate: forceUpdate,
          ),
        );
      }
      analyticsFutures.add(
        _pangeaController.analytics.getAnalytics(
          classRoom: classRoom,
          forceUpdate: forceUpdate,
        ),
      );
      analyticsFutures.add(
        _pangeaController.analytics.getAnalyticsForPrivateChats(
          classRoom: classRoom,
          forceUpdate: forceUpdate,
        ),
      );
      await Future.wait(analyticsFutures);
      if (mounted) setState(() {});
    } catch (err) {
      debugger(when: kDebugMode);
    }
  }

  String? get classId => GoRouterState.of(context).pathParameters['classid'];

  Room? _classRoom;
  Room? get classRoom {
    _classRoom ??= classId != null
        ? Matrix.of(context).client.getRoomById(classId!)
        : null;
    return _classRoom;
  }

  String className(BuildContext context) {
    return classRoom?.name ?? "";
  }
}
