import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/choreographer/constants/choreo_constants.dart';

class ITResponseModel {
  String fullTextTranslation;
  List<Continuance> continuances;
  List<Continuance>? goldContinuances;
  bool isFinal;
  String? translationId;
  int payloadId;

  ITResponseModel({
    required this.fullTextTranslation,
    required this.continuances,
    required this.translationId,
    required this.goldContinuances,
    required this.isFinal,
    required this.payloadId,
  });

  factory ITResponseModel.fromJson(Map<String, dynamic> json) {
    //PTODO - is continuances a variable type? can we change that?
    if (json['continuances'].runtimeType == String) {
      debugPrint("continuances was string - ${json['continuances']}");
      json['continuances'] = [];
      json['finished'] = true;
    }

    final List<Continuance> interimCont = (json['continuances'] as List)
        .mapIndexed((index, e) {
          e["index"] = index;
          return Continuance.fromJson(e);
        })
        .toList()
        .take(ChoreoConstants.numberOfITChoices)
        .toList()
        .cast<Continuance>()
        //can't do this on the backend because step translation can't filter them out
        .where((element) => element.inDictionary)
        .toList();

    interimCont.shuffle();

    return ITResponseModel(
      fullTextTranslation: json["full_text_translation"] ?? json["translation"],
      continuances: interimCont,
      translationId: json['translation_id'],
      payloadId: json['payload_id'] ?? 0,
      isFinal: json['finished'] ?? false,
      goldContinuances: json['gold_continuances'] != null
          ? (json['gold_continuances'] as Iterable).map((e) {
              e["gold"] = true;
              return Continuance.fromJson(e);
            }).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_text_translation'] = fullTextTranslation;
    data['continuances'] = continuances.map((v) => v.toJson()).toList();
    if (translationId != null) {
      data['translation_id'] = translationId;
    }
    data['payload_id'] = payloadId;
    data["finished"] = isFinal;
    return data;
  }
}

class Continuance {
  /// only saving this top set in a condensed json form
  double probability;
  int level;
  String text;
  // List<PangeaToken> tokens;

  /// saving this in a full json form
  String description;
  int? indexSavedByServer;
  bool wasClicked;
  bool inDictionary;
  bool hasInfo;
  bool gold;

  Continuance({
    required this.probability,
    required this.level,
    required this.text,
    required this.description,
    required this.indexSavedByServer,
    required this.wasClicked,
    required this.inDictionary,
    required this.hasInfo,
    required this.gold,
    // required this.tokens,
  });

  factory Continuance.fromJson(Map<String, dynamic> json) {
    // final List<PangeaToken> tokensInternal = (json[ModelKey.tokens] != null)
    //     ? (json[ModelKey.tokens] as Iterable)
    //         .map<PangeaToken>(
    //           (e) => PangeaToken.fromJson(e as Map<String, dynamic>),
    //         )
    //         .toList()
    //         .cast<PangeaToken>()
    //     : [];
    return Continuance(
      probability: json['probability'].toDouble(),
      level: json['level'],
      text: json['text'],
      description: json['description'] ?? "",
      indexSavedByServer: json["index"],
      inDictionary: json['in_dictionary'] ?? true,
      wasClicked: json['clkd'] ?? false,
      hasInfo: json['has_info'] ?? false,
      gold: json['gold'] ?? false,
      // tokens: tokensInternal,
    );
  }

  Map<String, dynamic> toJson([bool condensed = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['probability'] = probability;
    data['level'] = level;
    data['text'] = text;
    data['clkd'] = wasClicked;
    // data[ModelKey.tokens] = tokens.map((e) => e.toJson()).toList();

    if (!condensed) {
      data['description'] = description;
      data['in_dictionary'] = inDictionary;
      data['has_info'] = hasInfo;
      data["index"] = indexSavedByServer;
      data['gold'] = gold;
    }
    return data;
  }

  Color? get color {
    if (!wasClicked) return null;
    switch (level) {
      case ChoreoConstants.levelThresholdForGreen:
        return ChoreoConstants.green;
      case ChoreoConstants.levelThresholdForYellow:
        return ChoreoConstants.yellow;
      case ChoreoConstants.levelThresholdForRed:
        return ChoreoConstants.red;
      default:
        return null;
    }
  }

  String? feedbackText(BuildContext context) {
    final L10n l10n = L10n.of(context);
    switch (level) {
      case ChoreoConstants.levelThresholdForGreen:
        return l10n.greenFeedback;
      case ChoreoConstants.levelThresholdForYellow:
        return l10n.yellowFeedback;
      case ChoreoConstants.levelThresholdForRed:
        return l10n.redFeedback;
      default:
        return null;
    }
  }
}
