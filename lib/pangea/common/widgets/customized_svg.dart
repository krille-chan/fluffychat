import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluffychat/pangea/common/utils/svg_repo.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class CustomizedSvg extends StatefulWidget {
  /// URL of the SVG file
  final String svgUrl;

  /// Map of color replacements
  final Map<String, String> colorReplacements;

  /// Icon to show in case of error
  final Widget errorIcon;

  final Widget? loadingPlaceholder;

  /// Width of the SVG
  /// Default is 24
  /// If you want to keep the aspect ratio, set only the height
  final double? width;

  /// Height of the SVG
  /// Default is 24
  /// If you want to keep the aspect ratio, set only the width
  final double? height;

  final BoxFit? fit;

  const CustomizedSvg({
    super.key,
    required this.svgUrl,
    this.colorReplacements = const {},
    this.errorIcon = const Icon(Icons.error_outline),
    this.loadingPlaceholder,
    this.width = 24,
    this.height = 24,
    this.fit,
  });

  @override
  State<CustomizedSvg> createState() => _CustomizedSvgState();
}

class _CustomizedSvgState extends State<CustomizedSvg> {
  String? _svgContent;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadSvg();
  }

  @override
  void didUpdateWidget(covariant CustomizedSvg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.svgUrl != widget.svgUrl) {
      _loadSvg();
    }
  }

  String get _cacheKey {
    final buffer = StringBuffer(widget.svgUrl);
    widget.colorReplacements.forEach((k, v) {
      buffer.write('$k->$v;');
    });
    return buffer.toString();
  }

  Future<void> _loadSvg() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _svgContent = null;
    });

    final svg = await SvgRepo.get(widget.svgUrl);
    if (svg.isError) {
      _hasError = true;
    } else {
      _svgContent = _modifySVG(svg.result!);
    }

    if (mounted) setState(() => _isLoading = false);
  }

  String _modifySVG(String svgContent) {
    String modifiedSvg = svgContent.replaceAll("fill=\"none\"", '');
    for (final entry in widget.colorReplacements.entries) {
      modifiedSvg = modifiedSvg.replaceAll(entry.key, entry.value);
    }
    return modifiedSvg;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingPlaceholder ??
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Center(child: CircularProgressIndicator()),
          );
    } else if (_hasError || _svgContent == null) {
      return widget.errorIcon;
    } else {
      return SvgPicture(
        SvgStringLoader(_svgContent!),
        key: ValueKey(_cacheKey),
        width: widget.width,
        height: widget.height,
        fit: widget.fit ?? BoxFit.contain,
      );
    }
  }
}

String colorToHex(Color color) {
  return '#'
      '${(color.r * 255).toInt().toRadixString(16).padLeft(2, '0')}'
      '${(color.g * 255).toInt().toRadixString(16).padLeft(2, '0')}'
      '${(color.b * 255).toInt().toRadixString(16).padLeft(2, '0')}';
}
