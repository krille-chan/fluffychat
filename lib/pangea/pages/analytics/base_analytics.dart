import 'dart:async';

import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/analytics_event.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics_view.dart';
import 'package:fluffychat/pangea/pages/analytics/student_analytics/student_analytics.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

import '../../../widgets/matrix.dart';
import '../../controllers/pangea_controller.dart';
import '../../enum/bar_chart_view_enum.dart';
import '../../enum/time_span.dart';
import '../../models/chart_analytics_model.dart';

class BaseAnalyticsPage extends StatefulWidget {
  final String pageTitle;
  final List<TabData> tabs;

  final AnalyticsSelected defaultSelected;
  final AnalyticsSelected? alwaysSelected;
  final StudentAnalyticsController? myAnalyticsController;

  const BaseAnalyticsPage({
    super.key,
    required this.pageTitle,
    required this.tabs,
    required this.alwaysSelected,
    required this.defaultSelected,
    this.myAnalyticsController,
  });

  @override
  State<BaseAnalyticsPage> createState() => BaseAnalyticsController();
}

class BaseAnalyticsController extends State<BaseAnalyticsPage> {
  final PangeaController pangeaController = MatrixState.pangeaController;
  BarChartViewSelection? selectedView;
  AnalyticsSelected? selected;
  String? currentLemma;
  ChartAnalyticsModel? chartData;
  StreamController refreshStream = StreamController.broadcast();

  bool isSelected(String chatOrStudentId) => chatOrStudentId == selected?.id;

  @override
  void initState() {
    super.initState();
    runFirstRefresh();
    setChartData();
  }

  Future<void> runFirstRefresh() async {
    final analyticsRooms =
        pangeaController.matrixState.client.allMyAnalyticsRooms;

    final List<AnalyticsEvent> analyticsEvent = [];
    for (final analyticsRoom in analyticsRooms) {
      final lastSummaryEvent = await analyticsRoom
          .getLastAnalyticsEvent(PangeaEventTypes.summaryAnalytics);
      final lastConstructEvent =
          await analyticsRoom.getLastAnalyticsEvent(PangeaEventTypes.construct);
      if (lastSummaryEvent != null) {
        analyticsEvent.add(lastSummaryEvent);
      }
      if (lastConstructEvent != null) {
        analyticsEvent.add(lastConstructEvent);
      }
    }

    if (analyticsEvent.isNotEmpty) return;
    onRefresh();
  }

  Future<void> onRefresh() async {
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        debugPrint("updating analytics");
        await pangeaController.myAnalytics.updateAnalytics();
        await setChartData(forceUpdate: true);
        refreshStream.add(true);
      },
    );
  }

  Future<ChartAnalyticsModel> fetchChartData(
    AnalyticsSelected? params, {
    forceUpdate = false,
  }) async {
    final ChartAnalyticsModel data =
        await pangeaController.analytics.getAnalytics(
      defaultSelected: widget.defaultSelected,
      selected: params,
      forceUpdate: forceUpdate,
    );

    return data;
  }

  Future<void> setChartData({forceUpdate = false}) async {
    final ChartAnalyticsModel newData = await fetchChartData(
      selected,
      forceUpdate: forceUpdate,
    );
    setState(() => chartData = newData);
  }

  TimeSpan get currentTimeSpan =>
      pangeaController.analytics.currentAnalyticsTimeSpan;

  void navigate() {
    if (selectedView != null) {
      setSelectedView(null);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> toggleSelection(AnalyticsSelected selectedParam) async {
    setState(() {
      debugPrint("selectedParam.id is ${selectedParam.id}");
      currentLemma = null;
      selected = isSelected(selectedParam.id) ? null : selectedParam;
    });

    await pangeaController.analytics.setConstructs(
      constructType: ConstructType.grammar,
      defaultSelected: widget.defaultSelected,
      selected: selected,
      removeIT: true,
    );
    await setChartData();

    Future.delayed(Duration.zero, () => setState(() {}));
  }

  Future<void> toggleTimeSpan(BuildContext context, TimeSpan timeSpan) async {
    await pangeaController.analytics.setCurrentAnalyticsTimeSpan(timeSpan);
    await pangeaController.analytics.setConstructs(
      constructType: ConstructType.grammar,
      defaultSelected: widget.defaultSelected,
      selected: selected,
      removeIT: true,
    );
    await setChartData();
    refreshStream.add(false);
  }

  void setSelectedView(BarChartViewSelection? view) {
    currentLemma = null;
    selectedView = view;
    setState(() {});
    refreshStream.add(false);
  }

  void setCurrentLemma(String? lemma) {
    currentLemma = lemma;
    setState(() {});
    refreshStream.add(false);
  }

  @override
  Widget build(BuildContext context) {
    return BaseAnalyticsView(controller: this);
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
