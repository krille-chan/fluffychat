import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/widgets/common/list_placeholder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../../../widgets/matrix.dart';
import '../../../controllers/pangea_controller.dart';
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
  StreamSubscription? stateSub;

  @override
  void initState() {
    super.initState();
    stateSub = _pangeaController.myAnalytics.stateStream.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    stateSub?.cancel();
    super.dispose();
  }

  List<Room> get chats {
    if (_pangeaController.myAnalytics.studentChats.isEmpty) {
      _pangeaController.myAnalytics
          .setStudentChats()
          .then((_) => setState(() {}));
    }
    return _pangeaController.myAnalytics.studentChats;
  }

  List<Room> get spaces {
    if (_pangeaController.myAnalytics.studentSpaces.isEmpty) {
      _pangeaController.myAnalytics
          .setStudentSpaces()
          .then((_) => setState(() {}));
    }
    return _pangeaController.myAnalytics.studentSpaces;
  }

  String? get userId {
    final id = _pangeaController.matrixState.client.userID;
    debugger(when: kDebugMode && id == null);
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return PLoadingStatusV2(
      // if we everr want it rebuild the whole thing each time (and run initState again)
      // but this is computationally expensive!
      // key: UniqueKey(),
      shimmerChild: const ListPlaceholder(),
      // onFinish: initialize,
      child: StudentAnalyticsView(this),
    );
  }
}
