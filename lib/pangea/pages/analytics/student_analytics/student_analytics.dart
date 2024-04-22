import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/chart_analytics_model.dart';
import 'package:fluffychat/pangea/widgets/common/list_placeholder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../../../widgets/matrix.dart';
import '../../../controllers/pangea_controller.dart';
import '../../../extensions/client_extension.dart';
import '../../../utils/sync_status_util_v2.dart';
import '../base_analytics.dart';
import 'student_analytics_view.dart';

class StudentAnalyticsPage extends StatefulWidget {
  const StudentAnalyticsPage({super.key});

  @override
  State<StudentAnalyticsPage> createState() => StudentAnalyticsController();
}

class StudentAnalyticsController extends State<StudentAnalyticsPage> {
  final PangeaController _pangeaController = MatrixState.pangeaController;
  AnalyticsSelected? selected;
  StreamSubscription<Event>? stateSub;
  Timer? refreshTimer;

  List<Room> _chats = [];
  List<Room> _spaces = [];

  void onStateUpdate(Event newState) {
    if (!(refreshTimer?.isActive ?? false)) {
      refreshTimer = Timer(
        const Duration(seconds: 3),
        () => getClassAndChatAnalytics(context, true),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    refreshTimer?.cancel();
    stateSub?.cancel();
  }

  Future<void> initialize() async {
    await getClassAndChatAnalytics(context);
    stateSub = _pangeaController.matrixState.client.onRoomState.stream
        .where(
          (event) =>
              event.type == PangeaEventTypes.studentAnalyticsSummary &&
              event.senderId == userId,
        )
        .listen(onStateUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return PLoadingStatusV2(
      // if we everr want it rebuild the whole thing each time (and run initState again)
      // but this is computationally expensive!
      // key: UniqueKey(),
      shimmerChild: const ListPlaceholder(),
      onFinish: initialize,
      child: StudentAnalyticsView(this),
    );
  }

  Future<void> getClassAndChatAnalytics(
    BuildContext context, [
    forceUpdate = false,
  ]) async {
    final List<Future<ChartAnalyticsModel?>> analyticsFutures = [];
    for (final chat in (await getChats())) {
      analyticsFutures.add(
        _pangeaController.analytics.getAnalytics(
          chatId: chat.id,
          studentId: userId,
          forceUpdate: forceUpdate,
        ),
      );
    }
    for (final space in (await getSpaces())) {
      analyticsFutures.add(
        _pangeaController.analytics.getAnalytics(
          classRoom: space,
          studentId: userId,
          forceUpdate: forceUpdate,
        ),
      );
    }
    analyticsFutures.add(
      _pangeaController.analytics.getAnalytics(
        studentId: userId,
        forceUpdate: forceUpdate,
      ),
    );
    await Future.wait(analyticsFutures);
    setState(() {});
  }

  Future<List<Room>> getSpaces() async {
    final List<Room> rooms = await _pangeaController
        .matrixState.client.classesAndExchangesImStudyingIn;
    setState(() => _spaces = rooms);
    return rooms;
  }

  List<Room>? get spaces {
    try {
      if (_spaces.isNotEmpty) return _spaces;
      getSpaces();
      return _spaces;
    } catch (err) {
      debugger(when: kDebugMode);
      return [];
    }
  }

  Future<List<Room>> getChats() async {
    final List<String> teacherRoomIds =
        await Matrix.of(context).client.teacherRoomIds;
    _chats = Matrix.of(context)
        .client
        .rooms
        .where(
          (r) =>
              !r.isSpace &&
              !r.isAnalyticsRoom &&
              !teacherRoomIds.contains(r.id),
        )
        .toList();
    setState(() => _chats = _chats);
    return _chats;
  }

  List<Room>? get chats {
    try {
      if (_chats.isNotEmpty) return _chats;
      getChats();
      return _chats;
    } catch (err) {
      debugger(when: kDebugMode);
      return [];
    }
  }

  String? get userId {
    final id = _pangeaController.matrixState.client.userID;
    debugger(when: kDebugMode && id == null);
    return id;
  }

  String get username =>
      _pangeaController.matrixState.client.userID?.localpart ?? "";
}
