import 'package:fluffychat/pages/add_bridge/service/bot_bridge_connection.dart';
import 'package:fluffychat/pages/add_bridge/show_bottom_sheet.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import 'add_bridge_header.dart';
import 'connection_bridge_dialog.dart';
import 'model/social_network.dart';

// Page offering brigde bot connections to social network chats
// Takes the user's Client ( Matrix ) as parameter
class AddBridgeBody extends StatefulWidget {
  final Client client;
  const AddBridgeBody({super.key, required this.client});

  @override
  State<AddBridgeBody> createState() => _AddBridgeBodyState();
}

class _AddBridgeBodyState extends State<AddBridgeBody> {

  bool instagramConnected = false;
  bool loadingInstagram = true;

  late BotBridgeConnection botConnection;

  @override
  void initState() {
    botConnection = BotBridgeConnection(client: widget.client);
    super.initState();
    _initStateAsync();
  }

  // Online status update when page is opened
  Future<void> _initStateAsync() async {
    instagramConnected = await botConnection.instagramPing();
    setState(() {
      loadingInstagram = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildHeaderBridgeText(context),
            buildHeaderBridgeSubText(context),
            Center(
              child: SizedBox(
                width: PlatformInfos.isWeb ?MediaQuery.of(context).size.width/2 :null,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: socialNetwork.length,
                  itemBuilder: (BuildContext context, int index) {

                    return ListTile(
                      leading: socialNetwork[index].logo,
                      title: Text(
                        socialNetwork[index].name,
                      ),
                      // Different build of subtle depending on the social network, for now only Instagram
                      subtitle: buildSubtitle(socialNetwork[index]),
                      trailing: const Icon(
                        CupertinoIcons.right_chevron,
                      ),

                      // Different ways of connecting and disconnecting depending on the social network
                      onTap: () => handleSocialNetworkAction(socialNetwork[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Different ways of connecting and disconnecting depending on the social network, for now only Instagram
  void handleSocialNetworkAction(SocialNetwork network) async {
    if(network.name == "Instagram"){
      if (loadingInstagram == false) {
        if (instagramConnected != true) {
          // Trying to connect to Instagram
          final bool success = await connectToInstagram(context, network, botConnection);
          if (success) {
            setState(() {
              instagramConnected = true;
            });
          }
        } else {
          // Disconnect button, for the moment only this choice
          final bool success = await showBottomSheetBridge(
            context,
            network,
            botConnection,
          );

          if (success) {
            setState(() {
              instagramConnected = false;
            });
          }
        }
      }
    }
  }

  // Different build of subtle depending on the social network, for now only Instagram
  Widget buildSubtitle(SocialNetwork network) {
    if (loadingInstagram && network.name == "Instagram") {
      return const Align(
        alignment: Alignment.centerLeft,
        child: CircularProgressIndicator(
          color: Colors.grey,
        ),
      );
    } else {
      return Text(
        network.name == "Instagram" && instagramConnected
            ? L10n.of(context)!.connected
            : L10n.of(context)!.notConnected,
        style: TextStyle(
          color: network.name == "Instagram" && instagramConnected
              ? Colors.green
              : Colors.grey,
        ),
      );
    }
  }
}