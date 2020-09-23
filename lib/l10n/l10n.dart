import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<L10n> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'en',
      'de',
      'hu',
      'pl',
      'fr',
      'cs',
      'es',
      'sk',
      'gl',
      'hr',
      'ja',
      'ru',
      'uk',
      'hy',
      'tr',
      'zh_Hans',
      'et',
    ].contains(locale.languageCode);
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

  String get about => Intl.message("About", name: "about");

  String get accept => Intl.message("Accept", name: "accept");

  String acceptedTheInvitation(String username) => Intl.message(
        "$username accepted the invitation",
        name: "acceptedTheInvitation",
        args: [username],
      );

  String get account => Intl.message("Account", name: "account");

  String get accountInformation =>
      Intl.message("Account informations", name: "accountInformation");

  String activatedEndToEndEncryption(String username) => Intl.message(
        "$username activated end to end encryption",
        name: "activatedEndToEndEncryption",
        args: [username],
      );

  String get addGroupDescription =>
      Intl.message("Add a group description", name: "addGroupDescription");

  String get admin => Intl.message("Admin", name: "admin");

  String get alias => Intl.message("alias", name: "alias");

  String get alreadyHaveAnAccount =>
      Intl.message("Already have an account?", name: "alreadyHaveAnAccount");

  String answeredTheCall(String senderName) =>
      Intl.message('$senderName answered the call',
          name: "answeredTheCall", args: [senderName]);

  String get anyoneCanJoin =>
      Intl.message("Anyone can join", name: "anyoneCanJoin");

  String get archive => Intl.message("Archive", name: "archive");

  String get archivedRoom =>
      Intl.message("Archived Room", name: "archivedRoom");

  String get areGuestsAllowedToJoin =>
      Intl.message("Are guest users allowed to join",
          name: "areGuestsAllowedToJoin");

  String get areYouSure => Intl.message("Are you sure?", name: "areYouSure");

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

  String get authentication =>
      Intl.message("Authentication", name: "authentication");

  String get avatarHasBeenChanged =>
      Intl.message("Avatar has been changed", name: "avatarHasBeenChanged");

  String get banFromChat => Intl.message("Ban from chat", name: "banFromChat");

  String get banned => Intl.message("Banned", name: "banned");

  String bannedUser(String username, String targetName) => Intl.message(
        "$username banned $targetName",
        name: "bannedUser",
        args: [username, targetName],
      );

  String get blockDevice => Intl.message("Block Device", name: "blockDevice");

  String byDefaultYouWillBeConnectedTo(String homeserver) => Intl.message(
        'By default you will be connected to $homeserver',
        name: 'byDefaultYouWillBeConnectedTo',
        args: [homeserver],
      );

  String get cachedKeys =>
      Intl.message("Successfully cached keys!", name: "cachedKeys");

  String get cancel => Intl.message("Cancel", name: "cancel");

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

  String get changeTheHomeserver =>
      Intl.message('Change the homeserver', name: "changeTheHomeserver");

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
        "$username changed their avatar",
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

  String get changelog => Intl.message("Changelog", name: "changelog");

  String get changeTheNameOfTheGroup =>
      Intl.message("Change the name of the group",
          name: "changeTheNameOfTheGroup");

  String get changeWallpaper =>
      Intl.message("Change wallpaper", name: "changeWallpaper");

  String get changeTheServer =>
      Intl.message("Change the server", name: "changeTheServer");

  String get channelCorruptedDecryptError =>
      Intl.message("The encryption has been corrupted",
          name: "channelCorruptedDecryptError");

  String get chat => Intl.message('Chat', name: "chat");

  String get chatDetails => Intl.message('Chat details', name: "chatDetails");

  String get chooseAStrongPassword =>
      Intl.message("Choose a strong password", name: "chooseAStrongPassword");

  String get chooseAUsername =>
      Intl.message("Choose a username", name: "chooseAUsername");

  String get close => Intl.message("Close", name: "close");

  String get compareEmojiMatch => Intl.message(
      "Compare and make sure the following emoji match those of the other device:",
      name: "compareEmojiMatch");

  String get compareNumbersMatch => Intl.message(
      "Compare and make sure the following numbers match those of the other device:",
      name: "compareNumbersMatch");

  String get confirm => Intl.message("Confirm", name: "confirm");

  String get connect => Intl.message('Connect', name: "connect");

  String get connectionAttemptFailed =>
      Intl.message("Connection attempt failed",
          name: "connectionAttemptFailed");

  String get contactHasBeenInvitedToTheGroup =>
      Intl.message("Contact has been invited to the group",
          name: "contactHasBeenInvitedToTheGroup");

  String get contentViewer =>
      Intl.message("Content viewer", name: "contentViewer");

  String get copiedToClipboard =>
      Intl.message("Copied to clipboard", name: "copiedToClipboard");

  String get copy => Intl.message("Copy", name: "copy");

  String couldNotDecryptMessage(String error) => Intl.message(
        "Could not decrypt message: $error",
        name: "couldNotDecryptMessage",
        args: [error],
      );

  String get couldNotSetAvatar =>
      Intl.message("Could not set avatar", name: "couldNotSetAvatar");

  String get couldNotSetDisplayname =>
      Intl.message("Could not set displayname", name: "couldNotSetDisplayname");

  String countParticipants(String count) => Intl.message(
        "$count participants",
        name: "countParticipants",
        args: [count],
      );

  String get create => Intl.message("Create", name: "create");

  String get createAccountNow =>
      Intl.message("Create account now", name: "createAccountNow");

  String createdTheChat(String username) => Intl.message(
        "$username created the chat",
        name: "createdTheChat",
        args: [username],
      );

  String get createNewGroup =>
      Intl.message("Create new group", name: "createNewGroup");

  String get crossSigningDisabled =>
      Intl.message("Cross-Signing is disabled", name: "crossSigningDisabled");

  String get crossSigningEnabled =>
      Intl.message("Cross-Signing is enabled", name: "crossSigningEnabled");

  String get currentlyActive =>
      Intl.message('Currently active', name: "currentlyActive");

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

  String get delete => Intl.message("Delete", name: "delete");

  String get deactivateAccountWarning => Intl.message(
      'This will deactivate your user account. This can not be undone! Are you sure?',
      name: "deactivateAccountWarning");

  String get deleteAccount =>
      Intl.message('Delete account', name: "deleteAccount");

  String get deleteMessage =>
      Intl.message("Delete message", name: "deleteMessage");

  String get deny => Intl.message("Deny", name: "deny");

  String get device => Intl.message("Device", name: "device");

  String get devices => Intl.message("Devices", name: "devices");

  String get discardPicture =>
      Intl.message("Discard picture", name: "discardPicture");

  String get displaynameHasBeenChanged =>
      Intl.message("Displayname has been changed",
          name: "displaynameHasBeenChanged");

  String get downloadFile =>
      Intl.message("Download file", name: "downloadFile");

  String get editDisplayname =>
      Intl.message("Edit displayname", name: "editDisplayname");

  String get emoteSettings =>
      Intl.message('Emote Settings', name: "emoteSettings");

  String get emoteShortcode =>
      Intl.message('Emote shortcode', name: "emoteShortcode");

  String get emoteWarnNeedToPick =>
      Intl.message('You need to pick an emote shortcode and an image!',
          name: 'emoteWarnNeedToPick');

  String get emoteExists =>
      Intl.message('Emote already exists!', name: 'emoteExists');

  String get emoteInvalid =>
      Intl.message('Invalid emote shortcode!', name: 'emoteInvalid');

  String get emptyChat => Intl.message("Empty chat", name: "emptyChat");

  String get enableEncryptionWarning => Intl.message(
      "You won't be able to disable the encryption anymore. Are you sure?",
      name: "enableEncryptionWarning");

  String get encryption => Intl.message("Encryption", name: "encryption");

  String get encryptionAlgorithm =>
      Intl.message("Encryption algorithm", name: "encryptionAlgorithm");

  String get encryptionNotEnabled =>
      Intl.message("Encryption is not enabled", name: "encryptionNotEnabled");

  String get end2endEncryptionSettings =>
      Intl.message("End-to-end encryption settings",
          name: "end2endEncryptionSettings");

  String endedTheCall(String senderName) => Intl.message(
        '$senderName ended the call',
        name: 'endedTheCall',
        args: [senderName],
      );

  String get enterAGroupName =>
      Intl.message("Enter a group name", name: "enterAGroupName");

  String get enterAUsername =>
      Intl.message("Enter a username", name: "enterAUsername");

  String get enterYourHomeserver =>
      Intl.message('Enter your homeserver', name: "enterYourHomeserver");

  String get fileName => Intl.message("File name", name: "fileName");

  String get fileSize => Intl.message("File size", name: "fileSize");

  String get fluffychat => Intl.message("FluffyChat", name: "fluffychat");

  String get forward => Intl.message('Forward', name: "forward");

  String get friday => Intl.message("Friday", name: "friday");

  String get fromJoining => Intl.message("From joining", name: "fromJoining");

  String get fromTheInvitation =>
      Intl.message("From the invitation", name: "fromTheInvitation");

  String get group => Intl.message("Group", name: "group");

  String get groupDescription =>
      Intl.message("Group description", name: "groupDescription");

  String get groupDescriptionHasBeenChanged =>
      Intl.message("Group description has been changed",
          name: "groupDescriptionHasBeenChanged");

  String get groupIsPublic =>
      Intl.message("Group is public", name: "groupIsPublic");

  String groupWith(String displayname) => Intl.message(
        "Group with $displayname",
        name: "groupWith",
        args: [displayname],
      );

  String get guestsAreForbidden =>
      Intl.message("Guests are forbidden", name: "guestsAreForbidden");

  String get guestsCanJoin =>
      Intl.message("Guests can join", name: "guestsCanJoin");

  String hasWithdrawnTheInvitationFor(String username, String targetName) =>
      Intl.message(
        "$username has withdrawn the invitation for $targetName",
        name: "hasWithdrawnTheInvitationFor",
        args: [username, targetName],
      );

  String get help => Intl.message("Help", name: "help");

  String get homeserverIsNotCompatible =>
      Intl.message("Homeserver is not compatible",
          name: "homeserverIsNotCompatible");

  String get id => Intl.message("ID", name: "id");

  String get identity => Intl.message("Identity", name: "identity");

  String get ignoredUsers =>
      Intl.message('Ignored users', name: "ignoredUsers");

  String get ignoreUsername =>
      Intl.message('Ignore username', name: "ignoreUsername");

  String get ignoreListDescription => Intl.message(
      "You can ignore users who are disturbing you. You won't be able to receive any messages or room invites from the users on your personal ignore list.",
      name: "ignoreListDescription");

  String get incorrectPassphraseOrKey =>
      Intl.message("Incorrect passphrase or recovery key",
          name: "incorrectPassphraseOrKey");

  String get inviteContact =>
      Intl.message("Invite contact", name: "inviteContact");

  String inviteContactToGroup(String groupName) => Intl.message(
        "Invite contact to $groupName",
        name: "inviteContactToGroup",
        args: [groupName],
      );

  String get invited => Intl.message("Invited", name: "invited");

  String inviteText(String username, String link) => Intl.message(
        "$username invited you to FluffyChat. \n1. Install FluffyChat: https://fluffychat.im \n2. Sign up or sign in \n3. Open the invite link: $link",
        name: "inviteText",
        args: [username, link],
      );

  String invitedUser(String username, String targetName) => Intl.message(
        "$username invited $targetName",
        name: "invitedUser",
        args: [username, targetName],
      );

  String get invitedUsersOnly =>
      Intl.message("Invited users only", name: "invitedUsersOnly");

  String get isDeviceKeyCorrect =>
      Intl.message("Is the following device key correct?",
          name: "isDeviceKeyCorrect");

  String get isTyping => Intl.message("is typing...", name: "isTyping");

  String get editJitsiInstance =>
      Intl.message('Edit Jitsi instance', name: "editJitsiInstance");

  String joinedTheChat(String username) => Intl.message(
        "$username joined the chat",
        name: "joinedTheChat",
        args: [username],
      );

  String get joinRoom => Intl.message('Join room', name: "joinRoom");

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

  String get kickFromChat =>
      Intl.message("Kick from chat", name: "kickFromChat");

  String get leave => Intl.message('Leave', name: "leave");

  String get leftTheChat => Intl.message("Left the chat", name: "leftTheChat");

  String get logout => Intl.message("Logout", name: "logout");

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

  String get lastSeenIp => Intl.message("Last seen IP", name: "lastSeenIp");

  String get license => Intl.message("License", name: "license");

  String get loadingPleaseWait =>
      Intl.message("Loading... Please wait", name: "loadingPleaseWait");

  String get loadMore => Intl.message('Load more...', name: "loadMore");

  String loadCountMoreParticipants(String count) => Intl.message(
        "Load $count more participants",
        name: "loadCountMoreParticipants",
        args: [count],
      );

  String get login => Intl.message("Login", name: "login");

  String logInTo(String homeserver) => Intl.message(
        'Log in to $homeserver',
        name: 'logInTo',
        args: [homeserver],
      );

  String get makeAModerator =>
      Intl.message("Make a moderator", name: "makeAModerator");

  String get makeAnAdmin => Intl.message("Make an admin", name: "makeAnAdmin");

  String get makeSureTheIdentifierIsValid =>
      Intl.message("Make sure the identifier is valid",
          name: "makeSureTheIdentifierIsValid");

  String get messageWillBeRemovedWarning =>
      Intl.message("Message will be removed for all participants",
          name: "messageWillBeRemovedWarning");

  String get moderator => Intl.message("Moderator", name: "moderator");

  String get monday => Intl.message("Monday", name: "monday");

  String get muteChat => Intl.message('Mute chat', name: "muteChat");

  String get needPantalaimonWarning => Intl.message(
      "Please be aware that you need Pantalaimon to use end-to-end encryption for now.",
      name: "needPantalaimonWarning");

  String get newMessageInFluffyChat =>
      Intl.message('New message in FluffyChat', name: "newMessageInFluffyChat");

  String get newPrivateChat =>
      Intl.message("New private chat", name: "newPrivateChat");

  String get newVerificationRequest =>
      Intl.message("New verification request!", name: "newVerificationRequest");

  String get noCrossSignBootstrap => Intl.message(
      "Fluffychat currently does not support enabling Cross-Signing. Please enable it from within Riot.",
      name: "noCrossSignBootstrap");

  String get noMegolmBootstrap => Intl.message(
      "Fluffychat currently does not support enabling Online Key Backup. Please enable it from within Riot.",
      name: "noMegolmBootstrap");

  String get noGoogleServicesWarning => Intl.message(
      "It seems that you have no google services on your phone. That's a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/",
      name: "noGoogleServicesWarning");

  String get none => Intl.message("None", name: "none");

  String get noEmotesFound =>
      Intl.message('No emotes found. 😕', name: "noEmotesFound");

  String get noPermission =>
      Intl.message("No permission", name: "noPermission");

  String get noRoomsFound =>
      Intl.message("No rooms found...", name: "noRoomsFound");

  String get notSupportedInWeb =>
      Intl.message("Not supported in web", name: "notSupportedInWeb");

  String numberSelected(String number) =>
      Intl.message("$number selected", name: "numberSelected", args: [number]);

  String get ok => Intl.message('ok', name: "ok");

  String get onlineKeyBackupDisabled =>
      Intl.message("Online Key Backup is disabled",
          name: "onlineKeyBackupDisabled");

  String get onlineKeyBackupEnabled =>
      Intl.message("Online Key Backup is enabled",
          name: "onlineKeyBackupEnabled");

  String get oopsSomethingWentWrong =>
      Intl.message("Oops something went wrong...",
          name: "oopsSomethingWentWrong");

  String get openAppToReadMessages =>
      Intl.message('Open app to read messages', name: "openAppToReadMessages");

  String get openCamera => Intl.message('Open camera', name: "openCamera");

  String get optionalGroupName =>
      Intl.message("(Optional) Group name", name: "optionalGroupName");

  String get participatingUserDevices =>
      Intl.message("Participating user devices",
          name: "participatingUserDevices");

  String get passphraseOrKey =>
      Intl.message("passphrase or recovery key", name: "passphraseOrKey");

  String get password => Intl.message("Password", name: "password");

  String get passwordHasBeenChanged =>
      Intl.message('Password has been changed', name: "passwordHasBeenChanged");

  String get pickImage => Intl.message('Pick image', name: "pickImage");

  String get pin => Intl.message('Pin', name: "pin");

  String play(String fileName) => Intl.message(
        "Play $fileName",
        name: "play",
        args: [fileName],
      );

  String get pleaseChooseAUsername =>
      Intl.message("Please choose a username", name: "pleaseChooseAUsername");

  String get pleaseEnterAMatrixIdentifier =>
      Intl.message('Please enter a matrix identifier',
          name: "pleaseEnterAMatrixIdentifier");

  String get pleaseEnterYourPassword =>
      Intl.message("Please enter your password",
          name: "pleaseEnterYourPassword");

  String get pleaseEnterYourUsername =>
      Intl.message("Please enter your username",
          name: "pleaseEnterYourUsername");

  String get publicRooms => Intl.message("Public Rooms", name: "publicRooms");

  String get reject => Intl.message("Reject", name: "reject");

  String get rejoin => Intl.message("Rejoin", name: "rejoin");

  String get renderRichContent =>
      Intl.message("Render rich message content", name: "renderRichContent");

  String get recording => Intl.message("Recording", name: "recording");

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

  String get removeAllOtherDevices =>
      Intl.message("Remove all other devices", name: "removeAllOtherDevices");

  String removedBy(String username) => Intl.message(
        "Removed by $username",
        name: "removedBy",
        args: [username],
      );

  String get removeDevice =>
      Intl.message("Remove device", name: "removeDevice");

  String get removeExile => Intl.message("Remove exile", name: "removeExile");

  String get revokeAllPermissions =>
      Intl.message("Revoke all permissions", name: "revokeAllPermissions");

  String get remove => Intl.message("Remove", name: "remove");

  String get removeMessage =>
      Intl.message('Remove message', name: "removeMessage");

  String get reply => Intl.message('Reply', name: "reply");

  String get requestPermission =>
      Intl.message('Request permission', name: "requestPermission");

  String get requestToReadOlderMessages =>
      Intl.message("Request to read older messages",
          name: "requestToReadOlderMessages");

  String get roomHasBeenUpgraded =>
      Intl.message('Room has been upgraded', name: "roomHasBeenUpgraded");

  String get saturday => Intl.message("Saturday", name: "saturday");

  String get share => Intl.message("Share", name: "share");

  String sharedTheLocation(String username) => Intl.message(
        "$username shared the location",
        name: "sharedTheLocation",
        args: [username],
      );

  String get searchForAChat =>
      Intl.message("Search for a chat", name: "searchForAChat");

  String get lastSeenLongTimeAgo =>
      Intl.message('Seen a long time ago', name: "lastSeenLongTimeAgo");

  String get sendBugReports =>
      Intl.message('Allow sending bug reports with sentry.io',
          name: "sendBugReports");

  String get sentryInfo => Intl.message(
      'Informations about your privacy: https://sentry.io/security/',
      name: "sentryInfo");

  String get changesHaveBeenSaved =>
      Intl.message('Changes have been saved', name: "changesHaveBeenSaved");

  String get no => Intl.message('No', name: "no");

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

  String get send => Intl.message("Send", name: "send");

  String get sendAMessage =>
      Intl.message("Send a message", name: "sendAMessage");

  String get sendAudio => Intl.message('Send audio', name: "sendAudio");

  String get sendFile => Intl.message('Send file', name: "sendFile");

  String get sendImage => Intl.message('Send image', name: "sendImage");

  String get sendOriginal =>
      Intl.message('Send original', name: "sendOriginal");

  String get sendVideo => Intl.message('Send video', name: "sendVideo");

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

  String sentCallInformations(String senderName) => Intl.message(
        '$senderName sent call informations',
        name: 'sentCallInformations',
        args: [senderName],
      );

  String get sessionVerified =>
      Intl.message("Session is verified", name: "sessionVerified");

  String get setAProfilePicture =>
      Intl.message("Set a profile picture", name: "setAProfilePicture");

  String get setGroupDescription =>
      Intl.message("Set group description", name: "setGroupDescription");

  String get setInvitationLink =>
      Intl.message("Set invitation link", name: "setInvitationLink");

  String get setStatus => Intl.message('Set status', name: "setStatus");

  String get settings => Intl.message("Settings", name: "settings");

  String get signUp => Intl.message("Sign up", name: "signUp");

  String get skip => Intl.message("Skip", name: "skip");

  String startedACall(String senderName) =>
      Intl.message('$senderName started a call',
          name: "startedACall", args: [senderName]);

  String get changeTheme =>
      Intl.message("Change your style", name: "changeTheme");

  String get systemTheme => Intl.message("System", name: "systemTheme");

  String get statusExampleMessage =>
      Intl.message("How are you today?", name: "statusExampleMessage");

  String get lightTheme => Intl.message("Light", name: "lightTheme");

  String get darkTheme => Intl.message("Dark", name: "darkTheme");

  String get useAmoledTheme =>
      Intl.message("Use Amoled compatible colors?", name: "useAmoledTheme");

  String get sourceCode => Intl.message("Source code", name: "sourceCode");

  String get startYourFirstChat =>
      Intl.message("Start your first chat :-)", name: "startYourFirstChat");

  String get submit => Intl.message("Submit", name: "submit");

  String get sunday => Intl.message("Sunday", name: "sunday");

  String get donate => Intl.message("Donate", name: "donate");

  String get tapToShowMenu =>
      Intl.message("Tap to show menu", name: "tapToShowMenu");

  String get theyDontMatch =>
      Intl.message("They Don't Match", name: "theyDontMatch");

  String get theyMatch => Intl.message("They Match", name: "theyMatch");

  String get thisRoomHasBeenArchived =>
      Intl.message("This room has been archived.",
          name: "thisRoomHasBeenArchived");

  String get thursday => Intl.message("Thursday", name: "thursday");

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

  String get tryToSendAgain =>
      Intl.message("Try to send again", name: "tryToSendAgain");

  String get tuesday => Intl.message("Tuesday", name: "tuesday");

  String unbannedUser(String username, String targetName) => Intl.message(
        "$username unbanned $targetName",
        name: "unbannedUser",
        args: [username, targetName],
      );

  String get unblockDevice =>
      Intl.message("Unblock Device", name: "unblockDevice");

  String get unmuteChat => Intl.message('Unmute chat', name: "unmuteChat");

  String get unknownDevice =>
      Intl.message("Unknown device", name: "unknownDevice");

  String get unknownEncryptionAlgorithm =>
      Intl.message("Unknown encryption algorithm",
          name: "unknownEncryptionAlgorithm");

  String get unknownSessionVerify =>
      Intl.message("Unknown session, please verify",
          name: "unknownSessionVerify");

  String unknownEvent(String type) => Intl.message(
        "Unknown event '$type'",
        name: "unknownEvent",
        args: [type],
      );

  String get unpin => Intl.message('Unpin', name: "unpin");

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

  String get username => Intl.message("Username", name: "username");

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

  String get verify => Intl.message("Verify", name: "verify");

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

  String get verifyUser => Intl.message("Verify User", name: "verifyUser");

  String get videoCall => Intl.message('Video call', name: "videoCall");

  String get visibleForAllParticipants =>
      Intl.message("Visible for all participants",
          name: "visibleForAllParticipants");

  String get visibleForEveryone =>
      Intl.message("Visible for everyone", name: "visibleForEveryone");

  String get visibilityOfTheChatHistory =>
      Intl.message("Visibility of the chat history",
          name: "visibilityOfTheChatHistory");

  String get voiceMessage =>
      Intl.message("Voice message", name: "voiceMessage");

  String get waitingPartnerAcceptRequest =>
      Intl.message("Waiting for partner to accept the request...",
          name: "waitingPartnerAcceptRequest");

  String get waitingPartnerEmoji =>
      Intl.message("Waiting for partner to accept the emoji...",
          name: "waitingPartnerEmoji");

  String get waitingPartnerNumbers =>
      Intl.message("Waiting for partner to accept the numbers...",
          name: "waitingPartnerNumbers");

  String get warning => Intl.message('Warning!', name: "warning");

  String get wallpaper => Intl.message("Wallpaper", name: "wallpaper");

  String get warningEncryptionInBeta => Intl.message(
      "End to end encryption is currently in Beta! Use at your own risk!",
      name: "warningEncryptionInBeta");

  String get wednesday => Intl.message("Wednesday", name: "wednesday");

  String get welcomeText => Intl.message(
      'Welcome to the cutest instant messenger in the matrix network.',
      name: "welcomeText");

  String get whoIsAllowedToJoinThisGroup =>
      Intl.message("Who is allowed to join this group",
          name: "whoIsAllowedToJoinThisGroup");

  String get writeAMessage =>
      Intl.message("Write a message...", name: "writeAMessage");

  String get yes => Intl.message("Yes", name: "yes");

  String get you => Intl.message("You", name: "you");

  String get youAreInvitedToThisChat =>
      Intl.message("You are invited to this chat",
          name: "youAreInvitedToThisChat");

  String get youAreNoLongerParticipatingInThisChat =>
      Intl.message("You are no longer participating in this chat",
          name: "youAreNoLongerParticipatingInThisChat");

  String get youCannotInviteYourself =>
      Intl.message("You cannot invite yourself",
          name: "youCannotInviteYourself");

  String get youHaveBeenBannedFromThisChat =>
      Intl.message("You have been banned from this chat",
          name: "youHaveBeenBannedFromThisChat");

  String get yourOwnUsername =>
      Intl.message("Your own username", name: "yourOwnUsername");
}
