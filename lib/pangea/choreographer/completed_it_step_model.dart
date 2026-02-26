class CompletedITStepModel {
  final List<ContinuanceModel> continuances;
  final int chosen;

  const CompletedITStepModel(this.continuances, {required this.chosen});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['continuances'] = continuances.map((e) => e.toJson(true)).toList();
    data['chosen'] = chosen;
    return data;
  }

  factory CompletedITStepModel.fromJson(Map<String, dynamic> json) {
    final List<ContinuanceModel> continuances = <ContinuanceModel>[];
    for (final Map<String, dynamic> continuance in json['continuances']) {
      continuances.add(ContinuanceModel.fromJson(continuance));
    }
    return CompletedITStepModel(continuances, chosen: json['chosen']);
  }

  ContinuanceModel? get chosenContinuance {
    return continuances[chosen];
  }
}

class ContinuanceModel {
  final double probability;
  final int level;
  final String text;

  final String description;
  final int? indexSavedByServer;
  final bool wasClicked;
  final bool inDictionary;
  final bool hasInfo;
  final bool gold;

  const ContinuanceModel({
    required this.probability,
    required this.level,
    required this.text,
    required this.description,
    required this.indexSavedByServer,
    required this.wasClicked,
    required this.inDictionary,
    required this.hasInfo,
    required this.gold,
  });

  factory ContinuanceModel.fromJson(Map<String, dynamic> json) {
    return ContinuanceModel(
      probability: json['probability'].toDouble(),
      level: json['level'],
      text: json['text'],
      description: json['description'] ?? "",
      indexSavedByServer: json["index"],
      inDictionary: json['in_dictionary'] ?? true,
      wasClicked: json['clkd'] ?? false,
      hasInfo: json['has_info'] ?? false,
      gold: json['gold'] ?? false,
    );
  }

  Map<String, dynamic> toJson([bool condensed = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['probability'] = probability;
    data['level'] = level;
    data['text'] = text;
    data['clkd'] = wasClicked;

    if (!condensed) {
      data['description'] = description;
      data['in_dictionary'] = inDictionary;
      data['has_info'] = hasInfo;
      data["index"] = indexSavedByServer;
      data['gold'] = gold;
    }
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContinuanceModel &&
          runtimeType == other.runtimeType &&
          probability == other.probability &&
          level == other.level &&
          text == other.text &&
          description == other.description &&
          indexSavedByServer == other.indexSavedByServer &&
          wasClicked == other.wasClicked &&
          inDictionary == other.inDictionary &&
          hasInfo == other.hasInfo &&
          gold == other.gold;

  @override
  int get hashCode =>
      probability.hashCode ^
      level.hashCode ^
      text.hashCode ^
      description.hashCode ^
      indexSavedByServer.hashCode ^
      wasClicked.hashCode ^
      inDictionary.hashCode ^
      hasInfo.hashCode ^
      gold.hashCode;
}
