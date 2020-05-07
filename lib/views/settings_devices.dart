import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:flutter/material.dart';

import '../utils/date_time_extension.dart';
import '../components/adaptive_page_layout.dart';
import '../components/matrix.dart';
import '../l10n/l10n.dart';
import 'chat_list.dart';

class DevicesSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(),
      secondScaffold: DevicesSettings(),
    );
  }
}

class DevicesSettings extends StatefulWidget {
  @override
  DevicesSettingsState createState() => DevicesSettingsState();
}

class DevicesSettingsState extends State<DevicesSettings> {
  List<UserDevice> devices;
  Future<bool> _loadUserDevices(BuildContext context) async {
    if (devices != null) return true;
    devices = await Matrix.of(context).client.requestUserDevices();
    return true;
  }

  void reload() => setState(() => devices = null);

  void _removeDevicesAction(
      BuildContext context, List<UserDevice> devices) async {
    if (await SimpleDialogs(context).askConfirmation() == false) return;
    MatrixState matrix = Matrix.of(context);
    List<String> deviceIds = [];
    for (UserDevice userDevice in devices) {
      deviceIds.add(userDevice.deviceId);
    }
    final success = await SimpleDialogs(context)
        .tryRequestWithLoadingDialog(matrix.client.deleteDevices(deviceIds),
            onAdditionalAuth: (MatrixException exception) async {
      final String password = await SimpleDialogs(context).enterText(
          titleText: L10n.of(context).pleaseEnterYourPassword,
          labelText: L10n.of(context).pleaseEnterYourPassword,
          hintText: "******",
          password: true);
      if (password == null) return;
      await matrix.client.deleteDevices(deviceIds,
          auth: matrix.getAuthByPassword(password, exception.session));
      return;
    });
    if (success != false) {
      reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).devices)),
      body: FutureBuilder<bool>(
        future: _loadUserDevices(context),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.error),
                  Text(snapshot.error.toString()),
                ],
              ),
            );
          }
          if (!snapshot.hasData || this.devices == null) {
            return Center(child: CircularProgressIndicator());
          }
          Function isOwnDevice = (UserDevice userDevice) =>
              userDevice.deviceId == Matrix.of(context).client.deviceID;
          final List<UserDevice> devices = List<UserDevice>.from(this.devices);
          UserDevice thisDevice =
              devices.firstWhere(isOwnDevice, orElse: () => null);
          devices.removeWhere(isOwnDevice);
          devices.sort((a, b) => b.lastSeenTs.compareTo(a.lastSeenTs));
          return Column(
            children: <Widget>[
              if (thisDevice != null)
                UserDeviceListItem(
                  thisDevice,
                  remove: (d) => _removeDevicesAction(context, [d]),
                ),
              Divider(height: 1),
              if (devices.isNotEmpty)
                ListTile(
                  title: Text(
                    L10n.of(context).removeAllOtherDevices,
                    style: TextStyle(color: Colors.red),
                  ),
                  trailing: Icon(Icons.delete_outline),
                  onTap: () => _removeDevicesAction(context, devices),
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
                          remove: (d) => _removeDevicesAction(context, [d]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class UserDeviceListItem extends StatelessWidget {
  final UserDevice userDevice;
  final Function remove;

  const UserDeviceListItem(this.userDevice, {this.remove, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (String action) {
        if (action == "remove" && this.remove != null) {
          remove(userDevice);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: "remove",
          child: Text(L10n.of(context).removeDevice,
              style: TextStyle(color: Colors.red)),
        ),
      ],
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                (userDevice.displayName?.isNotEmpty ?? false)
                    ? userDevice.displayName
                    : L10n.of(context).unknownDevice,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(userDevice.lastSeenTs.localizedTimeShort(context)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("${L10n.of(context).id}: ${userDevice.deviceId}"),
            Text("${L10n.of(context).lastSeenIp}: ${userDevice.lastSeenIp}"),
          ],
        ),
      ),
    );
  }
}
