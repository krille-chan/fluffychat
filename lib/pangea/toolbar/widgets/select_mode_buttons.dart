import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/audio_player.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/events/utils/report_message.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_audio_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum SelectMode {
  audio(Icons.volume_up),
  translate(Icons.translate),
  practice(Symbols.fitness_center),
  speechTranslation(Icons.translate);

  final IconData icon;
  const SelectMode(this.icon);

  String tooltip(BuildContext context) {
    final l10n = L10n.of(context);
    switch (this) {
      case SelectMode.audio:
        return l10n.playAudio;
      case SelectMode.translate:
      case SelectMode.speechTranslation:
        return l10n.translationTooltip;
      case SelectMode.practice:
        return l10n.practice;
    }
  }
}

enum MessageActions {
  reply,
  forward,
  edit,
  delete,
  copy,
  download,
  pin,
  report,
  info,
  deleteOnError,
  sendAgain;

  IconData get icon {
    switch (this) {
      case MessageActions.reply:
        return Icons.reply_all;
      case MessageActions.forward:
        return Symbols.forward;
      case MessageActions.edit:
        return Symbols.edit;
      case MessageActions.delete:
        return Symbols.delete;
      case MessageActions.copy:
        return Icons.copy_outlined;
      case MessageActions.download:
        return Symbols.download;
      case MessageActions.pin:
        return Symbols.push_pin;
      case MessageActions.report:
        return Icons.shield_outlined;
      case MessageActions.info:
        return Icons.info_outlined;
      case MessageActions.deleteOnError:
        return Icons.delete;
      case MessageActions.sendAgain:
        return Icons.send_outlined;
    }
  }

  String tooltip(BuildContext context) {
    final l10n = L10n.of(context);
    switch (this) {
      case MessageActions.reply:
        return l10n.reply;
      case MessageActions.forward:
        return l10n.forward;
      case MessageActions.edit:
        return l10n.edit;
      case MessageActions.delete:
        return l10n.redactMessage;
      case MessageActions.copy:
        return l10n.copy;
      case MessageActions.download:
        return l10n.download;
      case MessageActions.pin:
        return l10n.pinMessage;
      case MessageActions.report:
        return l10n.reportMessage;
      case MessageActions.info:
        return l10n.messageInfo;
      case MessageActions.deleteOnError:
        return l10n.delete;
      case MessageActions.sendAgain:
        return l10n.tryToSendAgain;
    }
  }
}

class SelectModeButtons extends StatefulWidget {
  final VoidCallback lauchPractice;
  final MessageOverlayController overlayController;
  final ChatController controller;

  const SelectModeButtons({
    required this.lauchPractice,
    required this.overlayController,
    required this.controller,
    super.key,
  });

  @override
  State<SelectModeButtons> createState() => SelectModeButtonsState();
}

class SelectModeButtonsState extends State<SelectModeButtons> {
  static const double iconWidth = 36.0;
  static const double buttonSize = 40.0;

  static List<SelectMode> get textModes => [
        SelectMode.audio,
        SelectMode.translate,
        SelectMode.practice,
      ];

  static List<SelectMode> get audioModes => [
        SelectMode.speechTranslation,
        // SelectMode.practice,
      ];

  SelectMode? _selectedMode;

  bool _isLoadingAudio = false;
  PangeaAudioFile? _audioBytes;
  File? _audioFile;
  String? _audioError;

  StreamSubscription? _onPlayerStateChanged;
  StreamSubscription? _onAudioPositionChanged;

  bool _isLoadingTranslation = false;
  String? _translationError;

  bool _isLoadingSpeechTranslation = false;
  String? _speechTranslationError;

  Completer<String>? _transcriptionCompleter;

  MatrixState? matrix;

  @override
  void initState() {
    super.initState();

    matrix = Matrix.of(context);
    if (messageEvent?.isAudioMessage == true) {
      _fetchTranscription();
    }
  }

  @override
  void dispose() {
    matrix?.audioPlayer?.dispose();
    matrix?.audioPlayer = null;
    matrix?.voiceMessageEventId.value = null;

    _onPlayerStateChanged?.cancel();
    _onAudioPositionChanged?.cancel();
    super.dispose();
  }

  PangeaMessageEvent? get messageEvent =>
      widget.overlayController.pangeaMessageEvent;

  String? get l1Code =>
      MatrixState.pangeaController.languageController.userL1?.langCodeShort;
  String? get l2Code =>
      MatrixState.pangeaController.languageController.userL2?.langCodeShort;

  void _clear() {
    setState(() {
      // Audio errors do not go away when I switch modes and back
      // Is there any reason to wipe error records on clear?
      _translationError = null;
      _speechTranslationError = null;
    });

    widget.overlayController.updateSelectedSpan(null);
    widget.overlayController.setShowTranslation(false);
    widget.overlayController.setShowSpeechTranslation(false);
  }

