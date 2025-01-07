import 'package:flutter/material.dart';

class WidgetMeasurements {
  static final Map<String, WidgetMeasurements> _fromKey = {};
  static dispose() => _fromKey.clear();
  static WidgetMeasurements defaultFromKey(String key) {
    if (_fromKey[key] == null) {
      _fromKey[key] = WidgetMeasurements(
        position: const Offset(0, 0),
        size: const Size(0, 0),
        uid: key,
      );
    }

    return _fromKey[key]!;
  }

  Offset? position;
  Size? size;
  String? uid;
  WidgetMeasurements({
    required this.position,
    required this.size,
    required this.uid,
  });

  toJson() => {'position': position, 'size': size, 'uid': uid};
}
