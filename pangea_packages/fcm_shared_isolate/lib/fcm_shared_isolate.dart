import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FcmSharedIsolate {
  final _channel = MethodChannel('fcm_shared_isolate');
  final _msg = <Map<dynamic, dynamic>>[];
  void Function(Map<dynamic, dynamic>)? _onMessage;
  void Function(String)? _onNewToken;

  FcmSharedIsolate() {
    _channel.setMethodCallHandler(handle);
  }

  Future<dynamic> handle(MethodCall call) async {
    if (call.method == 'message') {
      final Map<dynamic, dynamic> data = call.arguments;
      final onMessage = _onMessage;
      if (onMessage != null) {
        onMessage(data);
      } else {
        _msg.add(data);
      }
    } else if (call.method == 'token') {
      final String newToken = call.arguments;
      _onNewToken?.call(newToken);
    }
    return null;
  }

  Future<String> getToken() async {
    return await _channel.invokeMethod('getToken');
  }

  void setListeners({
    void Function(Map<dynamic, dynamic>)? onMessage,
    void Function(String)? onNewToken,
  }) {
    _onMessage = onMessage;
    _onNewToken = onNewToken;
    if (onMessage != null) {
      _msg.forEach(onMessage);
      _msg.clear();
    }
  }

  Future<bool> requestPermission(
      {bool sound = true,
      bool alert = true,
      bool badge = true,
      bool provisional = false,}) async {
    if (kIsWeb || !Platform.isIOS) {
      return true;
    }

    final bool result = await _channel.invokeMethod('requestPermission', {
      'sound': sound,
      'alert': alert,
      'badge': badge,
      'provisional': provisional,
    });
    return result;
  }
}
