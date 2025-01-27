import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

enum MediaEnum {
  images,
  videos,
  voiceMessages,
  nan,
}

extension MediaEnumExtension on MediaEnum {
  //fromString
  MediaEnum fromString(String value) {
    switch (value) {
      case 'images':
        return MediaEnum.images;
      case 'videos':
        return MediaEnum.videos;
      case 'voice_messages':
        return MediaEnum.voiceMessages;
      case 'nan':
        return MediaEnum.nan;
      default:
        return MediaEnum.nan;
    }
  }

  String get string {
    switch (this) {
      case MediaEnum.images:
        return 'images';
      case MediaEnum.videos:
        return 'videos';
      case MediaEnum.voiceMessages:
        return 'voice_messages';
      case MediaEnum.nan:
        return 'nan';
    }
  }

  //toDisplayCopyUsingL10n
  String toDisplayCopyUsingL10n(BuildContext context) {
    switch (this) {
      case MediaEnum.images:
        return L10n.of(context).image;
      case MediaEnum.videos:
        return L10n.of(context).video;
      case MediaEnum.voiceMessages:
        return L10n.of(context).voiceMessage;
      case MediaEnum.nan:
        return L10n.of(context).nan;
    }
  }
}
