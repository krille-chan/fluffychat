import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:linkify/linkify.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/event_checkbox_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import '../../../utils/url_launcher.dart';

class HtmlMessage extends StatelessWidget {
  final String html;
  final Room room;
  final Color textColor;
  final double fontSize;
  final TextStyle linkStyle;
  final void Function(LinkableElement) onOpen;
  final String? eventId;
  final Set<Event>? checkboxCheckedEvents;
  final bool limitHeight;

  const HtmlMessage({
    super.key,
    required this.html,
    required this.room,
    required this.fontSize,
    required this.linkStyle,
    this.textColor = Colors.black,
    required this.onOpen,
    this.eventId,
    this.checkboxCheckedEvents,
    this.limitHeight = true,
  });

  String _linkify(String html) {
    try {
      final doc = parser.parseFragment(html);

      void walk(dom.Node node) {
        if (node is dom.Element) {
          if (node.localName == 'a' ||
              node.localName == 'code' ||
              node.localName == 'pre') {
            return;
          }
        }

        if (node.nodeType == dom.Node.TEXT_NODE && node.text != null) {
          final text = node.text!;
          if (text.trim().isEmpty) return;

          final elements = linkify(
            text,
            options: const LinkifyOptions(humanize: false),
            linkifiers: [const UrlLinkifier()],
          );

          if (elements.length == 1 && elements.first is TextElement) {
            return;
          }

          final newNodes = <dom.Node>[];
          for (final e in elements) {
            if (e is LinkableElement) {
              final a = dom.Element.tag('a');
              a.attributes['href'] = e.url;
              a.text = e.text;
              newNodes.add(a);
            } else {
              newNodes.add(dom.Text(e.text));
            }
          }

          node.replaceWith(dom.DocumentFragment()..nodes.addAll(newNodes));
        } else {
          for (final child in List<dom.Node>.from(node.nodes)) {
            walk(child);
          }
        }
      }

      walk(doc);
      return doc.outerHtml;
    } catch (e) {
      return html;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final fontFamilyFallback = bodyMedium?.fontFamilyFallback;

    return Html(
      data: _linkify(html),
      shrinkWrap: true,
      style: {
        "body": Style(
          fontSize: FontSize(fontSize),
          color: textColor,
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontFamily: bodyMedium?.fontFamily ?? 'sans-serif',
          fontFamilyFallback: fontFamilyFallback,
          display: Display.inline,
        ),
        "a": Style(
          color: linkStyle.color,
          textDecoration: linkStyle.decoration,
        ),
        "pre": Style(
          backgroundColor: Colors.transparent,
          padding: HtmlPaddings.zero,
          fontFamilyFallback: fontFamilyFallback,
          margin: Margins.zero,
        ),
        "code": Style(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          fontFamily: 'monospace',
          fontFamilyFallback: fontFamilyFallback,
        ),
        "p": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        "div": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        "ul": Style(margin: Margins.only(left: 10), padding: HtmlPaddings.zero),
        "ol": Style(margin: Margins.only(left: 10), padding: HtmlPaddings.zero),
      },
      onLinkTap: (url, attributes, element) {
        if (url != null) {
          onOpen(LinkableElement(url, url));
        }
      },
      extensions: [
        _MatrixPillExtension(room, context, fontSize, linkStyle),
        _MxcImageExtension(),
        _CheckboxExtension(
          room,
          context,
          fontSize,
          textColor,
          linkStyle,
          eventId,
          checkboxCheckedEvents,
          onOpen,
        ),
        _SpoilerExtension(textColor, fontSize),
        _DetailsExtension(textColor, fontSize, linkStyle, onOpen),
      ],
    );
  }
}

class _MatrixPillExtension extends HtmlExtension {
  final Room room;
  final BuildContext context;
  final double fontSize;
  final TextStyle linkStyle;

  _MatrixPillExtension(this.room, this.context, this.fontSize, this.linkStyle);

  @override
  Set<String> get supportedTags => {"a"};

