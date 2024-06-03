import 'dart:math';

import 'package:fluffychat/pangea/enum/bar_chart_view_enum.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/time_span.dart';
import 'package:fluffychat/pangea/pages/analytics/analytics_list_tile.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics.dart';
import 'package:fluffychat/pangea/pages/analytics/construct_list.dart';
import 'package:fluffychat/pangea/pages/analytics/messages_bar_chart.dart';
import 'package:fluffychat/pangea/pages/analytics/time_span_menu_button.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class BaseAnalyticsView extends StatelessWidget {
  const BaseAnalyticsView({
    super.key,
    required this.controller,
  });

  final BaseAnalyticsController controller;

  Widget chartView(BuildContext context) {
    if (controller.selectedView == null) {
      return const SizedBox();
    }

    switch (controller.selectedView!) {
      case BarChartViewSelection.messages:
        return MessagesBarChart(
          chartAnalytics: controller.chartData,
        );
      case BarChartViewSelection.grammar:
        return ConstructList(
          constructType: ConstructType.grammar,
          defaultSelected: controller.widget.defaultSelected,
          selected: controller.selected,
          controller: controller,
          pangeaController: controller.pangeaController,
          refreshStream: controller.refreshStream,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            children: [
              TextSpan(
                text: controller.widget.pageTitle,
                style: const TextStyle(decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => controller.selectedView != null
                      ? controller.setSelectedView(null)
                      : null,
              ),
              if (controller.selectedView != null)
                const TextSpan(
                  text: " > ",
                ),
              if (controller.selectedView != null)
                TextSpan(
                  style: const TextStyle(decoration: TextDecoration.underline),
                  text: controller.selectedView!.string(context),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => controller.currentLemma != null
                        ? controller.setCurrentLemma(null)
                        : null,
                ),
              if (controller.currentLemma != null)
                const TextSpan(
                  text: " > ",
                ),
              if (controller.currentLemma != null)
                TextSpan(
                  text: controller.currentLemma,
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
            ],
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.navigate,
        ),
        // actions: [
        // TimeSpanMenuButton(
        //   value: controller.currentTimeSpan,
        //   onChange: (TimeSpan value) =>
        //       controller.toggleTimeSpan(context, value),
        // ),
        // ],
      ),
      body: MaxWidthBody(
        withScrolling: false,
        child: controller.selectedView != null
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: controller.onRefresh,
                        tooltip: L10n.of(context)!.refresh,
                      ),
                      TimeSpanMenuButton(
                        value: controller.currentTimeSpan,
                        onChange: (TimeSpan value) =>
                            controller.toggleTimeSpan(context, value),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: chartView(context),
                  ),
                  Expanded(
                    flex: 1,
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            tabs: [
                              ...controller.widget.tabs.map(
                                (tab) => Tab(
                                  icon: Icon(
                                    tab.icon,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: SizedBox(
                                height: max(
                                      controller.widget.tabs[0].items.length +
                                          1,
                                      controller.widget.tabs[1].items.length,
                                    ) *
                                    72,
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ...controller.widget.tabs[0].items.map(
                                          (item) => AnalyticsListTile(
                                            refreshStream:
                                                controller.refreshStream,
                                            avatar: item.avatar,
                                            defaultSelected: controller
                                                .widget.defaultSelected,
                                            selected: AnalyticsSelected(
                                              item.id,
                                              controller.widget.tabs[0].type,
                                              item.displayName,
                                            ),
                                            isSelected:
                                                controller.isSelected(item.id),
                                            showSpaceAnalytics: false,
                                            onTap: (_) =>
                                                controller.toggleSelection(
                                              AnalyticsSelected(
                                                item.id,
                                                controller.widget.tabs[0].type,
                                                item.displayName,
                                              ),
                                            ),
                                            allowNavigateOnSelect: controller
                                                .widget
                                                .tabs[0]
                                                .allowNavigateOnSelect,
                                            pangeaController:
                                                controller.pangeaController,
                                          ),
                                        ),
                                        if (controller
                                                .widget.defaultSelected.type ==
                                            AnalyticsEntryType.space)
                                          AnalyticsListTile(
                                            refreshStream:
                                                controller.refreshStream,
                                            defaultSelected: controller
                                                .widget.defaultSelected,
                                            avatar: null,
                                            selected: AnalyticsSelected(
                                              controller
                                                  .widget.defaultSelected.id,
                                              AnalyticsEntryType.privateChats,
                                              L10n.of(context)!.allPrivateChats,
                                            ),
                                            allowNavigateOnSelect: false,
                                            isSelected: controller.isSelected(
                                              controller
                                                  .widget.defaultSelected.id,
                                            ),
                                            onTap: controller.toggleSelection,
                                            pangeaController:
                                                controller.pangeaController,
                                          ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: controller.widget.tabs[1].items
                                          .map(
                                            (item) => AnalyticsListTile(
                                              refreshStream:
                                                  controller.refreshStream,
                                              avatar: item.avatar,
                                              defaultSelected: controller
                                                  .widget.defaultSelected,
                                              selected: AnalyticsSelected(
                                                item.id,
                                                controller.widget.tabs[1].type,
                                                item.displayName,
                                              ),
                                              isSelected: controller
                                                  .isSelected(item.id),
                                              onTap: controller.toggleSelection,
                                              allowNavigateOnSelect: controller
                                                  .widget
                                                  .tabs[1]
                                                  .allowNavigateOnSelect,
                                              pangeaController:
                                                  controller.pangeaController,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  const Divider(height: 1),
                  ListTile(
                    title: const Text("Error Analytics"),
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      foregroundColor:
                          Theme.of(context).textTheme.bodyLarge!.color,
                      child: Icon(BarChartViewSelection.grammar.icon),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => controller.setSelectedView(
                      BarChartViewSelection.grammar,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text("Message Analytics"),
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      foregroundColor:
                          Theme.of(context).textTheme.bodyLarge!.color,
                      child: Icon(BarChartViewSelection.messages.icon),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => controller.setSelectedView(
                      BarChartViewSelection.messages,
                    ),
                  ),
                  const Divider(height: 1),
                ],
              ),
      ),
    );
  }
}
