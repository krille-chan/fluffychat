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

  static m2(senderName) => "${senderName} hat den Anruf abgehoben";

  static m3(username) => "Diese Bestätigungsanfrage von ${username} annehmen?";

  static m4(username, targetName) => "${username} hat ${targetName} verbannt";

  static m5(homeserver) => "Standardmäßig wirst Du mit ${homeserver} verbunden";

  static m6(username) => "${username} hat den Chat-Avatar geändert";

  static m7(username, description) =>
      "${username} hat die Chat-Beschreibung geändert zu: „${description}“";

  static m8(username, chatname) =>
      "${username} hat den Chat-Namen geändert zu: „${chatname}“";

  static m9(username) => "${username} hat die Chat-Berechtigungen geändert";

  static m10(username, displayname) =>
      "${username} hat den Nicknamen geändert zu: ${displayname}";

  static m11(username) =>
      "${username} hat die Zugangsregeln für Gäste geändert";

  static m12(username, rules) =>
      "${username} hat die Zugangsregeln für Gäste geändert zu: ${rules}";

  static m13(username) =>
      "${username} hat die Sichtbarkeit des Chat-Verlaufs geändert";

  static m14(username, rules) =>
      "${username} hat die Sichtbarkeit des Chat-Verlaufs geändert zu: ${rules}";

  static m15(username) => "${username} hat die Zugangsregeln geändert";

  static m16(username, joinRules) =>
      "${username} hat die Zugangsregeln geändert zu: ${joinRules}";

  static m17(username) => "${username} hat das Profilbild geändert";

  static m18(username) => "${username} hat die Raum-Aliasse geändert";

  static m19(username) => "${username} hat den Einladungslink geändert";

  static m20(error) => "Nachricht konnte nicht entschlüsselt werden: ${error}";

  static m21(count) => "${count} Teilnehmer*innen";

  static m22(username) => "${username} hat den Chat erstellt";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${day}. ${month}. ${year}";

  static m25(month, day) => "${day}. ${month}";

  static m26(senderName) => "${senderName} hat den Anruf aufgelegt";

  static m27(displayname) => "Gruppe mit ${displayname}";

  static m28(username, targetName) =>
      "${username} hat die Einladung für ${targetName} zurückgezogen";

  static m29(groupName) => "Kontakt in die Gruppe ${groupName} einladen";

  static m30(username, link) =>
      "${username} hat Dich zu FluffyChat eingeladen. \n1. Installiere FluffyChat: https://fluffychat.im \n2. Melde Dich in der App an \n3. Öffne den Einladungslink: ${link}";

  static m31(username, targetName) =>
      "${username} hat ${targetName} eingeladen";

  static m32(username) => "${username} ist dem Chat beigetreten";

  static m33(username, targetName) =>
      "${username} hat ${targetName} hinausgeworfen";

  static m34(username, targetName) =>
      "${username} hat ${targetName} hinausgeworfen und verbannt";

  static m35(localizedTimeShort) => "Zuletzt aktiv: ${localizedTimeShort}";

  static m36(count) => "${count} weitere Teilnehmer*innen laden";

  static m37(homeserver) => "Bei ${homeserver} anmelden";

  static m38(number) => "${number} ausgewählt";

  static m39(fileName) => "${fileName} abspielen";

  static m40(username) => "${username} hat ein Event entfernt";

  static m41(username) => "${username} hat die Einladung abgelehnt";

  static m42(username) => "Entfernt von ${username}";

  static m43(username) => "Gelesen von ${username}";

  static m44(username, count) => "Gelesen von ${username} und ${count} anderen";

  static m45(username, username2) => "Gelesen von ${username} und ${username2}";

  static m46(username) => "${username} hat eine Datei gesendet";

  static m47(username) => "${username} hat ein Bild gesendet";

  static m48(username) => "${username} hat einen Sticker gesendet";

  static m49(username) => "${username} hat ein Video gesendet";

  static m50(username) => "${username} hat eine Audio-Datei gesendet";

  static m51(senderName) => "${senderName} hat Anrufinformationen geschickt";

  static m52(username) => "${username} hat den Standort geteilt";

  static m53(senderName) => "${senderName} hat einen Anruf getätigt";

  static m54(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m55(username, targetName) =>
      "${username} hat die Verbannung von ${targetName} aufgehoben";

  static m56(type) => "Unbekanntes Ereignis \'${type}\'";

  static m57(unreadCount) => "${unreadCount} ungelesene Unterhaltungen";

  static m58(unreadEvents) => "${unreadEvents} ungelesene Nachrichten";

  static m59(unreadEvents, unreadChats) =>
      "${unreadEvents} ungelesene Nachrichten in ${unreadChats} Chats";

  static m60(username, count) => "${username} und ${count} andere schreiben...";

  static m61(username, username2) =>
      "${username} und ${username2} schreiben...";

  static m62(username) => "${username} schreibt ...";

  static m63(username) => "${username} hat den Chat verlassen";

  static m64(username, type) => "${username} hat ${type} Event gesendet";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("Über"),
        "accept": MessageLookupByLibrary.simpleMessage("Annehmen"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Konto"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Kontoinformationen"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription": MessageLookupByLibrary.simpleMessage(
            "Eine Beschreibung für die Gruppe hinzufügen"),
        "admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "alias": MessageLookupByLibrary.simpleMessage("Alias"),
        "alreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage(
            "Hast du schon einen Account?"),
        "answeredTheCall": m2,
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("Jeder darf beitreten"),
        "archive": MessageLookupByLibrary.simpleMessage("Archiv"),
        "archivedRoom":
            MessageLookupByLibrary.simpleMessage("Archivierter Raum"),
        "areGuestsAllowedToJoin": MessageLookupByLibrary.simpleMessage(
            "Dürfen Gast-Benutzer beitreten"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Bist Du sicher?"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Bitte gib dein Secure-Store Passwort oder Wiederherstellungsschlüssel ein, um die Keys zu cachen."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Bitte gebe um die andere Person signieren zu können dein Secure-Store Passwort oder Wiederherstellungsschlüssel ein."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Bitte gebe um deine Session zu verifizieren dein Secure-Store Passwort oder Wiederherstellungsschlüssel ein."),
        "askVerificationRequest": m3,
        "authentication":
            MessageLookupByLibrary.simpleMessage("Authentifizierung"),
        "avatarHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Avatar wurde geändert"),
        "banFromChat":
            MessageLookupByLibrary.simpleMessage("Aus dem Chat verbannen"),
        "banned": MessageLookupByLibrary.simpleMessage("Verbannt"),
        "bannedUser": m4,
        "blockDevice": MessageLookupByLibrary.simpleMessage("Blockiere Gerät"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys":
            MessageLookupByLibrary.simpleMessage("Keys erfolgreich gecached!"),
        "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "changeTheHomeserver": MessageLookupByLibrary.simpleMessage(
            "Anderen Homeserver verwenden"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("Gruppenname ändern"),
        "changeTheServer":
            MessageLookupByLibrary.simpleMessage("Ändere den Server"),
        "changeTheme":
            MessageLookupByLibrary.simpleMessage("Ändere Deinen Style"),
        "changeWallpaper":
            MessageLookupByLibrary.simpleMessage("Hintergrund ändern"),
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
        "changelog":
            MessageLookupByLibrary.simpleMessage("Protokoll der Änderungen"),
        "changesHaveBeenSaved": MessageLookupByLibrary.simpleMessage(
            "Änderungen wurden gespeichert"),
        "channelCorruptedDecryptError": MessageLookupByLibrary.simpleMessage(
            "Die Verschlüsselung wurde korrumpiert"),
        "chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "chatDetails": MessageLookupByLibrary.simpleMessage("Gruppeninfo"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("Wähle ein sicheres Passwort"),
        "chooseAUsername":
            MessageLookupByLibrary.simpleMessage("Wähle einen Benutzernamen"),
        "close": MessageLookupByLibrary.simpleMessage("Schließen"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Vergleiche und stelle sicher, dass die folgenden Emoji mit denen des anderen Gerätes übereinstimmen:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Vergleiche und stelle sicher, dass die folgenden Zahlen mit denen des anderen Gerätes übereinstimmen:"),
        "confirm": MessageLookupByLibrary.simpleMessage("Bestätigen"),
        "connect": MessageLookupByLibrary.simpleMessage("Verbinden"),
        "connectionAttemptFailed": MessageLookupByLibrary.simpleMessage(
            "Verbindungsversuch fehlgeschlagen"),
        "contactHasBeenInvitedToTheGroup": MessageLookupByLibrary.simpleMessage(
            "Kontakt wurde in die Gruppe eingeladen"),
        "contentViewer": MessageLookupByLibrary.simpleMessage("Content Viewer"),
        "copiedToClipboard": MessageLookupByLibrary.simpleMessage(
            "Wurde in die Zwischenablage kopiert"),
        "copy": MessageLookupByLibrary.simpleMessage("Kopieren"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar": MessageLookupByLibrary.simpleMessage(
            "Profilbild konnte nicht gesetzt werden"),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(
            "Anzeigename konnte nicht gesetzt werden"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Erstellen"),
        "createAccountNow":
            MessageLookupByLibrary.simpleMessage("Account jetzt erstellen"),
        "createNewGroup": MessageLookupByLibrary.simpleMessage("Neue Gruppe"),
        "createdTheChat": m22,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "Cross-Signing ist deaktiviert"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Cross-Signing ist aktiviert"),
        "currentlyActive":
            MessageLookupByLibrary.simpleMessage("Jetzt gerade online"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Dunkel"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "delete": MessageLookupByLibrary.simpleMessage("Löschen"),
        "deleteMessage":
            MessageLookupByLibrary.simpleMessage("Nachricht löschen"),
        "deny": MessageLookupByLibrary.simpleMessage("Ablehnen"),
        "device": MessageLookupByLibrary.simpleMessage("Gerät"),
        "devices": MessageLookupByLibrary.simpleMessage("Geräte"),
        "discardPicture":
            MessageLookupByLibrary.simpleMessage("Bild verwerfen"),
        "displaynameHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Anzeigename wurde geändert"),
        "donate": MessageLookupByLibrary.simpleMessage("Spenden"),
        "downloadFile":
            MessageLookupByLibrary.simpleMessage("Datei herunterladen"),
        "editDisplayname":
            MessageLookupByLibrary.simpleMessage("Anzeigename ändern"),
        "editJitsiInstance":
            MessageLookupByLibrary.simpleMessage("Jitsi-Instanz ändern"),
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Emote existiert bereits!"),
        "emoteInvalid":
            MessageLookupByLibrary.simpleMessage("Ungültiges Emote-Kürzel!"),
        "emoteSettings":
            MessageLookupByLibrary.simpleMessage("Emote-Einstellungen"),
        "emoteShortcode": MessageLookupByLibrary.simpleMessage("Emote-Kürzel"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Wähle ein Emote-Kürzel und ein Bild!"),
        "emptyChat": MessageLookupByLibrary.simpleMessage("Leerer Chat"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "Du wirst die Verschlüsselung nicht mehr ausstellen können. Bist Du sicher?"),
        "encryption": MessageLookupByLibrary.simpleMessage("Verschlüsselung"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Verschlüsselungsalgorithmus"),
        "encryptionNotEnabled": MessageLookupByLibrary.simpleMessage(
            "Verschlüsselung ist nicht aktiviert"),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "Ende-zu-Ende-Verschlüsselung"),
        "endedTheCall": m26,
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("Gib einen Gruppennamen ein"),
        "enterAUsername":
            MessageLookupByLibrary.simpleMessage("Gib einen Benutzernamen ein"),
        "enterYourHomeserver":
            MessageLookupByLibrary.simpleMessage("Gib Deinen Homeserver ein"),
        "fileName": MessageLookupByLibrary.simpleMessage("Dateiname"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Dateigröße"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("Weiterleiten"),
        "friday": MessageLookupByLibrary.simpleMessage("Freitag"),
        "fromJoining": MessageLookupByLibrary.simpleMessage("Ab dem Beitritt"),
        "fromTheInvitation":
            MessageLookupByLibrary.simpleMessage("Ab der Einladung"),
        "group": MessageLookupByLibrary.simpleMessage("Gruppe"),
        "groupDescription":
            MessageLookupByLibrary.simpleMessage("Gruppenbeschreibung"),
        "groupDescriptionHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "Gruppenbeschreibung wurde geändert"),
        "groupIsPublic":
            MessageLookupByLibrary.simpleMessage("Öffentliche Gruppe"),
        "groupWith": m27,
        "guestsAreForbidden":
            MessageLookupByLibrary.simpleMessage("Gäste sind verboten"),
        "guestsCanJoin":
            MessageLookupByLibrary.simpleMessage("Gäste dürfen beitreten"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Hilfe"),
        "homeserverIsNotCompatible": MessageLookupByLibrary.simpleMessage(
            "Homeserver ist nicht kompatibel"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "identity": MessageLookupByLibrary.simpleMessage("Identität"),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Falsches Passwort oder Wiederherstellungsschlüssel"),
        "inviteContact":
            MessageLookupByLibrary.simpleMessage("Kontakt einladen"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("Eingeladen"),
        "invitedUser": m31,
        "invitedUsersOnly":
            MessageLookupByLibrary.simpleMessage("Nur eingeladene Benutzer"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Ist der folgende Geräteschlüssel korrekt?"),
        "isTyping": MessageLookupByLibrary.simpleMessage("schreibt..."),
        "joinRoom": MessageLookupByLibrary.simpleMessage("Raum beitreten"),
        "joinedTheChat": m32,
        "keysCached":
            MessageLookupByLibrary.simpleMessage("Keys sind gecached"),
        "keysMissing": MessageLookupByLibrary.simpleMessage("Keys fehlen"),
        "kickFromChat":
            MessageLookupByLibrary.simpleMessage("Aus dem Chat hinauswerfen"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp":
            MessageLookupByLibrary.simpleMessage("Letzte bekannte IP"),
        "lastSeenLongTimeAgo": MessageLookupByLibrary.simpleMessage(
            "Vor sehr langer Zeit gesehen"),
        "leave": MessageLookupByLibrary.simpleMessage("Verlassen"),
        "leftTheChat":
            MessageLookupByLibrary.simpleMessage("Hat den Chat verlassen"),
        "license": MessageLookupByLibrary.simpleMessage("Lizenz"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Hell"),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage("Lade mehr..."),
        "loadingPleaseWait":
            MessageLookupByLibrary.simpleMessage("Lade... Bitte warten"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Abmelden"),
        "makeAModerator":
            MessageLookupByLibrary.simpleMessage("Zum Moderator ernennen"),
        "makeAnAdmin":
            MessageLookupByLibrary.simpleMessage("Zum Admin ernennen"),
        "makeSureTheIdentifierIsValid": MessageLookupByLibrary.simpleMessage(
            "Gib bitte einen richtigen Benutzernamen ein"),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "Nachricht wird für alle Teilnehmer*innen entfernt"),
        "moderator": MessageLookupByLibrary.simpleMessage("Moderator"),
        "monday": MessageLookupByLibrary.simpleMessage("Montag"),
        "muteChat": MessageLookupByLibrary.simpleMessage("Stummschalten"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(
            "Bitte beachte, dass du Pantalaimon brauchst, um Ende-zu-Ende-Verschlüsselung benutzen zu können."),
        "newMessageInFluffyChat": MessageLookupByLibrary.simpleMessage(
            "Neue Nachricht in FluffyChat"),
        "newPrivateChat":
            MessageLookupByLibrary.simpleMessage("Neuer privater Chat"),
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("Neue Verifikationsanfrage!"),
        "no": MessageLookupByLibrary.simpleMessage("Nein"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat kann Cross-Signing noch nicht einschalten. Bitte schalte es innerhalb Element an."),
        "noEmotesFound":
            MessageLookupByLibrary.simpleMessage("Keine Emotes gefunden. 😕"),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "Es sieht so aus als hättest du keine Google-Dienste auf deinem Gerät. Das ist eine gute Entscheidung für deine Privatsphäre! Um Push Benachrichtigungen in FluffyChat zu erhalten, empfehlen wir die Verwendung von microG: https://microg.org/"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat kann das Online-Schlüssel-Backup noch nicht aktivieren. Bitte schalte es innerhalb von Element an."),
        "noPermission":
            MessageLookupByLibrary.simpleMessage("Keine Berechtigung"),
        "noRoomsFound":
            MessageLookupByLibrary.simpleMessage("Keine Räume gefunden..."),
        "none": MessageLookupByLibrary.simpleMessage("Keiner"),
        "notSupportedInWeb": MessageLookupByLibrary.simpleMessage(
            "Wird in der Web-Version nicht unterstützt"),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Online Key Backup ist deaktiviert"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Online Key Backup ist aktiviert"),
        "oopsSomethingWentWrong": MessageLookupByLibrary.simpleMessage(
            "Hoppla! Da ist etwas schief gelaufen ..."),
        "openAppToReadMessages": MessageLookupByLibrary.simpleMessage(
            "App öffnen, um Nachrichten zu lesen"),
        "openCamera": MessageLookupByLibrary.simpleMessage("Kamera öffnen"),
        "optionalGroupName": MessageLookupByLibrary.simpleMessage(
            "(Optional) Name für die Gruppe"),
        "participatingUserDevices":
            MessageLookupByLibrary.simpleMessage("Teilnehmende Geräte"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Passwort oder Wiederherstellungsschlüssel"),
        "password": MessageLookupByLibrary.simpleMessage("Passwort"),
        "pickImage": MessageLookupByLibrary.simpleMessage("Bild wählen"),
        "pin": MessageLookupByLibrary.simpleMessage("Anpinnen"),
        "play": m39,
        "pleaseChooseAUsername": MessageLookupByLibrary.simpleMessage(
            "Bitte wähle einen Benutzernamen"),
        "pleaseEnterAMatrixIdentifier": MessageLookupByLibrary.simpleMessage(
            "Bitte eine Matrix ID eingeben"),
        "pleaseEnterYourPassword": MessageLookupByLibrary.simpleMessage(
            "Bitte dein Passwort eingeben"),
        "pleaseEnterYourUsername": MessageLookupByLibrary.simpleMessage(
            "Bitte deinen Benutzernamen eingeben"),
        "publicRooms":
            MessageLookupByLibrary.simpleMessage("Öffentliche Räume"),
        "recording": MessageLookupByLibrary.simpleMessage("Aufnahme"),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("Ablehnen"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("Wieder beitreten"),
        "remove": MessageLookupByLibrary.simpleMessage("Entfernen"),
        "removeAllOtherDevices": MessageLookupByLibrary.simpleMessage(
            "Alle anderen Geräte entfernen"),
        "removeDevice": MessageLookupByLibrary.simpleMessage("Gerät entfernen"),
        "removeExile":
            MessageLookupByLibrary.simpleMessage("Verbannung aufheben"),
        "removeMessage":
            MessageLookupByLibrary.simpleMessage("Nachricht entfernen"),
        "removedBy": m42,
        "renderRichContent": MessageLookupByLibrary.simpleMessage(
            "Zeige Nachrichtenformatierungen an"),
        "reply": MessageLookupByLibrary.simpleMessage("Antworten"),
        "requestPermission":
            MessageLookupByLibrary.simpleMessage("Berechtigung anfragen"),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(
            "Anfrage um ältere Nachrichten zu lesen"),
        "revokeAllPermissions": MessageLookupByLibrary.simpleMessage(
            "Alle Berechtigungen zurücknehmen"),
        "roomHasBeenUpgraded":
            MessageLookupByLibrary.simpleMessage("Der Raum wurde ge-upgraded"),
        "saturday": MessageLookupByLibrary.simpleMessage("Samstag"),
        "searchForAChat": MessageLookupByLibrary.simpleMessage("Chat suchen"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("Senden"),
        "sendAMessage":
            MessageLookupByLibrary.simpleMessage("Nachricht schreiben"),
        "sendAudio": MessageLookupByLibrary.simpleMessage("Sende Audiodatei"),
        "sendBugReports": MessageLookupByLibrary.simpleMessage(
            "Erlaube das Senden von Fehlermeldungen via sentry.io"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Datei senden"),
        "sendImage": MessageLookupByLibrary.simpleMessage("Bild senden"),
        "sendOriginal": MessageLookupByLibrary.simpleMessage("Sende Original"),
        "sendVideo": MessageLookupByLibrary.simpleMessage("Sende Video"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sentryInfo": MessageLookupByLibrary.simpleMessage(
            "Information über deine Privatsphäre: https://sentry.io/security/"),
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Sitzung ist verifiziert"),
        "setAProfilePicture":
            MessageLookupByLibrary.simpleMessage("Ein Profilbild festlegen"),
        "setGroupDescription": MessageLookupByLibrary.simpleMessage(
            "Gruppenbeschreibung festlegen"),
        "setInvitationLink":
            MessageLookupByLibrary.simpleMessage("Einladungslink festlegen"),
        "setStatus": MessageLookupByLibrary.simpleMessage("Status ändern"),
        "settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "share": MessageLookupByLibrary.simpleMessage("Teilen"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("Registrieren"),
        "skip": MessageLookupByLibrary.simpleMessage("Überspringe"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Quellcode"),
        "startYourFirstChat": MessageLookupByLibrary.simpleMessage(
            "Starte deinen ersten Chat :-)"),
        "startedACall": m53,
        "statusExampleMessage":
            MessageLookupByLibrary.simpleMessage("Wie geht es dir heute?"),
        "submit": MessageLookupByLibrary.simpleMessage("Absenden"),
        "sunday": MessageLookupByLibrary.simpleMessage("Sonntag"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("System"),
        "tapToShowMenu": MessageLookupByLibrary.simpleMessage(
            "Tippen, um das Menü anzuzeigen"),
        "theyDontMatch":
            MessageLookupByLibrary.simpleMessage("Stimmen nicht überein"),
        "theyMatch": MessageLookupByLibrary.simpleMessage("Stimmen überein"),
        "thisRoomHasBeenArchived": MessageLookupByLibrary.simpleMessage(
            "Dieser Raum wurde archiviert."),
        "thursday": MessageLookupByLibrary.simpleMessage("Donnerstag"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain":
            MessageLookupByLibrary.simpleMessage("Nochmal versuchen zu senden"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Dienstag"),
        "unbannedUser": m55,
        "unblockDevice":
            MessageLookupByLibrary.simpleMessage("Geräteblockierung aufheben"),
        "unknownDevice":
            MessageLookupByLibrary.simpleMessage("Unbekanntes Gerät"),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(
            "Unbekannter Verschlüsselungsalgorithmus"),
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Unbekannte Sitzung, bitte verifiziere diese"),
        "unmuteChat": MessageLookupByLibrary.simpleMessage("Stumm aus"),
        "unpin": MessageLookupByLibrary.simpleMessage("Abpinnen"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(
            "Amoled optimierte Farben verwenden?"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("Benutzername"),
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Sitzung erfolgreich verifiziert!"),
        "verify": MessageLookupByLibrary.simpleMessage("Bestätigen"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Verifiziere manuell"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Starte Verifikation"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Erfolgreich verifiziert!"),
        "verifyTitle": MessageLookupByLibrary.simpleMessage(
            "Verifiziere anderen Benutzer"),
        "verifyUser":
            MessageLookupByLibrary.simpleMessage("Verifiziere Benutzer"),
        "videoCall": MessageLookupByLibrary.simpleMessage("Videoanruf"),
        "visibilityOfTheChatHistory": MessageLookupByLibrary.simpleMessage(
            "Sichtbarkeit des Chat-Verlaufs"),
        "visibleForAllParticipants": MessageLookupByLibrary.simpleMessage(
            "Sichtbar für alle Teilnehmer*innen"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("Für jeden sichtbar"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("Sprachnachricht"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Warte darauf, dass der Partner die Verifikationsanfrage annimmt..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Warte darauf, dass der Partner die Emoji annimmt..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Warte darauf, dass der Partner die Zahlen annimmt..."),
        "wallpaper": MessageLookupByLibrary.simpleMessage("Hintergrund"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "Ende-zu-Ende-Verschlüsselung ist im Beta-Status. Benutzung auf eigene Gefahr!"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Mittwoch"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Herzlich willkommen beim knuffigsten Instant Messenger im Matrix-Netwerk."),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(
            "Wer darf der Gruppe beitreten"),
        "writeAMessage":
            MessageLookupByLibrary.simpleMessage("Schreibe eine Nachricht ..."),
        "yes": MessageLookupByLibrary.simpleMessage("Ja"),
        "you": MessageLookupByLibrary.simpleMessage("Du"),
        "youAreInvitedToThisChat": MessageLookupByLibrary.simpleMessage(
            "Du wurdest in diesen Chat eingeladen"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(
                "Du bist kein Mitglied mehr in diesem Chat"),
        "youCannotInviteYourself": MessageLookupByLibrary.simpleMessage(
            "Du kannst dich nicht selbst einladen"),
        "youHaveBeenBannedFromThisChat": MessageLookupByLibrary.simpleMessage(
            "Du wurdest aus dem Chat verbannt"),
        "yourOwnUsername":
            MessageLookupByLibrary.simpleMessage("Dein eigener Benutzername")
      };
}
