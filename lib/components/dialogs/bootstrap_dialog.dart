import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/encryption.dart';
import 'package:famedlysdk/encryption/utils/bootstrap.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/adaptive_flat_button.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class BootstrapDialog extends StatefulWidget {
  const BootstrapDialog({
    Key key,
    @required this.l10n,
    @required this.client,
    this.easyMode = false,
  }) : super(key: key);

  Future<bool> show(BuildContext context) => PlatformInfos.isCupertinoStyle
      ? showCupertinoDialog(context: context, builder: (context) => this)
      : showDialog(context: context, builder: (context) => this);

  final L10n l10n;
  final Client client;
  final bool easyMode;

  @override
  _BootstrapDialogState createState() => _BootstrapDialogState();
}

class _BootstrapDialogState extends State<BootstrapDialog> {
  Bootstrap bootstrap;

  @override
  Widget build(BuildContext context) {
    bootstrap ??= widget.client.encryption
        .bootstrap(onUpdate: () => setState(() => null));

    final buttons = <AdaptiveFlatButton>[];
    Widget body;
    var titleText = widget.l10n.cachedKeys;

    switch (bootstrap.state) {
      case BootstrapState.loading:
        body = LinearProgressIndicator();
        titleText = widget.l10n.loadingPleaseWait;
        break;
      case BootstrapState.askWipeSsss:
        body = Text('Wipe chat backup?');
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.yes),
          onPressed: () => bootstrap.wipeSsss(true),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(widget.l10n.no),
          onPressed: () => bootstrap.wipeSsss(false),
        ));
        break;
      case BootstrapState.askUseExistingSsss:
        body = Text('Use existing chat backup?');
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.yes),
          onPressed: () => bootstrap.useExistingSsss(true),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(widget.l10n.no),
          onPressed: () => bootstrap.useExistingSsss(false),
        ));
        break;
      case BootstrapState.askBadSsss:
        body = Text('SSSS bad - continue nevertheless? DATALOSS!!!');
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.yes),
          onPressed: () => bootstrap.ignoreBadSecrets(true),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(widget.l10n.no),
          onPressed: () => bootstrap.ignoreBadSecrets(false),
        ));
        break;
      case BootstrapState.askUnlockSsss:
        final widgets = <Widget>[Text('Unlock old SSSS')];
        for (final entry in bootstrap.oldSsssKeys.entries) {
          final keyId = entry.key;
          final key = entry.value;
          widgets
              .add(Flexible(child: _AskUnlockOldSsss(keyId, key, widget.l10n)));
        }
        body = Column(
          children: widgets,
          mainAxisSize: MainAxisSize.min,
        );
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.confirm),
          onPressed: () => bootstrap.unlockedSsss(),
        ));
        break;
      case BootstrapState.askNewSsss:
        body = Text('Please set a long passphrase to secure your backup.');
        buttons.add(AdaptiveFlatButton(
            child: Text('Enter a new passphrase'),
            onPressed: () async {
              final input =
                  await showTextInputDialog(context: context, textFields: [
                DialogTextField(
                  minLines: 1,
                  maxLines: 1,
                  obscureText: true,
                )
              ]);
              if (input?.isEmpty ?? true) return;
              await bootstrap.newSsss(input.single);
            }));
        break;
      case BootstrapState.openExistingSsss:
        body = Text('Please enter your passphrase!');
        buttons.add(AdaptiveFlatButton(
            child: Text('Enter passphrase'),
            onPressed: () async {
              final input =
                  await showTextInputDialog(context: context, textFields: [
                DialogTextField(
                  minLines: 1,
                  maxLines: 1,
                  obscureText: true,
                )
              ]);
              if (input?.isEmpty ?? true) return;
              final valid = await showFutureLoadingDialog(
                context: context,
                future: () =>
                    bootstrap.newSsssKey.unlock(keyOrPassphrase: input.single),
              );
              if (valid.error == null) await bootstrap.openExistingSsss();
            }));
        break;
      case BootstrapState.askWipeCrossSigning:
        body = Text('Wipe cross-signing?');
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.yes),
          onPressed: () => bootstrap.wipeCrossSigning(true),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(widget.l10n.no),
          onPressed: () => bootstrap.wipeCrossSigning(false),
        ));
        break;
      case BootstrapState.askSetupCrossSigning:
        body = Text('Set up cross-signing?');
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.yes),
          onPressed: () => bootstrap.askSetupCrossSigning(
            setupMasterKey: true,
            setupSelfSigningKey: true,
            setupUserSigningKey: true,
          ),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(widget.l10n.no),
          onPressed: () => bootstrap.askSetupCrossSigning(),
        ));
        break;
      case BootstrapState.askWipeOnlineKeyBackup:
        body = Text('Wipe chat backup?');
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.yes),
          onPressed: () => bootstrap.wipeOnlineKeyBackup(true),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(widget.l10n.no),
          onPressed: () => bootstrap.wipeOnlineKeyBackup(false),
        ));
        break;
      case BootstrapState.askSetupOnlineKeyBackup:
        body = Text('Set up chat backup?');
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.yes),
          onPressed: () => bootstrap.askSetupOnlineKeyBackup(true),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(widget.l10n.no),
          onPressed: () => bootstrap.askSetupOnlineKeyBackup(false),
        ));
        break;
      case BootstrapState.error:
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
        body = ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Chat backup has been initialized!'),
        );
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.close),
          onPressed: () => Navigator.of(context).pop<bool>(false),
        ));
        break;
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

class _AskUnlockOldSsss extends StatefulWidget {
  final String keyId;
  final OpenSSSS ssssKey;
  final L10n l10n;
  _AskUnlockOldSsss(this.keyId, this.ssssKey, this.l10n);

  @override
  _AskUnlockOldSsssState createState() => _AskUnlockOldSsssState();
}

class _AskUnlockOldSsssState extends State<_AskUnlockOldSsss> {
  bool valid = false;
  TextEditingController textEditingController = TextEditingController();
  String input;

  void checkInput(BuildContext context) async {
    if (input == null) {
      return;
    }

    valid = (await showFutureLoadingDialog(
          context: context,
          future: () => widget.ssssKey.unlock(keyOrPassphrase: input),
        ))
            .error ==
        null;
    setState(() => null);
  }

  @override
  Widget build(BuildContext build) {
    if (valid) {
      return Row(
        children: <Widget>[
          Text(widget.keyId),
          Text('unlocked'),
        ],
        mainAxisSize: MainAxisSize.min,
      );
    }
    return Row(
      children: <Widget>[
        Text(widget.keyId),
        Flexible(
          child: TextField(
            controller: textEditingController,
            autofocus: false,
            autocorrect: false,
            onSubmitted: (s) {
              input = s;
              checkInput(context);
            },
            minLines: 1,
            maxLines: 1,
            obscureText: true,
            decoration: InputDecoration(
              hintText: widget.l10n.passphraseOrKey,
              prefixStyle: TextStyle(color: Theme.of(context).primaryColor),
              suffixStyle: TextStyle(color: Theme.of(context).primaryColor),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          elevation: 5,
          textColor: Colors.white,
          child: Text(widget.l10n.submit),
          onPressed: () {
            input = textEditingController.text;
            checkInput(context);
          },
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}
