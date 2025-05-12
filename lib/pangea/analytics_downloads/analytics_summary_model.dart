import 'package:fluffychat/pangea/analytics_downloads/analytics_summary_enum.dart';

class AnalyticsSummaryModel {
  String? lemma;
  String? morphFeature;
  String? morphTag;
  int xp;
  List<String> forms;
  List<String> exampleMessages;
  int independantUseOccurrences;
  int assistedUseOccurrences;

  AnalyticsSummaryModel({
    this.lemma,
    this.morphFeature,
    this.morphTag,
    required this.xp,
    required this.forms,
    required this.exampleMessages,
    required this.independantUseOccurrences,
    required this.assistedUseOccurrences,
  });

  Map<String, dynamic> toJson() {
    return {
      'lemma': lemma,
      'morphFeature': morphFeature,
      'morphTag': morphTag,
      'xp': xp,
      'forms': forms,
      'exampleMessages': exampleMessages,
      'totalOriginalUseOccurrences': independantUseOccurrences,
      'correctOriginalUseOccurrences': independantUseOccurrences,
    };
  }

  dynamic getValue(AnalyticsSummaryEnum key) {
    switch (key) {
      case AnalyticsSummaryEnum.lemma:
        return lemma;
      case AnalyticsSummaryEnum.morphFeature:
        return morphFeature;
      case AnalyticsSummaryEnum.morphTag:
        return morphTag;
      case AnalyticsSummaryEnum.xp:
        return xp;
      case AnalyticsSummaryEnum.forms:
        return forms;
      case AnalyticsSummaryEnum.exampleMessages:
        return exampleMessages;
      case AnalyticsSummaryEnum.independentUseOccurrences:
        return independantUseOccurrences;
      case AnalyticsSummaryEnum.assistedUseOccurrences:
        return assistedUseOccurrences;
    }
  }
}
