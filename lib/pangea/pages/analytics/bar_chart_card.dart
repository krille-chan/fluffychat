import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class BarChartCard extends StatelessWidget {
  const BarChartCard({
    super.key,
    required this.barChart,
    required this.legend,
    required this.loadingData,
  });

  final BarChart? barChart;
  final Widget legend;
  final bool loadingData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 14),
            Expanded(
              child: loadingData || barChart == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : barChart!,
            ),
            const SizedBox(height: 10),
            legend,
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
