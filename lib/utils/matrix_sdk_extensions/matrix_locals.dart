import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

/// This is a temporary helper class until there is a proper solution to this with the new system
class MatrixLocals extends MatrixLocalizations {
  final L10n l10n;

  MatrixLocals(this.l10n);

  @override
  String acceptedTheInvitation(String targetName) {
    return l10n.acceptedTheInvitation(targetName);
  }

  @override
  String activatedEndToEndEncryption(String senderName) {
    return l10n.activatedEndToEndEncryption(senderName);
  }

  @override
  String answeredTheCall(String senderName) {
    return l10n.answeredTheCall(senderName, senderName);
  }

  @override
  String get anyoneCanJoin => l10n.anyoneCanJoin;

  @override
  String bannedUser(String senderName, String targetName) {
    return l10n.bannedUser(senderName, targetName);
  }

  @override
  String changedTheChatAvatar(String senderName) {
    return l10n.changedTheChatAvatar(senderName);
  }

  @override
  String changedTheChatDescriptionTo(String senderName, String content) {
    return l10n.changedTheChatDescriptionTo(senderName, content);
  }

  @override
  String changedTheChatNameTo(String senderName, String content) {
    return l10n.changedTheChatNameTo(senderName, content);
  }

  @override
  String changedTheChatPermissions(String senderName) {
    return l10n.changedTheChatPermissions(senderName);
  }

  @override
  String changedTheDisplaynameTo(String targetName, String newDisplayname) {
    return l10n.changedTheDisplaynameTo(targetName, newDisplayname);
  }

  @override
  String changedTheGuestAccessRules(String senderName) {
    return l10n.changedTheGuestAccessRules(senderName);
  }

  @override
  String changedTheGuestAccessRulesTo(
    String senderName,
    String localizedString,
  ) {
    return l10n.changedTheGuestAccessRulesTo(senderName, localizedString);
  }

  @override
  String changedTheHistoryVisibility(String senderName) {
    return l10n.changedTheHistoryVisibility(senderName);
  }

  @override
  String changedTheHistoryVisibilityTo(
    String senderName,
    String localizedString,
  ) {
    return l10n.changedTheHistoryVisibilityTo(senderName, localizedString);
  }

  @override
  String changedTheJoinRules(String senderName) {
    return l10n.changedTheJoinRules(senderName);
  }

  @override
  String changedTheJoinRulesTo(String senderName, String localizedString) {
    return l10n.changedTheJoinRulesTo(senderName, localizedString);
  }

  @override
  String changedTheProfileAvatar(String targetName) {
    return l10n.changedTheProfileAvatar(targetName);
  }

  @override
  String changedTheRoomAliases(String senderName) {
    return l10n.changedTheRoomAliases(senderName);
  }

  @override
  String changedTheRoomInvitationLink(String senderName) {
    return l10n.changedTheRoomInvitationLink(senderName);
  }

  @override
  String get channelCorruptedDecryptError => l10n.channelCorruptedDecryptError;

  @override
  String couldNotDecryptMessage(String errorText) {
    return l10n.couldNotDecryptMessage(errorText);
  }

  @override
  String createdTheChat(String senderName) {
    return l10n.createdTheChat(senderName);
  }

  @override
  String get emptyChat => l10n.emptyChat;

  @override
  String get encryptionNotEnabled => l10n.encryptionNotEnabled;

  @override
  String endedTheCall(String senderName) {
    return l10n.endedTheCall(senderName);
  }

  @override
  String get fromJoining => l10n.fromJoining;

  @override
  String get fromTheInvitation => l10n.fromTheInvitation;

  @override
  String groupWith(String displayname) {
    return l10n.groupWith(displayname);
  }

  @override
  String get guestsAreForbidden => l10n.guestsAreForbidden;

  @override
  String get guestsCanJoin => l10n.guestsCanJoin;

  @override
  String hasWithdrawnTheInvitationFor(String senderName, String targetName) {
    return l10n.hasWithdrawnTheInvitationFor(senderName, targetName);
  }

