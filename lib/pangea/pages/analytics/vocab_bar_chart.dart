// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fl_chart/fl_chart.dart';

// Project imports:
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/headwords.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics_page.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'bar_chart_card.dart';
import 'messages_legend_widget.dart';

class VocabBarChart extends StatefulWidget {
  final AnalyticsSelected? selected;
  final AnalyticsSelected defaultSelected;

  const VocabBarChart({
    Key? key,
    required this.selected,
    required this.defaultSelected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => VocabBarChartState();
}

class VocabBarChartState extends State<VocabBarChart> {
  final double barSpace = 16;

  final PangeaController _pangeaController = MatrixState.pangeaController;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VocabHeadwords>(
      future: _pangeaController.analytics.vocabHeadsByAnalyticsSelected(
        selected: widget.selected,
        defaultSelected: widget.defaultSelected,
      ),
      builder: ((context, snapshot) => BarChartCard(
            barChartTitle: (widget.selected != null
                    ? widget.selected!
                    : widget.defaultSelected)
                .displayName,
            barChart: snapshot.hasData
                ? buildBarChart(context, snapshot.data!)
                : null,
            loadingData: snapshot.connectionState != ConnectionState.done,
            legend: const MessagesLegendsListWidget(),
          )),
    );
  }

  TextStyle titleTextStyle(BuildContext context) => TextStyle(
        color: Theme.of(context).textTheme.bodyLarge!.color,
        fontSize: 10,
      );

  BarChart buildBarChart(BuildContext context, VocabHeadwords vocabHeadwords) {
    final flLine = FlLine(
      color: Theme.of(context).dividerColor,
      strokeWidth: 1,
    );

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        barTouchData: BarTouchData(
          enabled: false,
        ),
        // barTouchData: barTouchData,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (double value, TitleMeta meta) =>
                  SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  vocabHeadwords.lists[value.toInt()].name,
                  style: titleTextStyle(context),
                ),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                Widget textWidget;
                if (value != meta.max) {
                  textWidget =
                      Text(meta.formattedValue, style: titleTextStyle(context));
                } else {
                  textWidget = const Icon(Icons.abc_outlined, size: 14);
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: textWidget,
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          // checkToShowHorizontalLine: (value) => value % 10 == 0,
          checkToShowHorizontalLine: (value) => true,
          getDrawingHorizontalLine: (value) => flLine,
          checkToShowVerticalLine: (value) => false,
          getDrawingVerticalLine: (value) => flLine,
        ),
        borderData: FlBorderData(
          show: false,
        ),
        groupsSpace: barSpace,
        barGroups: barChartGroupData(vocabHeadwords),
        backgroundColor: Colors.transparent,
      ),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  List<BarChartGroupData> barChartGroupData(VocabHeadwords vocabHeadwords) {
    // sort vocab into lists
    // calculate levels based on vocab data

    final List<BarChartGroupData> chartData = [];

    vocabHeadwords.lists.asMap().forEach((index, intervalGroup) {
      chartData.add(BarChartGroupData(
        x: index,
        barsSpace: barSpace,
        // barRods: intervalGroup.map(constructBarChartRodData).toList(),
        barRods: constructBarChartRodData(intervalGroup),
      ));
    });
    return chartData;
  }

  List<BarChartRodData> constructBarChartRodData(VocabList vocabList) {
    final ListTotals listTotals = vocabList.calculuateTotals();
    final y1 = listTotals.low;
    final y2 = y1 + listTotals.medium;
    final y3 = y2 + listTotals.high;

    return [
      BarChartRodData(
        toY: y3.toDouble(),
        width: 10.toDouble(),
        rodStackItems: [
          BarChartRodStackItem(0, y1.toDouble(), Colors.red),
          BarChartRodStackItem(y1.toDouble(), y2.toDouble(), Colors.grey),
          BarChartRodStackItem(y2.toDouble(), y3.toDouble(), Colors.green),
        ],
        borderRadius: BorderRadius.zero,
      )
    ];
  }
}
