import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';

class TokenPositionModel {
  /// Start index of the full substring in the message
  final int start;

  /// End index of the full substring in the message
  final int end;

  /// Start index of the token in the message
  final int tokenStart;

  /// End index of the token in the message
  final int tokenEnd;

  final bool selected;
  final bool hideContent;
  final PangeaToken? token;

  const TokenPositionModel({
    required this.start,
    required this.end,
    required this.tokenStart,
    required this.tokenEnd,
    required this.hideContent,
    required this.selected,
    this.token,
  });
}
