import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/enum/time_span.dart';
import 'package:fluffychat/pangea/pages/analytics/class_list/class_list_view.dart';
import '../../../../widgets/matrix.dart';
import '../../../constants/pangea_event_types.dart';
import '../../../controllers/pangea_controller.dart';
import '../../../models/chart_analytics_model.dart';
import '../../../utils/sync_status_util_v2.dart';
import '../../../widgets/common/list_placeholder.dart';

class AnalyticsClassList extends StatefulWidget {
  const AnalyticsClassList({super.key});

  @override
  State<AnalyticsClassList> createState() => AnalyticsClassListController();
}

class AnalyticsClassListController extends State<AnalyticsClassList> {
  PangeaController pangeaController = MatrixState.pangeaController;
  List<ChartAnalyticsModel> models = [];
  StreamSubscription<Event>? stateSub;
  Map<String, Timer> refreshTimer = {};

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      stateSub = pangeaController.matrixState.client.onRoomState.stream
          .where(
            (event) => event.type == PangeaEventTypes.studentAnalyticsSummary,
          )
          .listen(onStateUpdate);
    });
  }

  void onStateUpdate(Event newState) {
    if (!(refreshTimer[newState.room.id]?.isActive ?? false)) {
      refreshTimer[newState.room.id] = Timer(
        const Duration(seconds: 3),
        () => updateClassAnalytics(context, newState.room),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (final timer in refreshTimer.values) {
      timer.cancel();
    }
    stateSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PLoadingStatusV2(
      shimmerChild: const ListPlaceholder(),
      child: AnalyticsClassListView(this),
      onFinish: () {
        getAllClassAnalytics(context);
      },
    );
  }

  Future<void> getAllClassAnalytics(BuildContext context) async {
    await pangeaController.analytics.allClassAnalytics();
    setState(() {
      debugPrint("class list post getAllClassAnalytics");
    });
  }

  Future<void> updateClassAnalytics(
    BuildContext context,
    Room classRoom,
  ) async {
    await pangeaController.analytics
        .getAnalytics(classRoom: classRoom, forceUpdate: true);
    setState(() {
      debugPrint("class list post updateClassAnalytics");
    });
  }

  void toggleTimeSpan(BuildContext context, TimeSpan timeSpan) {
    pangeaController.analytics.setCurrentAnalyticsTimeSpan(timeSpan);
    setState(() {});
    getAllClassAnalytics(context);
  }
}