  @override
  String invitedUser(String senderName, String targetName) {
    return l10n.invitedUser(senderName, targetName);
  }

  @override
  String get invitedUsersOnly => l10n.invitedUsersOnly;

  @override
  String joinedTheChat(String targetName) {
    return l10n.joinedTheChat(targetName);
  }

  @override
  String kicked(String senderName, String targetName) {
    return l10n.kicked(senderName, targetName);
  }

  @override
  String kickedAndBanned(String senderName, String targetName) {
    return l10n.kickedAndBanned(senderName, targetName);
  }

  @override
  String get needPantalaimonWarning => l10n.needPantalaimonWarning;

  @override
  String get noPermission => l10n.noKeyForThisMessage;

  @override
  String redactedAnEvent(String senderName) {
    return l10n.redactedAnEvent(senderName);
  }

  @override
  String rejectedTheInvitation(String targetName) {
    return l10n.rejectedTheInvitation(targetName);
  }

  @override
  String removedBy(String calcDisplayname) {
    return l10n.removedBy(calcDisplayname);
  }

  @override
  String get roomHasBeenUpgraded => l10n.roomHasBeenUpgraded;

  @override
  String sentAFile(String senderName) {
    return l10n.sentAFile(senderName);
  }

  @override
  String sentAPicture(String senderName) {
    return l10n.sentAPicture(senderName);
  }

  @override
  String sentASticker(String senderName) {
    return l10n.sentASticker(senderName);
  }

  @override
  String sentAVideo(String senderName) {
    return l10n.sentAVideo(senderName);
  }

  @override
  String sentAnAudio(String senderName) {
    return l10n.sentAnAudio(senderName);
  }

  @override
  String sentCallInformations(String senderName) {
    return l10n.sentCallInformations(senderName);
  }

  @override
  String sharedTheLocation(String senderName) {
    return l10n.sharedTheLocation(senderName);
  }

  @override
  String startedACall(String senderName) {
    return l10n.startedACall(senderName);
  }

  @override
  String unbannedUser(String senderName, String targetName) {
    return l10n.unbannedUser(senderName, targetName);
  }

  @override
  String get unknownEncryptionAlgorithm => l10n.unknownEncryptionAlgorithm;

  @override
  String unknownEvent(String typeKey) {
    return l10n.unknownEvent(typeKey, typeKey);
  }

  @override
  String userLeftTheChat(String targetName) {
    return l10n.userLeftTheChat(targetName);
  }

  @override
  String get visibleForAllParticipants => l10n.visibleForAllParticipants;

  @override
  String get visibleForEveryone => l10n.visibleForEveryone;

  @override
  String get you => l10n.you;

  @override
  String sentReaction(String senderName, String reactionKey) =>
      l10n.reactedWith(senderName, reactionKey);

  @override
  // TODO: implement youAcceptedTheInvitation
  String get youAcceptedTheInvitation => l10n.youAcceptedTheInvitation;

  @override
  String youBannedUser(String targetName) => l10n.youBannedUser(targetName);

  @override
  String youHaveWithdrawnTheInvitationFor(String targetName) =>
      l10n.youHaveWithdrawnTheInvitationFor(targetName);

  @override
  String youInvitedBy(String senderName) => l10n.youInvitedBy(senderName);

  @override
  String youInvitedUser(String targetName) => l10n.youInvitedUser(targetName);

  @override
  // TODO: implement youJoinedTheChat
  String get youJoinedTheChat => l10n.youJoinedTheChat;

  @override
  String youKicked(String targetName) => l10n.youKicked(targetName);

  @override
  String youKickedAndBanned(String targetName) =>
      l10n.youKickedAndBanned(targetName);

  @override
  // TODO: implement youRejectedTheInvitation
  String get youRejectedTheInvitation => l10n.youRejectedTheInvitation;

  @override
  String youUnbannedUser(String targetName) => l10n.youUnbannedUser(targetName);

  @override
  String wasDirectChatDisplayName(String oldDisplayName) =>
      l10n.wasDirectChatDisplayName(oldDisplayName);
}
