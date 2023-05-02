import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_matrix_html/flutter_html.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/matrix.dart';
import '../../../config/app_config.dart';
import '../../../config/setting_keys.dart';
import '../../../utils/matrix_sdk_extensions/matrix_locals.dart';
import '../../../utils/url_launcher.dart';

class HtmlMessage extends StatelessWidget {
  final String html;
  final int? maxLines;
  final Room room;
  final TextStyle? defaultTextStyle;
  final TextStyle? linkStyle;
  final double? emoteSize;

  const HtmlMessage({
    Key? key,
    required this.html,
    this.maxLines,
    required this.room,
    this.defaultTextStyle,
    this.linkStyle,
    this.emoteSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // riot-web is notorious for creating bad reply fallback events from invalid messages which, if
    // not handled properly, can lead to impersination. As such, we strip the entire `<mx-reply>` tags
    // here already, to prevent that from happening.
    // We do *not* do this in an AST and just with simple regex here, as riot-web tends to create
    // miss-matching tags, and this way we actually correctly identify what we want to strip and, well,
    // strip it.
    final renderHtml = html.replaceAll(
      RegExp(
        '<mx-reply>.*</mx-reply>',
        caseSensitive: false,
        multiLine: false,
        dotAll: true,
      ),
      '',
    );

    // there is no need to pre-validate the html, as we validate it while rendering

    final matrix = Matrix.of(context);

    final themeData = Theme.of(context);
    return Html(
      data: renderHtml,
      defaultTextStyle: defaultTextStyle,
      emoteSize: emoteSize,
      linkStyle: linkStyle ??
          themeData.textTheme.bodyMedium!.copyWith(
            color: themeData.colorScheme.secondary,
            decoration: TextDecoration.underline,
            decorationColor: themeData.colorScheme.secondary,
          ),
      shrinkToFit: true,
      maxLines: maxLines,
      onLinkTap: (url) => UrlLauncher(context, url).launchUrl(),
      onPillTap: (url) => UrlLauncher(context, url).launchUrl(),
      getMxcUrl: (
        String mxc,
        double? width,
        double? height, {
        bool? animated = false,
      }) {
        final ratio = MediaQuery.of(context).devicePixelRatio;
        return Uri.parse(mxc)
            .getThumbnail(
              matrix.client,
              width: (width ?? 800) * ratio,
              height: (height ?? 800) * ratio,
              method: ThumbnailMethod.scale,
              animated: AppConfig.autoplayImages ? animated : false,
            )
            .toString();
      },
      onImageTap: (url) => UrlLauncher(context, url).launchUrl(),
      setCodeLanguage: (String key, String value) async {
        await matrix.store.setItem('${SettingKeys.codeLanguage}.$key', value);
      },
      getCodeLanguage: (String key) async {
        return await matrix.store.getItem('${SettingKeys.codeLanguage}.$key');
      },
      getPillInfo: (String url) async {
        final identityParts = url.parseIdentifierIntoParts();
        final identifier = identityParts?.primaryIdentifier;
        if (identifier == null) {
          return {};
        }
        if (identifier.sigil == '@') {
          // we have a user pill
          final user = room.getState('m.room.member', identifier);
          if (user != null) {
            return user.content;
          }
          // there might still be a profile...
          final profile = await room.client.getProfileFromUserId(identifier);
          return {
            'displayname': profile.displayName,
            'avatar_url': profile.avatarUrl.toString(),
          };
        }
        if (identifier.sigil == '#') {
          // we have an alias pill
          for (final r in room.client.rooms) {
            final state = r.getState('m.room.canonical_alias');
            if (state != null &&
                ((state.content['alias'] is String &&
                        state.content['alias'] == identifier) ||
                    (state.content['alt_aliases'] is List &&
                        state.content['alt_aliases'].contains(identifier)))) {
              // we have a room!
              return {
                'displayname':
                    r.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!)),
                'avatar_url': r.getState('m.room.avatar')?.content['url'],
              };
            }
          }
          return {};
        }
        if (identifier.sigil == '!') {
          // we have a room ID pill
          final r = room.client.getRoomById(identifier);
          if (r == null) {
            return {};
          }
          return {
            'displayname':
                r.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!)),
            'avatar_url': r.getState('m.room.avatar')?.content['url'],
          };
        }
        return {};
      },
    );
  }
}
