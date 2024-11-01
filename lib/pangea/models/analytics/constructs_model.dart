import 'dart:developer';

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
  String? form;
  String? category;
  ConstructTypeEnum constructType;
  ConstructUseTypeEnum useType;

  /// Used to unqiuely identify the construct use. Useful in the case
  /// that a users makes the same type of mistake multiple times in a
  /// message, and those uses need to be disinguished.
  String? id;
  ConstructUseMetaData metadata;

  OneConstructUse({
    required this.useType,
    required this.lemma,
    required this.constructType,
    required this.metadata,
    this.category,
    this.form,
    this.id,
  });

  String get chatId => metadata.roomId;
  String get msgId => metadata.eventId!;
  DateTime get timeStamp => metadata.timeStamp;

  factory OneConstructUse.fromJson(Map<String, dynamic> json) {
    final constructType = json['constructType'] != null
        ? ConstructTypeUtil.fromString(json['constructType'])
        : null;
    debugger(when: kDebugMode && constructType == null);

    final categoryEntry = json['categories'];
    String? category;
    if (categoryEntry != null) {
      if ((categoryEntry is List) && categoryEntry.isNotEmpty) {
        category = categoryEntry.first;
      } else if (categoryEntry is String) {
        category = categoryEntry;
      }
    }

    return OneConstructUse(
      useType: ConstructUseTypeUtil.fromString(json['useType']),
      lemma: json['lemma'],
      form: json['form'],
      category: category,
      constructType: constructType ?? ConstructTypeEnum.vocab,
      id: json['id'],
      metadata: ConstructUseMetaData(
        eventId: json['msgId'],
        roomId: json['chatId'],
        timeStamp: DateTime.parse(json['timeStamp']),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'useType': useType.string,
      'chatId': metadata.roomId,
      'timeStamp': metadata.timeStamp.toIso8601String(),
      'form': form,
      'msgId': metadata.eventId,
    };

    data['lemma'] = lemma!;
    data['constructType'] = constructType.string;

    if (id != null) data['id'] = id;
    data['categories'] = category;
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
