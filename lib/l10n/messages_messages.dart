// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'messages';

  static m0(username) => "${username} accepted the invitation";

  static m1(username) => "${username} activated end to end encryption";

  static m2(senderName) => "${senderName} answered the call";

  static m3(username) => "Accept this verification request from ${username}?";

  static m4(username, targetName) => "${username} banned ${targetName}";

  static m5(homeserver) => "By default you will be connected to ${homeserver}";

  static m6(username) => "${username} changed the chat avatar";

  static m7(username, description) =>
      "${username} changed the chat description to: \'${description}\'";

  static m8(username, chatname) =>
      "${username} changed the chat name to: \'${chatname}\'";

  static m9(username) => "${username} changed the chat permissions";

  static m10(username, displayname) =>
      "${username} changed the displayname to: ${displayname}";

  static m11(username) => "${username} changed the guest access rules";

  static m12(username, rules) =>
      "${username} changed the guest access rules to: ${rules}";

  static m13(username) => "${username} changed the history visibility";

  static m14(username, rules) =>
      "${username} changed the history visibility to: ${rules}";

  static m15(username) => "${username} changed the join rules";

  static m16(username, joinRules) =>
      "${username} changed the join rules to: ${joinRules}";

  static m17(username) => "${username} changed their avatar";

  static m18(username) => "${username} changed the room aliases";

  static m19(username) => "${username} changed the invitation link";

  static m20(error) => "Could not decrypt message: ${error}";

  static m21(count) => "${count} participants";

  static m22(username) => "${username} created the chat";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${year}-${month}-${day}";

  static m25(month, day) => "${month}-${day}";

  static m26(senderName) => "${senderName} ended the call";

  static m27(displayname) => "Group with ${displayname}";

  static m28(username, targetName) =>
      "${username} has withdrawn the invitation for ${targetName}";

  static m29(groupName) => "Invite contact to ${groupName}";

  static m30(username, link) =>
      "${username} invited you to FluffyChat. \n1. Install FluffyChat: https://fluffychat.im \n2. Sign up or sign in \n3. Open the invite link: ${link}";

  static m31(username, targetName) => "${username} invited ${targetName}";

  static m32(username) => "${username} joined the chat";

  static m33(username, targetName) => "${username} kicked ${targetName}";

  static m34(username, targetName) =>
      "${username} kicked and banned ${targetName}";

  static m35(localizedTimeShort) => "Last active: ${localizedTimeShort}";

  static m36(count) => "Load ${count} more participants";

  static m37(homeserver) => "Log in to ${homeserver}";

  static m38(number) => "${number} selected";

  static m39(fileName) => "Play ${fileName}";

  static m40(username) => "${username} redacted an event";

  static m41(username) => "${username} rejected the invitation";

  static m42(username) => "Removed by ${username}";

  static m43(username) => "Seen by ${username}";

  static m44(username, count) => "Seen by ${username} and ${count} others";

  static m45(username, username2) => "Seen by ${username} and ${username2}";

  static m46(username) => "${username} sent a file";

  static m47(username) => "${username} sent a picture";

  static m48(username) => "${username} sent a sticker";

  static m49(username) => "${username} sent a video";

  static m50(username) => "${username} sent an audio";

  static m51(senderName) => "${senderName} sent call informations";

  static m52(username) => "${username} shared the location";

  static m53(senderName) => "${senderName} started a call";

  static m54(hours12, hours24, minutes, suffix) =>
      "${hours12}:${minutes} ${suffix}";

  static m55(username, targetName) => "${username} unbanned ${targetName}";

  static m56(type) => "Unknown event \'${type}\'";

  static m57(unreadCount) => "${unreadCount} unread chats";

  static m58(unreadEvents) => "${unreadEvents} unread messages";

  static m59(unreadEvents, unreadChats) =>
      "${unreadEvents} unread messages in ${unreadChats} chats";

  static m60(username, count) =>
      "${username} and ${count} others are typing...";

  static m61(username, username2) =>
      "${username} and ${username2} are typing...";

  static m62(username) => "${username} is typing...";

  static m63(username) => "${username} left the chat";

  static m64(username, type) => "${username} sent a ${type} event";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("About"),
        "accept": MessageLookupByLibrary.simpleMessage("Accept"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Account informations"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription":
            MessageLookupByLibrary.simpleMessage("Add a group description"),
        "admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Already have an account?"),
        "answeredTheCall": m2,
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("Anyone can join"),
        "archive": MessageLookupByLibrary.simpleMessage("Archive"),
        "archivedRoom": MessageLookupByLibrary.simpleMessage("Archived Room"),
        "areGuestsAllowedToJoin": MessageLookupByLibrary.simpleMessage(
            "Are guest users allowed to join"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Are you sure?"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Please enter your secure store passphrase or recovery key to cache the keys."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "To be able to sign the other person, please enter your secure store passphrase or recovery key."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Please enter your secure store passphrase or recovery key to verify your session."),
        "askVerificationRequest": m3,
        "authentication":
            MessageLookupByLibrary.simpleMessage("Authentication"),
        "avatarHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Avatar has been changed"),
        "banFromChat": MessageLookupByLibrary.simpleMessage("Ban from chat"),
        "banned": MessageLookupByLibrary.simpleMessage("Banned"),
        "bannedUser": m4,
        "blockDevice": MessageLookupByLibrary.simpleMessage("Block Device"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys":
            MessageLookupByLibrary.simpleMessage("Successfully cached keys!"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "changeTheHomeserver":
            MessageLookupByLibrary.simpleMessage("Change the homeserver"),
        "changeTheNameOfTheGroup": MessageLookupByLibrary.simpleMessage(
            "Change the name of the group"),
        "changeTheServer":
            MessageLookupByLibrary.simpleMessage("Change the server"),
        "changeTheme":
            MessageLookupByLibrary.simpleMessage("Change your style"),
        "changeWallpaper":
            MessageLookupByLibrary.simpleMessage("Change wallpaper"),
        "changedTheChatAvatar": m6,
        "changedTheChatDescriptionTo": m7,
        "changedTheChatNameTo": m8,
        "changedTheChatPermissions": m9,
        "changedTheDisplaynameTo": m10,
        "changedTheGuestAccessRules": m11,
        "changedTheGuestAccessRulesTo": m12,
        "changedTheHistoryVisibility": m13,
        "changedTheHistoryVisibilityTo": m14,
        "changedTheJoinRules": m15,
        "changedTheJoinRulesTo": m16,
        "changedTheProfileAvatar": m17,
        "changedTheRoomAliases": m18,
        "changedTheRoomInvitationLink": m19,
        "changelog": MessageLookupByLibrary.simpleMessage("Changelog"),
        "changesHaveBeenSaved":
            MessageLookupByLibrary.simpleMessage("Changes have been saved"),
        "channelCorruptedDecryptError": MessageLookupByLibrary.simpleMessage(
            "The encryption has been corrupted"),
        "chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "chatDetails": MessageLookupByLibrary.simpleMessage("Chat details"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("Choose a strong password"),
        "chooseAUsername":
            MessageLookupByLibrary.simpleMessage("Choose a username"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Compare and make sure the following emoji match those of the other device:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Compare and make sure the following numbers match those of the other device:"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "connect": MessageLookupByLibrary.simpleMessage("Connect"),
        "connectionAttemptFailed":
            MessageLookupByLibrary.simpleMessage("Connection attempt failed"),
        "contactHasBeenInvitedToTheGroup": MessageLookupByLibrary.simpleMessage(
            "Contact has been invited to the group"),
        "contentViewer": MessageLookupByLibrary.simpleMessage("Content viewer"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Copied to clipboard"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar":
            MessageLookupByLibrary.simpleMessage("Could not set avatar"),
        "couldNotSetDisplayname":
            MessageLookupByLibrary.simpleMessage("Could not set displayname"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "createAccountNow":
            MessageLookupByLibrary.simpleMessage("Create account now"),
        "createNewGroup":
            MessageLookupByLibrary.simpleMessage("Create new group"),
        "createdTheChat": m22,
        "crossSigningDisabled":
            MessageLookupByLibrary.simpleMessage("Cross-Signing is disabled"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Cross-Signing is enabled"),
        "currentlyActive":
            MessageLookupByLibrary.simpleMessage("Currently active"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Dark"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "deactivateAccountWarning": MessageLookupByLibrary.simpleMessage(
            "This will deactivate your user account. This can not be undone! Are you sure?"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete account"),
        "deleteMessage": MessageLookupByLibrary.simpleMessage("Delete message"),
        "deny": MessageLookupByLibrary.simpleMessage("Deny"),
        "device": MessageLookupByLibrary.simpleMessage("Device"),
        "devices": MessageLookupByLibrary.simpleMessage("Devices"),
        "discardPicture":
            MessageLookupByLibrary.simpleMessage("Discard picture"),
        "displaynameHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "Displayname has been changed"),
        "donate": MessageLookupByLibrary.simpleMessage("Donate"),
        "downloadFile": MessageLookupByLibrary.simpleMessage("Download file"),
        "editDisplayname":
            MessageLookupByLibrary.simpleMessage("Edit displayname"),
        "editJitsiInstance":
            MessageLookupByLibrary.simpleMessage("Edit Jitsi instance"),
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Emote already exists!"),
        "emoteInvalid":
            MessageLookupByLibrary.simpleMessage("Invalid emote shortcode!"),
        "emoteSettings": MessageLookupByLibrary.simpleMessage("Emote Settings"),
        "emoteShortcode":
            MessageLookupByLibrary.simpleMessage("Emote shortcode"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "You need to pick an emote shortcode and an image!"),
        "emptyChat": MessageLookupByLibrary.simpleMessage("Empty chat"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "You won\'t be able to disable the encryption anymore. Are you sure?"),
        "encryption": MessageLookupByLibrary.simpleMessage("Encryption"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Encryption algorithm"),
        "encryptionNotEnabled":
            MessageLookupByLibrary.simpleMessage("Encryption is not enabled"),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "End-to-end encryption settings"),
        "endedTheCall": m26,
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("Enter a group name"),
        "enterAUsername":
            MessageLookupByLibrary.simpleMessage("Enter a username"),
        "enterYourHomeserver":
            MessageLookupByLibrary.simpleMessage("Enter your homeserver"),
        "fileName": MessageLookupByLibrary.simpleMessage("File name"),
        "fileSize": MessageLookupByLibrary.simpleMessage("File size"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("Forward"),
        "friday": MessageLookupByLibrary.simpleMessage("Friday"),
        "fromJoining": MessageLookupByLibrary.simpleMessage("From joining"),
        "fromTheInvitation":
            MessageLookupByLibrary.simpleMessage("From the invitation"),
        "group": MessageLookupByLibrary.simpleMessage("Group"),
        "groupDescription":
            MessageLookupByLibrary.simpleMessage("Group description"),
        "groupDescriptionHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "Group description has been changed"),
        "groupIsPublic":
            MessageLookupByLibrary.simpleMessage("Group is public"),
        "groupWith": m27,
        "guestsAreForbidden":
            MessageLookupByLibrary.simpleMessage("Guests are forbidden"),
        "guestsCanJoin":
            MessageLookupByLibrary.simpleMessage("Guests can join"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Help"),
        "homeserverIsNotCompatible": MessageLookupByLibrary.simpleMessage(
            "Homeserver is not compatible"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "identity": MessageLookupByLibrary.simpleMessage("Identity"),
        "ignoreListDescription": MessageLookupByLibrary.simpleMessage(
            "You can ignore users who are disturbing you. You won\'t be able to receive any messages or room invites from the users on your personal ignore list."),
        "ignoreUsername":
            MessageLookupByLibrary.simpleMessage("Ignore username"),
        "ignoredUsers": MessageLookupByLibrary.simpleMessage("Ignored users"),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Incorrect passphrase or recovery key"),
        "inviteContact": MessageLookupByLibrary.simpleMessage("Invite contact"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("Invited"),
        "invitedUser": m31,
        "invitedUsersOnly":
            MessageLookupByLibrary.simpleMessage("Invited users only"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Is the following device key correct?"),
        "isTyping": MessageLookupByLibrary.simpleMessage("is typing..."),
        "joinRoom": MessageLookupByLibrary.simpleMessage("Join room"),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage("Keys are cached"),
        "keysMissing": MessageLookupByLibrary.simpleMessage("Keys are missing"),
        "kickFromChat": MessageLookupByLibrary.simpleMessage("Kick from chat"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp": MessageLookupByLibrary.simpleMessage("Last seen IP"),
        "lastSeenLongTimeAgo":
            MessageLookupByLibrary.simpleMessage("Seen a long time ago"),
        "leave": MessageLookupByLibrary.simpleMessage("Leave"),
        "leftTheChat": MessageLookupByLibrary.simpleMessage("Left the chat"),
        "license": MessageLookupByLibrary.simpleMessage("License"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Light"),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage("Load more..."),
        "loadingPleaseWait":
            MessageLookupByLibrary.simpleMessage("Loading... Please wait"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "makeAModerator":
            MessageLookupByLibrary.simpleMessage("Make a moderator"),
        "makeAnAdmin": MessageLookupByLibrary.simpleMessage("Make an admin"),
        "makeSureTheIdentifierIsValid": MessageLookupByLibrary.simpleMessage(
            "Make sure the identifier is valid"),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "Message will be removed for all participants"),
        "moderator": MessageLookupByLibrary.simpleMessage("Moderator"),
        "monday": MessageLookupByLibrary.simpleMessage("Monday"),
        "muteChat": MessageLookupByLibrary.simpleMessage("Mute chat"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(
            "Please be aware that you need Pantalaimon to use end-to-end encryption for now."),
        "newMessageInFluffyChat":
            MessageLookupByLibrary.simpleMessage("New message in FluffyChat"),
        "newPrivateChat":
            MessageLookupByLibrary.simpleMessage("New private chat"),
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("New verification request!"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat currently does not support enabling Cross-Signing. Please enable it from within Riot."),
        "noEmotesFound":
            MessageLookupByLibrary.simpleMessage("No emotes found. 😕"),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat currently does not support enabling Online Key Backup. Please enable it from within Riot."),
        "noPermission": MessageLookupByLibrary.simpleMessage("No permission"),
        "noRoomsFound":
            MessageLookupByLibrary.simpleMessage("No rooms found..."),
        "none": MessageLookupByLibrary.simpleMessage("None"),
        "notSupportedInWeb":
            MessageLookupByLibrary.simpleMessage("Not supported in web"),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Online Key Backup is disabled"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Online Key Backup is enabled"),
        "oopsSomethingWentWrong": MessageLookupByLibrary.simpleMessage(
            "Oops something went wrong..."),
        "openAppToReadMessages":
            MessageLookupByLibrary.simpleMessage("Open app to read messages"),
        "openCamera": MessageLookupByLibrary.simpleMessage("Open camera"),
        "optionalGroupName":
            MessageLookupByLibrary.simpleMessage("(Optional) Group name"),
        "participatingUserDevices":
            MessageLookupByLibrary.simpleMessage("Participating user devices"),
        "passphraseOrKey":
            MessageLookupByLibrary.simpleMessage("passphrase or recovery key"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Password has been changed"),
        "pickImage": MessageLookupByLibrary.simpleMessage("Pick image"),
        "pin": MessageLookupByLibrary.simpleMessage("Pin"),
        "play": m39,
        "pleaseChooseAUsername":
            MessageLookupByLibrary.simpleMessage("Please choose a username"),
        "pleaseEnterAMatrixIdentifier": MessageLookupByLibrary.simpleMessage(
            "Please enter a matrix identifier"),
        "pleaseEnterYourPassword":
            MessageLookupByLibrary.simpleMessage("Please enter your password"),
        "pleaseEnterYourUsername":
            MessageLookupByLibrary.simpleMessage("Please enter your username"),
        "publicRooms": MessageLookupByLibrary.simpleMessage("Public Rooms"),
        "recording": MessageLookupByLibrary.simpleMessage("Recording"),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("Reject"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("Rejoin"),
        "remove": MessageLookupByLibrary.simpleMessage("Remove"),
        "removeAllOtherDevices":
            MessageLookupByLibrary.simpleMessage("Remove all other devices"),
        "removeDevice": MessageLookupByLibrary.simpleMessage("Remove device"),
        "removeExile": MessageLookupByLibrary.simpleMessage("Remove exile"),
        "removeMessage": MessageLookupByLibrary.simpleMessage("Remove message"),
        "removedBy": m42,
        "renderRichContent":
            MessageLookupByLibrary.simpleMessage("Render rich message content"),
        "reply": MessageLookupByLibrary.simpleMessage("Reply"),
        "requestPermission":
            MessageLookupByLibrary.simpleMessage("Request permission"),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(
            "Request to read older messages"),
        "revokeAllPermissions":
            MessageLookupByLibrary.simpleMessage("Revoke all permissions"),
        "roomHasBeenUpgraded":
            MessageLookupByLibrary.simpleMessage("Room has been upgraded"),
        "saturday": MessageLookupByLibrary.simpleMessage("Saturday"),
        "searchForAChat":
            MessageLookupByLibrary.simpleMessage("Search for a chat"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "sendAMessage": MessageLookupByLibrary.simpleMessage("Send a message"),
        "sendAudio": MessageLookupByLibrary.simpleMessage("Send audio"),
        "sendBugReports": MessageLookupByLibrary.simpleMessage(
            "Allow sending bug reports with sentry.io"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Send file"),
        "sendImage": MessageLookupByLibrary.simpleMessage("Send image"),
        "sendOriginal": MessageLookupByLibrary.simpleMessage("Send original"),
        "sendVideo": MessageLookupByLibrary.simpleMessage("Send video"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sentryInfo": MessageLookupByLibrary.simpleMessage(
            "Informations about your privacy: https://sentry.io/security/"),
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Session is verified"),
        "setAProfilePicture":
            MessageLookupByLibrary.simpleMessage("Set a profile picture"),
        "setGroupDescription":
            MessageLookupByLibrary.simpleMessage("Set group description"),
        "setInvitationLink":
            MessageLookupByLibrary.simpleMessage("Set invitation link"),
        "setStatus": MessageLookupByLibrary.simpleMessage("Set status"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("Sign up"),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Source code"),
        "startYourFirstChat":
            MessageLookupByLibrary.simpleMessage("Start your first chat :-)"),
        "startedACall": m53,
        "statusExampleMessage":
            MessageLookupByLibrary.simpleMessage("How are you today?"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "sunday": MessageLookupByLibrary.simpleMessage("Sunday"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("System"),
        "tapToShowMenu":
            MessageLookupByLibrary.simpleMessage("Tap to show menu"),
        "theyDontMatch":
            MessageLookupByLibrary.simpleMessage("They Don\'t Match"),
        "theyMatch": MessageLookupByLibrary.simpleMessage("They Match"),
        "thisRoomHasBeenArchived": MessageLookupByLibrary.simpleMessage(
            "This room has been archived."),
        "thursday": MessageLookupByLibrary.simpleMessage("Thursday"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain":
            MessageLookupByLibrary.simpleMessage("Try to send again"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Tuesday"),
        "unbannedUser": m55,
        "unblockDevice": MessageLookupByLibrary.simpleMessage("Unblock Device"),
        "unknownDevice": MessageLookupByLibrary.simpleMessage("Unknown device"),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(
            "Unknown encryption algorithm"),
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Unknown session, please verify"),
        "unmuteChat": MessageLookupByLibrary.simpleMessage("Unmute chat"),
        "unpin": MessageLookupByLibrary.simpleMessage("Unpin"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(
            "Use Amoled compatible colors?"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Successfully verified session!"),
        "verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "verifyManual": MessageLookupByLibrary.simpleMessage("Verify Manually"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Start Verification"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("You successfully verified!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Verifying other account"),
        "verifyUser": MessageLookupByLibrary.simpleMessage("Verify User"),
        "videoCall": MessageLookupByLibrary.simpleMessage("Video call"),
        "visibilityOfTheChatHistory": MessageLookupByLibrary.simpleMessage(
            "Visibility of the chat history"),
        "visibleForAllParticipants": MessageLookupByLibrary.simpleMessage(
            "Visible for all participants"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("Visible for everyone"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("Voice message"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Waiting for partner to accept the request..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Waiting for partner to accept the emoji..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Waiting for partner to accept the numbers..."),
        "wallpaper": MessageLookupByLibrary.simpleMessage("Wallpaper"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning!"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "End to end encryption is currently in Beta! Use at your own risk!"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Wednesday"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Welcome to the cutest instant messenger in the matrix network."),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(
            "Who is allowed to join this group"),
        "writeAMessage":
            MessageLookupByLibrary.simpleMessage("Write a message..."),
        "yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "you": MessageLookupByLibrary.simpleMessage("You"),
        "youAreInvitedToThisChat": MessageLookupByLibrary.simpleMessage(
            "You are invited to this chat"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(
                "You are no longer participating in this chat"),
        "youCannotInviteYourself":
            MessageLookupByLibrary.simpleMessage("You cannot invite yourself"),
        "youHaveBeenBannedFromThisChat": MessageLookupByLibrary.simpleMessage(
            "You have been banned from this chat"),
        "yourOwnUsername":
            MessageLookupByLibrary.simpleMessage("Your own username")
      };
}
