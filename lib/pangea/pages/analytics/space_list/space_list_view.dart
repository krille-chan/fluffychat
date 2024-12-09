// import 'package:fluffychat/pangea/enum/time_span.dart';
// import 'package:fluffychat/pangea/pages/analytics/analytics_language_button.dart';
// import 'package:fluffychat/pangea/pages/analytics/analytics_list_tile.dart';
// import 'package:fluffychat/pangea/pages/analytics/time_span_menu_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/l10n.dart';
// import 'package:go_router/go_router.dart';

// import '../base_analytics.dart';
// import 'space_list.dart';

// class AnalyticsSpaceListView extends StatelessWidget {
//   final AnalyticsSpaceListController controller;
//   const AnalyticsSpaceListView(this.controller, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           L10n.of(context).spaceAnalytics,
//           style: TextStyle(
//             color: Theme.of(context).textTheme.bodyLarge!.color,
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//           ),
//           overflow: TextOverflow.clip,
//           textAlign: TextAlign.center,
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.close_outlined),
//           onPressed: () => context.pop(),
//         ),
//       ),
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               TimeSpanMenuButton(
//                 value: controller
//                     .pangeaController.analytics.currentAnalyticsTimeSpan,
//                 onChange: (TimeSpan value) => controller.toggleTimeSpan(
//                   context,
//                   value,
//                 ),
//               ),
//               AnalyticsLanguageButton(
//                 value:
//                     controller.pangeaController.analytics.currentAnalyticsLang,
//                 onChange: (lang) => controller.toggleSpaceLang(lang),
//                 languages:
//                     controller.pangeaController.pLanguageStore.targetOptions,
//               ),
//             ],
//           ),
//           Flexible(
//             child: ListView.builder(
//               itemCount: controller.spaces.length,
//               itemBuilder: (context, i) => AnalyticsListTile(
//                 defaultSelected: AnalyticsSelected(
//                   controller.spaces[i].id,
//                   AnalyticsEntryType.space,
//                   controller.spaces[i].name,
//                 ),
//                 avatar: controller.spaces[i].avatar,
//                 selected: AnalyticsSelected(
//                   controller.spaces[i].id,
//                   AnalyticsEntryType.space,
//                   controller.spaces[i].name,
//                 ),
//                 onTap: (selected) {
//                   context.go(
//                     '/rooms/analytics/${selected.id}',
//                   );
//                 },
//                 allowNavigateOnSelect: true,
//                 isSelected: false,
//                 pangeaController: controller.pangeaController,
//                 refreshStream: controller.refreshStream,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
