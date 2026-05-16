// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/pages/chat/events/file_send_status_indicator.dart';
import 'package:fluffychat/utils/file_description.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:matrix/matrix.dart';

import '../../../widgets/blur_hash.dart';

class ImageBubble extends StatelessWidget {
  final Event event;
  final bool tapToView;
  final BoxFit fit;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? linkColor;
  final bool thumbnailOnly;
  final bool animated;
  final double width;
  final double height;
  final void Function()? onTap;
  final BorderRadius? borderRadius;
  final Timeline? timeline;

  const ImageBubble(
    this.event, {
    this.tapToView = true,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.thumbnailOnly = true,
    this.width = 400,
    this.height = 300,
    this.animated = false,
    this.onTap,
    this.borderRadius,
    this.timeline,
    this.textColor,
    this.linkColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var borderRadius =
        this.borderRadius ?? BorderRadius.circular(AppConfig.borderRadius);

    final fileDescription = event.fileDescription;
    final textColor = this.textColor;

    if (fileDescription != null) {
      borderRadius = borderRadius.copyWith(
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
      );
    }
    final fileSendingStatus = event.fileSendingStatus;

    return Column(
      mainAxisSize: .min,
      spacing: 8,
      children: [
        Material(
          color: Colors.transparent,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: BorderSide(
              color: event.messageType == MessageTypes.Sticker
                  ? Colors.transparent
                  : theme.dividerColor,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: event.eventId,
                  child: AppSettings.showThumbnailsInTimeline.value
                      ? MxcImage(
                          event: event,
                          width: width,
                          height: height,
                          fit: fit,
                          animated: animated,
                          isThumbnail: thumbnailOnly,
                          placeholder: event.messageType == MessageTypes.Sticker
                              ? null
                              : (_) => _ImageBubblePlaceholder(
                                  event: event,
                                  width: width,
                                  height: height,
                                  fit: fit,
                                ),
                        )
                      : _ImageBubblePlaceholder(
                          event: event,
                          width: width,
                          height: height,
                          fit: fit,
                        ),
                ),
                if (fileSendingStatus != null)
                  FileSendStatusIndicator(fileSendingStatus: fileSendingStatus),
              ],
            ),
          ),
        ),
        if (fileDescription != null && textColor != null)
          SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Linkify(
                text: fileDescription,
                textScaleFactor: MediaQuery.textScalerOf(context).scale(1),
                style: TextStyle(
                  color: textColor,
                  fontSize:
                      AppSettings.fontSizeFactor.value *
                      AppConfig.messageFontSize,
                ),
                options: const LinkifyOptions(humanize: false),
                linkStyle: TextStyle(
                  color: linkColor,
                  fontSize:
                      AppSettings.fontSizeFactor.value *
                      AppConfig.messageFontSize,
                  decoration: TextDecoration.underline,
                  decorationColor: linkColor,
                ),
                onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
              ),
            ),
          ),
      ],
    );
  }
}

class _ImageBubblePlaceholder extends StatelessWidget {
  final Event event;
  final double width, height;
  final BoxFit fit;

  const _ImageBubblePlaceholder({
    required this.event,
    required this.width,
    required this.height,
    required this.fit,
  });

  @override
  Widget build(BuildContext context) {
    final blurHashString =
        event.infoMap.tryGet<String>('xyz.amorgan.blurhash') ??
        'LEHV6nWB2yk8pyo0adR*.7kCMdnj';
    return SizedBox(
      width: width,
      height: height,
      child: BlurHash(
        blurhash: blurHashString,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
