import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'date_time_extension.dart';

extension PresenceExtension on Presence {
  String getLocalizedStatusMessage(BuildContext context) {
    if (statusMsg?.isNotEmpty ?? false) {
      return statusMsg;
    }
    if (displayname != null) {
      return I18n.of(context)
          .changedTheDisplaynameTo(sender.localpart, displayname);
    }
    return I18n.of(context).lastActiveAgo(time.localizedTimeShort(context));
  }
}
