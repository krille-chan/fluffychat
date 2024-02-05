import 'package:matrix/matrix.dart';

class GridLayoutDefinition {
  late String name;
  late int columns;
  late int rows;
  late int minTiles;
  late int maxTiles;
  late int minWidth;
  late int minHeight;

  GridLayoutDefinition({
    required this.name,
    required this.columns,
    required this.rows,
    required this.minTiles,
    required this.maxTiles,
    required this.minWidth,
    required this.minHeight,
  });
}

// ignore: non_constant_identifier_names
List<GridLayoutDefinition> GRID_LAYOUTS = [
  GridLayoutDefinition(
    name: '1x1',
    columns: 1,
    rows: 1,
    minTiles: 1,
    maxTiles: 1,
    minWidth: 0,
    minHeight: 0,
  ),
  GridLayoutDefinition(
    name: '1x2',
    columns: 1,
    rows: 2,
    minTiles: 2,
    maxTiles: 2,
    minWidth: 0,
    minHeight: 0,
  ),
  GridLayoutDefinition(
    name: '2x1',
    columns: 2,
    rows: 1,
    minTiles: 2,
    maxTiles: 2,
    minWidth: 560,
    minHeight: 0,
  ),
  GridLayoutDefinition(
    name: '2x2',
    columns: 2,
    rows: 2,
    minTiles: 3,
    maxTiles: 4,
    minWidth: 560,
    minHeight: 0,
  ),
  GridLayoutDefinition(
    name: '3x3',
    columns: 3,
    rows: 3,
    minTiles: 5,
    maxTiles: 9,
    minWidth: 700,
    minHeight: 0,
  ),
  GridLayoutDefinition(
    name: '4x4',
    columns: 4,
    rows: 4,
    minTiles: 10,
    maxTiles: 16,
    minWidth: 960,
    minHeight: 0,
  ),
  GridLayoutDefinition(
    name: '5x5',
    columns: 5,
    rows: 5,
    minTiles: 17,
    maxTiles: 25,
    minWidth: 1100,
    minHeight: 0,
  ),
];

GridLayoutDefinition selectGridLayout(
  List<GridLayoutDefinition> layouts,
  int participantCount,
  double width,
  double height,
) {
  int currentLayoutIndex = 0;
  var layout = layouts.firstWhere(
    (layout_) {
      currentLayoutIndex = layouts.indexOf(layout_);
      final isBiggerLayoutAvailable = layouts.indexWhere(
            (l) =>
                layouts.indexOf(l) > currentLayoutIndex &&
                l.maxTiles == layout_.maxTiles,
          ) !=
          -1;
      return layout_.maxTiles >= participantCount && !isBiggerLayoutAvailable;
    },
    orElse: () {
      final lastLayout = layouts.last;
      // ignore: avoid_print
      Logs().d(
        'No layout found for: participantCount: $participantCount, width/height: $width/$height fallback to biggest available layout (${lastLayout.name}).',
      );
      return lastLayout;
    },
  );

  if (width < layout.minWidth || height < layout.minHeight) {
    if (currentLayoutIndex > 0) {
      final smallerLayout = layouts[currentLayoutIndex - 1];
      layout = selectGridLayout(
        layouts.sublist(0, currentLayoutIndex),
        smallerLayout.maxTiles,
        width,
        height,
      );
    }
  }

  return layout;
}
