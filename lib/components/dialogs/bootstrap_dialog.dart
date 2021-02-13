import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/encryption.dart';
import 'package:famedlysdk/encryption/utils/bootstrap.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/adaptive_flat_button.dart';
import 'package:flutter/services.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'key_verification_dialog.dart';

class BootstrapDialog extends StatefulWidget {
  final bool wipe;
  const BootstrapDialog({
    Key key,
    @required this.l10n,
    @required this.client,
    this.wipe = false,
  }) : super(key: key);

  Future<bool> show(BuildContext context) => PlatformInfos.isCupertinoStyle
      ? showCupertinoDialog(context: context, builder: (context) => this)
      : showDialog(context: context, builder: (context) => this);

  final L10n l10n;
  final Client client;

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
    titleText = widget.l10n.loadingPleaseWait;

    if (bootstrap == null) {
      titleText = widget.l10n.chatBackup;
      body = Text(widget.l10n.chatBackupDescription);
      buttons.add(AdaptiveFlatButton(
        child: Text(widget.l10n.next),
        onPressed: () => _createBootstrap(false),
      ));
    } else if (bootstrap.newSsssKey?.recoveryKey != null &&
        _recoveryKeyStored == false) {
      final key = bootstrap.newSsssKey.recoveryKey;
      titleText = widget.l10n.securityKey;
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
          ),
        ),
      );
      buttons.add(AdaptiveFlatButton(
        child: Text(widget.l10n.copyToClipboard),
        onPressed: () => Clipboard.setData(ClipboardData(text: key)),
      ));
      buttons.add(AdaptiveFlatButton(
        child: Text(widget.l10n.next),
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
              _recoveryKeyInputError ?? widget.l10n.pleaseEnterSecurityKey;
          body = PlatformInfos.isCupertinoStyle
              ? CupertinoTextField(
                  minLines: 2,
                  maxLines: 2,
                  autofocus: true,
                  autocorrect: false,
                  autofillHints: _recoveryKeyInputLoading
                      ? null
                      : [AutofillHints.password],
                  controller: _recoveryKeyTextEditingController,
                )
              : TextField(
                  minLines: 2,
                  maxLines: 2,
                  autofocus: true,
                  autocorrect: false,
                  autofillHints: _recoveryKeyInputLoading
                      ? null
                      : [AutofillHints.password],
                  controller: _recoveryKeyTextEditingController,
                );
          buttons.add(AdaptiveFlatButton(
            textColor: Colors.red,
            child: Text('Lost security key'),
            onPressed: () async {
              if (OkCancelResult.ok ==
                  await showOkCancelAlertDialog(
                    context: context,
                    title: widget.l10n.securityKeyLost,
                    message: widget.l10n.wipeChatBackup,
                    isDestructiveAction: true,
                  )) {
                _createBootstrap(true);
              }
            },
          ));
          buttons.add(AdaptiveFlatButton(
            child: Text(widget.l10n.transferFromAnotherDevice),
            onPressed: () async {
              final req = await widget
                  .client.userDeviceKeys[widget.client.userID]
                  .startVerification();
              await KeyVerificationDialog(
                request: req,
                l10n: widget.l10n,
              ).show(context);
              Navigator.of(context).pop();
            },
          ));
          buttons.add(AdaptiveFlatButton(
              child: Text(widget.l10n.next),
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
                      widget.l10n.oopsSomethingWentWrong);
                } finally {
                  setState(() => _recoveryKeyInputLoading = false);
                }
              }));
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
          titleText = widget.l10n.oopsSomethingWentWrong;
          body = ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.error_outline, color: Colors.red),
            title: Text(widget.l10n.oopsSomethingWentWrong),
          );
          buttons.add(AdaptiveFlatButton(
            child: Text(widget.l10n.close),
            onPressed: () => Navigator.of(context).pop<bool>(false),
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
            child: Text(widget.l10n.close),
            onPressed: () => Navigator.of(context).pop<bool>(false),
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
