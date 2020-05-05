import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'room_state_enums_extensions.dart';

extension LocalizedBody on Event {
  static Set<MessageTypes> textOnlyMessageTypes = {
    MessageTypes.Text,
    MessageTypes.Reply,
    MessageTypes.Notice,
    MessageTypes.Emote,
    MessageTypes.None,
  };

  String getLocalizedBody(I18n i18n,
      {bool withSenderNamePrefix = false, bool hideReply = false}) {
    if (this.redacted) {
      return i18n.removedBy(redactedBecause.sender.calcDisplayname());
    }
    String localizedBody = body;
    final String senderName = this.sender.calcDisplayname();
    switch (this.type) {
      case EventTypes.Sticker:
        localizedBody = i18n.sentASticker(senderName);
        break;
      case EventTypes.Redaction:
        localizedBody = i18n.redactedAnEvent(senderName);
        break;
      case EventTypes.RoomAliases:
        localizedBody = i18n.changedTheRoomAliases(senderName);
        break;
      case EventTypes.RoomCanonicalAlias:
        localizedBody = i18n.changedTheRoomInvitationLink(senderName);
        break;
      case EventTypes.RoomCreate:
        localizedBody = i18n.createdTheChat(senderName);
        break;
      case EventTypes.RoomJoinRules:
        JoinRules joinRules = JoinRules.values.firstWhere(
            (r) =>
                r.toString().replaceAll("JoinRules.", "") ==
                content["join_rule"],
            orElse: () => null);
        if (joinRules == null) {
          localizedBody = i18n.changedTheJoinRules(senderName);
        } else {
          localizedBody = i18n.changedTheJoinRulesTo(
              senderName, joinRules.getLocalizedString(i18n));
        }
        break;
      case EventTypes.RoomMember:
        String text = "Failed to parse member event";
        final String targetName = this.stateKeyUser.calcDisplayname();
        // Has the membership changed?
        final String newMembership = this.content["membership"] ?? "";
        final String oldMembership =
            this.unsigned["prev_content"] is Map<String, dynamic>
                ? this.unsigned["prev_content"]["membership"] ?? ""
                : "";
        if (newMembership != oldMembership) {
          if (oldMembership == "invite" && newMembership == "join") {
            text = i18n.acceptedTheInvitation(targetName);
          } else if (oldMembership == "invite" && newMembership == "leave") {
            if (this.stateKey == this.senderId) {
              text = i18n.rejectedTheInvitation(targetName);
            } else {
              text = i18n.hasWithdrawnTheInvitationFor(senderName, targetName);
            }
          } else if (oldMembership == "leave" && newMembership == "join") {
            text = i18n.joinedTheChat(targetName);
          } else if (oldMembership == "join" && newMembership == "ban") {
            text = i18n.kickedAndBanned(senderName, targetName);
          } else if (oldMembership == "join" &&
              newMembership == "leave" &&
              this.stateKey != this.senderId) {
            text = i18n.kicked(senderName, targetName);
          } else if (oldMembership == "join" &&
              newMembership == "leave" &&
              this.stateKey == this.senderId) {
            text = i18n.userLeftTheChat(targetName);
          } else if (oldMembership == "invite" && newMembership == "ban") {
            text = i18n.bannedUser(senderName, targetName);
          } else if (oldMembership == "leave" && newMembership == "ban") {
            text = i18n.bannedUser(senderName, targetName);
          } else if (oldMembership == "ban" && newMembership == "leave") {
            text = i18n.unbannedUser(senderName, targetName);
          } else if (newMembership == "invite") {
            text = i18n.invitedUser(senderName, targetName);
          } else if (newMembership == "join") {
            text = i18n.joinedTheChat(targetName);
          }
        } else if (newMembership == "join") {
          final String newAvatar = this.content["avatar_url"] ?? "";
          final String oldAvatar =
              this.unsigned["prev_content"] is Map<String, dynamic>
                  ? this.unsigned["prev_content"]["avatar_url"] ?? ""
                  : "";

          final String newDisplayname = this.content["displayname"] ?? "";
          final String oldDisplayname =
              this.unsigned["prev_content"] is Map<String, dynamic>
                  ? this.unsigned["prev_content"]["displayname"] ?? ""
                  : "";

          // Has the user avatar changed?
          if (newAvatar != oldAvatar) {
            text = i18n.changedTheProfileAvatar(targetName);
          }
          // Has the user avatar changed?
          else if (newDisplayname != oldDisplayname) {
            text = i18n.changedTheDisplaynameTo(targetName, newDisplayname);
          }
        }
        localizedBody = text;
        break;
      case EventTypes.RoomPowerLevels:
        localizedBody = i18n.changedTheChatPermissions(senderName);
        break;
      case EventTypes.RoomName:
        localizedBody = i18n.changedTheChatNameTo(senderName, content["name"]);
        break;
      case EventTypes.RoomTopic:
        localizedBody =
            i18n.changedTheChatDescriptionTo(senderName, content["topic"]);
        break;
      case EventTypes.RoomAvatar:
        localizedBody = i18n.changedTheChatAvatar(senderName);
        break;
      case EventTypes.GuestAccess:
        GuestAccess guestAccess = GuestAccess.values.firstWhere(
            (r) =>
                r.toString().replaceAll("GuestAccess.", "") ==
                content["guest_access"],
            orElse: () => null);
        if (guestAccess == null) {
          localizedBody = i18n.changedTheGuestAccessRules(senderName);
        } else {
          localizedBody = i18n.changedTheGuestAccessRulesTo(
              senderName, guestAccess.getLocalizedString(i18n));
        }
        break;
      case EventTypes.HistoryVisibility:
        HistoryVisibility historyVisibility = HistoryVisibility.values
            .firstWhere(
                (r) =>
                    r.toString().replaceAll("HistoryVisibility.", "") ==
                    content["history_visibility"],
                orElse: () => null);
        if (historyVisibility == null) {
          localizedBody = i18n.changedTheHistoryVisibility(senderName);
        } else {
          localizedBody = i18n.changedTheHistoryVisibilityTo(
              senderName, historyVisibility.getLocalizedString(i18n));
        }
        break;
      case EventTypes.Encryption:
        localizedBody = i18n.activatedEndToEndEncryption(senderName);
        if (!room.client.encryptionEnabled) {
          localizedBody += ". " + i18n.needPantalaimonWarning;
        }
        break;
      case EventTypes.Encrypted:
      case EventTypes.Message:
        switch (this.messageType) {
          case MessageTypes.Image:
            localizedBody = i18n.sentAPicture(senderName);
            break;
          case MessageTypes.File:
            localizedBody = i18n.sentAFile(senderName);
            break;
          case MessageTypes.Audio:
            localizedBody = i18n.sentAnAudio(senderName);
            break;
          case MessageTypes.Video:
            localizedBody = i18n.sentAVideo(senderName);
            break;
          case MessageTypes.Location:
            localizedBody = i18n.sharedTheLocation(senderName);
            break;
          case MessageTypes.Sticker:
            localizedBody = i18n.sentASticker(senderName);
            break;
          case MessageTypes.Emote:
            localizedBody = "* $body";
            break;
          case MessageTypes.BadEncrypted:
            String errorText;
            switch (body) {
              case DecryptError.CHANNEL_CORRUPTED:
                errorText = i18n.channelCorruptedDecryptError + ".";
                break;
              case DecryptError.NOT_ENABLED:
                errorText = i18n.encryptionNotEnabled + ".";
                break;
              case DecryptError.UNKNOWN_ALGORITHM:
                errorText = i18n.unknownEncryptionAlgorithm + ".";
                break;
              case DecryptError.UNKNOWN_SESSION:
                errorText = i18n.noPermission + ".";
                break;
              default:
                errorText = body;
                break;
            }
            localizedBody =
                "🔒 " + i18n.couldNotDecryptMessage + ": " + errorText;
            break;
          case MessageTypes.Text:
          case MessageTypes.Notice:
          case MessageTypes.None:
          case MessageTypes.Reply:
            localizedBody = body;
            break;
        }
        break;
      default:
        localizedBody = i18n.unknownEvent(this.typeKey);
    }

    // Hide reply fallback
    if (hideReply) {
      localizedBody = localizedBody.replaceFirst(
          RegExp(r'^>( \*)? <[^>]+>[^\n\r]+\r?\n(> [^\n]*\r?\n)*\r?\n'), "");
    }

    // Add the sender name prefix
    if (withSenderNamePrefix &&
        this.type == EventTypes.Message &&
        textOnlyMessageTypes.contains(this.messageType)) {
      final String senderNameOrYou =
          this.senderId == room.client.userID ? i18n.you : senderName;
      localizedBody = "$senderNameOrYou: $localizedBody";
    }

    return localizedBody;
  }

  IconData get statusIcon {
    switch (this.status) {
      case -1:
        return Icons.error_outline;
      case 0:
        return Icons.timer;
      case 1:
        return Icons.done;
      case 2:
        return Icons.done_all;
      default:
        return Icons.done;
    }
  }

  String get sizeString {
    if (content["info"] is Map<String, dynamic> &&
        content["info"].containsKey("size")) {
      num size = content["info"]["size"];
      if (size < 1000000) {
        size = size / 1000;
        return "${size.toString()}kb";
      } else if (size < 1000000000) {
        size = size / 1000000;
        return "${size.toString()}mb";
      } else {
        size = size / 1000000000;
        return "${size.toString()}gb";
      }
    } else {
      return null;
    }
  }
}
