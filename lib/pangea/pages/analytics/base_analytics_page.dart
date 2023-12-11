import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import '../../../widgets/layouts/max_width_body.dart';
import '../../../widgets/matrix.dart';
import '../../controllers/pangea_controller.dart';
import '../../enum/bar_chart_view_enum.dart';
import '../../enum/time_span.dart';
import '../../models/chart_analytics_model.dart';
import 'analytics_list_tile.dart';
import 'construct_list.dart';
import 'messages_bar_chart.dart';
import 'time_span_menu_button.dart';

class BaseAnalyticsPage extends StatefulWidget {
  final String pageTitle;
  final TabData tabData1;
  final TabData tabData2;
  final Future Function(BuildContext) refreshData;

  final AnalyticsSelected defaultAnalyticsSelected;
  final AnalyticsSelected? alwaysSelected;

  const BaseAnalyticsPage({
    super.key,
    required this.pageTitle,
    required this.tabData1,
    required this.tabData2,
    required this.defaultAnalyticsSelected,
    required this.refreshData,
    required this.alwaysSelected,
  });

  @override
  State<BaseAnalyticsPage> createState() => BaseAnalyticsController();
}

class BaseAnalyticsController extends State<BaseAnalyticsPage> {
  final PangeaController _pangeaController = MatrixState.pangeaController;
  AnalyticsSelected? selected;
  BarChartViewSelection selectedView = BarChartViewSelection.grammar;

  @override
  void initState() {
    super.initState();
  }

  bool isSelected(String chatOrStudentId) => chatOrStudentId == selected?.id;

  ChartAnalyticsModel? chartData(
    BuildContext context,
    AnalyticsSelected? selectedParam,
  ) {
    final AnalyticsSelected analyticsSelected =
        selectedParam ?? widget.defaultAnalyticsSelected;

    if (analyticsSelected.type == AnalyticsEntryType.privateChats) {
      return _pangeaController.analytics.getAnalyticsLocal(
        classId: analyticsSelected.id,
        chatId: AnalyticsEntryType.privateChats.toString(),
      );
    }

    String? chatId = analyticsSelected.type == AnalyticsEntryType.room
        ? analyticsSelected.id
        : null;
    chatId ??= widget.alwaysSelected?.type == AnalyticsEntryType.room
        ? widget.alwaysSelected?.id
        : null;

    String? studentId = analyticsSelected.type == AnalyticsEntryType.student
        ? analyticsSelected.id
        : null;
    studentId ??= widget.alwaysSelected?.type == AnalyticsEntryType.student
        ? widget.alwaysSelected?.id
        : null;

    String? classId = analyticsSelected.type == AnalyticsEntryType.space
        ? analyticsSelected.id
        : null;
    classId ??= widget.alwaysSelected?.type == AnalyticsEntryType.space
        ? widget.alwaysSelected?.id
        : null;

    final data = _pangeaController.analytics.getAnalyticsLocal(
      classId: classId,
      chatId: chatId,
      studentId: studentId,
    );
    return data;
  }

  String barTitle(BuildContext context) =>
      "${selectedView.string(context)}: ${selected == null ? widget.defaultAnalyticsSelected.displayName : selected!.displayName}";

  TimeSpan get currentTimeSpan =>
      _pangeaController.analytics.currentAnalyticsTimeSpan;

  void toggleSelection(AnalyticsSelected selectedParam) {
    setState(() {
      debugPrint("selectedParam.id is ${selectedParam.id}");
      selected = isSelected(selectedParam.id) ? null : selectedParam;
    });
    Future.delayed(Duration.zero, () => setState(() {}));
  }

  void toggleTimeSpan(BuildContext context, TimeSpan timeSpan) {
    _pangeaController.analytics.setCurrentAnalyticsTimeSpan(timeSpan);
    setState(() {});
    widget.refreshData(context).then((value) => setState(() {}));
  }

  void toggleSelectedView(BarChartViewSelection view) {
    selectedView = view;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => BaseAnalyticsView(controller: this);
}

class BaseAnalyticsView extends StatelessWidget {
  const BaseAnalyticsView({
    super.key,
    required this.controller,
  });

  final BaseAnalyticsController controller;

