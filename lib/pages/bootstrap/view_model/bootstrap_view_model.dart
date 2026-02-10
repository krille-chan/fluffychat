import 'package:flutter/material.dart';

import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';

import 'bootstrap_state.dart';

class BootstrapViewModel extends ValueNotifier<BootstrapViewModelState> {
  final Client client;

  final TextEditingController enterPassphraseOrRecovController =
      TextEditingController();
  final TextEditingController newPassphraseController = TextEditingController();
  final TextEditingController repeatPassphraseController =
      TextEditingController();

  BootstrapViewModel({required this.client})
    : super(BootstrapViewModelState()) {
    _init();
  }

  void _init() async {
    final state = value.cryptoIdentityState = await client
        .getCryptoIdentityState();
    if (state.initialized) {
      if (state.connected) return notifyListeners();

      await client.updateUserDeviceKeys();

      final devices = value.connectedDevices =
          client.userDeviceKeys[client.userID!]?.deviceKeys.values
              .where((device) => device.crossVerified)
              .toList() ??
          [];
      if (devices.isNotEmpty) {
        value.keyVerification = await client.userDeviceKeys[client.userID!]!
            .startVerification();
      }
    }
    notifyListeners();
  }

  void setOrSkipPassphrase(String? passphrase) async {
    value.isLoading = true;
    notifyListeners();

    value.recoveryKey = await client.initCryptoIdentity(passphrase: passphrase);
    notifyListeners();
  }

  void unlockWith({required VoidCallback onUnlockSuccess}) async {
    value.unlockWithError = null;
    value.isLoading = true;
    notifyListeners();

    try {
      await client.restoreCryptoIdentity(
        enterPassphraseOrRecovController.text.trim(),
      );
      value.isLoading = false;
      value.cryptoIdentityState = await client.getCryptoIdentityState();
      notifyListeners();

      onUnlockSuccess();
    } catch (e, s) {
      Logs().d('Unable to unlock', e, s);
      value.isLoading = false;
      value.unlockWithError = e;
      notifyListeners();
    }
  }

  void setRecoveryKeyStored() {
    value.recoveryKeyStored = true;
    notifyListeners();
  }
}
