import 'dart:developer';

import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/enum/l2_support_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../utils/error_handler.dart';

class LanguageModel {
  final String langCode;
  final String languageFlag;
  final String displayName;
  final String? languageEmoji;
  final bool l1;
  final L2SupportEnum l2Support;

  LanguageModel({
    required this.langCode,
    required this.languageFlag,
    required this.displayName,
    required this.l1,
    this.l2Support = L2SupportEnum.na,
    this.languageEmoji,
  });

  factory LanguageModel.fromJson(json) {
    final String code = json['language_code'] ??
        codeFromNameOrCode(
          json['language_name'],
          json['language_flag'],
        );

    return LanguageModel(
      langCode: code,
      languageFlag: json['language_flag'] ?? "",
      displayName: _LanguageLocal.getDisplayName(
        code != LanguageKeys.unknownLanguage ? code : json['language_name'],
      ),
      l1: json["l1"] ?? !code.contains("es") && !code.contains("en"),
      languageEmoji: json['language_emoji'],
      l2Support: json['l2_support'] != null
          ? L2SupportEnum.na.fromStorageString(json['l2_support'])
          : L2SupportEnum.na,
    );
  }

  toJson() => {
        'language_code': langCode,
        'language_name': displayName,
        'language_flag': languageFlag,
        'l1': l1,
        'language_emoji': languageEmoji,
        'l2_support': l2Support.storageString,
      };

  bool get l2 => l2Support != L2SupportEnum.na;

  // Discuss with Jordan - adding langCode field to language objects as separate from displayName
  static String codeFromNameOrCode(String codeOrName, [String? url]) {
    if (codeOrName.isEmpty) return LanguageKeys.unknownLanguage;
    if (codeOrName == LanguageKeys.unknownLanguage) return codeOrName;

    if (_LanguageLocal.isoLangs.containsKey(codeOrName)) return codeOrName;

    final String code = _LanguageLocal.langCodeFromName(codeOrName);
    if (code != LanguageKeys.unknownLanguage) return code;

    if (url == null) return LanguageKeys.unknownLanguage;

    final List<String> split = url.split('/');
    return split.last.split('.').first;
  }

  //PTODO - add flag for unknown
  static LanguageModel get unknown => LanguageModel(
        langCode: LanguageKeys.unknownLanguage,
        languageFlag: "",
        displayName: "Unknown",
        l1: false,
      );

  static LanguageModel multiLingual([BuildContext? context]) => LanguageModel(
        displayName: context != null
            ? L10n.of(context).multiLingualSpace
            : "Multilingual Space",
        l1: false,
        langCode: LanguageKeys.multiLanguage,
        languageFlag: 'assets/colors.png',
        languageEmoji: "🌎",
      );

