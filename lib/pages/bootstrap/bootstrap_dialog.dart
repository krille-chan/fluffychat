import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/error_reporter.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sync_status_localization.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../key_verification/key_verification_dialog.dart';

class BootstrapDialog extends StatefulWidget {
  final bool wipe;

  const BootstrapDialog({
    super.key,
    this.wipe = false,
  });

  @override
  BootstrapDialogState createState() => BootstrapDialogState();
}

class BootstrapDialogState extends State<BootstrapDialog> {
  final TextEditingController _recoveryKeyTextEditingController =
      TextEditingController();

  Bootstrap? bootstrap;

  String? _recoveryKeyInputError;

  bool _recoveryKeyInputLoading = false;

  String? titleText;

  bool _recoveryKeyStored = false;
  bool _recoveryKeyCopied = false;

  bool? _storeInSecureStorage = false;

  bool? _wipe;

  String get _secureStorageKey =>
      'ssss_recovery_key_${bootstrap!.client.userID}';

  bool get _supportsSecureStorage =>
      PlatformInfos.isMobile || PlatformInfos.isDesktop;

  String _getSecureStorageLocalizedName() {
    if (PlatformInfos.isAndroid) {
      return L10n.of(context).storeInAndroidKeystore;
    }
    if (PlatformInfos.isIOS || PlatformInfos.isMacOS) {
      return L10n.of(context).storeInAppleKeyChain;
    }
    return L10n.of(context).storeSecurlyOnThisDevice;
  }

  late final Client client;

  @override
  void initState() {
    super.initState();
    client = Matrix.of(context).client;
    _createBootstrap(widget.wipe);
  }

