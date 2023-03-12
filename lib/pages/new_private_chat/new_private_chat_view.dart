import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/new_private_chat/new_private_chat.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewPrivateChatView extends StatelessWidget {
  final NewPrivateChatController controller;

  const NewPrivateChatView(this.controller, {Key? key}) : super(key: key);

  static const double _qrCodePadding = 8;

  @override
  Widget build(BuildContext context) {
    final qrCodeSize =
        min(MediaQuery.of(context).size.width - 16, 256).toDouble();
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(L10n.of(context)!.newChat),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () => VRouter.of(context).to('/newgroup'),
              child: Text(
                L10n.of(context)!.createNewGroup,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MaxWidthBody(
              withScrolling: true,
              child: Container(
                margin: const EdgeInsets.all(_qrCodePadding),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(_qrCodePadding * 2),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  elevation: 10,
                  color: Colors.white,
                  shadowColor: Theme.of(context).appBarTheme.shadowColor,
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QrImage(
                        data:
                            'https://matrix.to/#/${Matrix.of(context).client.userID}',
                        version: QrVersions.auto,
                        size: qrCodeSize,
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          fixedSize:
                              Size.fromWidth(qrCodeSize - (2 * _qrCodePadding)),
                        ),
                        icon: Icon(Icons.adaptive.share_outlined),
                        label: Text(L10n.of(context)!.shareYourInviteLink),
                        onPressed: controller.inviteAction,
                      ),
                      const SizedBox(height: 8),
                      if (PlatformInfos.isMobile) ...[
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            fixedSize: Size.fromWidth(
                              qrCodeSize - (2 * _qrCodePadding),
                            ),
                          ),
                          icon: const Icon(Icons.qr_code_scanner_outlined),
                          label: Text(L10n.of(context)!.scanQrCode),
                          onPressed: controller.openScannerAction,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          MaxWidthBody(
            withScrolling: false,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: controller.formKey,
                child: TextFormField(
                  controller: controller.controller,
                  autocorrect: false,
                  textInputAction: TextInputAction.go,
                  focusNode: controller.textFieldFocus,
                  onFieldSubmitted: controller.submitAction,
                  validator: controller.validateForm,
                  inputFormatters: controller.removeMatrixToFormatters,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    labelText: L10n.of(context)!.enterInviteLinkOrMatrixId,
                    hintText: '@username',
                    prefixText: NewPrivateChatController.prefixNoProtocol,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send_outlined),
                      onPressed: controller.submitAction,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
