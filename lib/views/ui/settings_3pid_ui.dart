import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/settings_3pid.dart';
import 'package:fluffychat/views/widgets/max_width_body.dart';
import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class Settings3PidUI extends StatelessWidget {
  final Settings3PidController controller;

  const Settings3PidUI(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.request ??=
        Matrix.of(context).client.requestThirdPartyIdentifiers();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).passwordRecovery),
        actions: [
          IconButton(
            icon: Icon(Icons.add_outlined),
            onPressed: controller.add3PidAction,
            tooltip: L10n.of(context).addEmail,
          )
        ],
      ),
      body: MaxWidthBody(
        child: FutureBuilder<List<ThirdPartyIdentifier>>(
          future: controller.request,
          builder: (BuildContext context,
              AsyncSnapshot<List<ThirdPartyIdentifier>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final identifier = snapshot.data;
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
                        ? L10n.of(context).noPasswordRecoveryDescription
                        : L10n.of(context)
                            .withTheseAddressesRecoveryDescription,
                  ),
                ),
                Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: identifier.length,
                    itemBuilder: (BuildContext context, int i) => ListTile(
                      leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          foregroundColor: Colors.grey,
                          child: Icon(identifier[i].iconData)),
                      title: Text(identifier[i].address),
                      trailing: IconButton(
                        tooltip: L10n.of(context).delete,
                        icon: Icon(Icons.delete_forever_outlined),
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
    return Icons.device_unknown_outlined;
  }
}
