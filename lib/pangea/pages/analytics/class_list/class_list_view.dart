import 'package:fluffychat/pangea/pages/analytics/analytics_list_tile.dart';
import 'package:fluffychat/pangea/pages/analytics/time_span_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import '../../../enum/time_span.dart';
import '../base_analytics.dart';
import 'class_list.dart';

class AnalyticsClassListView extends StatelessWidget {
  final AnalyticsClassListController controller;
  const AnalyticsClassListView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
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
          Flexible(
            child: ListView.builder(
              itemCount: controller.spaces.length,
              itemBuilder: (context, i) => AnalyticsListTile(
                defaultSelected: AnalyticsSelected(
                  controller.spaces[i].id,
                  AnalyticsEntryType.space,
                  "",
                ),
                avatar: controller.spaces[i].avatar,
                selected: AnalyticsSelected(
                  controller.spaces[i].id,
                  AnalyticsEntryType.space,
                  controller.spaces[i].name,
                ),
                onTap: (selected) {
                  context.go(
                    '/rooms/analytics/${selected.id}',
                  );
                },
                allowNavigateOnSelect: true,
                isSelected: false,
                pangeaController: controller.pangeaController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
