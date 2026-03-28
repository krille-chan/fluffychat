import 'package:async/async.dart' show Result;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/device_settings/device_settings_view.dart';
import 'package:fluffychat/pages/key_verification/key_verification_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart' hide Result;
import 'package:url_launcher/url_launcher_string.dart';

import '../../widgets/matrix.dart';

class DevicesSettings extends StatefulWidget {
  const DevicesSettings({super.key});

  @override
  DevicesSettingsController createState() => DevicesSettingsController();
}

class DevicesSettingsController extends State<DevicesSettings> {
  List<Device>? devices;
  Future<bool> loadUserDevices(BuildContext context) async {
    if (devices != null) return true;
    devices = await Matrix.of(context).client.getDevices();
    return true;
  }

  void reload() => setState(() => devices = null);

  bool? chatBackupEnabled;

  @override
  void initState() {
    _checkChatBackup();
    super.initState();
  }

  Future<void> _checkChatBackup() async {
    final client = Matrix.of(context).client;
    final state = await client.getCryptoIdentityState();
    if (!mounted) return;
    setState(() {
      chatBackupEnabled = state.initialized && !state.connected;
    });
  }

  Future<void> removeDevicesAction(List<Device> devices) async {
    final l10n = L10n.of(context);
    final matrix = Matrix.of(context);
    final client = Matrix.of(context).client;

    final wellKnown = await Result.capture(client.getWellknown());
    final accountManageUrl = wellKnown.asValue?.value.additionalProperties
        .tryGetMap<String, Object?>('org.matrix.msc2965.authentication')
        ?.tryGet<String>('account');
    if (accountManageUrl != null) {
      launchUrlString(accountManageUrl, mode: LaunchMode.inAppBrowserView);
      return;
    }
    if (!mounted) return;
    if (await showOkCancelAlertDialog(
          context: context,
          title: l10n.areYouSure,
          okLabel: l10n.remove,
          cancelLabel: l10n.cancel,
          message: l10n.removeDevicesDescription,
          isDestructive: true,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    if (!mounted) return;
    final deviceIds = <String>[];
    for (final userDevice in devices) {
      deviceIds.add(userDevice.deviceId);
    }

    await showFutureLoadingDialog(
      context: context,
      delay: false,
      future: () => matrix.client.uiaRequestBackground(
        (auth) => matrix.client.deleteDevices(deviceIds, auth: auth),
      ),
    );
    reload();
  }

  Future<void> renameDeviceAction(Device device) async {
    final l10n = L10n.of(context);
    final matrix = Matrix.of(context);
    final displayName = await showTextInputDialog(
      context: context,
      title: l10n.changeDeviceName,
      okLabel: l10n.ok,
      cancelLabel: l10n.cancel,
      hintText: device.displayName,
    );
    if (displayName == null) return;
    if (!mounted) return;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () =>
          matrix.client.updateDevice(device.deviceId, displayName: displayName),
    );
    if (success.error == null) {
      reload();
    }
  }

  Future<void> verifyDeviceAction(Device device) async {
    final l10n = L10n.of(context);
    final matrix = Matrix.of(context);
    final consent = await showOkCancelAlertDialog(
      context: context,
      title: l10n.verifyOtherDevice,
      message: l10n.verifyOtherDeviceDescription,
      okLabel: l10n.ok,
      cancelLabel: l10n.cancel,
    );
    if (consent != OkCancelResult.ok) return;
    if (!mounted) return;
    final req = await matrix
        .client
        .userDeviceKeys[matrix.client.userID!]!
        .deviceKeys[device.deviceId]!
        .startVerification();
    req.onUpdate = () {
      if ({
        KeyVerificationState.error,
        KeyVerificationState.done,
      }.contains(req.state)) {
        setState(() {});
      }
    };
    if (!mounted) return;
    await KeyVerificationDialog(request: req).show(context);
  }

  Future<void> blockDeviceAction(Device device) async {
    final key = Matrix.of(context)
        .client
        .userDeviceKeys[Matrix.of(context).client.userID!]!
        .deviceKeys[device.deviceId]!;
    if (key.directVerified) {
      await key.setVerified(false);
    }
    await key.setBlocked(true);
    setState(() {});
  }

  Future<void> unblockDeviceAction(Device device) async {
    final key = Matrix.of(context)
        .client
        .userDeviceKeys[Matrix.of(context).client.userID!]!
        .deviceKeys[device.deviceId]!;
    await key.setBlocked(false);
    setState(() {});
  }

  bool _isOwnDevice(Device userDevice) =>
      userDevice.deviceId == Matrix.of(context).client.deviceID;

  Device? get thisDevice => devices!.firstWhereOrNull(_isOwnDevice);

  List<Device> get notThisDevice => List<Device>.from(devices!)
    ..removeWhere(_isOwnDevice)
    ..sort((a, b) => (b.lastSeenTs ?? 0).compareTo(a.lastSeenTs ?? 0));

  @override
  Widget build(BuildContext context) => DevicesSettingsView(this);
}
