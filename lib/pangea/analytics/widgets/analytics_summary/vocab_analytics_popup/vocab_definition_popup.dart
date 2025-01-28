import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/analytics/enums/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics/enums/learning_skills_enum.dart';
import 'package:fluffychat/pangea/analytics/enums/lemma_category_enum.dart';
import 'package:fluffychat/pangea/analytics/models/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics/models/constructs_model.dart';
import 'package:fluffychat/pangea/analytics/models/lemma.dart';
import 'package:fluffychat/pangea/analytics/repo/lemma_info_repo.dart';
import 'package:fluffychat/pangea/analytics/repo/lemma_info_request.dart';
import 'package:fluffychat/pangea/analytics/repo/lemma_info_response.dart';
import 'package:fluffychat/pangea/analytics/utils/get_grammar_copy.dart';
import 'package:fluffychat/pangea/common/widgets/customized_svg.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_audio_button.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Displays information about selected lemma, and its usage
class VocabDefinitionPopup extends StatelessWidget {
  final ConstructUses construct;
  final VoidCallback onClose;

  const VocabDefinitionPopup({
    super.key,
    required this.construct,
    required this.onClose,
  });

  String? get emoji => PangeaToken(
        text: PangeaTokenText(
          offset: 0,
          content: construct.lemma,
          length: construct.lemma.length,
        ),
        lemma: Lemma(
          text: construct.lemma,
          saveVocab: false,
          form: construct.lemma,
        ),
        pos: construct.category,
        morph: {},
      ).getEmoji();

  /// Get string representing forms of the given lemma that have been used
  String? get formString {
    // Get possible forms of lemma
    final constructs = MatrixState
        .pangeaController.getAnalytics.constructListModel
        .getConstructUsesByLemma(construct.lemma);

    final forms = constructs
        .map((e) => e.uses)
        .expand((element) => element)
        .where((use) => use.useType.pointValue > 0)
        .map((e) => e.form?.toLowerCase())
        .toSet()
        .whereType<String>()
        .toList();

    if (forms.isEmpty) return null;
    return forms.join(", ");
  }

