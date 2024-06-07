import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/analytics/analytics_model.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../enum/construct_type_enum.dart';

class ConstructAnalyticsModel extends AnalyticsModel {
  ConstructType type;
  List<LemmaConstructsModel> uses;

  ConstructAnalyticsModel({
    required this.type,
    this.uses = const [],
  });

  static const _usesKey = "uses";

  factory ConstructAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return ConstructAnalyticsModel(
      type: ConstructTypeUtil.fromString(json['type']),
      uses: json[_usesKey]
          .values
          .map((lemmaUses) => LemmaConstructsModel.fromJson(lemmaUses))
          .cast<LemmaConstructsModel>()
          .toList(),
    );
  }

  toJson() {
    final Map<String, dynamic> usesMap = {};
    for (final use in uses) {
      usesMap[use.lemma] = use.toJson();
    }

    return {
      'type': type.string,
      _usesKey: usesMap,
    };
  }

  static List<OneConstructUse> formatConstructsContent(
    List<PangeaMessageEvent> recentMsgs,
  ) {
    final List<PangeaMessageEvent> filtered = List.from(recentMsgs);
    final List<OneConstructUse> uses = filtered
        .map(
          (msg) => msg.originalSent?.choreo?.toGrammarConstructUse(
            msg.eventId,
            msg.room.id,
            msg.originServerTs,
          ),
        )
        .where((element) => element != null)
        .cast<List<OneConstructUse>>()
        .expand((element) => element)
        .toList();

    return uses;
  }
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

class OneConstructUse {
  String? lemma;
  ConstructType? constructType;
  String? form;
  ConstructUseType useType;
  String chatId;
  String? msgId;
  DateTime timeStamp;
  String? id;

  OneConstructUse({
    required this.useType,
    required this.chatId,
    required this.timeStamp,
    required this.lemma,
    required this.form,
    required this.msgId,
    required this.constructType,
    this.id,
  });

  factory OneConstructUse.fromJson(Map<String, dynamic> json) {
    return OneConstructUse(
      useType: ConstructUseType.values
          .firstWhere((e) => e.string == json['useType']),
      chatId: json['chatId'],
      timeStamp: DateTime.parse(json['timeStamp']),
      lemma: json['lemma'],
      form: json['form'],
      msgId: json['msgId'],
      constructType: json['constructType'] != null
          ? ConstructTypeUtil.fromString(json['constructType'])
          : null,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson([bool condensed = true]) {
    final Map<String, String?> data = {
      'useType': useType.string,
      'chatId': chatId,
      'timeStamp': timeStamp.toIso8601String(),
      'form': form,
      'msgId': msgId,
    };
    if (!condensed && lemma != null) data['lemma'] = lemma!;
    if (!condensed && constructType != null) {
      data['constructType'] = constructType!.string;
    }
    if (id != null) data['id'] = id;

    return data;
  }

  Room? getRoom(Client client) {
    return client.getRoomById(chatId);
  }

  Future<Event?> getEvent(Client client) async {
    final Room? room = getRoom(client);
    if (room == null || msgId == null) return null;
    return room.getEventById(msgId!);
  }
}

class AggregateConstructUses {
  final List<LemmaConstructsModel> _lemmaUses;

  AggregateConstructUses({required List<LemmaConstructsModel> lemmaUses})
      : _lemmaUses = lemmaUses;

  String get lemma {
    assert(
      _lemmaUses.isNotEmpty &&
          _lemmaUses.every(
            (construct) => construct.lemma == _lemmaUses.first.lemma,
          ),
    );
    return _lemmaUses.first.lemma;
  }

  List<OneConstructUse> get uses => _lemmaUses
      .map((lemmaUse) => lemmaUse.uses)
      .expand((element) => element)
      .toList();
}
