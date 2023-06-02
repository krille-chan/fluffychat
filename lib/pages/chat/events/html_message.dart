import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/shades-of-purple.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_math_fork/flutter_math.dart';
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
    Key? key,
    required this.html,
    required this.room,
    this.textColor = Colors.black,
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

    final fontSize = AppConfig.messageFontSize * AppConfig.fontSizeFactor;

    final linkifiedRenderHtml = linkify(
      renderHtml,
      options: const LinkifyOptions(humanize: false),
    )
        .map(
          (element) {
            if (element is! UrlElement ||
                element.text.contains('<') ||
                element.text.contains('>') ||
                element.text.contains('"')) {
              return element.text;
            }
            return '<a href="${element.url}">${element.text}</a>';
          },
        )
        .join('')
        .replaceAll('\n', '');

    final linkColor = textColor.withAlpha(150);

    // there is no need to pre-validate the html, as we validate it while rendering
    return Html(
      data: linkifiedRenderHtml,
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
        'blockquote': Style(
          border: Border(
            left: BorderSide(
              width: 3,
              color: textColor,
            ),
          ),
          padding: HtmlPaddings.only(left: 6, bottom: 0),
        ),
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
        RoomPillExtension(context, room),
        CodeExtension(fontSize: fontSize),
        MatrixMathExtension(
          style: TextStyle(fontSize: fontSize, color: textColor),
        ),
        const TableHtmlExtension(),
        SpoilerExtension(textColor: textColor),
        const ImageExtension(),
        FontColorExtension(),
      ],
      onLinkTap: (url, _, __) => UrlLauncher(context, url).launchUrl(),
      onlyRenderTheseTags: const {
        ...allowedHtmlTags,
        // Needed to make it work properly
        'body',
        'html',
      },
      shrinkWrap: true,
    );
  }

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
          cacheKey: mxcUrl.toString(),
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

class RoomPillExtension extends HtmlExtension {
  final Room room;
  final BuildContext context;

  RoomPillExtension(this.context, this.room);
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

  const MatrixPill({
    super.key,
    required this.name,
    required this.outerContext,
    this.avatar,
    required this.uri,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: UrlLauncher(outerContext, uri).launchUrl,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          side: BorderSide(
            color: Theme.of(outerContext).colorScheme.onPrimaryContainer,
            width: 0.5,
          ),
        ),
        color: Theme.of(outerContext).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
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
                  color: Theme.of(outerContext).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
