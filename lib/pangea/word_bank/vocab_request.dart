import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';

class VocabRequest {
  String langCode;
  LanguageLevelTypeEnum level;
  String? prefix;
  String? suffix;
  PangeaToken? token;

  int count;

  VocabRequest({
    required this.langCode,
    required this.level,
    this.token,
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
        token =
            json['token'] != null ? PangeaToken.fromJson(json['token']) : null;

  Map<String, dynamic> toJson() => {
        'langCode': langCode,
        'level': level.index,
        'prefix': prefix,
        'suffix': suffix,
        'token': token?.toJson(),
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
          count == other.count;
    }
    return false;
  }

  @override
  int get hashCode =>
      langCode.hashCode ^
      level.hashCode ^
      prefix.hashCode ^
      suffix.hashCode ^
      count.hashCode;
}
