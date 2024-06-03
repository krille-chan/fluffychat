import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/models/analytics_model.dart';
import 'package:fluffychat/pangea/models/constructs_analytics_model.dart';
import 'package:flutter/material.dart';

import '../enum/construct_type_enum.dart';

class ConstructAnalyticsModel extends AnalyticsModel {
  ConstructType type;
  List<LemmaConstructsModel> uses;

  ConstructAnalyticsModel({
    required this.type,
    this.uses = const [],
    super.lastUpdated,
    super.prevEventId,
    super.prevLastUpdated,
  });

  static const _lastUpdatedKey = "lupt";
  static const _usesKey = "uses";

  factory ConstructAnalyticsModel.fromJson(Map<String, dynamic> json) {
    // try {
    // debugger(
    //   when:
    //       kDebugMode && (json['uses'] == null || json[ModelKey.lemma] == null),
    // );
    return ConstructAnalyticsModel(
      // lemma: json[ModelKey.lemma],
      // uses: (json['uses'] as Iterable)
      //     .map<OneConstructUse?>(
      //       (use) => use != null ? OneConstructUse.fromJson(use) : null,
      //     )
      //     .where((element) => element != null)
      //     .cast<OneConstructUse>()
      //     .toList(),
      type: ConstructTypeUtil.fromString(json['type']),
      lastUpdated: json[_lastUpdatedKey] != null
          ? DateTime.parse(json[_lastUpdatedKey])
          : null,
      prevEventId: json[ModelKey.prevEventId],
      prevLastUpdated: json[ModelKey.prevLastUpdated] != null
          ? DateTime.parse(json[ModelKey.prevLastUpdated])
          : null,
      uses: json[_usesKey]
          .values
          .map((lemmaUses) => LemmaConstructsModel.fromJson(lemmaUses))
          .cast<LemmaConstructsModel>()
          .toList(),
    );
    // } catch (err) {
    //   debugger(when: kDebugMode);
    //   rethrow;
    // }
  }

  toJson() {
    final Map<String, dynamic> usesMap = {};
    for (final use in uses) {
      usesMap[use.lemma] = use.toJson();
    }

    return {
      // ModelKey.lemma: lemma,
      // 'uses': uses.map((use) => use.toJson()).toList(),
      'type': type.string,
      _lastUpdatedKey: lastUpdated?.toIso8601String(),
      _usesKey: usesMap,
      ModelKey.prevEventId: prevEventId,
      ModelKey.prevLastUpdated: prevLastUpdated?.toIso8601String(),
    };
  }

  // void addUsesByUseType(List<OneConstructUse> uses) {
  //   for (final use in uses) {
  //     if (use.lemma != lemma) {
  //       throw Exception('lemma mismatch');
  //     }
  //     uses.add(use);
  //   }
  // }
}

class LemmaConstructsModel {
  String lemma;
  List<OneConstructUse> uses;

  LemmaConstructsModel({
    required this.lemma,
    this.uses = const [],
  });

  factory LemmaConstructsModel.fromJson(Map<String, dynamic> json) {
    return LemmaConstructsModel(
      lemma: json[ModelKey.lemma],
      uses: (json['uses'] ?? [] as Iterable)
          .map<OneConstructUse?>(
            (use) => use != null ? OneConstructUse.fromJson(use) : null,
          )
          .where((element) => element != null)
          .cast<OneConstructUse>()
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ModelKey.lemma: lemma,
      'uses': uses.map((use) => use.toJson()).toList(),
    };
  }
}

enum ConstructUseType {
  /// produced in chat by user, igc was run, and we've judged it to be a correct use
  wa,

  /// produced in chat by user, igc was run, and we've judged it to be a incorrect use
  /// Note: if the IGC match is ignored, this is not counted as an incorrect use
  ga,

  /// produced in chat by user and igc was not run
  unk,

  /// selected correctly in IT flow
  corIt,

  /// encountered as IT distractor and correctly ignored it
  ignIt,

  /// encountered as it distractor and selected it
  incIt,

  /// encountered in igc match and ignored match
  ignIGC,

  /// selected correctly in IGC flow
  corIGC,

  /// encountered as distractor in IGC flow and selected it
  incIGC,
}

extension on ConstructUseType {
  String get string {
    switch (this) {
      case ConstructUseType.ga:
        return 'ga';
      case ConstructUseType.wa:
        return 'wa';
      case ConstructUseType.corIt:
        return 'corIt';
      case ConstructUseType.incIt:
        return 'incIt';
      case ConstructUseType.ignIt:
        return 'ignIt';
      case ConstructUseType.ignIGC:
        return 'ignIGC';
      case ConstructUseType.corIGC:
        return 'corIGC';
      case ConstructUseType.incIGC:
        return 'incIGC';
      case ConstructUseType.unk:
        return 'unk';
    }
  }

  IconData get icon {
    switch (this) {
      case ConstructUseType.ga:
        return Icons.check;
      case ConstructUseType.wa:
        return Icons.thumb_up_sharp;
      case ConstructUseType.corIt:
        return Icons.check;
      case ConstructUseType.incIt:
        return Icons.close;
      case ConstructUseType.ignIt:
        return Icons.close;
      case ConstructUseType.ignIGC:
        return Icons.close;
      case ConstructUseType.corIGC:
        return Icons.check;
      case ConstructUseType.incIGC:
        return Icons.close;
      case ConstructUseType.unk:
        return Icons.help;
    }
  }
}
