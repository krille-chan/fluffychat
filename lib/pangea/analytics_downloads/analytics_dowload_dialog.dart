import 'package:flutter/material.dart';

import 'package:excel/excel.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/analytics_downloads/analytics_summary_enum.dart';
import 'package:fluffychat/pangea/analytics_downloads/analytics_summary_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';
import 'package:fluffychat/pangea/chat_settings/utils/download_file.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';

class AnalyticsDownloadDialog extends StatefulWidget {
  const AnalyticsDownloadDialog({
    super.key,
  });

  @override
  AnalyticsDownloadDialogState createState() => AnalyticsDownloadDialogState();
}

class AnalyticsDownloadDialogState extends State<AnalyticsDownloadDialog> {
  DownloadType _downloadType = DownloadType.csv;

  bool _downloading = false;
  bool _downloaded = false;
  String? _error;

  String? get _statusText {
    if (_downloading) return L10n.of(context).downloading;
    if (_downloaded) return L10n.of(context).downloadComplete;
    return null;
  }

  void _setDownloadType(DownloadType type) {
    if (mounted) setState(() => _downloadType = type);
  }

  Future<void> _downloadAnalytics() async {
    try {
      setState(() {
        _downloading = true;
        _downloaded = false;
        _error = null;
      });

      final vocabSummary = await _getVocabAnalytics();
      final morphSummary = await _getMorphAnalytics();

      final content = _getExcelFileContent({
        ConstructTypeEnum.vocab: vocabSummary,
        ConstructTypeEnum.morph: morphSummary,
      });

      final fileName =
          "analytics_${MatrixState.pangeaController.matrixState.client.userID?.localpart}_${DateTime.now().toIso8601String()}.${_downloadType == DownloadType.xlsx ? 'xlsx' : 'csv'}";

      await downloadFile(
        content,
        fileName,
        _downloadType,
      );
    } catch (e) {
      ErrorHandler.logError(
        e: e,
        data: {
          "downloadType": _downloadType,
        },
      );
      _error = e.toString();
    } finally {
      setState(() {
        _downloading = false;
        _downloaded = true;
      });
    }
  }

  Future<List<AnalyticsSummaryModel>> _getVocabAnalytics() async {
    final uses = MatrixState.pangeaController.getAnalytics.constructListModel
        .constructList(type: ConstructTypeEnum.vocab);
    final Map<String, List<ConstructUses>> lemmasToUses = {};
    for (final use in uses) {
      lemmasToUses[use.lemma] ??= [];
      lemmasToUses[use.lemma]!.add(use);
    }

    final List<AnalyticsSummaryModel> summaries = [];
    for (final entry in lemmasToUses.entries) {
      final lemma = entry.key;
      final uses = entry.value;

      final xp = uses.map((e) => e.points).reduce((a, total) => a + total);
      final exampleMessages = await _getExampleMessages(uses);
      final allUses = uses.map((u) => u.uses).expand((element) => element);

      int independantUseOccurrences = 0;
      int assistedUseOccurrences = 0;
      for (final use in allUses) {
        use.useType == ConstructUseTypeEnum.wa
            ? independantUseOccurrences++
            : assistedUseOccurrences++;
      }

      final forms = allUses
          .map((e) => e.form?.toLowerCase())
          .toSet()
          .whereType<String>()
          .toList();

      final summary = AnalyticsSummaryModel(
        lemma: lemma,
        xp: xp,
        forms: forms,
        exampleMessages: exampleMessages,
        independantUseOccurrences: independantUseOccurrences,
        assistedUseOccurrences: assistedUseOccurrences,
      );

      summaries.add(summary);
    }

    return summaries;
  }

  Future<List<AnalyticsSummaryModel>> _getMorphAnalytics() async {
    final constructListModel =
        MatrixState.pangeaController.getAnalytics.constructListModel;

    final morphs = await MorphsRepo.get();
    final List<AnalyticsSummaryModel> summaries = [];
    for (final feature in morphs.displayFeatures) {
      final allTags = morphs
          .getDisplayTags(feature.feature)
          .map((tag) => tag.toLowerCase())
          .toSet();

      for (final morphTag in allTags) {
        final id = ConstructIdentifier(
          lemma: morphTag,
          type: ConstructTypeEnum.morph,
          category: feature.feature,
        );

        final uses = constructListModel.getConstructUses(id);
        if (uses == null) continue;

        final xp = uses.points;
        final exampleMessages = await _getExampleMessages([uses]);
        final allUses = uses.uses;

        int independantUseOccurrences = 0;
        int assistedUseOccurrences = 0;
        for (final use in allUses) {
          use.useType == ConstructUseTypeEnum.wa
              ? independantUseOccurrences++
              : assistedUseOccurrences++;
        }

        final forms = allUses
            .map((e) => e.form?.toLowerCase())
            .toSet()
            .whereType<String>()
            .toList();

        final tagCopy = getGrammarCopy(
          category: feature.feature,
          lemma: morphTag,
          context: context,
        );

        final summary = AnalyticsSummaryModel(
          morphFeature: MorphFeaturesEnumExtension.fromString(feature.feature)
              .getDisplayCopy(context),
          morphTag: tagCopy,
          xp: xp,
          forms: forms,
          exampleMessages: exampleMessages,
          independantUseOccurrences: independantUseOccurrences,
          assistedUseOccurrences: assistedUseOccurrences,
        );

        summaries.add(summary);
      }
    }

    return summaries;
  }

