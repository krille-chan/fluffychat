import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

enum IvsPlayerState {
  playing('PLAYING'),
  buffering('BUFFERING'),
  ended('ENDED'),
  idle('IDLE'),
  ready('READY'),
  error('ERROR'),
  unknown('UNKNOWN');

  final String value;
  const IvsPlayerState(this.value);

  static IvsPlayerState fromString(String state) {
    switch (state.toUpperCase()) {
      case 'PLAYING':
        return IvsPlayerState.playing;
      case 'BUFFERING':
        return IvsPlayerState.buffering;
      case 'ENDED':
        return IvsPlayerState.ended;
      case 'IDLE':
        return IvsPlayerState.idle;
      case 'READY':
        return IvsPlayerState.ready;
      case 'ERROR':
        return IvsPlayerState.error;
      default:
        return IvsPlayerState.unknown;
    }
  }
}

extension type IVSPlayerJS(JSObject _) implements JSAny {
  external void attachHTMLVideoElement(web.HTMLVideoElement? element);
  external void load(String url);
  external set autoplay(bool value);
  external set muted(bool value);
  external void play();
  external void pause();

  external String get quality;
  external JSArray<JSString> get qualities;
  external void setQuality(String quality);

  external String getState();
  external JSString get error;

  external void addEventListener(String eventName, JSAny callback);
  external void removeEventListener(String eventName, JSAny callback);

  external double getLiveLatency();
  external double getBufferDuration();
}

extension type PlayerStateChangeEventJS(JSObject _) implements JSAny {
  external String get state;
}

extension type PlayerErrorEventJS(JSObject _) implements JSAny {
  external JSAny get code;
  external JSAny get message;
}

IVSPlayerJS? createIVSPlayerIfAvailable() {
  final ivsPlayerModule = web.window.getProperty<JSObject?>('IVSPlayer'.toJS);
  if (ivsPlayerModule == null || ivsPlayerModule.isUndefinedOrNull) {
    debugPrint('[IVS] Módulo IVSPlayer não disponível no window.');
    return null;
  }

  final createFn = ivsPlayerModule.getProperty<JSFunction?>('create'.toJS);
  if (createFn == null || createFn.isUndefinedOrNull) {
    debugPrint('[IVS] Método create() não encontrado em IVSPlayer.');
    return null;
  }

  try {
    final instance = createFn.callMethod<JSObject>('call'.toJS, [null].toJS);
    return instance as IVSPlayerJS;
  } catch (e) {
    debugPrint('[IVS] Erro ao criar instância do player: $e');
    return null;
  }
}

class IVSPlayerEvent {
  static const String error = 'PlayerError';
  static const String stateChanged = 'PlayerStateChange';
}
