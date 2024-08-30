import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../../enum/construct_type_enum.dart';

class ConstructAnalyticsModel {
  List<OneConstructUse> uses;

  ConstructAnalyticsModel({
    this.uses = const [],
  });

  static const _usesKey = "uses";

  factory ConstructAnalyticsModel.fromJson(Map<String, dynamic> json) {
    final List<OneConstructUse> uses = [];
    if (json[_usesKey] is List) {
      // This is the new format
      uses.addAll(
        (json[_usesKey] as List)
            .map((use) => OneConstructUse.fromJson(use))
            .cast<OneConstructUse>()
            .toList(),
      );
    } else {
      // This is the old format. No data on production should be
      // structured this way, but it's useful for testing.
      try {
        final useValues = (json[_usesKey] as Map<String, dynamic>).values;
        for (final useValue in useValues) {
          final lemma = useValue['lemma'];
          final lemmaUses = useValue[_usesKey];
          for (final useData in lemmaUses) {
            final use = OneConstructUse(
              useType: ConstructUseTypeEnum.ga,
              lemma: lemma,
              form: useData["form"],
              constructType: ConstructTypeEnum.grammar,
              metadata: ConstructUseMetaData(
                eventId: useData["msgId"],
                roomId: useData["chatId"],
                timeStamp: DateTime.parse(useData["timeStamp"]),
              ),
            );
            uses.add(use);
          }
        }
      } catch (err, s) {
        debugPrint("Error parsing ConstructAnalyticsModel");
        ErrorHandler.logError(
          e: err,
          s: s,
          m: "Error parsing ConstructAnalyticsModel",
        );
        debugger(when: kDebugMode);
      }
    }
    return ConstructAnalyticsModel(
      uses: uses,
    );
  }

  toJson() {
    return {
      _usesKey: uses.map((use) => use.toJson()).toList(),
    };
  }
}

class OneConstructUse {
  String? lemma;
  ConstructTypeEnum? constructType;
  String? form;
  ConstructUseTypeEnum useType;
  String? id;
  ConstructUseMetaData metadata;

  OneConstructUse({
    required this.useType,
    required this.lemma,
    required this.constructType,
    required this.metadata,
    this.form,
    this.id,
  });

  String get chatId => metadata.roomId;
  String get msgId => metadata.eventId!;
  DateTime get timeStamp => metadata.timeStamp;

  factory OneConstructUse.fromJson(Map<String, dynamic> json) {
    return OneConstructUse(
      useType: ConstructUseTypeEnum.values
              .firstWhereOrNull((e) => e.string == json['useType']) ??
          ConstructUseTypeEnum.unk,
      lemma: json['lemma'],
      form: json['form'],
      constructType: json['constructType'] != null
          ? ConstructTypeUtil.fromString(json['constructType'])
          : null,
      id: json['id'],
      metadata: ConstructUseMetaData(
        eventId: json['msgId'],
        roomId: json['chatId'],
        timeStamp: DateTime.parse(json['timeStamp']),
      ),
    );
  }

  Map<String, dynamic> toJson([bool condensed = false]) {
    final Map<String, String?> data = {
      'useType': useType.string,
      'chatId': metadata.roomId,
      'timeStamp': metadata.timeStamp.toIso8601String(),
      'form': form,
      'msgId': metadata.eventId,
    };
    if (!condensed && lemma != null) data['lemma'] = lemma!;
    if (!condensed && constructType != null) {
      data['constructType'] = constructType!.string;
    }
    if (id != null) data['id'] = id;

    return data;
  }

  Room? getRoom(Client client) {
    return client.getRoomById(metadata.roomId);
  }

  Future<Event?> getEvent(Client client) async {
    final Room? room = getRoom(client);
    if (room == null || metadata.eventId == null) return null;
    return room.getEventById(metadata.eventId!);
  }

  int get pointValue => useType.pointValue;
}

class ConstructUseMetaData {
  String? eventId;
  String roomId;
  DateTime timeStamp;

  ConstructUseMetaData({
    required this.roomId,
    required this.timeStamp,
    this.eventId,
  });
}
