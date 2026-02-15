import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';

class BootstrapViewModelState {
  String? recoveryKey;
  bool isLoading = false;
  Object? unlockWithError;
  ({bool connected, bool initialized})? cryptoIdentityState;
  bool reset = false;
  KeyVerification? keyVerification;
  List<DeviceKeys>? connectedDevices;
  bool recoveryKeyStored = false;
}
