import 'dart:developer';

import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../enum/construct_type_enum.dart';

class ConstructUses {
  String lemma;
  ConstructType type;

  List<OneConstructUse> uses;

  //PTODO - how to incorporate semantic similarity score into this?

  //PTODO - add variables for saving requests for
  //  1) definitions
  //  2) translations
  //  3) examples??? (gpt suggested)

  ConstructUses({
    required this.lemma,
    required this.type,
    this.uses = const [],
  });

  factory ConstructUses.fromJson(Map<String, dynamic> json) {
    // try {
    debugger(
      when:
          kDebugMode && (json['uses'] == null || json[ModelKey.lemma] == null),
    );
    return ConstructUses(
      lemma: json[ModelKey.lemma],
      uses: (json['uses'] as Iterable)
          .map<OneConstructUse?>(
            (use) => use != null ? OneConstructUse.fromJson(use) : null,
          )
          .where((element) => element != null)
          .cast<OneConstructUse>()
          .toList(),
      type: ConstructTypeUtil.fromString(json['type']),
    );
    // } catch (err) {
    //   debugger(when: kDebugMode);
    //   rethrow;
    // }
  }

  toJson() {
    return {
      ModelKey.lemma: lemma,
      'uses': uses.map((use) => use.toJson()).toList(),
      'type': type.string,
    };
  }

  void addUsesByUseType(List<OneConstructUse> uses) {
    for (final use in uses) {
      if (use.lemma != lemma) {
        throw Exception('lemma mismatch');
      }
      uses.add(use);
    }
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
