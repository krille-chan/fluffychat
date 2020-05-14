import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter_matrix_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'matrix.dart';

class HtmlMessage extends StatelessWidget {
  final String html;
  final Color textColor;
  final int maxLines;
  final Room room;

  const HtmlMessage({this.html, this.textColor, this.maxLines, this.room});

  @override
  Widget build(BuildContext context) {
    // there is no need to pre-validate the html, as we validate it while rendering
    
    return Html(
      data: html,
      defaultTextStyle: TextStyle(color: textColor),
      shrinkToFit: true,
      maxLines: maxLines,
      onLinkTap: (String url) {
        if (url == null || url.isEmpty) {
          return;
        }
        launch(url);
      },
      getMxcUrl: (String mxc, double width, double height) {
        final ratio = MediaQuery.of(context).devicePixelRatio;
        return Uri.parse(mxc)?.getThumbnail(
          Matrix.of(context).client,
          width: (width ?? 800) * ratio,
          height: (height ?? 800) * ratio,
          method: ThumbnailMethod.scale,
        );
      },
      getPillInfo: (String identifier) async {
        if (room == null) {
          return null;
        }
        if (identifier[0] == '@') {
          // we have a user pill
          final user = room.getState('m.room.member', identifier);
          if (user != null) {
            return user.content;
          }
          // there might still be a profile...
          final profile = await room.client.getProfileFromUserId(identifier);
          if (profile != null) {
            return {
              'displayname': profile.displayname,
              'avatar_url': profile.avatarUrl.toString(),
            };
          }
          return null;
        }
        if (identifier[0] == '#') {
          // we have an alias pill
          for (final r in room.client.rooms) {
            final state = r.getState('m.room.canonical_alias');
            if (
              state != null && (
              (state.content['alias'] is String && state.content['alias'] == identifier) ||
              (state.content['alt_aliases'] is List && state.content['alt_aliases'].contains(identifier))
            )) {
              // we have a room!
              return {
                'displayname': identifier,
                'avatar_url': r.getState('m.room.avatar')?.content['url'],
              };
            }
          }
          return null;
        }
        if (identifier[0] == '!') {
          // we have a room ID pill
          final r = room.client.getRoomById(identifier);
          if (r == null) {
            return null;
          }
          return {
            'displayname': r.canonicalAlias,
            'avatar_url': r.getState('m.room.avatar')?.content['url'],
          };
        }
        return null;
      },
    );
  }
}
