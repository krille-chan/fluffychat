import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluffychat/l10n/l10n.dart';

class AudioPlayerStreaming extends StatefulWidget {
  const AudioPlayerStreaming({super.key});

  @override
  State<AudioPlayerStreaming> createState() => _AudioPlayerStreamingState();
}

class _AudioPlayerStreamingState extends State<AudioPlayerStreaming> {
  final player = AudioPlayer();

  double volume = 0.0;
  double _lastNonZeroVolume = 0.8;
  bool _everPlayed = false;

  String title = 'Carregando...';
  String artist = '';
  String artUrl = '';
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  Timer? _fetchMetadataTimer;
  Timer? _progressTimer;
  bool _isLoadingMetadata = false;
  String? _lastSongTitle;

  VoidCallback? _muteListener;

  static const double _artSize = 70.0;
  static const double _buttonSize = 40.0;
  static const double _volumeIconSize = 20.0;
  static const double _paddingValue = 15.0;
  static const double _borderRadius = 12.0;

  @override
  void initState() {
    super.initState();
    _initAudio();
    _fetchNowPlaying();
    _fetchMetadataTimer =
        Timer.periodic(const Duration(seconds: 10), (_) => _fetchNowPlaying());
    _startProgressTimer();

    _muteListener = () async {
      final muted = AudioState.mutedNotifier.value;
      if (muted) {
        await player.setVolume(0.0);
      } else {
        await player
            .setVolume(_lastNonZeroVolume > 0 ? _lastNonZeroVolume : 0.8);
      }
      if (!_everPlayed) {
        await player.play();
        _everPlayed = true;
      }
      if (mounted) setState(() {});
    };

    AudioState.mutedNotifier.addListener(_muteListener!);
  }

  void _initAudio() async {
    await player.setUrl(dotenv.env['AUDIO_PLAYER_URL'] ?? '');
    await player.setVolume(0.0);
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (duration.inSeconds > 0 && position.inSeconds < duration.inSeconds) {
        setState(() => position += const Duration(seconds: 1));
      }
    });
  }

  Future<void> _fetchNowPlaying() async {
    if (_isLoadingMetadata) return;
    setState(() => _isLoadingMetadata = true);

    try {
      final response = await http.get(
        Uri.parse(dotenv.env['NOW_PLAYING_URL'] ?? ''),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final nowPlaying = data['now_playing'];
        if (nowPlaying != null) {
          final newTitle =
              nowPlaying['song']['title'] ?? L10n.of(context).untitled;
          final newArtist =
              nowPlaying['song']['artist'] ?? L10n.of(context).unknownArtist;
          final newArtUrl = nowPlaying['song']['art'] ?? '';
          final newDuration = Duration(
            seconds: (nowPlaying['duration'] ?? 0).clamp(0, 3600),
          );
          final newElapsed = Duration(seconds: nowPlaying['elapsed'] ?? 0);

          final songChanged = newTitle != _lastSongTitle;
          final elapsedWentBack = newElapsed < position;

          setState(() {
            title = newTitle;
            artist = newArtist;
            artUrl = newArtUrl;
            duration = newDuration;
            if (songChanged || elapsedWentBack || newElapsed.inSeconds == 0) {
              position = newElapsed;
              _lastSongTitle = newTitle;
            }
          });
        }
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoadingMetadata = false);
    }
  }

  @override
  void dispose() {
    _fetchMetadataTimer?.cancel();
    _progressTimer?.cancel();
    if (_muteListener != null) {
      AudioState.mutedNotifier.removeListener(_muteListener!);
    }
    player.dispose();
    super.dispose();
  }

  String _formatTime(Duration d) {
    final minutes = d.inMinutes;
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        border: Border.all(color: theme.colorScheme.secondary),
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_paddingValue),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMetadataRow(theme),
            const SizedBox(height: 15),
            _buildProgressBar(theme, theme.colorScheme.primary),
            const SizedBox(height: 4),
            _buildTimeLabels(),
            const SizedBox(height: 5),
            ValueListenableBuilder<bool>(
              valueListenable: AudioState.mutedNotifier,
              builder: (context, isMuted, _) {
                final volumeIcon = (isMuted || volume == 0)
                    ? Icons.volume_off
                    : volume > 0.5
                        ? Icons.volume_up
                        : Icons.volume_down;

                return Row(
                  children: [
                    SizedBox(
                      width: _buttonSize,
                      height: _buttonSize,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          side: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () async {
                          final isMuted = AudioState.mutedNotifier.value;

                          if (isMuted || volume == 0) {
                            if (!isMuted && volume == 0) {
                              final v = _lastNonZeroVolume > 0
                                  ? _lastNonZeroVolume
                                  : 0.8;
                              volume = v;
                              await player.setVolume(v);
                              await player.play();
                              _everPlayed = true;
                              setState(() {});
                            } else {
                              AudioState.mutedNotifier.value = false;
                            }
                          } else {
                            _lastNonZeroVolume =
                                volume > 0 ? volume : _lastNonZeroVolume;
                            AudioState.mutedNotifier.value = true;
                          }
                        },
                        child: Icon(
                          volumeIcon,
                          color: theme.colorScheme.primary,
                          size: _volumeIconSize,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: theme.colorScheme.onTertiary,
                          inactiveTrackColor: theme.colorScheme.onTertiary,
                          thumbColor: theme.colorScheme.primary,
                          overlayColor:
                              theme.colorScheme.primary.withValues(alpha: 0.2),
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 12),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),
                        ),
                        child: Slider(
                          value: volume,
                          min: 0,
                          max: 1,
                          onChanged: (v) async {
                            volume = v;
                            await player.setVolume(v);

                            if (v == 0) {
                              AudioState.mutedNotifier.value = true;
                            } else {
                              _lastNonZeroVolume = v;
                              if (AudioState.mutedNotifier.value) {
                                AudioState.mutedNotifier.value = false;
                              }
                              if (!_everPlayed) {
                                await player.play();
                                _everPlayed = true;
                              }
                            }
                            if (mounted) setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(ThemeData theme) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: artUrl.isNotEmpty
              ? Image.network(
                  artUrl,
                  width: _artSize,
                  height: _artSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.music_note, size: _artSize),
                )
              : Image.asset(
                  'assets/logo_single_semfundo.png',
                  width: _artSize,
                  height: _artSize,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                artist,
                style: TextStyle(color: theme.hintColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(ThemeData theme, Color primaryColor) {
    final progress = (duration.inSeconds == 0)
        ? 0.0
        : (position.inSeconds / duration.inSeconds).clamp(0.0, 1.0);
    return LinearProgressIndicator(
      value: progress,
      minHeight: 4,
      backgroundColor: theme.colorScheme.onTertiary,
      color: primaryColor,
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _buildTimeLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatTime(position),
          style: const TextStyle(fontSize: 11),
        ),
        Text(
          _formatTime(duration),
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}

class AudioState {
  static final mutedNotifier = ValueNotifier<bool>(false);
}
