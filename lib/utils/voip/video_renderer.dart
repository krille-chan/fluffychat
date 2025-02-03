import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:matrix/matrix.dart';

class VideoRenderer extends StatefulWidget {
  final WrappedMediaStream? stream;
  final bool mirror;
  final RTCVideoViewObjectFit fit;

  const VideoRenderer(
    this.stream, {
    this.mirror = false,
    this.fit = RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _VideoRendererState();
}

class _VideoRendererState extends State<VideoRenderer> {
  RTCVideoRenderer? _renderer;
  bool _rendererReady = false;
  MediaStream? get mediaStream => widget.stream?.stream;
  StreamSubscription? _streamChangeSubscription;

  Future<RTCVideoRenderer> _initializeRenderer() async {
    _renderer ??= RTCVideoRenderer();
    await _renderer!.initialize();
    _renderer!.srcObject = mediaStream;
    return _renderer!;
  }

  void disposeRenderer() {
    try {
      _renderer?.srcObject = null;
      _renderer?.dispose();
      _renderer = null;
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void initState() {
    _streamChangeSubscription =
        widget.stream?.onStreamChanged.stream.listen((stream) {
      setState(() {
        _renderer?.srcObject = stream;
      });
    });
    setupRenderer();
    super.initState();
  }

  Future<void> setupRenderer() async {
    await _initializeRenderer();
    setState(() => _rendererReady = true);
  }

  @override
  void dispose() {
    _streamChangeSubscription?.cancel();
    disposeRenderer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => !_rendererReady
      ? Container()
      : Builder(
          key: widget.key,
          builder: (ctx) {
            return RTCVideoView(
              _renderer!,
              mirror: widget.mirror,
              filterQuality: FilterQuality.medium,
              objectFit: widget.fit,
              placeholderBuilder: (_) =>
                  Container(color: Colors.white.withAlpha(45)),
            );
          },
        );
}
