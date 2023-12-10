import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import '../../enum/use_type.dart';

class BarChartPlaceHolderData {
  static BarChartRodData randomBarChartRodData(
    BuildContext context,
    int index,
  ) {
    // final total = Random().nextInt(100);
    // final it = total != 0 ? Random().nextInt(max(total - index, 1)) : 0;
    // final igc = total != 0 ? Random().nextInt(max(total - it - index, 1)) : 0;
    // // final direct = Random().nextInt(total - it - igc);
    // final y1 = it.toDouble();
    // final y2 = y1 + igc.toDouble();
    // final y3 = total.toDouble();
    // final y4 = y3;
    const total = 0;
    const double y1 = 0;
    const double y2 = 0;
    const double y3 = 0;
    const double y4 = 0;

    return BarChartRodData(
      toY: total.toDouble(),
      rodStackItems: [
        BarChartRodStackItem(0, y1, UseType.ta.color(context)),
        BarChartRodStackItem(y1, y2, UseType.ga.color(context)),
        BarChartRodStackItem(y2, y3, UseType.wa.color(context)),
        BarChartRodStackItem(y3, y4, UseType.un.color(context)),
      ],
      borderRadius: BorderRadius.zero,
    );
  }

  static List<BarChartGroupData> getRandomData(BuildContext context) {
    const double barSpace = 16;

    const indices = [
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
    ];

    final List<BarChartGroupData> barChartGroupData = [];

    indices.asMap().forEach((key, value) {
      barChartGroupData.add(
        BarChartGroupData(
          x: key,
          barsSpace: barSpace,
          barRods: [
            randomBarChartRodData(context, value),
          ],
        ),
      );
    });

    return barChartGroupData;
  }

  static List<BarChartGroupData> getData(
    Color dark,
    Color normal,
    Color light,
  ) {
    const double barSpace = 16;

    return [
      BarChartGroupData(
        x: 0,
        barsSpace: barSpace,
        barRods: [
          BarChartRodData(
            toY: 17,
            rodStackItems: [
              BarChartRodStackItem(0, 2, dark),
              BarChartRodStackItem(2, 12, normal),
              BarChartRodStackItem(12, 17, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 24,
            rodStackItems: [
              BarChartRodStackItem(0, 13, dark),
              BarChartRodStackItem(13, 14, normal),
              BarChartRodStackItem(14, 24, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 23,
            rodStackItems: [
              BarChartRodStackItem(0, 6, dark),
              BarChartRodStackItem(6, 18, normal),
              BarChartRodStackItem(18, 23, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 29,
            rodStackItems: [
              BarChartRodStackItem(0, 9, dark),
              BarChartRodStackItem(9, 15, normal),
              BarChartRodStackItem(15, 29, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 32,
            rodStackItems: [
              BarChartRodStackItem(0, 2, dark),
              BarChartRodStackItem(2, 17, normal),
              BarChartRodStackItem(17, 32, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: barSpace,
        barRods: [
          BarChartRodData(
            toY: 31,
            rodStackItems: [
              BarChartRodStackItem(0, 11, dark),
              BarChartRodStackItem(11, 18, normal),
              BarChartRodStackItem(18, 31, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 35,
            rodStackItems: [
              BarChartRodStackItem(0, 14, dark),
              BarChartRodStackItem(14, 27, normal),
              BarChartRodStackItem(27, 35, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 31,
            rodStackItems: [
              BarChartRodStackItem(0, 8, dark),
              BarChartRodStackItem(8, 24, normal),
              BarChartRodStackItem(24, 31, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 15,
            rodStackItems: [
              BarChartRodStackItem(0, 6, dark),
              BarChartRodStackItem(6, 12, normal),
              BarChartRodStackItem(12, 15, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 17,
            rodStackItems: [
              BarChartRodStackItem(0, 9, dark),
              BarChartRodStackItem(9, 15, normal),
              BarChartRodStackItem(15, 17, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: barSpace,
        barRods: [
          BarChartRodData(
            toY: 34,
            rodStackItems: [
              BarChartRodStackItem(0, 6, dark),
              BarChartRodStackItem(6, 23, normal),
              BarChartRodStackItem(23, 34, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 32,
            rodStackItems: [
              BarChartRodStackItem(0, 7, dark),
              BarChartRodStackItem(7, 24, normal),
              BarChartRodStackItem(24, 32, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 14,
            rodStackItems: [
              BarChartRodStackItem(0, 1, dark),
              BarChartRodStackItem(1, 12, normal),
              BarChartRodStackItem(12, 14, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 20,
            rodStackItems: [
              BarChartRodStackItem(0, 4, dark),
              BarChartRodStackItem(4, 15, normal),
              BarChartRodStackItem(15, 20, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 24,
            rodStackItems: [
              BarChartRodStackItem(0, 4, dark),
              BarChartRodStackItem(4, 15, normal),
              BarChartRodStackItem(15, 24, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: barSpace,
        barRods: [
          BarChartRodData(
            toY: 14,
            rodStackItems: [
              BarChartRodStackItem(0, 1, dark),
              BarChartRodStackItem(1, 12, normal),
              BarChartRodStackItem(12, 14, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 27,
            rodStackItems: [
              BarChartRodStackItem(0, 7, dark),
              BarChartRodStackItem(7, 25, normal),
              BarChartRodStackItem(25, 27, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 29,
            rodStackItems: [
              BarChartRodStackItem(0, 6, dark),
              BarChartRodStackItem(6, 23, normal),
              BarChartRodStackItem(23, 29, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 16,
            rodStackItems: [
              BarChartRodStackItem(0, 9, dark),
              BarChartRodStackItem(9, 15, normal),
              BarChartRodStackItem(15, 16, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 15,
            rodStackItems: [
              BarChartRodStackItem(0, 7, dark),
              BarChartRodStackItem(7, 12, normal),
              BarChartRodStackItem(12, 15, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
        ],
      ),
    ];
  }
}
