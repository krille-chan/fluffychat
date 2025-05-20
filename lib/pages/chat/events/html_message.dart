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
import 'package:fluffychat/pangea/common/utils/any_state_holder.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/message_token_text/message_token_button.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/enums/reading_assistance_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/utils/token_rendering_util.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
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
  final MessageOverlayController? overlayController;
  final PangeaMessageEvent? pangeaMessageEvent;
  final ChatController controller;
  final Event event;
  final Event? nextEvent;
  final Event? prevEvent;
  final bool isTransitionAnimation;
  final ReadingAssistanceMode? readingAssistanceMode;

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
    this.overlayController,
    required this.event,
    this.pangeaMessageEvent,
    required this.controller,
    this.nextEvent,
    this.prevEvent,
    this.isSelected,
    this.onClick,
    this.isTransitionAnimation = false,
    this.readingAssistanceMode,
    // Pangea#
  });

  /// Keep in sync with: https://spec.matrix.org/latest/client-server-api/#mroommessage-msgtypes
  static const Set<String> allowedHtmlTags = {
    'font',
    'del',
    's',
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
    final regex = RegExp(r'(<[^>]+>)');

    final matches = regex.allMatches(fullHtml);
    final List<String> result = <String>[];
    int lastEnd = 0;

    for (final match in matches) {
      if (match.start > lastEnd) {
        result.add(fullHtml.substring(lastEnd, match.start)); // Text before tag
      }
      result.add(match.group(0)!); // The tag itself
      lastEnd = match.end;
    }

    if (lastEnd < fullHtml.length) {
      result.add(fullHtml.substring(lastEnd)); // Remaining text after last tag
    }

    for (final PangeaToken token in tokens ?? []) {
      final String tokenText = token.text.content;
      final substringIndex = result.indexWhere(
        (string) =>
            string.contains(tokenText) &&
            !(string.startsWith('<') && string.endsWith('>')),
      );

      if (substringIndex == -1) continue;
      final int tokenIndex = result[substringIndex].indexOf(tokenText);
      if (tokenIndex == -1) continue;

      final int tokenLength = tokenText.characters.length;
      final before = result[substringIndex].substring(0, tokenIndex);
      final after = result[substringIndex].substring(tokenIndex + tokenLength);
      result.replaceRange(substringIndex, substringIndex + 1, [
        if (before.isNotEmpty) before,
        '<token offset="${token.text.offset}" length="${token.text.length}">$tokenText</token>',
        if (after.isNotEmpty) after,
      ]);
    }

    return dom.Element.html('<span>${result.join()}</span>');
  }
  // Pangea#

  /// Adding line breaks before block elements.
  List<InlineSpan> _renderWithLineBreaks(
    dom.NodeList nodes,
    // #Pangea
    // BuildContext context, {
    BuildContext context,
    TextStyle textStyle, {
    // Pangea#
    int depth = 1,
  }) {
    final onlyElements = nodes.whereType<dom.Element>().toList();
    return [
      for (var i = 0; i < nodes.length; i++) ...[
        // Actually render the node child:
        // #Pangea
        // _renderHtml(nodes[i], context, depth: depth + 1),
        _renderHtml(nodes[i], context, textStyle, depth: depth + 1),
        // Pangea#
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
    // #Pangea
    // BuildContext context, {
    BuildContext context,
    TextStyle textStyle, {
    // Pangea#
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

        final renderer = TokenRenderingUtil(
          pangeaMessageEvent: pangeaMessageEvent,
          readingAssistanceMode: readingAssistanceMode,
          existingStyle: textStyle.merge(
            AppConfig.messageTextStyle(
              pangeaMessageEvent!.event,
              textColor,
            ),
          ),
          overlayController: overlayController,
          isTransitionAnimation: isTransitionAnimation,
        );

        final tokenWidth = renderer.tokenTextWidthForContainer(
          context,
          node.innerHtml,
        );

        return WidgetSpan(
          child: CompositedTransformTarget(
            link: token != null && renderer.assignTokenKey
                ? MatrixState.pAnyState
                    .layerLinkAndKey(token.text.uniqueKey)
                    .link
                : LayerLinkAndKey(token.hashCode.toString()).link,
            child: Column(
              key: token != null && renderer.assignTokenKey
                  ? MatrixState.pAnyState
                      .layerLinkAndKey(token.text.uniqueKey)
                      .key
                  : null,
              children: [
                if (renderer.showCenterStyling && token != null)
                  MessageTokenButton(
                    token: token,
                    overlayController: overlayController,
                    textStyle: renderer.style(
                      context,
                      color: renderer.backgroundColor(
                        context,
                        selected,
                      ),
                    ),
                    width: tokenWidth,
                    animateIn: isTransitionAnimation,
                    practiceTargetForToken:
                        overlayController?.toolbarMode.associatedActivityType !=
                                null
                            ? overlayController?.practiceSelection
                                ?.activities(
                                  overlayController!
                                      .toolbarMode.associatedActivityType!,
                                )
                                .firstWhereOrNull(
                                  (a) => a.tokens.contains(token),
                                )
                            : null,
                  ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: onClick != null && token != null
                        ? () => onClick?.call(token)
                        : null,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          LinkifySpan(
                            text: node.innerHtml,
                            style: renderer.style(
                              context,
                              color: renderer.backgroundColor(
                                context,
                                selected,
                              ),
                            ),
                            linkStyle: linkStyle,
                            onOpen: (url) =>
                                UrlLauncher(context, url.url).launchUrl(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
                // #Pangea
                // Text.rich applies the device's textScaleFactor
                // overriding this one since non-html messages don't
                // abide by the device's textScaleFactor
                textScaler: TextScaler.noScaling,
                // Pangea#
                TextSpan(
                  children: _renderWithLineBreaks(
                    node.nodes,
                    context,
                    // #Pangea
                    textStyle.merge(
                      linkStyle.copyWith(height: 1.25),
                    ),
                    // Pangea#
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
              // #Pangea
              textScaler: TextScaler.noScaling,
              // Pangea#
              TextSpan(
                children: [
                  if (node.parent?.localName == 'ul')
                    const TextSpan(text: '• '),
                  if (node.parent?.localName == 'ol')
                    TextSpan(
                      text:
                          '${(node.parent?.nodes.whereType<dom.Element>().toList().indexOf(node) ?? 0) + (int.tryParse(node.parent?.attributes['start'] ?? '1') ?? 1)}. ',
                    ),
                  ..._renderWithLineBreaks(
                    node.nodes,
                    context,
                    // #Pangea
                    textStyle,
                    // Pangea#
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
                  width: 5,
                ),
              ),
            ),
            child: Text.rich(
              // #Pangea
              textScaler: TextScaler.noScaling,
              // Pangea#
              TextSpan(
                children: _renderWithLineBreaks(
                  node.nodes,
                  context,
                  // #Pangea
                  textStyle.copyWith(fontStyle: FontStyle.italic),
                  // Pangea#
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
                  fontFamily: 'RobotoMono',
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
                // #Pangea
                textScaler: TextScaler.noScaling,
                // Pangea#
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
                            // #Pangea
                            // (node) => _renderHtml(node, context, depth: depth),
                            (node) => _renderHtml(
                              node,
                              context,
                              textStyle.merge(
                                TextStyle(
                                  fontSize: fontSize,
                                  color: textColor,
                                ),
                              ),
                              depth: depth,
                            ),
                            // Pangea#
                          )
                    else
                      ..._renderWithLineBreaks(
                        node.nodes,
                        context,
                        // #Pangea
                        textStyle,
                        // Pangea#
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
                // #Pangea
                textScaler: TextScaler.noScaling,
                // Pangea#
                TextSpan(
                  children: _renderWithLineBreaks(
                    node.nodes,
                    context,
                    // #Pangea
                    textStyle.copyWith(
                      backgroundColor: obscure ? textColor : null,
                    ),
                    // Pangea#
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
        // #Pangea
        final style = switch (node.localName) {
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
              backgroundColor: node.attributes['data-mx-bg-color']?.hexToColor,
            ),
          'sup' => const TextStyle(fontFeatures: [FontFeature.superscripts()]),
          'sub' => const TextStyle(fontFeatures: [FontFeature.subscripts()]),
          _ => null,
        };
        // Pangea#
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
            's' ||
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
            // #Pangea
            textStyle.merge(style ?? const TextStyle()),
            // Pangea#
            depth: depth,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // #Pangea
    // return Text.rich(
    dom.Node parsed = parser.parse(html).body ?? dom.Element.html('');
    if (tokens != null) {
      parsed = _tokenizeHtml(parsed, html, List.from(tokens!));
    }
    return SelectionArea(
      child: GestureDetector(
        onTap: () {
          if (overlayController == null) {
            controller.showToolbar(
              pangeaMessageEvent?.event ?? event,
              pangeaMessageEvent: pangeaMessageEvent,
              nextEvent: nextEvent,
              prevEvent: prevEvent,
            );
          }
        },
        child: Text.rich(
          textScaler: TextScaler.noScaling,
          // Pangea#
          _renderHtml(
            // #Pangea
            // parser.parse(html).body ?? dom.Element.html(''),
            parsed,
            // Pangea#
            context,
            // #Pangea
            TextStyle(
              fontSize: fontSize,
              color: textColor,
            ),
            // Pangea#
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
