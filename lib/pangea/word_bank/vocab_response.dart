import 'package:fluffychat/pangea/analytics_misc/construct_identifier.dart';

class VocabResponse {
  List<ConstructIdentifier> vocab;

  DateTime? expireAt;

  VocabResponse({this.vocab = const []}) {
    expireAt = DateTime.now().add(const Duration(days: 100));
  }

  VocabResponse.fromJson(Map<String, dynamic> json)
      : vocab = (json['vocab'] as List)
            .map((e) => ConstructIdentifier.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {
        'vocab': vocab.map((e) => e.toJson()).toList(),
      };
}
