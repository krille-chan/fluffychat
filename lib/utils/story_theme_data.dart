import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

class StoryThemeData {
  final Color? color1;
  final Color? color2;
  final BoxFit fit;
  final int alignmentX;
  final int alignmentY;

  static const String contentKey = 'msc3588.stories.design';

  const StoryThemeData({
    this.color1,
    this.color2,
    this.fit = BoxFit.contain,
    this.alignmentX = 0,
    this.alignmentY = 0,
  });

  factory StoryThemeData.fromJson(Map<String, dynamic> json) {
    final color1Int = json.tryGet<int>('color1');
    final color2Int = json.tryGet<int>('color2');
    final color1 = color1Int == null ? null : Color(color1Int);
    final color2 = color2Int == null ? null : Color(color2Int);
    return StoryThemeData(
      color1: color1,
      color2: color2,
      fit:
          json.tryGet<String>('fit') == 'cover' ? BoxFit.cover : BoxFit.contain,
      alignmentX: json.tryGet<int>('alignment_x') ?? 0,
      alignmentY: json.tryGet<int>('alignment_y') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        if (color1 != null) 'color1': color1?.value,
        if (color2 != null) 'color2': color2?.value,
        'fit': fit.name,
        'alignment_x': alignmentX,
        'alignment_y': alignmentY,
      };
}