  Future<void> _updateMode(SelectMode? mode) async {
    _clear();

    if (mode == null) {
      setState(() {
        matrix?.audioPlayer?.stop();
        matrix?.audioPlayer?.seek(null);
        _selectedMode = null;
      });
      return;
    }

    setState(
      () => _selectedMode = _selectedMode == mode &&
              (mode != SelectMode.audio || _audioError != null)
          ? null
          : mode,
    );

    if (_selectedMode == SelectMode.audio) {
      _playAudio();
      return;
    } else {
      matrix?.audioPlayer?.stop();
      matrix?.audioPlayer?.seek(null);
    }

    if (_selectedMode == SelectMode.practice) {
      widget.lauchPractice();
      return;
    }

    if (_selectedMode == SelectMode.translate) {
      await _fetchTranslation();
      widget.overlayController.setShowTranslation(true);
    }

    if (_selectedMode == SelectMode.speechTranslation) {
      await _fetchSpeechTranslation();
      widget.overlayController.setShowSpeechTranslation(true);
    }
  }

  Future<void> _fetchAudio() async {
    if (!mounted || messageEvent == null) return;
    setState(() => _isLoadingAudio = true);

    try {
      final String langCode = messageEvent!.messageDisplayLangCode;
      final Event? localEvent = messageEvent!.getTextToSpeechLocal(
        langCode,
        messageEvent!.messageDisplayText,
      );

      if (localEvent != null) {
        _audioBytes = await localEvent.getPangeaAudioFile();
      } else {
        _audioBytes = await messageEvent!.getMatrixAudioFile(
          langCode,
        );
      }

      if (!kIsWeb) {
        final tempDir = await getTemporaryDirectory();

        File? file;
        file = File('${tempDir.path}/${_audioBytes!.name}');
        await file.writeAsBytes(_audioBytes!.bytes);
        _audioFile = file;
      }
    } catch (e, s) {
      _audioError = e.toString();
      ErrorHandler.logError(
        e: e,
        s: s,
        m: 'something wrong getting audio in MessageAudioCardState',
        data: {
          'widget.messageEvent.messageDisplayLangCode':
              messageEvent?.messageDisplayLangCode,
        },
      );
    } finally {
      if (mounted) setState(() => _isLoadingAudio = false);
    }
  }

