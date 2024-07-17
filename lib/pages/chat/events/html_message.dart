import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/shades-of-purple.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:html/dom.dart' as dom;
import 'package:linkify/linkify.dart';
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
    final fontSize = AppConfig.messageFontSize * AppConfig.fontSizeFactor;

    final linkColor = textColor.withAlpha(150);

    final blockquoteStyle = Style(
      border: Border(
        left: BorderSide(
          width: 3,
          color: textColor,
        ),
      ),
      padding: HtmlPaddings.only(left: 6, bottom: 0),
    );

    final element = _linkifyHtml(HtmlParser.parseHTML(html));

    // there is no need to pre-validate the html, as we validate it while rendering
    return Html.fromElement(
      documentElement: element as dom.Element,
      style: {
        '*': Style(
          color: textColor,
          margin: Margins.all(0),
          fontSize: FontSize(fontSize),
        ),
        'a': Style(color: linkColor, textDecorationColor: linkColor),
        'h1': Style(
          fontSize: FontSize(fontSize * 2),
          lineHeight: LineHeight.number(1.5),
          fontWeight: FontWeight.w600,
        ),
        'h2': Style(
          fontSize: FontSize(fontSize * 1.75),
          lineHeight: LineHeight.number(1.5),
          fontWeight: FontWeight.w500,
        ),
        'h3': Style(
          fontSize: FontSize(fontSize * 1.5),
          lineHeight: LineHeight.number(1.5),
        ),
        'h4': Style(
          fontSize: FontSize(fontSize * 1.25),
          lineHeight: LineHeight.number(1.5),
        ),
        'h5': Style(
          fontSize: FontSize(fontSize * 1.25),
          lineHeight: LineHeight.number(1.5),
        ),
        'h6': Style(
          fontSize: FontSize(fontSize),
          lineHeight: LineHeight.number(1.5),
        ),
        'blockquote': blockquoteStyle,
        'tg-forward': blockquoteStyle,
        'hr': Style(
          border: Border.all(color: textColor, width: 0.5),
        ),
        'table': Style(
          border: Border.all(color: textColor, width: 0.5),
        ),
        'tr': Style(
          border: Border.all(color: textColor, width: 0.5),
        ),
        'td': Style(
          border: Border.all(color: textColor, width: 0.5),
          padding: HtmlPaddings.all(2),
        ),
        'th': Style(
          border: Border.all(color: textColor, width: 0.5),
        ),
      },
      extensions: [
        RoomPillExtension(context, room, fontSize, linkColor),
        CodeExtension(fontSize: fontSize),
        MatrixMathExtension(
          style: TextStyle(fontSize: fontSize, color: textColor),
        ),
        const TableHtmlExtension(),
        SpoilerExtension(textColor: textColor),
        const ImageExtension(),
        FontColorExtension(),
        FallbackTextExtension(fontSize: fontSize),
      ],
      onLinkTap: (url, _, element) => UrlLauncher(
        context,
        url,
        element?.text,
      ).launchUrl(),
      onlyRenderTheseTags: const {
        ...allowedHtmlTags,
        // Needed to make it work properly
        'body',
        'html',
      },
      shrinkWrap: true,
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

class FontColorExtension extends HtmlExtension {
  static const String colorAttribute = 'color';
  static const String mxColorAttribute = 'data-mx-color';
  static const String bgColorAttribute = 'data-mx-bg-color';

  @override
  Set<String> get supportedTags => {'font', 'span'};

  @override
  bool matches(ExtensionContext context) {
    if (!supportedTags.contains(context.elementName)) return false;
    return context.element?.attributes.keys.any(
          {
            colorAttribute,
            mxColorAttribute,
            bgColorAttribute,
          }.contains,
        ) ??
        false;
  }

  Color? hexToColor(String? hexCode) {
    if (hexCode == null) return null;
    if (hexCode.startsWith('#')) hexCode = hexCode.substring(1);
    if (hexCode.length == 6) hexCode = 'FF$hexCode';
    final colorValue = int.tryParse(hexCode, radix: 16);
    return colorValue == null ? null : Color(colorValue);
  }

  @override
  InlineSpan build(
    ExtensionContext context,
  ) {
    final colorText = context.element?.attributes[colorAttribute] ??
        context.element?.attributes[mxColorAttribute];
    final bgColor = context.element?.attributes[bgColorAttribute];
    return TextSpan(
      style: TextStyle(
        color: hexToColor(colorText),
        backgroundColor: hexToColor(bgColor),
      ),
      text: context.innerHtml,
    );
  }
}

class ImageExtension extends HtmlExtension {
  final double defaultDimension;

  const ImageExtension({this.defaultDimension = 64});

  @override
  Set<String> get supportedTags => {'img'};

  @override
  InlineSpan build(ExtensionContext context) {
    final mxcUrl = Uri.tryParse(context.attributes['src'] ?? '');
    if (mxcUrl == null || mxcUrl.scheme != 'mxc') {
      return TextSpan(text: context.attributes['alt']);
    }

    final width = double.tryParse(context.attributes['width'] ?? '');
    final height = double.tryParse(context.attributes['height'] ?? '');

    return WidgetSpan(
      child: SizedBox(
        width: width ?? height ?? defaultDimension,
        height: height ?? width ?? defaultDimension,
        child: MxcImage(
          uri: mxcUrl,
          width: width ?? height ?? defaultDimension,
          height: height ?? width ?? defaultDimension,
        ),
      ),
    );
  }
}

class SpoilerExtension extends HtmlExtension {
  final Color textColor;

  const SpoilerExtension({required this.textColor});

  @override
  Set<String> get supportedTags => {'span'};

  static const String customDataAttribute = 'data-mx-spoiler';

  @override
  bool matches(ExtensionContext context) {
    if (context.elementName != 'span') return false;
    return context.element?.attributes.containsKey(customDataAttribute) ??
        false;
  }

  @override
  InlineSpan build(ExtensionContext context) {
    var obscure = true;
    final children = context.inlineSpanChildren;
    return WidgetSpan(
      child: StatefulBuilder(
        builder: (context, setState) {
          return InkWell(
            onTap: () => setState(() {
              obscure = !obscure;
            }),
            child: RichText(
              text: TextSpan(
                style: obscure ? TextStyle(backgroundColor: textColor) : null,
                children: children,
              ),
            ),
          );
        },
      ),
    );
  }
}

class MatrixMathExtension extends HtmlExtension {
  final TextStyle? style;

  MatrixMathExtension({this.style});
  @override
  Set<String> get supportedTags => {'div'};

  @override
  bool matches(ExtensionContext context) {
    if (context.elementName != 'div') return false;
    final mathData = context.element?.attributes['data-mx-maths'];
    return mathData != null;
  }

  @override
  InlineSpan build(ExtensionContext context) {
    final data = context.element?.attributes['data-mx-maths'] ?? '';
    return WidgetSpan(
      child: Math.tex(
        data,
        textStyle: style,
        onErrorFallback: (e) {
          Logs().d('Flutter math parse error', e);
          return Text(
            data,
            style: style,
          );
        },
      ),
    );
  }
}

class CodeExtension extends HtmlExtension {
  final double fontSize;

  CodeExtension({required this.fontSize});
  @override
  Set<String> get supportedTags => {'code'};

  @override
  InlineSpan build(ExtensionContext context) => WidgetSpan(
        child: Material(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(4),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HighlightView(
              context.element?.text ?? '',
              language: context.element?.className
                      .split(' ')
                      .singleWhereOrNull(
                        (className) => className.startsWith('language-'),
                      )
                      ?.split('language-')
                      .last ??
                  'md',
              theme: shadesOfPurpleTheme,
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: context.element?.parent?.localName == 'pre' ? 6 : 0,
              ),
              textStyle: TextStyle(fontSize: fontSize),
            ),
          ),
        ),
      );
}

