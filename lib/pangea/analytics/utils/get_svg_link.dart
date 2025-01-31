import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';

String getMorphSvgLink({
  required String morphFeature,
  String? morphTag,
  required BuildContext context,
}) =>
    "${AppConfig.assetsBaseURL}/${morphFeature.toLowerCase()}_${morphTag?.toLowerCase() ?? ''}.svg";
