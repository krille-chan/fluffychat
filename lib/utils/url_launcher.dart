import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
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
    if (url.startsWith('https://matrix.to/#/') ||
        {'#', '@', '!', '+', '\$'}.contains(url[0])) {
      return openMatrixToUrl();
    }
    launch(url);
  }

  void openMatrixToUrl() async {
    final matrix = Matrix.of(context);
    final identifier = url.replaceAll('https://matrix.to/#/', '');
    if (identifier[0] == '#' || identifier[0] == '!') {
      var room = matrix.client.getRoomByAlias(identifier);
      room ??= matrix.client.getRoomById(identifier);
      var roomId = room?.id;
      var servers = <String>[];
      if (room == null && identifier == '#') {
        // we were unable to find the room locally...so resolve it
        final response =
            await SimpleDialogs(context).tryRequestWithLoadingDialog(
          matrix.client.requestRoomAliasInformations(identifier),
        );
        if (response != false) {
          roomId = response.roomId;
          servers = response.servers;
          room = matrix.client.getRoomById(roomId);
        }
      }
      if (room != null) {
        // we have the room, so....just open it!
        await Navigator.pushAndRemoveUntil(
          context,
          AppRoute.defaultRoute(context, ChatView(room.id)),
          (r) => r.isFirst,
        );
        return;
      }
      if (identifier == '!') {
        roomId = identifier;
      }
      if (roomId == null) {
        // we haven't found this room....so let's ignore it
        return;
      }
      if (await SimpleDialogs(context)
          .askConfirmation(titleText: 'Join room $identifier')) {
        final response =
            await SimpleDialogs(context).tryRequestWithLoadingDialog(
          matrix.client.joinRoomOrAlias(
            Uri.encodeComponent(roomId),
            servers: servers,
          ),
        );
        if (response == false) return;
        await Navigator.pushAndRemoveUntil(
          context,
          AppRoute.defaultRoute(context, ChatView(response['room_id'])),
          (r) => r.isFirst,
        );
      }
    } else if (identifier[0] == '@') {
      final user = User(
        identifier,
        room: Room(id: '', client: matrix.client),
      );
      var roomId = matrix.client.getDirectChatFromUserId(identifier);
      if (roomId != null) {
        await Navigator.pushAndRemoveUntil(
          context,
          AppRoute.defaultRoute(context, ChatView(roomId)),
          (r) => r.isFirst,
        );
        return;
      }

      if (await SimpleDialogs(context)
          .askConfirmation(titleText: 'Message user $identifier')) {
        roomId = await SimpleDialogs(context)
            .tryRequestWithLoadingDialog(user.startDirectChat());
        Navigator.of(context).pop();

        if (roomId != null) {
          await Navigator.pushAndRemoveUntil(
            context,
            AppRoute.defaultRoute(context, ChatView(roomId)),
            (r) => r.isFirst,
          );
        }
      }
    }
  }
}
