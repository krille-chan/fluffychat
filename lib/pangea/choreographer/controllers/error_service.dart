import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import '../../common/utils/error_handler.dart';

class ChoreoError {
  final Object? raw;

  ChoreoError({this.raw});

  String title(BuildContext context) => ErrorCopy(context, error: raw).title;

  String description(BuildContext context) =>
      ErrorCopy(context, error: raw).body;

  IconData get icon => Icons.error_outline;
}

class ErrorService {
  ChoreoError? _error;
  int coolDownSeconds = 0;
  final Choreographer controller;

  ErrorService(this.controller);

  bool get isError => _error != null;

  ChoreoError? get error => _error;

  Duration get defaultCooldown {
    coolDownSeconds += 3;
    return Duration(seconds: coolDownSeconds);
  }

  final List<String> _errorCache = [];

  setError(ChoreoError? error, {Duration? duration}) {
    if (_errorCache.contains(error?.raw.toString())) {
      return;
    }

    if (error != null) {
      _errorCache.add(error.raw.toString());
    }

    _error = error;
    Future.delayed(duration ?? defaultCooldown, () {
      clear();
      _setState();
    });
    _setState();
  }

  setErrorAndLock(ChoreoError? error) {
    _error = error;
    _setState();
  }

  resetError() {
    clear();
    _setState();
  }

  void _setState() {
    controller.setState();
  }

  void clear() {
    _error = null;
  }
}
