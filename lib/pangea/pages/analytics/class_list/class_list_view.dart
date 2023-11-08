import 'package:fluffychat/pangea/extensions/client_extension.dart';
import 'package:fluffychat/pangea/pages/analytics/analytics_list_tile.dart';
import 'package:fluffychat/pangea/pages/analytics/time_span_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import '../../../../widgets/matrix.dart';
import '../../../enum/time_span.dart';
import '../base_analytics_page.dart';
import 'class_list.dart';

class AnalyticsClassListView extends StatelessWidget {
  final AnalyticsClassListController controller;
  const AnalyticsClassListView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Room> classesAndExchanges =
        Matrix.of(context).client.classesAndExchangesImTeaching;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          L10n.of(context)!.classAnalytics,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () => context.pop(),
        ),
        actions: [
          TimeSpanMenuButton(
            value:
                controller.pangeaController.analytics.currentAnalyticsTimeSpan,
            onChange: (TimeSpan value) =>
                controller.toggleTimeSpan(context, value),
          ),
        ],
      ),
      body: Column(
        children: [
          // MessagesBarChart(
          //   chartAnalytics: controller.chartData(context),
          //   barChartTitle: "",
          // ),
          Flexible(
            child: ListView.builder(
              itemCount: classesAndExchanges.length,
              itemBuilder: (context, i) => AnalyticsListTile(
                avatar: classesAndExchanges[i].avatar,
                model: controller.pangeaController.analytics
                    .getAnalyticsLocal(classId: classesAndExchanges[i].id),
                displayName: classesAndExchanges[i].name,
                id: classesAndExchanges[i].id,
                type: AnalyticsEntryType.space,
                selected: false,
                onTap: (selected) => context.go(
                  '/rooms/analytics/${selected.id}',
                ),
                allowNavigateOnSelect: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
