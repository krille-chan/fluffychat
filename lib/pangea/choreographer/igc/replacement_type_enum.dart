import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum ReplacementTypeEnum {
  // Client-specific types
  definition,
  practice,
  itStart,

  // === GRAMMAR CATEGORIES (granular for teacher analytics) ===
  verbConjugation, // Wrong form for person/number/tense
  verbTense, // Using wrong tense for context
  verbMood, // Indicative vs subjunctive vs imperative
  subjectVerbAgreement, // "he go" -> "he goes"
  genderAgreement, // "la libro" -> "el libro"
  numberAgreement, // Singular/plural mismatches
  caseError, // For languages with grammatical cases
  article, // Missing, wrong, or unnecessary articles
  preposition, // Wrong preposition choice
  pronoun, // Wrong form, reference, or missing
  wordOrder, // Syntax/structure issues
  negation, // Double negatives, wrong placement
  questionFormation, // Incorrect question structure
  relativeClause, // who/which/that errors
  connector, // Conjunction usage (but/and/however)
  possessive, // Apostrophe usage, possessive pronouns
  comparative, // Comparative/superlative forms
  passiveVoice, // Passive construction errors
  conditional, // If clauses, would/could
  infinitiveGerund, // Infinitive vs gerund usage
  modal, // Modal verb usage (can/could/should/must)
  // === SURFACE-LEVEL CORRECTIONS (auto-applied) ===
  punct,
  diacritics,
  spell,
  cap,

  // === WORD CHOICE CATEGORIES (granular for teacher analytics) ===
  falseCognate, // False friends (e.g., "embarazada" ≠ "embarrassed")
  l1Interference, // L1 patterns bleeding through incorrectly
  collocation, // Wrong word pairing (e.g., "do a mistake" → "make a mistake")
  semanticConfusion, // Similar meanings, wrong choice (e.g., "see/watch/look")
  // === HIGHER-LEVEL SUGGESTIONS ===
  transcription,
  style,
  fluency,
  didYouMean,
  translation,
  other,
}

extension SpanDataTypeEnumExt on ReplacementTypeEnum {
  /// Types that should be auto-applied without user interaction.
  /// These are minor corrections like punctuation, spacing, accents, etc.
  static const List<ReplacementTypeEnum> autoApplyTypes = [
    ReplacementTypeEnum.punct,
    ReplacementTypeEnum.diacritics,
    ReplacementTypeEnum.spell,
    ReplacementTypeEnum.cap,
  ];

  /// Grammar types that require explanatory reasons for learning.
  static const List<ReplacementTypeEnum> grammarTypes = [
    ReplacementTypeEnum.verbConjugation,
    ReplacementTypeEnum.verbTense,
    ReplacementTypeEnum.verbMood,
    ReplacementTypeEnum.subjectVerbAgreement,
    ReplacementTypeEnum.genderAgreement,
    ReplacementTypeEnum.numberAgreement,
    ReplacementTypeEnum.caseError,
    ReplacementTypeEnum.article,
    ReplacementTypeEnum.preposition,
    ReplacementTypeEnum.pronoun,
    ReplacementTypeEnum.wordOrder,
    ReplacementTypeEnum.negation,
    ReplacementTypeEnum.questionFormation,
    ReplacementTypeEnum.relativeClause,
    ReplacementTypeEnum.connector,
    ReplacementTypeEnum.possessive,
    ReplacementTypeEnum.comparative,
    ReplacementTypeEnum.passiveVoice,
    ReplacementTypeEnum.conditional,
    ReplacementTypeEnum.infinitiveGerund,
    ReplacementTypeEnum.modal,
  ];

  /// Word choice types that require explanatory reasons for learning.
  static const List<ReplacementTypeEnum> wordChoiceTypes = [
    ReplacementTypeEnum.falseCognate,
    ReplacementTypeEnum.l1Interference,
    ReplacementTypeEnum.collocation,
    ReplacementTypeEnum.semanticConfusion,
  ];

