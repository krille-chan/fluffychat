import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';

class SpanCardModel {
  // IGCTextData igcTextData;
  int matchIndex;
  Future<void> Function({required int matchIndex, required int choiceIndex})
      onReplacementSelect;
  Future<void> Function(String) onSentenceRewrite;
  void Function() onIgnore;
  void Function() onITStart;
  Choreographer choreographer;

  SpanCardModel({
    // required this.igcTextData,
    required this.matchIndex,
    required this.onReplacementSelect,
    required this.onSentenceRewrite,
    required this.onIgnore,
    required this.onITStart,
    required this.choreographer,
  });

  PangeaMatch? get pangeaMatch {
    if (choreographer.igc.igcTextData == null) return null;
    if (matchIndex >= choreographer.igc.igcTextData!.matches.length) {
      ErrorHandler.logError(
        m: "matchIndex out of bounds in span card",
        data: {
          "matchIndex": matchIndex,
          "matchesLength": choreographer.igc.igcTextData?.matches.length,
        },
      );
      return null;
    }
    return choreographer.igc.igcTextData?.matches[matchIndex];
  }
}
