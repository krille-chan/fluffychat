import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix_api_lite/utils/try_get_map_extension.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/analytics_misc/client_analytics_extension.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ConstructIdentifier {
  final String lemma;
  final ConstructTypeEnum type;
  final String _category;

  ConstructIdentifier({
    required this.lemma,
    required this.type,
    required category,
  }) : _category = category;

  factory ConstructIdentifier.fromJson(Map<String, dynamic> json) {
    final categoryEntry = json['cat'] ?? json['categories'];
    String? category;
    if (categoryEntry != null) {
      if (categoryEntry is String) {
        category = categoryEntry;
      } else if (categoryEntry is List) {
        category = categoryEntry.first;
      }
    }

    final type = ConstructTypeEnum.values.firstWhereOrNull(
      (e) => e.string == json['type'],
    );

    if (type == null) {
      Sentry.addBreadcrumb(Breadcrumb(message: "type is: ${json['type']}"));
      Sentry.addBreadcrumb(Breadcrumb(data: json));
      throw Exception("Matching construct type not found");
    }

    try {
      return ConstructIdentifier(
        lemma: json['lemma'] as String,
        type: type,
        category: category ?? "",
      );
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s, data: json);
      rethrow;
    }
  }

  String get category {
    if (_category.isEmpty) return "other";
    return _category.toLowerCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'lemma': lemma,
      'type': type.string,
      'cat': category,
    };
  }

  // override operator == and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConstructIdentifier &&
        other.lemma == lemma &&
        other.type == type &&
        (category == other.category ||
            category.toLowerCase() == "other" ||
            other.category.toLowerCase() == "other");
  }

  @override
  int get hashCode {
    return lemma.hashCode ^ type.hashCode;
  }

  String get string {
    return "$lemma:${type.string}-$category".toLowerCase();
  }

  String get partialKey => "$lemma-${type.string}";

  ConstructUses get constructUses =>
      MatrixState.pangeaController.getAnalytics.constructListModel
          .getConstructUses(
        this,
      ) ??
      ConstructUses(
        lemma: lemma,
        constructType: ConstructTypeEnum.morph,
        category: category,
        uses: [],
      );

  String? get userSetEmoji {
    if (type == ConstructTypeEnum.morph) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: Exception("Morphs should not have userSetEmoji"),
        data: toJson(),
      );
      return null;
    }
    if (type == ConstructTypeEnum.vocab) {
      return MatrixState.pangeaController.matrixState.client
          .analyticsRoomLocal()
          ?.getState(PangeaEventTypes.userChosenEmoji, string)
          ?.content
          .tryGet<String>(ModelKey.emoji);
    }
    return null;
  }
}
