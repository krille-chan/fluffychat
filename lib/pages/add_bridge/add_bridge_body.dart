import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/pages/add_bridge/add_bridge.dart';
import 'package:tawkie/pages/add_bridge/social_network_item.dart';
import 'package:tawkie/utils/platform_infos.dart';
import 'package:tawkie/utils/platform_size.dart';

import 'add_bridge_header.dart';
import 'model/social_network.dart';

// Page offering brigde bot connections to social network chats
class AddBridgeBody extends StatelessWidget {
  final BotController controller;

  const AddBridgeBody({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              controller.showPopupMenu(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildHeaderBridgeText(context),
            buildHeaderBridgeSubText(context),
            PlatformInfos.isWeb ||
                    PlatformInfos.isDesktop ||
                    PlatformInfos.isWindows ||
                    PlatformInfos.isMacOS
                ? ElevatedButton(
                    onPressed: () {
                      // controller.handleRefresh();
                    },
                    child: Text(L10n.of(context)!.refreshList),
                  )
                : Container(),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: SizedBox(
                width: PlatformInfos.isWeb ? PlatformWidth.webWidth : null,
                child: RefreshIndicator(
                  onRefresh: () => controller.handleRefresh(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: SocialNetworkManager.socialNetworks.length,
                    itemBuilder: (BuildContext context, int index) {
                      final network =
                          SocialNetworkManager.socialNetworks[index];
                      if (!network.available) {
                        return const SizedBox();
                      }
                      return ListTile(
                        leading: network.logo,
                        title: Text(
                          network.name,
                        ),
                        // Different build of subtle depending on the social network, for now only Instagram
                        subtitle: buildSubtitle(
                            context, controller.socialNetworks[index]),
                        trailing:
                            controller.socialNetworks[index].error == false
                                ? const Icon(
                                    CupertinoIcons.right_chevron,
                                  )
                                : const Icon(
                                    CupertinoIcons.refresh_bold,
                                  ),
                        // Different ways of connecting and disconnecting depending on the social network
                        onTap: () => controller.handleSocialNetworkAction(
                            controller.socialNetworks[index]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
