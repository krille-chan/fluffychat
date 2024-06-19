import 'dart:async';

import 'package:fluffychat/pangea/enum/time_span.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics.dart';
import 'package:fluffychat/pangea/pages/analytics/space_list/space_list_view.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../../../widgets/matrix.dart';
import '../../../controllers/pangea_controller.dart';
import '../../../models/analytics/chart_analytics_model.dart';
import '../../../utils/sync_status_util_v2.dart';
import '../../../widgets/common/list_placeholder.dart';

class AnalyticsSpaceList extends StatefulWidget {
  const AnalyticsSpaceList({super.key});

  @override
  State<AnalyticsSpaceList> createState() => AnalyticsSpaceListController();
}

class AnalyticsSpaceListController extends State<AnalyticsSpaceList> {
  PangeaController pangeaController = MatrixState.pangeaController;
  List<ChartAnalyticsModel> models = [];
  List<Room> spaces = [];

  @override
  void initState() {
    super.initState();
    Matrix.of(context).client.spacesImTeaching.then((spaceList) {
      spaceList = spaceList
          .where(
            (space) => !spaceList.any(
              (parentSpace) => parentSpace.spaceChildren
                  .any((child) => child.roomId == space.id),
            ),
          )
          .toList();
      spaces = spaceList;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return PLoadingStatusV2(
      shimmerChild: const ListPlaceholder(),
      child: AnalyticsSpaceListView(this),
      onFinish: () {
        // getAllClassAnalytics(context);
      },
    );
  }

  Future<ChartAnalyticsModel?> updateSpaceAnalytics(
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
