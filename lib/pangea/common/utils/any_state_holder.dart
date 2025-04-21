import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';

class OverlayListEntry {
  final OverlayEntry entry;
  final String? key;
  final bool canPop;

  OverlayListEntry(
    this.entry, {
    this.key,
    this.canPop = true,
  });
}

class PangeaAnyState {
  final Map<String, LayerLinkAndKey> _layerLinkAndKeys = {};
  List<OverlayListEntry> entries = [];

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

  void openOverlay(
    OverlayEntry entry,
    BuildContext context, {
    String? overlayKey,
    bool canPop = true,
  }) {
    if (overlayKey != null &&
        entries.any((element) => element.key == overlayKey)) {
      return;
    }

    entries.add(
      OverlayListEntry(
        entry,
        key: overlayKey,
        canPop: canPop,
      ),
    );
    Overlay.of(context).insert(entry);
  }

  void closeOverlay([String? overlayKey]) {
    final entry = overlayKey != null
        ? entries.firstWhereOrNull((element) => element.key == overlayKey)
        : entries.lastWhereOrNull(
            (element) => element.canPop,
          );

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
    final shouldRemove = entries.where((element) => element.canPop).toList();
    if (shouldRemove.isEmpty) return;
    for (int i = 0; i < shouldRemove.length; i++) {
      try {
        shouldRemove[i].entry.remove();
      } catch (err, s) {
        ErrorHandler.logError(
          e: err,
          s: s,
          data: {
            "overlay": shouldRemove[i],
          },
        );
      }
      entries.remove(shouldRemove[i]);
    }
  }

  RenderBox? getRenderBox(String key) =>
      layerLinkAndKey(key).key.currentContext?.findRenderObject() as RenderBox?;

  bool isOverlayOpen(String overlayKey) {
    return entries.any((element) => element.key == overlayKey);
  }

  List<String> getMatchingOverlayKeys(RegExp regex) {
    return entries
        .where((e) => e.key != null)
        .where((element) => regex.hasMatch(element.key!))
        .map((e) => e.key)
        .whereType<String>()
        .toList();
  }
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
