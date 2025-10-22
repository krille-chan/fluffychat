// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:shimmer/shimmer.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

class ImageByUrl extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final BorderRadius borderRadius;
  final Widget? replacement;

  const ImageByUrl({
    super.key,
    required this.imageUrl,
    required this.width,
    this.replacement,
    this.borderRadius = const BorderRadius.all(Radius.circular(20.0)),
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return replacement ?? const SizedBox();
    }

    final Map<String, String> headers = {};
    if (imageUrl.toString().contains(Environment.cmsApi)) {
      headers['Authorization'] =
          'Bearer ${MatrixState.pangeaController.userController.accessToken}';
    }

    return SizedBox(
      width: width,
      height: width,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: imageUrl!.startsWith("mxc")
            ? MxcImage(
                uri: Uri.parse(imageUrl!),
                width: width,
                height: width,
                cacheKey: imageUrl,
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                width: width,
                height: width,
                fit: BoxFit.cover,
                imageUrl: imageUrl!,
                placeholder: (
                  context,
                  url,
                ) =>
                    Shimmer.fromColors(
                  baseColor:
                      Theme.of(context).colorScheme.primary.withAlpha(20),
                  highlightColor:
                      Theme.of(context).colorScheme.primary.withAlpha(50),
                  child: Container(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                errorWidget: (
                  context,
                  url,
                  error,
                ) =>
                    replacement ?? const SizedBox(),
                httpHeaders: headers,
                imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
              ),
      ),
    );
  }
}
