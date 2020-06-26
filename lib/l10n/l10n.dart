import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<L10n> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'de', 'hu', 'pl', 'fr', 'cs', 'es', 'sk']
        .contains(locale.languageCode);
  }

  @override
  Future<L10n> load(Locale locale) {
    return L10n.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<L10n> old) {
    return false;
  }
}

class L10n extends MatrixLocalizations {
  L10n(this.localeName);

  static Future<L10n> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return L10n(localeName);
    });
  }

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  final String localeName;

  /* <=============> Translations <=============> */

  String get about => Intl.message("About");

  String get accept => Intl.message("Accept");

  String acceptedTheInvitation(String username) => Intl.message(
        "$username accepted the invitation",
        name: "acceptedTheInvitation",
        args: [username],
      );

  String get account => Intl.message("Account");

  String get accountInformations => Intl.message("Account informations");

  String activatedEndToEndEncryption(String username) => Intl.message(
        "$username activated end to end encryption",
        name: "activatedEndToEndEncryption",
        args: [username],
      );

  String get addGroupDescription => Intl.message("Add a group description");

  String get admin => Intl.message("Admin");

  String get alias => Intl.message("alias");

  String get alreadyHaveAnAccount => Intl.message("Already have an account?");

  String get anyoneCanJoin => Intl.message("Anyone can join");

  String get archive => Intl.message("Archive");

  String get archivedRoom => Intl.message("Archived Room");

  String get areGuestsAllowedToJoin =>
      Intl.message("Are guest users allowed to join");

  String get areYouSure => Intl.message("Are you sure?");

  String get askSSSSCache => Intl.message(
      "Please enter your secure store passphrase or recovery key to cache the keys.",
      name: "askSSSSCache");

  String get askSSSSSign => Intl.message(
      "To be able to sign the other person, please enter your secure store passphrase or recovery key.",
      name: "askSSSSSign");

  String get askSSSSVerify => Intl.message(
      "Please enter your secure store passphrase or recovery key to verify your session.",
      name: "askSSSSVerify");

  String askVerificationRequest(String username) =>
      Intl.message("Accept this verification request from $username?",
          name: "askVerificationRequest", args: [username]);

  String get authentication => Intl.message("Authentication");

  String get avatarHasBeenChanged => Intl.message("Avatar has been changed");

  String get banFromChat => Intl.message("Ban from chat");

  String get banned => Intl.message("Banned");

  String bannedUser(String username, String targetName) => Intl.message(
        "$username banned $targetName",
        name: "bannedUser",
        args: [username, targetName],
      );

  String get blockDevice => Intl.message("Block Device");

  String byDefaultYouWillBeConnectedTo(String homeserver) => Intl.message(
        'By default you will be connected to $homeserver',
        name: 'byDefaultYouWillBeConnectedTo',
        args: [homeserver],
      );

  String get cachedKeys =>
      Intl.message("Successfully cached keys!", name: "cachedKeys");

  String get cancel => Intl.message("Cancel");

  String changedTheChatAvatar(String username) => Intl.message(
        "$username changed the chat avatar",
        name: "changedTheChatAvatar",
        args: [username],
      );

  String changedTheChatNameTo(String username, String chatname) => Intl.message(
        "$username changed the chat name to: '$chatname'",
        name: "changedTheChatNameTo",
        args: [username, chatname],
      );

  String changedTheChatDescriptionTo(String username, String description) =>
      Intl.message(
        "$username changed the chat description to: '$description'",
        name: "changedTheChatDescriptionTo",
        args: [username, description],
      );

  String changedTheChatPermissions(String username) => Intl.message(
        "$username changed the chat permissions",
        name: "changedTheChatPermissions",
        args: [username],
      );

  String changedTheDisplaynameTo(String username, String displayname) =>
      Intl.message(
        "$username changed the displayname to: $displayname",
        name: "changedTheDisplaynameTo",
        args: [username, displayname],
      );

  String get changeTheHomeserver => Intl.message('Change the homeserver');

  String changedTheGuestAccessRules(String username) => Intl.message(
        "$username changed the guest access rules",
        name: "changedTheGuestAccessRules",
        args: [username],
      );

  String changedTheGuestAccessRulesTo(String username, String rules) =>
      Intl.message(
        "$username changed the guest access rules to: $rules",
        name: "changedTheGuestAccessRulesTo",
        args: [username, rules],
      );

  String changedTheHistoryVisibility(String username) => Intl.message(
        "$username changed the history visibility",
        name: "changedTheHistoryVisibility",
        args: [username],
      );

  String changedTheHistoryVisibilityTo(String username, String rules) =>
      Intl.message(
        "$username changed the history visibility to: $rules",
        name: "changedTheHistoryVisibilityTo",
        args: [username, rules],
      );

  String changedTheJoinRules(String username) => Intl.message(
        "$username changed the join rules",
        name: "changedTheJoinRules",
        args: [username],
      );

  String changedTheJoinRulesTo(String username, String joinRules) =>
      Intl.message(
        "$username changed the join rules to: $joinRules",
        name: "changedTheJoinRulesTo",
        args: [username, joinRules],
      );

  String changedTheProfileAvatar(String username) => Intl.message(
        "$username changed the profile avatar",
        name: "changedTheProfileAvatar",
        args: [username],
      );

  String changedTheRoomAliases(String username) => Intl.message(
        "$username changed the room aliases",
        name: "changedTheRoomAliases",
        args: [username],
      );

  String changedTheRoomInvitationLink(String username) => Intl.message(
        "$username changed the invitation link",
        name: "changedTheRoomInvitationLink",
        args: [username],
      );

  String get changelog => Intl.message("Changelog");

  String get changeTheNameOfTheGroup =>
      Intl.message("Change the name of the group");

  String get changeWallpaper => Intl.message("Change wallpaper");

  String get changeTheServer => Intl.message("Change the server");

  String get channelCorruptedDecryptError =>
      Intl.message("The encryption has been corrupted");

  String get chat => Intl.message('Chat');

  String get chatDetails => Intl.message('Chat details');

  String get chooseAStrongPassword => Intl.message("Choose a strong password");

  String get chooseAUsername => Intl.message("Choose a username");

  String get close => Intl.message("Close");

  String get compareEmojiMatch => Intl.message(
      "Compare and make sure the following emoji match those of the other device:",
      name: "compareEmojiMatch");

  String get compareNumbersMatch => Intl.message(
      "Compare and make sure the following numbers match those of the other device:",
      name: "compareNumbersMatch");

  String get confirm => Intl.message("Confirm");

  String get connect => Intl.message('Connect');

  String get connectionAttemptFailed =>
      Intl.message("Connection attempt failed");

  String get contactHasBeenInvitedToTheGroup =>
      Intl.message("Contact has been invited to the group");

  String get contentViewer => Intl.message("Content viewer");

  String get copiedToClipboard => Intl.message("Copied to clipboard");

  String get copy => Intl.message("Copy");

  String couldNotDecryptMessage(String error) => Intl.message(
        "Could not decrypt message: $error",
        name: "couldNotDecryptMessage",
        args: [error],
      );

  String get couldNotSetAvatar => Intl.message("Could not set avatar");

  String get couldNotSetDisplayname =>
      Intl.message("Could not set displayname");

  String countParticipants(String count) => Intl.message(
        "$count participants",
        name: "countParticipants",
        args: [count],
      );

  String get create => Intl.message("Create");

  String get createAccountNow => Intl.message("Create account now");

  String createdTheChat(String username) => Intl.message(
        "$username created the chat",
        name: "createdTheChat",
        args: [username],
      );

  String get createNewGroup => Intl.message("Create new group");

  String get crossSigningDisabled =>
      Intl.message("Cross-Signing is disabled", name: "crossSigningDisabled");

  String get crossSigningEnabled =>
      Intl.message("Cross-Signing is enabled", name: "crossSigningEnabled");

  String get currentlyActive => Intl.message('Currently active');

  String dateAndTimeOfDay(String date, String timeOfDay) => Intl.message(
        "$date, $timeOfDay",
        name: "dateAndTimeOfDay",
        args: [date, timeOfDay],
      );

  String dateWithoutYear(String month, String day) => Intl.message(
        "$month-$day",
        name: "dateWithoutYear",
        args: [month, day],
      );

  String dateWithYear(String year, String month, String day) => Intl.message(
        "$year-$month-$day",
        name: "dateWithYear",
        args: [year, month, day],
      );

  String get delete => Intl.message("Delete");

  String get deleteMessage => Intl.message("Delete message");

  String get deny => Intl.message("Deny");

  String get device => Intl.message("Device");

  String get devices => Intl.message("Devices");

  String get discardPicture => Intl.message("Discard picture");

  String get displaynameHasBeenChanged =>
      Intl.message("Displayname has been changed");

  String get downloadFile => Intl.message("Download file");

  String get editDisplayname => Intl.message("Edit displayname");

  String get emoteSettings => Intl.message('Emote Settings');

  String get emoteShortcode => Intl.message('Emote shortcode');

  String get emoteWarnNeedToPick =>
      Intl.message('You need to pick an emote shortcode and an image!',
          name: 'emoteWarnNeedToPick');

  String get emoteExists =>
      Intl.message('Emote already exists!', name: 'emoteExists');

  String get emoteInvalid =>
      Intl.message('Invalid emote shortcode!', name: 'emoteInvalid');

  String get emptyChat => Intl.message("Empty chat");

  String get enableEncryptionWarning => Intl.message(
      "You won't be able to disable the encryption anymore. Are you sure?");

  String get encryption => Intl.message("Encryption");

  String get encryptionAlgorithm => Intl.message("Encryption algorithm");

  String get encryptionNotEnabled => Intl.message("Encryption is not enabled");

  String get end2endEncryptionSettings =>
      Intl.message("End-to-end encryption settings");

  String get enterAGroupName => Intl.message("Enter a group name");

  String get enterAUsername => Intl.message("Enter a username");

  String get enterYourHomeserver => Intl.message('Enter your homeserver');

  String get fileName => Intl.message("File name");

  String get fileSize => Intl.message("File size");

  String get fluffychat => Intl.message("FluffyChat");

  String get forward => Intl.message('Forward');

  String get friday => Intl.message("Friday");

  String get fromJoining => Intl.message("From joining");

  String get fromTheInvitation => Intl.message("From the invitation");

  String get group => Intl.message("Group");

  String get groupDescription => Intl.message("Group description");

  String get groupDescriptionHasBeenChanged =>
      Intl.message("Group description has been changed");

  String get groupIsPublic => Intl.message("Group is public");

  String groupWith(String displayname) => Intl.message(
        "Group with $displayname",
        name: "groupWith",
        args: [displayname],
      );

  String get guestsAreForbidden => Intl.message("Guests are forbidden");

  String get guestsCanJoin => Intl.message("Guests can join");

  String hasWithdrawnTheInvitationFor(String username, String targetName) =>
      Intl.message(
        "$username has withdrawn the invitation for $targetName",
        name: "hasWithdrawnTheInvitationFor",
        args: [username, targetName],
      );

  String get help => Intl.message("Help");

  String get homeserverIsNotCompatible =>
      Intl.message("Homeserver is not compatible");

  String get id => Intl.message("ID");

  String get identity => Intl.message("Identity");

  String get incorrectPassphraseOrKey =>
      Intl.message("Incorrect passphrase or recovery key",
          name: "incorrectPassphraseOrKey");

  String get inviteContact => Intl.message("Invite contact");

  String inviteContactToGroup(String groupName) => Intl.message(
        "Invite contact to $groupName",
        name: "inviteContactToGroup",
        args: [groupName],
      );

  String get invited => Intl.message("Invited");

  String inviteText(String username, String link) => Intl.message(
        "$username invited you to FluffyChat. \n1. Install FluffyChat: http://fluffy.chat \n2. Sign up or sign in \n3. Open the invite link: $link",
        name: "inviteText",
        args: [username, link],
      );

  String invitedUser(String username, String targetName) => Intl.message(
        "$username invited $targetName",
        name: "invitedUser",
        args: [username, targetName],
      );

  String get invitedUsersOnly => Intl.message("Invited users only");

  String get isDeviceKeyCorrect =>
      Intl.message("Is the following device key correct?",
          name: "isDeviceKeyCorrect");

  String get isTyping => Intl.message("is typing...");

  String get editJitsiInstance => Intl.message('Edit Jitsi instance');

  String joinedTheChat(String username) => Intl.message(
        "$username joined the chat",
        name: "joinedTheChat",
        args: [username],
      );

  String get keysCached => Intl.message("Keys are cached", name: "keysCached");

  String get keysMissing =>
      Intl.message("Keys are missing", name: "keysMissing");

  String kicked(String username, String targetName) => Intl.message(
        "$username kicked $targetName",
        name: "kicked",
        args: [username, targetName],
      );

  String kickedAndBanned(String username, String targetName) => Intl.message(
        "$username kicked and banned $targetName",
        name: "kickedAndBanned",
        args: [username, targetName],
      );

  String get kickFromChat => Intl.message("Kick from chat");

  String get leave => Intl.message('Leave');

  String get leftTheChat => Intl.message("Left the chat");

  String get logout => Intl.message("Logout");

  String userLeftTheChat(String username) => Intl.message(
        "$username left the chat",
        name: "userLeftTheChat",
        args: [username],
      );

  String lastActiveAgo(String localizedTimeShort) => Intl.message(
        "Last active: $localizedTimeShort",
        name: "lastActiveAgo",
        args: [localizedTimeShort],
      );

  String get lastSeenIp => Intl.message("Last seen IP");

  String get license => Intl.message("License");

  String get loadingPleaseWait => Intl.message("Loading... Please wait");

  String get loadMore => Intl.message('Load more...');

  String loadCountMoreParticipants(String count) => Intl.message(
        "Load $count more participants",
        name: "loadCountMoreParticipants",
        args: [count],
      );

  String get login => Intl.message("Login");

  String logInTo(String homeserver) => Intl.message(
        'Log in to $homeserver',
        name: 'logInTo',
        args: [homeserver],
      );

  String get makeAModerator => Intl.message("Make a moderator");

  String get makeAnAdmin => Intl.message("Make an admin");

  String get makeSureTheIdentifierIsValid =>
      Intl.message("Make sure the identifier is valid");

  String get messageWillBeRemovedWarning =>
      Intl.message("Message will be removed for all participants");

  String get moderator => Intl.message("Moderator");

  String get monday => Intl.message("Monday");

  String get muteChat => Intl.message('Mute chat');

  String get needPantalaimonWarning => Intl.message(
      "Please be aware that you need Pantalaimon to use end-to-end encryption for now.");

  String get newMessageInFluffyChat =>
      Intl.message('New message in FluffyChat');

  String get newPrivateChat => Intl.message("New private chat");

  String get newVerificationRequest =>
      Intl.message("New verification request!", name: "newVerificationRequest");

  String get noCrossSignBootstrap => Intl.message(
      "Fluffychat currently does not support enabling Cross-Signing. Please enable it from within Riot.",
      name: "noCrossSignBootstrap");

  String get noMegolmBootstrap => Intl.message(
      "Fluffychat currently does not support enabling Online Key Backup. Please enable it from within Riot.",
      name: "noMegolmBootstrap");

  String get noGoogleServicesWarning => Intl.message(
      "It seems that you have no google services on your phone. That's a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/");

  String get none => Intl.message("None");

  String get noEmotesFound => Intl.message('No emotes found. 😕');

  String get noPermission => Intl.message("No permission");

  String get noRoomsFound => Intl.message("No rooms found...");

  String get notSupportedInWeb => Intl.message("Not supported in web");

  String numberSelected(String number) =>
      Intl.message("$number selected", name: "numberSelected", args: [number]);

  String get ok => Intl.message('ok');

  String get onlineKeyBackupDisabled =>
      Intl.message("Online Key Backup is disabled",
          name: "onlineKeyBackupDisabled");

  String get onlineKeyBackupEnabled =>
      Intl.message("Online Key Backup is enabled",
          name: "onlineKeyBackupEnabled");

  String get oopsSomethingWentWrong =>
      Intl.message("Oops something went wrong...");

  String get openAppToReadMessages => Intl.message('Open app to read messages');

  String get openCamera => Intl.message('Open camera');

  String get optionalGroupName => Intl.message("(Optional) Group name");

  String get participatingUserDevices =>
      Intl.message("Participating user devices");

  String get passphraseOrKey =>
      Intl.message("passphrase or recovery key", name: "passphraseOrKey");

  String get password => Intl.message("Password");

  String get pickImage => Intl.message('Pick image');

  String play(String fileName) => Intl.message(
        "Play $fileName",
        name: "play",
        args: [fileName],
      );

  String get pleaseChooseAUsername => Intl.message("Please choose a username");

  String get pleaseEnterAMatrixIdentifier =>
      Intl.message('Please enter a matrix identifier');

  String get pleaseEnterYourPassword =>
      Intl.message("Please enter your password");

  String get pleaseEnterYourUsername =>
      Intl.message("Please enter your username");

  String get publicRooms => Intl.message("Public Rooms");

  String get reject => Intl.message("Reject");

  String get rejoin => Intl.message("Rejoin");

  String get renderRichContent => Intl.message("Render rich message content");

  String get recording => Intl.message("Recording");

  String redactedAnEvent(String username) => Intl.message(
        "$username redacted an event",
        name: "redactedAnEvent",
        args: [username],
      );

  String rejectedTheInvitation(String username) => Intl.message(
        "$username rejected the invitation",
        name: "rejectedTheInvitation",
        args: [username],
      );

  String get removeAllOtherDevices => Intl.message("Remove all other devices");

  String removedBy(String username) => Intl.message(
        "Removed by $username",
        name: "removedBy",
        args: [username],
      );

  String get removeDevice => Intl.message("Remove device");

  String get removeExile => Intl.message("Remove exile");

  String get revokeAllPermissions => Intl.message("Revoke all permissions");

  String get remove => Intl.message("Remove");

  String get removeMessage => Intl.message('Remove message');

  String get reply => Intl.message('Reply');

  String get requestPermission => Intl.message('Request permission');

  String get requestToReadOlderMessages =>
      Intl.message("Request to read older messages");

  String get roomHasBeenUpgraded => Intl.message('Room has been upgraded');

  String get saturday => Intl.message("Saturday");

  String get share => Intl.message("Share");

  String sharedTheLocation(String username) => Intl.message(
        "$username shared the location",
        name: "sharedTheLocation",
        args: [username],
      );

  String get searchForAChat => Intl.message("Search for a chat");

  String get lastSeenLongTimeAgo => Intl.message('Seen a long time ago');

  String seenByUser(String username) => Intl.message(
        "Seen by $username",
        name: "seenByUser",
        args: [username],
      );

  String seenByUserAndUser(String username, String username2) => Intl.message(
        "Seen by $username and $username2",
        name: "seenByUserAndUser",
        args: [username, username2],
      );

  String seenByUserAndCountOthers(String username, String count) =>
      Intl.message(
        "Seen by $username and $count others",
        name: "seenByUserAndCountOthers",
        args: [username, count],
      );

  String get send => Intl.message("Send");

  String get sendAMessage => Intl.message("Send a message");

  String get sendFile => Intl.message('Send file');

  String get sendImage => Intl.message('Send image');

  String sentAFile(String username) => Intl.message(
        "$username sent a file",
        name: "sentAFile",
        args: [username],
      );

  String sentAnAudio(String username) => Intl.message(
        "$username sent an audio",
        name: "sentAnAudio",
        args: [username],
      );

  String sentAPicture(String username) => Intl.message(
        "$username sent a picture",
        name: "sentAPicture",
        args: [username],
      );

  String sentASticker(String username) => Intl.message(
        "$username sent a sticker",
        name: "sentASticker",
        args: [username],
      );

  String sentAVideo(String username) => Intl.message(
        "$username sent a video",
        name: "sentAVideo",
        args: [username],
      );

  String get sessionVerified =>
      Intl.message("Session is verified", name: "sessionVerified");

  String get setAProfilePicture => Intl.message("Set a profile picture");

  String get setGroupDescription => Intl.message("Set group description");

  String get setInvitationLink => Intl.message("Set invitation link");

  String get setStatus => Intl.message('Set status');

  String get settings => Intl.message("Settings");

  String get signUp => Intl.message("Sign up");

  String get skip => Intl.message("Skip");

  String get changeTheme => Intl.message("Change your style");

  String get systemTheme => Intl.message("System");

  String get statusExampleMessage => Intl.message("How are you today?");

  String get lightTheme => Intl.message("Light");

  String get darkTheme => Intl.message("Dark");

  String get useAmoledTheme => Intl.message("Use Amoled compatible colors?");

  String get sourceCode => Intl.message("Source code");

  String get startYourFirstChat => Intl.message("Start your first chat :-)");

  String get submit => Intl.message("Submit");

  String get sunday => Intl.message("Sunday");

  String get donate => Intl.message("Donate");

  String get tapToShowMenu => Intl.message("Tap to show menu");

  String get theyDontMatch => Intl.message("They Don't Match");

  String get theyMatch => Intl.message("They Match");

  String get thisRoomHasBeenArchived =>
      Intl.message("This room has been archived.");

  String get thursday => Intl.message("Thursday");

  String timeOfDay(
          String hours12, String hours24, String minutes, String suffix) =>
      Intl.message(
        "$hours12:$minutes $suffix",
        name: "timeOfDay",
        args: [hours12, hours24, minutes, suffix],
      );

  String get title => Intl.message(
        'FluffyChat',
        name: 'title',
        desc: 'Title for the application',
        locale: localeName,
      );

  String get tryToSendAgain => Intl.message("Try to send again");

  String get tuesday => Intl.message("Tuesday");

  String unbannedUser(String username, String targetName) => Intl.message(
        "$username unbanned $targetName",
        name: "unbannedUser",
        args: [username, targetName],
      );

  String get unblockDevice => Intl.message("Unblock Device");

  String get unmuteChat => Intl.message('Unmute chat');

  String get unknownDevice => Intl.message("Unknown device");

  String get unknownEncryptionAlgorithm =>
      Intl.message("Unknown encryption algorithm");

  String get unknownSessionVerify =>
      Intl.message("Unknown session, please verify",
          name: "unknownSessionVerify");

  String unknownEvent(String type) => Intl.message(
        "Unknown event '$type'",
        name: "unknownEvent",
        args: [type],
      );

  String unreadChats(String unreadCount) => Intl.message(
        "$unreadCount unread chats",
        name: "unreadChats",
        args: [unreadCount],
      );

  String unreadMessages(String unreadEvents) => Intl.message(
        "$unreadEvents unread messages",
        name: "unreadMessages",
        args: [unreadEvents],
      );

  String unreadMessagesInChats(String unreadEvents, String unreadChats) =>
      Intl.message(
        "$unreadEvents unread messages in $unreadChats chats",
        name: "unreadMessagesInChats",
        args: [unreadEvents, unreadChats],
      );

  String userAndOthersAreTyping(String username, String count) => Intl.message(
        "$username and $count others are typing...",
        name: "userAndOthersAreTyping",
        args: [username, count],
      );

  String userAndUserAreTyping(String username, String username2) =>
      Intl.message(
        "$username and $username2 are typing...",
        name: "userAndUserAreTyping",
        args: [username, username2],
      );

  String get username => Intl.message("Username");

  String userIsTyping(String username) => Intl.message(
        "$username is typing...",
        name: "userIsTyping",
        args: [username],
      );

  String userSentUnknownEvent(String username, String type) => Intl.message(
        "$username sent a $type event",
        name: "userSentUnknownEvent",
        args: [username, type],
      );

  String get verify => Intl.message("Verify");

  String get verifyManual =>
      Intl.message("Verify Manually", name: "verifyManual");

  String get verifiedSession =>
      Intl.message("Successfully verified session!", name: "verifiedSession");

  String get verifyStart =>
      Intl.message("Start Verification", name: "verifyStart");

  String get verifySuccess =>
      Intl.message("You successfully verified!", name: "verifySuccess");

  String get verifyTitle =>
      Intl.message("Verifying other account", name: "verifyTitle");

  String get verifyUser => Intl.message("Verify User");

  String get videoCall => Intl.message('Video call');

  String get visibleForAllParticipants =>
      Intl.message("Visible for all participants");

  String get visibleForEveryone => Intl.message("Visible for everyone");

  String get visibilityOfTheChatHistory =>
      Intl.message("Visibility of the chat history");

  String get voiceMessage => Intl.message("Voice message");

  String get waitingPartnerAcceptRequest =>
      Intl.message("Waiting for partner to accept the request...",
          name: "waitingPartnerAcceptRequest");

  String get waitingPartnerEmoji =>
      Intl.message("Waiting for partner to accept the emoji...",
          name: "waitingPartnerEmoji");

  String get waitingPartnerNumbers =>
      Intl.message("Waiting for partner to accept the numbers...",
          name: "waitingPartnerNumbers");

  String get wallpaper => Intl.message("Wallpaper");

  String get warningEncryptionInBeta => Intl.message(
      "End to end encryption is currently in Beta! Use at your own risk!");

  String get wednesday => Intl.message("Wednesday");

  String get welcomeText => Intl.message(
      'Welcome to the cutest instant messenger in the matrix network.');

  String get whoIsAllowedToJoinThisGroup =>
      Intl.message("Who is allowed to join this group");

  String get writeAMessage => Intl.message("Write a message...");

  String get yes => Intl.message("Yes");

  String get you => Intl.message("You");

  String get youAreInvitedToThisChat =>
      Intl.message("You are invited to this chat");

  String get youAreNoLongerParticipatingInThisChat =>
      Intl.message("You are no longer participating in this chat");

  String get youCannotInviteYourself =>
      Intl.message("You cannot invite yourself");

  String get youHaveBeenBannedFromThisChat =>
      Intl.message("You have been banned from this chat");

  String get yourOwnUsername => Intl.message("Your own username");
}
