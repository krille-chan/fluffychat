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

  static m1(username) =>
      "${username} hat Ende-zu-Ende Verschlüsselung aktiviert";

  static m60(username) => "Diese Bestätigungsanfrage von ${username} annehmen?";

  static m2(username, targetName) => "${username} hat ${targetName} verbannt";

  static m3(homeserver) => "Standardmäßig wirst Du mit ${homeserver} verbunden";

  static m4(username) => "${username} hat den Chat-Avatar geändert";

  static m5(username, description) =>
      "${username} hat die Beschreibung vom Chat geändert zu: \'${description}\'";

  static m6(username, chatname) =>
      "${username} hat den Chat-Namen geändert zu: \'${chatname}\'";

  static m7(username) => "${username} hat die Berechtigungen vom Chat geändert";

  static m8(username, displayname) =>
      "${username} hat den Nicknamen geändert zu: ${displayname}";

  static m9(username) => "${username} hat Gast-Zugangsregeln geändert";

  static m10(username, rules) =>
      "${username} hat Gast-Zugangsregeln geändert zu: ${rules}";

  static m11(username) =>
      "${username} hat die Sichtbarkeit des Chat-Verlaufs geändert";

  static m12(username, rules) =>
      "${username} hat die Sichtbarkeit des Chat-Verlaufs geändert zu: ${rules}";

  static m13(username) => "${username} hat die Zugangsregeln geändert";

  static m14(username, joinRules) =>
      "${username} hat die Zugangsregeln geändert zu: ${joinRules}";

  static m15(username) => "${username} hat das Profilbild geändert";

  static m16(username) => "${username} hat die Raum-Aliase geändert";

  static m17(username) => "${username} hat den Einladungslink geändert";

  static m18(error) => "Nachricht konnte nicht entschlüsselt werden: ${error}";

  static m19(count) => "${count} Teilnehmer*innen";

  static m20(username) => "${username} hat den Chat erstellt";

  static m21(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m22(year, month, day) => "${day}. ${month}. ${year}";

  static m23(month, day) => "${day}. ${month}";

  static m24(displayname) => "Gruppe mit ${displayname}";

  static m25(username, targetName) =>
      "${username} hat die Einladung für ${targetName} zurückgezogen";

  static m26(groupName) => "Kontakt in die Gruppe ${groupName} einladen";

  static m27(username, link) =>
      "${username} hat Dich zu FluffyChat eingeladen. \n1. Installiere FluffyChat: http://fluffy.chat \n2. Melde Dich in der App an \n3. Öffne den Einladungslink: ${link}";

  static m28(username, targetName) =>
      "${username} hat ${targetName} eingeladen";

  static m29(username) => "${username} ist dem Chat beigetreten";

  static m30(username, targetName) =>
      "${username} hat ${targetName} hinausgeworfen";

  static m31(username, targetName) =>
      "${username} hat ${targetName} hinausgeworfen und verbannt";

  static m32(localizedTimeShort) => "Zuletzt aktiv: ${localizedTimeShort}";

  static m33(count) => "${count} weitere Teilnehmer*innen laden";

  static m34(homeserver) => "Bei ${homeserver} anmelden";

  static m35(number) => "${number} ausgewählt";

  static m36(fileName) => "${fileName} abspielen";

  static m37(username) => "${username} hat ein Event enternt";

  static m38(username) => "${username} hat die Einladung abgelehnt";

  static m39(username) => "Entfernt von ${username}";

  static m40(username) => "Gelesen von ${username}";

  static m41(username, count) => "Gelesen von ${username} und ${count} anderen";

  static m42(username, username2) => "Gelesen von ${username} und ${username2}";

  static m43(username) => "${username} hat eine Datei gesendet";

  static m44(username) => "${username} hat ein Bild gesendet";

  static m45(username) => "${username} hat einen Sticker gesendet";

  static m46(username) => "${username} hat ein Video gesendet";

  static m47(username) => "${username} hat eine Audio-Datei gesendet";

  static m48(username) => "${username} hat den Standort geteilt";

  static m49(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m50(username, targetName) =>
      "${username} hat die Verbannung von ${targetName} aufgehoben";

  static m51(type) => "Unbekanntes Ereignis \'${type}\'";

  static m52(unreadCount) => "${unreadCount} ungelesene Unterhaltungen";

  static m53(unreadEvents) => "${unreadEvents} ungelesene Nachrichten";

  static m54(unreadEvents, unreadChats) =>
      "${unreadEvents} ungelesene Nachrichten in ${unreadChats} Chats";

  static m55(username, count) =>
      "${username} und ${count} andere schreiben ...";

  static m56(username, username2) =>
      "${username} und ${username2} schreiben ...";

  static m57(username) => "${username} schreibt ...";

  static m58(username) => "${username} hat den Chat verlassen";

  static m59(username, type) => "${username} hat ${type} Event gesendet";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "(Optional) Group name": MessageLookupByLibrary.simpleMessage(
            "(Optional) Name für die Gruppe"),
        "About": MessageLookupByLibrary.simpleMessage("Über"),
        "Accept": MessageLookupByLibrary.simpleMessage("Annehmen"),
        "Account": MessageLookupByLibrary.simpleMessage("Konto"),
        "Account informations":
            MessageLookupByLibrary.simpleMessage("Kontoinformationen"),
        "Add a group description": MessageLookupByLibrary.simpleMessage(
            "Eine Beschreibung für die Gruppe hinzufügen"),
        "Admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "Already have an account?": MessageLookupByLibrary.simpleMessage(
            "Hast du schon einen Account?"),
        "Anyone can join":
            MessageLookupByLibrary.simpleMessage("Jeder darf beitreten"),
        "Archive": MessageLookupByLibrary.simpleMessage("Archiv"),
        "Archived Room":
            MessageLookupByLibrary.simpleMessage("Archivierter Raum"),
        "Are guest users allowed to join": MessageLookupByLibrary.simpleMessage(
            "Dürfen Gast-Benutzer beitreten"),
        "Are you sure?":
            MessageLookupByLibrary.simpleMessage("Bist Du sicher?"),
        "Authentication":
            MessageLookupByLibrary.simpleMessage("Authentifizierung"),
        "Avatar has been changed":
            MessageLookupByLibrary.simpleMessage("Avatar wurde geändert"),
        "Ban from chat":
            MessageLookupByLibrary.simpleMessage("Aus dem Chat verbannen"),
        "Banned": MessageLookupByLibrary.simpleMessage("Verbannt"),
        "Block Device": MessageLookupByLibrary.simpleMessage("Blockiere Gerät"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "Change the homeserver": MessageLookupByLibrary.simpleMessage(
            "Anderen Homeserver verwenden"),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("Gruppenname ändern"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Ändere den Server"),
        "Change wallpaper":
            MessageLookupByLibrary.simpleMessage("Hintergrund ändern"),
        "Change your style":
            MessageLookupByLibrary.simpleMessage("Ändere Deinen Style"),
        "Changelog":
            MessageLookupByLibrary.simpleMessage("Protokoll der Änderungen"),
        "Chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "Chat details": MessageLookupByLibrary.simpleMessage("Gruppeninfo"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("Wähle ein sicheres Passwort"),
        "Choose a username":
            MessageLookupByLibrary.simpleMessage("Wähle einen Benutzernamen"),
        "Close": MessageLookupByLibrary.simpleMessage("Schließen"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Bestätigen"),
        "Connect": MessageLookupByLibrary.simpleMessage("Verbinden"),
        "Connection attempt failed": MessageLookupByLibrary.simpleMessage(
            "Verbindungsversuch fehlgeschlagen"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage(
                "Kontakt wurde in die Gruppe eingeladen"),
        "Content viewer":
            MessageLookupByLibrary.simpleMessage("Content Viewer"),
        "Copied to clipboard": MessageLookupByLibrary.simpleMessage(
            "Wurde in die Zwischenablage kopiert"),
        "Copy": MessageLookupByLibrary.simpleMessage("Kopieren"),
        "Could not set avatar": MessageLookupByLibrary.simpleMessage(
            "Profilbild konnte nicht gesetzt werden"),
        "Could not set displayname": MessageLookupByLibrary.simpleMessage(
            "Anzeigename konnte nicht gesetzt werden"),
        "Create": MessageLookupByLibrary.simpleMessage("Erstellen"),
        "Create account now":
            MessageLookupByLibrary.simpleMessage("Account jetzt erstellen"),
        "Create new group": MessageLookupByLibrary.simpleMessage("Neue Gruppe"),
        "Currently active":
            MessageLookupByLibrary.simpleMessage("Jetzt gerade online"),
        "Dark": MessageLookupByLibrary.simpleMessage("Dunkel"),
        "Delete": MessageLookupByLibrary.simpleMessage("Löschen"),
        "Delete message":
            MessageLookupByLibrary.simpleMessage("Nachricht löschen"),
        "Deny": MessageLookupByLibrary.simpleMessage("Ablehnen"),
        "Device": MessageLookupByLibrary.simpleMessage("Gerät"),
        "Devices": MessageLookupByLibrary.simpleMessage("Geräte"),
        "Discard picture":
            MessageLookupByLibrary.simpleMessage("Bild verwerfen"),
        "Displayname has been changed":
            MessageLookupByLibrary.simpleMessage("Anzeigename wurde geändert"),
        "Donate": MessageLookupByLibrary.simpleMessage("Spenden"),
        "Download file":
            MessageLookupByLibrary.simpleMessage("Datei herunterladen"),
        "Edit Jitsi instance":
            MessageLookupByLibrary.simpleMessage("Jitsi Instanz ändern"),
        "Edit displayname":
            MessageLookupByLibrary.simpleMessage("Anzeigename ändern"),
        "Emote Settings":
            MessageLookupByLibrary.simpleMessage("Emote Einstellungen"),
        "Emote shortcode": MessageLookupByLibrary.simpleMessage("Emote kürzel"),
        "Empty chat": MessageLookupByLibrary.simpleMessage("Leerer Chat"),
        "Encryption": MessageLookupByLibrary.simpleMessage("Verschlüsselung"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Verschlüsselungsalgorithmus"),
        "Encryption is not enabled": MessageLookupByLibrary.simpleMessage(
            "Verschlüsselung ist nicht aktiviert"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "Ende-zu-Ende-Verschlüsselung ist im Beta-Status. Benutzung auf eigene Gefahr!"),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "Ende-zu-Ende-Verschlüsselung"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("Gib einen Gruppennamen ein"),
        "Enter a username":
            MessageLookupByLibrary.simpleMessage("Gib einen Benutzernamen ein"),
        "Enter your homeserver":
            MessageLookupByLibrary.simpleMessage("Gib Deinen Homeserver ein"),
        "File name": MessageLookupByLibrary.simpleMessage("Dateiname"),
        "File size": MessageLookupByLibrary.simpleMessage("Dateigröße"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("Weiterleiten"),
        "Friday": MessageLookupByLibrary.simpleMessage("Freitag"),
        "From joining": MessageLookupByLibrary.simpleMessage("Ab dem Beitritt"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("Ab der Einladung"),
        "Group": MessageLookupByLibrary.simpleMessage("Gruppe"),
        "Group description":
            MessageLookupByLibrary.simpleMessage("Gruppenbeschreibung"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage(
                "Gruppenbeschreibung wurde geändert"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("Öffentliche Gruppe"),
        "Guests are forbidden":
            MessageLookupByLibrary.simpleMessage("Gäste sind verboten"),
        "Guests can join":
            MessageLookupByLibrary.simpleMessage("Gäste dürfen beitreten"),
        "Help": MessageLookupByLibrary.simpleMessage("Hilfe"),
        "Homeserver is not compatible": MessageLookupByLibrary.simpleMessage(
            "Homeserver ist nicht kompatibel"),
        "How are you today?":
            MessageLookupByLibrary.simpleMessage("Wie geht es dir heute?"),
        "ID": MessageLookupByLibrary.simpleMessage("ID"),
        "Identity": MessageLookupByLibrary.simpleMessage("Identität"),
        "Invite contact":
            MessageLookupByLibrary.simpleMessage("Kontakt einladen"),
        "Invited": MessageLookupByLibrary.simpleMessage("Eingeladen"),
        "Invited users only":
            MessageLookupByLibrary.simpleMessage("Nur eingeladene Benutzer"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(
                "Es sieht so aus als hättest du keine Google Dienste auf deinem Gerät. Das ist eine gute Entscheidung für deine Privatsphäre. Um Push Benachrichtigungen in FluffyChat zu erhalten, empfehlen wir die Verwendung von microG: https://microg.org/"),
        "Kick from chat":
            MessageLookupByLibrary.simpleMessage("Aus dem Chat hinauswerfen"),
        "Last seen IP":
            MessageLookupByLibrary.simpleMessage("Zuletzt bekannte IP"),
        "Leave": MessageLookupByLibrary.simpleMessage("Verlassen"),
        "Left the chat":
            MessageLookupByLibrary.simpleMessage("Hat den Chat verlassen"),
        "License": MessageLookupByLibrary.simpleMessage("Lizenz"),
        "Light": MessageLookupByLibrary.simpleMessage("Hell"),
        "Load more...": MessageLookupByLibrary.simpleMessage("Lade mehr ..."),
        "Loading... Please wait":
            MessageLookupByLibrary.simpleMessage("Lade ... Bitte warten"),
        "Login": MessageLookupByLibrary.simpleMessage("Login"),
        "Logout": MessageLookupByLibrary.simpleMessage("Abmelden"),
        "Make a moderator":
            MessageLookupByLibrary.simpleMessage("Zum Moderator ernennen"),
        "Make an admin":
            MessageLookupByLibrary.simpleMessage("Zum Admin ernennen"),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(
                "Gib bitte einen richtigen Benutzernamen ein"),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(
                "Nachricht wird für alle Teilnehmer*innen entfernt"),
        "Moderator": MessageLookupByLibrary.simpleMessage("Moderator"),
        "Monday": MessageLookupByLibrary.simpleMessage("Montag"),
        "Mute chat": MessageLookupByLibrary.simpleMessage("Stummschalten"),
        "New message in FluffyChat": MessageLookupByLibrary.simpleMessage(
            "Neue Nachricht in FluffyChat"),
        "New private chat":
            MessageLookupByLibrary.simpleMessage("Neuer privater Chat"),
        "No emotes found. 😕":
            MessageLookupByLibrary.simpleMessage("Keine Emotes gefunden. 😕"),
        "No permission":
            MessageLookupByLibrary.simpleMessage("Keine Berechtigung"),
        "No rooms found...":
            MessageLookupByLibrary.simpleMessage("Keine Räume gefunden ..."),
        "None": MessageLookupByLibrary.simpleMessage("Keiner"),
        "Not supported in web": MessageLookupByLibrary.simpleMessage(
            "Wird in der Web-Version nicht unterstützt"),
        "Oops something went wrong...": MessageLookupByLibrary.simpleMessage(
            "Hoppla! Da ist etwas schief gelaufen ..."),
        "Open app to read messages": MessageLookupByLibrary.simpleMessage(
            "Öffne app, um Nachrichten zu lesen"),
        "Open camera": MessageLookupByLibrary.simpleMessage("Kamera öffnen"),
        "Participating user devices":
            MessageLookupByLibrary.simpleMessage("Teilnehmende Geräte"),
        "Password": MessageLookupByLibrary.simpleMessage("Passwort"),
        "Pick image": MessageLookupByLibrary.simpleMessage("Wähle Bild"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(
                "Bitte beachte, dass du Pantalaimon brauchst, um Ende-zu-Ende-Verschlüsselung benutzen zu können."),
        "Please choose a username": MessageLookupByLibrary.simpleMessage(
            "Bitte wähle einen Benutzernamen"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage(
                "Bitte eine Matrix ID eingeben"),
        "Please enter your password": MessageLookupByLibrary.simpleMessage(
            "Bitte dein Passwort eingeben"),
        "Please enter your username": MessageLookupByLibrary.simpleMessage(
            "Bitte deinen Benutzernamen eingeben"),
        "Public Rooms":
            MessageLookupByLibrary.simpleMessage("Öffentliche Räume"),
        "Recording": MessageLookupByLibrary.simpleMessage("Aufnahme"),
        "Reject": MessageLookupByLibrary.simpleMessage("Ablehnen"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Wieder beitreten"),
        "Remove": MessageLookupByLibrary.simpleMessage("Entfernen"),
        "Remove all other devices": MessageLookupByLibrary.simpleMessage(
            "Alle anderen Geräte entfernen"),
        "Remove device":
            MessageLookupByLibrary.simpleMessage("Gerät entfernen"),
        "Remove exile":
            MessageLookupByLibrary.simpleMessage("Verbannung aufheben"),
        "Remove message":
            MessageLookupByLibrary.simpleMessage("Nachricht entfernen"),
        "Render rich message content": MessageLookupByLibrary.simpleMessage(
            "Zeige Nachrichtenformatierungen an"),
        "Reply": MessageLookupByLibrary.simpleMessage("Antworten"),
        "Request permission":
            MessageLookupByLibrary.simpleMessage("Berechtigung anfragen"),
        "Request to read older messages": MessageLookupByLibrary.simpleMessage(
            "Anfrage um ältere Nachrichten zu lesen"),
        "Revoke all permissions": MessageLookupByLibrary.simpleMessage(
            "Alle Berechtigungen zurücknehmen"),
        "Room has been upgraded":
            MessageLookupByLibrary.simpleMessage("Der Raum wurde ge-upgraded"),
        "Saturday": MessageLookupByLibrary.simpleMessage("Samstag"),
        "Search for a chat":
            MessageLookupByLibrary.simpleMessage("Chat suchen"),
        "Seen a long time ago": MessageLookupByLibrary.simpleMessage(
            "Vor sehr langer Zeit gesehen"),
        "Send": MessageLookupByLibrary.simpleMessage("Senden"),
        "Send a message":
            MessageLookupByLibrary.simpleMessage("Nachricht schreiben"),
        "Send file": MessageLookupByLibrary.simpleMessage("Datei senden"),
        "Send image": MessageLookupByLibrary.simpleMessage("Bild senden"),
        "Set a profile picture":
            MessageLookupByLibrary.simpleMessage("Ein Profilbild festlegen"),
        "Set group description": MessageLookupByLibrary.simpleMessage(
            "Gruppenbeschreibung festlegen"),
        "Set invitation link":
            MessageLookupByLibrary.simpleMessage("Einladungslink festlegen"),
        "Set status": MessageLookupByLibrary.simpleMessage("Status ändern"),
        "Settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "Share": MessageLookupByLibrary.simpleMessage("Teilen"),
        "Sign up": MessageLookupByLibrary.simpleMessage("Registrieren"),
        "Skip": MessageLookupByLibrary.simpleMessage("Überspringe"),
        "Source code": MessageLookupByLibrary.simpleMessage("Quellcode"),
        "Start your first chat :-)": MessageLookupByLibrary.simpleMessage(
            "Starte deinen ersten Chat :-)"),
        "Submit": MessageLookupByLibrary.simpleMessage("Absenden"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Sonntag"),
        "System": MessageLookupByLibrary.simpleMessage("System"),
        "Tap to show menu": MessageLookupByLibrary.simpleMessage(
            "Tippen, um das Menü anzuzeigen"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage(
                "Die Verschlüsselung wurde korrumpiert"),
        "They Don\'t Match":
            MessageLookupByLibrary.simpleMessage("Stimmen nicht überein"),
        "They Match": MessageLookupByLibrary.simpleMessage("Stimmen überein"),
        "This room has been archived.": MessageLookupByLibrary.simpleMessage(
            "Dieser Raum wurde archiviert."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Donnerstag"),
        "Try to send again":
            MessageLookupByLibrary.simpleMessage("Nochmal versuchen zu senden"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("Dienstag"),
        "Unblock Device":
            MessageLookupByLibrary.simpleMessage("Geräteblockierung aufheben"),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Unbekanntes Gerät"),
        "Unknown encryption algorithm": MessageLookupByLibrary.simpleMessage(
            "Unbekannter Verschlüsselungsalgorithmus"),
        "Unmute chat": MessageLookupByLibrary.simpleMessage("Stumm aus"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "Amoled optimierte Farben verwenden?"),
        "Username": MessageLookupByLibrary.simpleMessage("Benutzername"),
        "Verify": MessageLookupByLibrary.simpleMessage("Bestätigen"),
        "Verify User":
            MessageLookupByLibrary.simpleMessage("Verifiziere Benutzer"),
        "Video call": MessageLookupByLibrary.simpleMessage("Videoanruf"),
        "Visibility of the chat history": MessageLookupByLibrary.simpleMessage(
            "Sichtbarkeit des Chat-Verlaufs"),
        "Visible for all participants": MessageLookupByLibrary.simpleMessage(
            "Sichtbar für alle Teilnehmer*innen"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("Für jeden sichtbar"),
        "Voice message":
            MessageLookupByLibrary.simpleMessage("Sprachnachricht"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("Hintergrund"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("Mittwoch"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "Herzlich willkommen beim knuffigsten Instant Messenger im Matrix-Netwerk."),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage(
                "Wer darf der Gruppe beitreten"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("Schreibe eine Nachricht ..."),
        "Yes": MessageLookupByLibrary.simpleMessage("Ja"),
        "You": MessageLookupByLibrary.simpleMessage("Du"),
        "You are invited to this chat": MessageLookupByLibrary.simpleMessage(
            "Du wurdest eingeladen in diesen Chat"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(
                "Du bist kein Mitglied mehr in diesem Chat"),
        "You cannot invite yourself": MessageLookupByLibrary.simpleMessage(
            "Du kannst dich nicht selbst einladen"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage(
                "Du wurdest aus dem Chat verbannt"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "Du wirst die Verschlüsselung nicht mehr ausstellen können. Bist Du sicher?"),
        "Your own username":
            MessageLookupByLibrary.simpleMessage("Dein eigener Benutzername"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("Alias"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Bitte gib dein Secure-Store Passwort oder Wiederherstellungsschlüssel ein, um die Keys zu cachen."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Bitte gebe um die andere Person signieren zu können dein Secure-Store Passwort oder Wiederherstellungsschlüssel ein."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Bitte gebe um deine Session zu verifizieren dein Secure-Store Passwort oder Wiederherstellungsschlüssel ein."),
        "askVerificationRequest": m60,
        "bannedUser": m2,
        "byDefaultYouWillBeConnectedTo": m3,
        "cachedKeys":
            MessageLookupByLibrary.simpleMessage("Keys erfolgreich gecached!"),
        "changedTheChatAvatar": m4,
        "changedTheChatDescriptionTo": m5,
        "changedTheChatNameTo": m6,
        "changedTheChatPermissions": m7,
        "changedTheDisplaynameTo": m8,
        "changedTheGuestAccessRules": m9,
        "changedTheGuestAccessRulesTo": m10,
        "changedTheHistoryVisibility": m11,
        "changedTheHistoryVisibilityTo": m12,
        "changedTheJoinRules": m13,
        "changedTheJoinRulesTo": m14,
        "changedTheProfileAvatar": m15,
        "changedTheRoomAliases": m16,
        "changedTheRoomInvitationLink": m17,
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Vergleiche und stelle sicher, dass die folgenden Emoji mit denen des anderen Gerätes übereinstimmen:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Vergleiche und stelle sicher, dass die folgenden Zahlen mit denen des anderen Gerätes übereinstimmen:"),
        "couldNotDecryptMessage": m18,
        "countParticipants": m19,
        "createdTheChat": m20,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "Cross-Signing ist deaktiviert"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Cross-Signing ist aktiviert"),
        "dateAndTimeOfDay": m21,
        "dateWithYear": m22,
        "dateWithoutYear": m23,
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Emote existiert bereits!"),
        "emoteInvalid":
            MessageLookupByLibrary.simpleMessage("Ungültiges Emote-kürzel!"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Wähle ein Emote-kürzel und ein Bild!"),
        "groupWith": m24,
        "hasWithdrawnTheInvitationFor": m25,
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Falsches Passwort oder Wiederherstellungsschlüssel"),
        "inviteContactToGroup": m26,
        "inviteText": m27,
        "invitedUser": m28,
        "is typing...": MessageLookupByLibrary.simpleMessage("schreibt..."),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Ist der folgende Geräteschlüssel korrekt?"),
        "joinedTheChat": m29,
        "keysCached":
            MessageLookupByLibrary.simpleMessage("Keys sind gecached"),
        "keysMissing": MessageLookupByLibrary.simpleMessage("Keys fehlen"),
        "kicked": m30,
        "kickedAndBanned": m31,
        "lastActiveAgo": m32,
        "loadCountMoreParticipants": m33,
        "logInTo": m34,
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("Neue Verifikationsanfrage!"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat unterstützt noch nicht das Einschalten von Cross-Signing. Bitte schalte es innerhalb Riot an."),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat unterstützt noch nicht das Einschalten vom Online Key Backup. Bitte schalte es innerhalb Riot an."),
        "numberSelected": m35,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Online Key Backup ist deaktiviert"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Online Key Backup ist aktiviert"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Passwort oder Wiederherstellungsschlüssel"),
        "play": m36,
        "redactedAnEvent": m37,
        "rejectedTheInvitation": m38,
        "removedBy": m39,
        "seenByUser": m40,
        "seenByUserAndCountOthers": m41,
        "seenByUserAndUser": m42,
        "sentAFile": m43,
        "sentAPicture": m44,
        "sentASticker": m45,
        "sentAVideo": m46,
        "sentAnAudio": m47,
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Sitzung ist verifiziert"),
        "sharedTheLocation": m48,
        "timeOfDay": m49,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m50,
        "unknownEvent": m51,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Unbekannte Sitzung, bitte verifiziere diese"),
        "unreadChats": m52,
        "unreadMessages": m53,
        "unreadMessagesInChats": m54,
        "userAndOthersAreTyping": m55,
        "userAndUserAreTyping": m56,
        "userIsTyping": m57,
        "userLeftTheChat": m58,
        "userSentUnknownEvent": m59,
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Sitzung erfolgreich verifiziert!"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Verifiziere manuell"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Starte Verifikation"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Erfolgreich verifiziert!"),
        "verifyTitle": MessageLookupByLibrary.simpleMessage(
            "Verifiziere anderen Benutzer"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Warte darauf, dass der Partner die Verifikationsanfrage annimmt..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Warte darauf, dass der Partner die Emoji annimmt..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Warte darauf, dass der Partner die Zahlen annimmt...")
      };
}
