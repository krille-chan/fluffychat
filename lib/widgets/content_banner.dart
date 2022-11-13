import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/mxc_image.dart';

class ContentBanner extends StatelessWidget {
  final Uri? mxContent;
  final double height;
  final IconData defaultIcon;
  final void Function()? onEdit;
  final Client? client;
  final double opacity;
  final String heroTag;

  const ContentBanner(
      {this.mxContent,
      this.height = 400,
      this.defaultIcon = Icons.account_circle_outlined,
      this.onEdit,
      this.client,
      this.opacity = 0.75,
      this.heroTag = 'content_banner',
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onEdit = this.onEdit;
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Opacity(
              opacity: opacity,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Hero(
                  tag: heroTag,
                  child: MxcImage(
                    key: Key(mxContent?.toString() ?? 'NoKey'),
                    uri: mxContent,
                    animated: true,
                    fit: BoxFit.cover,
                    height: 400,
                    width: 800,
                  ),
                );
              }),
            ),
          ),
          if (onEdit != null)
            Container(
              margin: const EdgeInsets.all(8),
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                mini: true,
                onPressed: onEdit,
                backgroundColor: Theme.of(context).backgroundColor,
                foregroundColor: Theme.of(context).textTheme.bodyText1?.color,
                child: const Icon(Icons.camera_alt_outlined),
              ),
            ),
        ],
      ),
    );
  }
}