  Future<void> _playAudio() async {
    final playerID =
        "${widget.overlayController.pangeaMessageEvent?.eventId}_button";

    if (matrix?.audioPlayer != null &&
        matrix?.voiceMessageEventId.value == playerID) {
      // If the audio player is already initialized and playing the same message, pause it
      if (matrix!.audioPlayer!.playerState.playing) {
        await matrix?.audioPlayer?.pause();
        return;
      }
      // If the audio player is paused, resume it
      await matrix?.audioPlayer?.play();
      return;
    }

    matrix?.audioPlayer?.dispose();
    matrix?.audioPlayer = AudioPlayer();
    matrix?.voiceMessageEventId.value =
        "${widget.overlayController.pangeaMessageEvent?.eventId}_button";

    _onPlayerStateChanged =
        matrix?.audioPlayer?.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _updateMode(null);
      }
      setState(() {});
    });

    _onAudioPositionChanged ??=
        matrix?.audioPlayer?.positionStream.listen((state) {
      if (_audioBytes?.tokens != null) {
        widget.overlayController.highlightCurrentText(
          state.inMilliseconds,
          _audioBytes!.tokens!,
        );
      }
    });

    try {
      if (matrix?.audioPlayer != null &&
          matrix!.audioPlayer!.playerState.playing) {
        await matrix?.audioPlayer?.pause();
        return;
      } else if (matrix?.audioPlayer?.position != Duration.zero) {
        TtsController.stop();
        await matrix?.audioPlayer?.play();
        return;
      }

      if (_audioBytes == null) {
        await _fetchAudio();
      }

      if (_audioBytes == null) return;

      if (_audioFile != null) {
        await matrix?.audioPlayer?.setFilePath(_audioFile!.path);
      } else {
        await matrix?.audioPlayer?.setAudioSource(
          BytesAudioSource(
            _audioBytes!.bytes,
            _audioBytes!.mimeType,
          ),
        );
      }

      TtsController.stop();
      await matrix?.audioPlayer?.play();
    } catch (e, s) {
      setState(() => _audioError = e.toString());
      ErrorHandler.logError(
        e: e,
        s: s,
        m: 'something wrong playing message audio',
        data: {
          'event': messageEvent?.event.toJson(),
        },
      );
    }
  }

  Future<void> _fetchTranslation() async {
    if (l1Code == null ||
        messageEvent == null ||
        widget.overlayController.translation != null) {
      return;
    }

    try {
      if (mounted) setState(() => _isLoadingTranslation = true);

      PangeaRepresentation? rep =
          messageEvent!.representationByLanguage(l1Code!)?.content;

      rep ??= await messageEvent?.representationByLanguageGlobal(
        langCode: l1Code!,
      );

      widget.overlayController.setTranslation(rep!.text);
    } catch (e, s) {
      _translationError = e.toString();
      ErrorHandler.logError(
        e: e,
        s: s,
        m: 'Error fetching translation',
        data: {
          'l1Code': l1Code,
          'messageEvent': messageEvent?.event.toJson(),
        },
      );
    } finally {
      if (mounted) setState(() => _isLoadingTranslation = false);
    }
  }

  Future<void> _fetchTranscription() async {
    try {
      if (_transcriptionCompleter != null) {
        // If a transcription is already in progress, wait for it to complete
        await _transcriptionCompleter!.future;
        return;
      }

      _transcriptionCompleter = Completer<String>();
      if (l1Code == null || messageEvent == null) {
        _transcriptionCompleter?.completeError(
          'Language code or message event is null',
        );
        return;
      }

      final resp = await messageEvent!.getSpeechToText(
        l1Code!,
        l2Code!,
      );

      widget.overlayController.setTranscription(resp!);
      _transcriptionCompleter?.complete(resp.transcript.text);
    } catch (err) {
      widget.overlayController.setTranscriptionError(
        err.toString(),
      );
      _transcriptionCompleter?.completeError(err);
      ErrorHandler.logError(
        e: err,
        data: {},
      );
    }
  }

  Future<void> _fetchSpeechTranslation() async {
    if (messageEvent == null ||
        l1Code == null ||
        l2Code == null ||
        widget.overlayController.speechTranslation != null) {
      return;
    }

    try {
      setState(() => _isLoadingSpeechTranslation = true);

      if (widget.overlayController.transcription == null) {
        await _fetchTranscription();
        if (widget.overlayController.transcription == null) {
          throw Exception('Transcription is null');
        }
      }

      final translation = await messageEvent!.sttTranslationByLanguageGlobal(
        langCode: l1Code!,
        l1Code: l1Code!,
        l2Code: l2Code!,
      );
      if (translation == null) {
        throw Exception('Translation is null');
      }

      widget.overlayController.setSpeechTranslation(translation.translation);
    } catch (err, s) {
      debugPrint("Error fetching speech translation: $err, $s");
      _speechTranslationError = err.toString();
      ErrorHandler.logError(
        e: err,
        data: {},
      );
    } finally {
      if (mounted) setState(() => _isLoadingSpeechTranslation = false);
    }
  }

  bool get _isError {
    switch (_selectedMode) {
      case SelectMode.audio:
        return _audioError != null;
      case SelectMode.translate:
        return _translationError != null;
      case SelectMode.speechTranslation:
        return _speechTranslationError != null;
      default:
        return false;
    }
  }

  bool get _isLoading {
    switch (_selectedMode) {
      case SelectMode.audio:
        return _isLoadingAudio;
      case SelectMode.translate:
        return _isLoadingTranslation;
      case SelectMode.speechTranslation:
        return _isLoadingSpeechTranslation;
      default:
        return false;
    }
  }

  Widget icon(SelectMode mode) {
    if (_isError && mode == _selectedMode) {
      return Icon(
        Icons.error_outline,
        size: 20,
        color: Theme.of(context).colorScheme.error,
      );
    }

    if (_isLoading && mode == _selectedMode) {
      return const Center(
        child: SizedBox(
          height: 20.0,
          width: 20.0,
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    if (mode == SelectMode.audio) {
      return Icon(
        matrix?.audioPlayer?.playerState.playing == true
            ? Icons.pause_outlined
            : Icons.volume_up,
        size: 20,
        color: mode == _selectedMode ? Colors.white : null,
      );
    }

    return Icon(
      mode.icon,
      size: 20,
      color: mode == _selectedMode ? Colors.white : null,
    );
  }

  bool _messageActionEnabled(MessageActions action) {
    if (messageEvent == null) return false;
    if (widget.controller.selectedEvents.isEmpty) return false;
    final events = widget.controller.selectedEvents;

    if (events.any((e) => !e.status.isSent)) {
      if (action == MessageActions.sendAgain) {
        return true;
      }

      if (events.every((e) => e.status.isError) &&
          action == MessageActions.deleteOnError) {
        return true;
      }

      return false;
    }

    switch (action) {
      case MessageActions.reply:
        return events.length == 1 &&
            widget.controller.room.canSendDefaultMessages;
      case MessageActions.edit:
        return widget.controller.canEditSelectedEvents &&
            !events.first.isActivityMessage &&
            events.single.messageType == MessageTypes.Text;
      case MessageActions.delete:
        return widget.controller.canRedactSelectedEvents;
      case MessageActions.copy:
        return events.length == 1 &&
            events.single.messageType == MessageTypes.Text;
      case MessageActions.download:
        return widget.controller.canSaveSelectedEvent;
      case MessageActions.pin:
        return widget.controller.canPinSelectedEvents;
      case MessageActions.forward:
      case MessageActions.report:
      case MessageActions.info:
        return events.length == 1;
      case MessageActions.deleteOnError:
      case MessageActions.sendAgain:
        return false;
    }
  }

  void _onActionPressed(MessageActions action) {
    switch (action) {
      case MessageActions.reply:
        widget.controller.replyAction();
        break;
      case MessageActions.forward:
        widget.controller.forwardEventsAction();
        break;
      case MessageActions.edit:
        widget.controller.editSelectedEventAction();
        break;
      case MessageActions.delete:
        widget.controller.redactEventsAction();
        break;
      case MessageActions.copy:
        widget.controller.copyEventsAction();
        break;
      case MessageActions.download:
        widget.controller.saveSelectedEvent(context);
        break;
      case MessageActions.pin:
        widget.controller.pinEvent();
        break;
      case MessageActions.report:
        final event = widget.controller.selectedEvents.first;
        widget.controller.clearSelectedEvents();
        reportEvent(
          event,
          widget.controller,
          widget.controller.context,
        );
        break;
      case MessageActions.info:
        widget.controller.showEventInfo();
        widget.controller.clearSelectedEvents();
        break;
      case MessageActions.deleteOnError:
        widget.controller.deleteErrorEventsAction();
        break;
      case MessageActions.sendAgain:
        widget.controller.sendAgainAction();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final modes = widget.overlayController.showLanguageAssistance
        ? messageEvent?.isAudioMessage == true
            ? audioModes
            : textModes
        : [];
    final actions = MessageActions.values.where(_messageActionEnabled);

    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: 250,
        constraints: const BoxConstraints(
          maxHeight: AppConfig.toolbarMenuHeight,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(
            AppConfig.borderRadius,
          ),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: modes.length + actions.length + 1,
          itemBuilder: (context, index) {
            if (index < modes.length) {
              final mode = modes[index];
              return SizedBox(
                height: 50.0,
                child: ListTile(
                  leading: Icon(mode.icon),
                  title: Text(mode.tooltip(context)),
                  onTap: () => _updateMode(mode),
                ),
              );
            } else if (index == modes.length) {
              return modes.isNotEmpty
                  ? const Divider(height: 1.0)
                  : const SizedBox();
            } else {
              final action = actions.elementAt(index - modes.length - 1);
              return SizedBox(
                height: 50.0,
                child: ListTile(
                  leading: Icon(action.icon),
                  title: Text(action.tooltip(context)),
                  onTap: () => _onActionPressed(action),
                ),
              );
            }
          },
        ),
      ),
    );

    // return SizedBox(
    //   width: 150,
    //   child: ListView.builder(
    //     itemCount: modes.length,
    //     itemBuilder: (context, index) {
    //       final mode = modes[index];
    //       return ListTile(
    //         leading: Icon(mode.icon),
    //         title: Text(mode.name),
    //         onTap: () {
    //           _updateMode(mode);
    //         },
    //       );
    //     },
    //   ),
    // );

    // return Row(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   mainAxisSize: MainAxisSize.min,
    //   spacing: 4.0,
    //   children: [
    //     for (final mode in modes)
    //       TooltipVisibility(
    //         visible: (!_isError || mode != _selectedMode),
    //         child: Tooltip(
    //           message: mode.tooltip(context),
    //           child: PressableButton(
    //             depressed: mode == _selectedMode,
    //             borderRadius: BorderRadius.circular(20),
    //             color: Theme.of(context).colorScheme.primaryContainer,
    //             onPressed: () => _updateMode(mode),
    //             playSound: mode != SelectMode.audio,
    //             colorFactor: Theme.of(context).brightness == Brightness.light
    //                 ? 0.55
    //                 : 0.3,
    //             child: Container(
    //               height: buttonSize,
    //               width: buttonSize,
    //               decoration: BoxDecoration(
    //                 color: Theme.of(context).colorScheme.primaryContainer,
    //                 shape: BoxShape.circle,
    //               ),
    //               child: icon(mode),
    //             ),
    //           ),
    //         ),
    //       ),
    //   ],
    // );
  }
}
