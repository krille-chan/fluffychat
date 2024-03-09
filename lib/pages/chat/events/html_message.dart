import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/shades-of-purple.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:linkify/linkify.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import '../../../utils/url_launcher.dart';

class HtmlMessage extends StatelessWidget {
  final String html;
  final Room room;
  final Color textColor;

  const HtmlMessage({
    super.key,
    required this.html,
    required this.room,
    this.textColor = Colors.black,
  });

  dom.Node _linkifyHtml(dom.Node element) {
    for (final node in element.nodes) {
      if (node is! dom.Text ||
          (element is dom.Element && element.localName == 'code')) {
        node.replaceWith(_linkifyHtml(node));
        continue;
      }

      final parts = linkify(
        node.text,
        options: const LinkifyOptions(humanize: false),
      );

      if (!parts.any((part) => part is UrlElement)) {
        continue;
      }

      final newHtml = parts
          .map(
            (linkifyElement) => linkifyElement is! UrlElement
                ? linkifyElement.text.replaceAll('<', '&#60;')
                : '<a href="${linkifyElement.text}">${linkifyElement.text}</a>',
          )
          .join(' ');

      node.replaceWith(dom.Element.html('<p>$newHtml</p>'));
    }
    return element;
  }

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

    final fontSize = AppConfig.messageFontSize * AppConfig.fontSizeFactor;

    // there is no need to pre-validate the html, as we validate it while rendering
    return HtmlWidget(
      renderHtml,
      customWidgetBuilder: (element) {
        if (!allowedHtmlTags.contains(element.localName)) {
          Logs().v('Do not render prohibited tag', element.localName);
          return Text(element.text);
        }
        if (element.localName == 'img') {
          final source = Uri.tryParse(element.attributes['src'] ?? '');
          if (source?.scheme != 'mxc') {
            Logs().v('Do not render img tag with illegal scheme', source);
            return Text(element.attributes['alt'] ?? element.text);
          }
        }
        return null;
      },
      customStylesBuilder: (element) {
        switch (element.localName) {
          case 'blockquote':
            return {
              'border-left':
                  '4px solid rgb(${textColor.red},${textColor.green},${textColor.blue})',
              'padding-left': '4px',
              'margin': '0px',
              'padding-top': '0px',
            };
          default:
            return null;
        }
      },
      textStyle: TextStyle(fontSize: fontSize, color: textColor),
      onTapUrl: (url) async {
        final consent = await showOkCancelAlertDialog(
          fullyCapitalizedForMaterial: false,
          context: context,
          title: L10n.of(context)!.openLinkInBrowser,
          message: url,
          okLabel: L10n.of(context)!.openLinkInBrowser,
          cancelLabel: L10n.of(context)!.cancel,
        );
        if (consent != OkCancelResult.ok) return true;

        UrlLauncher(context, url).launchUrl();
        return true;
      },
    );
  }

  static const Set<String> fallbackTextTags = {'tg-forward'};

  /// Keep in sync with: https://spec.matrix.org/v1.6/client-server-api/#mroommessage-msgtypes
  static const Set<String> allowedHtmlTags = {
    'font',
    'del',
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'blockquote',
    'p',
    'a',
    'ul',
    'ol',
    'sup',
    'sub',
    'li',
    'b',
    'i',
    'u',
    'strong',
    'em',
    'strike',
    'code',
    'hr',
    'br',
    'div',
    'table',
    'thead',
    'tbody',
    'tr',
    'th',
    'td',
    'caption',
    'pre',
    'span',
    'img',
    'details',
    'summary',
    // Not in the allowlist of the matrix spec yet but should be harmless:
    'ruby',
    'rp',
    'rt',
    // Workaround for https://github.com/krille-chan/fluffychat/issues/507
    ...fallbackTextTags,
  };
}

class MatrixPill extends StatelessWidget {
  final String name;
  final BuildContext outerContext;
  final Uri? avatar;
  final String uri;
  final double? fontSize;
  final Color? color;

  const MatrixPill({
    super.key,
    required this.name,
    required this.outerContext,
    this.avatar,
    required this.uri,
    required this.fontSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: UrlLauncher(outerContext, uri).launchUrl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Avatar(
            mxContent: avatar,
            name: name,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            name,
            style: TextStyle(
              color: color,
              decorationColor: color,
              decoration: TextDecoration.underline,
              fontSize: fontSize,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
