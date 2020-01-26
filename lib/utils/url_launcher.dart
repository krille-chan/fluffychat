import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  final String url;
  final BuildContext context;
  const UrlLauncher(this.context, this.url);

  void launchUrl() {
    if (url.startsWith("https://matrix.to/#/")) {
      return openMatrixToUrl();
    }
    launch(url);
  }

  void openMatrixToUrl() async {
    final matrix = Matrix.of(context);
    final String identifier = url.replaceAll("https://matrix.to/#/", "");
    if (identifier.substring(0, 1) == "#") {
      final response = await matrix.tryRequestWithLoadingDialog(
        matrix.client.joinRoomById(
          Uri.encodeComponent(identifier),
        ),
      );
      if (response == false) return;
      await Navigator.pushAndRemoveUntil(
        context,
        AppRoute.defaultRoute(context, Chat(response["room_id"])),
        (r) => r.isFirst,
      );
    } else if (identifier.substring(0, 1) == "@") {
      final User user = User(
        identifier,
        room: Room(id: "", client: matrix.client),
      );
      final String roomID =
          await matrix.tryRequestWithLoadingDialog(user.startDirectChat());
      Navigator.of(context).pop();

      if (roomID != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Chat(roomID)),
        );
      }
    }
  }
}
