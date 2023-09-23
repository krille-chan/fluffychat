import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/error_reporter.dart';
import 'package:fluffychat/widgets/theme_builder.dart';

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

  void tryUnlock(BuildContext context) async {
    setState(() {
      _errorText = null;
    });
    if (_textEditingController.text.length < 4) return;

    final enteredPin = int.tryParse(_textEditingController.text);
    if (enteredPin == null || _textEditingController.text.length != 4) {
      setState(() {
        _errorText = L10n.of(context)!.invalidInput;
      });
      _textEditingController.clear();
      return;
    }

    final correctPin = int.tryParse(
      await const FlutterSecureStorage().read(key: SettingKeys.appLockKey) ??
          '',
    );
    if (correctPin == null) {
      ErrorReporter(
        context,
        'Lockscreen was displayed but pin was not stored correctly',
      ).onErrorCallback(
        Exception(),
      );
      AppLock.of(context)!.didUnlock();
      return;
    }

    if (correctPin == enteredPin) {
      AppLock.of(context)!.didUnlock();
      return;
    }
    setState(() {
      _errorText = L10n.of(context)!.wrongPinEntered(_coolDownSeconds);
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
    return ThemeBuilder(
      builder: (context, themeMode, primaryColor) => MaterialApp(
        title: AppConfig.applicationName,
        themeMode: themeMode,
        theme: FluffyThemes.buildTheme(context, Brightness.light, primaryColor),
        darkTheme:
            FluffyThemes.buildTheme(context, Brightness.dark, primaryColor),
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(L10n.of(context)!.pleaseEnterYourPin),
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
                        child: _inputBlocked
                            ? const CircularProgressIndicator.adaptive()
                            : Image.asset(
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
                        onChanged: (_) => tryUnlock(context),
                        onSubmitted: (_) => tryUnlock(context),
                        style: const TextStyle(fontSize: 40),
                        decoration: InputDecoration(
                          errorText: _errorText,
                          hintText: '****',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
