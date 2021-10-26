import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/new_private_chat.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewPrivateChatView extends StatelessWidget {
  final NewPrivateChatController controller;

  const NewPrivateChatView(this.controller, {Key key}) : super(key: key);

  static const double _qrCodePadding = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
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
            Container(
              margin: const EdgeInsets.all(_qrCodePadding),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(_qrCodePadding * 2),
              child: InkWell(
                onTap: controller.inviteAction,
                borderRadius: BorderRadius.circular(12),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  elevation: 4,
                  color: Colors.white,
                  child: QrImage(
                    data:
                        'https://matrix.to/#/${Matrix.of(context).client.userID}',
                    version: QrVersions.auto,
                    size: min(MediaQuery.of(context).size.width - 16, 200),
                    embeddedImage: const AssetImage('assets/share.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: const Size(48, 48),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              subtitle: Text(L10n.of(context).createNewChatExplaination),
              trailing: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.info_outline_rounded),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(12),
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
                      icon: const Icon(Icons.send_outlined),
                      onPressed: controller.submitAction,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/private_chat_wallpaper.png',
                width: min(AppConfig.columnWidth - _qrCodePadding * 6,
                    MediaQuery.of(context).size.width - _qrCodePadding * 6),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: PlatformInfos.isMobile
          ? FloatingActionButton.extended(
              onPressed: controller.openScannerAction,
              label: Text(L10n.of(context).scanQrCode),
              icon: const Icon(Icons.camera_alt_outlined),
            )
          : null,
    );
  }
}
