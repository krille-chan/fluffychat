// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';

enum MorphologicalCategories {
  Pos,
  AdvType,
  Aspect,
  Case,
  ConjType,
  Definite,
  Degree,
  Evident,
  Foreign,
  Gender,
  Mood,
  NounType,
  NumForm,
  NumType,
  Number,
  NumberPsor,
  Person,
  Polarity,
  Polite,
  Poss,
  PrepCase,
  PronType,
  PunctSide,
  PunctType,
  Reflex,
  Tense,
  VerbForm,
  VerbType,
  Voice,
}

extension MorphologicalCategoriesExtension on MorphologicalCategories {
  /// Convert enum to string
  String toShortString() {
    return toString().split('.').last.toLowerCase();
  }

  /// Convert string to enum
  static MorphologicalCategories? fromString(String category) {
    final morph = MorphologicalCategories.values.firstWhereOrNull(
      (e) =>
          e.toShortString() ==
          category.toLowerCase().replaceAll(RegExp(r'[,\[\]]'), ''),
    );
    if (morph == null) {
      ErrorHandler.logError(
        e: "Missing morphological category",
        s: StackTrace.current,
        data: {"category": category},
      );
    }
    return morph;
  }

  String getDisplayCopy(BuildContext context) {
    switch (this) {
      case MorphologicalCategories.Pos:
        return L10n.of(context).grammarCopyPOS;
      case MorphologicalCategories.AdvType:
        return L10n.of(context).grammarCopyADVTYPE;
      case MorphologicalCategories.Aspect:
        return L10n.of(context).grammarCopyASPECT;
      case MorphologicalCategories.Case:
        return L10n.of(context).grammarCopyCASE;
      case MorphologicalCategories.ConjType:
        return L10n.of(context).grammarCopyCONJTYPE;
      case MorphologicalCategories.Definite:
        return L10n.of(context).grammarCopyDEFINITE;
      case MorphologicalCategories.Degree:
        return L10n.of(context).grammarCopyDEGREE;
      case MorphologicalCategories.Evident:
        return L10n.of(context).grammarCopyEVIDENT;
      case MorphologicalCategories.Foreign:
        return L10n.of(context).grammarCopyFOREIGN;
      case MorphologicalCategories.Gender:
        return L10n.of(context).grammarCopyGENDER;
      case MorphologicalCategories.Mood:
        return L10n.of(context).grammarCopyMOOD;
      case MorphologicalCategories.NounType:
        return L10n.of(context).grammarCopyNOUNTYPE;
      case MorphologicalCategories.NumForm:
        return L10n.of(context).grammarCopyNUMFORM;
      case MorphologicalCategories.NumType:
        return L10n.of(context).grammarCopyNUMTYPE;
      case MorphologicalCategories.Number:
        return L10n.of(context).grammarCopyNUMBER;
      case MorphologicalCategories.NumberPsor:
        return L10n.of(context).grammarCopyNUMBERPSOR;
      case MorphologicalCategories.Person:
        return L10n.of(context).grammarCopyPERSON;
      case MorphologicalCategories.Polarity:
        return L10n.of(context).grammarCopyPOLARITY;
      case MorphologicalCategories.Polite:
        return L10n.of(context).grammarCopyPOLITE;
      case MorphologicalCategories.Poss:
        return L10n.of(context).grammarCopyPOSS;
      case MorphologicalCategories.PrepCase:
        return L10n.of(context).grammarCopyPREPCASE;
      case MorphologicalCategories.PronType:
        return L10n.of(context).grammarCopyPRONTYPE;
      case MorphologicalCategories.PunctSide:
        return L10n.of(context).grammarCopyPUNCTSIDE;
      case MorphologicalCategories.PunctType:
        return L10n.of(context).grammarCopyPUNCTTYPE;
      case MorphologicalCategories.Reflex:
        return L10n.of(context).grammarCopyREFLEX;
      case MorphologicalCategories.Tense:
        return L10n.of(context).grammarCopyTENSE;
      case MorphologicalCategories.VerbForm:
        return L10n.of(context).grammarCopyVERBFORM;
      case MorphologicalCategories.VerbType:
        return L10n.of(context).grammarCopyVERBTYPE;
      case MorphologicalCategories.Voice:
        return L10n.of(context).grammarCopyVOICE;
    }
  }
}

String? getMorphologicalCategoryCopy(
  String categoryName,
  BuildContext context,
) {
  final MorphologicalCategories? category =
      MorphologicalCategoriesExtension.fromString(categoryName);

  if (category == null) {
    return null;
  }
  return category.getDisplayCopy(context);
}
