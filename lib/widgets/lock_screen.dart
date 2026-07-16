// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/app_lock.dart';
import 'package:fluffychat/widgets/bidi/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String? _errorText;
  int _coolDownSeconds = 5;
  bool _inputBlocked = false;
  final TextEditingController _textEditingController = TextEditingController();

  Future<void> tryUnlockWithBiometrics() async {
    setState(() {
      _errorText = null;
    });

    final success = await AppLock.of(context).unlockWithBiometrics();

    if (success) {
      setState(() {
        _inputBlocked = false;
        _errorText = null;
      });
      return;
    }

    setState(() {
      _errorText = L10n.of(context).wrongPinEntered(_coolDownSeconds);
      _inputBlocked = true;
    });
    Future.delayed(Duration(seconds: _coolDownSeconds)).then((_) {
      setState(() {
        _inputBlocked = false;
        _coolDownSeconds *= 2;
        _errorText = null;
      });
    });
    _textEditingController.clear();
  }

  Future<void> tryUnlock(String text) async {
    text = text.trim();
    setState(() {
      _errorText = null;
    });

    final enteredPin = int.tryParse(text);
    if (enteredPin == null) {
      setState(() {
        _errorText = L10n.of(context).invalidInput;
      });
      _textEditingController.clear();
      return;
    }

    if (AppLock.of(context).unlock(text)) {
      setState(() {
        _inputBlocked = false;
        _errorText = null;
      });
      _textEditingController.clear();
      return;
    }

    setState(() {
      _errorText = L10n.of(context).wrongPinEntered(_coolDownSeconds);
      _inputBlocked = true;
    });
    Future.delayed(Duration(seconds: _coolDownSeconds)).then((_) {
      setState(() {
        _inputBlocked = false;
        _coolDownSeconds *= 2;
        _errorText = null;
      });
    });
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(L10n.of(context).pleaseEnterYourPin),
              centerTitle: true,
            ),
            body: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: FluffyThemes.columnWidth,
              ),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                children: [
                  Center(
                    child: Image.asset(
                      'assets/logo/mini/logo_mono_mini.png',
                      width: 128,
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _textEditingController,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    readOnly: _inputBlocked,
                    onChanged: (text) {
                      if (text.length >= 6) tryUnlock(text);
                    },
                    onSubmitted: tryUnlock,
                    style: const TextStyle(fontSize: 40),
                    inputFormatters: [LengthLimitingTextInputFormatter(6)],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      errorText: _errorText,
                      hintText: '✱✱✱✱',
                      hintStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                      ),
                      prefix: AppLock.of(context).useBiometrics
                          ? IconButton(
                              tooltip: L10n.of(context).unlockWithBiometrics,
                              icon: FutureBuilder(
                                future: LocalAuthentication()
                                    .getAvailableBiometrics(),
                                builder: (context, snapshot) {
                                  final availableBiometrics =
                                      snapshot.data ?? [];
                                  if (availableBiometrics.contains(
                                    BiometricType.face,
                                  )) {
                                    return Icon(Icons.face_unlock_outlined);
                                  }
                                  return Icon(Icons.fingerprint_outlined);
                                },
                              ),
                              onPressed: _inputBlocked
                                  ? null
                                  : tryUnlockWithBiometrics,
                            )
                          : IconButton(
                              tooltip: L10n.of(context).reset,
                              icon: Icon(Icons.cancel_outlined),
                              onPressed: _inputBlocked
                                  ? null
                                  : _textEditingController.clear,
                            ),
                      suffix: IconButton(
                        tooltip: L10n.of(context).unlock,
                        icon: Icon(Icons.send_outlined),
                        onPressed: _inputBlocked
                            ? null
                            : () => tryUnlock(_textEditingController.text),
                      ),
                    ),
                  ),
                  if (_inputBlocked)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator.adaptive(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
