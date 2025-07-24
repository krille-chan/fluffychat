import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class AudioPlayerStream extends StatefulWidget {
  const AudioPlayerStream({
    super.key,
  });

  @override
  State<AudioPlayerStream> createState() => _AudioPlayerStreamState();
}

class _AudioPlayerStreamState extends State<AudioPlayerStream>
    with TickerProviderStateMixin {
  final player = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double volume = 0.8;
  bool isMuted = false;
  bool isPlaying = false;

  String title = 'Carregando...';
  String artist = '';
  String artUrl = '';

  Timer? progressTimer;
  Timer? fetchTimer;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    player.setUrl('https://radio.kamii.com.br:8000/radio.mp3');
    player.setVolume(volume);

    player.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
        if (isPlaying) {
          _pulseController.stop();
        } else if (!_hasInteracted) {
          _pulseController.repeat(reverse: true);
        }
      });
    });

    progressTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isPlaying) {
        setState(() {
          position += const Duration(seconds: 1);
        });
      }
    });

    fetchNowPlaying();
    fetchTimer =
        Timer.periodic(const Duration(seconds: 10), (_) => fetchNowPlaying());
  }

  Future<void> fetchNowPlaying() async {
    try {
      final response = await http.get(
          Uri.parse('https://radio.kamii.com.br/api/nowplaying/radiohemp'));
      final data = jsonDecode(response.body);
      final nowPlaying = data['now_playing'];

      if (nowPlaying != null) {
        setState(() {
          title = nowPlaying['song']['title'] ?? 'Sem título';
          artist = nowPlaying['song']['artist'] ?? '';
          artUrl = nowPlaying['song']['art'] ?? '';
          duration =
              Duration(seconds: (nowPlaying['duration'] ?? 0).clamp(0, 3600));
          position = Duration(seconds: nowPlaying['elapsed'] ?? 0);
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar now playing: $e');
      setState(() {
        title = 'Erro ao carregar info';
        artist = '';
        artUrl = '';
        duration = Duration.zero;
        position = Duration.zero;
      });
    }
  }

  @override
  void dispose() {
    player.dispose();
    progressTimer?.cancel();
    fetchTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String formatTime(Duration d) {
    return "${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final volumeIcon = isMuted || volume == 0
        ? Icons.volume_off
        : volume > 0.5
            ? Icons.volume_up
            : Icons.volume_down;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        border: Border.all(color: theme.colorScheme.secondary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: artUrl.isNotEmpty
                      ? Image.network(
                          artUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.music_note, size: 70),
                        )
                      : Image.asset(
                          'assets/logo_single_semfundo.png',
                          width: 70,
                          height: 70,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 2),
                      Text(artist, style: TextStyle(color: theme.hintColor)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            LinearProgressIndicator(
              value: duration.inSeconds == 0
                  ? 0
                  : (position.inSeconds / duration.inSeconds).clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: theme.colorScheme.onTertiary,
              color: primary,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatTime(position),
                  style: const TextStyle(fontSize: 11),
                ),
                Text(
                  formatTime(duration),
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        side: BorderSide(color: primary, width: 2),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () async {
                        if (!_hasInteracted) {
                          _hasInteracted = true;
                          _pulseController.stop();
                          _pulseController.reset();
                        }

                        if (isPlaying) {
                          await player.pause();
                          setState(() => position = Duration.zero);
                        } else {
                          await player.play();
                          await fetchNowPlaying();
                        }
                      },
                      child: Icon(
                        isPlaying ? Icons.stop : Icons.play_arrow,
                        color: primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: IconButton(
                    icon: Icon(volumeIcon),
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        isMuted = !isMuted;
                        player.setVolume(isMuted ? 0 : volume);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: theme.colorScheme.onTertiary,
                      inactiveTrackColor: theme.colorScheme.onTertiary,
                      thumbColor: primary,
                      overlayColor: primary.withValues(alpha: 0.2),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 12),
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 8),
                    ),
                    child: Slider(
                      value: volume,
                      min: 0,
                      max: 1,
                      onChanged: (v) {
                        setState(() {
                          volume = v;
                          isMuted = v == 0;
                          player.setVolume(volume);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
