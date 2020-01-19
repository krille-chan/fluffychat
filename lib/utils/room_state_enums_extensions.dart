import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';

extension HistoryVisibilityDisplayString on HistoryVisibility {
  String getLocalizedString(BuildContext context) {
    switch (this) {
      case HistoryVisibility.invited:
        return "From the invitation";
      case HistoryVisibility.joined:
        return "From joining";
      case HistoryVisibility.shared:
        return "Visible for all participants";
      case HistoryVisibility.world_readable:
        return "Visible for everyone";
      default:
        return this.toString().replaceAll("HistoryVisibility.", "");
    }
  }
}

extension GuestAccessDisplayString on GuestAccess {
  String getLocalizedString(BuildContext context) {
    switch (this) {
      case GuestAccess.can_join:
        return "Guests can join";
      case GuestAccess.forbidden:
        return "Guests are forbidden";
      default:
        return this.toString().replaceAll("GuestAccess.", "");
    }
  }
}

extension JoinRulesDisplayString on JoinRules {
  String getLocalizedString(BuildContext context) {
    switch (this) {
      case JoinRules.public:
        return "Anyone can join";
      case JoinRules.invite:
        return "Invited users only";
      default:
        return this.toString().replaceAll("JoinRules.", "");
    }
  }
}