  /// Whether this type should be auto-applied without user interaction.
  bool get isAutoApply => autoApplyTypes.contains(this);

  /// Whether this is a grammar-related type (for analytics grouping).
  bool get isGrammarType => grammarTypes.contains(this);

  /// Whether this is a word-choice-related type (for analytics grouping).
  bool get isWordChoiceType => wordChoiceTypes.contains(this);

  /// Convert enum to snake_case string for JSON serialization.
  String get name {
    switch (this) {
      // Client-specific types
      case ReplacementTypeEnum.definition:
        return "definition";
      case ReplacementTypeEnum.practice:
        return "practice";
      case ReplacementTypeEnum.itStart:
        return "itStart";

      // Grammar types
      case ReplacementTypeEnum.verbConjugation:
        return "verb_conjugation";
      case ReplacementTypeEnum.verbTense:
        return "verb_tense";
      case ReplacementTypeEnum.verbMood:
        return "verb_mood";
      case ReplacementTypeEnum.subjectVerbAgreement:
        return "subject_verb_agreement";
      case ReplacementTypeEnum.genderAgreement:
        return "gender_agreement";
      case ReplacementTypeEnum.numberAgreement:
        return "number_agreement";
      case ReplacementTypeEnum.caseError:
        return "case_error";
      case ReplacementTypeEnum.article:
        return "article";
      case ReplacementTypeEnum.preposition:
        return "preposition";
      case ReplacementTypeEnum.pronoun:
        return "pronoun";
      case ReplacementTypeEnum.wordOrder:
        return "word_order";
      case ReplacementTypeEnum.negation:
        return "negation";
      case ReplacementTypeEnum.questionFormation:
        return "question_formation";
      case ReplacementTypeEnum.relativeClause:
        return "relative_clause";
      case ReplacementTypeEnum.connector:
        return "connector";
      case ReplacementTypeEnum.possessive:
        return "possessive";
      case ReplacementTypeEnum.comparative:
        return "comparative";
      case ReplacementTypeEnum.passiveVoice:
        return "passive_voice";
      case ReplacementTypeEnum.conditional:
        return "conditional";
      case ReplacementTypeEnum.infinitiveGerund:
        return "infinitive_gerund";
      case ReplacementTypeEnum.modal:
        return "modal";

      // Surface-level corrections
      case ReplacementTypeEnum.punct:
        return "punct";
      case ReplacementTypeEnum.diacritics:
        return "diacritics";
      case ReplacementTypeEnum.spell:
        return "spell";
      case ReplacementTypeEnum.cap:
        return "cap";

      // Word choice types
      case ReplacementTypeEnum.falseCognate:
        return "false_cognate";
      case ReplacementTypeEnum.l1Interference:
        return "l1_interference";
      case ReplacementTypeEnum.collocation:
        return "collocation";
      case ReplacementTypeEnum.semanticConfusion:
        return "semantic_confusion";

      // Higher-level suggestions
      case ReplacementTypeEnum.transcription:
        return "transcription";
      case ReplacementTypeEnum.style:
        return "style";
      case ReplacementTypeEnum.fluency:
        return "fluency";
      case ReplacementTypeEnum.didYouMean:
        return "did_you_mean";
      case ReplacementTypeEnum.translation:
        return "translation";
      case ReplacementTypeEnum.other:
        return "other";
    }
  }

