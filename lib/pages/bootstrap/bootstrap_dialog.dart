import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/encryption/utils/bootstrap.dart';
import 'package:matrix/matrix.dart';
import 'package:share_plus/share_plus.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/adaptive_flat_button.dart';
import '../key_verification/key_verification_dialog.dart';

class BootstrapDialog extends StatefulWidget {
  final bool wipe;
  final Client client;
  const BootstrapDialog({
    Key? key,
    this.wipe = false,
    required this.client,
  }) : super(key: key);

  Future<bool?> show(BuildContext context) => PlatformInfos.isCupertinoStyle
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

  late Bootstrap bootstrap;

  String? _recoveryKeyInputError;

  bool _recoveryKeyInputLoading = false;

  String? titleText;

  bool _recoveryKeyStored = false;
  bool _recoveryKeyCopied = false;

  bool? _wipe;

  @override
  void initState() {
    _createBootstrap(widget.wipe);
    super.initState();
  }

  void _createBootstrap(bool wipe) {
    _wipe = wipe;
    titleText = null;
    _recoveryKeyStored = false;
    bootstrap =
        widget.client.encryption!.bootstrap(onUpdate: () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    _wipe ??= widget.wipe;
    final buttons = <AdaptiveFlatButton>[];
    Widget body = PlatformInfos.isCupertinoStyle
        ? const CupertinoActivityIndicator()
        : const LinearProgressIndicator();
    titleText = L10n.of(context)!.loadingPleaseWait;

    if (bootstrap.newSsssKey?.recoveryKey != null &&
        _recoveryKeyStored == false) {
      final key = bootstrap.newSsssKey!.recoveryKey;
      titleText = L10n.of(context)!.securityKey;
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: Navigator.of(context).pop,
          ),
          title: Text(L10n.of(context)!.securityKey),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: FluffyThemes.columnWidth * 1.5),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  L10n.of(context)!.chatBackupDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Divider(height: 64),
                TextField(
                  minLines: 4,
                  maxLines: 4,
                  readOnly: true,
                  controller: TextEditingController(text: key),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save_alt_outlined),
                  label: Text(L10n.of(context)!.saveTheSecurityKeyNow),
                  onPressed: () {
                    Share.share(key!);
                    setState(() => _recoveryKeyCopied = true);
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).secondaryHeaderColor,
                    onPrimary: Theme.of(context).primaryColor,
                  ),
                  icon: const Icon(Icons.check_outlined),
                  label: Text(L10n.of(context)!.next),
                  onPressed: _recoveryKeyCopied
                      ? () => setState(() => _recoveryKeyStored = true)
                      : null,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      switch (bootstrap.state) {
        case BootstrapState.loading:
          break;
        case BootstrapState.askWipeSsss:
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) => bootstrap.wipeSsss(_wipe!),
          );
          break;
        case BootstrapState.askBadSsss:
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) => bootstrap.ignoreBadSecrets(true),
          );
          break;
        case BootstrapState.askUseExistingSsss:
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) => bootstrap.useExistingSsss(!_wipe!),
          );
          break;
        case BootstrapState.askUnlockSsss:
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) => bootstrap.unlockedSsss(),
          );
          break;
        case BootstrapState.askNewSsss:
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) => bootstrap.newSsss(),
          );
          break;
        case BootstrapState.openExistingSsss:
          _recoveryKeyStored = true;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(context).pop,
              ),
              title: Text(L10n.of(context)!.pleaseEnterSecurityKey),
            ),
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxWidth: FluffyThemes.columnWidth * 1.5),
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Text(
                      L10n.of(context)!.pleaseEnterSecurityKeyDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Divider(height: 64),
                    TextField(
                      minLines: 1,
                      maxLines: 1,
                      autocorrect: false,
                      readOnly: _recoveryKeyInputLoading,
                      autofillHints: _recoveryKeyInputLoading
                          ? null
                          : [AutofillHints.password],
                      controller: _recoveryKeyTextEditingController,
                      decoration: InputDecoration(
                        hintText: 'Abc123 Def456',
                        labelText: L10n.of(context)!.securityKey,
                        errorText: _recoveryKeyInputError,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                        icon: _recoveryKeyInputLoading
                            ? const CircularProgressIndicator.adaptive()
                            : const Icon(Icons.lock_open_outlined),
                        label: Text(L10n.of(context)!.unlockChatBackup),
                        onPressed: _recoveryKeyInputLoading
                            ? null
                            : () async {
                                setState(() {
                                  _recoveryKeyInputError = null;
                                  _recoveryKeyInputLoading = true;
                                });
                                try {
                                  final key =
                                      _recoveryKeyTextEditingController.text;
                                  await bootstrap.newSsssKey!.unlock(
                                    keyOrPassphrase: key,
                                  );
                                  Logs().d('SSSS unlocked');
                                  await bootstrap
                                      .client.encryption!.crossSigning
                                      .selfSign(
                                    keyOrPassphrase: key,
                                  );
                                  Logs().d('Successful elfsigned');
                                  await bootstrap.openExistingSsss();
                                } catch (e, s) {
                                  Logs().w('Unable to unlock SSSS', e, s);
                                  setState(() => _recoveryKeyInputError =
                                      L10n.of(context)!.oopsSomethingWentWrong);
                                } finally {
                                  setState(
                                      () => _recoveryKeyInputLoading = false);
                                }
                              }),
                    const SizedBox(height: 32),
                    Row(children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(L10n.of(context)!.or),
                      ),
                      const Expanded(child: Divider()),
                    ]),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).secondaryHeaderColor,
                        onPrimary: Theme.of(context).primaryColor,
                      ),
                      icon: const Icon(Icons.cast_connected_outlined),
                      label: Text(L10n.of(context)!.transferFromAnotherDevice),
                      onPressed: _recoveryKeyInputLoading
                          ? null
                          : () async {
                              final req = await showFutureLoadingDialog(
                                context: context,
                                future: () => widget.client
                                    .userDeviceKeys[widget.client.userID!]!
                                    .startVerification(),
                              );
                              if (req.error != null) return;
                              await KeyVerificationDialog(request: req.result!)
                                  .show(context);
                              Navigator.of(context, rootNavigator: false).pop();
                            },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).secondaryHeaderColor,
                        onPrimary: Colors.red,
                      ),
                      icon: const Icon(Icons.delete_outlined),
                      label: Text(L10n.of(context)!.securityKeyLost),
                      onPressed: _recoveryKeyInputLoading
                          ? null
                          : () async {
                              if (OkCancelResult.ok ==
                                  await showOkCancelAlertDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    title: L10n.of(context)!.securityKeyLost,
                                    message: L10n.of(context)!.wipeChatBackup,
                                    okLabel: L10n.of(context)!.ok,
                                    cancelLabel: L10n.of(context)!.cancel,
                                    isDestructiveAction: true,
                                  )) {
                                setState(() => _createBootstrap(true));
                              }
                            },
                    )
                  ],
                ),
              ),
            ),
          );
        case BootstrapState.askWipeCrossSigning:
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) => bootstrap.wipeCrossSigning(_wipe!),
          );
          break;
        case BootstrapState.askSetupCrossSigning:
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) => bootstrap.askSetupCrossSigning(
              setupMasterKey: true,
              setupSelfSigningKey: true,
              setupUserSigningKey: true,
            ),
          );
          break;
        case BootstrapState.askWipeOnlineKeyBackup:
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) => bootstrap.wipeOnlineKeyBackup(_wipe!),
          );

          break;
        case BootstrapState.askSetupOnlineKeyBackup:
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) => bootstrap.askSetupOnlineKeyBackup(true),
          );
          break;
        case BootstrapState.error:
          titleText = L10n.of(context)!.oopsSomethingWentWrong;
          body = const Icon(Icons.error_outline, color: Colors.red, size: 40);
          buttons.add(AdaptiveFlatButton(
            label: L10n.of(context)!.close,
            onPressed: () =>
                Navigator.of(context, rootNavigator: false).pop<bool>(false),
          ));
          break;
        case BootstrapState.done:
          titleText = L10n.of(context)!.everythingReady;
          body = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/backup.png', fit: BoxFit.contain),
              Text(L10n.of(context)!.yourChatBackupHasBeenSetUp),
            ],
          );
          buttons.add(AdaptiveFlatButton(
            label: L10n.of(context)!.close,
            onPressed: () =>
                Navigator.of(context, rootNavigator: false).pop<bool>(false),
          ));
          break;
      }
    }

    final title = Text(titleText!);
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
