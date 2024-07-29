// import 'dart:math';

// import 'package:fluffychat/pangea/models/analytics/chart_analytics_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/l10n.dart';

// import '../../enum/use_type.dart';

// class ListSummaryAnalytics extends StatelessWidget {
//   final ChartAnalyticsModel? chartAnalytics;

//   const ListSummaryAnalytics({super.key, this.chartAnalytics});

//   TimeSeriesTotals? get totals => chartAnalytics?.totals;

//   String spacer(int baseLength, int number) =>
//       " " * max(baseLength - number.toString().length, 0);

//   WidgetSpan spacerIconText(
//     String toolTip,
//     String space,
//     IconData icon,
//     int value,
//     Color? color, [
//     percentage = true,
//   ]) =>
//       WidgetSpan(
//         child: Tooltip(
//           message: toolTip,
//           child: RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: space,
//                 ),
//                 WidgetSpan(child: Icon(icon, size: 14, color: color)),
//                 TextSpan(
//                   text: " $value${percentage ? "%" : ""}",
//                   style: TextStyle(color: color),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     if (totals == null) {
//       return const LinearProgressIndicator();
//     }
//     final l10n = L10n.of(context);

//     return RichText(
//       text: TextSpan(
//         children: [
//           spacerIconText(
//             L10n.of(context) != null
//                 ? L10n.of(context)!.totalMessages
//                 : "Total messages sent",
//             "",
//             Icons.chat_bubble,
//             totals!.all,
//             Theme.of(context).textTheme.bodyLarge!.color,
//             false,
//           ),
//           if (totals!.all != 0) ...[
//             spacerIconText(
//               l10n != null ? l10n.taTooltip : "With translation assistance",
//               spacer(8, totals!.all),
//               UseType.ta.iconData,
//               totals!.taPercent,
//               UseType.ta.color(context),
//             ),
//             spacerIconText(
//               l10n != null ? l10n.gaTooltip : "With grammar assistance",
//               spacer(4, totals!.taPercent),
//               UseType.ga.iconData,
//               totals!.gaPercent,
//               UseType.ga.color(context),
//             ),
//             spacerIconText(
//               l10n != null ? l10n.waTooltip : "Without assistance",
//               spacer(4, totals!.gaPercent),
//               UseType.wa.iconData,
//               totals!.waPercent,
//               UseType.wa.color(context),
//             ),
//             spacerIconText(
//               l10n != null ? l10n.unTooltip : "Other",
//               spacer(4, totals!.waPercent),
//               UseType.un.iconData,
//               totals!.unPercent,
//               UseType.un.color(context),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
