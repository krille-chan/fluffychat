import 'dart:async';
import 'dart:ui_web' as ui;

import 'package:fluffychat/widgets/streaming/video_streaming_model.dart';
import 'package:fluffychat/widgets/streaming/video_streaming_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'ivs_player.dart';

class VideoStreaming extends StatefulWidget {
  final String playbackUrl;
  final String title;
  final String aspectRatio;
  final bool isAdmin;
  final bool? isPreview;
  final void Function(String debugInfo)? onDebugInfoChanged;
  final VoidCallback? onClose;
  final VoidCallback? onEdit;

  const VideoStreaming({
    super.key,
    required this.playbackUrl,
    required this.title,
    required this.isAdmin,
    this.aspectRatio = '16:9',
    this.onClose,
    this.onEdit,
    this.isPreview = false,
    this.onDebugInfoChanged,
  });

  @override
  State<VideoStreaming> createState() => VideoStreamingController();
}

class VideoStreamingController extends State<VideoStreaming> {
  final positionNotifier = ValueNotifier<Offset>(const Offset(16, 16));
  final widthNotifier = ValueNotifier<double>(0);
  late double aspectRatioValue;

  double get width => widthNotifier.value;
  double get height => width / aspectRatioValue;
  Offset get position => positionNotifier.value;

  bool get isPreview => widget.isPreview ?? false;

  void initializeIfNeeded(double defaultWidth) {
    if (widthNotifier.value == 0) {
      widthNotifier.value = defaultWidth;
    }
  }

  void setPosition(Offset newPosition, double maxWidth, double maxHeight,
      bool isMobileMode) {
    if (!mounted) return;

    final dx = isMobileMode ? position.dx : newPosition.dx.clamp(16, maxWidth);
    final dy = newPosition.dy.clamp(16, maxHeight);
    positionNotifier.value = Offset(dx.toDouble(), dy.toDouble());
  }

  void resize(double deltaX, double screenWidth) {
    if (!mounted) return;

    final maxWidthFactor = aspectRatioValue == 16 / 9 ? 0.65 : 0.55;

    final newWidth =
        (width + deltaX).clamp(screenWidth * 0.3, screenWidth * maxWidthFactor);
    widthNotifier.value = newWidth;
  }

  late String viewId;
  web.HTMLVideoElement? videoElement;
  IVSPlayerJS? ivsPlayer;

  bool htmlElementsCreated = false;
  String debugInfo = 'Iniciando componente...';

  Timer? _playbackPollTimer;

  bool _widgetMounted = false;
  bool _isLive = false;