  String? getDisplayName(BuildContext context) {
    switch (langCode) {
      case 'ab':
        return L10n.of(context).abDisplayName;
      case 'aa':
        return L10n.of(context).aaDisplayName;
      case 'af':
        return L10n.of(context).afDisplayName;
      case 'ak':
        return L10n.of(context).akDisplayName;
      case 'sq':
        return L10n.of(context).sqDisplayName;
      case 'am':
        return L10n.of(context).amDisplayName;
      case 'ar':
        return L10n.of(context).arDisplayName;
      case 'an':
        return L10n.of(context).anDisplayName;
      case 'hy':
        return L10n.of(context).hyDisplayName;
      case 'as':
        return L10n.of(context).asDisplayName;
      case 'av':
        return L10n.of(context).avDisplayName;
      case 'ae':
        return L10n.of(context).aeDisplayName;
      case 'ay':
        return L10n.of(context).ayDisplayName;
      case 'az':
        return L10n.of(context).azDisplayName;
      case 'bm':
        return L10n.of(context).bmDisplayName;
      case 'ba':
        return L10n.of(context).baDisplayName;
      case 'eu':
        return L10n.of(context).euDisplayName;
      case 'be':
        return L10n.of(context).beDisplayName;
      case 'bn':
        return L10n.of(context).bnDisplayName;
      case 'bh':
        return L10n.of(context).bhDisplayName;
      case 'bi':
        return L10n.of(context).biDisplayName;
      case 'bs':
        return L10n.of(context).bsDisplayName;
      case 'br':
        return L10n.of(context).brDisplayName;
      case 'bg':
        return L10n.of(context).bgDisplayName;
      case 'my':
        return L10n.of(context).myDisplayName;
      case 'ca':
        return L10n.of(context).caDisplayName;
      case 'ch':
        return L10n.of(context).chDisplayName;
      case 'ce':
        return L10n.of(context).ceDisplayName;
      case 'ny':
        return L10n.of(context).nyDisplayName;
      case 'zh':
        return L10n.of(context).zhDisplayName;
      case 'cv':
        return L10n.of(context).cvDisplayName;
      case 'kw':
        return L10n.of(context).kwDisplayName;
      case 'co':
        return L10n.of(context).coDisplayName;
      case 'cr':
        return L10n.of(context).crDisplayName;
      case 'hr':
        return L10n.of(context).hrDisplayName;
      case 'cs':
        return L10n.of(context).csDisplayName;
      case 'da':
        return L10n.of(context).daDisplayName;
      case 'dv':
        return L10n.of(context).dvDisplayName;
      case 'nl':
        return L10n.of(context).nlDisplayName;
      case 'en':
        return L10n.of(context).enDisplayName;
      case 'eo':
        return L10n.of(context).eoDisplayName;
      case 'et':
        return L10n.of(context).etDisplayName;
      case 'ee':
        return L10n.of(context).eeDisplayName;
      case 'fo':
        return L10n.of(context).foDisplayName;
      case 'fj':
        return L10n.of(context).fjDisplayName;
      case 'fi':
        return L10n.of(context).fiDisplayName;
      case 'fr':
        return L10n.of(context).frDisplayName;
      case 'ff':
        return L10n.of(context).ffDisplayName;
      case 'gl':
        return L10n.of(context).glDisplayName;
      case 'ka':
        return L10n.of(context).kaDisplayName;
      case 'de':
        return L10n.of(context).deDisplayName;
      case 'el':
        return L10n.of(context).elDisplayName;
      case 'gn':
        return L10n.of(context).gnDisplayName;
      case 'gu':
        return L10n.of(context).guDisplayName;
      case 'ht':
        return L10n.of(context).htDisplayName;
      case 'ha':
        return L10n.of(context).haDisplayName;
      case 'he':
        return L10n.of(context).heDisplayName;
      case 'hz':
        return L10n.of(context).hzDisplayName;
      case 'hi':
        return L10n.of(context).hiDisplayName;
      case 'ho':
        return L10n.of(context).hoDisplayName;
      case 'hu':
        return L10n.of(context).huDisplayName;
      case 'ia':
        return L10n.of(context).iaDisplayName;
      case 'id':
        return L10n.of(context).idDisplayName;
      case 'ie':
        return L10n.of(context).ieDisplayName;
      case 'ga':
        return L10n.of(context).gaDisplayName;
      case 'ig':
        return L10n.of(context).igDisplayName;
      case 'ik':
        return L10n.of(context).ikDisplayName;
      case 'io':
        return L10n.of(context).ioDisplayName;
      case 'is':
        return L10n.of(context).isDisplayName;
      case 'it':
        return L10n.of(context).itDisplayName;
      case 'iu':
        return L10n.of(context).iuDisplayName;
      case 'ja':
        return L10n.of(context).jaDisplayName;
      case 'jv':
        return L10n.of(context).jvDisplayName;
      case 'kl':
        return L10n.of(context).klDisplayName;
      case 'kn':
        return L10n.of(context).knDisplayName;
      case 'kr':
        return L10n.of(context).krDisplayName;
      case 'ks':
        return L10n.of(context).ksDisplayName;
      case 'kk':
        return L10n.of(context).kkDisplayName;
      case 'km':
        return L10n.of(context).kmDisplayName;
      case 'ki':
        return L10n.of(context).kiDisplayName;
      case 'rw':
        return L10n.of(context).rwDisplayName;
      case 'ky':
        return L10n.of(context).kyDisplayName;
      case 'kv':
        return L10n.of(context).kvDisplayName;
      case 'kg':
        return L10n.of(context).kgDisplayName;
      case 'ko':
        return L10n.of(context).koDisplayName;
      case 'ku':
        return L10n.of(context).kuDisplayName;
      case 'kj':
        return L10n.of(context).kjDisplayName;
      case 'la':
        return L10n.of(context).laDisplayName;
      case 'lb':
        return L10n.of(context).lbDisplayName;
      case 'lg':
        return L10n.of(context).lgDisplayName;
      case 'li':
        return L10n.of(context).liDisplayName;
      case 'ln':
        return L10n.of(context).lnDisplayName;
      case 'lo':
        return L10n.of(context).loDisplayName;
      case 'lt':
        return L10n.of(context).ltDisplayName;
      case 'lu':
        return L10n.of(context).luDisplayName;
      case 'lv':
        return L10n.of(context).lvDisplayName;
      case 'gv':
        return L10n.of(context).gvDisplayName;
      case 'mk':
        return L10n.of(context).mkDisplayName;
      case 'mg':
        return L10n.of(context).mgDisplayName;
      case 'ms':
        return L10n.of(context).msDisplayName;
      case 'ml':
        return L10n.of(context).mlDisplayName;
      case 'mt':
        return L10n.of(context).mtDisplayName;
      case 'mi':
        return L10n.of(context).miDisplayName;
      case 'mr':
        return L10n.of(context).mrDisplayName;
      case 'mh':
        return L10n.of(context).mhDisplayName;
      case 'mn':
        return L10n.of(context).mnDisplayName;
      case 'na':
        return L10n.of(context).naDisplayName;
      case 'nv':
        return L10n.of(context).nvDisplayName;
      case 'nb':
        return L10n.of(context).nbDisplayName;
      case 'nd':
        return L10n.of(context).ndDisplayName;
      case 'ne':
        return L10n.of(context).neDisplayName;
      case 'ng':
        return L10n.of(context).ngDisplayName;
      case 'nn':
        return L10n.of(context).nnDisplayName;
      case 'no':
        return L10n.of(context).noDisplayName;
      case 'ii':
        return L10n.of(context).iiDisplayName;
      case 'nr':
        return L10n.of(context).nrDisplayName;
      case 'oc':
        return L10n.of(context).ocDisplayName;
      case 'oj':
        return L10n.of(context).ojDisplayName;
      case 'cu':
        return L10n.of(context).cuDisplayName;
      case 'om':
        return L10n.of(context).omDisplayName;
      case 'or':
        return L10n.of(context).orDisplayName;
      case 'os':
        return L10n.of(context).osDisplayName;
      case 'pa':
        return L10n.of(context).paDisplayName;
      case 'pi':
        return L10n.of(context).piDisplayName;
      case 'fa':
        return L10n.of(context).faDisplayName;
      case 'pl':
        return L10n.of(context).plDisplayName;
      case 'ps':
        return L10n.of(context).psDisplayName;
      case 'pt':
        return L10n.of(context).ptDisplayName;
      case 'qu':
        return L10n.of(context).quDisplayName;
      case 'rm':
        return L10n.of(context).rmDisplayName;
      case 'rn':
        return L10n.of(context).rnDisplayName;
      case 'ro':
        return L10n.of(context).roDisplayName;
      case 'ru':
        return L10n.of(context).ruDisplayName;
      case 'sa':
        return L10n.of(context).saDisplayName;
      case 'sc':
        return L10n.of(context).scDisplayName;
      case 'sd':
        return L10n.of(context).sdDisplayName;
      case 'se':
        return L10n.of(context).seDisplayName;
      case 'sm':
        return L10n.of(context).smDisplayName;
      case 'sg':
        return L10n.of(context).sgDisplayName;
      case 'sr':
        return L10n.of(context).srDisplayName;
      case 'gd':
        return L10n.of(context).gdDisplayName;
      case 'sn':
        return L10n.of(context).snDisplayName;
      case 'si':
        return L10n.of(context).siDisplayName;
      case 'sk':
        return L10n.of(context).skDisplayName;
      case 'sl':
        return L10n.of(context).slDisplayName;
      case 'so':
        return L10n.of(context).soDisplayName;
      case 'st':
        return L10n.of(context).stDisplayName;
      case 'es':
        return L10n.of(context).esDisplayName;
      case 'su':
        return L10n.of(context).suDisplayName;
      case 'sw':
        return L10n.of(context).swDisplayName;
      case 'ss':
        return L10n.of(context).ssDisplayName;
      case 'sv':
        return L10n.of(context).svDisplayName;
      case 'ta':
        return L10n.of(context).taDisplayName;
      case 'te':
        return L10n.of(context).teDisplayName;
      case 'tg':
        return L10n.of(context).tgDisplayName;
      case 'th':
        return L10n.of(context).thDisplayName;
      case 'ti':
        return L10n.of(context).tiDisplayName;
      case 'bo':
        return L10n.of(context).boDisplayName;
      case 'tk':
        return L10n.of(context).tkDisplayName;
      case 'tl':
        return L10n.of(context).tlDisplayName;
      case 'tn':
        return L10n.of(context).tnDisplayName;
      case 'to':
        return L10n.of(context).toDisplayName;
      case 'tr':
        return L10n.of(context).trDisplayName;
      case 'ts':
        return L10n.of(context).tsDisplayName;
      case 'tt':
        return L10n.of(context).ttDisplayName;
      case 'tw':
        return L10n.of(context).twDisplayName;
      case 'ty':
        return L10n.of(context).tyDisplayName;
      case 'ug':
        return L10n.of(context).ugDisplayName;
      case 'uk':
        return L10n.of(context).ukDisplayName;
      case 'ur':
        return L10n.of(context).urDisplayName;
      case 'uz':
        return L10n.of(context).uzDisplayName;
      case 've':
        return L10n.of(context).veDisplayName;
      case 'vi':
        return L10n.of(context).viDisplayName;
      case 'vo':
        return L10n.of(context).voDisplayName;
      case 'wa':
        return L10n.of(context).waDisplayName;
      case 'cy':
        return L10n.of(context).cyDisplayName;
      case 'wo':
        return L10n.of(context).woDisplayName;
      case 'fy':
        return L10n.of(context).fyDisplayName;
      case 'xh':
        return L10n.of(context).xhDisplayName;
      case 'yi':
        return L10n.of(context).yiDisplayName;
      case 'yo':
        return L10n.of(context).yoDisplayName;
      case 'za':
        return L10n.of(context).zaDisplayName;
      case 'unk':
        return L10n.of(context).unkDisplayName;
      case 'zu':
        return L10n.of(context).zuDisplayName;
      case 'haw':
        return L10n.of(context).hawDisplayName;
      case 'hmn':
        return L10n.of(context).hmnDisplayName;
      case 'multi':
        return L10n.of(context).multiDisplayName;
      case 'ceb':
        return L10n.of(context).cebDisplayName;
      case 'dz':
        return L10n.of(context).dzDisplayName;
      case 'iw':
        return L10n.of(context).iwDisplayName;
      case 'jw':
        return L10n.of(context).jwDisplayName;
      case 'mo':
        return L10n.of(context).moDisplayName;
      case 'sh':
        return L10n.of(context).shDisplayName;
    }
    debugger(when: kDebugMode);
    ErrorHandler.logError(m: "No Display name found", s: StackTrace.current);
    return null;
  }
}

