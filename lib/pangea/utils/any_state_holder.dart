// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sentry_flutter/sentry_flutter.dart';

// Project imports:
import '../models/widget_measurement.dart';

class PangeaAnyState {
  final Map<String, StreamController<WidgetMeasurements>?> _streams = {};
  final Map<String, List<WidgetMeasurements>> _pastValues = {};
  final Map<String, LayerLinkAndKey> _layerLinkAndKeys = {};
  OverlayEntry? overlay;

  dispose() {
    closeOverlay();
    _layerLinkAndKeys.clear();
  }

  LayerLinkAndKey layerLinkAndKey(String transformTargetId,
      [throwErrorIfNotThere = false]) {
    if (_layerLinkAndKeys[transformTargetId] == null) {
      if (throwErrorIfNotThere) {
        Sentry.addBreadcrumb(Breadcrumb.fromJson(_layerLinkAndKeys));
        throw Exception("layerLinkAndKey with null for $transformTargetId");
      } else {
        _layerLinkAndKeys[transformTargetId] =
            LayerLinkAndKey(transformTargetId);
      }
    }

    return _layerLinkAndKeys[transformTargetId]!;
  }

  void disposeByWidgetKey(String transformTargetId) {
    _layerLinkAndKeys.remove(transformTargetId);
  }

  void closeOverlay() {
    if (overlay != null) {
      overlay!.remove();
      overlay = null;
    }
  }

  LayerLinkAndKey messageLinkAndKey(String eventId) => layerLinkAndKey(eventId);

  // String chatViewTargetKey(String? roomId) => "chatViewKey$roomId";
  // LayerLinkAndKey chatViewLinkAndKey(String? roomId) =>
  //     layerLinkAndKey(chatViewTargetKey(roomId));
}

class LayerLinkAndKey {
  late LabeledGlobalKey key;
  late LayerLink link;
  String transformTargetId;

  LayerLinkAndKey(this.transformTargetId) {
    key = LabeledGlobalKey(transformTargetId);
    link = LayerLink();
  }

  Map<String, dynamic> toJson() => {
        "key": key.toString(),
        "link": link.toString(),
        "transformTargetId": transformTargetId,
      };
}
