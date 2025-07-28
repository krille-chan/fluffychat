import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluffychat/l10n/l10n.dart';

class AudioPlayerStreaming extends StatefulWidget {
  const AudioPlayerStreaming({
    super.key,
  });

  @override
  State<AudioPlayerStreaming> createState() => _AudioPlayerStreamingState();
}

class _AudioPlayerStreamingState extends State<AudioPlayerStreaming>
    with TickerProviderStateMixin {
  final player = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double volume = 0.8;
  bool isPlaying = false;

  String title = 'Carregando...';
  String artist = '';
  String artUrl = '';

  Timer? _fetchMetadataTimer;
  bool _isLoadingMetadata = false;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  static const double _artSize = 70.0;
  static const double _buttonSize = 40.0;
  static const double _volumeIconSize = 20.0;
  static const double _paddingValue = 15.0;
  static const double _borderRadius = 12.0;

  @override
  void initState() {
    super.initState();

    _initializePlayer();
    _setupPlayerListeners();
    _setupAudioStateListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_fetchMetadataTimer == null) {
      _fetchAndScheduleMetadataUpdates();
    }
  }

  void _initializePlayer() {
    player.setUrl(dotenv.env['AUDIO_PLAYER_URL'] ?? '');
    player.setVolume(volume);
  }

  void _setupPlayerListeners() {
    _playerStateSubscription = player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
        });
      }
    });

    _positionSubscription = player.positionStream.listen((p) {
      if (mounted) {
        setState(() {
          position = p;
        });
      }
    });

    _durationSubscription = player.durationStream.listen((d) {
      if (mounted && d != null) {
        setState(() {
          duration = d;
        });
      }
    });
  }

  void _setupAudioStateListener() {
    AudioState.mutedNotifier.addListener(_onMutedChanged);
  }

  void _onMutedChanged() {
    if (mounted) {
      player.setVolume(AudioState.mutedNotifier.value ? 0 : volume);
    }
  }

  void _fetchAndScheduleMetadataUpdates() {
    _fetchNowPlaying();
    _fetchMetadataTimer =
        Timer.periodic(const Duration(seconds: 10), (_) => _fetchNowPlaying());
  }

  Future<void> _fetchNowPlaying() async {
    if (_isLoadingMetadata) return;

    setState(() {
      _isLoadingMetadata = true;
      title = L10n.of(context).loading;
      artist = '';
      artUrl = '';
    });

    try {
      final response = await http.get(
        Uri.parse(
          dotenv.env['NOW_PLAYING_URL'] ?? '',
        ),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final nowPlaying = data['now_playing'];

        if (nowPlaying != null) {
          setState(() {
            title = nowPlaying['song']['title'] ?? L10n.of(context).untitled;
            artist =
                nowPlaying['song']['artist'] ?? L10n.of(context).unknownArtist;
            artUrl = nowPlaying['song']['art'] ?? '';
            duration = Duration(
              seconds: (nowPlaying['duration'] ?? 0).clamp(0, 3600),
            );
            position = Duration(seconds: nowPlaying['elapsed'] ?? 0);
          });
        } else {
          _setErrorState(L10n.of(context).noSongPlaying);
        }
      } else {
        _setErrorState('${L10n.of(context).apiError}: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar now playing: $e');
      if (mounted) {
        _setErrorState(L10n.of(context).errorLoadingInfo);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMetadata = false;
        });
      }
    }
  }

  void _setErrorState(String message) {
    if (mounted) {
      setState(() {
        title = message;
        artist = '';
        artUrl = '';
        duration = Duration.zero;
        position = Duration.zero;
      });
    }
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _fetchMetadataTimer?.cancel();

    AudioState.mutedNotifier.removeListener(_onMutedChanged);

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
    final primaryColor = theme.colorScheme.primary;
    final isMuted = AudioState.mutedNotifier.value;

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
            const SizedBox(
              height: 15,
            ),
            _buildProgressBar(theme, primaryColor),
            const SizedBox(height: 4),
            _buildTimeLabels(),
            const SizedBox(height: 5),
            _buildControlsRow(theme, primaryColor, isMuted),
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
    return LinearProgressIndicator(
      value: duration.inSeconds == 0
          ? 0
          : (position.inSeconds / duration.inSeconds).clamp(0.0, 1.0),
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

  Widget _buildControlsRow(ThemeData theme, Color primaryColor, bool isMuted) {
    final volumeIcon = isMuted || volume == 0
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
              side: BorderSide(color: primaryColor, width: 2),
              padding: EdgeInsets.zero,
            ),
            onPressed: () async {
              if (isPlaying) {
                await player.pause();
              } else {
                await player.play();
              }
            },
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: primaryColor,
              size: _volumeIconSize,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 32,
          height: 32,
          child: IconButton(
            icon: Icon(volumeIcon),
            iconSize: _volumeIconSize,
            padding: EdgeInsets.zero,
            onPressed: () {
              AudioState.mutedNotifier.value = !isMuted;
            },
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: theme.colorScheme.onTertiary,
              inactiveTrackColor: theme.colorScheme.onTertiary,
              thumbColor: primaryColor,
              overlayColor: primaryColor.withValues(alpha: 0.2),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: volume,
              min: 0,
              max: 1,
              onChanged: (v) {
                setState(() {
                  volume = v;
                  AudioState.mutedNotifier.value = v == 0;
                  player.setVolume(volume);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class AudioState {
  static final mutedNotifier = ValueNotifier<bool>(false);
}
