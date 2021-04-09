import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/encryption/utils/key_verification.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/widgets/dialogs/key_verification_dialog.dart';
import 'package:fluffychat/views/widgets/max_width_body.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../views/widgets/matrix.dart';
import '../utils/date_time_extension.dart';
import '../utils/device_extension.dart';

class DevicesSettings extends StatefulWidget {
  @override
  DevicesSettingsState createState() => DevicesSettingsState();
}

class DevicesSettingsState extends State<DevicesSettings> {
  List<Device> devices;
  Future<bool> _loadUserDevices(BuildContext context) async {
    if (devices != null) return true;
    devices = await Matrix.of(context).client.requestDevices();
    return true;
  }

  void reload() => setState(() => devices = null);

  bool _loadingDeletingDevices = false;
  String _errorDeletingDevices;

  void _removeDevicesAction(BuildContext context, List<Device> devices) async {
    if (await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).areYouSure,
          okLabel: L10n.of(context).yes,
          cancelLabel: L10n.of(context).cancel,
          useRootNavigator: false,
        ) ==
        OkCancelResult.cancel) return;
    var matrix = Matrix.of(context);
    var deviceIds = <String>[];
    for (var userDevice in devices) {
      deviceIds.add(userDevice.deviceId);
    }

    try {
      setState(() {
        _loadingDeletingDevices = true;
        _errorDeletingDevices = null;
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
      setState(() => _errorDeletingDevices = e.toString());
    } finally {
      setState(() => _loadingDeletingDevices = false);
    }
  }

  void _renameDeviceAction(BuildContext context, Device device) async {
    final displayName = await showTextInputDialog(
      context: context,
      title: L10n.of(context).changeDeviceName,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      useRootNavigator: false,
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
          .setDeviceMetadata(device.deviceId, displayName: displayName.single),
    );
    if (success.error == null) {
      reload();
    }
  }

  void _verifyDeviceAction(BuildContext context, Device device) async {
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

  void _blockDeviceAction(BuildContext context, Device device) async {
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

  void _unblockDeviceAction(BuildContext context, Device device) async {
    final key = Matrix.of(context)
        .client
        .userDeviceKeys[Matrix.of(context).client.userID]
        .deviceKeys[device.deviceId];
    await key.setBlocked(false);
    setState(() => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).devices),
      ),
      body: MaxWidthBody(
        child: FutureBuilder<bool>(
          future: _loadUserDevices(context),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.error_outlined),
                    Text(snapshot.error.toString()),
                  ],
                ),
              );
            }
            if (!snapshot.hasData || this.devices == null) {
              return Center(child: CircularProgressIndicator());
            }
            Function isOwnDevice = (Device userDevice) =>
                userDevice.deviceId == Matrix.of(context).client.deviceID;
            final devices = List<Device>.from(this.devices);
            var thisDevice =
                devices.firstWhere(isOwnDevice, orElse: () => null);
            devices.removeWhere(isOwnDevice);
            devices.sort((a, b) => b.lastSeenTs.compareTo(a.lastSeenTs));
            return Column(
              children: <Widget>[
                if (thisDevice != null)
                  UserDeviceListItem(
                    thisDevice,
                    rename: (d) => _renameDeviceAction(context, d),
                    remove: (d) => _removeDevicesAction(context, [d]),
                    verify: (d) => _verifyDeviceAction(context, d),
                    block: (d) => _blockDeviceAction(context, d),
                    unblock: (d) => _unblockDeviceAction(context, d),
                  ),
                Divider(height: 1),
                if (devices.isNotEmpty)
                  ListTile(
                    title: Text(
                      _errorDeletingDevices ??
                          L10n.of(context).removeAllOtherDevices,
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: _loadingDeletingDevices
                        ? CircularProgressIndicator()
                        : Icon(Icons.delete_outline),
                    onTap: _loadingDeletingDevices
                        ? null
                        : () => _removeDevicesAction(context, devices),
                  ),
                Divider(height: 1),
                Expanded(
                  child: devices.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.devices_other,
                            size: 60,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (BuildContext context, int i) =>
                              Divider(height: 1),
                          itemCount: devices.length,
                          itemBuilder: (BuildContext context, int i) =>
                              UserDeviceListItem(
                            devices[i],
                            rename: (d) => _renameDeviceAction(context, d),
                            remove: (d) => _removeDevicesAction(context, [d]),
                            verify: (d) => _verifyDeviceAction(context, d),
                            block: (d) => _blockDeviceAction(context, d),
                            unblock: (d) => _unblockDeviceAction(context, d),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

enum UserDeviceListItemAction {
  rename,
  remove,
  verify,
  block,
  unblock,
}

class UserDeviceListItem extends StatelessWidget {
  final Device userDevice;
  final void Function(Device) remove;
  final void Function(Device) rename;
  final void Function(Device) verify;
  final void Function(Device) block;
  final void Function(Device) unblock;

  const UserDeviceListItem(
    this.userDevice, {
    @required this.remove,
    @required this.rename,
    @required this.verify,
    @required this.block,
    @required this.unblock,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keys = Matrix.of(context)
        .client
        .userDeviceKeys[Matrix.of(context).client.userID]
        ?.deviceKeys[userDevice.deviceId];

    return ListTile(
      onTap: () async {
        final action = await showModalActionSheet<UserDeviceListItemAction>(
          context: context,
          actions: [
            SheetAction(
              key: UserDeviceListItemAction.rename,
              label: L10n.of(context).changeDeviceName,
            ),
            SheetAction(
              key: UserDeviceListItemAction.verify,
              label: L10n.of(context).verifyStart,
            ),
            if (keys != null) ...{
              if (!keys.blocked)
                SheetAction(
                  key: UserDeviceListItemAction.block,
                  label: L10n.of(context).blockDevice,
                  isDestructiveAction: true,
                ),
              if (keys.blocked)
                SheetAction(
                  key: UserDeviceListItemAction.unblock,
                  label: L10n.of(context).unblockDevice,
                  isDestructiveAction: true,
                ),
              SheetAction(
                key: UserDeviceListItemAction.remove,
                label: L10n.of(context).delete,
                isDestructiveAction: true,
              ),
            },
          ],
        );
        switch (action) {
          case UserDeviceListItemAction.rename:
            rename(userDevice);
            break;
          case UserDeviceListItemAction.remove:
            remove(userDevice);
            break;
          case UserDeviceListItemAction.verify:
            verify(userDevice);
            break;
          case UserDeviceListItemAction.block:
            block(userDevice);
            break;
          case UserDeviceListItemAction.unblock:
            unblock(userDevice);
            break;
        }
      },
      leading: CircleAvatar(
        foregroundColor: Theme.of(context).textTheme.bodyText1.color,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        child: Icon(userDevice.icon),
      ),
      title: Row(
        children: <Widget>[
          Text(
            userDevice.displayname,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Spacer(),
          Text(userDevice.lastSeenTs.localizedTimeShort(context)),
        ],
      ),
      subtitle: Row(
        children: <Widget>[
          Text(userDevice.deviceId),
          Spacer(),
          if (keys != null)
            Text(
              keys.blocked
                  ? L10n.of(context).blocked
                  : keys.verified
                      ? L10n.of(context).verified
                      : L10n.of(context).unknownDevice,
              style: TextStyle(
                color: keys.blocked
                    ? Colors.red
                    : keys.verified
                        ? Colors.green
                        : Colors.orange,
              ),
            ),
        ],
      ),
    );
  }
}
