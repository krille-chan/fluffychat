import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';

extension PushRuleExtension on PushRule {
  String getPushRuleName(L10n l10n) {
    switch (ruleId) {
      case '.m.rule.contains_user_name':
        return l10n.notificationRuleContainsUserName;
      case '.m.rule.master':
        return l10n.notificationRuleMaster;
      case '.m.rule.suppress_notices':
        return l10n.notificationRuleSuppressNotices;
      case '.m.rule.invite_for_me':
        return l10n.notificationRuleInviteForMe;
      case '.m.rule.member_event':
        return l10n.notificationRuleMemberEvent;
      case '.m.rule.is_user_mention':
        return l10n.notificationRuleIsUserMention;
      case '.m.rule.contains_display_name':
        return l10n.notificationRuleContainsDisplayName;
      case '.m.rule.is_room_mention':
        return l10n.notificationRuleIsRoomMention;
      case '.m.rule.roomnotif':
        return l10n.notificationRuleRoomnotif;
      case '.m.rule.tombstone':
        return l10n.notificationRuleTombstone;
      case '.m.rule.reaction':
        return l10n.notificationRuleReaction;
      case '.m.rule.room_server_acl':
        return l10n.notificationRuleRoomServerAcl;
      case '.m.rule.suppress_edits':
        return l10n.notificationRuleSuppressEdits;
      case '.m.rule.call':
        return l10n.notificationRuleCall;
      case '.m.rule.encrypted_room_one_to_one':
        return l10n.notificationRuleEncryptedRoomOneToOne;
      case '.m.rule.room_one_to_one':
        return l10n.notificationRuleRoomOneToOne;
      case '.m.rule.message':
        return l10n.notificationRuleMessage;
      case '.m.rule.encrypted':
        return l10n.notificationRuleEncrypted;
      case '.m.rule.room.server_acl':
        return l10n.notificationRuleServerAcl;
      case '.im.vector.jitsi':
        return l10n.notificationRuleJitsi;
      default:
        return ruleId.split('.').last.replaceAll('_', ' ').capitalize();
    }
  }

  String getPushRuleDescription(L10n l10n) {
    switch (ruleId) {
      case '.m.rule.contains_user_name':
        return l10n.notificationRuleContainsUserNameDescription;
      case '.m.rule.master':
        return l10n.notificationRuleMasterDescription;
      case '.m.rule.suppress_notices':
        return l10n.notificationRuleSuppressNoticesDescription;
      case '.m.rule.invite_for_me':
        return l10n.notificationRuleInviteForMeDescription;
      case '.m.rule.member_event':
        return l10n.notificationRuleMemberEventDescription;
      case '.m.rule.is_user_mention':
        return l10n.notificationRuleIsUserMentionDescription;
      case '.m.rule.contains_display_name':
        return l10n.notificationRuleContainsDisplayNameDescription;
      case '.m.rule.is_room_mention':
        return l10n.notificationRuleIsRoomMentionDescription;
      case '.m.rule.roomnotif':
        return l10n.notificationRuleRoomnotifDescription;
      case '.m.rule.tombstone':
        return l10n.notificationRuleTombstoneDescription;
      case '.m.rule.reaction':
        return l10n.notificationRuleReactionDescription;
      case '.m.rule.room_server_acl':
        return l10n.notificationRuleRoomServerAclDescription;
      case '.m.rule.suppress_edits':
        return l10n.notificationRuleSuppressEditsDescription;
      case '.m.rule.call':
        return l10n.notificationRuleCallDescription;
      case '.m.rule.encrypted_room_one_to_one':
        return l10n.notificationRuleEncryptedRoomOneToOneDescription;
      case '.m.rule.room_one_to_one':
        return l10n.notificationRuleRoomOneToOneDescription;
      case '.m.rule.message':
        return l10n.notificationRuleMessageDescription;
      case '.m.rule.encrypted':
        return l10n.notificationRuleEncryptedDescription;
      case '.m.rule.room.server_acl':
        return l10n.notificationRuleServerAclDescription;
      case '.im.vector.jitsi':
        return l10n.notificationRuleJitsiDescription;
      default:
        return l10n.unknownPushRule(ruleId);
    }
  }
}

extension PushRuleKindLocal on PushRuleKind {
  String localized(L10n l10n) {
    switch (this) {
      case PushRuleKind.content:
        return l10n.contentNotificationSettings;
      case PushRuleKind.override:
        return l10n.generalNotificationSettings;
      case PushRuleKind.room:
        return l10n.roomNotificationSettings;
      case PushRuleKind.sender:
        return l10n.userSpecificNotificationSettings;
      case PushRuleKind.underride:
        return l10n.otherNotificationSettings;
    }
  }
}

extension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
