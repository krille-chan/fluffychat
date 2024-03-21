import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:blurhash_dart/blurhash_dart.dart' as b;
import 'package:image/image.dart' as image;

class BlurHash extends StatefulWidget {
  final double width;
  final double height;
  final String blurhash;
  final BoxFit fit;

  const BlurHash({
    super.key,
    String? blurhash,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  }) : blurhash = blurhash ?? 'LEHV6nWB2yk8pyo0adR*.7kCMdnj';

  @override
  State<BlurHash> createState() => _BlurHashState();
}

class _BlurHashState extends State<BlurHash> {
  Uint8List? _data;

  Future<Uint8List> getBlurhashData() async {
    final blurhash = b.BlurHash.decode(widget.blurhash);
    final img = blurhash.toImage(widget.width.round(), widget.height.round());
    return _data ??= Uint8List.fromList(image.encodePng(img));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: getBlurhashData(),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return Container(
            width: widget.width,
            height: widget.height,
            color: Theme.of(context).colorScheme.surface,
          );
        }
        return Image.memory(
          data,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
        );
      },
    );
  }
}
