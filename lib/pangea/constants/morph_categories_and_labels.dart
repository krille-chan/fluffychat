import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';

const Map<String, List<String>> morphCategoriesAndLabels = {
  "Pos": [
    "ADJ",
    "ADP",
    "ADV",
    "AFFIX",
    "AUX",
    "CCONJ",
    "DET",
    "INTJ",
    "NOUN",
    "NUM",
    "PART",
    "PRON",
    "PROPN",
    "PUNCT",
    "SCONJ",
    "SPACE",
    "SYM",
    "VERB",
    "X",
  ],
  "AdvType": ["Adverbial", "Tim"],
  "Aspect": [
    "Imp",
    "Perf",
    "Prog",
    "Hab",
  ],
  "Case": [
    "Nom",
    "Acc",
    "Dat",
    "Gen",
    "Voc",
    "Abl",
    "Loc",
    "All",
    "Ins",
    "Ess",
    "Tra",
    "Com",
    "Par",
    "Adv",
    "Ref",
    "Rel",
    "Equ",
    "Dis",
    "Abs",
    "Erg",
    "Cau",
    "Ben",
    "Sub",
    "Sup",
    "Tem",
    "Obl",
    "Acc,Dat",
    "Acc,Nom",
    "Pre",
  ],
  "ConjType": ["Coord", "Sub", "Cmp"],
  "Definite": ["Def", "Ind", "Cons"],
  "Degree": [
    "Pos",
    "Cmp",
    "Sup",
    "Abs",
  ],
  "Evident": ["Fh", "Nfh"],
  "Foreign": ["Yes"],
  "Gender": ["Masc", "Fem", "Neut", "Com"],
  "Mood": [
    "Ind",
    "Imp",
    "Sub",
    "Cnd",
    "Opt",
    "Jus",
    "Adm",
    "Des",
    "Nec",
    "Pot",
    "Prp",
    "Qot",
    "Int",
  ],
  "NounType": ["Prop", "Comm", "Not_proper"],
  "NumForm": [
    "Digit",
    "Word",
    "Roman",
    "Letter",
  ],
  "NumType": [
    "Card",
    "Ord",
    "Mult",
    "Frac",
    "Sets",
    "Range",
    "Dist",
  ],
  "Number": [
    "Sing",
    "Plur",
    "Dual",
    "Tri",
    "Pauc",
    "Grpa",
    "Grpl",
    "Inv",
  ],
  "Number[psor]": ["Sing", "Plur", "Dual"],
  "Person": [
    "0",
    "1",
    "2",
    "3",
    "4",
  ],
  "Polarity": ["Pos", "Neg"],
  "Polite": ["Infm", "Form", "Elev", "Humb"],
  "Poss": ["Yes"],
  "PrepCase": ["Npr"],
  "PronType": [
    "Prs",
    "Int",
    "Rel",
    "Dem",
    "Tot",
    "Neg",
    "Art",
    "Emp",
    "Exc",
    "Ind",
    "Rcp",
    "Int,Rel",
  ],
  "PunctSide": ["Ini", "Fin"],
  "PunctType": [
    "Brck",
    "Dash",
    "Excl",
    "Peri",
    "Qest",
    "Quot",
    "Semi",
    "Colo",
    "Comm",
  ],
  "Reflex": ["Yes"],
  "Tense": ["Pres", "Past", "Fut", "Imp", "Pqp", "Aor", "Eps", "Prosp"],
  "VerbForm": [
    "Fin",
    "Inf",
    "Sup",
    "Part",
    "Conv",
    "Vnoun",
    "Ger",
    "Adn",
    "Lng",
  ],
  "VerbType": ["Mod", "Caus"],
  "Voice": ["Act", "Mid", "Pass", "Antip", "Cau", "Dir", "Inv", "Rcp", "Caus"],
  "X": ["X"],
};

// TODO Use the icons that Khue is creating
IconData getIconForMorphFeature(String feature) {
  // Define a function to get the icon based on the universal dependency morphological feature (key)
  switch (feature.toLowerCase()) {
    case 'number':
      // google material 123 icon
      return Icons.format_list_numbered;
    case 'gender':
      return Icons.wc;
    case 'tense':
      return Icons.access_time;
    case 'mood':
      return Icons.mood;
    case 'person':
      return Icons.person;
    case 'case':
      return Icons.format_list_bulleted;
    case 'degree':
      return Icons.trending_up;
    case 'verbform':
      return Icons.text_format;
    case 'voice':
      return Icons.record_voice_over;
    case 'aspect':
      return Icons.aspect_ratio;
    case 'prontype':
      return Icons.text_fields;
    case 'numtype':
      return Icons.format_list_numbered;
    case 'poss':
      return Icons.account_balance;
    case 'reflex':
      return Icons.refresh;
    case 'foreign':
      return Icons.language;
    case 'abbr':
      return Icons.text_format;
    case 'nountype':
      return Symbols.abc;
    case 'pos':
      return Symbols.toys_and_games;
    case 'polarity':
      return Icons.swap_vert;
    case 'definite':
      return Icons.check_circle_outline;
    case 'prepcase':
      return Icons.location_on_outlined;
    case 'conjtype':
      return Icons.compare_arrows;
    default:
      debugger(when: kDebugMode);
      return Icons.help_outline;
  }
}

List<String> getLabelsForMorphCategory(String category) {
  for (final feat in morphCategoriesAndLabels.keys) {
    if (feat.toLowerCase() == category.toLowerCase()) {
      return morphCategoriesAndLabels[feat]!;
    }
  }
  return [];
}
