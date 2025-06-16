import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/app_lock.dart';

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

  void tryUnlock(String text) async {
    setState(() {
      _errorText = null;
    });
    if (text.length < 4) return;

    final enteredPin = int.tryParse(text);
    if (enteredPin == null || text.length != 4) {
      setState(() {
        _errorText = L10n.of(context).invalidInput;
      });
      _textEditingController.clear();
      return;
    }

    if (AppLock.of(context).unlock(enteredPin.toString())) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).pleaseEnterYourPin),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: FluffyThemes.columnWidth,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Image.asset(
                    'assets/info-logo.png',
                    width: 256,
                  ),
                ),
                TextField(
                  controller: _textEditingController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  readOnly: _inputBlocked,
                  onChanged: tryUnlock,
                  onSubmitted: tryUnlock,
                  style: const TextStyle(fontSize: 40),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: InputDecoration(
                    errorText: _errorText,
                    hintText: '****',
                    suffix: IconButton(
                      icon: const Icon(Icons.lock_open_outlined),
                      onPressed: () => tryUnlock(_textEditingController.text),
                    ),
                  ),
                ),
                if (_inputBlocked)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
