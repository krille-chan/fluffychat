import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class Settings3Pid extends StatefulWidget {
  static int sendAttempt = 0;

  @override
  _Settings3PidState createState() => _Settings3PidState();
}

class _Settings3PidState extends State<Settings3Pid> {
  void _add3PidAction(BuildContext context) async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).enterAnEmailAddress,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      useRootNavigator: false,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context).enterAnEmailAddress,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
    if (input == null) return;
    final clientSecret = DateTime.now().millisecondsSinceEpoch.toString();
    final response = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.requestEmailToken(
            input.single,
            clientSecret,
            Settings3Pid.sendAttempt++,
          ),
    );
    if (response.error != null) return;
    final ok = await showOkAlertDialog(
      context: context,
      title: L10n.of(context).weSentYouAnEmail,
      message: L10n.of(context).pleaseClickOnLink,
      okLabel: L10n.of(context).iHaveClickedOnLink,
      useRootNavigator: false,
    );
    if (ok == null) return;
    final password = await showTextInputDialog(
      context: context,
      title: L10n.of(context).pleaseEnterYourPassword,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      useRootNavigator: false,
      textFields: [
        DialogTextField(
          hintText: '******',
          obscureText: true,
          minLines: 1,
          maxLines: 1,
        ),
      ],
    );
    if (password == null) return;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.uiaRequestBackground(
            (auth) => Matrix.of(context).client.addThirdPartyIdentifier(
                  clientSecret,
                  (response as RequestTokenResponse).sid,
                  auth: auth,
                ),
          ),
    );
    if (success.error != null) return;
    setState(() => _request = null);
  }

  Future<List<ThirdPartyIdentifier>> _request;

  void _delete3Pid(
      BuildContext context, ThirdPartyIdentifier identifier) async {
    if (await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).areYouSure,
          okLabel: L10n.of(context).yes,
          cancelLabel: L10n.of(context).cancel,
          useRootNavigator: false,
        ) !=
        OkCancelResult.ok) {
      return;
    }
    final success = await showFutureLoadingDialog(
        context: context,
        future: () => Matrix.of(context).client.deleteThirdPartyIdentifier(
              identifier.address,
              identifier.medium,
            ));
    if (success.error != null) return;
    setState(() => _request = null);
  }

  @override
  Widget build(BuildContext context) {
    _request ??= Matrix.of(context).client.requestThirdPartyIdentifiers();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).passwordRecovery),
        actions: [
          IconButton(
            icon: Icon(Icons.add_outlined),
            onPressed: () => _add3PidAction(context),
            tooltip: L10n.of(context).addEmail,
          )
        ],
      ),
      body: FutureBuilder<List<ThirdPartyIdentifier>>(
        future: _request,
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
                      : L10n.of(context).withTheseAddressesRecoveryDescription,
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
                      onPressed: () => _delete3Pid(context, identifier[i]),
                    ),
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