  /// Fetch the meaning of the lemma
  Future<String?> getDefinition(BuildContext context) async {
    final lang2 =
        MatrixState.pangeaController.languageController.userL2?.langCode;
    if (lang2 == null) {
      debugPrint("No lang2, cannot retrieve definition");
      return L10n.of(context).meaningNotFound;
    }

    final LemmaInfoRequest lemmaDefReq = LemmaInfoRequest(
      partOfSpeech: construct.category,
      lemmaLang: lang2,
      userL1:
          MatrixState.pangeaController.languageController.userL1?.langCode ??
              LanguageKeys.defaultLanguage,
      lemma: construct.lemma,
    );
    final LemmaInfoResponse res = await LemmaInfoRepo.get(lemmaDefReq);
    return res.meaning;
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).brightness != Brightness.light
        ? construct.lemmaCategory.color
        : construct.lemmaCategory.darkColor;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 42,
              child: emoji == null
                  ? Tooltip(
                      message: L10n.of(context).noEmojiSelectedTooltip,
                      child: Icon(
                        Icons.add_reaction_outlined,
                        size: 24,
                        color: textColor.withValues(alpha: 0.7),
                      ),
                    )
                  : Text(emoji!),
            ),
            const SizedBox(width: 10.0),
            Text(
              construct.lemma,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 10.0),
            WordAudioButton(
              text: construct.lemma,
              ttsController: TtsController(),
              size: 24,
            ),
            const SizedBox(width: 24),
          ],
        ),
        centerTitle: true,
        leading: SizedBox(
          width: 24,
          child: BackButton(onPressed: onClose),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Tooltip(
                    message: L10n.of(context).grammarCopyPOS,
                    child: Icon(
                      Symbols.toys_and_games,
                      size: 23,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    getGrammarCopy(
                          category: "pos",
                          lemma: construct.category,
                          context: context,
                        ) ??
                        construct.category,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: FutureBuilder(
                    future: getDefinition(context),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<String?> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        return RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: L10n.of(context).meaningSectionHeader,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              TextSpan(
                                text: "  ${snapshot.data!}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Wrap(
                          children: [
                            Text(
                              L10n.of(context).meaningSectionHeader,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: <TextSpan>[
                        TextSpan(
                          text: L10n.of(context).formSectionHeader,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "  ${formString ?? L10n.of(context).formsNotFound}",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  height: 3,
                  color: textColor.withValues(alpha: 0.7),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CustomizedSvg(
                      svgUrl: construct.lemmaCategory.svgURL,
                      colorReplacements: const {},
                      errorIcon: Text(
                        construct.lemmaCategory.emoji,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "${construct.points} XP",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LemmaUseExampleMessages(construct: construct),
              // Writing exercise section
              LemmaUsageDots(
                construct: construct,
                category: LearningSkillsEnum.writing,
                tooltip: L10n.of(context).writingExercisesTooltip,
                icon: Symbols.edit_square,
              ),
              // Listening exercise section
              LemmaUsageDots(
                construct: construct,
                category: LearningSkillsEnum.hearing,
                tooltip: L10n.of(context).listeningExercisesTooltip,
                icon: Symbols.hearing,
              ),
              // Reading exercise section
              LemmaUsageDots(
                construct: construct,
                category: LearningSkillsEnum.reading,
                tooltip: L10n.of(context).readingExercisesTooltip,
                icon: Symbols.two_pager,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LemmaUseExampleMessages extends StatelessWidget {
  final ConstructUses construct;

  const LemmaUseExampleMessages({
    super.key,
    required this.construct,
  });

  Future<List<ExampleMessage>> _getExampleMessages() async {
    final Set<ExampleMessage> examples = {};
    for (final OneConstructUse use in construct.uses) {
      if (use.useType.skillsEnumType != LearningSkillsEnum.writing ||
          use.metadata.eventId == null ||
          use.form == null ||
          use.pointValue <= 0) {
        continue;
      }
      final Room? room = MatrixState.pangeaController.matrixState.client
          .getRoomById(use.metadata.roomId);

      final Event? event = await room?.getEventById(use.metadata.eventId!);
      final String? messageText = event?.text;

      if (messageText != null && messageText.contains(use.form!)) {
        final int offset = messageText.indexOf(use.form!);
        examples.add(
          ExampleMessage(
            message: messageText,
            offset: offset,
            length: use.form!.length,
          ),
        );
        if (examples.length > 4) break;
      }
    }

    return examples.toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getExampleMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: snapshot.data!.map((e) {
                return Container(
                  decoration: BoxDecoration(
                    color: construct.lemmaCategory.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  constraints: const BoxConstraints(
                    maxWidth: FluffyThemes.columnWidth * 1.5,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                        fontSize: AppConfig.fontSizeFactor *
                            AppConfig.messageFontSize,
                      ),
                      children: [
                        TextSpan(text: e.message.substring(0, e.offset)),
                        TextSpan(
                          text: e.message
                              .substring(e.offset, e.offset + e.length),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: e.message.substring(e.offset + e.length),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          return const Column(
            children: [
              SizedBox(height: 10),
              CircularProgressIndicator.adaptive(
                strokeWidth: 2,
              ),
            ],
          );
        }
      },
    );
  }
}

class LemmaUsageDots extends StatelessWidget {
  final ConstructUses construct;
  final LearningSkillsEnum category;

  final String tooltip;
  final IconData icon;

  const LemmaUsageDots({
    required this.construct,
    required this.category,
    required this.tooltip,
    required this.icon,
    super.key,
  });

  /// Find lemma uses for the given exercise type, to create dot list
  List<bool> sortedUses(LearningSkillsEnum category) {
    final List<bool> useList = [];
    for (final OneConstructUse use in construct.uses) {
      if (use.useType.pointValue == 0) {
        continue;
      }
      // If the use type matches the given category, save to list
      // Usage with positive XP is saved as true, else false
      if (category == use.useType.skillsEnumType) {
        useList.add(use.useType.pointValue > 0);
      }
    }
    return useList;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> dots = [];
    for (final bool use in sortedUses(category)) {
      dots.add(
        Container(
          width: 15.0,
          height: 15.0,
          decoration: BoxDecoration(
            color: use ? AppConfig.success : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    final Color textColor = Theme.of(context).brightness != Brightness.light
        ? construct.lemmaCategory.color
        : construct.lemmaCategory.darkColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Tooltip(
            message: tooltip,
            child: Icon(
              icon,
              size: 24,
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Wrap(
              spacing: 3,
              runSpacing: 5,
              children: dots,
            ),
          ),
        ],
      ),
    );
  }
}

class ExampleMessage {
  final String message;
  final int offset;
  final int length;

  ExampleMessage({
    required this.message,
    required this.offset,
    required this.length,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExampleMessage &&
        other.message == message &&
        other.offset == offset &&
        other.length == length;
  }

  @override
  int get hashCode => message.hashCode ^ offset.hashCode ^ length.hashCode;
}
