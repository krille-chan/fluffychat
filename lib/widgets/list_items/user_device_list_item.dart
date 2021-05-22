import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../matrix.dart';
import '../../utils/date_time_extension.dart';
import '../../utils/device_extension.dart';

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
