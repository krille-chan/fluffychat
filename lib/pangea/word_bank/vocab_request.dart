import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';

class VocabRequest {
  String langCode;
  LanguageLevelTypeEnum level;
  String? prefix;
  String? suffix;
  String? lemma;
  String? pos;

  int count;

  VocabRequest({
    required this.langCode,
    required this.level,
    this.lemma,
    this.pos,
    this.prefix,
    this.suffix,
    this.count = 10,
  });

  VocabRequest.fromJson(Map<String, dynamic> json)
      : langCode = json['langCode'],
        level = LanguageLevelTypeEnum.values[json['level']],
        prefix = json['prefix'],
        suffix = json['suffix'],
        count = json['count'],
        lemma = json['lemma'],
        pos = json['pos'];

  Map<String, dynamic> toJson() => {
        'langCode': langCode,
        'level': level.index,
        'prefix': prefix,
        'suffix': suffix,
        'lemma': lemma,
        'pos': pos,
        'count': count,
      };

  String get storageKey =>
      '${langCode}_${level.index}_${prefix}_${suffix}_$count';

  @override
  operator ==(Object other) {
    if (other is VocabRequest) {
      return langCode == other.langCode &&
          level == other.level &&
          prefix == other.prefix &&
          suffix == other.suffix &&
          count == other.count &&
          lemma == other.lemma &&
          pos == other.pos;
    }
    return false;
  }

  @override
  int get hashCode =>
      langCode.hashCode ^
      level.hashCode ^
      prefix.hashCode ^
      suffix.hashCode ^
      count.hashCode ^
      lemma.hashCode ^
      pos.hashCode;
}
