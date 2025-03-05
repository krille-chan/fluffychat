import 'dart:convert';

import 'package:fluffychat/pangea/choreographer/models/language_detection_model.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';

/// this class lives within a [PangeaTokensEvent]
/// it always has a [RepresentationEvent] parent
/// These live as separate event so that anyone can add and edit tokens to
/// representation
class PangeaMessageTokens {
  List<PangeaToken> tokens;
  List<LanguageDetection>? detections;

  PangeaMessageTokens({
    required this.tokens,
    this.detections,
  });

  factory PangeaMessageTokens.fromJson(Map<String, dynamic> json) {
    // "tokens" was accidentally used as the key in the first implementation
    // _tokensKey is the correct key
    final something = json[_tokensKey] ?? json["tokens"];

    final Iterable tokensIterable = something is Iterable
        ? something
        : something is String
            ? jsonDecode(json[_tokensKey])
            : null;

    final Iterable? detectionsIterable = json[_detectionsKey] is Iterable
        ? json[_detectionsKey]
        : json[_detectionsKey] is String
            ? jsonDecode(json[_detectionsKey])
            : null;
    return PangeaMessageTokens(
      tokens: tokensIterable
          .map((e) => PangeaToken.fromJson(e))
          .toList()
          .cast<PangeaToken>(),
      detections: detectionsIterable
          ?.map((e) => LanguageDetection.fromJson(e))
          .toList()
          .cast<LanguageDetection>(),
    );
  }

  static const _tokensKey = "tkns";
  static const _detectionsKey = "detections";

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[_tokensKey] = jsonEncode(tokens.map((e) => e.toJson()).toList());
    data[_detectionsKey] =
        jsonEncode(detections?.map((e) => e.toJson()).toList());
    return data;
  }
}
