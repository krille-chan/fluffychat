import 'dart:convert';

import 'package:fluffychat/pangea/models/pangea_token_model.dart';

/// this class lives within a [PangeaTokensEvent]
/// it always has a [RepresentationEvent] parent
/// These live as separate event so that anyone can add and edit tokens to
/// representation
class PangeaMessageTokens {
  List<PangeaToken> tokens;

  PangeaMessageTokens({
    required this.tokens,
  });

  factory PangeaMessageTokens.fromJson(Map<String, dynamic> json) {
    return PangeaMessageTokens(
      tokens: (jsonDecode(json[_tokensKey] ?? "[]") as Iterable)
          .map((e) => PangeaToken.fromJson(e))
          .toList()
          .cast<PangeaToken>(),
    );
  }

  static const _tokensKey = "tkns";

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[_tokensKey] = jsonEncode(tokens.map((e) => e.toJson()).toList());
    return data;
  }
}
