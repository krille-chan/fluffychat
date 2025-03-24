import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/shades-of-purple.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import '../../../utils/url_launcher.dart';

class HtmlMessage extends StatelessWidget {
  final String html;
  final Room room;
  final Color textColor;
  final double fontSize;
  final TextStyle linkStyle;
  final void Function(LinkableElement) onOpen;
  // #Pangea
  final bool isOverlay;
  final PangeaMessageEvent? pangeaMessageEvent;
  final ChatController controller;
  final Event event;
  final Event? nextEvent;
  final Event? prevEvent;

  final bool Function(PangeaToken)? isSelected;
  final void Function(PangeaToken)? onClick;
  // Pangea#

  const HtmlMessage({
    super.key,
    required this.html,
    required this.room,
    required this.fontSize,
    required this.linkStyle,
    this.textColor = Colors.black,
    required this.onOpen,
    // #Pangea
    required this.isOverlay,
    required this.event,
    this.pangeaMessageEvent,
    required this.controller,
    this.nextEvent,
    this.prevEvent,
    this.isSelected,
    this.onClick,
    // Pangea#
  });

  /// Keep in sync with: https://spec.matrix.org/latest/client-server-api/#mroommessage-msgtypes
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
    'html',
    'body',
    // Workaround for https://github.com/krille-chan/fluffychat/issues/507
    'tg-forward',
    // #Pangea
    'token',
    // Pangea#
  };

  /// We add line breaks before these tags:
  static const Set<String> blockHtmlTags = {
    'p',
    'ul',
    'ol',
    'pre',
    'div',
    'table',
    'details',
    'blockquote',
  };

  /// We add line breaks before these tags:
  static const Set<String> fullLineHtmlTag = {
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'li',
  };

  // #Pangea
  List<PangeaToken>? get tokens =>
      pangeaMessageEvent?.messageDisplayRepresentation?.tokens;

  PangeaToken? getToken(
    String text,
    int offset,
    int length,
  ) =>
      tokens?.firstWhereOrNull(
        (token) => token.text.offset == offset && token.text.length == length,
      );

  /// Wrap token spans in token tags so styling / functions can be applied
  dom.Node _tokenizeHtml(
    dom.Node element,
    String fullHtml,
    List<PangeaToken> remainingTokens,
  ) {
    for (final node in element.nodes) {
      node.replaceWith(_tokenizeHtml(node, fullHtml, remainingTokens));
    }

    if (element is dom.Text) {
      // once a text element in reached in the HTML tree, find and
      // wrap all the spans with matching tokens until all tokens
      // have been wrapped or no more text elements remain
      String tokenizedText = element.text;
      while (remainingTokens.isNotEmpty) {
        final tokenText = remainingTokens.first.text.content;

        int startIndex = tokenizedText.lastIndexOf('</token>');
        startIndex = startIndex == -1 ? 0 : startIndex + 8;
        final int tokenIndex = tokenizedText.indexOf(
          tokenText,
          startIndex,
        );

        // if the token is not found in the text, check if the token exist in the full HTML.
        // If not, remove the token and continue. If so, break to move on to the next node in the HTML.
        if (tokenIndex == -1) {
          final fullHtmlIndex = fullHtml.indexOf(tokenText);
          if (fullHtmlIndex == -1) {
            remainingTokens.removeAt(0);
            continue;
          } else {
            break;
          }
        }

        final token = remainingTokens.removeAt(0);
        final tokenEnd = tokenIndex + tokenText.length;
        final before = tokenizedText.substring(0, tokenIndex);
        final after = tokenizedText.substring(tokenEnd);

        tokenizedText =
            "$before<token offset=\"${token.text.offset}\" length=\"${token.text.length}\">$tokenText</token>$after";
      }

      final newElement = dom.Element.html('<span>$tokenizedText</span>');
      return newElement;
    }

    return element;
  }
  // Pangea#

  /// Adding line breaks before block elements.
  List<InlineSpan> _renderWithLineBreaks(
    dom.NodeList nodes,
    BuildContext context, {
    int depth = 1,
  }) {
    final onlyElements = nodes.whereType<dom.Element>().toList();
    return [
      for (var i = 0; i < nodes.length; i++) ...[
        // Actually render the node child:
        _renderHtml(nodes[i], context, depth: depth + 1),
        // Add linebreaks between blocks:
        if (nodes[i] is dom.Element &&
            onlyElements.indexOf(nodes[i] as dom.Element) <
                onlyElements.length - 1) ...[
          if (blockHtmlTags.contains((nodes[i] as dom.Element).localName))
            const TextSpan(text: '\n\n'),
          if (fullLineHtmlTag.contains((nodes[i] as dom.Element).localName))
            const TextSpan(text: '\n'),
        ],
      ],
    ];
  }

  /// Transforms a Node to an InlineSpan.
  InlineSpan _renderHtml(
    dom.Node node,
    BuildContext context, {
    int depth = 1,
  }) {
    // We must not render elements nested more than 100 elements deep:
    if (depth >= 100) return const TextSpan();

    // This is a text node, so we render it as text:
    if (node is! dom.Element) {
      var text = node.text ?? '';
      // Single linebreak nodes between Elements are ignored:
      if (text == '\n') text = '';

      return LinkifySpan(
        text: text,
        options: const LinkifyOptions(humanize: false),
        linkStyle: linkStyle,
        onOpen: onOpen,
      );
    }

    // We must not render tags which are not in the allow list:
    if (!allowedHtmlTags.contains(node.localName)) return const TextSpan();

    switch (node.localName) {
      // #Pangea
      case 'token':
        final token = getToken(
          node.attributes['offset'] ?? '',
          int.tryParse(node.attributes['offset'] ?? '') ?? 0,
          int.tryParse(node.attributes['length'] ?? '') ?? 0,
        );

        final selected = token != null && isSelected != null
            ? isSelected!.call(token)
            : false;

        final shouldDo = pangeaMessageEvent?.shouldDoActivity(
              token: token,
              a: ActivityTypeEnum.wordMeaning,
              feature: null,
              tag: null,
            ) ??
            false;

        // @ggurdin: probably changing this, not sure when it shows up
        final didMeaningActivity = token?.didActivitySuccessfully(
              ActivityTypeEnum.wordMeaning,
            ) ??
            true;

        Color backgroundColor = Colors.transparent;
        if (selected) {
          backgroundColor = Theme.of(context).colorScheme.primary.withAlpha(80);
        } else if (isSelected != null && shouldDo) {
          backgroundColor = !didMeaningActivity
              ? AppConfig.success.withAlpha(60)
              : AppConfig.gold.withAlpha(60);
        }

        return WidgetSpan(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onClick != null && token != null
                  ? () => onClick?.call(token)
                  : null,
              child: RichText(
                text: TextSpan(
                  children: [
                    LinkifySpan(
                      text: node.innerHtml,
                      style: AppConfig.messageTextStyle(
                        pangeaMessageEvent!.event,
                        textColor,
                      ).merge(TextStyle(backgroundColor: backgroundColor)),
                      linkStyle: linkStyle,
                      onOpen: (url) =>
                          UrlLauncher(context, url.url).launchUrl(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      // Pangea#
      case 'br':
        return const TextSpan(text: '\n');
      case 'a':
        final href = node.attributes['href'];
        if (href == null) continue block;
        final matrixId = node.attributes['href']
            ?.parseIdentifierIntoParts()
            ?.primaryIdentifier;
        if (matrixId != null) {
          if (matrixId.sigil == '@') {
            final user = room.unsafeGetUserFromMemoryOrFallback(matrixId);
            return WidgetSpan(
              child: MatrixPill(
                key: Key('user_pill_$matrixId'),
                name: user.calcDisplayname(),
                avatar: user.avatarUrl,
                uri: href,
                outerContext: context,
                fontSize: fontSize,
                color: linkStyle.color,
              ),
            );
          }
          if (matrixId.sigil == '#' || matrixId.sigil == '!') {
            final room = matrixId.sigil == '!'
                ? this.room.client.getRoomById(matrixId)
                : this.room.client.getRoomByAlias(matrixId);
            return WidgetSpan(
              child: MatrixPill(
                name: room?.getLocalizedDisplayname() ?? matrixId,
                avatar: room?.avatar,
                uri: href,
                outerContext: context,
                fontSize: fontSize,
                color: linkStyle.color,
              ),
            );
          }
        }
        return WidgetSpan(
          child: Tooltip(
            message: href,
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () => UrlLauncher(context, href, node.text).launchUrl(),
              child: Text.rich(
                TextSpan(
                  children: _renderWithLineBreaks(
                    node.nodes,
                    context,
                    depth: depth,
                  ),
                  style: linkStyle,
                ),
                style: const TextStyle(height: 1.25),
              ),
            ),
          ),
        );
      case 'li':
        if (!{'ol', 'ul'}.contains(node.parent?.localName)) {
          continue block;
        }
        return WidgetSpan(
          child: Padding(
            padding: EdgeInsets.only(left: fontSize),
            child: Text.rich(
              TextSpan(
                children: [
                  if (node.parent?.localName == 'ul')
                    const TextSpan(text: '• '),
                  if (node.parent?.localName == 'ol')
                    TextSpan(
                      text:
                          '${(node.parent?.nodes.indexOf(node) ?? 0) + (int.tryParse(node.parent?.attributes['start'] ?? '1') ?? 1)}. ',
                    ),
                  ..._renderWithLineBreaks(
                    node.nodes,
                    context,
                    depth: depth,
                  ),
                ],
                style: TextStyle(fontSize: fontSize, color: textColor),
              ),
            ),
          ),
        );
      case 'blockquote':
        return WidgetSpan(
          child: Container(
            padding: const EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: textColor,
                  width: 3,
                ),
              ),
            ),
            child: Text.rich(
              TextSpan(
                children: _renderWithLineBreaks(
                  node.nodes,
                  context,
                  depth: depth,
                ),
              ),
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: fontSize,
                color: textColor,
              ),
            ),
          ),
        );
      case 'code':
        final isInline = node.parent?.localName != 'pre';
        return WidgetSpan(
          child: Material(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: HighlightView(
                node.text,
                language: node.className
                        .split(' ')
                        .singleWhereOrNull(
                          (className) => className.startsWith('language-'),
                        )
                        ?.split('language-')
                        .last ??
                    'md',
                theme: shadesOfPurpleTheme,
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: isInline ? 0 : 8,
                ),
                textStyle: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'UbuntuMono',
                ),
              ),
            ),
          ),
        );
      case 'img':
        final mxcUrl = Uri.tryParse(node.attributes['src'] ?? '');
        if (mxcUrl == null || mxcUrl.scheme != 'mxc') {
          return TextSpan(text: node.attributes['alt']);
        }

        final width = double.tryParse(node.attributes['width'] ?? '');
        final height = double.tryParse(node.attributes['height'] ?? '');
        const defaultDimension = 64.0;
        final actualWidth = width ?? height ?? defaultDimension;
        final actualHeight = height ?? width ?? defaultDimension;

        return WidgetSpan(
          child: SizedBox(
            width: actualWidth,
            height: actualHeight,
            child: MxcImage(
              uri: mxcUrl,
              width: actualWidth,
              height: actualHeight,
              isThumbnail: (actualWidth * actualHeight) > (256 * 256),
            ),
          ),
        );
      case 'hr':
        return const WidgetSpan(child: Divider());
      case 'details':
        var obscure = true;
        return WidgetSpan(
          child: StatefulBuilder(
            builder: (context, setState) => InkWell(
              splashColor: Colors.transparent,
              onTap: () => setState(() {
                obscure = !obscure;
              }),
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        obscure ? Icons.arrow_right : Icons.arrow_drop_down,
                        size: fontSize * 1.2,
                        color: textColor,
                      ),
                    ),
                    if (obscure)
                      ...node.nodes
                          .where(
                            (node) =>
                                node is dom.Element &&
                                node.localName == 'summary',
                          )
                          .map(
                            (node) => _renderHtml(node, context, depth: depth),
                          )
                    else
                      ..._renderWithLineBreaks(
                        node.nodes,
                        context,
                        depth: depth,
                      ),
                  ],
                ),
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                ),
              ),
            ),
          ),
        );
      case 'span':
        if (!node.attributes.containsKey('data-mx-spoiler')) {
          continue block;
        }
        var obscure = true;
        return WidgetSpan(
          child: StatefulBuilder(
            builder: (context, setState) => InkWell(
              splashColor: Colors.transparent,
              onTap: () => setState(() {
                obscure = !obscure;
              }),
              child: Text.rich(
                TextSpan(
                  children: _renderWithLineBreaks(
                    node.nodes,
                    context,
                    depth: depth,
                  ),
                ),
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                  backgroundColor: obscure ? textColor : null,
                ),
              ),
            ),
          ),
        );
      block:
      default:
        return TextSpan(
          style: switch (node.localName) {
            'body' => TextStyle(
                fontSize: fontSize,
                color: textColor,
              ),
            'a' => linkStyle,
            'strong' => const TextStyle(fontWeight: FontWeight.bold),
            'em' || 'i' => const TextStyle(fontStyle: FontStyle.italic),
            'del' ||
            'strikethrough' =>
              const TextStyle(decoration: TextDecoration.lineThrough),
            'u' => const TextStyle(decoration: TextDecoration.underline),
            'h1' => TextStyle(fontSize: fontSize * 1.6, height: 2),
            'h2' => TextStyle(fontSize: fontSize * 1.5, height: 2),
            'h3' => TextStyle(fontSize: fontSize * 1.4, height: 2),
            'h4' => TextStyle(fontSize: fontSize * 1.3, height: 1.75),
            'h5' => TextStyle(fontSize: fontSize * 1.2, height: 1.75),
            'h6' => TextStyle(fontSize: fontSize * 1.1, height: 1.5),
            'span' => TextStyle(
                color: node.attributes['color']?.hexToColor ??
                    node.attributes['data-mx-color']?.hexToColor ??
                    textColor,
                backgroundColor:
                    node.attributes['data-mx-bg-color']?.hexToColor,
              ),
            'sup' =>
              const TextStyle(fontFeatures: [FontFeature.superscripts()]),
            'sub' => const TextStyle(fontFeatures: [FontFeature.subscripts()]),
            _ => null,
          },
          children: _renderWithLineBreaks(
            node.nodes,
            context,
            depth: depth,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // #Pangea
    dom.Node parsed = parser.parse(html).body ?? dom.Element.html('');
    if (tokens != null) {
      parsed = _tokenizeHtml(parsed, html, List.from(tokens!));
    }
    return SelectionArea(
      child: GestureDetector(
        onTap: () {
          if (!isOverlay) {
            controller.showToolbar(
              pangeaMessageEvent?.event ?? event,
              pangeaMessageEvent: pangeaMessageEvent,
              nextEvent: nextEvent,
              prevEvent: prevEvent,
            );
          }
        },
        // Pangea#
        child: Text.rich(
          _renderHtml(
            // #Pangea
            // parser.parse(html).body ?? dom.Element.html(''),
            parsed,
            // Pangea#
            context,
          ),
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
          ),
        ),
      ),
    );
  }
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
      splashColor: Colors.transparent,
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

extension on String {
  Color? get hexToColor {
    var hexCode = this;
    if (hexCode.startsWith('#')) hexCode = hexCode.substring(1);
    if (hexCode.length == 6) hexCode = 'FF$hexCode';
    final colorValue = int.tryParse(hexCode, radix: 16);
    return colorValue == null ? null : Color(colorValue);
  }
}
