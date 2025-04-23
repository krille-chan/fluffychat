import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/morphs/default_morph_mapping.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_models.dart';
import 'construct_type_enum.dart';

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
          try {
            uses.add(OneConstructUse.fromJson(useJson));
          } catch (err, s) {
            ErrorHandler.logError(
              e: err,
              s: s,
              data: {
                "useJson": useJson,
              },
            );
            continue;
          }
        }
      }
    } else {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "Analytics room with non-list uses",
        data: {
          "usesKey": _usesKey,
        },
      );
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
  String lemma;

  // practice activities do not currently include form in the target_construct info
  // for that, this is nullable
  String? form;

  /// For vocab constructs, this is the POS. For morph
  /// constructs, this is the morphological category.
  late String _category;

  ConstructTypeEnum constructType;
  ConstructUseTypeEnum useType;

  /// Used to unqiuely identify the construct use. Useful in the case
  /// that a users makes the same type of mistake multiple times in a
  /// message, and those uses need to be disinguished.
  String? id;
  ConstructUseMetaData metadata;

  int xp;

  OneConstructUse({
    required this.useType,
    required this.lemma,
    required this.constructType,
    required this.metadata,
    required category,
    required this.form,
    required this.xp,
    this.id,
  }) {
    if (category is MorphFeaturesEnum) {
      _category = category.name;
    } else {
      _category = category ?? "other";
    }
  }

  String? get chatId => metadata.roomId;
  String get msgId => metadata.eventId!;
  DateTime get timeStamp => metadata.timeStamp;

  factory OneConstructUse.fromJson(Map<String, dynamic> json) {
    debugger(when: kDebugMode && json['constructType'] == null);

    final ConstructTypeEnum constructType = json['constructType'] != null
        ? ConstructTypeUtil.fromString(json['constructType'])
        : ConstructTypeEnum.vocab;

    final useType = ConstructUseTypeUtil.fromString(json['useType']);

    return OneConstructUse(
      useType: useType,
      lemma: json['lemma'],
      form: json['form'],
      category: getCategory(json, constructType),
      constructType: constructType,
      id: json['id'],
      metadata: ConstructUseMetaData(
        eventId: json['msgId'],
        roomId: json['chatId'],
        timeStamp: DateTime.parse(json['timeStamp']),
      ),
      xp: json['xp'] ?? useType.pointValue,
    );
  }

  Map<String, dynamic> toJson() => {
        'useType': useType.string,
        'chatId': metadata.roomId,
        'timeStamp': metadata.timeStamp.toIso8601String(),
        'form': form,
        'msgId': metadata.eventId,
        'lemma': lemma,
        'constructType': constructType.string,
        'categories': category,
        'id': id,
        'xp': xp,
      };

  String get category {
    if (_category.isEmpty) return "other";
    return _category.toLowerCase();
  }

  static String getCategory(
    Map<String, dynamic> json,
    ConstructTypeEnum constructType,
  ) {
    final categoryEntry = json['cat'] ?? json['categories'];

    if (constructType == ConstructTypeEnum.vocab) {
      final String? category = categoryEntry is String
          ? categoryEntry
          : categoryEntry is List && categoryEntry.isNotEmpty
              ? categoryEntry.first
              : null;
      return category ?? "Other";
    }

    final MorphFeaturesAndTags morphs = defaultMorphMapping;

    if (categoryEntry == null) {
      return morphs.guessMorphCategory(json["lemma"]);
    }

    if ((categoryEntry is List)) {
      if (categoryEntry.isEmpty) {
        return morphs.guessMorphCategory(json["lemma"]);
      }
      return categoryEntry.first;
    } else if (categoryEntry is String) {
      return categoryEntry;
    }

    debugPrint(
      "Category entry is not a list or string -${json['cat'] ?? json['categories']}-",
    );
    return morphs.guessMorphCategory(json["lemma"]);
  }

  Room? getRoom(Client client) {
    if (metadata.roomId == null) return null;
    return client.getRoomById(metadata.roomId!);
  }

  Future<Event?> getEvent(Client client) async {
    final Room? room = getRoom(client);
    if (room == null || metadata.eventId == null) return null;
    return room.getEventById(metadata.eventId!);
  }

  Color pointValueColor(BuildContext context) {
    if (xp == 0) return Theme.of(context).colorScheme.primary;
    return xp > 0 ? AppConfig.gold : Colors.red;
  }

  ConstructIdentifier get identifier => ConstructIdentifier(
        lemma: lemma,
        type: constructType,
        category: category,
      );
}

class ConstructUseMetaData {
  String? eventId;
  String? roomId;
  DateTime timeStamp;

  ConstructUseMetaData({
    required this.roomId,
    required this.timeStamp,
    this.eventId,
  });
}
