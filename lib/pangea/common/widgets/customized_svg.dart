import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:fluffychat/pangea/common/utils/error_handler.dart';

class CustomizedSvg extends StatelessWidget {
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

  Future<String?> _fetchSvg() async {
    final cachedSvgEntry = _svgStorage.read(svgUrl);
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

    final response = await http.get(Uri.parse(svgUrl));
    if (response.statusCode != 200) {
      final e = Exception('Failed to load SVG: ${response.statusCode}');
      ErrorHandler.logError(
        e: e,
        data: {
          "svgUrl": svgUrl,
        },
      );
      await _svgStorage.write(
        svgUrl,
        {'timestamp': DateTime.now().millisecondsSinceEpoch},
      );
      throw e;
    }

    final String svgContent = response.body;
    await _svgStorage.write(svgUrl, {
      'svg': svgContent,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    return svgContent;
  }

  Future<String?> _getModifiedSvg() async {
    final svgContent = await _fetchSvg();
    final String? modifiedSvg = svgContent;
    if (modifiedSvg == null) {
      return null;
    }

    return _modifySVG(modifiedSvg);
  }

  String _modifySVG(String svgContent) {
    String modifiedSvg = svgContent.replaceAll("fill=\"none\"", '');
    for (final entry in colorReplacements.entries) {
      modifiedSvg = modifiedSvg.replaceAll(entry.key, entry.value);
    }
    return modifiedSvg;
  }

  String? _getSvgFromCache() {
    final cachedSvgEntry = _svgStorage.read(svgUrl);
    if (cachedSvgEntry != null &&
        cachedSvgEntry is Map<String, dynamic> &&
        cachedSvgEntry['svg'] is String) {
      return _modifySVG(cachedSvgEntry['svg'] as String);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cached = _getSvgFromCache();
    if (cached != null) {
      return SvgPicture.string(cached);
    }

    return FutureBuilder<String?>(
      future: _getModifiedSvg(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          return errorIcon;
        } else if (snapshot.hasData) {
          return SvgPicture.string(
            snapshot.data!,
            width: width,
            height: height,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
