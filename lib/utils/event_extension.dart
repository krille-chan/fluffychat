import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';

extension LocalizedBody on Event {
  IconData get statusIcon {
    switch (this.status) {
      case -1:
        return Icons.error_outline;
      case 0:
        return Icons.timer;
      case 1:
        return Icons.done;
      case 2:
        return Icons.done_all;
      default:
        return Icons.done;
    }
  }

  String get sizeString {
    if (content["info"] is Map<String, dynamic> &&
        content["info"].containsKey("size")) {
      num size = content["info"]["size"];
      if (size < 1000000) {
        size = size / 1000;
        return "${size.toString()}kb";
      } else if (size < 1000000000) {
        size = size / 1000000;
        return "${size.toString()}mb";
      } else {
        size = size / 1000000000;
        return "${size.toString()}gb";
      }
    } else {
      return null;
    }
  }
}
