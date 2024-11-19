import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl/intl.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix/src/models/timeline_chunk.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart' as webFile;

import '../models/choreo_record.dart';

enum DownloadType { txt, csv, xlsx }

Future<void> downloadChat(
  Room room,
  DownloadType type,
  BuildContext context,
) async {
  List<PangeaMessageEvent> allPangeaMessages;

  try {
    final List<Event> allEvents = await getAllEvents(room);
    final TimelineChunk chunk = TimelineChunk(events: allEvents);
    final Timeline timeline = Timeline(
      room: room,
      chunk: chunk,
    );

    allPangeaMessages = getPangeaMessageEvents(
      allEvents,
      timeline,
      room,
    );
  } catch (err, s) {
    ErrorHandler.logError(e: err, s: s);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${L10n.of(context)!.oopsSomethingWentWrong} ${L10n.of(context)!.errorPleaseRefresh}",
        ),
      ),
    );
    return;
  }

  if (allPangeaMessages.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          L10n.of(context)!.emptyChatDownloadWarning,
        ),
      ),
    );
    return;
  }

  final String filename = getFilename(room, type);

  switch (type) {
    case DownloadType.txt:
      final String content =
          getTxtContent(allPangeaMessages, context, filename, room);
      downloadFile(content, filename, DownloadType.txt);
      break;
    case DownloadType.csv:
      final String content =
          getCSVContent(allPangeaMessages, context, filename);
      downloadFile(content, filename, DownloadType.csv);
      return;
    case DownloadType.xlsx:
      final List<int> content =
          getExcelContent(allPangeaMessages, context, filename);
      downloadFile(content, filename, DownloadType.xlsx);
      return;
  }
}

Future<List<Event>> getAllEvents(Room room) async {
  final GetRoomEventsResponse initalResp =
      await room.client.getRoomEvents(room.id, Direction.b);
  if (initalResp.end == null) return [];
  String? nextStartToken = initalResp.end;
  List<MatrixEvent> allMatrixEvents = initalResp.chunk;
  while (nextStartToken != null) {
    final GetRoomEventsResponse resp = await room.client.getRoomEvents(
      room.id,
      Direction.b,
      from: nextStartToken,
    );
    final chunkMessages = resp.chunk;
    allMatrixEvents.addAll(chunkMessages);
    resp.end != nextStartToken
        ? nextStartToken = resp.end
        : nextStartToken = null;
  }
  allMatrixEvents = allMatrixEvents.reversed.toList();
  final List<Event> allEvents = allMatrixEvents
      .map((MatrixEvent message) => Event.fromMatrixEvent(message, room))
      .toList();
  return allEvents;
}

List<PangeaMessageEvent> getPangeaMessageEvents(
  List<Event> events,
  Timeline timeline,
  Room room,
) {
  final List<PangeaMessageEvent> allPangeaMessages = events
      .where(
        (Event event) =>
            event.type == EventTypes.Message &&
            event.content['msgtype'] == MessageTypes.Text,
      )
      .map(
        (Event message) => PangeaMessageEvent(
          event: message,
          timeline: timeline,
          ownMessage: false,
        ),
      )
      .cast<PangeaMessageEvent>()
      .toList();
  return allPangeaMessages;
}

String getOriginalText(PangeaMessageEvent message) {
  try {
    final List<ChoreoRecordStep>? steps =
        message.originalSent?.choreo?.choreoSteps;
    if (steps != null && steps.isNotEmpty) return steps.first.text;
    if (message.originalWritten != null) return message.originalWritten!.text;
    if (message.originalSent != null) return message.originalSent!.text;
    return message.body;
  } catch (err) {
    return message.body;
  }
}

String getSentText(PangeaMessageEvent message) =>
    message.originalSent?.text ?? message.body;

bool usageIsAvailable(PangeaMessageEvent message) {
  try {
    return message.originalSent?.choreo != null;
  } catch (err) {
    return false;
  }
}

String getFilename(Room room, DownloadType type) {
  final String roomName = room
      .getLocalizedDisplayname()
      .trim()
      .replaceAll(RegExp(r'[^A-Za-z0-9\s]'), "")
      .replaceAll(RegExp(r'\s+'), "-");
  final String timestamp =
      DateFormat('yyyy-MM-dd-hh:mm:ss').format(DateTime.now());
  final String extension = type == DownloadType.txt
      ? 'txt'
      : type == DownloadType.csv
          ? 'csv'
          : 'xlsx';
  return "$roomName-$timestamp.$extension";
}

String mimetype(DownloadType fileType) {
  switch (fileType) {
    case DownloadType.txt:
      return 'text/plain';
    case DownloadType.csv:
      return 'text/csv';
    case DownloadType.xlsx:
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
  }
}

Future<void> downloadFile(
  contents,
  String filename,
  DownloadType fileType,
) async {
  if (kIsWeb) {
    final blob = webFile.Blob([contents], mimetype(fileType), 'native');
    webFile.AnchorElement(
      href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
    )
      ..setAttribute("download", filename)
      ..click();
    return;
  }
  if (await Permission.storage.request().isGranted) {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err, s) {
      debugPrint("Failed to get download folder path");
      ErrorHandler.logError(e: err, s: s);
    }
    if (directory != null) {
      final File f = File("${directory.path}/$filename");
      File resp;
      if (fileType == DownloadType.txt || fileType == DownloadType.csv) {
        resp = await f.writeAsString(contents);
      } else {
        resp = await f.writeAsBytes(contents);
      }
      OpenFile.open(resp.path);
    }
  }
}

