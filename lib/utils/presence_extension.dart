import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:flutter/material.dart';

extension PresenceExtension on Presence {
  bool get isStatus =>
      (statusMsg?.isNotEmpty ?? false) || this.displayname != null;

  String getLocalizedStatusMessage(BuildContext context) {
    if (!isStatus) return null;
    if (statusMsg?.isNotEmpty ?? false) {
      return statusMsg;
    }
    if (displayname != null) {
      return I18n.of(context)
          .changedTheDisplaynameTo(sender.localpart, displayname);
    }
    if (avatarUrl != null) {
      return I18n.of(context).changedTheProfileAvatar(sender.localpart);
    }
    return null;
  }
}
