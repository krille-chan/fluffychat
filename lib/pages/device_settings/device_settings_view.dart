import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pages/device_settings/device_settings.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'user_device_list_item.dart';

class DevicesSettingsView extends StatelessWidget {
  final DevicesSettingsController controller;

  const DevicesSettingsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        title: Text(L10n.of(context)!.devices),
      ),
      body: MaxWidthBody(
        child: FutureBuilder<bool>(
          future: controller.loadUserDevices(context),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.error_outlined),
                    Text(snapshot.error.toString()),
                  ],
                ),
              );
            }
            if (!snapshot.hasData || controller.devices == null) {
              return const Center(
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.notThisDevice.length + 1,
              itemBuilder: (BuildContext context, int i) {
                if (i == 0) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller.thisDevice != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            L10n.of(context)!.thisDevice,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        UserDeviceListItem(
                          controller.thisDevice!,
                          rename: controller.renameDeviceAction,
                          remove: (d) => controller.removeDevicesAction([d]),
                          verify: controller.verifyDeviceAction,
                          block: controller.blockDeviceAction,
                          unblock: controller.unblockDeviceAction,
                        ),
                      ],
                      if (controller.notThisDevice.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              label: Text(
                                controller.errorDeletingDevices ??
                                    L10n.of(context)!.removeAllOtherDevices,
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .errorContainer,
                              ),
                              icon: controller.loadingDeletingDevices
                                  ? const CircularProgressIndicator.adaptive(
                                      strokeWidth: 2,
                                    )
                                  : const Icon(Icons.delete_outline),
                              onPressed: controller.loadingDeletingDevices
                                  ? null
                                  : () => controller.removeDevicesAction(
                                        controller.notThisDevice,
                                      ),
                            ),
                          ),
                        )
                      else
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(L10n.of(context)!.noOtherDevicesFound),
                          ),
                        ),
                    ],
                  );
                }
                i--;
                return UserDeviceListItem(
                  controller.notThisDevice[i],
                  rename: controller.renameDeviceAction,
                  remove: (d) => controller.removeDevicesAction([d]),
                  verify: controller.verifyDeviceAction,
                  block: controller.blockDeviceAction,
                  unblock: controller.unblockDeviceAction,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
