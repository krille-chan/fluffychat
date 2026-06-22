import 'package:fluffychat/utils/text_direction.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

export 'package:flutter_linkify/flutter_linkify.dart'
    show
        LinkifyOptions,
        LinkableElement,
        LinkCallback,
        Linkifier,
        UrlLinkifier,
        EmailLinkifier,
        LinkifySpan,
        LinkifyElement,
        TextElement,
        UrlElement,
        EmailElement;

const _defaultLinkifiers = [UrlLinkifier(), EmailLinkifier()];

class AutoLinkify extends StatelessWidget {
  final String text;
  final List<Linkifier> linkifiers;
  final LinkCallback? onOpen;
  final LinkifyOptions options;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double textScaleFactor;
  final bool softWrap;
  final StrutStyle? strutStyle;
  final Locale? locale;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final bool useMouseRegion;

  const AutoLinkify({
    super.key,
    required this.text,
    this.linkifiers = _defaultLinkifiers,
    this.onOpen,
    this.options = const LinkifyOptions(),
    this.style,
    this.linkStyle,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.softWrap = true,
    this.strutStyle,
    this.locale,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.useMouseRegion = true,
  });

  @override
  Widget build(BuildContext context) {
    return Linkify(
      text: bidiIsolateMultiline(text),
      linkifiers: linkifiers,
      onOpen: onOpen,
      options: options,
      style: style,
      linkStyle: linkStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      softWrap: softWrap,
      strutStyle: strutStyle,
      locale: locale,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      useMouseRegion: useMouseRegion,
    );
  }
}

class AutoSelectableLinkify extends StatelessWidget {
  final String text;
  final double textScaleFactor;
  final List<Linkifier> linkifiers;
  final LinkCallback? onOpen;
  final LinkifyOptions options;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final TextAlign? textAlign;
  final int? minLines;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool showCursor;
  final bool autofocus;
  final StrutStyle? strutStyle;
  final DragStartBehavior dragStartBehavior;
  final bool enableInteractiveSelection;
  final SelectionChangedCallback? onSelectionChanged;
  final ScrollPhysics? scrollPhysics;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final bool useMouseRegion;

  const AutoSelectableLinkify({
    super.key,
    required this.text,
    this.textScaleFactor = 1.0,
    this.linkifiers = _defaultLinkifiers,
    this.onOpen,
    this.options = const LinkifyOptions(),
    this.style,
    this.linkStyle,
    this.textAlign,
    this.minLines,
    this.maxLines,
    this.focusNode,
    this.showCursor = false,
    this.autofocus = false,
    this.strutStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.onSelectionChanged,
    this.scrollPhysics,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.useMouseRegion = false,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableLinkify(
      text: bidiIsolateMultiline(text),
      textScaleFactor: textScaleFactor,
      linkifiers: linkifiers,
      onOpen: onOpen,
      options: options,
      style: style,
      linkStyle: linkStyle,
      textAlign: textAlign,
      minLines: minLines,
      maxLines: maxLines,
      focusNode: focusNode,
      showCursor: showCursor,
      autofocus: autofocus,
      strutStyle: strutStyle,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      onSelectionChanged: onSelectionChanged,
      scrollPhysics: scrollPhysics,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      useMouseRegion: useMouseRegion,
    );
  }
}
