import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/events/audio_player.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_audio_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum SelectMode {
  audio(Icons.volume_up),
  translate(Icons.translate),
  practice(Symbols.fitness_center);

  final IconData icon;
  const SelectMode(this.icon);

  String tooltip(BuildContext context) {
    final l10n = L10n.of(context);
    switch (this) {
      case SelectMode.audio:
        return l10n.playAudio;
      case SelectMode.translate:
        return l10n.translationTooltip;
      case SelectMode.practice:
        return l10n.practice;
    }
  }
}

class SelectModeButtons extends StatefulWidget {
  final VoidCallback lauchPractice;
  final MessageOverlayController overlayController;

  const SelectModeButtons({
    required this.lauchPractice,
    required this.overlayController,
    super.key,
  });

  @override
  State<SelectModeButtons> createState() => SelectModeButtonsState();
}

class SelectModeButtonsState extends State<SelectModeButtons> {
  static const double iconWidth = 36.0;
  static const double buttonSize = 40.0;

  SelectMode? _selectedMode;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isLoadingAudio = false;
  PangeaAudioFile? _audioFile;

  StreamSubscription? _onPlayerStateChanged;
  StreamSubscription? _onAudioPositionChanged;

  bool _isLoadingTranslation = false;
  PangeaRepresentation? _repEvent;

  @override
  void initState() {
    super.initState();
    _onPlayerStateChanged = _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _audioPlayer.stop();
        _audioPlayer.seek(null);
      }
      setState(() {});
    });
    _onAudioPositionChanged ??= _audioPlayer.positionStream.listen((state) {
      if (_audioFile != null) {
        widget.overlayController.highlightCurrentText(
          state.inMilliseconds,
          _audioFile!.tokens,
        );
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _onPlayerStateChanged?.cancel();
    _onAudioPositionChanged?.cancel();
    super.dispose();
  }

  PangeaMessageEvent? get messageEvent =>
      widget.overlayController.pangeaMessageEvent;

  String? get l1Code =>
      MatrixState.pangeaController.languageController.activeL1Code();
  String? get l2Code =>
      MatrixState.pangeaController.languageController.activeL2Code();

  Future<void> _updateMode(SelectMode mode) async {
    widget.overlayController.updateSelectedSpan(null);

    if (_selectedMode == SelectMode.translate) {
      widget.overlayController.setShowTranslation(false, null);
      await Future.delayed(FluffyThemes.animationDuration);
    }

    setState(
      () => _selectedMode =
          _selectedMode == mode && mode != SelectMode.audio ? null : mode,
    );

    if (_selectedMode == SelectMode.audio) {
      _playAudio();
      return;
    } else {
      _audioPlayer.stop();
      _audioPlayer.seek(null);
    }

    if (_selectedMode == SelectMode.practice) {
      widget.lauchPractice();
      return;
    }

    if (_selectedMode == SelectMode.translate) {
      await _loadTranslation();
      if (_repEvent == null) return;
      widget.overlayController.setShowTranslation(
        true,
        _repEvent!.text,
      );
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
        _audioFile = await localEvent.getPangeaAudioFile();
      } else {
        _audioFile = await messageEvent!.getMatrixAudioFile(
          langCode,
        );
      }

      if (mounted) setState(() => _isLoadingAudio = false);
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        m: 'something wrong getting audio in MessageAudioCardState',
        data: {
          'widget.messageEvent.messageDisplayLangCode':
              messageEvent?.messageDisplayLangCode,
        },
      );
      if (mounted) setState(() => _isLoadingAudio = false);
    }
  }

  Future<void> _playAudio() async {
    if (_audioPlayer.playerState.playing) {
      await _audioPlayer.pause();
      return;
    } else if (_audioPlayer.position != Duration.zero) {
      await _audioPlayer.play();
      return;
    }

    if (_audioFile == null) {
      await _fetchAudio();
    }

    if (_audioFile == null) return;
    await _audioPlayer.setAudioSource(
      BytesAudioSource(
        _audioFile!.bytes,
        _audioFile!.mimeType,
      ),
    );
    _audioPlayer.play();
  }

  Future<void> _fetchRepresentation() async {
    if (l1Code == null || messageEvent == null || _repEvent != null) {
      return;
    }

    _repEvent = messageEvent!.representationByLanguage(l1Code!)?.content;
    if (_repEvent == null && mounted) {
      _repEvent = await messageEvent?.representationByLanguageGlobal(
        langCode: l1Code!,
      );
    }
  }

  Future<void> _loadTranslation() async {
    if (!mounted) return;
    setState(() => _isLoadingTranslation = true);

    try {
      await _fetchRepresentation();
    } catch (err) {
      ErrorHandler.logError(
        e: err,
        data: {},
      );
    }

    if (mounted) {
      setState(() => _isLoadingTranslation = false);
    }
  }

  Widget icon(SelectMode mode) {
    if (mode == SelectMode.audio) {
      if (_isLoadingAudio) {
        return const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator.adaptive(),
        );
      } else {
        return Icon(
          _audioPlayer.playerState.playing == true
              ? Icons.pause_outlined
              : Icons.play_arrow,
          size: 20,
          color: mode == _selectedMode ? Colors.white : null,
        );
      }
    }

    if (mode == SelectMode.translate) {
      if (_isLoadingTranslation) {
        return const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator.adaptive(),
        );
      } else if (_repEvent != null) {
        return Icon(
          mode.icon,
          size: 20,
          color: mode == _selectedMode ? Colors.white : null,
        );
      }
    }

    return Icon(
      mode.icon,
      size: 20,
      color: mode == _selectedMode ? Colors.white : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConfig.toolbarButtonsHeight,
      alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 4.0,
        children: [
          for (final mode in SelectMode.values)
            Tooltip(
              message: mode.tooltip(context),
              child: PressableButton(
                depressed: mode == _selectedMode,
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primaryContainer,
                onPressed: () => _updateMode(mode),
                playSound: true,
                child: Container(
                  height: buttonSize,
                  width: buttonSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: icon(mode),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