class _LanguageLocal {
  static const isoLangs = {
    "ab": {"name": "Abkhaz", "nativeName": "аҧсуа"},
    "aa": {"name": "Afar", "nativeName": "Afaraf"},
    "af": {"name": "Afrikaans", "nativeName": "Afrikaans"},
    "ak": {"name": "Akan", "nativeName": "Akan"},
    "sq": {"name": "Albanian", "nativeName": "Shqip"},
    "am": {"name": "Amharic", "nativeName": "አማርኛ"},
    "ar": {"name": "Arabic", "nativeName": "العربية"},
    "an": {"name": "Aragonese", "nativeName": "Aragonés"},
    "hy": {"name": "Armenian", "nativeName": "Հայերեն"},
    "as": {"name": "Assamese", "nativeName": "অসমীয়া"},
    "av": {"name": "Avaric", "nativeName": "авар мацӀ, магӀарул мацӀ"},
    "ae": {"name": "Avestan", "nativeName": "avesta"},
    "ay": {"name": "Aymara", "nativeName": "aymar aru"},
    "az": {"name": "Azerbaijani", "nativeName": "azərbaycan dili"},
    "bm": {"name": "Bambara", "nativeName": "bamanankan"},
    "ba": {"name": "Bashkir", "nativeName": "башҡорт теле"},
    "eu": {"name": "Basque", "nativeName": "euskara, euskera"},
    "be": {"name": "Belarusian", "nativeName": "Беларуская"},
    "bn": {"name": "Bengali", "nativeName": "বাংলা"},
    "bh": {"name": "Bihari", "nativeName": "भोजपुरी"},
    "bi": {"name": "Bislama", "nativeName": "Bislama"},
    "bs": {"name": "Bosnian", "nativeName": "bosanski jezik"},
    "br": {"name": "Breton", "nativeName": "brezhoneg"},
    "bg": {"name": "Bulgarian", "nativeName": "български език"},
    "my": {"name": "Burmese", "nativeName": "ဗမာစာ"},
    "ca": {"name": "Catalan, Valencian", "nativeName": "Català"},
    "ch": {"name": "Chamorro", "nativeName": "Chamoru"},
    "ce": {"name": "Chechen", "nativeName": "нохчийн мотт"},
    "ny": {
      "name": "Chichewa, Chewa, Nyanja",
      "nativeName": "chiCheŵa, chinyanja",
    },
    "zh": {"name": "Chinese", "nativeName": "中文 (Zhōngwén), 汉语, 漢語"},
    "cv": {"name": "Chuvash", "nativeName": "чӑваш чӗлхи"},
    "kw": {"name": "Cornish", "nativeName": "Kernewek"},
    "co": {"name": "Corsican", "nativeName": "corsu, lingua corsa"},
    "cr": {"name": "Cree", "nativeName": "ᓀᐦᐃᔭᐍᐏᐣ"},
    "hr": {"name": "Croatian", "nativeName": "hrvatski"},
    "cs": {"name": "Czech", "nativeName": "česky, čeština"},
    "da": {"name": "Danish", "nativeName": "dansk"},
    "dv": {"name": "Divehi; Dhivehi; Maldivian;", "nativeName": "ދިވެހި"},
    "nl": {"name": "Dutch", "nativeName": "Nederlands, Vlaams"},
    "en": {"name": "English", "nativeName": "English"},
    "eo": {"name": "Esperanto", "nativeName": "Esperanto"},
    "et": {"name": "Estonian", "nativeName": "eesti, eesti keel"},
    "ee": {"name": "Ewe", "nativeName": "Evegbe"},
    "fo": {"name": "Faroese", "nativeName": "føroyskt"},
    "fj": {"name": "Fijian", "nativeName": "vosa Vakaviti"},
    "fi": {"name": "Finnish", "nativeName": "suomi, suomen kieli"},
    "fr": {"name": "French", "nativeName": "français, langue française"},
    "ff": {
      "name": "Fula; Fulah; Pulaar; Pular",
      "nativeName": "Fulfulde, Pulaar, Pular",
    },
    "gl": {"name": "Galician", "nativeName": "Galego"},
    "ka": {"name": "Georgian", "nativeName": "ქართული"},
    "de": {"name": "German", "nativeName": "Deutsch"},
    "el": {"name": "Greek, Modern", "nativeName": "Ελληνικά"},
    "gn": {"name": "Guaraní", "nativeName": "Avañeẽ"},
    "gu": {"name": "Gujarati", "nativeName": "ગુજરાતી"},
    "ht": {"name": "Haitian, Haitian Creole", "nativeName": "Kreyòl ayisyen"},
    "ha": {"name": "Hausa", "nativeName": "Hausa, هَوُسَ"},
    "he": {"name": "Hebrew (modern)", "nativeName": "עברית"},
    "hz": {"name": "Herero", "nativeName": "Otjiherero"},
    "hi": {"name": "Hindi", "nativeName": "हिन्दी, हिंदी"},
    "ho": {"name": "Hiri Motu", "nativeName": "Hiri Motu"},
    "hu": {"name": "Hungarian", "nativeName": "Magyar"},
    "ia": {"name": "Interlingua", "nativeName": "Interlingua"},
    "id": {"name": "Indonesian", "nativeName": "Bahasa Indonesia"},
    "ie": {
      "name": "Interlingue",
      "nativeName": "Originally called Occidental; then Interlingue after WWII",
    },
    "ga": {"name": "Irish", "nativeName": "Gaeilge"},
    "ig": {"name": "Igbo", "nativeName": "Asụsụ Igbo"},
    "ik": {"name": "Inupiaq", "nativeName": "Iñupiaq, Iñupiatun"},
    "io": {"name": "Ido", "nativeName": "Ido"},
    "is": {"name": "Icelandic", "nativeName": "Íslenska"},
    "it": {"name": "Italian", "nativeName": "Italiano"},
    "iu": {"name": "Inuktitut", "nativeName": "ᐃᓄᒃᑎᑐᑦ"},
    "ja": {"name": "Japanese", "nativeName": "日本語 (にほんご／にっぽんご)"},
    "jv": {"name": "Javanese", "nativeName": "basa Jawa"},
    "kl": {
      "name": "Kalaallisut, Greenlandic",
      "nativeName": "kalaallisut, kalaallit oqaasii",
    },
    "kn": {"name": "Kannada", "nativeName": "ಕನ್ನಡ"},
    "kr": {"name": "Kanuri", "nativeName": "Kanuri"},
    "ks": {"name": "Kashmiri", "nativeName": "कश्मीरी, كشميري"},
    "kk": {"name": "Kazakh", "nativeName": "Қазақ тілі"},
    "km": {"name": "Khmer", "nativeName": "ភាសាខ្មែរ"},
    "ki": {"name": "Kikuyu, Gikuyu", "nativeName": "Gĩkũyũ"},
    "rw": {"name": "Kinyarwanda", "nativeName": "Ikinyarwanda"},
    "ky": {"name": "Kirghiz, Kyrgyz", "nativeName": "кыргыз тили"},
    "kv": {"name": "Komi", "nativeName": "коми кыв"},
    "kg": {"name": "Kongo", "nativeName": "KiKongo"},
    "ko": {"name": "Korean", "nativeName": "한국어 (韓國語), 조선말 (朝鮮語)"},
    "ku": {"name": "Kurdish", "nativeName": "Kurdî, كوردی"},
    "kj": {"name": "Kwanyama, Kuanyama", "nativeName": "Kuanyama"},
    "la": {"name": "Latin", "nativeName": "latine, lingua latina"},
    "lb": {
      "name": "Luxembourgish, Letzeburgesch",
      "nativeName": "Lëtzebuergesch",
    },
    "lg": {"name": "Luganda", "nativeName": "Luganda"},
    "li": {
      "name": "Limburgish, Limburgan, Limburger",
      "nativeName": "Limburgs",
    },
    "ln": {"name": "Lingala", "nativeName": "Lingála"},
    "lo": {"name": "Lao", "nativeName": "ພາສາລາວ"},
    "lt": {"name": "Lithuanian", "nativeName": "lietuvių kalba"},
    "lu": {"name": "Luba-Katanga", "nativeName": ""},
    "lv": {"name": "Latvian", "nativeName": "latviešu valoda"},
    "gv": {"name": "Manx", "nativeName": "Gaelg, Gailck"},
    "mk": {"name": "Macedonian", "nativeName": "македонски јазик"},
    "mg": {"name": "Malagasy", "nativeName": "Malagasy fiteny"},
    "ms": {"name": "Malay", "nativeName": "bahasa Melayu, بهاس ملايو"},
    "ml": {"name": "Malayalam", "nativeName": "മലയാളം"},
    "mt": {"name": "Maltese", "nativeName": "Malti"},
    "mi": {"name": "Māori", "nativeName": "te reo Māori"},
    "mr": {"name": "Marathi (Marāṭhī)", "nativeName": "मराठी"},
    "mh": {"name": "Marshallese", "nativeName": "Kajin M̧ajeļ"},
    "mn": {"name": "Mongolian", "nativeName": "монгол"},
    "na": {"name": "Nauru", "nativeName": "Ekakairũ Naoero"},
    "nv": {"name": "Navajo, Navaho", "nativeName": "Diné bizaad, Dinék'ehǰí"},
    "nb": {"name": "Norwegian Bokmål", "nativeName": "Norsk bokmål"},
    "nd": {"name": "North Ndebele", "nativeName": "isiNdebele"},
    "ne": {"name": "Nepali", "nativeName": "नेपाली"},
    "ng": {"name": "Ndonga", "nativeName": "Owambo"},
    "nn": {"name": "Norwegian Nynorsk", "nativeName": "Norsk nynorsk"},
    "no": {"name": "Norwegian", "nativeName": "Norsk"},
    "ii": {"name": "Nuosu", "nativeName": "ꆈꌠ꒿ Nuosuhxop"},
    "nr": {"name": "South Ndebele", "nativeName": "isiNdebele"},
    "oc": {"name": "Occitan", "nativeName": "Occitan"},
    "oj": {"name": "Ojibwe, Ojibwa", "nativeName": "ᐊᓂᔑᓈᐯᒧᐎᓐ"},
    "cu": {
      "name":
          "Old Church Slavonic, Church Slavic, Church Slavonic, Old Bulgarian, Old Slavonic",
      "nativeName": "ѩзыкъ словѣньскъ",
    },
    "om": {"name": "Oromo", "nativeName": "Afaan Oromoo"},
    "or": {"name": "Oriya", "nativeName": "ଓଡ଼ିଆ"},
    "os": {"name": "Ossetian, Ossetic", "nativeName": "ирон æвзаг"},
    "pa": {"name": "Panjabi, Punjabi", "nativeName": "ਪੰਜਾਬੀ, پنجابی"},
    "pi": {"name": "Pāli", "nativeName": "पाऴि"},
    "fa": {"name": "Persian", "nativeName": "فارسی"},
    "pl": {"name": "Polish", "nativeName": "polski"},
    "ps": {"name": "Pashto, Pushto", "nativeName": "پښتو"},
    "pt": {"name": "Portuguese", "nativeName": "Português"},
    "qu": {"name": "Quechua", "nativeName": "Runa Simi, Kichwa"},
    "rm": {"name": "Romansh", "nativeName": "rumantsch grischun"},
    "rn": {"name": "Kirundi", "nativeName": "kiRundi"},
    "ro": {"name": "Romanian, Moldavian, Moldovan", "nativeName": "română"},
    "ru": {"name": "Russian", "nativeName": "русский язык"},
    "sa": {"name": "Sanskrit (Saṁskṛta)", "nativeName": "संस्कृतम्"},
    "sc": {"name": "Sardinian", "nativeName": "sardu"},
    "sd": {"name": "Sindhi", "nativeName": "सिन्धी, سنڌي، سندھی"},
    "se": {"name": "Northern Sami", "nativeName": "Davvisámegiella"},
    "sm": {"name": "Samoan", "nativeName": "gagana faa Samoa"},
    "sg": {"name": "Sango", "nativeName": "yângâ tî sängö"},
    "sr": {"name": "Serbian", "nativeName": "српски језик"},
    "gd": {"name": "Scottish Gaelic, Gaelic", "nativeName": "Gàidhlig"},
    "sn": {"name": "Shona", "nativeName": "chiShona"},
    "si": {"name": "Sinhala, Sinhalese", "nativeName": "සිංහල"},
    "sk": {"name": "Slovak", "nativeName": "Slovenčina"},
    "sl": {"name": "Slovene", "nativeName": "Slovenščina"},
    "so": {"name": "Somali", "nativeName": "Soomaaliga, af Soomaali"},
    "st": {"name": "Southern Sotho", "nativeName": "Sesotho"},
    "es": {"name": "Spanish, Castilian", "nativeName": "Español, Castellano"},
    "su": {"name": "Sundanese", "nativeName": "Basa Sunda"},
    "sw": {"name": "Swahili", "nativeName": "Kiswahili"},
    "ss": {"name": "Swati", "nativeName": "SiSwati"},
    "sv": {"name": "Swedish", "nativeName": "svenska"},
    "ta": {"name": "Tamil", "nativeName": "தமிழ்"},
    "te": {"name": "Telugu", "nativeName": "తెలుగు"},
    "tg": {"name": "Tajik", "nativeName": "тоҷикӣ, toğikī, تاجیکی"},
    "th": {"name": "Thai", "nativeName": "ไทย"},
    "ti": {"name": "Tigrinya", "nativeName": "ትግርኛ"},
    "bo": {
      "name": "Tibetan Standard, Tibetan, Central",
      "nativeName": "བོད་ཡིག",
    },
    "tk": {"name": "Turkmen", "nativeName": "Türkmen, Түркмен"},
    "tl": {"name": "Tagalog", "nativeName": "Wikang Tagalog, ᜏᜒᜃᜅ᜔ ᜆᜄᜎᜓᜄ᜔"},
    "tn": {"name": "Tswana", "nativeName": "Setswana"},
    "to": {"name": "Tonga (Tonga Islands)", "nativeName": "faka Tonga"},
    "tr": {"name": "Turkish", "nativeName": "Türkçe"},
    "ts": {"name": "Tsonga", "nativeName": "Xitsonga"},
    "tt": {"name": "Tatar", "nativeName": "татарча, tatarça, تاتارچا"},
    "tw": {"name": "Twi", "nativeName": "Twi"},
    "ty": {"name": "Tahitian", "nativeName": "Reo Tahiti"},
    "ug": {"name": "Uighur, Uyghur", "nativeName": "Uyƣurqə, ئۇيغۇرچە"},
    "uk": {"name": "Ukrainian", "nativeName": "українська"},
    "ur": {"name": "Urdu", "nativeName": "اردو"},
    "uz": {"name": "Uzbek", "nativeName": "zbek, Ўзбек, أۇزبېك"},
    "ve": {"name": "Venda", "nativeName": "Tshivenḓa"},
    "vi": {"name": "Vietnamese", "nativeName": "Tiếng Việt"},
    "vo": {"name": "Volapük", "nativeName": "Volapük"},
    "wa": {"name": "Walloon", "nativeName": "Walon"},
    "cy": {"name": "Welsh", "nativeName": "Cymraeg"},
    "wo": {"name": "Wolof", "nativeName": "Wollof"},
    "fy": {"name": "Western Frisian", "nativeName": "Frysk"},
    "xh": {"name": "Xhosa", "nativeName": "isiXhosa"},
    "yi": {"name": "Yiddish", "nativeName": "ייִדיש"},
    "yo": {"name": "Yoruba", "nativeName": "Yorùbá"},
    "za": {"name": "Zhuang, Chuang", "nativeName": "Saw cueŋƅ, Saw cuengh"},
    "unk": {"name": "Unknown", "nativeName": "Saw cueŋƅ, Saw cuengh"},
    "zu": {"name": "Zulu", "nativeName": "Zulu"},
    "haw": {"name": "Hawaiian", "nativeName": "Hawaiian"},
    "hmn": {"name": "Hmong", "nativeName": "Hmong"},
    'multi': {"name": "Multi", "nativeName": "Multi"},
    "ceb": {"name": "Cebuano", "nativeName": "Cebuano"},
    "dz": {"name": "Dzongkha", "nativeName": "Dzongkha"},
    "iw": {"name": "Hebrew", "nativeName": "Hebrew"},
    "jw": {"name": "Javanese", "nativeName": "Javanese"},
    "mo": {"name": "Moldavian", "nativeName": "Moldavian"},
    "sh": {"name": "Serbo-Croatian", "nativeName": "Serbo-Croatian"},
  };

  static String getDisplayName(String key, [native = false]) {
    final Map<String, String>? item = isoLangs[key];
    if (item == null) {
      // debugger(when: kDebugMode);
      // ErrorHandler.logError(m: "Bad language key $key", s: StackTrace.current);
    }
    if (item == null ||
        (native && !item.containsKey("nativeName") ||
            (!native && !item.containsKey("name")))) {
      return key;
    }

    return (native ? item["nativeName"]! : item["name"]!).split(",")[0];
  }

  static String langCodeFromName(String? name) {
    if (name == null) return LanguageKeys.unknownLanguage;
    if (isoLangs.containsKey(name)) return name;

    final String searchName = name.toLowerCase().split(" ")[0];
    for (final entry in isoLangs.entries) {
      if (entry.value.containsKey("name") &&
          entry.value["name"]!.toLowerCase().contains(searchName)) {
        return entry.key;
      }
    }
    // debugger(when: kDebugMode);
    // ErrorHandler.logError(m: "Bad language name $name", s: StackTrace.current);
    return LanguageKeys.unknownLanguage;
  }
}
