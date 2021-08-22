import 'dart:math';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/new_private_chat.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vrouter/vrouter.dart';

class NewPrivateChatView extends StatelessWidget {
  final NewPrivateChatController controller;

  const NewPrivateChatView(this.controller, {Key key}) : super(key: key);

  static const double _qrCodePadding = 8;

  @override
  Widget build(BuildContext context) {
    final qrCodeSize = min(AppConfig.columnWidth - _qrCodePadding * 6,
        MediaQuery.of(context).size.width - _qrCodePadding * 6);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).newChat),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => VRouter.of(context).to('/newgroup'),
            child: Text(
              L10n.of(context).createNewGroup,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          )
        ],
      ),
      body: MaxWidthBody(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: _qrCodePadding * 2,
                left: _qrCodePadding * 2,
                right: _qrCodePadding * 2,
              ),
              child: Text(
                L10n.of(context).createNewChatExplaination,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              margin: EdgeInsets.all(_qrCodePadding),
              alignment: Alignment.center,
              padding: EdgeInsets.all(_qrCodePadding * 2),
              color: Colors.white,
              child: Material(
                borderRadius: BorderRadius.circular(12),
                elevation: 4,
                child: QrImage(
                  data:
                      'https://matrix.to/#/${Matrix.of(context).client.userID}',
                  version: QrVersions.auto,
                  size: qrCodeSize,
                ),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(L10n.of(context).shareYourInviteLink),
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.share_outlined),
              ),
              onTap: controller.inviteAction,
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(12),
              child: Form(
                key: controller.formKey,
                child: TextFormField(
                  controller: controller.controller,
                  autocorrect: false,
                  textInputAction: TextInputAction.go,
                  onFieldSubmitted: controller.submitAction,
                  validator: controller.validateForm,
                  decoration: InputDecoration(
                    labelText: L10n.of(context).typeInInviteLinkManually,
                    hintText: '@username',
                    prefixText: 'https://matrix.to/#/',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send_outlined),
                      onPressed: controller.submitAction,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/private_chat_wallpaper.png',
                width: qrCodeSize,
                height: qrCodeSize,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: PlatformInfos.isMobile
          ? FloatingActionButton.extended(
              onPressed: controller.openScannerAction,
              label: Text(L10n.of(context).scanQrCode),
              icon: Icon(Icons.camera_alt_outlined),
            )
          : null,
    );
  }
}
