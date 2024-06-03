import 'dart:async';

import 'package:fluffychat/pangea/enum/time_span.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics.dart';
import 'package:fluffychat/pangea/pages/analytics/class_list/class_list_view.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../../../widgets/matrix.dart';
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

  @override
  Widget build(BuildContext context) {
    return PLoadingStatusV2(
      shimmerChild: const ListPlaceholder(),
      child: AnalyticsClassListView(this),
      onFinish: () {
        // getAllClassAnalytics(context);
      },
    );
  }

  Future<ChartAnalyticsModel?> updateClassAnalytics(
    Room? space,
  ) async {
    if (space == null) {
      return null;
    }

    final data = await pangeaController.analytics.getAnalytics(
      defaultSelected: AnalyticsSelected(
        space.id,
        AnalyticsEntryType.space,
        space.name,
      ),
      forceUpdate: true,
    );
    setState(() {});
    return data;
  }

  void toggleTimeSpan(BuildContext context, TimeSpan timeSpan) {
    pangeaController.analytics.setCurrentAnalyticsTimeSpan(timeSpan);
    setState(() {});
  }
}
