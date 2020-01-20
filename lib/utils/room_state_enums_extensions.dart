import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:flutter/material.dart';

extension HistoryVisibilityDisplayString on HistoryVisibility {
  String getLocalizedString(BuildContext context) {
    switch (this) {
      case HistoryVisibility.invited:
        return I18n.of(context).fromTheInvitation;
      case HistoryVisibility.joined:
        return I18n.of(context).fromJoining;
      case HistoryVisibility.shared:
        return I18n.of(context).visibleForAllParticipants;
      case HistoryVisibility.world_readable:
        return I18n.of(context).visibleForEveryone;
      default:
        return this.toString().replaceAll("HistoryVisibility.", "");
    }
  }
}

extension GuestAccessDisplayString on GuestAccess {
  String getLocalizedString(BuildContext context) {
    switch (this) {
      case GuestAccess.can_join:
        return I18n.of(context).guestsCanJoin;
      case GuestAccess.forbidden:
        return I18n.of(context).guestsAreForbidden;
      default:
        return this.toString().replaceAll("GuestAccess.", "");
    }
  }
}

extension JoinRulesDisplayString on JoinRules {
  String getLocalizedString(BuildContext context) {
    switch (this) {
      case JoinRules.public:
        return I18n.of(context).anyoneCanJoin;
      case JoinRules.invite:
        return I18n.of(context).invitedUsersOnly;
      default:
        return this.toString().replaceAll("JoinRules.", "");
    }
  }
}
