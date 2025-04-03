import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:fluffychat/pangea/common/utils/error_handler.dart';

class CustomizedSvg extends StatefulWidget {
  /// URL of the SVG file
  final String svgUrl;

  /// Map of color replacements
  final Map<String, String> colorReplacements;

  /// Icon to show in case of error
  final Widget errorIcon;

  /// Width of the SVG
  /// Default is 24
  /// If you want to keep the aspect ratio, set only the height
  final double? width;

  /// Height of the SVG
  /// Default is 24
  /// If you want to keep the aspect ratio, set only the width
  final double? height;

  static final GetStorage _svgStorage = GetStorage('svg_cache');

  const CustomizedSvg({
    super.key,
    required this.svgUrl,
    required this.colorReplacements,
    this.errorIcon = const Icon(Icons.error_outline),
    this.width = 24,
    this.height = 24,
  });

  @override
  State<CustomizedSvg> createState() => _CustomizedSvgState();
}

class _CustomizedSvgState extends State<CustomizedSvg> {
  String? _svgContent;
  bool _isLoading = true;
  bool _hasError = false;
  bool _showProgressIndicator = false;

  @override
  void initState() {
    super.initState();
    _startLoadingTimer();
    _loadSvg();
  }

  void _startLoadingTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isLoading) {
        setState(() {
          _showProgressIndicator = true;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomizedSvg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.svgUrl != widget.svgUrl) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _showProgressIndicator = false;
      });
      _loadSvg();
    }
  }

  Future<void> _loadSvg() async {
    try {
      final cached = _getSvgFromCache();
      if (cached != null) {
        setState(() {
          _svgContent = cached;
          _isLoading = false;
        });
        return;
      }

      final modifiedSvg = await _getModifiedSvg();
      setState(() {
        _svgContent = modifiedSvg;
        _isLoading = false;
        _hasError = modifiedSvg == null;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<String?> _getModifiedSvg() async {
    final svgContent = await _fetchSvg();
    if (svgContent == null) {
      return null;
    }
    return _modifySVG(svgContent);
  }

  Future<String?> _fetchSvg() async {
    final cachedSvgEntry = CustomizedSvg._svgStorage.read(widget.svgUrl);
    if (cachedSvgEntry != null && cachedSvgEntry is Map<String, dynamic>) {
      final cachedSvg = cachedSvgEntry['svg'] as String?;
      final timestamp = cachedSvgEntry['timestamp'] as int?;
      if (cachedSvg != null) {
        return cachedSvg;
      }
      // if timestamp is younger than 1 day, return null
      if (timestamp != null &&
          DateTime.now()
                  .difference(DateTime.fromMillisecondsSinceEpoch(timestamp))
                  .inDays <
              1) {
        return null;
      }
    }

    final response = await http.get(Uri.parse(widget.svgUrl));
    if (response.statusCode != 200) {
      final e = Exception('Failed to load SVG: ${response.statusCode}');
      ErrorHandler.logError(
        e: e,
        data: {
          "svgUrl": widget.svgUrl,
        },
      );
      await CustomizedSvg._svgStorage.write(
        widget.svgUrl,
        {'timestamp': DateTime.now().millisecondsSinceEpoch},
      );
      throw e;
    }

    final String svgContent = response.body;
    await CustomizedSvg._svgStorage.write(widget.svgUrl, {
      'svg': svgContent,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    return svgContent;
  }

  String _modifySVG(String svgContent) {
    String modifiedSvg = svgContent.replaceAll("fill=\"none\"", '');
    for (final entry in widget.colorReplacements.entries) {
      modifiedSvg = modifiedSvg.replaceAll(entry.key, entry.value);
    }
    return modifiedSvg;
  }

  String? _getSvgFromCache() {
    final cachedSvgEntry = CustomizedSvg._svgStorage.read(widget.svgUrl);
    if (cachedSvgEntry != null &&
        cachedSvgEntry is Map<String, dynamic> &&
        cachedSvgEntry['svg'] is String) {
      return _modifySVG(cachedSvgEntry['svg'] as String);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      if (_showProgressIndicator) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return SizedBox(
          width: widget.width,
          height: widget.height,
        );
      }
    } else if (_hasError || _svgContent == null) {
      return widget.errorIcon;
    } else {
      return SvgPicture.string(
        _svgContent!,
        width: widget.width,
        height: widget.height,
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