  @override
  bool matches(ExtensionContext extensionContext) {
    if (extensionContext.elementName != "a") return false;
    final href = extensionContext.element?.attributes['href'];
    return href != null &&
        (href.parseIdentifierIntoParts()?.primaryIdentifier != null);
  }

  @override
  InlineSpan build(ExtensionContext extensionContext) {
    final href = extensionContext.element!.attributes['href']!;
    final matrixId = href.parseIdentifierIntoParts()!.primaryIdentifier!;

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
    return TextSpan(text: extensionContext.innerHtml);
  }
}

class _MxcImageExtension extends HtmlExtension {
  @override
  Set<String> get supportedTags => {"img"};

  @override
  bool matches(ExtensionContext extensionContext) {
    if (extensionContext.elementName != "img") return false;
    final src = extensionContext.element?.attributes['src'];
    return src != null && Uri.tryParse(src)?.scheme == 'mxc';
  }

  @override
  InlineSpan build(ExtensionContext extensionContext) {
    final element = extensionContext.element!;
    final mxcUrl = Uri.parse(element.attributes['src']!);
    final widthAttr = double.tryParse(element.attributes['width'] ?? '');
    final heightAttr = double.tryParse(element.attributes['height'] ?? '');

    return WidgetSpan(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double? width = widthAttr;
          double? height = heightAttr;
          double maxWidth = constraints.maxWidth;
          if (maxWidth.isInfinite) maxWidth = FluffyThemes.maxTimelineWidth;

          if (width != null && height != null) {
            final aspectRatio = width / height;
            if (width > maxWidth) {
              width = maxWidth;
              height = width / aspectRatio;
            }
            if (height! > maxWidth) {
              height = maxWidth;
              width = height * aspectRatio;
            }
          } else if (width != null && width > maxWidth) {
            width = maxWidth;
          }

          return MxcImage(
            uri: mxcUrl,
            width: width,
            height: height,
            fit: BoxFit.contain,
            isThumbnail: false,
            cacheKey: mxcUrl.toString(),
          );
        },
      ),
    );
  }
}

class _CheckboxExtension extends HtmlExtension {
  final Room room;
  final BuildContext context;
  final double fontSize;
  final Color textColor;
  final TextStyle linkStyle;
  final String? eventId;
  final Set<Event>? checkboxCheckedEvents;
  final void Function(LinkableElement) onOpen;

  _CheckboxExtension(
    this.room,
    this.context,
    this.fontSize,
    this.textColor,
    this.linkStyle,
    this.eventId,
    this.checkboxCheckedEvents,
    this.onOpen,
  );

  @override
  Set<String> get supportedTags => {"li"};

  @override
  bool matches(ExtensionContext extensionContext) {
    return extensionContext.elementName == "li" &&
        extensionContext.element?.classes.contains('task-list-item') == true;
  }

