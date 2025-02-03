import 'package:fluffychat/pangea/events/models/content_feedback.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';

class LemmaInfoRequest {
  final String lemma;
  final String partOfSpeech;
  final String lemmaLang;
  final String userL1;

  ContentFeedback<LemmaInfoResponse>? feedback;

  LemmaInfoRequest({
    required String partOfSpeech,
    required String lemmaLang,
    required this.userL1,
    required this.lemma,
    this.feedback,
  })  : partOfSpeech = partOfSpeech.toLowerCase(),
        lemmaLang = lemmaLang.toLowerCase();

  Map<String, dynamic> toJson() {
    return {
      'lemma': lemma,
      'part_of_speech': partOfSpeech,
      'lemma_lang': lemmaLang,
      'user_l1': userL1,
      'feedback': feedback?.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LemmaInfoRequest &&
          runtimeType == other.runtimeType &&
          lemma == other.lemma &&
          partOfSpeech == other.partOfSpeech &&
          feedback == other.feedback;

  @override
  int get hashCode =>
      lemma.hashCode ^ partOfSpeech.hashCode ^ feedback.hashCode;

  String get storageKey {
    return 'l:$lemma,p:$partOfSpeech,lang:$lemmaLang,l1:$userL1';
  }
}
