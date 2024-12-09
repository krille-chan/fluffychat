// import 'dart:math';

// import 'package:fluffychat/pangea/enum/bar_chart_view_enum.dart';
// import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
// import 'package:fluffychat/pangea/enum/time_span.dart';
// import 'package:fluffychat/pangea/pages/analytics/analytics_language_button.dart';
// import 'package:fluffychat/pangea/pages/analytics/analytics_list_tile.dart';
// import 'package:fluffychat/pangea/pages/analytics/analytics_view_button.dart';
// import 'package:fluffychat/pangea/pages/analytics/base_analytics.dart';
// import 'package:fluffychat/pangea/pages/analytics/construct_list.dart';
// import 'package:fluffychat/pangea/pages/analytics/messages_bar_chart.dart';
// import 'package:fluffychat/pangea/pages/analytics/time_span_menu_button.dart';
// import 'package:fluffychat/widgets/layouts/max_width_body.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/l10n.dart';
// import 'package:go_router/go_router.dart';

// class BaseAnalyticsView extends StatelessWidget {
//   const BaseAnalyticsView({
//     super.key,
//     required this.controller,
//   });

//   final BaseAnalyticsController controller;

//   Widget chartView(BuildContext context) {
//     switch (controller.currentView) {
//       case BarChartViewSelection.messages:
//         return MessagesBarChart(
//           chartAnalytics: controller.chartData,
//         );
//       case BarChartViewSelection.grammar:
//         return ConstructList(
//           constructType: ConstructTypeEnum.grammar,
//           defaultSelected: controller.widget.defaultSelected,
//           selected: controller.selected,
//           controller: controller,
//           pangeaController: controller.pangeaController,
//           refreshStream: controller.refreshStream,
//         );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: RichText(
//           text: TextSpan(
//             style: TextStyle(
//               color: Theme.of(context).textTheme.bodyLarge!.color,
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//             ),
//             children: [
//               TextSpan(
//                 text: controller.widget.pageTitle,
//                 style: const TextStyle(decoration: TextDecoration.underline),
//                 recognizer: TapGestureRecognizer()
//                   ..onTap = () {
//                     final String route =
//                         "/rooms/${controller.widget.defaultSelected.type.route}";
//                     context.go(route);
//                   },
//               ),
//               if (controller.activeSpace != null)
//                 const TextSpan(
//                   text: " > ",
//                 ),
//               if (controller.activeSpace != null)
//                 TextSpan(
//                   text: controller.activeSpace!.getLocalizedDisplayname(),
//                 ),
//               const TextSpan(
//                 text: " > ",
//               ),
//               TextSpan(
//                 text: controller.currentView.string(context),
//               ),
//             ],
//           ),
//           overflow: TextOverflow.ellipsis,
//           textAlign: TextAlign.center,
//         ),
//       ),
//       body: MaxWidthBody(
//         withScrolling: false,
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TimeSpanMenuButton(
//                   value: controller.currentTimeSpan,
//                   onChange: (TimeSpan value) =>
//                       controller.toggleTimeSpan(context, value),
//                 ),
//                 AnalyticsViewButton(
//                   value: controller.currentView,
//                   onChange: controller.toggleView,
//                 ),
//                 AnalyticsLanguageButton(
//                   value: controller
//                       .pangeaController.analytics.currentAnalyticsLang,
//                   onChange: (lang) => controller.toggleSpaceLang(lang),
//                   languages: controller.widget.targetLanguages,
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Expanded(
//               flex: 1,
//               child: chartView(context),
//             ),
//             Expanded(
//               flex: 1,
//               child: DefaultTabController(
//                 length: 2,
//                 child: Column(
//                   children: [
//                     TabBar(
//                       tabs: [
//                         ...controller.widget.tabs.map(
//                           (tab) => Tab(
//                             icon: Icon(
//                               tab.icon,
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onSurfaceVariant,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: SizedBox(
//                           height: max(
//                                 controller.widget.tabs[0].items.length + 1,
//                                 controller.widget.tabs[1].items.length,
//                               ) *
//                               72,
//                           child: TabBarView(
//                             physics: const NeverScrollableScrollPhysics(),
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 children: [
//                                   ...controller.widget.tabs[0].items.map(
//                                     (item) => AnalyticsListTile(
//                                       refreshStream: controller.refreshStream,
//                                       avatar: item.avatar,
//                                       defaultSelected:
//                                           controller.widget.defaultSelected,
//                                       selected: AnalyticsSelected(
//                                         item.id,
//                                         controller.widget.tabs[0].type,
//                                         item.displayName,
//                                       ),
//                                       isSelected:
//                                           controller.isSelected(item.id),
//                                       onTap: (_) => controller.toggleSelection(
//                                         AnalyticsSelected(
//                                           item.id,
//                                           controller.widget.tabs[0].type,
//                                           item.displayName,
//                                         ),
//                                       ),
//                                       allowNavigateOnSelect: controller
//                                           .widget.tabs[0].allowNavigateOnSelect,
//                                       pangeaController:
//                                           controller.pangeaController,
//                                       controller: controller,
//                                     ),
//                                   ),
//                                   if (controller.widget.defaultSelected.type ==
//                                       AnalyticsEntryType.space)
//                                     AnalyticsListTile(
//                                       refreshStream: controller.refreshStream,
//                                       defaultSelected:
//                                           controller.widget.defaultSelected,
//                                       avatar: null,
//                                       selected: AnalyticsSelected(
//                                         controller.widget.defaultSelected.id,
//                                         AnalyticsEntryType.privateChats,
//                                         L10n.of(context).allPrivateChats,
//                                       ),
//                                       allowNavigateOnSelect: false,
//                                       isSelected: controller.isSelected(
//                                         controller.widget.defaultSelected.id,
//                                       ),
//                                       onTap: controller.toggleSelection,
//                                       pangeaController:
//                                           controller.pangeaController,
//                                       controller: controller,
//                                     ),
//                                 ],
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 children: controller.widget.tabs[1].items
//                                     .map(
//                                       (item) => AnalyticsListTile(
//                                         refreshStream: controller.refreshStream,
//                                         avatar: item.avatar,
//                                         defaultSelected:
//                                             controller.widget.defaultSelected,
//                                         selected: AnalyticsSelected(
//                                           item.id,
//                                           controller.widget.tabs[1].type,
//                                           item.displayName,
//                                         ),
//                                         isSelected:
//                                             controller.isSelected(item.id),
//                                         onTap: controller.toggleSelection,
//                                         allowNavigateOnSelect: controller.widget
//                                             .tabs[1].allowNavigateOnSelect,
//                                         pangeaController:
//                                             controller.pangeaController,
//                                         controller: controller,
//                                       ),
//                                     )
//                                     .toList(),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
