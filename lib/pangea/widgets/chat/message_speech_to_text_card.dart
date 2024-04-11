import 'dart:developer';

import 'package:fluffychat/pangea/enum/audio_encoding_enum.dart';
import 'package:fluffychat/pangea/models/message_data_models.dart';
import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/speech_to_text_models.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class MessageSpeechToTextCard extends StatefulWidget {
  final PangeaMessageEvent messageEvent;

  const MessageSpeechToTextCard({
    super.key,
    required this.messageEvent,
  });

  @override
  MessageSpeechToTextCardState createState() => MessageSpeechToTextCardState();
}

enum AudioFileStatus { notDownloaded, downloading, downloaded }

class MessageSpeechToTextCardState extends State<MessageSpeechToTextCard> {
  PangeaRepresentation? repEvent;
  String? transcription;
  bool _fetchingTranscription = true;
  AudioFileStatus status = AudioFileStatus.notDownloaded;
  MatrixFile? matrixFile;
  // File? audioFile;

  String? get l1Code =>
      MatrixState.pangeaController.languageController.activeL1Code(
        roomID: widget.messageEvent.room.id,
      );
  String? get l2Code =>
      MatrixState.pangeaController.languageController.activeL2Code(
        roomID: widget.messageEvent.room.id,
      );

  // get transcription from local events
  Future<String> getLocalTranscription() async {
    return "This is a dummy transcription";
  }

  // This code is duplicated from audio_player.dart. Is there some way to reuse that code?
  Future<void> _downloadAction() async {
    // #Pangea
    // if (status != AudioFileStatus.notDownloaded) return;
    if (status != AudioFileStatus.notDownloaded) {
      return;
    }
    // Pangea#
    setState(() => status = AudioFileStatus.downloading);
    try {
      // #Pangea
      // final matrixFile = await widget.event.downloadAndDecryptAttachment();
      final matrixFile =
          await widget.messageEvent.event.downloadAndDecryptAttachment();
      // Pangea#
      // File? file;

      // TODO: Test on mobile and see if we need this case
      // if (!kIsWeb) {
      //   final tempDir = await getTemporaryDirectory();
      //   final fileName = Uri.encodeComponent(
      //     // #Pangea
      //     // widget.event.attachmentOrThumbnailMxcUrl()!.pathSegments.last,
      //     widget.messageEvent.event
      //         .attachmentOrThumbnailMxcUrl()!
      //         .pathSegments
      //         .last,
      //     // Pangea#
      //   );
      //   file = File('${tempDir.path}/${fileName}_${matrixFile.name}');
      //   await file.writeAsBytes(matrixFile.bytes);
      // }

      // audioFile = file;
      this.matrixFile = matrixFile;
      status = AudioFileStatus.downloaded;
    } catch (e, s) {
      Logs().v('Could not download audio file', e, s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toLocalizedString(context)),
        ),
      );
    }
  }

  AudioEncodingEnum? get encoding {
    if (matrixFile == null) return null;
    return mimeTypeToAudioEncoding(matrixFile!.mimeType);
  }

  // call API to transcribe audio
  Future<String?> transcribeAudio() async {
    await _downloadAction();

    final localmatrixFile = matrixFile;
    final info = matrixFile?.info;

    if (matrixFile == null) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: 'Audio file or matrix file is null ${widget.messageEvent.eventId}',
        s: StackTrace.current,
        data: widget.messageEvent.event.content,
      );
      return null;
    }

    if (l1Code == null || l2Code == null) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: 'Language codes are null ${widget.messageEvent.eventId}',
        s: StackTrace.current,
        data: widget.messageEvent.event.content,
      );
      return null;
    }

    final SpeechToTextResponseModel response =
        await MatrixState.pangeaController.speechToText.get(
      SpeechToTextRequestModel(
        audioContent: matrixFile!.bytes,
        config: SpeechToTextAudioConfigModel(
          encoding: encoding ?? AudioEncodingEnum.encodingUnspecified,
          //this is the default in the RecordConfig in record package
          sampleRateHertz: 44100,
          userL1: l1Code!,
          userL2: l2Code!,
        ),
      ),
    );
    return response.results.first.transcripts.first.transcript;
  }

  // look for transcription in message event
  // if not found, call API to transcribe audio
  Future<void> loadTranscription() async {
    // transcription ??= await getLocalTranscription();
    transcription ??= await transcribeAudio();
    setState(() => _fetchingTranscription = false);
  }

  @override
  void initState() {
    super.initState();
    loadTranscription();
  }

  @override
  Widget build(BuildContext context) {
    // if (!_fetchingTranscription && repEvent == null && transcription == null) {
    //   return const CardErrorWidget();
    // }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: _fetchingTranscription
          ? SizedBox(
              height: 14,
              width: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : transcription != null
              ? Text(
                  transcription!,
                  style: BotStyle.text(context),
                )
              : Text(
                  repEvent!.text,
                  style: BotStyle.text(context),
                ),
    );
  }
}
