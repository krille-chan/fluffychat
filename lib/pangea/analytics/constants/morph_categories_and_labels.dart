import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';

const Map<String, List<String>> morphCategoriesAndLabels = {
  "pos": [
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
  "advtype": ["Adverbial", "Tim"],
  "aspect": [
    "Imp",
    "Perf",
    "Prog",
    "Hab",
  ],
  "case": [
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
  "conjtype": ["Coord", "Sub", "Cmp"],
  "definite": ["Def", "Ind", "Cons"],
  "degree": [
    "Pos",
    "Cmp",
    "Sup",
    "Abs",
  ],
  "evident": ["Fh", "Nfh"],
  "foreign": ["Yes"],
  "gender": ["Masc", "Fem", "Neut", "Com"],
  "mood": [
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
  "nountype": ["Prop", "Comm", "Not_proper"],
  "numform": [
    "Digit",
    "Word",
    "Roman",
    "Letter",
  ],
  "numtype": [
    "Card",
    "Ord",
    "Mult",
    "Frac",
    "Sets",
    "Range",
    "Dist",
  ],
  "number": [
    "Sing",
    "Plur",
    "Dual",
    "Tri",
    "Pauc",
    "Grpa",
    "Grpl",
    "Inv",
  ],
  "number[psor]": ["Sing", "Plur", "Dual"],
  "person": [
    "0",
    "1",
    "2",
    "3",
    "4",
  ],
  "polarity": ["Pos", "Neg"],
  "polite": ["Infm", "Form", "Elev", "Humb"],
  "poss": ["Yes"],
  "prepcase": ["Npr"],
  "prontype": [
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
  "punctside": ["Ini", "Fin"],
  "puncttype": [
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
  "reflex": ["Yes"],
  "tense": ["Pres", "Past", "Fut", "Imp", "Pqp", "Aor", "Eps", "Prosp"],
  "verbform": [
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
  "verbtype": ["Mod", "Caus"],
  "voice": ["Act", "Mid", "Pass", "Antip", "Cau", "Dir", "Inv", "Rcp", "Caus"],
  "x": ["X"],
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
      return Icons.help_outline;
  }
}

List<String> getLabelsForMorphCategory(String feature) =>
    morphCategoriesAndLabels[feature.toLowerCase()] ?? [];

List<String> getMorphCategories() => morphCategoriesAndLabels.keys.toList();
