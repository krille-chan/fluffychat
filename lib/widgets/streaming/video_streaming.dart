import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;
import 'dart:async';

extension type IVSPlayerJS(JSObject _) implements JSAny {
  external void attachHTMLVideoElement(
    web.HTMLVideoElement? element,
  );
  external void load(String url);
  external set autoplay(bool value);
  external set muted(bool value);
  external void play();
  external void pause();
  external String get quality;
  external JSArray<JSString> get qualities;
  external void setQuality(String quality);
  external String get playbackState;
  external JSString get error;
  external void addEventListener(
    String eventName,
    JSAny callback,
  );
  external void removeEventListener(
    String eventName,
    JSAny callback,
  );
  external double getLiveLatency();
  external double getBufferDuration();
}

extension type PlayerStateChangeEventJS(JSObject _) implements JSAny {
  external String get state;
}

extension type PlayerErrorEventJS(JSObject _) implements JSAny {
  external String get code;
  external String get message;
}

IVSPlayerJS createIVSPlayer() {
  final ivsPlayerModule = web.window.getProperty<JSObject>('IVSPlayer'.toJS);
  final createFn = ivsPlayerModule.getProperty<JSFunction>('create'.toJS);
  final instance = createFn.callMethod<JSObject>('call'.toJS, [null].toJS);
  return instance as IVSPlayerJS;
}

class VideoStreaming extends StatefulWidget {
  final String playbackUrl;
  final double? width;
  final double? height;

  const VideoStreaming({
    super.key,
    required this.playbackUrl,
    this.width,
    this.height,
  });

  @override
  State<VideoStreaming> createState() => _VideoStreamingState();
}

class _VideoStreamingState extends State<VideoStreaming> {
  late String viewId;
  web.HTMLVideoElement? videoElement;
  web.HTMLDivElement? container;
  IVSPlayerJS? ivsPlayer;

  bool htmlElementsCreated = false;
  String debugInfo = 'Iniciando componente...';
  String ivsPlayerStatus = 'INICIANDO';
  int retryCount = 0;
  static const int maxRetries = 30;
  Duration retryDelay = const Duration(seconds: 1);

  Timer? initTimer;
  Timer? retryTimer;
  Timer? pollTimer;

  bool widgetMounted = false;

  @override
  void initState() {
    super.initState();
    widgetMounted = true;
    viewId = 'ivs-player-${DateTime.now().millisecondsSinceEpoch}';
    _createHtmlElements();
    _registerView();
    _startPlayerInitializationFlow();
  }

  void _startPlayerInitializationFlow() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widgetMounted) _initializePlayerWithDelay();
    });
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
      ..backgroundColor = 'black';

    htmlElementsCreated = true;
  }

  void _registerView() {
    try {
      ui.platformViewRegistry.registerViewFactory(
        viewId,
        (int id) => videoElement!,
      );
    } on PlatformException catch (e) {
      debugInfo = 'Erro ao registrar view factory: $e';
    }
  }

  void _initializePlayerWithDelay() {
    if (!widgetMounted || retryCount >= maxRetries) {
      ivsPlayerStatus = 'FALHA_MAX_RETRIES';
      return;
    }

    initTimer = Timer(retryDelay, () {
      if (!widgetMounted) return;

      try {
        ivsPlayer = createIVSPlayer();
        ivsPlayer!.attachHTMLVideoElement(videoElement!);
        ivsPlayer!.autoplay = true;
        ivsPlayer!.muted = true;
        ivsPlayer!.load(widget.playbackUrl);
        ivsPlayer!.play();

        _setupEventListeners();

        ivsPlayerStatus = 'CARREGANDO';
        setState(() {});
      } catch (e) {
        retryCount++;
        retryDelay *= 1.5;
        if (retryDelay.inSeconds > 30) {
          retryDelay = const Duration(seconds: 30);
        }

        retryTimer = Timer(retryDelay, _initializePlayerWithDelay);
        ivsPlayerStatus = 'REINIT_TENTATIVA';
        debugInfo = 'Erro: $e';
        setState(() {});
      }
    });
  }

  void _setupEventListeners() {
    if (ivsPlayer == null) return;

    final onStateChange = (JSAny event) {
      final stateEvent = event as PlayerStateChangeEventJS;
      setState(() {
        ivsPlayerStatus = stateEvent.state.toUpperCase();
        debugInfo = 'Estado: ${stateEvent.state}';
      });
    }.toJS;

    final onError = (JSAny event) {
      final errorEvent = event as PlayerErrorEventJS;
      setState(() {
        ivsPlayerStatus = 'ERRO: ${errorEvent.code} - ${errorEvent.message}';
        debugInfo = 'Erro: ${errorEvent.code} - ${errorEvent.message}';
      });

      if (errorEvent.code == '404' && pollTimer == null) {
        _startPollingStream();
      }
    }.toJS;

    ivsPlayer!.addEventListener('playerStateChange', onStateChange);
    ivsPlayer!.addEventListener('playerError', onError);
  }

  void _startPollingStream() {
    pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      try {
        ivsPlayer!.load(widget.playbackUrl);
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    widgetMounted = false;
    initTimer?.cancel();
    retryTimer?.cancel();
    pollTimer?.cancel();
    ivsPlayer?.pause();

    container?.remove();

    ivsPlayer = null;
    videoElement = null;
    container = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: viewId);
  }
}
