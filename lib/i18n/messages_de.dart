// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static m0(username) => "${username} hat die Einladung akzeptiert";

  static m1(username) => "${username} hat Ende-zu-Ende Verschlüsselung aktiviert";

  static m2(username, targetName) => "${username} hat ${targetName} verbannt";

  static m3(username) => "${username} hat den Chat-Avatar geändert";

  static m4(username, description) => "${username} hat die Beschreibung vom Chat geändert zu: \'${description}\'";

  static m5(username, chatname) => "${username} hat den Chat-Namen geändert zu: \'${chatname}\'";

  static m6(username) => "${username} hat die Berechtigungen vom Chat geändert";

  static m7(username, displayname) => "${username} hat den Nicknamen geändert zu: ${displayname}";

  static m8(username) => "${username} hat Gast-Zugangsregeln geändert";

  static m9(username, rules) => "${username} hat Gast-Zugangsregeln geändert zu: ${rules}";

  static m10(username) => "${username} hat die Sichtbarkeit des Chat-Verlaufs geändert";

  static m11(username, rules) => "${username} hat die Sichtbarkeit des Chat-Verlaufs geändert zu: ${rules}";

  static m12(username) => "${username} hat die Zugangsregeln geändert";

  static m13(username, joinRules) => "${username} hat die Zugangsregeln geändert zu: ${joinRules}";

  static m14(username) => "${username} hat das Profilbild geändert";

  static m15(username) => "${username} hat die Raum-Aliase geändert";

  static m16(username) => "${username} hat den Einladungslink geändert";

  static m17(count) => "${count} Teilnehmer";

  static m18(username) => "${username} hat den Chat erstellt";

  static m19(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m20(year, month, day) => "${day}.${month}.${year}";

  static m21(month, day) => "${day}.${month}";

  static m22(fileName) => "Download ${fileName}";

  static m23(displayname) => "Gruppe mit ${displayname}";

  static m24(username, targetName) => "${username} hat die Einladung für ${targetName} zurückgezogen";

  static m25(groupName) => "Kontakt zu ${groupName} einladen";

  static m26(username, targetName) => "${username} hat ${targetName} eingeladen";

  static m27(username) => "${username} ist dem Chat beigetreten";

  static m28(username, targetName) => "${username} hat ${targetName} hinausgeworfen";

  static m29(username, targetName) => "${username} hat ${targetName} hinausgeworfen und verbannt";

  static m30(count) => "${count} weitere Teilnehmer laden";

  static m31(fileName) => "Play ${fileName}";

  static m32(username) => "${username} hat ein Event enternt";

  static m33(username) => "${username} hat die Einladung abgelehnt";

  static m34(username) => "Entfernt von ${username}";

  static m35(username) => "Gelesen von ${username}";

  static m36(username, count) => "Gelesen von ${username} und ${count} anderen";

  static m37(username, username2) => "Gelesen von ${username} und ${username2}";

  static m38(username) => "${username} hat eine Datei gesendet";

  static m39(username) => "${username} hat ein Bild gesendet";

  static m40(username) => "${username} hat einen Sticker gesendet";

  static m41(username) => "${username} hat ein Video gesendet";

  static m42(username) => "${username} hat eine Audio-Datei gesendet";

  static m43(username) => "${username} hat den Standort geteilt";

  static m44(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m45(username, targetName) => "${username} hat die Verbannung von ${targetName} aufgehoben";

  static m46(type) => "Unbekanntes Event \'${type}\'";

  static m47(unreadEvents) => "${unreadEvents} ungelesene Nachrichten";

  static m48(unreadEvents, unreadChats) => "${unreadEvents} ungelesene Nachrichten in ${unreadChats} Chats";

  static m49(username, count) => "${username} und ${count} andere schreiben ...";

  static m50(username, username2) => "${username} und ${username2} schreiben ...";

  static m51(username) => "${username} schreibt ...";

  static m52(username) => "${username} hat den Chat verlassen";

  static m53(username, type) => "${username} hat ${type} Event gesendet";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "(Optional) Group name" : MessageLookupByLibrary.simpleMessage("(Optional) Name für die Gruppe"),
    "About" : MessageLookupByLibrary.simpleMessage("Über"),
    "Add a group description" : MessageLookupByLibrary.simpleMessage("Eine Beschreibung für die Gruppe hinzufügen"),
    "Admin" : MessageLookupByLibrary.simpleMessage("Admin"),
    "Already have an account?" : MessageLookupByLibrary.simpleMessage("Hast du schon einen Account?"),
    "Anyone can join" : MessageLookupByLibrary.simpleMessage("Jeder darf beitreten"),
    "Archive" : MessageLookupByLibrary.simpleMessage("Archiv"),
    "Archived Room" : MessageLookupByLibrary.simpleMessage("Archivierter Raum"),
    "Are guest users allowed to join" : MessageLookupByLibrary.simpleMessage("Dürfen Gast-Benutzer beitreten"),
    "Authentication" : MessageLookupByLibrary.simpleMessage("Authentifizierung"),
    "Avatar has been changed" : MessageLookupByLibrary.simpleMessage("Avatar wurde geändert"),
    "Ban from chat" : MessageLookupByLibrary.simpleMessage("Aus dem Chat verbannen"),
    "Banned" : MessageLookupByLibrary.simpleMessage("Banned"),
    "Change the name of the group" : MessageLookupByLibrary.simpleMessage("Gruppenname ändern"),
    "Changelog" : MessageLookupByLibrary.simpleMessage("Changelog"),
    "Chat details" : MessageLookupByLibrary.simpleMessage("Gruppeninfo"),
    "Choose a username" : MessageLookupByLibrary.simpleMessage("Wähle einen Benutzernamen"),
    "Close" : MessageLookupByLibrary.simpleMessage("Schließen"),
    "Confirm" : MessageLookupByLibrary.simpleMessage("Bestätigen"),
    "Connection attempt failed" : MessageLookupByLibrary.simpleMessage("Verbindungsversuch fehlgeschlagen"),
    "Contact has been invited to the group" : MessageLookupByLibrary.simpleMessage("Kontakt wurde in die Gruppe eingeladen"),
    "Content viewer" : MessageLookupByLibrary.simpleMessage("Content Viewer"),
    "Copied to clipboard" : MessageLookupByLibrary.simpleMessage("Wurde in die Zwischenablage kopiert"),
    "Could not decrypt message" : MessageLookupByLibrary.simpleMessage("Nachricht konnte nicht entschlüsselt werden"),
    "Could not set avatar" : MessageLookupByLibrary.simpleMessage("Profilbild konnte nicht gesetzt werden"),
    "Could not set displayname" : MessageLookupByLibrary.simpleMessage("Anzeigename konnte nicht gesetzt werden"),
    "Create" : MessageLookupByLibrary.simpleMessage("Create"),
    "Create account now" : MessageLookupByLibrary.simpleMessage("Account jetzt erstellen"),
    "Create new group" : MessageLookupByLibrary.simpleMessage("Neue Gruppe"),
    "Delete" : MessageLookupByLibrary.simpleMessage("Löschen"),
    "Delete message" : MessageLookupByLibrary.simpleMessage("Nachricht löschen"),
    "Discard picture" : MessageLookupByLibrary.simpleMessage("Bild verwerfen"),
    "Displayname has been changed" : MessageLookupByLibrary.simpleMessage("Anzeigename wurde geändert"),
    "Donate" : MessageLookupByLibrary.simpleMessage("Spenden"),
    "Edit displayname" : MessageLookupByLibrary.simpleMessage("Anzeigename ändern"),
    "Empty chat" : MessageLookupByLibrary.simpleMessage("Leerer Chat"),
    "Enter a group name" : MessageLookupByLibrary.simpleMessage("Gib einen Gruppennamen ein"),
    "Enter a username" : MessageLookupByLibrary.simpleMessage("Gib einen Benutzernamen ein"),
    "FluffyChat" : MessageLookupByLibrary.simpleMessage("FluffyChat"),
    "Forward" : MessageLookupByLibrary.simpleMessage("Weiterleiten"),
    "Friday" : MessageLookupByLibrary.simpleMessage("Freitag"),
    "From joining" : MessageLookupByLibrary.simpleMessage("Ab dem Beitritt"),
    "From the invitation" : MessageLookupByLibrary.simpleMessage("Ab der Einladung"),
    "Group" : MessageLookupByLibrary.simpleMessage("Gruppe"),
    "Group description" : MessageLookupByLibrary.simpleMessage("Gruppenbeschreibung"),
    "Group description has been changed" : MessageLookupByLibrary.simpleMessage("Gruppenbeschreibung wurde geändert"),
    "Group is public" : MessageLookupByLibrary.simpleMessage("Gruppe ist öffentlich"),
    "Guests are forbidden" : MessageLookupByLibrary.simpleMessage("Gäste sind verboten"),
    "Guests can join" : MessageLookupByLibrary.simpleMessage("Gäste dürfen beitreten"),
    "Help" : MessageLookupByLibrary.simpleMessage("Hilfe"),
    "Homeserver is not compatible" : MessageLookupByLibrary.simpleMessage("Homeserver ist nicht kompatibel"),
    "Invite contact" : MessageLookupByLibrary.simpleMessage("Kontakt einladen"),
    "Invited" : MessageLookupByLibrary.simpleMessage("Eingeladen"),
    "Invited users only" : MessageLookupByLibrary.simpleMessage("Nur eingeladene Benutzer"),
    "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/" : MessageLookupByLibrary.simpleMessage("Es sieht so aus als hättest du keine Google Dienste auf deinem Gerät. Das ist eine gute Entscheidung für deine Privatsphäre. Um Push Benachrichtigungen in FluffyChat zu erhalten, empfehlen wir die Verwendung von microG: https://microg.org/"),
    "Kick from chat" : MessageLookupByLibrary.simpleMessage("Aus dem Chat hinauswerfen"),
    "Leave" : MessageLookupByLibrary.simpleMessage("Verlassen"),
    "Left the chat" : MessageLookupByLibrary.simpleMessage("Hat den Chat verlassen"),
    "License" : MessageLookupByLibrary.simpleMessage("Lizenz"),
    "Loading... Please wait" : MessageLookupByLibrary.simpleMessage("Lade ... Bitte warten"),
    "Login" : MessageLookupByLibrary.simpleMessage("Login"),
    "Logout" : MessageLookupByLibrary.simpleMessage("Logout"),
    "Make an admin" : MessageLookupByLibrary.simpleMessage("Zum Admin ernennen"),
    "Make sure the identifier is valid" : MessageLookupByLibrary.simpleMessage("Gib bitte einen richtigen Benutzernamen ein"),
    "Message will be removed for all participants" : MessageLookupByLibrary.simpleMessage("Nachricht wird für alle Teilnehmer entfernt"),
    "Moderator" : MessageLookupByLibrary.simpleMessage("Moderator"),
    "Monday" : MessageLookupByLibrary.simpleMessage("Montag"),
    "Mute chat" : MessageLookupByLibrary.simpleMessage("Stummschalten"),
    "New message in FluffyChat" : MessageLookupByLibrary.simpleMessage("Neue Nachricht in FluffyChat"),
    "New private chat" : MessageLookupByLibrary.simpleMessage("Neuer privater Chat"),
    "No rooms found..." : MessageLookupByLibrary.simpleMessage("Keine Räume gefunden ..."),
    "Not supported in web" : MessageLookupByLibrary.simpleMessage("Wird in der Web-Version nicht unterstützt"),
    "Oops something went wrong..." : MessageLookupByLibrary.simpleMessage("Hoppla! Da ist etwas schief gelaufen ..."),
    "Open camera" : MessageLookupByLibrary.simpleMessage("Kamera öffnen"),
    "Password" : MessageLookupByLibrary.simpleMessage("Passwort"),
    "Please choose a username" : MessageLookupByLibrary.simpleMessage("Bitte wähle einen Benutzernamen"),
    "Please enter a matrix identifier" : MessageLookupByLibrary.simpleMessage("Bitte eine Matrix ID eingeben"),
    "Please enter your password" : MessageLookupByLibrary.simpleMessage("Bitte dein Passwort eingeben"),
    "Please enter your username" : MessageLookupByLibrary.simpleMessage("Bitte deinen Benutzernamen eingeben"),
    "Rejoin" : MessageLookupByLibrary.simpleMessage("Wieder beitreten"),
    "Remove" : MessageLookupByLibrary.simpleMessage("Entfernen"),
    "Remove exile" : MessageLookupByLibrary.simpleMessage("Verbannung aufheben"),
    "Remove message" : MessageLookupByLibrary.simpleMessage("Nachricht entfernen"),
    "Revoke all permissions" : MessageLookupByLibrary.simpleMessage("Alle Berechtigungen zurücknehmen"),
    "Saturday" : MessageLookupByLibrary.simpleMessage("Samstag"),
    "Search for a chat" : MessageLookupByLibrary.simpleMessage("Durchsuche die Chats"),
    "Secure your account with a password" : MessageLookupByLibrary.simpleMessage("Sichere deinen Account mit einem Passwort ab"),
    "Send a message" : MessageLookupByLibrary.simpleMessage("Nachricht schreiben"),
    "Send file" : MessageLookupByLibrary.simpleMessage("Datei senden"),
    "Send image" : MessageLookupByLibrary.simpleMessage("Bild senden"),
    "Set a profile picture" : MessageLookupByLibrary.simpleMessage("Ein Profilbild festlegen"),
    "Set group description" : MessageLookupByLibrary.simpleMessage("Gruppenbeschreibung festlegen"),
    "Set invitation link" : MessageLookupByLibrary.simpleMessage("Einladungslink festlegen"),
    "Settings" : MessageLookupByLibrary.simpleMessage("Einstellungen"),
    "Share" : MessageLookupByLibrary.simpleMessage("Teilen"),
    "Sign up" : MessageLookupByLibrary.simpleMessage("Registrieren"),
    "Source code" : MessageLookupByLibrary.simpleMessage("Quellcode"),
    "Start your first chat :-)" : MessageLookupByLibrary.simpleMessage("Starte deinen ersten Chat :-)"),
    "Sunday" : MessageLookupByLibrary.simpleMessage("Sonntag"),
    "Tap to show menu" : MessageLookupByLibrary.simpleMessage("Tippen, um das Menü anzuzeigen"),
    "This room has been archived." : MessageLookupByLibrary.simpleMessage("Dieser Raum wurde archiviert."),
    "Thursday" : MessageLookupByLibrary.simpleMessage("Donnerstag"),
    "Try to send again" : MessageLookupByLibrary.simpleMessage("Nochmal versuchen zu senden"),
    "Tuesday" : MessageLookupByLibrary.simpleMessage("Tuesday"),
    "Unmute chat" : MessageLookupByLibrary.simpleMessage("Nicht mehr stummschalten"),
    "Username" : MessageLookupByLibrary.simpleMessage("Benutzername"),
    "Visibility of the chat history" : MessageLookupByLibrary.simpleMessage("Sichtbarkeit des Chat-Verlaufs"),
    "Visible for all participants" : MessageLookupByLibrary.simpleMessage("Sichtbar für alle Teilnehmer"),
    "Visible for everyone" : MessageLookupByLibrary.simpleMessage("Für jeden sichtbar"),
    "Wednesday" : MessageLookupByLibrary.simpleMessage("Mittwoch"),
    "Who is allowed to join this group" : MessageLookupByLibrary.simpleMessage("Wer darf der Gruppe beitreten"),
    "Write a message..." : MessageLookupByLibrary.simpleMessage("Schreibe eine Nachricht ..."),
    "You" : MessageLookupByLibrary.simpleMessage("Du"),
    "You are invited to this chat" : MessageLookupByLibrary.simpleMessage("Du wurdest eingeladen in diesen Chat"),
    "You are no longer participating in this chat" : MessageLookupByLibrary.simpleMessage("Du bist kein Teilnehmer mehr in diesem Chat"),
    "You cannot invite yourself" : MessageLookupByLibrary.simpleMessage("Du kannst dich nicht selbst einladen"),
    "You have been banned from this chat" : MessageLookupByLibrary.simpleMessage("Du wurdest aus dem Chat verbannt"),
    "Your own username" : MessageLookupByLibrary.simpleMessage("Dein eigener Benutzername"),
    "acceptedTheInvitation" : m0,
    "activatedEndToEndEncryption" : m1,
    "alias" : MessageLookupByLibrary.simpleMessage("Alias"),
    "bannedUser" : m2,
    "changedTheChatAvatar" : m3,
    "changedTheChatDescriptionTo" : m4,
    "changedTheChatNameTo" : m5,
    "changedTheChatPermissions" : m6,
    "changedTheDisplaynameTo" : m7,
    "changedTheGuestAccessRules" : m8,
    "changedTheGuestAccessRulesTo" : m9,
    "changedTheHistoryVisibility" : m10,
    "changedTheHistoryVisibilityTo" : m11,
    "changedTheJoinRules" : m12,
    "changedTheJoinRulesTo" : m13,
    "changedTheProfileAvatar" : m14,
    "changedTheRoomAliases" : m15,
    "changedTheRoomInvitationLink" : m16,
    "countParticipants" : m17,
    "createdTheChat" : m18,
    "dateAndTimeOfDay" : m19,
    "dateWithYear" : m20,
    "dateWithoutYear" : m21,
    "download" : m22,
    "groupWith" : m23,
    "hasWithdrawnTheInvitationFor" : m24,
    "inviteContactToGroup" : m25,
    "invitedUser" : m26,
    "is typing..." : MessageLookupByLibrary.simpleMessage("schreibt..."),
    "joinedTheChat" : m27,
    "kicked" : m28,
    "kickedAndBanned" : m29,
    "loadCountMoreParticipants" : m30,
    "play" : m31,
    "redactedAnEvent" : m32,
    "rejectedTheInvitation" : m33,
    "removedBy" : m34,
    "seenByUser" : m35,
    "seenByUserAndCountOthers" : m36,
    "seenByUserAndUser" : m37,
    "sentAFile" : m38,
    "sentAPicture" : m39,
    "sentASticker" : m40,
    "sentAVideo" : m41,
    "sentAnAudio" : m42,
    "sharedTheLocation" : m43,
    "timeOfDay" : m44,
    "title" : MessageLookupByLibrary.simpleMessage("FluffyChat"),
    "unbannedUser" : m45,
    "unknownEvent" : m46,
    "unreadMessages" : m47,
    "unreadMessagesInChats" : m48,
    "userAndOthersAreTyping" : m49,
    "userAndUserAreTyping" : m50,
    "userIsTyping" : m51,
    "userLeftTheChat" : m52,
    "userSentUnknownEvent" : m53
  };
}
