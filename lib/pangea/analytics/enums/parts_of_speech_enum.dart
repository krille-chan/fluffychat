import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';

enum GrammarCopyPOS {
  sconj,
  num,
  verb,
  affix,
  part,
  adj,
  cconj,
  punct,
  adv,
  aux,
  space,
  sym,
  det,
  pron,
  adp,
  propn,
  noun,
  intj,
  x,
}

extension GrammarCopyPOSExtension on GrammarCopyPOS {
  /// Convert enum to string
  String toShortString() {
    return toString().split('.').last.toLowerCase();
  }

  GrammarCopyPOS? fromString(String categoryName) {
    final pos = GrammarCopyPOS.values.firstWhereOrNull(
      (pos) => pos.toShortString() == categoryName.toLowerCase(),
    );
    if (pos == null) {
      ErrorHandler.logError(
        e: "Missing part of speech",
        s: StackTrace.current,
        data: {"category": categoryName},
      );
    }
    return pos;
  }

  String getDisplayCopy(BuildContext context) {
    switch (this) {
      case GrammarCopyPOS.sconj:
        return L10n.of(context).grammarCopyPOSsconj;
      case GrammarCopyPOS.num:
        return L10n.of(context).grammarCopyPOSnum;
      case GrammarCopyPOS.verb:
        return L10n.of(context).grammarCopyPOSverb;
      case GrammarCopyPOS.affix:
        return L10n.of(context).grammarCopyPOSaffix;
      case GrammarCopyPOS.part:
        return L10n.of(context).grammarCopyPOSpart;
      case GrammarCopyPOS.adj:
        return L10n.of(context).grammarCopyPOSadj;
      case GrammarCopyPOS.cconj:
        return L10n.of(context).grammarCopyPOScconj;
      case GrammarCopyPOS.punct:
        return L10n.of(context).grammarCopyPOSpunct;
      case GrammarCopyPOS.adv:
        return L10n.of(context).grammarCopyPOSadv;
      case GrammarCopyPOS.aux:
        return L10n.of(context).grammarCopyPOSaux;
      case GrammarCopyPOS.space:
        return L10n.of(context).grammarCopyPOSspace;
      case GrammarCopyPOS.sym:
        return L10n.of(context).grammarCopyPOSsym;
      case GrammarCopyPOS.det:
        return L10n.of(context).grammarCopyPOSdet;
      case GrammarCopyPOS.pron:
        return L10n.of(context).grammarCopyPOSpron;
      case GrammarCopyPOS.adp:
        return L10n.of(context).grammarCopyPOSadp;
      case GrammarCopyPOS.propn:
        return L10n.of(context).grammarCopyPOSpropn;
      case GrammarCopyPOS.noun:
        return L10n.of(context).grammarCopyPOSnoun;
      case GrammarCopyPOS.intj:
        return L10n.of(context).grammarCopyPOSintj;
      case GrammarCopyPOS.x:
        return L10n.of(context).grammarCopyPOSx;
    }
  }
}

String? getVocabCategoryName(String category, BuildContext context) {
  return GrammarCopyPOS.values
      .firstWhereOrNull((pos) => pos.toShortString() == category.toLowerCase())
      ?.getDisplayCopy(context);
}
