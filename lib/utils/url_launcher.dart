import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrouter/vrouter.dart';

class UrlLauncher {
  final String url;
  final BuildContext context;
  const UrlLauncher(this.context, this.url);

  void launchUrl() {
    if (url.toLowerCase().startsWith(AppConfig.inviteLinkPrefix) ||
        {'#', '@', '!', '+', '\$'}.contains(url[0]) ||
        url.toLowerCase().startsWith(AppConfig.schemePrefix)) {
      return openMatrixToUrl();
    }
    launch(url);
  }

  void openMatrixToUrl() async {
    final matrix = Matrix.of(context);
    // The identifier might be a matrix.to url and needs escaping. Or, it might have multiple
    // identifiers (room id & event id), or it might also have a query part.
    // All this needs parsing.
    final identityParts = url.parseIdentifierIntoParts();
    if (identityParts == null) {
      return; // no match, nothing to do
    }
    if (identityParts.primaryIdentifier.sigil == '#' ||
        identityParts.primaryIdentifier.sigil == '!') {
      // we got a room! Let's open that one
      final roomIdOrAlias = identityParts.primaryIdentifier;
      final event = identityParts.secondaryIdentifier;
      var room = matrix.client.getRoomByAlias(roomIdOrAlias) ??
          matrix.client.getRoomById(roomIdOrAlias);
      var roomId = room?.id;
      // we make the servers a set and later on convert to a list, so that we can easily
      // deduplicate servers added via alias lookup and query parameter
      final servers = <String>{};
      if (room == null && roomIdOrAlias.sigil == '#') {
        // we were unable to find the room locally...so resolve it
        final response = await showFutureLoadingDialog(
          context: context,
          future: () => matrix.client.getRoomIdByAlias(roomIdOrAlias),
        );
        if (response.error != null) {
          return; // nothing to do, the alias doesn't exist
        }
        roomId = response.result.roomId;
        servers.addAll(response.result.servers);
        room = matrix.client.getRoomById(roomId);
      }
      if (identityParts.via != null) {
        servers.addAll(identityParts.via);
      }
      if (room != null) {
        // we have the room, so....just open it
        if (event != null) {
          VRouter.of(context)
              .push('/rooms/${room.id}', queryParameters: {'event': event});
        } else {
          VRouter.of(context).push('/rooms/${room.id}');
        }
        return;
      }
      if (roomIdOrAlias.sigil == '!') {
        if (await showOkCancelAlertDialog(
              useRootNavigator: false,
              context: context,
              title: 'Join room $roomIdOrAlias',
            ) ==
            OkCancelResult.ok) {
          roomId = roomIdOrAlias;
          final response = await showFutureLoadingDialog(
            context: context,
            future: () => matrix.client.joinRoom(
              roomIdOrAlias,
              servers: servers.isNotEmpty ? servers.toList() : null,
            ),
          );
          if (response.error != null) return;
          // wait for two seconds so that it probably came down /sync
          await showFutureLoadingDialog(
              context: context,
              future: () => Future.delayed(const Duration(seconds: 2)));
          if (event != null) {
            VRouter.of(context).push('/rooms/${response.result}/$event');
          } else {
            VRouter.of(context).push('/rooms/${response.result}');
          }
        }
      } else {
        VRouter.of(context).push('/search', queryParameters: {
          if (roomIdOrAlias != null) 'query': roomIdOrAlias
        });
      }
    } else if (identityParts.primaryIdentifier.sigil == '@') {
      final user = User(
        identityParts.primaryIdentifier,
        room: Room(id: '', client: matrix.client),
      );
      var roomId = matrix.client.getDirectChatFromUserId(user.id);
      if (roomId != null) {
        VRouter.of(context).push('/rooms/$roomId');

        return;
      }

      if (await showOkCancelAlertDialog(
            useRootNavigator: false,
            context: context,
            title: 'Message user ${user.id}',
          ) ==
          OkCancelResult.ok) {
        roomId = (await showFutureLoadingDialog(
          context: context,
          future: () => user.startDirectChat(),
        ))
            .result;

        if (roomId != null) {
          VRouter.of(context).push('/rooms/$roomId');
        }
      }
    }
  }
}