  Widget chartView(BuildContext context) {
    switch (controller.selectedView) {
      case BarChartViewSelection.messages:
        return MessagesBarChart(
          chartAnalytics: controller.chartData(context, controller.selected),
          barChartTitle: controller.barTitle(context),
        );
      // case BarChartViewSelection.vocab:
      //   return ConstructList(
      //     selected: controller.selected,
      //     defaultSelected: controller.widget.defaultAnalyticsSelected,
      //     constructType: ConstructType.vocab,
      //   );
      case BarChartViewSelection.grammar:
        return ConstructList(
          selected: controller.selected,
          defaultSelected: controller.widget.defaultAnalyticsSelected,
          constructType: ConstructType.grammar,
          title: controller.barTitle(context),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          controller.widget.pageTitle,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
        ),
        actions: [
          for (final view in BarChartViewSelection.values)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.selectedView == view
                    ? AppConfig.primaryColor
                    : null,
              ),
              child: IconButton(
                isSelected: controller.selectedView == view,
                icon: Icon(view.icon),
                tooltip: view.string(context),
                onPressed: () => controller.toggleSelectedView(view),
              ),
            ),
          TimeSpanMenuButton(
            value: controller.currentTimeSpan,
            onChange: (TimeSpan value) =>
                controller.toggleTimeSpan(context, value),
          ),
          // ChartViewPickerButton(
          //   selected: controller.selectedView,
          //   onChange: controller.toggleSelectedView,
          // ),
        ],
      ),
      body: MaxWidthBody(
        withScrolling: false,
        child: Column(
          children: [
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
                        Tab(
                          icon: Icon(
                            controller.widget.tabData1.icon,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            controller.widget.tabData2.icon,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: max(
                                controller.widget.tabData1.items.length + 1,
                                controller.widget.tabData2.items.length,
                              ) *
                              72,
                          child: TabBarView(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ...controller.widget.tabData1.items.map(
                                    (item) => AnalyticsListTile(
                                      avatar: item.avatar,
                                      model: controller.chartData(
                                        context,
                                        AnalyticsSelected(
                                          item.id,
                                          controller.widget.tabData1.type,
                                          "",
                                        ),
                                      ),
                                      displayName: item.displayName,
                                      id: item.id,
                                      type: controller.widget.tabData1.type,
                                      selected: controller.isSelected(item.id),
                                      onTap: controller.toggleSelection,
                                      allowNavigateOnSelect: controller.widget
                                          .tabData1.allowNavigateOnSelect,
                                    ),
                                  ),
                                  if (controller.widget.defaultAnalyticsSelected
                                          .type ==
                                      AnalyticsEntryType.space)
                                    AnalyticsListTile(
                                      avatar: null,
                                      model: controller.chartData(
                                        context,
                                        AnalyticsSelected(
                                          controller.widget
                                              .defaultAnalyticsSelected.id,
                                          AnalyticsEntryType.privateChats,
                                          L10n.of(context)!.allPrivateChats,
                                        ),
                                      ),
                                      displayName:
                                          L10n.of(context)!.allPrivateChats,
                                      id: controller
                                          .widget.defaultAnalyticsSelected.id,
                                      type: AnalyticsEntryType.privateChats,
                                      selected: controller.isSelected(
                                        controller
                                            .widget.defaultAnalyticsSelected.id,
                                      ),
                                      onTap: controller.toggleSelection,
                                      allowNavigateOnSelect: false,
                                    ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: controller.widget.tabData2.items
                                    .map(
                                      (item) => AnalyticsListTile(
                                        avatar: item.avatar,
                                        model: controller.chartData(
                                          context,
                                          AnalyticsSelected(
                                            item.id,
                                            controller.widget.tabData2.type,
                                            "",
                                          ),
                                        ),
                                        displayName: item.displayName,
                                        id: item.id,
                                        type: controller.widget.tabData2.type,
                                        selected:
                                            controller.isSelected(item.id),
                                        onTap: controller.toggleSelection,
                                        allowNavigateOnSelect: controller.widget
                                            .tabData2.allowNavigateOnSelect,
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
        ),
      ),
    );
  }
}

class TabData {
  AnalyticsEntryType type;
  IconData icon;
  List<TabItem> items;
  bool allowNavigateOnSelect;

  TabData({
    required this.type,
    required this.items,
    required this.icon,
    this.allowNavigateOnSelect = true,
  });
}

class TabItem {
  Uri? avatar;
  String displayName;
  String id;

  TabItem({required this.avatar, required this.displayName, required this.id});
}

enum AnalyticsEntryType { student, room, space, privateChats }

class AnalyticsSelected {
  String id;
  AnalyticsEntryType type;
  String displayName;

  AnalyticsSelected(this.id, this.type, this.displayName);
}
