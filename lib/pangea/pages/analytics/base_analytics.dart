// import 'dart:async';

// import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
// import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
// import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
// import 'package:fluffychat/pangea/models/analytics/analytics_event.dart';
// import 'package:fluffychat/pangea/models/language_model.dart';
// import 'package:fluffychat/pangea/pages/analytics/base_analytics_view.dart';
// import 'package:fluffychat/pangea/pages/analytics/student_analytics/student_analytics.dart';
// import 'package:flutter/material.dart';
// import 'package:future_loading_dialog/future_loading_dialog.dart';
// import 'package:matrix/matrix.dart';

// import '../../../widgets/matrix.dart';
// import '../../controllers/pangea_controller.dart';
// import '../../enum/bar_chart_view_enum.dart';
// import '../../enum/time_span.dart';
// import '../../models/analytics/chart_analytics_model.dart';

// class BaseAnalyticsPage extends StatefulWidget {
//   final String pageTitle;
//   final List<TabData> tabs;
//   final BarChartViewSelection selectedView;

//   final AnalyticsSelected defaultSelected;
//   final AnalyticsSelected? alwaysSelected;
//   final StudentAnalyticsController? myAnalyticsController;
//   final List<LanguageModel> targetLanguages;

//   BaseAnalyticsPage({
//     super.key,
//     required this.pageTitle,
//     required this.tabs,
//     required this.alwaysSelected,
//     required this.defaultSelected,
//     required this.selectedView,
//     this.myAnalyticsController,
//     targetLanguages,
//   }) : targetLanguages = (targetLanguages?.isNotEmpty ?? false)
//             ? targetLanguages
//             : MatrixState.pangeaController.pLanguageStore.targetOptions;

//   @override
//   State<BaseAnalyticsPage> createState() => BaseAnalyticsController();
// }

// class BaseAnalyticsController extends State<BaseAnalyticsPage> {
//   final PangeaController pangeaController = MatrixState.pangeaController;
//   AnalyticsSelected? selected;
//   String? currentLemma;
//   ChartAnalyticsModel? chartData;
//   StreamController refreshStream = StreamController.broadcast();
//   BarChartViewSelection currentView = BarChartViewSelection.messages;

//   bool isSelected(String chatOrStudentId) => chatOrStudentId == selected?.id;

//   Room? get activeSpace {
//     if (widget.defaultSelected.type == AnalyticsEntryType.space) {
//       return Matrix.of(context).client.getRoomById(widget.defaultSelected.id);
//     }
//     return null;
//   }

//   @override
//   void initState() {
//     super.initState();
//     currentView = widget.selectedView;
//     if (widget.defaultSelected.type == AnalyticsEntryType.student) {
//       runFirstRefresh();
//     }
//     setChartData();
//   }

//   @override
//   void didUpdateWidget(covariant BaseAnalyticsPage oldWidget) {
//     // when a user is a parent space's analytics and clicks on a subspace
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.defaultSelected.id != widget.defaultSelected.id) {
//       setChartData();
//       refreshStream.add(false);
//     }
//   }

//   Future<void> runFirstRefresh() async {
//     final analyticsRooms =
//         pangeaController.matrixState.client.allMyAnalyticsRooms;

//     final List<AnalyticsEvent> analyticsEvent = [];
//     for (final analyticsRoom in analyticsRooms) {
//       final lastSummaryEvent = await analyticsRoom.getLastAnalyticsEvent(
//         PangeaEventTypes.summaryAnalytics,
//         Matrix.of(context).client.userID!,
//       );
//       final lastConstructEvent = await analyticsRoom.getLastAnalyticsEvent(
//         PangeaEventTypes.construct,
//         Matrix.of(context).client.userID!,
//       );
//       if (lastSummaryEvent != null) {
//         analyticsEvent.add(lastSummaryEvent);
//       }
//       if (lastConstructEvent != null) {
//         analyticsEvent.add(lastConstructEvent);
//       }
//     }

//     if (analyticsEvent.isNotEmpty) return;
//     onRefresh();
//   }

//   Future<void> onRefresh() async {
//     // postframe callback to avoid calling this function during build
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await showFutureLoadingDialog(
//         context: context,
//         future: () async {
//           debugPrint("updating analytics");
//           await pangeaController.myAnalytics.updateAnalytics();
//           await setChartData(forceUpdate: true);
//           refreshStream.add(true);
//         },
//       );
//     });
//   }

//   Future<ChartAnalyticsModel> fetchChartData(
//     AnalyticsSelected? params, {
//     forceUpdate = false,
//   }) async {
//     final ChartAnalyticsModel data =
//         await pangeaController.analytics.getAnalytics(
//       defaultSelected: widget.defaultSelected,
//       selected: params,
//       forceUpdate: forceUpdate,
//     );

//     return data;
//   }

//   Future<void> setChartData({forceUpdate = false}) async {
//     final ChartAnalyticsModel newData = await fetchChartData(
//       selected,
//       forceUpdate: forceUpdate,
//     );
//     setState(() => chartData = newData);
//   }

//   TimeSpan get currentTimeSpan =>
//       pangeaController.analytics.currentAnalyticsTimeSpan;

//   Future<void> toggleSelection(AnalyticsSelected selectedParam) async {
//     setState(() {
//       debugPrint("selectedParam.id is ${selectedParam.id}");
//       currentLemma = null;
//       selected = isSelected(selectedParam.id) ? null : selectedParam;
//     });
//     await setChartData();
//     refreshStream.add(false);
//     Future.delayed(Duration.zero, () => setState(() {}));
//   }

//   Future<void> toggleTimeSpan(BuildContext context, TimeSpan timeSpan) async {
//     await pangeaController.analytics.setCurrentAnalyticsTimeSpan(timeSpan);
//     await setChartData();
//     refreshStream.add(false);
//   }

//   Future<void> toggleSpaceLang(LanguageModel lang) async {
//     await pangeaController.analytics.setCurrentAnalyticsLang(lang);
//     await setChartData();
//     refreshStream.add(false);
//   }

//   Future<void> toggleView(BarChartViewSelection view) async {
//     currentView = view;
//     await setChartData();
//     refreshStream.add(false);
//   }

//   void setCurrentLemma(String? lemma) {
//     currentLemma = lemma;
//     setState(() {});
//     refreshStream.add(false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BaseAnalyticsView(controller: this);
//   }
// }

// class TabData {
//   AnalyticsEntryType type;
//   IconData icon;
//   List<TabItem> items;
//   bool allowNavigateOnSelect;

//   TabData({
//     required this.type,
//     required this.items,
//     required this.icon,
//     this.allowNavigateOnSelect = true,
//   });
// }

// class TabItem {
//   Uri? avatar;
//   String displayName;
//   String id;

//   TabItem({required this.avatar, required this.displayName, required this.id});
// }

enum AnalyticsEntryType { student, room, space, privateChats }

extension AnalyticsEntryTypeExtension on AnalyticsEntryType {
  String get route {
    switch (this) {
      case AnalyticsEntryType.student:
        return 'mylearning';
      case AnalyticsEntryType.space:
        return 'analytics';
      default:
        throw Exception('No route for $this');
    }
  }
}

class AnalyticsSelected {
  String id;
  AnalyticsEntryType type;
  String displayName;

  AnalyticsSelected(this.id, this.type, this.displayName);
}
