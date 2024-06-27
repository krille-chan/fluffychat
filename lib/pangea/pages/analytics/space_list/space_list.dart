import 'dart:async';

import 'package:fluffychat/pangea/enum/time_span.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:fluffychat/pangea/pages/analytics/space_list/space_list_view.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../../../widgets/matrix.dart';
import '../../../controllers/pangea_controller.dart';
import '../../../utils/sync_status_util_v2.dart';
import '../../../widgets/common/list_placeholder.dart';

class AnalyticsSpaceList extends StatefulWidget {
  const AnalyticsSpaceList({super.key});

  @override
  State<AnalyticsSpaceList> createState() => AnalyticsSpaceListController();
}

class AnalyticsSpaceListController extends State<AnalyticsSpaceList> {
  PangeaController pangeaController = MatrixState.pangeaController;
  List<Room> spaces = [];
  StreamSubscription? stateSub;

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

    // reload dropdowns when their values change in analytics page
    stateSub = pangeaController.analytics.stateStream.listen(
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    stateSub?.cancel();
    super.dispose();
  }

  StreamController refreshStream = StreamController.broadcast();

  void toggleTimeSpan(BuildContext context, TimeSpan timeSpan) {
    pangeaController.analytics.setCurrentAnalyticsTimeSpan(timeSpan);
    refreshStream.add(false);
    setState(() {});
  }

  Future<void> toggleSpaceLang(LanguageModel lang) async {
    await pangeaController.analytics.setCurrentAnalyticsLang(lang);
    refreshStream.add(false);
    setState(() {});
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
}
