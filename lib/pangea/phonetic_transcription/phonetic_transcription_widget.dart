import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_repo.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_request.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PhoneticTranscriptionWidget extends StatefulWidget {
  final String text;
  final LanguageModel textLanguage;
  final TextStyle? style;
  final double? iconSize;

  const PhoneticTranscriptionWidget({
    super.key,
    required this.text,
    required this.textLanguage,
    this.style,
    this.iconSize,
  });

  @override
  State<PhoneticTranscriptionWidget> createState() =>
      _PhoneticTranscriptionWidgetState();
}

class _PhoneticTranscriptionWidgetState
    extends State<PhoneticTranscriptionWidget> {
  late Future<String?> _transcriptionFuture;
  bool _hovering = false;
  bool _isPlaying = false;
  bool _isLoading = false;
  late final StreamSubscription _loadingChoreoSubscription;

  @override
  void initState() {
    super.initState();
    _transcriptionFuture = _fetchTranscription();
    _loadingChoreoSubscription =
        TtsController.loadingChoreoStream.stream.listen((val) {
      if (mounted) setState(() => _isLoading = val);
    });
  }

  @override
  void dispose() {
    TtsController.stop();
    _loadingChoreoSubscription.cancel();
    super.dispose();
  }

  Future<String?> _fetchTranscription() async {
    if (MatrixState.pangeaController.languageController.userL1 == null) {
      ErrorHandler.logError(
        e: Exception('User L1 is not set'),
        data: {
          'text': widget.text,
          'textLanguageCode': widget.textLanguage.langCode,
        },
      );
      return widget.text; // Fallback to original text if no L1 is set
    }
    final req = PhoneticTranscriptionRequest(
      arc: LanguageArc(
        l1: MatrixState.pangeaController.languageController.userL1!,
        l2: widget.textLanguage,
      ),
      content: PangeaTokenText.fromString(widget.text),
      // arc can be omitted for default empty map
    );
    final res = await PhoneticTranscriptionRepo.get(req);
    return res.phoneticTranscriptionResult.phoneticTranscription.first
        .phoneticL1Transcription.content;
  }

  Future<void> _handleAudioTap(BuildContext context) async {
    if (_isPlaying) {
      await TtsController.stop();
      setState(() => _isPlaying = false);
    } else {
      await TtsController.tryToSpeak(
        widget.text,
        context: context,
        targetID: 'phonetic-transcription-${widget.text}',
        langCode: widget.textLanguage.langCode,
        onStart: () {
          if (mounted) setState(() => _isPlaying = true);
        },
        onStop: () {
          if (mounted) setState(() => _isPlaying = false);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _transcriptionFuture,
      builder: (context, snapshot) {
        final transcription = snapshot.data ?? '';
        return MouseRegion(
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: GestureDetector(
            onTap: () => _handleAudioTap(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: _hovering
                    ? Colors.grey.withAlpha((0.2 * 255).round())
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      "/${transcription.isNotEmpty ? transcription : widget.text}/",
                      style: widget.style ??
                          Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Tooltip(
                    message: _isPlaying
                        ? L10n.of(context).stop
                        : L10n.of(context).playAudio,
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                        : Icon(
                            _isPlaying ? Icons.pause_outlined : Icons.volume_up,
                            size: widget.iconSize ?? 24,
                            color: _isPlaying
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).iconTheme.color,
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
