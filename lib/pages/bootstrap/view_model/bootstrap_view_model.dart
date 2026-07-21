// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:file_picker/file_picker.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/error_reporter.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';

import 'bootstrap_state.dart';

class BootstrapViewModel extends ValueNotifier<BootstrapViewModelState> {
  final Client client;
  final bool reset;

  final TextEditingController enterPassphraseOrRecovController =
      TextEditingController();
  final TextEditingController newPassphraseController = TextEditingController();
  final TextEditingController repeatPassphraseController =
      TextEditingController();
  final ScrollController devicesScrollController = ScrollController();

  BootstrapViewModel({required this.client, required this.reset})
    : super(BootstrapViewModelState()..reset = reset) {
    _init();
  }

  @override
  void dispose() {
    _cancelKeyVerification();
    enterPassphraseOrRecovController.dispose();
    newPassphraseController.dispose();
    repeatPassphraseController.dispose();
    devicesScrollController.dispose();
    super.dispose();
  }

  void _checkCanCreatePassphrase([_]) {
    final passphrase = newPassphraseController.text;
    value.newPassphraseEqualsRepeatPassphrase =
        passphrase.isNotEmpty && passphrase == repeatPassphraseController.text;
    value.newPassphraseLongEnough = passphrase.length >= 12;
    value.newPassphraseUpperAndLowerCase =
        passphrase.contains(RegExp(r'[A-Z]')) &&
        passphrase.contains(RegExp(r'[a-z]'));
    value.newPassphraseSpecialCharacters = passphrase.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    );
    value.newPassphraseNumbers = passphrase.contains(RegExp(r'\d'));
    notifyListeners();
  }

  Future<void> retryKeyVerification() async {
    value.noSecretsreceived = false;
    final keys = await client.fetchUserDeviceKeysList(client.userID!);
    value.keyVerification = await keys!.startVerification();
    value.keyVerification?.onUpdate = _onKeyVerificationUpdate;
    notifyListeners();
  }

  Future<void> _init() async {
    final state = value.cryptoIdentityState = await client
        .getCryptoIdentityState();
    newPassphraseController.addListener(_checkCanCreatePassphrase);
    repeatPassphraseController.addListener(_checkCanCreatePassphrase);
    enterPassphraseOrRecovController.addListener(
      _passphraseOrRecoveryKeyEntered,
    );
    if (state.initialized) {
      if (state.connected) return notifyListeners();

      final keys = await client.fetchUserDeviceKeysList(client.userID!);

      final devices = value.connectedDevices =
          keys?.deviceKeys.values
              .where(
                (device) => device.hasValidSignatureChain(
                  verifiedByTheirMasterKey: true,
                ),
              )
              .toList() ??
          [];
      if (devices.isNotEmpty) {
        value.keyVerification = await keys!.startVerification();
        value.keyVerification?.onUpdate = _onKeyVerificationUpdate;
      }
      if (supportsSecureStorage) {
        try {
          final keyFromSecureStorage = await FlutterSecureStorage().read(
            key: _secureStorageKey,
          );
          if (keyFromSecureStorage != null) {
            enterPassphraseOrRecovController.text = keyFromSecureStorage;
          }
        } catch (e, s) {
          Logs().e('Unable to read key from secure storage', e, s);
        }
      }
    }
    notifyListeners();
  }

  void _passphraseOrRecoveryKeyEntered() {
    final passphraseOrRecoveryKeyEntered =
        enterPassphraseOrRecovController.text.isNotEmpty;
    if (value.passphraseOrRecoveryKeyEntered !=
        passphraseOrRecoveryKeyEntered) {
      value.passphraseOrRecoveryKeyEntered = passphraseOrRecoveryKeyEntered;
      notifyListeners();
    }
  }

  Future<void> _onKeyVerificationUpdate() async {
    if (value.keyVerification?.state == KeyVerificationState.done) {
      value.waitingForSecrets = true;
      value.noSecretsreceived = false;
      notifyListeners();
      value.cryptoIdentityState = await client.getCryptoIdentityState();
      var tries = 0;
      const max = 10;
      while (value.cryptoIdentityState?.connected != true) {
        Logs().d('Waiting for secrets... [$tries/$max]');
        if (tries >= max) return;
        await Future.delayed(const Duration(seconds: 1));
        value.cryptoIdentityState = await client.getCryptoIdentityState();
        tries++;
      }

      if (value.cryptoIdentityState?.connected != true) {
        value.waitingForSecrets = false;
        value.noSecretsreceived = true;
      }
    }
    notifyListeners();
  }

  Future<void> setOrSkipPassphrase(
    String? passphrase,
    BuildContext context,
  ) async {
    value.isLoading = true;
    notifyListeners();
    try {
      value.recoveryKey = await client.initCryptoIdentity(
        passphrase: passphrase,
        wipeCrossSigning: !reset,
        wipeKeyBackup: !reset,
        wipeSecureStorage: !reset,
        setupMasterKey: !reset,
        setupSelfSigningKey: !reset,
        setupUserSigningKey: !reset,
      );
    } catch (e, s) {
      if (!context.mounted) return;
      ErrorReporter(
        context,
        'Unable to init crypto identity',
      ).onErrorCallback(e, s);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toLocalizedString(context))));
      value.isLoading = false;
    }
    notifyListeners();
  }

  void _cancelKeyVerification() {
    final keyVerification = value.keyVerification;
    if (keyVerification != null &&
        keyVerification.state != KeyVerificationState.done &&
        keyVerification.state != KeyVerificationState.error) {
      keyVerification.cancel();
    }
  }

  bool get supportsSecureStorage =>
      PlatformInfos.isMobile || PlatformInfos.isDesktop;

  Future<void> unlock(BuildContext context) async {
    final key = enterPassphraseOrRecovController.text.trim();
    if (key.isEmpty) return;

    _cancelKeyVerification();

    value.unlockWithError = null;
    value.isLoading = true;
    notifyListeners();
    try {
      await client.restoreCryptoIdentity(key);
      value.isLoading = false;
      value.cryptoIdentityState = await client.getCryptoIdentityState();
      notifyListeners();
      return;
    } catch (e, s) {
      if (e is! InvalidPassphraseException) {
        const errorMessage = 'Unexpected error on unlock passphrase';
        if (context.mounted) {
          ErrorReporter(context, errorMessage).onErrorCallback(e, s);
        } else {
          Logs().wtf(errorMessage, e, s);
        }
      }
      value.isLoading = false;
      value.unlockWithError = e;
      notifyListeners();
      if (supportsSecureStorage) {
        await FlutterSecureStorage().delete(key: _secureStorageKey);
      }
      return;
    }
  }

  void goToRoomsPageAfterSuccess(BuildContext context) {
    for (final room in client.rooms) {
      final lastEvent = room.lastEvent;
      if (lastEvent == null ||
          lastEvent.messageType != MessageTypes.BadEncrypted ||
          lastEvent.content['can_request_session'] != true) {
        continue;
      }
      final sessionId = lastEvent.content.tryGet<String>('session_id');
      final senderKey = lastEvent.content.tryGet<String>('sender_key');
      if (sessionId != null && senderKey != null) {
        client.encryption?.keyManager.maybeAutoRequest(
          room.id,
          sessionId,
          senderKey,
        );
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        showCloseIcon: true,
        backgroundColor: Colors.green.shade700,
        content: Text(
          L10n.of(context).youAreReadyToStart,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    context.go('/rooms');
  }

  void toggleObscureText() {
    value.obscureText = !value.obscureText;
    notifyListeners();
  }

  void startResetAccount() {
    value.reset = true;
    notifyListeners();
  }

  String get _secureStorageKey => 'ssss_recovery_key_${client.userID}';

  Future<void> openRecoveryKeyFile(BuildContext context) async {
    final result = await FilePicker.pickFile(
      allowedExtensions: ['txt'],
      type: FileType.custom,
    );
    final file = result?.xFile;
    if (file == null) return;
    try {
      final key = await file.readAsString();
      enterPassphraseOrRecovController.text = key;
    } catch (e, s) {
      Logs().d('Unable to read recovery key file', e, s);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toLocalizedString(context))));
      }
    }
    if (context.mounted) await unlock(context);
  }

  Future<void> toggleRecoveryKeyDownloaded(
    bool? downloaded,
    BuildContext context,
  ) async {
    final path = await FilePicker.saveFile(
      fileName:
          'FluffyChat-Recovery-Key-${DateTime.now().toIso8601String()}.txt',
      bytes: Uint8List.fromList(value.recoveryKey!.codeUnits),
    );
    if (path == null) return;
    value.recoveryKeyDownloaded = downloaded == true;
    notifyListeners();
  }

  Future<void> toggleRecoveryKeyStoredInSecureStorage(bool? stored) async {
    if (stored == true) {
      await FlutterSecureStorage().write(
        key: _secureStorageKey,
        value: value.recoveryKey,
      );
    } else {
      await FlutterSecureStorage().delete(key: _secureStorageKey);
    }
    value.recoveryKeyStoredInSecureStorage = stored == true;
    notifyListeners();
  }
}