  @override
  void initState() {
    super.initState();
    _widgetMounted = true;

    aspectRatioValue = VideoStreamingModel.parseAspectRatio(widget.aspectRatio);

    viewId = 'ivs-player-${DateTime.now().millisecondsSinceEpoch}';

    _createHtmlElements();
    _registerView();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_widgetMounted) _initIvsPlayerAndStream();
    });
  }

  @override
  void didUpdateWidget(covariant VideoStreaming oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.aspectRatio != oldWidget.aspectRatio) {
      final newAspectRatio =
          VideoStreamingModel.parseAspectRatio(widget.aspectRatio);
      aspectRatioValue = newAspectRatio;
      setState(() {});
    }
  }

  void _createHtmlElements() {
    if (htmlElementsCreated) return;
    videoElement = web.document.createElement('video') as web.HTMLVideoElement
      ..id = '$viewId-video'
      ..autoplay = true
      ..muted = true
      ..controls = true;
    videoElement!.style
      ..width = '100%'
      ..height = '100%'
      ..border = 'none'
      ..borderRadius = '8px'
      ..backgroundColor = 'black'
      ..objectFit = 'cover';
    htmlElementsCreated = true;
    _updateDebugInfo('Elemento de vídeo HTML criado.',
        playerStatus: _getCurrentPlayerStatus());
  }

  void _registerView() {
    try {
      ui.platformViewRegistry.registerViewFactory(
        viewId,
        (int id) => videoElement!,
      );
      _updateDebugInfo('View factory registrada.',
          playerStatus: _getCurrentPlayerStatus());
    } on PlatformException catch (e) {
      _updateDebugInfo('Erro ao registrar view factory: $e',
          playerStatus: _getCurrentPlayerStatus());
    }
  }

  IvsPlayerState _getCurrentPlayerStatus() {
    try {
      final raw = ivsPlayer?.getState();
      if (raw == null) return IvsPlayerState.unknown;
      return IvsPlayerState.fromString(raw.toUpperCase());
    } catch (e) {
      debugPrint('Erro ao obter estado do player: $e');
      return IvsPlayerState.unknown;
    }
  }

  void _updateDebugInfo(String message, {IvsPlayerState? playerStatus}) {
    final statusToShow = playerStatus ?? _getCurrentPlayerStatus();
    final newDebug = 'Status: ${statusToShow.value} | $message';

    if (mounted) {
      setState(() {
        debugInfo = newDebug;
      });

      widget.onDebugInfoChanged?.call(newDebug);
    }
  }

  void _initIvsPlayerAndStream() {
    if (!_widgetMounted) return;

    if (ivsPlayer == null) {
      _updateDebugInfo(
        'Player IVS não inicializado. Tentando criar e anexar.',
        playerStatus: _getCurrentPlayerStatus(),
      );
      try {
        ivsPlayer = createIVSPlayerIfAvailable();
        ivsPlayer!.autoplay = true;
        ivsPlayer!.muted = true;

        if (ivsPlayer == null) {
          _updateDebugInfo(
              'IVS Player SDK não carregado/pronto. Tentando novamente em 3s.',
              playerStatus: IvsPlayerState.error);
          Future.delayed(const Duration(seconds: 3), () {
            if (_widgetMounted) _initIvsPlayerAndStream();
          });
          return;
        }

        if (videoElement == null) {
          throw Exception("Elemento de vídeo HTML é nulo ao tentar anexar.");
        }

        ivsPlayer!.attachHTMLVideoElement(videoElement!);
        _setupEventListeners();
        _updateDebugInfo(
          'IVS Player criado e anexado com sucesso.',
          playerStatus: _getCurrentPlayerStatus(),
        );
      } catch (e) {
        _updateDebugInfo(
            'Erro ao criar/anexar IVS Player: $e. Tentando novamente em 3s.',
            playerStatus: IvsPlayerState.error);
        Future.delayed(const Duration(seconds: 3), () {
          if (_widgetMounted) _initIvsPlayerAndStream();
        });
        return;
      }
    }

    if (ivsPlayer != null) {
      ivsPlayer!.load(widget.playbackUrl);
      _updateDebugInfo(
        'Chamada inicial de load para playback URL: ${widget.playbackUrl}.',
        playerStatus: _getCurrentPlayerStatus(),
      );
    } else {
      _updateDebugInfo(
        'Erro: IVS Player é nulo após tentativa de criação. Não é possível carregar a URL.',
        playerStatus: IvsPlayerState.error,
      );
    }

    _handleIsLiveChange();
  }

  void _setupEventListeners() {
    if (ivsPlayer == null) return;
    _updateDebugInfo('Configurando event listeners do IVS Player.',
        playerStatus: _getCurrentPlayerStatus());

    final onStateChange = (JSAny event) {
      try {
        final rawState =
            (event as JSObject).getProperty<JSString?>('state'.toJS)?.toDart;

        final newState =
            IvsPlayerState.fromString(rawState?.toUpperCase() ?? '');
        _updateDebugInfo(
          '🟢 Evento PlayerStateChange: $rawState',
          playerStatus: newState,
        );

        final oldIsLive = _isLive;
        _isLive = (newState == IvsPlayerState.playing);

        if (_isLive != oldIsLive || (_isLive && _playbackPollTimer != null)) {
          _handleIsLiveChange();
        }

        if ((newState == IvsPlayerState.idle ||
                newState == IvsPlayerState.ready) &&
            !_isLive) {
          if (newState != IvsPlayerState.playing) {
            _updateDebugInfo('Estado ${newState.value}. Tentando play...',
                playerStatus: newState);
          }

          ivsPlayer?.play();
        }
      } catch (e) {
        _updateDebugInfo(
          '❌ Erro no evento PlayerStateChange: $e',
          playerStatus: IvsPlayerState.error,
        );
      }
    }.toJS;

    final onError = (JSAny event) {
      final errorEvent = event as PlayerErrorEventJS;

      final codeStr = '${errorEvent.code}';
      final messageStr = '${errorEvent.message}';

      _updateDebugInfo(
        'Erro IVS: $codeStr - $messageStr.',
        playerStatus: IvsPlayerState.error,
      );

      final oldIsLive = _isLive;
      _isLive = false;

      if (_isLive != oldIsLive) {
        _handleIsLiveChange();
      } else if (_playbackPollTimer == null) {
        _handleIsLiveChange();
      }
    }.toJS;

    ivsPlayer!.addEventListener(IVSPlayerEvent.stateChanged, onStateChange);
    ivsPlayer!.addEventListener(IVSPlayerEvent.error, onError);
    _updateDebugInfo('Event listeners configurados.',
        playerStatus: _getCurrentPlayerStatus());
  }

  void _handleIsLiveChange() {
    if (_isLive) {
      _updateDebugInfo('Player está tocando.',
          playerStatus: IvsPlayerState.playing);
      _stopPlaybackPolling();
    } else {
      _updateDebugInfo('Player não está tocando.',
          playerStatus: _getCurrentPlayerStatus());
      _startPlaybackPolling();
    }
  }

  void _startPlaybackPolling() {
    if (_playbackPollTimer != null && _playbackPollTimer!.isActive) {
      _updateDebugInfo('Polling ativo.',
          playerStatus: _getCurrentPlayerStatus());
      return;
    }

    _playbackPollTimer?.cancel();

    _updateDebugInfo('Iniciando polling...',
        playerStatus: _getCurrentPlayerStatus());
    _playbackPollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_widgetMounted) {
        _stopPlaybackPolling();
        return;
      }
      final currentStatus = _getCurrentPlayerStatus();

      if (currentStatus == IvsPlayerState.playing) {
        _updateDebugInfo('Polling: player tocando, nada a fazer.',
            playerStatus: currentStatus);
        return;
      }

      _updateDebugInfo('Polling: tentando recarregar stream.',
          playerStatus: currentStatus);

      try {
        ivsPlayer?.load(widget.playbackUrl);
      } catch (e) {
        _updateDebugInfo('Erro no polling: $e', playerStatus: currentStatus);
      }
    });
  }

  void _stopPlaybackPolling() {
    if (_playbackPollTimer != null) {
      _playbackPollTimer!.cancel();
      _playbackPollTimer = null;
      _updateDebugInfo('Polling parado.',
          playerStatus: _getCurrentPlayerStatus());
    }
  }

  @override
  void dispose() {
    _widgetMounted = false;
    _playbackPollTimer?.cancel();
    ivsPlayer?.pause();
    ivsPlayer = null;
    videoElement = null;
    _updateDebugInfo('Widget VideoStreaming descartado.',
        playerStatus: IvsPlayerState.unknown);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoStreamingView(
      this,
      title: widget.title,
      playbackUrl: widget.playbackUrl,
      isAdmin: widget.isAdmin,
      isPreview: widget.isPreview ?? false,
      viewId: viewId,
      onClose: widget.onClose ?? () {},
      onEdit: widget.onEdit ?? () {},
    );
  }
}
