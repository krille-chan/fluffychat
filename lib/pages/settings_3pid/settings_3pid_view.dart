import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/settings_3pid/settings_3pid.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class Settings3PidView extends StatelessWidget {
  final Settings3PidController controller;

  const Settings3PidView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.request ??= Matrix.of(context).client.getAccount3PIDs();
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(L10n.of(context)!.passwordRecovery),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_outlined),
            onPressed: controller.add3PidAction,
            tooltip: L10n.of(context)!.addEmail,
          )
        ],
      ),
      body: MaxWidthBody(
        child: FutureBuilder<List<ThirdPartyIdentifier>?>(
          future: controller.request,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<ThirdPartyIdentifier>?> snapshot,
          ) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              );
            }
            final identifier = snapshot.data!;
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    foregroundColor:
                        identifier.isEmpty ? Colors.orange : Colors.grey,
                    child: Icon(
                      identifier.isEmpty
                          ? Icons.warning_outlined
                          : Icons.info_outlined,
                    ),
                  ),
                  title: Text(
                    identifier.isEmpty
                        ? L10n.of(context)!.noPasswordRecoveryDescription
                        : L10n.of(context)!
                            .withTheseAddressesRecoveryDescription,
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: identifier.length,
                    itemBuilder: (BuildContext context, int i) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        foregroundColor: Colors.grey,
                        child: Icon(identifier[i].iconData),
                      ),
                      title: Text(identifier[i].address),
                      trailing: IconButton(
                        tooltip: L10n.of(context)!.delete,
                        icon: const Icon(Icons.delete_forever_outlined),
                        color: Colors.red,
                        onPressed: () => controller.delete3Pid(identifier[i]),
                      ),
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

extension on ThirdPartyIdentifier {
  IconData get iconData {
    switch (medium) {
      case ThirdPartyIdentifierMedium.email:
        return Icons.mail_outline_rounded;
      case ThirdPartyIdentifierMedium.msisdn:
        return Icons.phone_android_outlined;
    }
  }
}
