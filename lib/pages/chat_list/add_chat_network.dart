import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../../widgets/matrix.dart';
import '../add_bridge/add_bridge_body.dart';

class AddChatNetwork extends StatelessWidget {
  const AddChatNetwork({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3.5,
      width: PlatformInfos.isWeb ? MediaQuery.of(context).size.width / 2 : null,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (!PlatformInfos.isWeb)
              Text(
                L10n.of(context)!.youDonTHaveConversation,
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AddBridgeBody(
                        client: Matrix.of(context).client,
                      );
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFEEA77),
              ),
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
