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

  static m2(username) => "Accept this verification request from ${username}?";

  static m3(username, targetName) => "${username} banned ${targetName}";

  static m4(homeserver) => "By default you will be connected to ${homeserver}";

  static m5(username) => "${username} changed the chat avatar";

  static m6(username, description) =>
      "${username} changed the chat description to: \'${description}\'";

  static m7(username, chatname) =>
      "${username} changed the chat name to: \'${chatname}\'";

  static m8(username) => "${username} changed the chat permissions";

  static m9(username, displayname) =>
      "${username} changed the displayname to: ${displayname}";

  static m10(username) => "${username} changed the guest access rules";

  static m11(username, rules) =>
      "${username} changed the guest access rules to: ${rules}";

  static m12(username) => "${username} changed the history visibility";

  static m13(username, rules) =>
      "${username} changed the history visibility to: ${rules}";

  static m14(username) => "${username} changed the join rules";

  static m15(username, joinRules) =>
      "${username} changed the join rules to: ${joinRules}";

  static m16(username) => "${username} changed their avatar";

  static m17(username) => "${username} changed the room aliases";

  static m18(username) => "${username} changed the invitation link";

  static m19(error) => "Could not decrypt message: ${error}";

  static m20(count) => "${count} participants";

  static m21(username) => "${username} created the chat";

  static m22(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m23(year, month, day) => "${year}-${month}-${day}";

  static m24(month, day) => "${month}-${day}";

  static m25(displayname) => "Group with ${displayname}";

  static m26(username, targetName) =>
      "${username} has withdrawn the invitation for ${targetName}";

  static m27(groupName) => "Invite contact to ${groupName}";

  static m28(username, link) =>
      "${username} invited you to FluffyChat. \n1. Install FluffyChat: http://fluffy.chat \n2. Sign up or sign in \n3. Open the invite link: ${link}";

  static m29(username, targetName) => "${username} invited ${targetName}";

  static m30(username) => "${username} joined the chat";

  static m31(username, targetName) => "${username} kicked ${targetName}";

  static m32(username, targetName) =>
      "${username} kicked and banned ${targetName}";

  static m33(localizedTimeShort) => "Last active: ${localizedTimeShort}";

  static m34(count) => "Load ${count} more participants";

  static m35(homeserver) => "Log in to ${homeserver}";

  static m36(number) => "${number} selected";

  static m37(fileName) => "Play ${fileName}";

  static m38(username) => "${username} redacted an event";

  static m39(username) => "${username} rejected the invitation";

  static m40(username) => "Removed by ${username}";

  static m41(username) => "Seen by ${username}";

  static m42(username, count) => "Seen by ${username} and ${count} others";

  static m43(username, username2) => "Seen by ${username} and ${username2}";

  static m44(username) => "${username} sent a file";

  static m45(username) => "${username} sent a picture";

  static m46(username) => "${username} sent a sticker";

  static m47(username) => "${username} sent a video";

  static m48(username) => "${username} sent an audio";

  static m49(username) => "${username} shared the location";

  static m50(hours12, hours24, minutes, suffix) =>
      "${hours12}:${minutes} ${suffix}";

  static m51(username, targetName) => "${username} unbanned ${targetName}";

  static m52(type) => "Unknown event \'${type}\'";

  static m53(unreadCount) => "${unreadCount} unread chats";

  static m54(unreadEvents) => "${unreadEvents} unread messages";

  static m55(unreadEvents, unreadChats) =>
      "${unreadEvents} unread messages in ${unreadChats} chats";

  static m56(username, count) =>
      "${username} and ${count} others are typing...";

  static m57(username, username2) =>
      "${username} and ${username2} are typing...";

  static m58(username) => "${username} is typing...";

  static m59(username) => "${username} left the chat";

  static m60(username, type) => "${username} sent a ${type} event";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "(Optional) Group name":
            MessageLookupByLibrary.simpleMessage("(Optional) Group name"),
        "About": MessageLookupByLibrary.simpleMessage("About"),
        "Accept": MessageLookupByLibrary.simpleMessage("Accept"),
        "Account": MessageLookupByLibrary.simpleMessage("Account"),
        "Account informations":
            MessageLookupByLibrary.simpleMessage("Account informations"),
        "Add a group description":
            MessageLookupByLibrary.simpleMessage("Add a group description"),
        "Admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("Already have an account?"),
        "Anyone can join":
            MessageLookupByLibrary.simpleMessage("Anyone can join"),
        "Archive": MessageLookupByLibrary.simpleMessage("Archive"),
        "Archived Room": MessageLookupByLibrary.simpleMessage("Archived Room"),
        "Are guest users allowed to join": MessageLookupByLibrary.simpleMessage(
            "Are guest users allowed to join"),
        "Are you sure?": MessageLookupByLibrary.simpleMessage("Are you sure?"),
        "Authentication":
            MessageLookupByLibrary.simpleMessage("Authentication"),
        "Avatar has been changed":
            MessageLookupByLibrary.simpleMessage("Avatar has been changed"),
        "Ban from chat": MessageLookupByLibrary.simpleMessage("Ban from chat"),
        "Banned": MessageLookupByLibrary.simpleMessage("Banned"),
        "Block Device": MessageLookupByLibrary.simpleMessage("Block Device"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "Change the homeserver":
            MessageLookupByLibrary.simpleMessage("Change the homeserver"),
        "Change the name of the group": MessageLookupByLibrary.simpleMessage(
            "Change the name of the group"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Change the server"),
        "Change wallpaper":
            MessageLookupByLibrary.simpleMessage("Change wallpaper"),
        "Change your style":
            MessageLookupByLibrary.simpleMessage("Change your style"),
        "Changelog": MessageLookupByLibrary.simpleMessage("Changelog"),
        "Chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "Chat details": MessageLookupByLibrary.simpleMessage("Chat details"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("Choose a strong password"),
        "Choose a username":
            MessageLookupByLibrary.simpleMessage("Choose a username"),
        "Close": MessageLookupByLibrary.simpleMessage("Close"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "Connect": MessageLookupByLibrary.simpleMessage("Connect"),
        "Connection attempt failed":
            MessageLookupByLibrary.simpleMessage("Connection attempt failed"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage(
                "Contact has been invited to the group"),
        "Content viewer":
            MessageLookupByLibrary.simpleMessage("Content viewer"),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("Copied to clipboard"),
        "Copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "Could not set avatar":
            MessageLookupByLibrary.simpleMessage("Could not set avatar"),
        "Could not set displayname":
            MessageLookupByLibrary.simpleMessage("Could not set displayname"),
        "Create": MessageLookupByLibrary.simpleMessage("Create"),
        "Create account now":
            MessageLookupByLibrary.simpleMessage("Create account now"),
        "Create new group":
            MessageLookupByLibrary.simpleMessage("Create new group"),
        "Currently active":
            MessageLookupByLibrary.simpleMessage("Currently active"),
        "Dark": MessageLookupByLibrary.simpleMessage("Dark"),
        "Delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "Delete message":
            MessageLookupByLibrary.simpleMessage("Delete message"),
        "Deny": MessageLookupByLibrary.simpleMessage("Deny"),
        "Device": MessageLookupByLibrary.simpleMessage("Device"),
        "Devices": MessageLookupByLibrary.simpleMessage("Devices"),
        "Discard picture":
            MessageLookupByLibrary.simpleMessage("Discard picture"),
        "Displayname has been changed": MessageLookupByLibrary.simpleMessage(
            "Displayname has been changed"),
        "Donate": MessageLookupByLibrary.simpleMessage("Donate"),
        "Download file": MessageLookupByLibrary.simpleMessage("Download file"),
        "Edit Jitsi instance":
            MessageLookupByLibrary.simpleMessage("Edit Jitsi instance"),
        "Edit displayname":
            MessageLookupByLibrary.simpleMessage("Edit displayname"),
        "Emote Settings":
            MessageLookupByLibrary.simpleMessage("Emote Settings"),
        "Emote shortcode":
            MessageLookupByLibrary.simpleMessage("Emote shortcode"),
        "Empty chat": MessageLookupByLibrary.simpleMessage("Empty chat"),
        "Encryption": MessageLookupByLibrary.simpleMessage("Encryption"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Encryption algorithm"),
        "Encryption is not enabled":
            MessageLookupByLibrary.simpleMessage("Encryption is not enabled"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "End to end encryption is currently in Beta! Use at your own risk!"),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "End-to-end encryption settings"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("Enter a group name"),
        "Enter a username":
            MessageLookupByLibrary.simpleMessage("Enter a username"),
        "Enter your homeserver":
            MessageLookupByLibrary.simpleMessage("Enter your homeserver"),
        "File name": MessageLookupByLibrary.simpleMessage("File name"),
        "File size": MessageLookupByLibrary.simpleMessage("File size"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("Forward"),
        "Friday": MessageLookupByLibrary.simpleMessage("Friday"),
        "From joining": MessageLookupByLibrary.simpleMessage("From joining"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("From the invitation"),
        "Group": MessageLookupByLibrary.simpleMessage("Group"),
        "Group description":
            MessageLookupByLibrary.simpleMessage("Group description"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage(
                "Group description has been changed"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("Group is public"),
        "Guests are forbidden":
            MessageLookupByLibrary.simpleMessage("Guests are forbidden"),
        "Guests can join":
            MessageLookupByLibrary.simpleMessage("Guests can join"),
        "Help": MessageLookupByLibrary.simpleMessage("Help"),
        "Homeserver is not compatible": MessageLookupByLibrary.simpleMessage(
            "Homeserver is not compatible"),
        "How are you today?":
            MessageLookupByLibrary.simpleMessage("How are you today?"),
        "ID": MessageLookupByLibrary.simpleMessage("ID"),
        "Identity": MessageLookupByLibrary.simpleMessage("Identity"),
        "Invite contact":
            MessageLookupByLibrary.simpleMessage("Invite contact"),
        "Invited": MessageLookupByLibrary.simpleMessage("Invited"),
        "Invited users only":
            MessageLookupByLibrary.simpleMessage("Invited users only"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(
                "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/"),
        "Kick from chat":
            MessageLookupByLibrary.simpleMessage("Kick from chat"),
        "Last seen IP": MessageLookupByLibrary.simpleMessage("Last seen IP"),
        "Leave": MessageLookupByLibrary.simpleMessage("Leave"),
        "Left the chat": MessageLookupByLibrary.simpleMessage("Left the chat"),
        "License": MessageLookupByLibrary.simpleMessage("License"),
        "Light": MessageLookupByLibrary.simpleMessage("Light"),
        "Load more...": MessageLookupByLibrary.simpleMessage("Load more..."),
        "Loading... Please wait":
            MessageLookupByLibrary.simpleMessage("Loading... Please wait"),
        "Login": MessageLookupByLibrary.simpleMessage("Login"),
        "Logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "Make a moderator":
            MessageLookupByLibrary.simpleMessage("Make a moderator"),
        "Make an admin": MessageLookupByLibrary.simpleMessage("Make an admin"),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(
                "Make sure the identifier is valid"),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(
                "Message will be removed for all participants"),
        "Moderator": MessageLookupByLibrary.simpleMessage("Moderator"),
        "Monday": MessageLookupByLibrary.simpleMessage("Monday"),
        "Mute chat": MessageLookupByLibrary.simpleMessage("Mute chat"),
        "New message in FluffyChat":
            MessageLookupByLibrary.simpleMessage("New message in FluffyChat"),
        "New private chat":
            MessageLookupByLibrary.simpleMessage("New private chat"),
        "No emotes found. 😕":
            MessageLookupByLibrary.simpleMessage("No emotes found. 😕"),
        "No permission": MessageLookupByLibrary.simpleMessage("No permission"),
        "No rooms found...":
            MessageLookupByLibrary.simpleMessage("No rooms found..."),
        "None": MessageLookupByLibrary.simpleMessage("None"),
        "Not supported in web":
            MessageLookupByLibrary.simpleMessage("Not supported in web"),
        "Oops something went wrong...": MessageLookupByLibrary.simpleMessage(
            "Oops something went wrong..."),
        "Open app to read messages":
            MessageLookupByLibrary.simpleMessage("Open app to read messages"),
        "Open camera": MessageLookupByLibrary.simpleMessage("Open camera"),
        "Participating user devices":
            MessageLookupByLibrary.simpleMessage("Participating user devices"),
        "Password": MessageLookupByLibrary.simpleMessage("Password"),
        "Pick image": MessageLookupByLibrary.simpleMessage("Pick image"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(
                "Please be aware that you need Pantalaimon to use end-to-end encryption for now."),
        "Please choose a username":
            MessageLookupByLibrary.simpleMessage("Please choose a username"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage(
                "Please enter a matrix identifier"),
        "Please enter your password":
            MessageLookupByLibrary.simpleMessage("Please enter your password"),
        "Please enter your username":
            MessageLookupByLibrary.simpleMessage("Please enter your username"),
        "Public Rooms": MessageLookupByLibrary.simpleMessage("Public Rooms"),
        "Recording": MessageLookupByLibrary.simpleMessage("Recording"),
        "Reject": MessageLookupByLibrary.simpleMessage("Reject"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Rejoin"),
        "Remove": MessageLookupByLibrary.simpleMessage("Remove"),
        "Remove all other devices":
            MessageLookupByLibrary.simpleMessage("Remove all other devices"),
        "Remove device": MessageLookupByLibrary.simpleMessage("Remove device"),
        "Remove exile": MessageLookupByLibrary.simpleMessage("Remove exile"),
        "Remove message":
            MessageLookupByLibrary.simpleMessage("Remove message"),
        "Render rich message content":
            MessageLookupByLibrary.simpleMessage("Render rich message content"),
        "Reply": MessageLookupByLibrary.simpleMessage("Reply"),
        "Request permission":
            MessageLookupByLibrary.simpleMessage("Request permission"),
        "Request to read older messages": MessageLookupByLibrary.simpleMessage(
            "Request to read older messages"),
        "Revoke all permissions":
            MessageLookupByLibrary.simpleMessage("Revoke all permissions"),
        "Room has been upgraded":
            MessageLookupByLibrary.simpleMessage("Room has been upgraded"),
        "Saturday": MessageLookupByLibrary.simpleMessage("Saturday"),
        "Search for a chat":
            MessageLookupByLibrary.simpleMessage("Search for a chat"),
        "Seen a long time ago":
            MessageLookupByLibrary.simpleMessage("Seen a long time ago"),
        "Send": MessageLookupByLibrary.simpleMessage("Send"),
        "Send a message":
            MessageLookupByLibrary.simpleMessage("Send a message"),
        "Send file": MessageLookupByLibrary.simpleMessage("Send file"),
        "Send image": MessageLookupByLibrary.simpleMessage("Send image"),
        "Set a profile picture":
            MessageLookupByLibrary.simpleMessage("Set a profile picture"),
        "Set group description":
            MessageLookupByLibrary.simpleMessage("Set group description"),
        "Set invitation link":
            MessageLookupByLibrary.simpleMessage("Set invitation link"),
        "Set status": MessageLookupByLibrary.simpleMessage("Set status"),
        "Settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "Share": MessageLookupByLibrary.simpleMessage("Share"),
        "Sign up": MessageLookupByLibrary.simpleMessage("Sign up"),
        "Skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "Source code": MessageLookupByLibrary.simpleMessage("Source code"),
        "Start your first chat :-)":
            MessageLookupByLibrary.simpleMessage("Start your first chat :-)"),
        "Submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Sunday"),
        "System": MessageLookupByLibrary.simpleMessage("System"),
        "Tap to show menu":
            MessageLookupByLibrary.simpleMessage("Tap to show menu"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage(
                "The encryption has been corrupted"),
        "They Don\'t Match":
            MessageLookupByLibrary.simpleMessage("They Don\'t Match"),
        "They Match": MessageLookupByLibrary.simpleMessage("They Match"),
        "This room has been archived.": MessageLookupByLibrary.simpleMessage(
            "This room has been archived."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Thursday"),
        "Try to send again":
            MessageLookupByLibrary.simpleMessage("Try to send again"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("Tuesday"),
        "Unblock Device":
            MessageLookupByLibrary.simpleMessage("Unblock Device"),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Unknown device"),
        "Unknown encryption algorithm": MessageLookupByLibrary.simpleMessage(
            "Unknown encryption algorithm"),
        "Unmute chat": MessageLookupByLibrary.simpleMessage("Unmute chat"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "Use Amoled compatible colors?"),
        "Username": MessageLookupByLibrary.simpleMessage("Username"),
        "Verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "Verify User": MessageLookupByLibrary.simpleMessage("Verify User"),
        "Video call": MessageLookupByLibrary.simpleMessage("Video call"),
        "Visibility of the chat history": MessageLookupByLibrary.simpleMessage(
            "Visibility of the chat history"),
        "Visible for all participants": MessageLookupByLibrary.simpleMessage(
            "Visible for all participants"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("Visible for everyone"),
        "Voice message": MessageLookupByLibrary.simpleMessage("Voice message"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("Wallpaper"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("Wednesday"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "Welcome to the cutest instant messenger in the Matrix network."),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage(
                "Who is allowed to join this group"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("Write a message..."),
        "Yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "You": MessageLookupByLibrary.simpleMessage("You"),
        "You are invited to this chat": MessageLookupByLibrary.simpleMessage(
            "You are invited to this chat"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(
                "You are no longer participating in this chat"),
        "You cannot invite yourself":
            MessageLookupByLibrary.simpleMessage("You cannot invite yourself"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage(
                "You have been banned from this chat"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "You won\'t be able to disable the encryption anymore. Are you sure?"),
        "Your own username":
            MessageLookupByLibrary.simpleMessage("Your own username"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Please enter your secure store passphrase or recovery key to cache the keys."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "To be able to sign the other person, please enter your secure store passphrase or recovery key."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Please enter your secure store passphrase or recovery key to verify your session."),
        "askVerificationRequest": m2,
        "bannedUser": m3,
        "byDefaultYouWillBeConnectedTo": m4,
        "cachedKeys":
            MessageLookupByLibrary.simpleMessage("Successfully cached keys!"),
        "changedTheChatAvatar": m5,
        "changedTheChatDescriptionTo": m6,
        "changedTheChatNameTo": m7,
        "changedTheChatPermissions": m8,
        "changedTheDisplaynameTo": m9,
        "changedTheGuestAccessRules": m10,
        "changedTheGuestAccessRulesTo": m11,
        "changedTheHistoryVisibility": m12,
        "changedTheHistoryVisibilityTo": m13,
        "changedTheJoinRules": m14,
        "changedTheJoinRulesTo": m15,
        "changedTheProfileAvatar": m16,
        "changedTheRoomAliases": m17,
        "changedTheRoomInvitationLink": m18,
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Compare and make sure the following emoji match those of the other device:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Compare and make sure the following numbers match those of the other device:"),
        "couldNotDecryptMessage": m19,
        "countParticipants": m20,
        "createdTheChat": m21,
        "crossSigningDisabled":
            MessageLookupByLibrary.simpleMessage("Cross-Signing is disabled"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Cross-Signing is enabled"),
        "dateAndTimeOfDay": m22,
        "dateWithYear": m23,
        "dateWithoutYear": m24,
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Emote already exists!"),
        "emoteInvalid":
            MessageLookupByLibrary.simpleMessage("Invalid emote shortcode!"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "You need to pick an emote shortcode and an image!"),
        "groupWith": m25,
        "hasWithdrawnTheInvitationFor": m26,
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Incorrect passphrase or recovery key"),
        "inviteContactToGroup": m27,
        "inviteText": m28,
        "invitedUser": m29,
        "is typing...": MessageLookupByLibrary.simpleMessage("is typing..."),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Is the following device key correct?"),
        "joinedTheChat": m30,
        "keysCached": MessageLookupByLibrary.simpleMessage("Keys are cached"),
        "keysMissing": MessageLookupByLibrary.simpleMessage("Keys are missing"),
        "kicked": m31,
        "kickedAndBanned": m32,
        "lastActiveAgo": m33,
        "loadCountMoreParticipants": m34,
        "logInTo": m35,
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("New verification request!"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat currently does not support enabling Cross-Signing. Please enable it from within Element."),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat currently does not support enabling Online Key Backup. Please enable it from within Element."),
        "numberSelected": m36,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Online Key Backup is disabled"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Online Key Backup is enabled"),
        "passphraseOrKey":
            MessageLookupByLibrary.simpleMessage("passphrase or recovery key"),
        "play": m37,
        "redactedAnEvent": m38,
        "rejectedTheInvitation": m39,
        "removedBy": m40,
        "seenByUser": m41,
        "seenByUserAndCountOthers": m42,
        "seenByUserAndUser": m43,
        "sentAFile": m44,
        "sentAPicture": m45,
        "sentASticker": m46,
        "sentAVideo": m47,
        "sentAnAudio": m48,
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Session is verified"),
        "sharedTheLocation": m49,
        "timeOfDay": m50,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m51,
        "unknownEvent": m52,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Unknown session, please verify"),
        "unreadChats": m53,
        "unreadMessages": m54,
        "unreadMessagesInChats": m55,
        "userAndOthersAreTyping": m56,
        "userAndUserAreTyping": m57,
        "userIsTyping": m58,
        "userLeftTheChat": m59,
        "userSentUnknownEvent": m60,
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Successfully verified session!"),
        "verifyManual": MessageLookupByLibrary.simpleMessage("Verify Manually"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Start Verification"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("You successfully verified!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Verifying other account"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Waiting for partner to accept the request..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Waiting for partner to accept the emoji..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Waiting for partner to accept the numbers...")
      };
}
