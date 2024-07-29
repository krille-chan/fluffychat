// import 'dart:developer';

// import 'package:fl_chart/fl_chart.dart';
// import 'package:fluffychat/config/themes.dart';
// import 'package:fluffychat/pangea/pages/analytics/bar_chart_placeholder_data.dart';
// import 'package:fluffychat/pangea/utils/error_handler.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../enum/time_span.dart';
// import '../../enum/use_type.dart';
// import '../../models/analytics/chart_analytics_model.dart';
// import 'bar_chart_card.dart';
// import 'messages_legend_widget.dart';

// class MessagesBarChart extends StatefulWidget {
//   final ChartAnalyticsModel? chartAnalytics;

//   const MessagesBarChart({
//     super.key,
//     required this.chartAnalytics,
//   });

//   @override
//   State<StatefulWidget> createState() => MessagesBarChartState();
// }

// class MessagesBarChartState extends State<MessagesBarChart> {
//   final double barSpace = 16;
//   final List<List<TimeSeriesInterval>> intervalGroupings = [];

//   @override
//   initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final flLine = FlLine(
//       color: Theme.of(context).dividerColor,
//       strokeWidth: 1,
//     );

//     final flTitlesData = FlTitlesData(
//       show: true,
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 28,
//           getTitlesWidget: bottomTitles,
//         ),
//       ),
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 40,
//           getTitlesWidget: leftTitles,
//         ),
//       ),
//       topTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       rightTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//     );
//     final barChartData = BarChartData(
//       alignment: BarChartAlignment.spaceEvenly,
//       barTouchData: BarTouchData(
//         enabled: false,
//       ),
//       // barTouchData: barTouchData,
//       titlesData: flTitlesData,
//       gridData: FlGridData(
//         show: true,
//         // checkToShowHorizontalLine: (value) => value % 10 == 0,
//         checkToShowHorizontalLine: (value) => true,
//         getDrawingHorizontalLine: (value) => flLine,
//         checkToShowVerticalLine: (value) => false,
//         getDrawingVerticalLine: (value) => flLine,
//       ),
//       borderData: FlBorderData(
//         show: false,
//       ),
//       groupsSpace: barSpace,
//       barGroups: barChartGroupData,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//     );
//     final barChart = BarChart(
//       barChartData,
//       swapAnimationDuration: const Duration(milliseconds: 250),
//     );

//     return BarChartCard(
//       barChart: barChart,
//       loadingData: widget.chartAnalytics == null,
//       legend: const MessagesLegendsListWidget(),
//     );
//   }

//   bool showLabelBasedOnTimeSpan(
//     TimeSpan timeSpan,
//     TimeSeriesInterval current,
//     TimeSeriesInterval? last,
//     int labelIndex,
//   ) {
//     switch (timeSpan) {
//       case TimeSpan.day:
//         return current.end.hour % 3 == 0;
//       case TimeSpan.month:
//         if (current.end.month != last?.end.month) {
//           return true;
//         }
//         double width = MediaQuery.of(context).size.width;
//         if (FluffyThemes.isColumnMode(context)) {
//           width = width - FluffyThemes.navRailWidth - FluffyThemes.columnWidth;
//         }
//         const int numDays = 28;
//         const int minSpacePerDay = 20;
//         final int availableSpaces = width ~/ minSpacePerDay;
//         final int showAtInterval = (numDays / availableSpaces).floor() + 1;

//         final int lastDayOfCurrentMonth =
//             DateTime(current.end.year, current.end.month + 1, 0).day;
//         final bool isNextToMonth = labelIndex == 1 ||
//             current.end.day == 2 ||
//             current.end.day == lastDayOfCurrentMonth;
//         final bool shouldShowNextToMonth = showAtInterval <= 1;
//         return (current.end.day % showAtInterval == 0) &&
//             (!isNextToMonth || shouldShowNextToMonth);
//       case TimeSpan.week:
//       case TimeSpan.sixmonths:
//       case TimeSpan.year:
//       default:
//         return true;
//     }
//   }

//   String getLabelBasedOnTimeSpan(
//     TimeSpan timeSpan,
//     TimeSeriesInterval current,
//     TimeSeriesInterval? last,
//     int labelIndex,
//   ) {
//     final bool showLabel = showLabelBasedOnTimeSpan(
//       timeSpan,
//       current,
//       last,
//       labelIndex,
//     );

