import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/models/pangea_match_model.dart';

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

  PangeaMatch? get pangeaMatch =>
      choreographer.igc.igcTextData?.matches[matchIndex];
}
