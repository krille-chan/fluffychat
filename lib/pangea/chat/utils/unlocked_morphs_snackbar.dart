// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';

void showUnlockedMorphsSnackbar(
  Set<ConstructIdentifier> unlockedConstructs,
  BuildContext context,
) {
  for (final construct in unlockedConstructs) {
    final copy = getGrammarCopy(
      category: construct.category,
      lemma: construct.lemma,
      context: context,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: FluffyThemes.isColumnMode(context)
            ? SnackBarBehavior.floating
            : SnackBarBehavior.fixed,
        width: FluffyThemes.isColumnMode(context)
            ? MediaQuery.of(context).size.width
            : null,
        showCloseIcon: true,
        duration: const Duration(seconds: 5),
        dismissDirection: DismissDirection.none,
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 16.0,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                L10n.of(context).youUnlocked,
                style: TextStyle(
                  fontSize: FluffyThemes.isColumnMode(context) ? 32.0 : 16.0,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 16.0,
                children: [
                  Flexible(
                    child: Text(
                      copy ?? construct.lemma,
                      style: TextStyle(
                        fontSize:
                            FluffyThemes.isColumnMode(context) ? 32.0 : 16.0,
                        color: AppConfig.gold,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  MorphIcon(
                    morphFeature: MorphFeaturesEnumExtension.fromString(
                      construct.category,
                    ),
                    morphTag: construct.lemma,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
