import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'layouts/one_page_card.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({Key key}) : super(key: key);

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _wrongInput = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FluffyThemes.light,
      darkTheme: FluffyThemes.light,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      home: Builder(
        builder: (context) => OnePageCard(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              centerTitle: true,
              title: Text(L10n.of(context).pleaseEnterYourPin),
              backgroundColor: Colors.transparent,
            ),
            extendBodyBehindAppBar: true,
            body: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: const [
                    0.1,
                    0.4,
                    0.6,
                    0.9,
                  ],
                  colors: [
                    Theme.of(context).secondaryHeaderColor.withAlpha(16),
                    Theme.of(context).primaryColor.withAlpha(16),
                    Theme.of(context).colorScheme.secondary.withAlpha(16),
                    Theme.of(context).backgroundColor.withAlpha(16),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: PinCodeTextField(
                autofocus: true,
                controller: _textEditingController,
                focusNode: _focusNode,
                pinBoxRadius: AppConfig.borderRadius,
                pinTextStyle: const TextStyle(fontSize: 32),
                hideCharacter: true,
                hasError: _wrongInput,
                onDone: (String input) async {
                  if (input ==
                      await const FlutterSecureStorage()
                          .read(key: SettingKeys.appLockKey)) {
                    AppLock.of(context).didUnlock();
                  } else {
                    _textEditingController.clear();
                    setState(() => _wrongInput = true);
                    _focusNode.requestFocus();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
