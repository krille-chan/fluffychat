// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';

import 'package:fluffychat/widgets/matrix.dart';

class CourseImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final Widget? replacement;
  final BorderRadius borderRadius;

  const CourseImage({
    super.key,
    required this.imageUrl,
    required this.width,
    this.replacement,
    this.borderRadius = const BorderRadius.all(Radius.circular(20.0)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: imageUrl != null
          ? CachedNetworkImage(
              width: width,
              height: width,
              fit: BoxFit.cover,
              imageUrl: imageUrl!,
              httpHeaders: {
                'Authorization':
                    'Bearer ${MatrixState.pangeaController.userController.accessToken}',
              },
              imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
              placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorWidget: (context, url, error) {
                return replacement ?? const SizedBox();
              },
            )
          : replacement ?? const SizedBox(),
    );
  }
}
