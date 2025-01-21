import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';

String? getMorphSvgLink({
  required String morphFeature,
  String? morphTag,
  required BuildContext context,
}) {
  if (morphTag == null) {
    final key = morphFeature.toLowerCase();
    String? filename;
    switch (key) {
      case "advtype":
        filename = "AdverbType.svg";
      case "aspect":
        filename = "Aspect.svg";
      case "conjtype":
        filename = "ConjunctionType.svg";
      case "definite":
        filename = "Definite.svg";
      case "degree":
        filename = "Degree.svg";
      case "mood":
        filename = "Mood.svg";
      case "number":
        filename = "Number.svg";
      case "pos":
        filename = "PartOfSpeech.svg";
      case "person":
        filename = "Person.svg";
      case "polarity":
        filename = "Polarity.svg";
      case "prontype":
        filename = "PronounType.svg";
      case "verbform":
        "VerbForm.svg";
      case "voice":
        filename = "Voice.svg";
    }

    if (filename == null) {
      ErrorHandler.logError(
        e: "Missing morphFeature in getMorphSvgLink",
        data: {"morphFeature": morphFeature},
      );
      debugPrint("Missing morphFeature in getMorphSvgLink: $morphFeature");
      return null;
    }

    return "${AppConfig.svgAssetsBaseURL}/$filename";
  }

  final key = "${morphFeature.toLowerCase()}${morphTag.toLowerCase()}";
  String? filename;
  switch (key) {
    case "advtypeadverbial":
      filename = "AdverbType_Adverbial.svg";
    case "advtypetim":
      filename = "AdverbType_TemporalAdverb.svg";
    case "aspecthab":
      filename = "Aspect_Habitual.svg";
    case "aspectimp":
      filename = "Aspect_Imperfective.svg";
    case "aspectperf":
      filename = "Aspect_Perfective.svg";
    case "aspectprog":
      filename = "Aspect_Progressive.svg";
    case "conjtypecoord":
      filename = "ConjunctionType_Coordinating.svg";
    case "conjtypesub":
      filename = "ConjunctionType_Subordinating.svg";
    case "definitedef":
      filename = "Definite_Definite.svg";
    case "definiteind":
      filename = "Definite_Indefinite.svg";
    case "degreecmp":
      filename = "Degree_Comparative.svg";
    case "degreepos":
      filename = "Degree_Positive.svg";
    case "degreesup":
      filename = "Degree_Superlative.svg";
    case "moodcnd":
      filename = "Mood_Conditional.svg";
    case "moodimp":
      filename = "Mood_Imperative.svg";
    case "moodind":
      filename = "Mood_Indicative.svg";
    case "moodopt":
      filename = "Mood_Optative.svg";
    case "moodsub":
      filename = "Mood_Subjunctive.svg";
    case "numberplur":
      filename = "Number_Plural.svg";
    case "numbersing":
      filename = "Number_Singular.svg";
    case "posadv":
      filename = "PartOfSpeech_Adverb.svg";
    case "posadj":
      filename = "PartOfSpeech_Adjective.svg";
    case "posadp":
      filename = "PartOfSpeech_Adposition.svg";
    case "posaux":
      filename = "PartOfSpeech_Auxiliary.svg";
    case "posconj":
      filename = "PartOfSpeech_Conjunction.svg";
    case "posdet":
      filename = "PartOfSpeech_Determiner.svg";
    case "posnoun":
      filename = "PartOfSpeech_Noun.svg";
    case "posnum":
      filename = "PartOfSpeech_Numeral.svg";
    case "pospron":
      filename = "PartOfSpeech_Pronoun.svg";
    case "pospunct":
      filename = "PartOfSpeech_Punctuation.svg";
    case "possconj":
      filename = "PartOfSpeech_Subconjunction.svg";
    case "posverb":
      filename = "PartOfSpeech_Verb.svg";
    case "person1":
      filename = "Person_FirstPerson.svg";
    case "person2":
      filename = "Person_SecondPerson.svg";
    case "person3":
      filename = "Person_ThirdPerson.svg";
    case "polarityneg":
      filename = "Polarity_Negative.svg";
    case "polaritypos":
      filename = "Polarity_Positive.svg";
    case "prontypedem":
      filename = "PronounType_Demonstrative.svg";
    case "prontypeind":
      filename = "PronounType_Indefinite.svg";
    case "prontypeint":
      filename = "PronounType_Interrogative.svg";
    case "prontypeneg":
      filename = "PronounType_Negative.svg";
    case "prontypeprs":
      filename = "PronounType_Personal.svg";
    case "prontyperel":
      filename = "PronounType_Relative.svg";
    case "prontypetot":
      filename = "PronounType_Total.svg";
    case "tensefut":
      filename = "Tense_future.svg";
    case "tenseimp":
      filename = "Tense_imperfect.svg";
    case "tensepast":
      filename = "Tense_past.svg";
    case "tensepres":
      filename = "Tense_present.svg";
    case "verbformfin":
      filename = "VerbForm_Finite.svg";
    case "verbformger":
      filename = "VerbForm_Gerund.svg";
    case "verbforminf":
      filename = "VerbForm_Infinitive.svg";
    case "verbformpart":
      filename = "VerbForm_Participle.svg";
    case "voiceact":
      filename = "Voice_Active.svg";
    case "voicemid":
      filename = "Voice_Middle.svg";
    case "voicepass":
      filename = "Voice_Passive.svg";
  }

  if (filename == null) {
    ErrorHandler.logError(
      e: "Missing morphFeature and morphTag in getMorphSvgLink",
      data: {"morphFeature": morphFeature, "morphTag": morphTag},
    );
    debugPrint(
      "Missing morphFeature and morphTag in getMorphSvgLink: $morphFeature, $morphTag",
    );
    return null;
  }

  return "${AppConfig.svgAssetsBaseURL}/$filename";
}