class FallbackTextExtension extends HtmlExtension {
  final double fontSize;

  FallbackTextExtension({required this.fontSize});
  @override
  Set<String> get supportedTags => HtmlMessage.fallbackTextTags;

  @override
  InlineSpan build(ExtensionContext context) => TextSpan(
        text: context.element?.text ?? '',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
}

class RoomPillExtension extends HtmlExtension {
  final Room room;
  final BuildContext context;
  final double fontSize;
  final Color color;

  RoomPillExtension(this.context, this.room, this.fontSize, this.color);
  @override
  Set<String> get supportedTags => {'a'};

  @override
  bool matches(ExtensionContext context) {
    if (context.elementName != 'a') return false;
    final userId = context.element?.attributes['href']
        ?.parseIdentifierIntoParts()
        ?.primaryIdentifier;
    return userId != null;
  }

  static final _cachedUsers = <String, User?>{};

  Future<User?> _fetchUser(String matrixId) async =>
      _cachedUsers[room.id + matrixId] ??= await room.requestUser(matrixId);

  @override
  InlineSpan build(ExtensionContext context) {
    final href = context.element?.attributes['href'];
    final matrixId = href?.parseIdentifierIntoParts()?.primaryIdentifier;
    if (href == null || matrixId == null) {
      return TextSpan(text: context.innerHtml);
    }
    if (matrixId.sigil == '@') {
      return WidgetSpan(
        child: FutureBuilder<User?>(
          future: _fetchUser(matrixId),
          builder: (context, snapshot) => MatrixPill(
            key: Key('user_pill_$matrixId'),
            name: _cachedUsers[room.id + matrixId]?.calcDisplayname() ??
                matrixId.localpart ??
                matrixId,
            avatar: _cachedUsers[room.id + matrixId]?.avatarUrl,
            uri: href,
            outerContext: this.context,
            fontSize: fontSize,
            color: color,
          ),
        ),
      );
    }
    if (matrixId.sigil == '#' || matrixId.sigil == '!') {
      final room = matrixId.sigil == '!'
          ? this.room.client.getRoomById(matrixId)
          : this.room.client.getRoomByAlias(matrixId);
      if (room != null) {
        return WidgetSpan(
          child: MatrixPill(
            name: room.getLocalizedDisplayname(),
            avatar: room.avatar,
            uri: href,
            outerContext: this.context,
            fontSize: fontSize,
            color: color,
          ),
        );
      }
    }

    return TextSpan(text: context.innerHtml);
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
