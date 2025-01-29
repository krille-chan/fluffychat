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

  const CustomizedSvg({
    super.key,
    required this.svgUrl,
    required this.colorReplacements,
    this.errorIcon = const Icon(Icons.error_outline),
  });

  static final GetStorage _svgStorage = GetStorage('svg_cache');

  Future<String> _fetchSvg() async {
    final cachedSvg = _svgStorage.read(svgUrl);
    if (cachedSvg != null) {
      return cachedSvg;
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
      throw e;
    }

    final String svgContent = response.body;
    await _svgStorage.write(svgUrl, svgContent);

    return svgContent;
  }

  Future<String> _getModifiedSvg() async {
    final svgContent = await _fetchSvg();
    String modifiedSvg = svgContent;
    // find the white and replace with black
    // or find black and replace with white
    modifiedSvg = modifiedSvg.replaceAll("fill=\"none\"", '');
    for (final entry in colorReplacements.entries) {
      modifiedSvg = modifiedSvg.replaceAll(entry.key, entry.value);
    }
    return modifiedSvg;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getModifiedSvg(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return errorIcon;
        } else if (snapshot.hasData) {
          return SvgPicture.string(snapshot.data!);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
