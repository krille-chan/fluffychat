import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:fluffychat/pages/views/device_settings_view.dart';
import 'package:fluffychat/pages/key_verification_dialog.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../widgets/matrix.dart';

class DevicesSettings extends StatefulWidget {
  @override
  DevicesSettingsController createState() => DevicesSettingsController();
}

class DevicesSettingsController extends State<DevicesSettings> {
  List<Device> devices;
  Future<bool> loadUserDevices(BuildContext context) async {
    if (devices != null) return true;
    devices = await Matrix.of(context).client.getDevices();
    return true;
  }

  void reload() => setState(() => devices = null);

  bool loadingDeletingDevices = false;
  String errorDeletingDevices;

  void removeDevicesAction(List<Device> devices) async {
    if (await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context).areYouSure,
          okLabel: L10n.of(context).yes,
          cancelLabel: L10n.of(context).cancel,
        ) ==
        OkCancelResult.cancel) return;
    final matrix = Matrix.of(context);
    final deviceIds = <String>[];
    for (final userDevice in devices) {
      deviceIds.add(userDevice.deviceId);
    }

    try {
      setState(() {
        loadingDeletingDevices = true;
        errorDeletingDevices = null;
      });
      await matrix.client.uiaRequestBackground(
        (auth) => matrix.client.deleteDevices(
          deviceIds,
          auth: auth,
        ),
      );
      reload();
    } catch (e, s) {
      Logs().v('Error while deleting devices', e, s);
      setState(() => errorDeletingDevices = e.toString());
    } finally {
      setState(() => loadingDeletingDevices = false);
    }
  }

  void renameDeviceAction(Device device) async {
    final displayName = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context).changeDeviceName,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      textFields: [
        DialogTextField(
          hintText: device.displayName,
        )
      ],
    );
    if (displayName == null) return;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context)
          .client
          .updateDevice(device.deviceId, displayName: displayName.single),
    );
    if (success.error == null) {
      reload();
    }
  }

  void verifyDeviceAction(Device device) async {
    final req = Matrix.of(context)
        .client
        .userDeviceKeys[Matrix.of(context).client.userID]
        .deviceKeys[device.deviceId]
        .startVerification();
    req.onUpdate = () {
      if ({KeyVerificationState.error, KeyVerificationState.done}
          .contains(req.state)) {
        setState(() => null);
      }
    };
    await KeyVerificationDialog(request: req).show(context);
  }

  void blockDeviceAction(Device device) async {
    final key = Matrix.of(context)
        .client
        .userDeviceKeys[Matrix.of(context).client.userID]
        .deviceKeys[device.deviceId];
    if (key.directVerified) {
      await key.setVerified(false);
    }
    await key.setBlocked(true);
    setState(() => null);
  }

  void unblockDeviceAction(Device device) async {
    final key = Matrix.of(context)
        .client
        .userDeviceKeys[Matrix.of(context).client.userID]
        .deviceKeys[device.deviceId];
    await key.setBlocked(false);
    setState(() => null);
  }

  bool _isOwnDevice(Device userDevice) =>
      userDevice.deviceId == Matrix.of(context).client.deviceID;

  Device get thisDevice => devices.firstWhere(
        _isOwnDevice,
        orElse: () => null,
      );

  List<Device> get notThisDevice => List<Device>.from(devices)
    ..removeWhere(_isOwnDevice)
    ..sort((a, b) => (b.lastSeenTs ?? 0).compareTo(a.lastSeenTs ?? 0));

  @override
  Widget build(BuildContext context) => DevicesSettingsView(this);
}