  Future<List<String>> _getExampleMessages(
    List<ConstructUses> constructUses,
  ) async {
    final allUses = constructUses.map((e) => e.uses).expand((e) => e).toList();
    final List<PangeaMessageEvent> examples = [];
    for (final OneConstructUse use in allUses) {
      final Room? room = MatrixState.pangeaController.matrixState.client
          .getRoomById(use.metadata.roomId!);
      if (room == null) continue;

      if (use.useType.skillsEnumType != LearningSkillsEnum.writing ||
          use.metadata.eventId == null ||
          use.form == null ||
          use.xp <= 0) {
        continue;
      }

      final exampleIndex = examples.indexWhere(
        (example) => example.eventId == use.metadata.eventId!,
      );
      if (exampleIndex != -1) continue;
      if (use.metadata.roomId == null) continue;

      Timeline? timeline = room.timeline;
      if (room.timeline == null) {
        timeline = await room.getTimeline();
      }

      final Event? event = await room.getEventById(use.metadata.eventId!);

      if (event == null || event.senderId != room.client.userID) continue;
      final PangeaMessageEvent pangeaMessageEvent = PangeaMessageEvent(
        event: event,
        timeline: timeline!,
        ownMessage: event.senderId ==
            MatrixState.pangeaController.matrixState.client.userID,
      );
      examples.add(pangeaMessageEvent);
      if (examples.length >= 5) break;
    }

    return examples.map((m) => m.messageDisplayText).toSet().toList();
  }

  List<int> _getExcelFileContent(
    Map<ConstructTypeEnum, List<AnalyticsSummaryModel>> summaries,
  ) {
    final excel = Excel.createExcel();

    for (final entry in summaries.entries) {
      final sheet = excel[entry.key.sheetname(context)];
      final values = entry.key == ConstructTypeEnum.vocab
          ? AnalyticsSummaryEnum.vocabValues
          : AnalyticsSummaryEnum.morphValues;

      for (final key in values) {
        sheet
            .cell(
              CellIndex.indexByColumnRow(
                rowIndex: 0,
                columnIndex: values.indexOf(key),
              ),
            )
            .value = TextCellValue(key.header(context));
      }

      final rows = entry.value
          .map(
            (summary) => _formatExcelRow(
              summary,
              entry.key,
            ),
          )
          .toList();

      for (int i = 0; i < rows.length; i++) {
        final row = rows[i];
        for (int j = 0; j < row.length; j++) {
          final cell = row[j];
          sheet
              .cell(CellIndex.indexByColumnRow(rowIndex: i + 2, columnIndex: j))
              .value = cell;
        }
      }
    }

    excel.setDefaultSheet(ConstructTypeEnum.vocab.sheetname(context));
    excel.delete('Sheet1');
    return excel.encode() ?? [];
  }

  List<CellValue> _formatExcelRow(
    AnalyticsSummaryModel summary,
    ConstructTypeEnum type,
  ) {
    final List<CellValue> row = [];
    final values = type == ConstructTypeEnum.vocab
        ? AnalyticsSummaryEnum.vocabValues
        : AnalyticsSummaryEnum.morphValues;

    for (int i = 0; i < values.length; i++) {
      final key = values[i];
      final value = summary.getValue(key);
      if (value is int) {
        row.add(IntCellValue(value));
      } else if (value is String) {
        row.add(TextCellValue(value));
      } else if (value is List<String>) {
        row.add(TextCellValue(value.map((v) => "\"$v\"").join(", ")));
      }
    }
    return row;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              L10n.of(context).fileType,
              style: TextStyle(
                fontSize: AppConfig.fontSizeFactor * AppConfig.messageFontSize,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SegmentedButton<DownloadType>(
                selected: {_downloadType},
                onSelectionChanged: (c) => _setDownloadType(c.first),
                segments: [
                  ButtonSegment(
                    value: DownloadType.csv,
                    label: Text(L10n.of(context).commaSeparatedFile),
                  ),
                  ButtonSegment(
                    value: DownloadType.xlsx,
                    label: Text(L10n.of(context).excelFile),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
              child: OutlinedButton(
                onPressed: _downloading ? null : _downloadAnalytics,
                child: _downloading
                    ? const SizedBox(
                        height: 10,
                        width: 100,
                        child: LinearProgressIndicator(),
                      )
                    : Text(L10n.of(context).download),
              ),
            ),
            AnimatedSize(
              duration: FluffyThemes.animationDuration,
              child: _statusText != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_statusText!),
                    )
                  : const SizedBox(),
            ),
            AnimatedSize(
              duration: FluffyThemes.animationDuration,
              child: _error != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(L10n.of(context).oopsSomethingWentWrong),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
