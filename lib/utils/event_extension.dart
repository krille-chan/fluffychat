import 'package:famedlysdk/famedlysdk.dart';
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

  getLocalizedBody(BuildContext context,
      {bool withSenderNamePrefix = false, hideQuotes = false}) {
    if (this.redacted) {
      return "Redacted by ${this.redactedBecause.sender.calcDisplayname()}";
    }
    String localizedBody = body;
    final String senderName = this.sender.calcDisplayname();
    switch (this.type) {
      case EventTypes.Sticker:
        localizedBody = "$senderName sent a sticker";
        break;
      case EventTypes.Redaction:
        localizedBody = "$senderName redacted an event";
        break;
      case EventTypes.RoomAliases:
        localizedBody = "$senderName changed the room aliases";
        break;
      case EventTypes.RoomCanonicalAlias:
        localizedBody = "$senderName changed the room invite link";
        break;
      case EventTypes.RoomCreate:
        localizedBody = "$senderName created the room";
        break;
      case EventTypes.RoomJoinRules:
        JoinRules joinRules = JoinRules.values.firstWhere(
            (r) =>
                r.toString().replaceAll("JoinRules.", "") ==
                content["join_rule"],
            orElse: () => null);
        if (joinRules == null) {
          localizedBody = "$senderName changed the join rules";
        } else {
          localizedBody =
              "$senderName changed the join rules to: ${joinRules.getLocalizedString(context)}";
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
            text = "$targetName has accepted the invitation";
          } else if (oldMembership == "leave" && newMembership == "join") {
            text = "$targetName has joined the chat";
          } else if (oldMembership == "join" && newMembership == "ban") {
            text = "$senderName has kicked and banned $targetName";
          } else if (oldMembership == "join" &&
              newMembership == "leave" &&
              this.stateKey != this.senderId) {
            text = "$senderName has kicked $targetName";
          } else if (oldMembership == "join" &&
              newMembership == "leave" &&
              this.stateKey == this.senderId) {
            text = "$senderName has left the room";
          } else if (oldMembership == "invite" && newMembership == "ban") {
            text = "$senderName has banned $targetName";
          } else if (oldMembership == "leave" && newMembership == "ban") {
            text = "$senderName has banned $targetName";
          } else if (oldMembership == "ban" && newMembership == "leave") {
            text = "$senderName has unbanned $targetName";
          } else if (newMembership == "invite") {
            text = "$senderName has invited $targetName";
          } else if (newMembership == "join") {
            text = "$targetName has joined";
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
            text = "$targetName has changed the profile avatar";
          }
          // Has the user avatar changed?
          else if (newDisplayname != oldDisplayname) {
            text =
                "${this.stateKeyUser.id} has changed the displayname to '$newDisplayname'";
          }
        }
        localizedBody = text;
        break;
      case EventTypes.RoomPowerLevels:
        localizedBody = "$senderName changed the group permissions";
        break;
      case EventTypes.RoomName:
        localizedBody =
            "$senderName changed the group name to: '${content["name"]}'";
        break;
      case EventTypes.RoomTopic:
        localizedBody =
            "$senderName changed the group name to: '${content["topic"]}'";
        break;
      case EventTypes.RoomAvatar:
        localizedBody = "$senderName changed the group avatar";
        break;
      case EventTypes.GuestAccess:
        GuestAccess guestAccess = GuestAccess.values.firstWhere(
            (r) =>
                r.toString().replaceAll("GuestAccess.", "") ==
                content["guest_access"],
            orElse: () => null);
        if (guestAccess == null) {
          localizedBody = "$senderName changed the guest access rules";
        } else {
          localizedBody =
              "$senderName changed the guest access rules to: ${guestAccess.getLocalizedString(context)}";
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
          localizedBody = "$senderName changed the history visibility";
        } else {
          localizedBody =
              "$senderName changed the history visibility to: ${historyVisibility.getLocalizedString(context)}";
        }
        break;
      case EventTypes.Encryption:
        localizedBody = "$senderName activated end to end encryption";
        break;
      case EventTypes.Encrypted:
        localizedBody = "Could not decrypt message";
        break;
      case EventTypes.CallInvite:
        localizedBody = body;
        break;
      case EventTypes.CallAnswer:
        localizedBody = body;
        break;
      case EventTypes.CallCandidates:
        localizedBody = body;
        break;
      case EventTypes.CallHangup:
        localizedBody = body;
        break;
      case EventTypes.Unknown:
        localizedBody = body;
        break;
      case EventTypes.Message:
        switch (this.messageType) {
          case MessageTypes.Image:
            localizedBody = "$senderName sent a picture";
            break;
          case MessageTypes.File:
            localizedBody = "$senderName sent a file";
            break;
          case MessageTypes.Audio:
            localizedBody = "$senderName sent an audio";
            break;
          case MessageTypes.Video:
            localizedBody = "$senderName sent a video";
            break;
          case MessageTypes.Location:
            localizedBody = "$senderName shared the location";
            break;
          case MessageTypes.Sticker:
            localizedBody = "$senderName sent a sticker";
            break;
          case MessageTypes.Emote:
            localizedBody = "* $body";
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
        localizedBody =
            "Unknown event '${this.type.toString().replaceAll("EventTypes.", "")}'";
    }

    // Add the sender name prefix
    if (withSenderNamePrefix &&
        this.type == EventTypes.Message &&
        textOnlyMessageTypes.contains(this.messageType)) {
      localizedBody = "$senderName: $localizedBody";
    }

    // Hide quotes
    if (hideQuotes) {
      List<String> lines = localizedBody.split("\n");
      lines.removeWhere((s) => s.startsWith("> "));
      localizedBody = lines.join("\n");
    }

    return localizedBody;
  }
}
