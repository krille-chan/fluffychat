import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_details_popup/vocab_analytics_list_tile.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_navigation_util.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

mixin LemmaEmojiSetter {
  Future<void> setLemmaEmoji(
    ConstructIdentifier constructId,
    String langCode,
    String emoji,
    String? targetId,
    String? roomId,
    String? eventId,
    String? form,
  ) async {
    final userL2 =
        MatrixState.pangeaController.userController.userL2?.langCodeShort;
    if (langCode.split("-").first != userL2) {
      // only set emoji for user's L2 language
      return;
    }

    if (constructId.userSetEmoji == null) {
      _getEmojiAnalytics(
        constructId,
        language: langCode.split("-").first,
        targetId: targetId,
        roomId: roomId,
        eventId: eventId,
        form: form,
      );
    }

    await MatrixState
        .pangeaController
        .matrixState
        .analyticsDataService
        .updateService
        .setLemmaInfo(constructId, emoji: emoji);
  }

  void showLemmaEmojiSnackbar(
    ScaffoldMessengerState messenger,
    BuildContext context,
    ConstructIdentifier constructId,
    String emoji,
  ) {
    if (InstructionsEnum.setLemmaEmoji.isToggledOff) return;
    InstructionsEnum.setLemmaEmoji.setToggledOff(true);

    messenger.showSnackBar(
      SnackBar(
        showCloseIcon: false,
        padding: const EdgeInsets.all(8.0),
        content: Row(
          spacing: 8.0,
          children: [
            VocabAnalyticsListTile(
              constructId: constructId,
              textColor: Theme.of(context).colorScheme.surface,
              onTap: () {
                messenger.hideCurrentSnackBar();
                AnalyticsNavigationUtil.navigateToAnalytics(
                  context: context,
                  view: constructId.type.indicator,
                  construct: constructId,
                );
              },
            ),
            Expanded(
              child: Text(
                L10n.of(context).emojiSelectedSnackbar(constructId.lemma),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: Theme.of(context).colorScheme.surface,
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            ),
          ],
        ),
        duration: const Duration(seconds: 30),
      ),
    );
  }

  void _getEmojiAnalytics(
    ConstructIdentifier constructId, {
    required String language,
    String? eventId,
    String? roomId,
    String? targetId,
    String? form,
  }) {
    final constructs = [
      OneConstructUse(
        useType: ConstructUseTypeEnum.em,
        lemma: constructId.lemma,
        constructType: constructId.type,
        metadata: ConstructUseMetaData(
          roomId: roomId,
          timeStamp: DateTime.now(),
          eventId: eventId,
        ),
        category: constructId.category,
        form: form ?? constructId.lemma,
        xp: ConstructUseTypeEnum.em.pointValue,
      ),
    ];

    MatrixState.pangeaController.matrixState.analyticsDataService.updateService
        .addAnalytics(targetId, constructs, language);
  }
}
