import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/encryption.dart';
import 'package:famedlysdk/encryption/utils/bootstrap.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/widgets/adaptive_flat_button.dart';
import 'package:flutter/services.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

import 'key_verification_dialog.dart';

class BootstrapDialog extends StatefulWidget {
  final bool wipe;
  final Client client;
  const BootstrapDialog({
    Key key,
    this.wipe = false,
    @required this.client,
  }) : super(key: key);

  Future<bool> show(BuildContext context) => PlatformInfos.isCupertinoStyle
      ? showCupertinoDialog(
          context: context,
          builder: (context) => this,
          barrierDismissible: true,
          useRootNavigator: false,
        )
      : showDialog(
          context: context,
          builder: (context) => this,
          barrierDismissible: true,
          useRootNavigator: false,
        );

  @override
  _BootstrapDialogState createState() => _BootstrapDialogState();
}

class _BootstrapDialogState extends State<BootstrapDialog> {
  final TextEditingController _recoveryKeyTextEditingController =
      TextEditingController();

  Bootstrap bootstrap;

  String _recoveryKeyInputError;

  bool _recoveryKeyInputLoading = false;

  String titleText;

  bool _recoveryKeyStored = false;

  bool _wipe;

  void _createBootstrap(bool wipe) {
    setState(() {
      _wipe = wipe;
      titleText = null;
      _recoveryKeyStored = false;
      bootstrap = widget.client.encryption
          .bootstrap(onUpdate: () => setState(() => null));
    });
  }

