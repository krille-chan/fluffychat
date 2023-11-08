import 'dart:developer';

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
import '../base_analytics_page.dart';
import 'student_analytics_view.dart';

class StudentAnalyticsPage extends StatefulWidget {
  const StudentAnalyticsPage({Key? key}) : super(key: key);

  @override
  State<StudentAnalyticsPage> createState() => StudentAnalyticsController();
}

class StudentAnalyticsController extends State<StudentAnalyticsPage> {
  final PangeaController _pangeaController = MatrixState.pangeaController;

  AnalyticsSelected? selected;

  @override
  void initState() {
    _pangeaController.matrixState.client
        .updateMyLearningAnalyticsForAllClassesImIn(
            _pangeaController.pStoreService);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PLoadingStatusV2(
      // if we everr want it rebuild the whole thing each time (and run initState again)
      // but this is computationally expensive!
      // key: UniqueKey(),
      shimmerChild: const ListPlaceholder(),
      onFinish: () {
        getClassAndChatAnalytics(context);
      },
      child: StudentAnalyticsView(this),
    );
  }

  Future<void> getClassAndChatAnalytics(BuildContext context) async {
    final List<Future<ChartAnalyticsModel?>> analyticsFutures = [];
    for (final chat in chats(context)) {
      analyticsFutures.add(
        _pangeaController.analytics.getAnalytics(
          chatId: chat.id,
          studentId: userId,
        ),
      );
    }
    for (final space in spaces(context)) {
      analyticsFutures.add(
        _pangeaController.analytics.getAnalytics(
          classRoom: space,
          studentId: userId,
        ),
      );
    }
    analyticsFutures.add(
      _pangeaController.analytics.getAnalytics(studentId: userId),
    );
    await Future.wait(analyticsFutures);
    setState(() {});
  }

  List<Room> spaces(BuildContext context) {
    try {
      return _pangeaController
          .matrixState.client.classesAndExchangesImStudyingIn;
    } catch (err) {
      debugger(when: kDebugMode);
      return [];
    }
  }

  List<Room> chats(BuildContext context) {
    try {
      return Matrix.of(context)
          .client
          .rooms
          .where((r) => !r.isSpace && !r.isAnalyticsRoom)
          .toList();
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
