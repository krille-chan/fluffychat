import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';

class OverlayListEntry {
  final OverlayEntry entry;
  final String? key;

  OverlayListEntry(this.entry, {this.key});
}

class PangeaAnyState {
  final Map<String, LayerLinkAndKey> _layerLinkAndKeys = {};
  List<OverlayListEntry> entries = [];

  dispose() {
    closeOverlay();
    _layerLinkAndKeys.clear();
  }

  LayerLinkAndKey layerLinkAndKey(
    String transformTargetId, [
    throwErrorIfNotThere = false,
  ]) {
    if (_layerLinkAndKeys[transformTargetId] == null) {
      if (throwErrorIfNotThere) {
        Sentry.addBreadcrumb(Breadcrumb(data: _layerLinkAndKeys));
        throw Exception("layerLinkAndKey with null for $transformTargetId");
      } else {
        _layerLinkAndKeys[transformTargetId] =
            LayerLinkAndKey(transformTargetId);
      }
    }

    return _layerLinkAndKeys[transformTargetId]!;
  }

  void disposeByWidgetKey(String transformTargetId) {
    final index =
        entries.indexWhere((element) => element.key == transformTargetId);
    if (index != -1) {
      entries[index].entry.remove();
      entries.removeAt(index);
    }
    _layerLinkAndKeys.remove(transformTargetId);
  }

  void openOverlay(
    OverlayEntry entry,
    BuildContext context, {
    String? overlayKey,
  }) {
    if (overlayKey != null &&
        entries.any((element) => element.key == overlayKey)) {
      return;
    }

    entries.add(OverlayListEntry(entry, key: overlayKey));
    Overlay.of(context).insert(entry);
  }

  void closeOverlay([String? overlayKey]) {
    final entry = overlayKey != null
        ? entries.firstWhereOrNull((element) => element.key == overlayKey)
        : entries.lastOrNull;

    if (entry != null) {
      try {
        entry.entry.remove();
      } catch (err, s) {
        ErrorHandler.logError(
          e: err,
          s: s,
          data: {
            "overlay": entry,
          },
        );
      }
      entries.remove(entry);
    }
  }

  void closeAllOverlays() {
    for (int i = 0; i < entries.length; i++) {
      try {
        entries.last.entry.remove();
      } catch (err, s) {
        ErrorHandler.logError(
          e: err,
          s: s,
          data: {
            "overlay": entries.last,
          },
        );
      }
      entries.removeLast();
    }
  }

  LayerLinkAndKey messageLinkAndKey(String eventId) => layerLinkAndKey(eventId);

  // String chatViewTargetKey(String? roomId) => "chatViewKey$roomId";
  // LayerLinkAndKey chatViewLinkAndKey(String? roomId) =>
  //     layerLinkAndKey(chatViewTargetKey(roomId));

  RenderBox? getRenderBox(String key) =>
      layerLinkAndKey(key).key.currentContext?.findRenderObject() as RenderBox?;
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

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is LayerLinkAndKey &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          link == other.link &&
          transformTargetId == other.transformTargetId;

  @override
  int get hashCode => key.hashCode ^ link.hashCode ^ transformTargetId.hashCode;
}
