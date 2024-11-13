import 'dart:developer';

import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
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
      for (final useJson in json[_usesKey]) {
        // grammar construct uses are deprecated so but some are saved
        // here we're filtering from data
        if (["grammar", "g"].contains(useJson['constructType'])) {
          continue;
        } else {
          uses.add(OneConstructUse.fromJson(useJson));
        }
      }
    } else {
      debugger(when: kDebugMode);
      ErrorHandler.logError(m: "Analytics room with non-list uses");
    }

    return ConstructAnalyticsModel(
      uses: uses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _usesKey: uses.map((use) => use.toJson()).toList(),
    };
  }
}

class OneConstructUse {
  /// the lemma of vocab or the text of a morph tag
  /// e.g. "be" or "Present"
  String? lemma;

  /// exact text as it appeared in the text
  String? form;

  /// For vocab constructs, this is the POS. For morph
  /// constructs, this is the morphological category.
  /// e.g. "are" or "Tense"
  /// TODO - for old uses without category, we should
  /// try guessing the category from the lemma as best we can
  /// while it's not 1-to-1, most morph tags are unique
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

    final categoryEntry = json['cat'] ?? json['categories'];
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

  ConstructIdentifier get identifier => ConstructIdentifier(
        lemma: lemma!,
        type: constructType,
        category: category ?? "",
      );
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