  @override
  InlineSpan build(ExtensionContext extensionContext) {
    final element = extensionContext.element!;
    final checkboxIndex =
        element.rootElement
            .getElementsByClassName('task-list-item')
            .indexOf(element) +
        1;

    final checkedByReaction = checkboxCheckedEvents?.firstWhereOrNull(
      (event) => event.checkedCheckboxId == checkboxIndex,
    );
    final staticallyChecked =
        element.children.isNotEmpty &&
        element.children.first.attributes['checked'] == 'true';

    var contentHtml = element.innerHtml;
    contentHtml = contentHtml.replaceFirst(
      RegExp(r'<input[^>]*type="checkbox"[^>]*>'),
      '',
    );

    return WidgetSpan(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox.square(
              dimension: fontSize + 2,
              child: CupertinoCheckbox(
                value: staticallyChecked || checkedByReaction != null,
                onChanged:
                    eventId == null ||
                        staticallyChecked ||
                        !room.canSendDefaultMessages ||
                        (checkedByReaction != null &&
                            checkedByReaction.senderId != room.client.userID)
                    ? null
                    : (_) => showFutureLoadingDialog(
                        context: context,
                        future: () => checkedByReaction != null
                            ? room.redactEvent(checkedByReaction.eventId)
                            : room.checkCheckbox(eventId!, checkboxIndex),
                      ),
              ),
            ),
          ),
          Expanded(
            child: Html(
              data: contentHtml,
              style: {
                "body": Style(
                  fontSize: FontSize(fontSize),
                  color: textColor,
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  fontFamily:
                      Theme.of(context).textTheme.bodyMedium?.fontFamily ??
                      'sans-serif',
                ),
                "a": Style(
                  color: linkStyle.color,
                  textDecoration: linkStyle.decoration,
                ),
              },
              onLinkTap: (url, attributes, element) {
                if (url != null) {
                  onOpen(LinkableElement(url, url));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SpoilerExtension extends HtmlExtension {
  final Color textColor;
  final double fontSize;

  _SpoilerExtension(this.textColor, this.fontSize);

  @override
  Set<String> get supportedTags => {"span"};

  @override
  bool matches(ExtensionContext extensionContext) {
    return extensionContext.elementName == "span" &&
        extensionContext.element?.attributes.containsKey('data-mx-spoiler') ==
            true;
  }

  @override
  InlineSpan build(ExtensionContext extensionContext) {
    return WidgetSpan(
      child: Builder(
        builder: (context) {
          var obscure = true;
          return StatefulBuilder(
            builder: (context, setState) => InkWell(
              splashColor: Colors.transparent,
              onTap: () => setState(() {
                obscure = !obscure;
              }),
              child: Container(
                decoration: BoxDecoration(
                  color: obscure ? textColor : null,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Html(
                  data: extensionContext.innerHtml,
                  style: {
                    "body": Style(
                      fontSize: FontSize(fontSize),
                      color: obscure ? Colors.transparent : textColor,
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontFamily:
                          Theme.of(context).textTheme.bodyMedium?.fontFamily ??
                          'sans-serif',
                    ),
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DetailsExtension extends HtmlExtension {
  final Color textColor;
  final double fontSize;
  final TextStyle linkStyle;
  final void Function(LinkableElement) onOpen;

  _DetailsExtension(this.textColor, this.fontSize, this.linkStyle, this.onOpen);

  @override
  Set<String> get supportedTags => {"details"};

  @override
  bool matches(ExtensionContext extensionContext) =>
      extensionContext.elementName == "details";

  @override
  InlineSpan build(ExtensionContext extensionContext) {
    final element = extensionContext.element!;
    return WidgetSpan(
      child: Builder(
        builder: (context) {
          var obscure = true;
          final summary = element.children.firstWhereOrNull(
            (e) => e.localName == 'summary',
          );
          final content = element.children
              .where((e) => e.localName != 'summary')
              .map((e) => e.outerHtml)
              .join();

          return StatefulBuilder(
            builder: (context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () => setState(() {
                    obscure = !obscure;
                  }),
                  child: Row(
                    children: [
                      Icon(
                        obscure ? Icons.arrow_right : Icons.arrow_drop_down,
                        size: fontSize * 1.2,
                      ),
                      if (summary != null)
                        Expanded(
                          child: Html(
                            data: summary.innerHtml,
                            style: {
                              "body": Style(
                                fontSize: FontSize(fontSize),
                                color: textColor,
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                                fontFamily:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.fontFamily ??
                                    'sans-serif',
                              ),
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                if (!obscure)
                  Html(
                    data: content,
                    style: {
                      "body": Style(
                        fontSize: FontSize(fontSize),
                        color: textColor,
                        margin: Margins.zero,
                        padding: HtmlPaddings.only(left: 10),
                        fontFamily:
                            Theme.of(
                              context,
                            ).textTheme.bodyMedium?.fontFamily ??
                            'sans-serif',
                      ),
                      "a": Style(
                        color: linkStyle.color,
                        textDecoration: linkStyle.decoration,
                      ),
                    },
                    onLinkTap: (url, attributes, element) {
                      if (url != null) {
                        onOpen(LinkableElement(url, url));
                      }
                    },
                  ),
              ],
            ),
          );
        },
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
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Avatar(mxContent: avatar, name: name, size: 16),
              ),
            ),
            TextSpan(
              text: name,
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

extension on dom.Element {
  dom.Element get rootElement => parent?.rootElement ?? this;
}
