import 'package:flutter/material.dart';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:punycode/punycode.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/user_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../widgets/adaptive_dialogs/public_room_dialog.dart';
import 'platform_infos.dart';

class UrlLauncher {
  /// The url to open.
  final String? url;

  /// The visible name in the GUI. For example the name of a markdown link
  /// which may differ from the actual url to open.
  final String? name;

  final BuildContext context;

  const UrlLauncher(this.context, this.url, [this.name]);

  void launchUrl() async {
    if (url!.toLowerCase().startsWith(AppConfig.deepLinkPrefix) ||
        url!.toLowerCase().startsWith(AppConfig.inviteLinkPrefix) ||
        {'#', '@', '!', '+', '\$'}.contains(url![0]) ||
        url!.toLowerCase().startsWith(AppConfig.schemePrefix)) {
      return openMatrixToUrl();
    }
    final uri = Uri.tryParse(url!);
    if (uri == null) {
      // we can't open this thing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).cantOpenUri(url!))),
      );
      return;
    }

    if (name != null && url != name) {
      // If there is a name which differs from the url, we need to make sure
      // that the user can see the actual url before opening the browser.
      final consent = await showOkCancelAlertDialog(
        context: context,
        title: L10n.of(context).openLinkInBrowser,
        message: url,
        okLabel: L10n.of(context).open,
        cancelLabel: L10n.of(context).cancel,
      );
      if (consent != OkCancelResult.ok) return;
    }

    if (!{'https', 'http'}.contains(uri.scheme)) {
      // just launch non-https / non-http uris directly

      // we need to transmute geo URIs on desktop and on iOS
      if ((!PlatformInfos.isMobile || PlatformInfos.isIOS) &&
          uri.scheme == 'geo') {
        final latlong = uri.path
            .split(';')
            .first
            .split(',')
            .map((s) => double.tryParse(s))
            .toList();
        if (latlong.length == 2 &&
            latlong.first != null &&
            latlong.last != null) {
          if (PlatformInfos.isIOS) {
            // iOS is great at not following standards, so we need to transmute the geo URI
            // to an apple maps thingy
            // https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
            final ll = '${latlong.first},${latlong.last}';
            launchUrlString('https://maps.apple.com/?q=$ll&sll=$ll');
          } else {
            // transmute geo URIs on desktop to openstreetmap links, as those usually can't handle
            // geo URIs
            launchUrlString(
              'https://www.openstreetmap.org/?mlat=${latlong.first}&mlon=${latlong.last}#map=16/${latlong.first}/${latlong.last}',
            );
          }
          return;
        }
      }
      launchUrlString(url!);
      return;
    }
    if (uri.host.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).cantOpenUri(url!))),
      );
      return;
    }
    // okay, we have either an http or an https URI.
    // As some platforms have issues with opening unicode URLs, we are going to help
    // them out by punycode-encoding them for them ourself.
    final newHost = uri.host.split('.').map((hostPartEncoded) {
      final hostPart = Uri.decodeComponent(hostPartEncoded);
      final hostPartPunycode = punycodeEncode(hostPart);
      return hostPartPunycode != '$hostPart-'
          ? 'xn--$hostPartPunycode'
          : hostPart;
    }).join('.');
    // Force LaunchMode.externalApplication, otherwise url_launcher will default
    // to opening links in a webview on mobile platforms.
    launchUrlString(
      uri.replace(host: newHost).toString(),
      mode: LaunchMode.externalApplication,
    );
  }

  void openMatrixToUrl() async {
    final matrix = Matrix.of(context);
    final url = this.url!.replaceFirst(
          AppConfig.deepLinkPrefix,
          AppConfig.inviteLinkPrefix,
        );

    // The identifier might be a matrix.to url and needs escaping. Or, it might have multiple
    // identifiers (room id & event id), or it might also have a query part.
    // All this needs parsing.
    final identityParts = url.parseIdentifierIntoParts() ??
        Uri.tryParse(url)?.host.parseIdentifierIntoParts() ??
        Uri.tryParse(url)
            ?.pathSegments
            .lastWhereOrNull((_) => true)
            ?.parseIdentifierIntoParts();
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
        roomId = response.result!.roomId;
        servers.addAll(response.result!.servers!);
        room = matrix.client.getRoomById(roomId!);
      }
      servers.addAll(identityParts.via);
      if (room != null) {
        if (room.isSpace) {
          // TODO: Implement navigate to space
          context.go('/rooms/${room.id}');

          return;
        }
        // we have the room, so....just open it
        if (event != null) {
          context.go(
            '/${Uri(
              pathSegments: ['rooms', room.id],
              queryParameters: {'event': event},
            )}',
          );
        } else {
          context.go('/rooms/${room.id}');
        }
        return;
      } else {
        await showAdaptiveDialog(
          context: context,
          builder: (c) => PublicRoomDialog(
            roomAlias: identityParts.primaryIdentifier,
          ),
        );
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
              serverName: servers.isNotEmpty ? servers.toList() : null,
            ),
          );
          if (response.error != null) return;
          // wait for two seconds so that it probably came down /sync
          await showFutureLoadingDialog(
            context: context,
            future: () => Future.delayed(const Duration(seconds: 2)),
          );
          if (event != null) {
            context.go(
              Uri(
                pathSegments: ['rooms', response.result!],
                queryParameters: {'event': event},
              ).toString(),
            );
          } else {
            context.go('/rooms/${response.result!}');
          }
        }
      }
    } else if (identityParts.primaryIdentifier.sigil == '@') {
      final userId = identityParts.primaryIdentifier;
      var noProfileWarning = false;
      final profileResult = await showFutureLoadingDialog(
        context: context,
        future: () => matrix.client.getProfileFromUserId(userId).catchError(
          (_) {
            noProfileWarning = true;
            return Profile(userId: userId);
          },
        ),
      );
      await UserDialog.show(
        context: context,
        profile: profileResult.result!,
        noProfileWarning: noProfileWarning,
      );
    }
  }
}