String getTxtContent(
  List<PangeaMessageEvent> messages,
  BuildContext context,
  String filename,
  Room room,
) {
  String formattedInfo = "";
  for (final PangeaMessageEvent message in messages) {
    final String timestamp =
        DateFormat('yyyy-MM-dd hh:mm:ss').format(message.originServerTs);
    final String sender = message.senderId;
    final String originalMsg = getOriginalText(message);
    final String sentMsg = getSentText(message);
    final bool usageAvailable = usageIsAvailable(message);

    if (!usageAvailable) {
      formattedInfo +=
          "${L10n.of(context)!.sender}: $sender\n${L10n.of(context)!.time}: $timestamp\n${L10n.of(context)!.originalMessage}: $originalMsg\n${L10n.of(context)!.sentMessage}: $sentMsg\n${L10n.of(context)!.useType}: ${L10n.of(context)!.notAvailable}\n\n";
      continue;
    }

    final bool includedIT = message.originalSent!.choreo!.includedIT;
    final bool includedIGC = message.originalSent!.choreo!.includedIGC;

    formattedInfo +=
        "${L10n.of(context)!.sender}: $sender\n${L10n.of(context)!.time}: $timestamp\n${L10n.of(context)!.originalMessage}: $originalMsg\n${L10n.of(context)!.sentMessage}: $sentMsg\n${L10n.of(context)!.useType}: ";
    if (includedIT && includedIGC) {
      formattedInfo += L10n.of(context)!.taAndGaTooltip;
    } else if (includedIT) {
      formattedInfo += L10n.of(context)!.taTooltip;
    } else if (includedIGC) {
      formattedInfo += L10n.of(context)!.gaTooltip;
    } else {
      formattedInfo += L10n.of(context)!.waTooltip;
    }
    formattedInfo += "\n\n";
  }
  formattedInfo = "${room.getLocalizedDisplayname()}\n\n$formattedInfo";
  return formattedInfo;
}

String getCSVContent(
  List<PangeaMessageEvent> messages,
  BuildContext context,
  String fileName,
) {
  final List<List<String>> csvData = [
    [
      L10n.of(context)!.sender,
      L10n.of(context)!.time,
      L10n.of(context)!.originalMessage,
      L10n.of(context)!.sentMessage,
      L10n.of(context)!.taTooltip,
      L10n.of(context)!.gaTooltip,
    ]
  ];
  for (final PangeaMessageEvent message in messages) {
    final String timestamp =
        DateFormat('yyyy-MM-dd hh:mm:ss').format(message.originServerTs);
    final String sender = message.senderId;
    final String originalMsg = getOriginalText(message);
    final String sentMsg = getSentText(message);
    final bool usageAvailable = usageIsAvailable(message);

    if (!usageAvailable) {
      csvData.add([
        sender,
        timestamp,
        originalMsg,
        sentMsg,
        L10n.of(context)!.notAvailable,
        L10n.of(context)!.notAvailable,
      ]);
      continue;
    }

    final bool includedIT = message.originalSent!.choreo!.includedIT;
    final bool includedIGC = message.originalSent!.choreo!.includedIGC;

    csvData.add([
      sender,
      timestamp,
      originalMsg,
      sentMsg,
      includedIT.toString(),
      includedIGC.toString(),
    ]);
  }
  final String fileString = const ListToCsvConverter().convert(csvData);
  return fileString;
}

List<int> getExcelContent(
  List<PangeaMessageEvent> messages,
  BuildContext context,
  String filename,
) {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByIndex(1, 1).setValue(L10n.of(context)!.sender);
  sheet.getRangeByIndex(1, 2).setValue(L10n.of(context)!.time);
  sheet.getRangeByIndex(1, 3).setValue(L10n.of(context)!.originalMessage);
  sheet.getRangeByIndex(1, 4).setValue(L10n.of(context)!.sentMessage);
  sheet.getRangeByIndex(1, 5).setValue(L10n.of(context)!.taTooltip);
  sheet.getRangeByIndex(1, 6).setValue(L10n.of(context)!.gaTooltip);

  for (int i = 0; i < messages.length; i++) {
    final PangeaMessageEvent message = messages[i];
    final String sender = message.senderId;
    final String originalMsg = getOriginalText(message);
    final String sentMsg = getSentText(message);
    final bool usageAvailable = usageIsAvailable(message);

    bool includedIT = false;
    bool includedIGC = false;

    if (usageAvailable) {
      includedIT = message.originalSent!.choreo!.includedIT;
      includedIGC = message.originalSent!.choreo!.includedIGC;
    }

    sheet.getRangeByIndex(i + 2, 1).setValue(sender);
    sheet.getRangeByIndex(i + 2, 2).setDateTime(message.originServerTs);
    sheet.getRangeByIndex(i + 2, 3).setValue(originalMsg);
    sheet.getRangeByIndex(i + 2, 4).setValue(sentMsg);
    sheet.getRangeByIndex(i + 2, 5).setValue(L10n.of(context)!.notAvailable);
    sheet.getRangeByIndex(i + 2, 6).setValue(L10n.of(context)!.notAvailable);
    if (usageAvailable) {
      sheet.getRangeByIndex(i + 2, 5).setValue(includedIT);
      sheet.getRangeByIndex(i + 2, 6).setValue(includedIGC);
    }
  }

  final List<int> bytes = workbook.saveAsStream();
  return bytes;
}
