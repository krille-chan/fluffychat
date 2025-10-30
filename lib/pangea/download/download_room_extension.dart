// ignore_for_file: implementation_imports

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix/src/models/timeline_chunk.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/download/download_file_util.dart';
import 'package:fluffychat/pangea/download/download_type_enum.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';

class _EventDownloadInfo {
  final String sender;
  final DateTime timestamp;
  final String originalMsg;
  final String sentMsg;
  final bool usageAvailable;

  final bool includedIT;
  final bool includedIGC;

  _EventDownloadInfo({
    required this.sender,
    required this.timestamp,
    required this.originalMsg,
    required this.sentMsg,
    required this.usageAvailable,
    required this.includedIT,
    required this.includedIGC,
  });
}

class EmptyChatException implements Exception {}

extension DownloadExtension on Room {
  Future<void> download(
    DownloadType type,
    BuildContext context,
  ) async {
    List<PangeaMessageEvent> allPangeaMessages;

    final List<Event> allEvents = await getAllEvents();
    final TimelineChunk chunk = TimelineChunk(events: allEvents);
    final Timeline timeline = Timeline(
      room: this,
      chunk: chunk,
    );

    allPangeaMessages = getPangeaMessageEvents(
      allEvents,
      timeline,
    );

    if (allPangeaMessages.isEmpty) {
      throw EmptyChatException();
    }

    dynamic content;
    final List<_EventDownloadInfo> eventInfo = allPangeaMessages.map((message) {
      return _EventDownloadInfo(
        sender: message.senderId,
        timestamp: message.originServerTs,
        originalMsg: message.originalWrittenContent,
        sentMsg: message.originalSent?.text ?? message.body,
        usageAvailable: message.originalSent?.choreo != null,
        includedIT: message.originalSent?.choreo?.includedIT ?? false,
        includedIGC: message.originalSent?.choreo?.includedIGC ?? false,
      );
    }).toList();

    switch (type) {
      case DownloadType.txt:
        content = _getTxtContent(eventInfo, context);
      case DownloadType.csv:
        content = _getCSVContent(eventInfo, context);
      case DownloadType.xlsx:
        content = _getExcelContent(eventInfo, context);
    }
    DownloadUtil.downloadFile(content, _getFilename(type), type);
  }

  String _getFilename(DownloadType type) {
    final String roomName = getLocalizedDisplayname()
        .trim()
        .replaceAll(RegExp(r'[^A-Za-z0-9\s]'), "")
        .replaceAll(RegExp(r'\s+'), "-");

    final String timestamp =
        DateFormat('yyyy-MM-dd-hh:mm:ss').format(DateTime.now());

    return "$roomName-$timestamp.${type.extension}";
  }

  String _getTxtContent(
    List<_EventDownloadInfo> eventInfo,
    BuildContext context,
  ) {
    String formattedInfo = "";
    final l10n = L10n.of(context);
    for (final _EventDownloadInfo info in eventInfo) {
      final String timestamp =
          DateFormat('yyyy-MM-dd hh:mm:ss').format(info.timestamp);

      if (!info.usageAvailable) {
        formattedInfo +=
            "${l10n.sender}: ${info.sender}\n${l10n.time}: $timestamp\n${l10n.originalMessage}: ${info.originalMsg}\n${l10n.sentMessage}: ${info.sentMsg}\n${l10n.useType}: ${l10n.notAvailable}\n\n";
        continue;
      }

      formattedInfo +=
          "${l10n.sender}: ${info.sender}\n${l10n.time}: $timestamp\n${l10n.originalMessage}: ${info.originalMsg}\n${l10n.sentMessage}: ${info.sentMsg}\n${l10n.useType}: ";

      if (info.includedIT && info.includedIGC) {
        formattedInfo += l10n.taAndGaTooltip;
      } else if (info.includedIT) {
        formattedInfo += l10n.taTooltip;
      } else if (info.includedIGC) {
        formattedInfo += l10n.gaTooltip;
      } else {
        formattedInfo += l10n.waTooltip;
      }
      formattedInfo += "\n\n";
    }
    formattedInfo = "${getLocalizedDisplayname()}\n\n$formattedInfo";
    return formattedInfo;
  }

  String _getCSVContent(
    List<_EventDownloadInfo> eventInfo,
    BuildContext context,
  ) {
    final l10n = L10n.of(context);
    final List<List<String>> csvData = [
      [
        l10n.sender,
        l10n.time,
        l10n.originalMessage,
        l10n.sentMessage,
        l10n.taTooltip,
        l10n.gaTooltip,
      ]
    ];
    for (final _EventDownloadInfo info in eventInfo) {
      final String timestamp =
          DateFormat('yyyy-MM-dd hh:mm:ss').format(info.timestamp);

      if (!info.usageAvailable) {
        csvData.add([
          info.sender,
          timestamp,
          info.originalMsg,
          info.sentMsg,
          l10n.notAvailable,
          l10n.notAvailable,
        ]);
        continue;
      }

      csvData.add([
        info.sender,
        timestamp,
        info.originalMsg,
        info.sentMsg,
        info.includedIT.toString(),
        info.includedIGC.toString(),
      ]);
    }
    final String fileString = const ListToCsvConverter().convert(csvData);
    return fileString;
  }

  List<int> _getExcelContent(
    List<_EventDownloadInfo> eventInfo,
    BuildContext context,
  ) {
    final l10n = L10n.of(context);
    final excel = Excel.createExcel();
    final Sheet sheetObject = excel['Sheet1'];
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = TextCellValue(l10n.sender);
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
        .value = TextCellValue(l10n.time);
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
        .value = TextCellValue(l10n.originalMessage);
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
        .value = TextCellValue(l10n.sentMessage);
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
        .value = TextCellValue(l10n.taTooltip);
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0))
        .value = TextCellValue(l10n.gaTooltip);

    for (int i = 0; i < eventInfo.length; i++) {
      final _EventDownloadInfo info = eventInfo[i];

      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 2))
          .value = TextCellValue(info.sender);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 2))
          .value = DateTimeCellValue(
        year: info.timestamp.year,
        month: info.timestamp.month,
        day: info.timestamp.day,
        hour: info.timestamp.hour,
        minute: info.timestamp.minute,
        second: info.timestamp.second,
      );

      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 2))
          .value = TextCellValue(info.originalMsg);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 2))
          .value = TextCellValue(info.sentMsg);
      if (info.usageAvailable) {
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 2))
            .value = TextCellValue(info.includedIT.toString());
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i + 2))
            .value = TextCellValue(info.includedIGC.toString());
      }
    }

    final List<int>? bytes = excel.encode();
    return bytes ?? [];
  }
}
