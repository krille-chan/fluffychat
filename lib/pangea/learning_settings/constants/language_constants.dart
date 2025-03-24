import 'package:fluffychat/pangea/choreographer/models/language_detection_model.dart';

class LanguageKeys {
  static const unknownLanguage = "unk";
  static const mixedLanguage = "mixed";
  static const defaultLanguage = "en";
  static const multiLanguage = "multi";
}

class PrefKey {
  static const lastFetched = 'p_lang_lastfetched';
  static const languagesKey = 'p_lang_flag';
}

final LanguageDetection unknownLanguageDetection = LanguageDetection(
  langCode: LanguageKeys.unknownLanguage,
  confidence: 0.5,
);

class FallbackLanguage {
  static List<Map<String, dynamic>> get languageList => [
        {
          "language_code": "ab",
          "language_name": "Abkhazian",
          "l2_support": "na",
        },
        {
          "language_code": "ace",
          "language_name": "Achinese",
          "l2_support": "na",
        },
        {
          "language_code": "ach",
          "language_name": "Acoli",
          "l2_support": "na",
        },
        {
          "language_code": "af",
          "language_name": "Afrikaans",
          "l2_support": "na",
        },
        {
          "language_code": "ak",
          "language_name": "Akan",
          "l2_support": "na",
        },
        {
          "language_code": "alz",
          "language_name": "Alur",
          "l2_support": "na",
        },
        {
          "language_code": "am",
          "language_name": "Amharic",
          "l2_support": "beta",
        },
        {
          "language_code": "ar",
          "language_name": "Arabic",
          "l2_support": "beta",
        },
        {
          "language_code": "as",
          "language_name": "Assamese",
          "l2_support": "na",
        },
        {
          "language_code": "awa",
          "language_name": "Awadhi",
          "l2_support": "na",
        },
        {
          "language_code": "ay",
          "language_name": "Aymara",
          "l2_support": "na",
        },
        {
          "language_code": "az",
          "language_name": "Azerbaijani",
          "l2_support": "na",
        },
        {
          "language_code": "ba",
          "language_name": "Bashkir",
          "l2_support": "na",
        },
        {
          "language_code": "ban",
          "language_name": "Balinese",
          "l2_support": "na",
        },
        {
          "language_code": "bbc",
          "language_name": "Batak Toba",
          "l2_support": "na",
        },
        {
          "language_code": "be",
          "language_name": "Belarusian",
          "l2_support": "na",
        },
        {
          "language_code": "bem",
          "language_name": "Bemba",
          "l2_support": "na",
        },
        {
          "language_code": "bew",
          "language_name": "Betawi",
          "l2_support": "na",
        },
        {
          "language_code": "bg",
          "language_name": "Bulgarian",
          "l2_support": "beta",
        },
        {
          "language_code": "bho",
          "language_name": "Bhojpuri",
          "l2_support": "na",
        },
        {
          "language_code": "bik",
          "language_name": "Bikol",
          "l2_support": "na",
        },
        {
          "language_code": "bm",
          "language_name": "Bambara",
          "l2_support": "na",
        },
        {
          "language_code": "bn",
          "language_name": "Bangla",
          "l2_support": "beta",
        },
        {
          "language_code": "bn-BD",
          "language_name": "Bengali (Bangladesh)",
          "l2_support": "beta",
        },
        {
          "language_code": "bn-IN",
          "language_name": "Bengali (India)",
          "l2_support": "beta",
        },
        {
          "language_code": "br",
          "language_name": "Breton",
          "l2_support": "na",
        },
        {
          "language_code": "bs",
          "language_name": "Bosnian",
          "l2_support": "na",
        },
        {
          "language_code": "bts",
          "language_name": "Batak Simalungun",
          "l2_support": "na",
        },
        {
          "language_code": "btx",
          "language_name": "Batak Karo",
          "l2_support": "na",
        },
        {
          "language_code": "bua",
          "language_name": "Buriat",
          "l2_support": "na",
        },
        {
          "language_code": "ca",
          "language_name": "Catalan",
          "l2_support": "full",
        },
        {
          "language_code": "ceb",
          "language_name": "Cebuano",
          "l2_support": "na",
        },
        {
          "language_code": "cgg",
          "language_name": "Chiga",
          "l2_support": "na",
        },
        {
          "language_code": "chm",
          "language_name": "Mari",
          "l2_support": "na",
        },
        {
          "language_code": "ckb",
          "language_name": "Central Kurdish",
          "l2_support": "na",
        },
        {
          "language_code": "cnh",
          "language_name": "Hakha Chin",
          "l2_support": "na",
        },
        {
          "language_code": "co",
          "language_name": "Corsican",
          "l2_support": "na",
        },
        {
          "language_code": "crh",
          "language_name": "Crimean Turkish",
          "l2_support": "na",
        },
        {
          "language_code": "crs",
          "language_name": "Seselwa Creole French",
          "l2_support": "na",
        },
        {
          "language_code": "cs",
          "language_name": "Czech",
          "l2_support": "beta",
        },
        {
          "language_code": "cv",
          "language_name": "Chuvash",
          "l2_support": "na",
        },
        {
          "language_code": "cy",
          "language_name": "Welsh",
          "l2_support": "na",
        },
        {
          "language_code": "da",
          "language_name": "Danish",
          "l2_support": "beta",
        },
        {
          "language_code": "de",
          "language_name": "German",
          "l2_support": "full",
        },
        {
          "language_code": "din",
          "language_name": "Dinka",
          "l2_support": "na",
        },
        {
          "language_code": "doi",
          "language_name": "Dogri",
          "l2_support": "na",
        },
        {
          "language_code": "dov",
          "language_name": "Dombe",
          "l2_support": "na",
        },
        {
          "language_code": "dv",
          "language_name": "Divehi",
          "l2_support": "na",
        },
        {
          "language_code": "dz",
          "language_name": "Dzongkha",
          "l2_support": "na",
        },
        {
          "language_code": "ee",
          "language_name": "Ewe",
          "l2_support": "na",
        },
        {
          "language_code": "el",
          "language_name": "Greek",
          "l2_support": "beta",
        },
        {
          "language_code": "en",
          "language_name": "English",
          "l2_support": "full",
        },
        {
          "language_code": "en-AU",
          "language_name": "English (Australia)",
          "l2_support": "full",
        },
        {
          "language_code": "en-GB",
          "language_name": "English (UK)",
          "l2_support": "full",
        },
        {
          "language_code": "en-IN",
          "language_name": "English (India)",
          "l2_support": "full",
        },
        {
          "language_code": "en-US",
          "language_name": "English (US)",
          "l2_support": "full",
        },
        {
          "language_code": "eo",
          "language_name": "Esperanto",
          "l2_support": "na",
        },
        {
          "language_code": "es",
          "language_name": "Spanish",
          "l2_support": "full",
        },
        {
          "language_code": "es-ES",
          "language_name": "Spanish (Spain)",
          "l2_support": "full",
        },
        {
          "language_code": "es-MX",
          "language_name": "Spanish (Mexico)",
          "l2_support": "full",
        },
        {
          "language_code": "et",
          "language_name": "Estonian",
          "l2_support": "beta",
        },
        {
          "language_code": "eu",
          "language_name": "Basque",
          "l2_support": "beta",
        },
        {
          "language_code": "fa",
          "language_name": "Persian",
          "l2_support": "na",
        },
        {
          "language_code": "ff",
          "language_name": "Fulah",
          "l2_support": "na",
        },
        {
          "language_code": "fi",
          "language_name": "Finnish",
          "l2_support": "beta",
        },
        {
          "language_code": "fil",
          "language_name": "Filipino",
          "l2_support": "na",
        },
        {
          "language_code": "fj",
          "language_name": "Fijian",
          "l2_support": "na",
        },
        {
          "language_code": "fo",
          "language_name": "Faroese",
          "l2_support": "na",
        },
        {
          "language_code": "fr",
          "language_name": "French",
          "l2_support": "full",
        },
        {
          "language_code": "fr-CA",
          "language_name": "French (Canada)",
          "l2_support": "full",
        },
        {
          "language_code": "fr-FR",
          "language_name": "French (France)",
          "l2_support": "full",
        },
        {
          "language_code": "fy",
          "language_name": "Western Frisian",
          "l2_support": "na",
        },
        {
          "language_code": "ga",
          "language_name": "Irish",
          "l2_support": "na",
        },
        {
          "language_code": "gaa",
          "language_name": "Ga",
          "l2_support": "na",
        },
        {
          "language_code": "gd",
          "language_name": "Scottish Gaelic",
          "l2_support": "na",
        },
        {
          "language_code": "gl",
          "language_name": "Galician",
          "l2_support": "beta",
        },
        {
          "language_code": "gn",
          "language_name": "Guarani",
          "l2_support": "na",
        },
        {
          "language_code": "gom",
          "language_name": "Goan Konkani",
          "l2_support": "na",
        },
        {
          "language_code": "gu",
          "language_name": "Gujarati",
          "l2_support": "beta",
        },
        {
          "language_code": "ha",
          "language_name": "Hausa",
          "l2_support": "na",
        },
        {
          "language_code": "haw",
          "language_name": "Hawaiian",
          "l2_support": "na",
        },
        {
          "language_code": "he",
          "language_name": "Hebrew",
          "l2_support": "na",
        },
        {
          "language_code": "hi",
          "language_name": "Hindi",
          "l2_support": "beta",
        },
        {
          "language_code": "hil",
          "language_name": "Hiligaynon",
          "l2_support": "na",
        },
        {
          "language_code": "hmn",
          "language_name": "Hmong",
          "l2_support": "na",
        },
        {
          "language_code": "hne",
          "language_name": "Chhattisgarhi",
          "l2_support": "na",
        },
        {
          "language_code": "hr",
          "language_name": "Croatian",
          "l2_support": "na",
        },
        {
          "language_code": "hrx",
          "language_name": "Hunsrik",
          "l2_support": "na",
        },
        {
          "language_code": "ht",
          "language_name": "Haitian Creole",
          "l2_support": "na",
        },
        {
          "language_code": "hu",
          "language_name": "Hungarian",
          "l2_support": "beta",
        },
        {
          "language_code": "hy",
          "language_name": "Armenian",
          "l2_support": "na",
        },
        {
          "language_code": "id",
          "language_name": "Indonesian",
          "l2_support": "beta",
        },
        {
          "language_code": "ig",
          "language_name": "Igbo",
          "l2_support": "na",
        },
        {
          "language_code": "ilo",
          "language_name": "Iloko",
          "l2_support": "na",
        },
        {
          "language_code": "is",
          "language_name": "Icelandic",
          "l2_support": "na",
        },
        {
          "language_code": "it",
          "language_name": "Italian",
          "l2_support": "full",
        },
        {
          "language_code": "iw",
          "language_name": "Hebrew",
          "l2_support": "na",
        },
        {
          "language_code": "ja",
          "language_name": "Japanese",
          "l2_support": "full",
        },
        {
          "language_code": "jv",
          "language_name": "Javanese",
          "l2_support": "na",
        },
        {
          "language_code": "ka",
          "language_name": "Georgian",
          "l2_support": "na",
        },
        {
          "language_code": "kk",
          "language_name": "Kazakh",
          "l2_support": "na",
        },
        {
          "language_code": "km",
          "language_name": "Khmer",
          "l2_support": "na",
        },
        {
          "language_code": "kn",
          "language_name": "Kannada",
          "l2_support": "beta",
        },
        {
          "language_code": "ko",
          "language_name": "Korean",
          "l2_support": "full",
        },
        {
          "language_code": "kok",
          "language_name": "Konkani",
          "l2_support": "na",
        },
        {
          "language_code": "kri",
          "language_name": "Krio",
          "l2_support": "na",
        },
        {
          "language_code": "ks",
          "language_name": "Kashmiri",
          "l2_support": "na",
        },
        {
          "language_code": "ktu",
          "language_name": "Kituba (Democratic Republic of Congo)",
          "l2_support": "na",
        },
        {
          "language_code": "ku",
          "language_name": "Kurdish",
          "l2_support": "na",
        },
        {
          "language_code": "ky",
          "language_name": "Kyrgyz",
          "l2_support": "na",
        },
        {
          "language_code": "la",
          "language_name": "Latin",
          "l2_support": "na",
        },
        {
          "language_code": "lb",
          "language_name": "Luxembourgish",
          "l2_support": "na",
        },
        {
          "language_code": "lg",
          "language_name": "Ganda",
          "l2_support": "na",
        },
        {
          "language_code": "li",
          "language_name": "Limburgish",
          "l2_support": "na",
        },
        {
          "language_code": "lij",
          "language_name": "Ligurian",
          "l2_support": "na",
        },
        {
          "language_code": "lmo",
          "language_name": "Lombard",
          "l2_support": "na",
        },
        {
          "language_code": "ln",
          "language_name": "Lingala",
          "l2_support": "na",
        },
        {
          "language_code": "lo",
          "language_name": "Lao",
          "l2_support": "na",
        },
        {
          "language_code": "lt",
          "language_name": "Lithuanian",
          "l2_support": "beta",
        },
        {
          "language_code": "ltg",
          "language_name": "Latgalian",
          "l2_support": "na",
        },
        {
          "language_code": "luo",
          "language_name": "Luo (Kenya and Tanzania)",
          "l2_support": "na",
        },
        {
          "language_code": "lus",
          "language_name": "Mizo",
          "l2_support": "na",
        },
        {
          "language_code": "lv",
          "language_name": "Latvian",
          "l2_support": "beta",
        },
        {
          "language_code": "mai",
          "language_name": "Maithili",
          "l2_support": "na",
        },
        {
          "language_code": "mak",
          "language_name": "Makasar",
          "l2_support": "na",
        },
        {
          "language_code": "mg",
          "language_name": "Malagasy",
          "l2_support": "na",
        },
        {
          "language_code": "mi",
          "language_name": "Māori",
          "l2_support": "na",
        },
        {
          "language_code": "min",
          "language_name": "Minangkabau",
          "l2_support": "na",
        },
        {
          "language_code": "mk",
          "language_name": "Macedonian",
          "l2_support": "na",
        },
        {
          "language_code": "ml",
          "language_name": "Malayalam",
          "l2_support": "na",
        },
        {
          "language_code": "mn",
          "language_name": "Mongolian",
          "l2_support": "beta",
        },
        {
          "language_code": "mni",
          "language_name": "Manipuri",
          "l2_support": "na",
        },
        {
          "language_code": "mr",
          "language_name": "Marathi",
          "l2_support": "beta",
        },
        {
          "language_code": "ms",
          "language_name": "Malay",
          "l2_support": "beta",
        },
        {
          "language_code": "ms-Arab",
          "language_name": "Malay (Arabic)",
          "l2_support": "beta",
        },
        {
          "language_code": "ms-MY",
          "language_name": "Malay (Malaysia)",
          "l2_support": "beta",
        },
        {
          "language_code": "mt",
          "language_name": "Maltese",
          "l2_support": "na",
        },
        {
          "language_code": "mwr",
          "language_name": "Marwari",
          "l2_support": "na",
        },
        {
          "language_code": "my",
          "language_name": "Burmese",
          "l2_support": "na",
        },
        {
          "language_code": "nan",
          "language_name": "Min Nan",
          "l2_support": "na",
        },
        {
          "language_code": "nb",
          "language_name": "Norwegian (Bokmål)",
          "l2_support": "na",
        },
        {
          "language_code": "ne",
          "language_name": "Nepali",
          "l2_support": "na",
        },
        {
          "language_code": "new",
          "language_name": "Newari",
          "l2_support": "na",
        },
        {
          "language_code": "nl",
          "language_name": "Dutch",
          "l2_support": "beta",
        },
        {
          "language_code": "nl-BE",
          "language_name": "Flemish",
          "l2_support": "beta",
        },
        {
          "language_code": "no",
          "language_name": "Norwegian",
          "l2_support": "na",
        },
        {
          "language_code": "nr",
          "language_name": "South Ndebele",
          "l2_support": "na",
        },
        {
          "language_code": "nso",
          "language_name": "Northern Sotho",
          "l2_support": "na",
        },
        {
          "language_code": "nus",
          "language_name": "Nuer",
          "l2_support": "na",
        },
        {
          "language_code": "ny",
          "language_name": "Nyanja",
          "l2_support": "na",
        },
        {
          "language_code": "oc",
          "language_name": "Occitan",
          "l2_support": "na",
        },
        {
          "language_code": "om",
          "language_name": "Oromo",
          "l2_support": "na",
        },
        {
          "language_code": "or",
          "language_name": "Odia",
          "l2_support": "na",
        },
        {
          "language_code": "pa",
          "language_name": "Punjabi",
          "l2_support": "beta",
        },
        {
          "language_code": "pa-Arab",
          "language_name": "Punjabi (Shahmukhi)",
          "l2_support": "beta",
        },
        {
          "language_code": "pa-IN",
          "language_name": "Punjabi (Gurmukhi)",
          "l2_support": "beta",
        },
        {
          "language_code": "pag",
          "language_name": "Pangasinan",
          "l2_support": "na",
        },
        {
          "language_code": "pam",
          "language_name": "Pampanga",
          "l2_support": "na",
        },
        {
          "language_code": "pap",
          "language_name": "Papiamento",
          "l2_support": "na",
        },
        {
          "language_code": "pl",
          "language_name": "Polish",
          "l2_support": "beta",
        },
        {
          "language_code": "ps",
          "language_name": "Pashto",
          "l2_support": "na",
        },
        {
          "language_code": "pt",
          "language_name": "Portuguese",
          "l2_support": "full",
        },
        {
          "language_code": "pt-BR",
          "language_name": "Portuguese (Brazil)",
          "l2_support": "full",
        },
        {
          "language_code": "pt-PT",
          "language_name": "Portuguese (Portugal)",
          "l2_support": "full",
        },
        {
          "language_code": "qu",
          "language_name": "Quechua",
          "l2_support": "na",
        },
        {
          "language_code": "raj",
          "language_name": "Rajasthani",
          "l2_support": "na",
        },
        {
          "language_code": "rn",
          "language_name": "Rundi",
          "l2_support": "na",
        },
        {
          "language_code": "ro",
          "language_name": "Romanian",
          "l2_support": "beta",
        },
        {
          "language_code": "ro-MD",
          "language_name": "Moldovan",
          "l2_support": "beta",
        },
        {
          "language_code": "ro-RO",
          "language_name": "Romanian (Romania)",
          "l2_support": "beta",
        },
        {
          "language_code": "rom",
          "language_name": "Romany",
          "l2_support": "na",
        },
        {
          "language_code": "ru",
          "language_name": "Russian",
          "l2_support": "full",
        },
        {
          "language_code": "rw",
          "language_name": "Kinyarwanda",
          "l2_support": "na",
        },
        {
          "language_code": "sa",
          "language_name": "Sanskrit",
          "l2_support": "na",
        },
        {
          "language_code": "sat",
          "language_name": "Santali",
          "l2_support": "na",
        },
        {
          "language_code": "scn",
          "language_name": "Sicilian",
          "l2_support": "na",
        },
        {
          "language_code": "sd",
          "language_name": "Sindhi",
          "l2_support": "na",
        },
        {
          "language_code": "sg",
          "language_name": "Sango",
          "l2_support": "na",
        },
        {
          "language_code": "shn",
          "language_name": "Shan",
          "l2_support": "na",
        },
        {
          "language_code": "si",
          "language_name": "Sinhala",
          "l2_support": "na",
        },
        {
          "language_code": "sk",
          "language_name": "Slovak",
          "l2_support": "beta",
        },
        {
          "language_code": "sl",
          "language_name": "Slovenian",
          "l2_support": "na",
        },
        {
          "language_code": "sm",
          "language_name": "Samoan",
          "l2_support": "na",
        },
        {
          "language_code": "sn",
          "language_name": "Shona",
          "l2_support": "na",
        },
        {
          "language_code": "so",
          "language_name": "Somali",
          "l2_support": "na",
        },
        {
          "language_code": "sq",
          "language_name": "Albanian",
          "l2_support": "na",
        },
        {
          "language_code": "sr",
          "language_name": "Serbian",
          "l2_support": "beta",
        },
        {
          "language_code": "sr-ME",
          "language_name": "Montenegrin",
          "l2_support": "beta",
        },
        {
          "language_code": "sr-RS",
          "language_name": "Serbian",
          "l2_support": "beta",
        },
        {
          "language_code": "ss",
          "language_name": "Swati",
          "l2_support": "na",
        },
        {
          "language_code": "st",
          "language_name": "Southern Sotho",
          "l2_support": "na",
        },
        {
          "language_code": "su",
          "language_name": "Sundanese",
          "l2_support": "na",
        },
        {
          "language_code": "sv",
          "language_name": "Swedish",
          "l2_support": "na",
        },
        {
          "language_code": "sw",
          "language_name": "Swahili",
          "l2_support": "na",
        },
        {
          "language_code": "szl",
          "language_name": "Silesian",
          "l2_support": "na",
        },
        {
          "language_code": "ta",
          "language_name": "Tamil",
          "l2_support": "na",
        },
        {
          "language_code": "te",
          "language_name": "Telugu",
          "l2_support": "na",
        },
        {
          "language_code": "tet",
          "language_name": "Tetum",
          "l2_support": "na",
        },
        {
          "language_code": "tg",
          "language_name": "Tajik",
          "l2_support": "na",
        },
        {
          "language_code": "th",
          "language_name": "Thai",
          "l2_support": "na",
        },
        {
          "language_code": "ti",
          "language_name": "Tigrinya",
          "l2_support": "na",
        },
        {
          "language_code": "tk",
          "language_name": "Turkmen",
          "l2_support": "na",
        },
        {
          "language_code": "tl",
          "language_name": "Tagalog",
          "l2_support": "na",
        },
        {
          "language_code": "tn",
          "language_name": "Tswana",
          "l2_support": "na",
        },
        {
          "language_code": "tr",
          "language_name": "Turkish",
          "l2_support": "na",
        },
        {
          "language_code": "ts",
          "language_name": "Tsonga",
          "l2_support": "na",
        },
        {
          "language_code": "tt",
          "language_name": "Tatar",
          "l2_support": "na",
        },
        {
          "language_code": "ug",
          "language_name": "Uyghur",
          "l2_support": "na",
        },
        {
          "language_code": "uk",
          "language_name": "Ukrainian",
          "l2_support": "beta",
        },
        {
          "language_code": "ur",
          "language_name": "Urdu",
          "l2_support": "beta",
        },
        {
          "language_code": "ur-IN",
          "language_name": "Urdu (India)",
          "l2_support": "beta",
        },
        {
          "language_code": "ur-PK",
          "language_name": "Urdu (Pakistan)",
          "l2_support": "beta",
        },
        {
          "language_code": "uz",
          "language_name": "Uzbek",
          "l2_support": "na",
        },
        {
          "language_code": "vi",
          "language_name": "Vietnamese",
          "l2_support": "full",
        },
        {
          "language_code": "wuu",
          "language_name": "Wu",
          "l2_support": "na",
        },
        {
          "language_code": "xh",
          "language_name": "Xhosa",
          "l2_support": "na",
        },
        {
          "language_code": "yi",
          "language_name": "Yiddish",
          "l2_support": "na",
        },
        {
          "language_code": "yo",
          "language_name": "Yoruba",
          "l2_support": "na",
        },
        {
          "language_code": "yua",
          "language_name": "Yucateco",
          "l2_support": "na",
        },
        {
          "language_code": "yue",
          "language_name": "Cantonese",
          "l2_support": "beta",
        },
        {
          "language_code": "yue-CN",
          "language_name": "Cantonese (China)",
          "l2_support": "beta",
        },
        {
          "language_code": "yue-HK",
          "language_name": "Cantonese (Hong Kong)",
          "l2_support": "beta",
        },
        {
          "language_code": "zh",
          "language_name": "Chinese",
          "l2_support": "full",
        },
        {
          "language_code": "zh-CN",
          "language_name": "Chinese (Simplified)",
          "l2_support": "full",
        },
        {
          "language_code": "zh-TW",
          "language_name": "Chinese (Traditional)",
          "l2_support": "full",
        },
        {
          "language_code": "zu",
          "language_name": "Zulu",
          "l2_support": "na",
        }
      ];
}
