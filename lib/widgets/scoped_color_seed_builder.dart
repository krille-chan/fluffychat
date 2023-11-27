import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/theme_builder.dart';

typedef ColorSeedBuilder = Widget Function(BuildContext context, Color? color);

class ScopedColorSeedBuilder extends StatefulWidget {
  final ScopedColorSeedController controller;
  final ColorSeedBuilder builder;

  const ScopedColorSeedBuilder({
    super.key,
    required this.controller,
    required this.builder,
  });

  @override
  State<ScopedColorSeedBuilder> createState() => _ScopedColorSeedBuilderState();
}

class _ScopedColorSeedBuilderState extends State<ScopedColorSeedBuilder> {
  StreamSubscription<Color?>? _colorSchemeListener;
  Color? _color;

  @override
  void initState() {
    _colorSchemeListener =
        widget.controller._colorStreamController.stream.listen(_setColor);
    super.initState();
  }

  void _setColor(Color? seed) {
    if (seed != _color) setState(() => _color = seed);
  }

  @override
  Widget build(BuildContext context) {
    final fluffyThemeMode = ThemeController.of(context);

    final color = _color;
    // if a custom primary color is defined or no custom seed set,
    // no need to adjust theme
    if (color == null || fluffyThemeMode.primaryColor != null) {
      return widget.builder.call(context, color);
    }

    final theme = Theme.of(context);

    return Theme(
      // build the proper FluffyChat theme with the given seed
      data: FluffyThemes.buildTheme(context, theme.brightness, color),
      child: Builder(
        builder: (context) => widget.builder.call(context, color),
      ),
    );
  }

  @override
  void dispose() {
    _colorSchemeListener?.cancel();
    super.dispose();
  }
}

class ScopedColorSeedController {
  final _colorStreamController = StreamController<Color?>.broadcast();

  void setSeed(Color? seed) => _colorStreamController.add(seed);

  static Future<Color> imageHelper(Uint8List image) async {
    final scheme = await ColorScheme.fromImageProvider(
      provider: MemoryImage(image),
    );
    final color = scheme.primary;
    return color;
  }
}
