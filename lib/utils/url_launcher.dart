import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/app_config.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:fluffychat/views/discover_view.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'matrix_identifier_string_extension.dart';

class UrlLauncher {
  final String url;
  final BuildContext context;
  const UrlLauncher(this.context, this.url);

  void launchUrl() {
    if (url.startsWith(AppConfig.inviteLinkPrefix) ||
        {'#', '@', '!', '+', '\$'}.contains(url[0])) {
      return openMatrixToUrl();
    }
    launch(url);
  }

  void openMatrixToUrl() async {
    final matrix = Matrix.of(context);
    final identifier = url.replaceAll(AppConfig.inviteLinkPrefix, '');
    if (identifier[0] == '#' || identifier[0] == '!') {
      // sometimes we have identifiers which have an event id and additional query parameters
      // we want to separate those.
      final identityParts = identifier.parseIdentifierIntoParts();
      if (identityParts == null) {
        return; // no match, nothing to do
      }
      final roomIdOrAlias = identityParts.roomIdOrAlias;
      final event = identityParts.eventId;
      final query = identityParts.queryString;
      var room = matrix.client.getRoomByAlias(roomIdOrAlias) ??
          matrix.client.getRoomById(roomIdOrAlias);
      var roomId = room?.id;
      // we make the servers a set and later on convert to a list, so that we can easily
      // deduplicate servers added via alias lookup and query parameter
      var servers = <String>{};
      if (room == null && roomIdOrAlias.startsWith('#')) {
        // we were unable to find the room locally...so resolve it
        final response = await showFutureLoadingDialog(
          context: context,
          future: () =>
              matrix.client.requestRoomAliasInformations(roomIdOrAlias),
        );
        if (response.error == null) {
          roomId = response.result.roomId;
          servers.addAll(response.result.servers);
          room = matrix.client.getRoomById(roomId);
        }
      }
      if (query != null) {
        // the query information might hold additional servers to try, so let's try them!
        // as there might be multiple "via" tags we can't just use Uri.splitQueryString, we need to do our own thing
        for (final parameter in query.split('&')) {
          final index = parameter.indexOf('=');
          if (index == -1) {
            continue;
          }
          if (Uri.decodeQueryComponent(parameter.substring(0, index)) !=
              'via') {
            continue;
          }
          servers.add(Uri.decodeQueryComponent(parameter.substring(index + 1)));
        }
      }
      if (room != null) {
        // we have the room, so....just open it!
        await Navigator.pushAndRemoveUntil(
          context,
          AppRoute.defaultRoute(
              context, ChatView(room.id, scrollToEventId: event)),
          (r) => r.isFirst,
        );
        return;
      }
      if (roomIdOrAlias.sigil == '!') {
        roomId = roomIdOrAlias;
        final response = await showFutureLoadingDialog(
          context: context,
          future: () => matrix.client.joinRoomOrAlias(
            roomIdOrAlias,
            servers: servers.isNotEmpty ? servers.toList() : null,
          ),
        );
        if (response.error != null) return;
        // wait for two seconds so that it probably came down /sync
        await showFutureLoadingDialog(
            context: context,
            future: () => Future.delayed(const Duration(seconds: 2)));
        await Navigator.pushAndRemoveUntil(
          context,
          AppRoute.defaultRoute(
              context, ChatView(response.result, scrollToEventId: event)),
          (r) => r.isFirst,
        );
      } else if (identifier.sigil == '#') {
        await Navigator.of(context).pushAndRemoveUntil(
          AppRoute.defaultRoute(
            context,
            DiscoverView(alias: identifier),
          ),
          (r) => r.isFirst,
        );
      } else if (identifier.sigil == '@') {
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

        if (await showOkCancelAlertDialog(
              context: context,
              title: 'Message user $identifier',
            ) ==
            OkCancelResult.ok) {
          roomId = (await showFutureLoadingDialog(
            context: context,
            future: () => user.startDirectChat(),
          ))
              .result;
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
}