  @override
  Widget build(BuildContext context) {
    _wipe ??= widget.wipe;
    final buttons = <AdaptiveFlatButton>[];
    Widget body = LinearProgressIndicator();
    titleText = L10n.of(context).loadingPleaseWait;

    if (bootstrap == null) {
      titleText = L10n.of(context).chatBackup;
      body = Text(L10n.of(context).chatBackupDescription);
      buttons.add(AdaptiveFlatButton(
        label: L10n.of(context).next,
        onPressed: () => _createBootstrap(false),
      ));
    } else if (bootstrap.newSsssKey?.recoveryKey != null &&
        _recoveryKeyStored == false) {
      final key = bootstrap.newSsssKey.recoveryKey;
      titleText = L10n.of(context).securityKey;
      body = Container(
        alignment: Alignment.center,
        width: 200,
        height: 128,
        child: Text(
          key,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            wordSpacing: 38,
            fontFamily: 'monospace',
          ),
        ),
      );
      buttons.add(AdaptiveFlatButton(
        label: L10n.of(context).copyToClipboard,
        onPressed: () => Clipboard.setData(ClipboardData(text: key)),
      ));
      buttons.add(AdaptiveFlatButton(
        label: L10n.of(context).next,
        onPressed: () => setState(() => _recoveryKeyStored = true),
      ));
    } else {
      switch (bootstrap.state) {
        case BootstrapState.loading:
          break;
        case BootstrapState.askWipeSsss:
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.wipeSsss(_wipe),
          );
          break;
        case BootstrapState.askUseExistingSsss:
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.useExistingSsss(!_wipe),
          );
          break;
        case BootstrapState.askUnlockSsss:
          throw Exception('This state is not supposed to be implemented');
        case BootstrapState.askNewSsss:
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.newSsss(),
          );
          break;
        case BootstrapState.openExistingSsss:
          _recoveryKeyStored = true;
          titleText =
              _recoveryKeyInputError ?? L10n.of(context).pleaseEnterSecurityKey;
          body = PlatformInfos.isCupertinoStyle
              ? CupertinoTextField(
                  minLines: 1,
                  maxLines: 1,
                  autofocus: true,
                  autocorrect: false,
                  autofillHints: _recoveryKeyInputLoading
                      ? null
                      : [AutofillHints.password],
                  controller: _recoveryKeyTextEditingController,
                )
              : TextField(
                  minLines: 1,
                  maxLines: 1,
                  autofocus: true,
                  autocorrect: false,
                  autofillHints: _recoveryKeyInputLoading
                      ? null
                      : [AutofillHints.password],
                  controller: _recoveryKeyTextEditingController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: false,
                    hintText: L10n.of(context).securityKey,
                  ),
                );
          buttons.add(AdaptiveFlatButton(
              label: L10n.of(context).unlockChatBackup,
              onPressed: () async {
                setState(() {
                  _recoveryKeyInputError = null;
                  _recoveryKeyInputLoading = true;
                });
                try {
                  await bootstrap.newSsssKey.unlock(
                    keyOrPassphrase: _recoveryKeyTextEditingController.text,
                  );
                  await bootstrap.openExistingSsss();
                } catch (e, s) {
                  Logs().w('Unable to unlock SSSS', e, s);
                  setState(() => _recoveryKeyInputError =
                      L10n.of(context).oopsSomethingWentWrong);
                } finally {
                  setState(() => _recoveryKeyInputLoading = false);
                }
              }));
          buttons.add(AdaptiveFlatButton(
            label: L10n.of(context).transferFromAnotherDevice,
            onPressed: () async {
              final req = await showFutureLoadingDialog(
                context: context,
                future: () => widget.client.userDeviceKeys[widget.client.userID]
                    .startVerification(),
              );
              if (req.error != null) return;
              await KeyVerificationDialog(request: req.result).show(context);
              Navigator.of(context, rootNavigator: false).pop();
            },
          ));
          buttons.add(AdaptiveFlatButton(
            textColor: Colors.red,
            label: L10n.of(context).securityKeyLost,
            onPressed: () async {
              if (OkCancelResult.ok ==
                  await showOkCancelAlertDialog(
                    useRootNavigator: false,
                    context: context,
                    title: L10n.of(context).securityKeyLost,
                    message: L10n.of(context).wipeChatBackup,
                    okLabel: L10n.of(context).ok,
                    cancelLabel: L10n.of(context).cancel,
                    isDestructiveAction: true,
                  )) {
                _createBootstrap(true);
              }
            },
          ));
          break;
        case BootstrapState.askWipeCrossSigning:
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.wipeCrossSigning(_wipe),
          );
          break;
        case BootstrapState.askSetupCrossSigning:
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.askSetupCrossSigning(
              setupMasterKey: true,
              setupSelfSigningKey: true,
              setupUserSigningKey: true,
            ),
          );
          break;
        case BootstrapState.askWipeOnlineKeyBackup:
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.wipeOnlineKeyBackup(_wipe),
          );

          break;
        case BootstrapState.askSetupOnlineKeyBackup:
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.askSetupOnlineKeyBackup(true),
          );
          break;
        case BootstrapState.askBadSsss:
        case BootstrapState.error:
          titleText = L10n.of(context).oopsSomethingWentWrong;
          body = ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.error_outline, color: Colors.red),
            title: Text(L10n.of(context).oopsSomethingWentWrong),
          );
          buttons.add(AdaptiveFlatButton(
            label: L10n.of(context).close,
            onPressed: () =>
                Navigator.of(context, rootNavigator: false).pop<bool>(false),
          ));
          break;
        case BootstrapState.done:
          titleText = L10n.of(context).everythingReady;
          body = ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text(L10n.of(context).keysCached),
          );
          buttons.add(AdaptiveFlatButton(
            label: L10n.of(context).close,
            onPressed: () =>
                Navigator.of(context, rootNavigator: false).pop<bool>(false),
          ));
          break;
      }
    }

    final title = Text(titleText);
    if (PlatformInfos.isCupertinoStyle) {
      return CupertinoAlertDialog(
        title: title,
        content: body,
        actions: buttons,
      );
    }
    return AlertDialog(
      title: title,
      content: body,
      actions: buttons,
    );
  }
}