  /// Parse type string from JSON, handling backward compatibility
  /// for old saved data and snake_case to camelCase conversion.
  static ReplacementTypeEnum? fromString(String? typeString) {
    if (typeString == null) return null;

    // Normalize snake_case to camelCase and handle backward compatibility
    final normalized = switch (typeString) {
      // Legacy mappings - grammar and word_choice were split into subtypes
      'correction' => 'subjectVerbAgreement', // Legacy fallback
      'grammar' => 'subjectVerbAgreement', // Legacy fallback
      'word_choice' => 'semanticConfusion', // Legacy fallback
      // Snake_case to camelCase conversions - grammar types
      'did_you_mean' => 'didYouMean',
      'verb_conjugation' => 'verbConjugation',
      'verb_tense' => 'verbTense',
      'verb_mood' => 'verbMood',
      'subject_verb_agreement' => 'subjectVerbAgreement',
      'gender_agreement' => 'genderAgreement',
      'number_agreement' => 'numberAgreement',
      'case_error' => 'caseError',
      'word_order' => 'wordOrder',
      'question_formation' => 'questionFormation',
      'relative_clause' => 'relativeClause',
      'passive_voice' => 'passiveVoice',
      'infinitive_gerund' => 'infinitiveGerund',

      // Snake_case to camelCase conversions - word choice types
      'false_cognate' => 'falseCognate',
      'l1_interference' => 'l1Interference',
      'semantic_confusion' => 'semanticConfusion',
      // 'collocation' is already single word, no conversion needed

      // Already camelCase or single word - pass through
      _ => typeString,
    };

    return ReplacementTypeEnum.values.firstWhereOrNull(
      (e) => e.name == normalized || e.toString().split('.').last == normalized,
    );
  }

  String defaultPrompt(BuildContext context) {
    switch (this) {
      case ReplacementTypeEnum.definition:
        return L10n.of(context).definitionDefaultPrompt;
      case ReplacementTypeEnum.practice:
        return L10n.of(context).practiceDefaultPrompt;
      case ReplacementTypeEnum.itStart:
        return L10n.of(context).needsItMessage(
          MatrixState.pangeaController.userController.userL2?.getDisplayName(
                context,
              ) ??
              L10n.of(context).targetLanguage,
        );
      // All grammar types and other corrections use the same default prompt
      default:
        return L10n.of(context).correctionDefaultPrompt;
    }
  }

  /// Returns the underline color for this replacement type.
  /// Used to visually distinguish different error categories in the text field.
  Color get color {
    // IT start and auto-apply types use primary color
    if (this == ReplacementTypeEnum.itStart) {
      return AppConfig.primaryColor;
    }

    // Mint green
    if (isAutoApply) {
      return Color.fromARGB(255, 152, 255, 152);
    }

    // Grammar errors use Coral / warm pink
    if (isGrammarType) {
      return Color.fromARGB(255, 245, 122, 138);
    }
    // Word choice uses Sky blue
    if (isWordChoiceType) {
      return Color.fromARGB(255, 135, 206, 235);
    }
    // Style and fluency use Lavender
    switch (this) {
      case ReplacementTypeEnum.style:
      case ReplacementTypeEnum.fluency:
        return Color.fromARGB(255, 188, 139, 194);
      case ReplacementTypeEnum.translation:
        return Color.fromARGB(255, 255, 126, 0); // Amber
      default:
        // Other/unknown use error color
        return AppConfig.error;
    }
  }

  /// Returns a human-readable display name for this replacement type.
  /// Used in the SpanCard UI to show the error category.
  String displayName(BuildContext context) {
    if (isGrammarType) {
      return L10n.of(context).spanTypeGrammar;
    }
    if (isWordChoiceType) {
      return L10n.of(context).spanTypeWordChoice;
    }
    switch (this) {
      case ReplacementTypeEnum.spell:
        return L10n.of(context).spanTypeSpelling;
      case ReplacementTypeEnum.punct:
        return L10n.of(context).spanTypePunctuation;
      case ReplacementTypeEnum.style:
        return L10n.of(context).spanTypeStyle;
      case ReplacementTypeEnum.fluency:
        return L10n.of(context).spanTypeFluency;
      case ReplacementTypeEnum.diacritics:
        return L10n.of(context).spanTypeAccents;
      case ReplacementTypeEnum.cap:
        return L10n.of(context).spanTypeCapitalization;
      default:
        return L10n.of(context).spanTypeCorrection;
    }
  }
}
