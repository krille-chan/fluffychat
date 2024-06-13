import 'dart:async';

import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics_view.dart';
import 'package:fluffychat/pangea/pages/analytics/student_analytics/student_analytics.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import '../../../widgets/matrix.dart';
import '../../controllers/pangea_controller.dart';
import '../../enum/bar_chart_view_enum.dart';
import '../../enum/time_span.dart';
import '../../models/chart_analytics_model.dart';

class BaseAnalyticsPage extends StatefulWidget {
  final String pageTitle;
  final List<TabData> tabs;
  final Future Function(BuildContext) refreshData;

  final AnalyticsSelected defaultSelected;
  final AnalyticsSelected? alwaysSelected;
  final StudentAnalyticsController? myAnalyticsController;

  const BaseAnalyticsPage({
    super.key,
    required this.pageTitle,
    required this.tabs,
    required this.refreshData,
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

  bool isSelected(String chatOrStudentId) => chatOrStudentId == selected?.id;

  ChartAnalyticsModel? chartData(
    BuildContext context,
    AnalyticsSelected? selectedParam,
  ) {
    final AnalyticsSelected analyticsSelected =
        selectedParam ?? widget.defaultSelected;

    if (analyticsSelected.type == AnalyticsEntryType.privateChats) {
      return pangeaController.analytics.getAnalyticsLocal(
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

    final data = pangeaController.analytics.getAnalyticsLocal(
      classId: classId,
      chatId: chatId,
      studentId: studentId,
    );

    return data;
  }

  TimeSpan get currentTimeSpan =>
      pangeaController.analytics.currentAnalyticsTimeSpan;

  void navigate() {
    if (currentLemma != null) {
      setCurrentLemma(null);
    } else if (selectedView != null) {
      setSelectedView(null);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> toggleSelection(AnalyticsSelected selectedParam) async {
    final bool joinSelectedRoom =
        selectedParam.type == AnalyticsEntryType.room &&
            !enableSelection(
              selectedParam,
            );

    if (joinSelectedRoom) {
      await showFutureLoadingDialog(
        context: context,
        future: () async {
          final waitForRoom = Matrix.of(context).client.waitForRoomInSync(
                selectedParam.id,
                join: true,
              );
          await Matrix.of(context).client.joinRoom(selectedParam.id);
          await waitForRoom;
        },
      );
    }

    setState(() {
      debugPrint("selectedParam.id is ${selectedParam.id}");
      currentLemma = null;
      selected = isSelected(selectedParam.id) ? null : selectedParam;
    });

    pangeaController.analytics.setConstructs(
      constructType: ConstructType.grammar,
      defaultSelected: widget.defaultSelected,
      selected: selected,
      removeIT: true,
    );

    Future.delayed(Duration.zero, () => setState(() {}));
  }

  Future<void> toggleTimeSpan(BuildContext context, TimeSpan timeSpan) async {
    await pangeaController.analytics.setCurrentAnalyticsTimeSpan(timeSpan);
    await widget.refreshData(context);
    await pangeaController.analytics.setConstructs(
      constructType: ConstructType.grammar,
      defaultSelected: widget.defaultSelected,
      selected: selected,
      removeIT: true,
    );
    setState(() {});
  }

  void setSelectedView(BarChartViewSelection? view) {
    currentLemma = null;
    selectedView = view;
    if (!enableSelection(selected)) {
      toggleSelection(selected!);
    }
    setState(() {});
  }

  void setCurrentLemma(String? lemma) {
    currentLemma = lemma;
    setState(() {});
  }

  bool enableSelection(AnalyticsSelected? selectedParam) {
    if (selectedView == BarChartViewSelection.grammar) {
      if (selectedParam?.type == AnalyticsEntryType.room) {
        return Matrix.of(context)
                .client
                .getRoomById(selectedParam!.id)
                ?.membership ==
            Membership.join;
      }

      if (selectedParam?.type == AnalyticsEntryType.student) {
        final String? langCode =
            pangeaController.languageController.activeL2Code(
          roomID: widget.defaultSelected.id,
        );
        if (langCode == null) return false;
        return Matrix.of(context).client.analyticsRoomLocal(
                  langCode,
                  selectedParam?.id,
                ) !=
            null;
      }
    }
    return true;
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
