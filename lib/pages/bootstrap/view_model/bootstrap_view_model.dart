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

  Future<void> _init() async {
    final state = value.cryptoIdentityState = await client
        .getCryptoIdentityState();
    if (state.initialized) {
      if (state.connected) return notifyListeners();

      await client.updateUserDeviceKeys();

      final devices = value.connectedDevices =
          client.userDeviceKeys[client.userID!]?.deviceKeys.values
              .where(
                (device) => device.hasValidSignatureChain(
                  verifiedByTheirMasterKey: true,
                ),
              )
              .toList() ??
          [];
      if (devices.isNotEmpty) {
        value.keyVerification = await client.userDeviceKeys[client.userID!]!
            .startVerification();
      }
    }
    notifyListeners();
  }

  Future<void> setOrSkipPassphrase(String? passphrase) async {
    value.isLoading = true;
    notifyListeners();

    value.recoveryKey = await client.initCryptoIdentity(passphrase: passphrase);
    notifyListeners();
  }

  Future<bool> unlock() async {
    final key = enterPassphraseOrRecovController.text.trim();
    if (key.isEmpty) return false;

    value.unlockWithError = null;
    value.isLoading = true;
    notifyListeners();
    try {
      await client.restoreCryptoIdentity(key);
      value.isLoading = false;
      value.cryptoIdentityState = await client.getCryptoIdentityState();
      notifyListeners();
      return true;
    } catch (e, s) {
      Logs().d('Unable to unlock', e, s);
      value.isLoading = false;
      value.unlockWithError = e;
      notifyListeners();
      return false;
    }
  }

  void setRecoveryKeyStored() {
    value.recoveryKeyStored = true;
    notifyListeners();
  }

  void toggleObscureText() {
    value.obscureText = !value.obscureText;
    notifyListeners();
  }

  void startResetAccount() {
    value.reset = true;
    notifyListeners();
  }
}
