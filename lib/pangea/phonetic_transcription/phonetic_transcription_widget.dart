import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_repo.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_request.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PhoneticTranscriptionWidget extends StatefulWidget {
  final String text;
  final LanguageModel textLanguage;

  final TextStyle? style;
  final double? iconSize;
  final Color? iconColor;

  final bool enabled;

  final VoidCallback? onTranscriptionFetched;

  const PhoneticTranscriptionWidget({
    super.key,
    required this.text,
    required this.textLanguage,
    this.style,
    this.iconSize,
    this.iconColor,
    this.enabled = true,
    this.onTranscriptionFetched,
  });

  @override
  State<PhoneticTranscriptionWidget> createState() =>
      _PhoneticTranscriptionWidgetState();
}

class _PhoneticTranscriptionWidgetState
    extends State<PhoneticTranscriptionWidget> {
  bool _isPlaying = false;
  bool _isLoading = false;
  Object? _error;

  String? _transcription;

  @override
  void initState() {
    super.initState();
    _fetchTranscription();
  }

  @override
  void didUpdateWidget(
    covariant PhoneticTranscriptionWidget oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.textLanguage != widget.textLanguage) {
      _fetchTranscription();
    }
  }

  Future<void> _fetchTranscription() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
        _transcription = null;
      });

      if (MatrixState.pangeaController.languageController.userL1 == null) {
        ErrorHandler.logError(
          e: Exception('User L1 is not set'),
          data: {
            'text': widget.text,
            'textLanguageCode': widget.textLanguage.langCode,
          },
        );
        _error = Exception('User L1 is not set');
        return;
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
      _transcription = res.phoneticTranscriptionResult.phoneticTranscription
          .first.phoneticL1Transcription.content;
    } catch (e, s) {
      _error = e;
      if (e is! UnsubscribedException) {
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {
            'text': widget.text,
            'textLanguageCode': widget.textLanguage.langCode,
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          widget.onTranscriptionFetched?.call();
        });
      }
    }
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
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: HoverBuilder(
        builder: (context, hovering) {
          return GestureDetector(
            onTap: () => _handleAudioTap(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: hovering
                    ? Colors.grey.withAlpha((0.2 * 255).round())
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_error != null)
                    _error is UnsubscribedException
                        ? ErrorIndicator(
                            message: L10n.of(context)
                                .subscribeToUnlockTranscriptions,
                            onTap: () {
                              MatrixState
                                  .pangeaController.subscriptionController
                                  .showPaywall(context);
                            },
                          )
                        : ErrorIndicator(
                            message:
                                L10n.of(context).failedToFetchTranscription,
                          )
                  else if (_isLoading || _transcription == null)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator.adaptive(),
                    )
                  else
                    Flexible(
                      child: Text(
                        _transcription!,
                        textScaler: TextScaler.noScaling,
                        style: widget.style ??
                            Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  if (_transcription != null &&
                      _error == null &&
                      widget.enabled)
                    const SizedBox(width: 8),
                  if (_transcription != null &&
                      _error == null &&
                      widget.enabled)
                    Tooltip(
                      message: _isPlaying
                          ? L10n.of(context).stop
                          : L10n.of(context).playAudio,
                      child: Icon(
                        _isPlaying ? Icons.pause_outlined : Icons.volume_up,
                        size: widget.iconSize ?? 24,
                        color: widget.iconColor ??
                            Theme.of(context).iconTheme.color,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
