import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:matrix/matrix.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrouter/vrouter.dart';
import 'package:punycode/punycode.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'platform_infos.dart';

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
    final uri = Uri.tryParse(url);
    if (uri == null) {
      // we can't open this thing
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context).cantOpenUri(url))));
      return;
    }
    if (!{'https', 'http'}.contains(uri.scheme)) {
      // just launch non-https / non-http uris directly

      // transmute geo URIs on desktop to openstreetmap links, as those usually can't hanlde
      // geo URIs
      if (!PlatformInfos.isMobile && uri.scheme == 'geo' && uri.path != null) {
        final latlong = uri.path
            .split(';')
            .first
            .split(',')
            .map((s) => double.tryParse(s))
            .toList();
        if (latlong.length == 2 &&
            latlong.first != null &&
            latlong.last != null) {
          launch(
              'https://www.openstreetmap.org/?mlat=${latlong.first}&mlon=${latlong.last}#map=16/${latlong.first}/${latlong.last}');
          return;
        }
      }
      launch(url);
      return;
    }
    if (uri.host == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context).cantOpenUri(url))));
      return;
    }
    // okay, we have either an http or an https URI.
    // As some platforms have issues with opening unicode URLs, we are going to help
    // them out by punycode-encoding them for them ourself.
    final newHost = uri.host.split('.').map((hostPartEncoded) {
      final hostPart = Uri.decodeComponent(hostPartEncoded);
      final hostPartPunycode = punycodeEncode(hostPart);
      return hostPartPunycode != hostPart + '-'
          ? 'xn--$hostPartPunycode'
          : hostPart;
    }).join('.');
    launch(uri.replace(host: newHost).toString());
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
              .to('/rooms/${room.id}', queryParameters: {'event': event});
        } else {
          VRouter.of(context).to('/rooms/${room.id}');
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
            VRouter.of(context).to('/rooms/${response.result}/$event');
          } else {
            VRouter.of(context).to('/rooms/${response.result}');
          }
        }
      } else {
        VRouter.of(context).to('/search', queryParameters: {
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
        VRouter.of(context).to('/rooms/$roomId');

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
          VRouter.of(context).to('/rooms/$roomId');
        }
      }
    }
  }
}