//     if (widget.chartAnalytics == null || !showLabel) {
//       return "";
//     }
//     if (isInSameGroup(last, current, timeSpan)) {
//       return "-";
//     }

//     switch (widget.chartAnalytics?.timeSpan ?? TimeSpan.month) {
//       case TimeSpan.day:
//         return DateFormat(DateFormat.HOUR).format(current.end);
//       case TimeSpan.week:
//         return DateFormat(DateFormat.ABBR_WEEKDAY).format(current.end);
//       case TimeSpan.month:
//         return current.end.month != last?.end.month
//             ? DateFormat(DateFormat.ABBR_MONTH).format(current.end)
//             : DateFormat(DateFormat.DAY).format(current.end);
//       case TimeSpan.sixmonths:
//       case TimeSpan.year:
//         return DateFormat(DateFormat.ABBR_STANDALONE_MONTH).format(current.end);
//       default:
//         return '';
//     }
//   }

//   Widget bottomTitles(double value, TitleMeta meta) {
//     if (widget.chartAnalytics == null) {
//       return Container();
//     }
//     String text;
//     final index = value.toInt();
//     final TimeSpan timeSpan = widget.chartAnalytics?.timeSpan ?? TimeSpan.month;
//     final TimeSeriesInterval? last =
//         index != 0 ? intervalGroupings[index - 1].last : null;
//     final TimeSeriesInterval current = intervalGroupings[index].last;

//     text = getLabelBasedOnTimeSpan(timeSpan, current, last, index);

//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: Text(
//         text,
//         style: titleTextStyle(context),
//       ),
//     );
//   }

//   TextStyle titleTextStyle(context) => TextStyle(
//         color: Theme.of(context).textTheme.bodyLarge!.color,
//         fontSize: 10,
//       );

//   Widget leftTitles(double value, TitleMeta meta) {
//     Widget textWidget;
//     if (value != meta.max) {
//       textWidget = Text(meta.formattedValue, style: titleTextStyle(context));
//     } else {
//       textWidget = const Icon(Icons.chat_bubble, size: 14);
//     }
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: textWidget,
//     );
//   }

//   bool isInSameGroup(
//     TimeSeriesInterval? t1,
//     TimeSeriesInterval t2,
//     TimeSpan timeSpan,
//   ) {
//     final DateTime? date1 = t1?.end;
//     final DateTime date2 = t2.end;
//     if (timeSpan == TimeSpan.sixmonths || timeSpan == TimeSpan.year) {
//       return date1?.month == date2.month;
//     } else if (timeSpan == TimeSpan.week) {
//       return date1?.day == date2.day;
//     } else {
//       return false;
//     }
//   }

//   void makeIntervalGroupings() {
//     intervalGroupings.clear();
//     try {
//       for (final timeSeriesInterval
//           in widget.chartAnalytics?.timeSeries ?? []) {
//         //Note: if we decide we'd like to do some sort of grouping in the future,
//         // this is where that could happen. Currently, we're just putting one
//         // BarChartRod in each BarChartGroup
//         final TimeSeriesInterval? last =
//             intervalGroupings.isNotEmpty ? intervalGroupings.last.last : null;

//         if (widget.chartAnalytics != null &&
//             isInSameGroup(
//               last,
//               timeSeriesInterval,
//               widget.chartAnalytics!.timeSpan,
//             )) {
//           intervalGroupings.last.add(timeSeriesInterval);
//         } else {
//           intervalGroupings.add([timeSeriesInterval]);
//         }
//       }
//     } catch (err, stack) {
//       debugger(when: kDebugMode);
//       ErrorHandler.logError(e: err, s: stack);
//     }
//   }

//   List<BarChartGroupData> get barChartGroupData {
//     if (widget.chartAnalytics == null) {
//       return BarChartPlaceHolderData.getRandomData(context);
//     }

//     makeIntervalGroupings();

//     final List<BarChartGroupData> chartData = [];

//     intervalGroupings.asMap().forEach((index, intervalGroup) {
//       chartData.add(
//         BarChartGroupData(
//           x: index,
//           barsSpace: barSpace,
//           // barRods: intervalGroup.map(constructBarChartRodData).toList(),
//           barRods: constructBarChartRodData(intervalGroup),
//         ),
//       );
//     });
//     return chartData;
//   }

