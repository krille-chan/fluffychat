import 'package:tawkie/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:tawkie/utils/platform_size.dart';

// Shows a button redirecting to the bridge bots social network chat connection page
class AddChatNetwork extends StatelessWidget {
  final bool showText;

  const AddChatNetwork(this.showText, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3.5,
      width: PlatformInfos.isWeb ? PlatformWidth.webWidth : null,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (PlatformInfos.isMobile && showText)
              Text(
                L10n.of(context)!.youDonTHaveConversation,
              ),
            ElevatedButton(
              onPressed: () {
                // Redirect to bot social network connection page via route
                context.go('/rooms/settings/addbridgebot');
              },
              // style: ElevatedButton.styleFrom(
              //   backgroundColor: const Color(0xFFFEEA77),
              // ),
              child: Text(
                L10n.of(context)!.connectChatNetworks,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
