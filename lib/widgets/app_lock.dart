// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/app_switcher_privacy.dart';
import 'package:fluffychat/widgets/lock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

class AppLockWidget extends StatefulWidget {
  const AppLockWidget({
    required this.child,
    required this.pincode,
    required this.clients,
    super.key,
  });

  final List<Client> clients;
  final String? pincode;
  final Widget child;

  @override
  State<AppLockWidget> createState() => AppLock();
}

class AppLock extends State<AppLockWidget> with WidgetsBindingObserver {
  String? _pincode;
  bool _isLocked = false;
  bool _paused = false;
  AppLifecycleState _lifecycleState =
      WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed;

  bool get _hasPincode =>
      _pincode != null &&
      int.tryParse(_pincode!) != null &&
      _pincode!.length == 4;

  bool get isActive => _hasPincode && !_paused;

  bool get _appSwitcherPrivacyEnabled {
    if (!AppSwitcherPrivacy.isMobile) return false;
    switch (AppSettings.appSwitcherPrivacy.appSwitcherPrivacyMode) {
      case AppSwitcherPrivacyMode.off:
        return false;
      case AppSwitcherPrivacyMode.appLock:
        return _hasPincode;
      case AppSwitcherPrivacyMode.always:
        return true;
    }
  }

  bool get _isForeground => _lifecycleState == AppLifecycleState.resumed;

  bool get _showAppSwitcherPrivacyCover =>
      _appSwitcherPrivacyEnabled &&
      !AppSwitcherPrivacy.isAndroid &&
      {
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
      }.contains(_lifecycleState);

  @override
  void initState() {
    _pincode = widget.pincode;
    _isLocked = isActive;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(syncAppSwitcherPrivacy());
    WidgetsBinding.instance.addPostFrameCallback(_checkLoggedIn);
  }

  Future<void> _checkLoggedIn(_) async {
    if (widget.clients.any((client) => client.isLogged())) return;

    await changePincode(null);
    setState(() {
      _isLocked = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lifecycleState = state;
    });
    unawaited(syncAppSwitcherPrivacy());

    if (isActive &&
        state == AppLifecycleState.hidden &&
        !_isLocked &&
        isActive) {
      showLockScreen();
    }
  }

  bool get isLocked => _isLocked;

  Future<void> changePincode(String? pincode) async {
    await const FlutterSecureStorage().write(
      key: 'chat.fluffy.app_lock',
      value: pincode,
    );
    _pincode = pincode;
    await syncAppSwitcherPrivacy();
    return;
  }

  bool unlock(String pincode) {
    final isCorrect = pincode == _pincode;
    if (isCorrect) {
      setState(() {
        _isLocked = false;
      });
    }
    return isCorrect;
  }

  void showLockScreen() => setState(() {
    _isLocked = true;
  });

  Future<T> pauseWhile<T>(Future<T> future) async {
    _paused = true;
    try {
      return await future;
    } finally {
      _paused = false;
    }
  }

  static AppLock of(BuildContext context) =>
      Provider.of<AppLock>(context, listen: false);

  Future<void> syncAppSwitcherPrivacy() => AppSwitcherPrivacy.setState(
    enabled: _appSwitcherPrivacyEnabled,
    foreground: _isForeground,
  );

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(AppSwitcherPrivacy.setState(enabled: false, foreground: true));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Provider<AppLock>(
    create: (_) => this,
    child: Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (_showAppSwitcherPrivacyCover) const _AppSwitcherPrivacyCover(),
        if (isLocked) const LockScreen(),
      ],
    ),
  );
}

class _AppSwitcherPrivacyCover extends StatelessWidget {
  const _AppSwitcherPrivacyCover();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      key: const ValueKey('app_switcher_privacy_cover'),
      color: theme.colorScheme.surface,
      child: Center(
        child: Icon(
          Icons.lock_outline,
          color: theme.colorScheme.onSurface.withAlpha(96),
          size: 96,
        ),
      ),
    );
  }
}