  void _cancelAction() async {
    final consent = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context).skipChatBackup,
      message: L10n.of(context).skipChatBackupWarning,
      okLabel: L10n.of(context).skip,
      isDestructive: true,
    );
    if (consent != OkCancelResult.ok) return;
    if (!mounted) return;
    _goBackAction(false);
  }

  void _goBackAction(bool success) {
    if (success) _decryptLastEvents();

    context.canPop() ? context.pop(success) : context.go('/rooms');
  }

  void _decryptLastEvents() async {
    for (final room in client.rooms) {
      final event = room.lastEvent;
      if (event != null &&
          event.type == EventTypes.Encrypted &&
          event.messageType == MessageTypes.BadEncrypted &&
          event.content['can_request_session'] == true) {
        final sessionId = event.content.tryGet<String>('session_id');
        final senderKey = event.content.tryGet<String>('sender_key');
        if (sessionId != null && senderKey != null) {
          room.client.encryption?.keyManager.maybeAutoRequest(
            room.id,
            sessionId,
            senderKey,
          );
        }
      }
    }
  }

  void _createBootstrap(bool wipe) async {
    await client.roomsLoading;
    await client.accountDataLoading;
    await client.userDeviceKeysLoading;
    while (client.prevBatch == null) {
      await client.onSync.stream.first;
    }
    _wipe = wipe;
    titleText = null;
    _recoveryKeyStored = false;
    bootstrap = client.encryption!.bootstrap(onUpdate: (_) => setState(() {}));
    final key = await const FlutterSecureStorage().read(key: _secureStorageKey);
    if (key == null) return;
    _recoveryKeyTextEditingController.text = key;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bootstrap = this.bootstrap;
    if (bootstrap == null) {
      return LoginScaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: CloseButton(onPressed: _cancelAction),
          title: Text(L10n.of(context).loadingMessages),
        ),
        body: Center(
          child: StreamBuilder(
            stream: client.onSyncStatus.stream,
            builder: (context, snapshot) {
              final status = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(value: status?.progress),
                  if (status != null) Text(status.calcLocalizedString(context)),
                ],
              );
            },
          ),
        ),
      );
    }

    _wipe ??= widget.wipe;
    final buttons = <Widget>[];
    Widget body = const Center(child: CircularProgressIndicator.adaptive());
    titleText = L10n.of(context).loadingPleaseWait;

    if (bootstrap.newSsssKey?.recoveryKey != null &&
        _recoveryKeyStored == false) {
      final key = bootstrap.newSsssKey!.recoveryKey;
      titleText = L10n.of(context).recoveryKey;
      return LoginScaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: CloseButton(onPressed: _cancelAction),
          title: Text(L10n.of(context).recoveryKey),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: FluffyThemes.columnWidth * 1.5),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.info_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  subtitle: Text(L10n.of(context).chatBackupDescription),
                ),
                const Divider(
                  height: 32,
                  thickness: 1,
                ),
                TextField(
                  minLines: 2,
                  maxLines: 4,
                  readOnly: true,
                  style: const TextStyle(fontFamily: 'RobotoMono'),
                  controller: TextEditingController(text: key),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    suffixIcon: Icon(Icons.key_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                if (_supportsSecureStorage)
                  CheckboxListTile.adaptive(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    value: _storeInSecureStorage,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (b) {
                      setState(() {
                        _storeInSecureStorage = b;
                      });
                    },
                    title: Text(_getSecureStorageLocalizedName()),
                    subtitle:
                        Text(L10n.of(context).storeInSecureStorageDescription),
                  ),
                const SizedBox(height: 16),
                CheckboxListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  value: _recoveryKeyCopied,
                  activeColor: theme.colorScheme.primary,
                  onChanged: (b) {
                    FluffyShare.share(key!, context);
                    setState(() => _recoveryKeyCopied = true);
                  },
                  title: Text(L10n.of(context).copyToClipboard),
                  subtitle: Text(L10n.of(context).saveKeyManuallyDescription),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_outlined),
                  label: Text(L10n.of(context).next),
                  onPressed:
                      (_recoveryKeyCopied || _storeInSecureStorage == true)
                          ? () {
                              if (_storeInSecureStorage == true) {
                                const FlutterSecureStorage().write(
                                  key: _secureStorageKey,
                                  value: key,
                                );
                              }
                              setState(() => _recoveryKeyStored = true);
                            }
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
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.wipeSsss(_wipe!),
          );
          break;
        case BootstrapState.askBadSsss:
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.ignoreBadSecrets(true),
          );
          break;
        case BootstrapState.askUseExistingSsss:
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.useExistingSsss(!_wipe!),
          );
          break;
        case BootstrapState.askUnlockSsss:
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.unlockedSsss(),
          );
          break;
        case BootstrapState.askNewSsss:
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.newSsss(),
          );
          break;
        case BootstrapState.openExistingSsss:
          _recoveryKeyStored = true;
          return LoginScaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: CloseButton(onPressed: _cancelAction),
              title: Text(L10n.of(context).setupChatBackup),
            ),
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: FluffyThemes.columnWidth * 1.5,
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                      trailing: Icon(
                        Icons.info_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      subtitle: Text(
                        L10n.of(context).pleaseEnterRecoveryKeyDescription,
                      ),
                    ),
                    const Divider(height: 32),
                    TextField(
                      minLines: 1,
                      maxLines: 2,
                      autocorrect: false,
                      readOnly: _recoveryKeyInputLoading,
                      autofillHints: _recoveryKeyInputLoading
                          ? null
                          : [AutofillHints.password],
                      controller: _recoveryKeyTextEditingController,
                      style: const TextStyle(fontFamily: 'RobotoMono'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16),
                        hintStyle: TextStyle(
                          fontFamily: theme.textTheme.bodyLarge?.fontFamily,
                        ),
                        prefixIcon: const Icon(Icons.key_outlined),
                        labelText: L10n.of(context).recoveryKey,
                        hintText: 'Es** **** **** ****',
                        errorText: _recoveryKeyInputError,
                        errorMaxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: theme.colorScheme.onPrimary,
                        iconColor: theme.colorScheme.onPrimary,
                        backgroundColor: theme.colorScheme.primary,
                      ),
                      icon: _recoveryKeyInputLoading
                          ? const CircularProgressIndicator.adaptive()
                          : const Icon(Icons.lock_open_outlined),
                      label: Text(L10n.of(context).unlockOldMessages),
                      onPressed: _recoveryKeyInputLoading
                          ? null
                          : () async {
                              setState(() {
                                _recoveryKeyInputError = null;
                                _recoveryKeyInputLoading = true;
                              });
                              try {
                                final key = _recoveryKeyTextEditingController
                                    .text
                                    .trim();
                                if (key.isEmpty) return;
                                await bootstrap.newSsssKey!.unlock(
                                  keyOrPassphrase: key,
                                );
                                await bootstrap.openExistingSsss();
                                Logs().d('SSSS unlocked');
                                if (bootstrap.encryption.crossSigning.enabled) {
                                  Logs().v(
                                    'Cross signing is already enabled. Try to self-sign',
                                  );
                                  try {
                                    await bootstrap
                                        .client.encryption!.crossSigning
                                        .selfSign(recoveryKey: key);
                                    Logs().d('Successful selfsigned');
                                  } catch (e, s) {
                                    Logs().e(
                                      'Unable to self sign with recovery key after successfully open existing SSSS',
                                      e,
                                      s,
                                    );
                                  }
                                }
                              } on InvalidPassphraseException catch (e) {
                                setState(
                                  () => _recoveryKeyInputError =
                                      e.toLocalizedString(context),
                                );
                              } on FormatException catch (_) {
                                setState(
                                  () => _recoveryKeyInputError =
                                      L10n.of(context).wrongRecoveryKey,
                                );
                              } catch (e, s) {
                                ErrorReporter(
                                  context,
                                  'Unable to open SSSS with recovery key',
                                ).onErrorCallback(e, s);
                                setState(
                                  () => _recoveryKeyInputError =
                                      e.toLocalizedString(context),
                                );
                              } finally {
                                setState(
                                  () => _recoveryKeyInputLoading = false,
                                );
                              }
                            },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(L10n.of(context).or),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.cast_connected_outlined),
                      label: Text(L10n.of(context).transferFromAnotherDevice),
                      onPressed: _recoveryKeyInputLoading
                          ? null
                          : () async {
                              final consent = await showOkCancelAlertDialog(
                                context: context,
                                title: L10n.of(context).verifyOtherDevice,
                                message: L10n.of(context)
                                    .verifyOtherDeviceDescription,
                                okLabel: L10n.of(context).ok,
                                cancelLabel: L10n.of(context).cancel,
                              );
                              if (consent != OkCancelResult.ok) return;
                              final req = await showFutureLoadingDialog(
                                context: context,
                                delay: false,
                                future: () async {
                                  await client.updateUserDeviceKeys();
                                  return client.userDeviceKeys[client.userID!]!
                                      .startVerification();
                                },
                              );
                              if (req.error != null) return;
                              final success = await KeyVerificationDialog(
                                request: req.result!,
                              ).show(context);
                              if (success != true) return;
                              if (!mounted) return;

                              final waitForSecret = Completer();
                              final secretsSub = client
                                  .encryption!.ssss.onSecretStored.stream
                                  .listen((
                                event,
                              ) async {
                                if (await client.encryption!.keyManager
                                        .isCached() &&
                                    await client.encryption!.crossSigning
                                        .isCached()) {
                                  waitForSecret.complete();
                                }
                              });

                              final result = await showFutureLoadingDialog(
                                context: context,
                                future: () => waitForSecret.future,
                              );
                              await secretsSub.cancel();
                              if (!mounted) return;
                              if (!result.isError) _goBackAction(true);
                            },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.errorContainer,
                        foregroundColor: theme.colorScheme.onErrorContainer,
                        iconColor: theme.colorScheme.onErrorContainer,
                      ),
                      icon: const Icon(Icons.delete_outlined),
                      label: Text(L10n.of(context).recoveryKeyLost),
                      onPressed: _recoveryKeyInputLoading
                          ? null
                          : () async {
                              if (OkCancelResult.ok ==
                                  await showOkCancelAlertDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    title: L10n.of(context).recoveryKeyLost,
                                    message: L10n.of(context).wipeChatBackup,
                                    okLabel: L10n.of(context).ok,
                                    cancelLabel: L10n.of(context).cancel,
                                    isDestructive: true,
                                  )) {
                                setState(() => _createBootstrap(true));
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),
          );
        case BootstrapState.askWipeCrossSigning:
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.wipeCrossSigning(_wipe!),
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
            (_) => bootstrap.wipeOnlineKeyBackup(_wipe!),
          );

          break;
        case BootstrapState.askSetupOnlineKeyBackup:
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => bootstrap.askSetupOnlineKeyBackup(true),
          );
          break;
        case BootstrapState.error:
          titleText = L10n.of(context).oopsSomethingWentWrong;
          body = const Icon(Icons.error_outline, color: Colors.red, size: 80);
          buttons.add(
            ElevatedButton(
              onPressed: () => _goBackAction(false),
              child: Text(L10n.of(context).close),
            ),
          );
          break;
        case BootstrapState.done:
          titleText = L10n.of(context).everythingReady;
          body = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 120,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                L10n.of(context).yourChatBackupHasBeenSetUp,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
            ],
          );
          buttons.add(
            ElevatedButton(
              onPressed: () => _goBackAction(true),
              child: Text(L10n.of(context).close),
            ),
          );
          break;
      }
    }

    return LoginScaffold(
      appBar: AppBar(
        leading: CloseButton(onPressed: _cancelAction),
        title: Text(titleText ?? L10n.of(context).loadingPleaseWait),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              body,
              const SizedBox(height: 8),
              ...buttons,
            ],
          ),
        ),
      ),
    );
  }
}