//   // BarChartRodData constructBarChartRodData(TimeSeriesInterval timeSeriesInterval) {
//   //   final double y1 = timeSeriesInterval.spanIT.toDouble();
//   //   final double y2 =
//   //       (timeSeriesInterval.spanIT + timeSeriesInterval.spanIGC).toDouble();
//   //   final double y3 = timeSeriesInterval.spanTotal.toDouble();
//   //   return BarChartRodData(
//   //     toY: y3,
//   //     width: 10.toDouble(),
//   //     rodStackItems: [
//   //       BarChartRodStackItem(0, y1, UseType.ta.color(context)),
//   //       BarChartRodStackItem(y1, y2, UseType.ga.color(context)),
//   //       BarChartRodStackItem(y2, y3, UseType.wa.color(context)),
//   //     ],
//   //     borderRadius: BorderRadius.zero,
//   //   );
//   // }

//   List<BarChartRodData> constructBarChartRodData(
//     List<TimeSeriesInterval> timeSeriesIntervalGroup,
//   ) {
//     int y1 = 0;
//     int y2 = 0;
//     int y3 = 0;
//     int y4 = 0;
//     for (final e in timeSeriesIntervalGroup) {
//       y1 += e.totals.ta;
//       y2 += y1 + e.totals.ga;
//       y3 += y2 + e.totals.wa;
//       y4 += y3 + e.totals.un;
//     }
//     return [
//       BarChartRodData(
//         toY: y4.toDouble(),
//         width: 10.toDouble(),
//         rodStackItems: [
//           BarChartRodStackItem(0, y1.toDouble(), UseType.ta.color(context)),
//           BarChartRodStackItem(
//             y1.toDouble(),
//             y2.toDouble(),
//             UseType.ga.color(context),
//           ),
//           BarChartRodStackItem(
//             y2.toDouble(),
//             y3.toDouble(),
//             UseType.wa.color(context),
//           ),
//           BarChartRodStackItem(
//             y3.toDouble(),
//             y4.toDouble(),
//             UseType.un.color(context),
//           ),
//         ],
//         borderRadius: BorderRadius.zero,
//       ),
//     ];
//   }

//   // BarTouchData get barTouchData => BarTouchData(
//   //       touchTooltipData: BarTouchTooltipData(
//   //         fitInsideVertically: true,
//   //         tooltipBgColor: Colors.blueGrey,
//   //         getTooltipItem: (group, groupIndex, rod, rodIndex) {
//   //           return BarTooltipItem(
//   //             "groupindex $groupIndex rodIndex $rodIndex",
//   //             const TextStyle(
//   //               color: Colors.white,
//   //               fontWeight: FontWeight.bold,
//   //               fontSize: 18,
//   //             ),
//   //             children: <TextSpan>[
//   //               toolTipText(rod),
//   //             ],
//   //           );
//   //         },
//   //       ),
//   //       // touchCallback: (FlTouchEvent event, barTouchResponse) {
//   //       //   setState(() {
//   //       //     if (!event.isInterestedForInteractions ||
//   //       //         barTouchResponse == null ||
//   //       //         barTouchResponse.spot == null) {
//   //       //       touchedIndex = -1;
//   //       //       return;
//   //       //     }
//   //       //     touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
//   //       //   });
//   //       // },
//   //     );

//   // TextSpan toolTipText(BarChartRodData rodData) {
//   //   double rodPercentage(int index) {
//   //     return (rodData.rodStackItems[index].toY -
//   //             rodData.rodStackItems[index].fromY) /
//   //         rodData.toY *
//   //         100;
//   //   }

//   //   return TextSpan(
//   //     children: [
//   //       const WidgetSpan(
//   //         child: Icon(Icons.chat_bubble, size: 14),
//   //       ),
//   //       TextSpan(
//   //         text: " ${rodData.toY}",
//   //       ),
//   //       TextSpan(
//   //         text: "/nIT ${rodPercentage(0)}%",
//   //         style: TextStyle(color: UseType.ta.color(context)),
//   //       ),
//   //       TextSpan(
//   //         text: "   IGC ${rodPercentage(1)}%",
//   //         style: TextStyle(color: UseType.ga.color(context)),
//   //       ),
//   //       TextSpan(
//   //         text: "   Direct ${rodPercentage(2)}%",
//   //         style: TextStyle(color: UseType.wa.color(context)),
//   //       ),
//   //     ],
//   //   );
//   // }
// }
