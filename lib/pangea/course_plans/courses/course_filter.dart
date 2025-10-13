import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';

class CourseFilter {
  final LanguageModel? targetLanguage;
  final LanguageModel? languageOfInstructions;
  final LanguageLevelTypeEnum? cefrLevel;

  CourseFilter({
    this.targetLanguage,
    this.languageOfInstructions,
    this.cefrLevel,
  });

  Map<String, dynamic> get whereFilter {
    final Map<String, dynamic> where = {};
    int numberOfFilter = 0;
    if (cefrLevel != null) {
      numberOfFilter += 1;
    }
    if (languageOfInstructions != null) {
      numberOfFilter += 1;
    }
    if (targetLanguage != null) {
      numberOfFilter += 1;
    }
    if (numberOfFilter > 1) {
      where["and"] = [];
      if (cefrLevel != null) {
        where["and"].add({
          "cefrLevel": {"equals": cefrLevel!.string},
        });
      }
      if (languageOfInstructions != null) {
        where["and"].add({
          "l1": {
            "equals": languageOfInstructions!.langCodeShort,
          },
        });
      }
      if (targetLanguage != null) {
        where["and"].add({
          "l2": {"equals": targetLanguage!.langCodeShort},
        });
      }
    } else if (numberOfFilter == 1) {
      if (cefrLevel != null) {
        where["cefrLevel"] = {"equals": cefrLevel!.string};
      }
      if (languageOfInstructions != null) {
        where["l1"] = {
          "equals": languageOfInstructions!.langCode,
        };
      }
      if (targetLanguage != null) {
        where["l2"] = {"equals": targetLanguage!.langCode};
      }
    }

    return where;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseFilter &&
        other.targetLanguage == targetLanguage &&
        other.languageOfInstructions == languageOfInstructions &&
        other.cefrLevel == cefrLevel;
  }

  @override
  int get hashCode =>
      targetLanguage.hashCode ^
      languageOfInstructions.hashCode ^
      cefrLevel.hashCode;
}
