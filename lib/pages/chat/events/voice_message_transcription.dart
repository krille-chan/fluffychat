// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/stt/stt_manager.dart';
import 'package:fluffychat/utils/stt/transcription_cache.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../../widgets/matrix.dart';

/// Renders the "Transcribe" button and the resulting transcript beneath a
/// voice message bubble. Reads/writes the shared [SttManager] cache. The button
/// is disabled while the STT engine is busy (model download / load); the
/// detailed download progress lives in the settings, not on every message.
class VoiceMessageTranscription extends StatelessWidget {
  final Event event;
  final Color color;
  final double fontSize;

  const VoiceMessageTranscription({
    required this.event,
    required this.color,
    required this.fontSize,
    super.key,
  });

  ButtonStyle get _buttonStyle => TextButton.styleFrom(
    foregroundColor: color,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    minimumSize: const Size(0, 0),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    textStyle: TextStyle(fontSize: fontSize - 1),
  );

  @override
  Widget build(BuildContext context) {
    final stt = Matrix.of(context).stt;
    return ValueListenableBuilder<Map<String, TranscriptionEntry>>(
      valueListenable: stt.cache,
      builder: (context, entries, _) {
        final entry = entries[event.eventId];
        final featureAvailable = stt.isFeatureAvailable;
        final hasContent =
            entry != null && entry.status != TranscriptionStatus.idle;
        if (!featureAvailable && !hasContent) {
          return const SizedBox.shrink();
        }
        return ValueListenableBuilder<bool>(
          valueListenable: stt.isBusy,
          builder: (context, busy, _) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 4.0,
                bottom: 8.0,
              ),
              child: _Body(
                event: event,
                stt: stt,
                entry: entry,
                busy: busy,
                color: color,
                buttonStyle: _buttonStyle,
                fontSize: fontSize,
              ),
            );
          },
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  final Event event;
  final SttManager stt;
  final TranscriptionEntry? entry;
  final bool busy;
  final Color color;
  final ButtonStyle buttonStyle;
  final double fontSize;

  const _Body({
    required this.event,
    required this.stt,
    required this.entry,
    required this.busy,
    required this.color,
    required this.buttonStyle,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final status = entry?.status ?? TranscriptionStatus.idle;
    final progress = entry?.progress;
    final model = entry?.model;
    final modelSuffix = (model != null && model.isNotEmpty) ? ' ($model)' : '';
    final smallStyle = TextStyle(color: color, fontSize: fontSize - 2);
    final dimStyle = TextStyle(
      color: color.withAlpha(180),
      fontSize: fontSize - 2,
    );
    return switch (status) {
      TranscriptionStatus.loading || TranscriptionStatus.preparing => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: progress,
                color: color,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                progress != null && progress > 0
                    ? '${l10n.transcribingVoiceMessage} ${(progress * 100).round()}%'
                    : l10n.transcribingVoiceMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: smallStyle,
              ),
            ),
          ],
        ),
      ),
      TranscriptionStatus.ready => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withAlpha(40)),
            ),
            child: SelectableText(
              entry?.text ?? '',
              style: TextStyle(
                color: color,
                fontSize: fontSize - 1,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.phone_iphone, size: 12, color: color.withAlpha(160)),
              const SizedBox(width: 4),
              Text(
                '${l10n.sttProviderOnDevice}$modelSuffix',
                style: TextStyle(
                  color: color.withAlpha(160),
                  fontSize: fontSize - 4,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => stt.transcribeEvent(event),
                style: buttonStyle,
                child: Text(l10n.retry),
              ),
            ],
          ),
        ],
      ),
      TranscriptionStatus.error => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(Icons.error_outline, size: 16, color: color.withAlpha(180)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.sttTranscriptionError,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: dimStyle,
              ),
            ),
            TextButton(
              onPressed: () => stt.transcribeEvent(event),
              style: buttonStyle,
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
      TranscriptionStatus.idle => Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: busy ? null : () => stt.transcribeEvent(event),
          icon: const Icon(Icons.subtitles_outlined, size: 18),
          label: Text(l10n.transcribeVoiceMessage),
          style: buttonStyle,
        ),
      ),
    };
  }
}
