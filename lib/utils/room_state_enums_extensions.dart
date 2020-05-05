import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/i18n/i18n.dart';

extension HistoryVisibilityDisplayString on HistoryVisibility {
  String getLocalizedString(I18n i18n) {
    switch (this) {
      case HistoryVisibility.invited:
        return i18n.fromTheInvitation;
      case HistoryVisibility.joined:
        return i18n.fromJoining;
      case HistoryVisibility.shared:
        return i18n.visibleForAllParticipants;
      case HistoryVisibility.world_readable:
        return i18n.visibleForEveryone;
      default:
        return this.toString().replaceAll("HistoryVisibility.", "");
    }
  }
}

extension GuestAccessDisplayString on GuestAccess {
  String getLocalizedString(I18n i18n) {
    switch (this) {
      case GuestAccess.can_join:
        return i18n.guestsCanJoin;
      case GuestAccess.forbidden:
        return i18n.guestsAreForbidden;
      default:
        return this.toString().replaceAll("GuestAccess.", "");
    }
  }
}

extension JoinRulesDisplayString on JoinRules {
  String getLocalizedString(I18n i18n) {
    switch (this) {
      case JoinRules.public:
        return i18n.anyoneCanJoin;
      case JoinRules.invite:
        return i18n.invitedUsersOnly;
      default:
        return this.toString().replaceAll("JoinRules.", "");
    }
  }
}
