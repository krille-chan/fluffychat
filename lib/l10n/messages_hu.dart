// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a hu locale. All the
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
  String get localeName => 'hu';

  static m0(username) => "${username} elfogadta a meghívást";

  static m1(username) =>
      "${username} aktiválta a végpontól-végpontig titkosítást";

  static m3(username) => "Elfogadod ${username} hitelesítési kérelmét?";

  static m4(username, targetName) => "${username} kitiltotta ${targetName}-t";

  static m5(homeserver) => "Alapértelmezésben ${homeserver}-hoz csatlakozol";

  static m6(username) => "${username} módosította a csevegés képét";

  static m7(username, description) =>
      "${username} módosította a csevegés leírását erre: \'${description}\'";

  static m8(username, chatname) =>
      "${username} módosította a csevegés nevét erre: \'${chatname}\'";

  static m9(username) => "${username} módosította a csevegési enegedélyeket";

  static m10(username, displayname) =>
      "${username} módosította a megjenelítési nevét erre: ${displayname}";

  static m11(username) =>
      "${username} módosította a vendégek hozzáférési jogait";

  static m12(username, rules) =>
      "${username} módosította a vendégek hozzáférési jogait, így: ${rules}";

  static m13(username) =>
      "${username} módosította a múltbéli események láthatóságát";

  static m14(username, rules) =>
      "${username} módosította a múltbéli események láthatóságát, így: ${rules}";

  static m15(username) => "${username} módosított a csatlakozási szabályokat";

  static m16(username, joinRules) =>
      "${username} módosította a csatlakozási szabályokat, így: ${joinRules}";

  static m17(username) => "${username} módosította a profil képét";

  static m18(username) => "${username} módosítottaa szoba álnevét";

  static m19(username) => "${username} módosította a meghívó linket";

  static m20(error) =>
      "Nem sikerült visszafejteni a titkosított üzenetet: ${error}";

  static m21(count) => "${count} résztvevő";

  static m22(username) => "${username} létrehozta a csevegést";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${year}-${month}-${day}";

  static m25(month, day) => "${month}-${day}";

  static m27(displayname) => "Csoport ${displayname}-vel";

  static m28(username, targetName) =>
      "${username} visszavonta ${targetName} meghívását";

  static m29(groupName) => "Ismerős meghívása a ${groupName} csoportba";

  static m30(username, link) =>
      "${username} meghívott a FluffyChatre. \n1. FluffyChat telepítése: https://fluffychat.im \n2. Jelentkezz be vagy regisztrálj. \n3. Nyisd meg a meghívó linket: ${link}";

  static m31(username, targetName) => "${username} meghívta ${targetName}-t";

  static m32(username) => "${username} csatalakozott a csevegéshez";

  static m33(username, targetName) => "${username} kirúgta ${targetName}-t";

  static m34(username, targetName) =>
      "${username} kirúgta és kitiltotta ${targetName}-t";

  static m35(localizedTimeShort) => "Utoljára aktív: ${localizedTimeShort}";

  static m36(count) => "További ${count} résztvevő betöltése";

  static m37(homeserver) => "Bejelentkezés ${homeserver} Matrix szerverre";

  static m38(number) => "${number} kijelölve";

  static m39(fileName) => "${fileName} lejátszása";

  static m40(username) => "${username} visszavont egy eseményt";

  static m41(username) => "${username} elutasította a meghívást";

  static m42(username) => "Törölve ${username} által";

  static m43(username) => "${username} látta";

  static m44(username, count) =>
      "${username} és ${count} másik résztvevő látta";

  static m45(username, username2) => "${username} és ${username2} látta";

  static m46(username) => "${username} fájlt küldött";

  static m47(username) => "${username} képet küldött";

  static m48(username) => "${username} matricát küldött";

  static m49(username) => "${username} videót küldött";

  static m50(username) => "${username} hangüzenetet küldött";

  static m52(username) => "${username} megosztotta a pozícióját";

  static m54(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m55(username, targetName) =>
      "${username} feloldotta ${targetName} kitiltását";

  static m56(type) => "Ismeretlen esemény \'${type}\'";

  static m57(unreadCount) => "${unreadCount} olvasatlan üzenet";

  static m58(unreadEvents) => "${unreadEvents} olvasatlan üzenet";

  static m59(unreadEvents, unreadChats) =>
      "${unreadEvents} olvastlan üzenet van ${unreadChats}-ban";

  static m60(username, count) =>
      "${username} és ${count} másik résztvevő gépel...";

  static m61(username, username2) => "${username} és ${username2} gépel...";

  static m62(username) => "${username} gépel...";

  static m63(username) => "${username} elhagyta a csevegést";

  static m64(username, type) => "${username} ${type} eseményt küldött";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("Névjegy"),
        "accept": MessageLookupByLibrary.simpleMessage("Elfogad"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Fiók"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Fiók információk"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription":
            MessageLookupByLibrary.simpleMessage("Csoport leírás hozzáadása"),
        "admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "alias": MessageLookupByLibrary.simpleMessage("álnév"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Van már fiókod?"),
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("Bárki csatlakozhat"),
        "archive": MessageLookupByLibrary.simpleMessage("Archív"),
        "archivedRoom": MessageLookupByLibrary.simpleMessage("Archivált szoba"),
        "areGuestsAllowedToJoin": MessageLookupByLibrary.simpleMessage(
            "Csatlakozhatnak vendég felhasználók"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Biztos?"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Add meg a biztonságos tárolóhoz tartozó vagy a visszaállítási jelszavadat, hogy betöltsük a kulcsaidat."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "A másik személy igazolásához, kérlek add meg jelszavadat vagy visszaállítási kulcsodat."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Add meg a biztonságos tárolóhoz tartozó vagy a visszaállítási jelszavadat, a munkamenet hitelesítéséhez."),
        "askVerificationRequest": m3,
        "authentication": MessageLookupByLibrary.simpleMessage("Hitelesítés"),
        "avatarHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Az avatar megváltozott"),
        "banFromChat":
            MessageLookupByLibrary.simpleMessage("Csevegésből kitiltás"),
        "banned": MessageLookupByLibrary.simpleMessage("Kitiltva"),
        "bannedUser": m4,
        "blockDevice":
            MessageLookupByLibrary.simpleMessage("Eszköz blokkolása"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Sikeresen betöltöttük a kulcsokat!"),
        "cancel": MessageLookupByLibrary.simpleMessage("Mégsem"),
        "changeTheHomeserver":
            MessageLookupByLibrary.simpleMessage("Matrix szerver váltás"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("Csoport nevének módosítása"),
        "changeTheServer":
            MessageLookupByLibrary.simpleMessage("Szerver módosítás"),
        "changeTheme":
            MessageLookupByLibrary.simpleMessage("Stílus módosítása"),
        "changeWallpaper":
            MessageLookupByLibrary.simpleMessage("Háttér módosítása"),
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
        "changelog": MessageLookupByLibrary.simpleMessage("Változás napló"),
        "channelCorruptedDecryptError": MessageLookupByLibrary.simpleMessage(
            "A titkosítás sérült és megbízhatatlan"),
        "chat": MessageLookupByLibrary.simpleMessage("Csevegés"),
        "chatDetails":
            MessageLookupByLibrary.simpleMessage("Csevegés részletei"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("Válassz egy erős jelszót"),
        "chooseAUsername": MessageLookupByLibrary.simpleMessage(
            "Válassz egy felhasználónevet"),
        "close": MessageLookupByLibrary.simpleMessage("Bezárás"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Hasonlítsd össze a hangulatjeleket a másik eszközön lévőkkel:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Hasonlítsd össze a számokat a másik eszközön lévőkkel:"),
        "confirm": MessageLookupByLibrary.simpleMessage("Megerősítés"),
        "connect": MessageLookupByLibrary.simpleMessage("Csatlakozás"),
        "connectionAttemptFailed": MessageLookupByLibrary.simpleMessage(
            "Csatlakozási kísérlet meghiusult"),
        "contactHasBeenInvitedToTheGroup": MessageLookupByLibrary.simpleMessage(
            "Meghívtad ismerősödet a csoportba"),
        "contentViewer":
            MessageLookupByLibrary.simpleMessage("Tartalom nézegető"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Vágólapra másolva"),
        "copy": MessageLookupByLibrary.simpleMessage("Másolás"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar": MessageLookupByLibrary.simpleMessage(
            "Nem sikerült beállítani a képet"),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(
            "Nem sikerült beállítani a megjelenítési nevet"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Létrehozás"),
        "createAccountNow":
            MessageLookupByLibrary.simpleMessage("Új fiók létrehozása"),
        "createNewGroup":
            MessageLookupByLibrary.simpleMessage("Új csoport létrehozása"),
        "createdTheChat": m22,
        "crossSigningDisabled":
            MessageLookupByLibrary.simpleMessage("Kereszt-Aláírás kikapcsolva"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Kereszt-Aláírás bekapcsolva"),
        "currentlyActive":
            MessageLookupByLibrary.simpleMessage("Jelenleg aktív"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Sötét"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "delete": MessageLookupByLibrary.simpleMessage("Törlés"),
        "deleteMessage": MessageLookupByLibrary.simpleMessage("Üzenet törlése"),
        "deny": MessageLookupByLibrary.simpleMessage("Elutasítás"),
        "device": MessageLookupByLibrary.simpleMessage("Eszköz"),
        "devices": MessageLookupByLibrary.simpleMessage("Eszközök"),
        "discardPicture": MessageLookupByLibrary.simpleMessage("Kép elvetése"),
        "displaynameHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "Megjelenítési név megváltozott"),
        "donate": MessageLookupByLibrary.simpleMessage("Támogatom"),
        "downloadFile": MessageLookupByLibrary.simpleMessage("File letöltése"),
        "editDisplayname": MessageLookupByLibrary.simpleMessage(
            "Megjelenítési név módosítása"),
        "editJitsiInstance":
            MessageLookupByLibrary.simpleMessage("Jitsi példány módosítása"),
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("A hangulatjel már létezik!"),
        "emoteInvalid":
            MessageLookupByLibrary.simpleMessage("Érvénytelen rövid kód!"),
        "emoteSettings":
            MessageLookupByLibrary.simpleMessage("Hangulatjel beállítások"),
        "emoteShortcode":
            MessageLookupByLibrary.simpleMessage("Rövid kód a hangulatjelhez"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "A hangulatjelhez válassz egy képet és egy rövid kód"),
        "emptyChat": MessageLookupByLibrary.simpleMessage("Üres csevegés"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "Többé nem tudod kikapcsolni a titkosítás. Biztosan folytatod?"),
        "encryption": MessageLookupByLibrary.simpleMessage("Titkosítás"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Titkosítási algoritmus"),
        "encryptionNotEnabled": MessageLookupByLibrary.simpleMessage(
            "Titkosítás nincs engedélyezve"),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "Végpontól-végpontig titkosítás beállításai"),
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("Adj meg egy csoport nevet"),
        "enterAUsername": MessageLookupByLibrary.simpleMessage(
            "Adj meg egy felhasználónevet"),
        "enterYourHomeserver": MessageLookupByLibrary.simpleMessage(
            "Add meg a Matrix szervered nevét"),
        "fileName": MessageLookupByLibrary.simpleMessage("Fájl név"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Fájl méret"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("Továbbítás"),
        "friday": MessageLookupByLibrary.simpleMessage("Péntek"),
        "fromJoining": MessageLookupByLibrary.simpleMessage("Belépés óta"),
        "fromTheInvitation":
            MessageLookupByLibrary.simpleMessage("Meghívás óta"),
        "group": MessageLookupByLibrary.simpleMessage("Csoport"),
        "groupDescription":
            MessageLookupByLibrary.simpleMessage("Csoport leírás"),
        "groupDescriptionHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "Csoport leírása megváltozott"),
        "groupIsPublic":
            MessageLookupByLibrary.simpleMessage("A csoport publikus"),
        "groupWith": m27,
        "guestsAreForbidden":
            MessageLookupByLibrary.simpleMessage("Vendégeknek tilos a belépés"),
        "guestsCanJoin":
            MessageLookupByLibrary.simpleMessage("Vendégek csatlakozhatnak"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Segítség"),
        "homeserverIsNotCompatible": MessageLookupByLibrary.simpleMessage(
            "Ez a Matrix szerver nem kompatibilis"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "identity": MessageLookupByLibrary.simpleMessage("Azonosság"),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Hibás jelszó vagy visszaállítási kulcs"),
        "inviteContact":
            MessageLookupByLibrary.simpleMessage("Ismerős meghívása"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("Meghívott"),
        "invitedUser": m31,
        "invitedUsersOnly":
            MessageLookupByLibrary.simpleMessage("Csak meghívottak"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Helyes az alábbi eszköz kulcs?"),
        "isTyping": MessageLookupByLibrary.simpleMessage("gépel..."),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage("Kulcsok betöltve"),
        "keysMissing":
            MessageLookupByLibrary.simpleMessage("Kulcsok hiányoznak"),
        "kickFromChat":
            MessageLookupByLibrary.simpleMessage("Csevegésből kirúgás"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp":
            MessageLookupByLibrary.simpleMessage("Utoljára látott IP"),
        "lastSeenLongTimeAgo":
            MessageLookupByLibrary.simpleMessage("Már régen látta"),
        "leave": MessageLookupByLibrary.simpleMessage("Csevegés elhagyása"),
        "leftTheChat":
            MessageLookupByLibrary.simpleMessage("Elhagyta a csevegést"),
        "license": MessageLookupByLibrary.simpleMessage("Licenc"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Világos"),
        "loadCountMoreParticipants": m36,
        "loadMore":
            MessageLookupByLibrary.simpleMessage("Továbbiak betöltése..."),
        "loadingPleaseWait":
            MessageLookupByLibrary.simpleMessage("Betöltés... Kérlek várj"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("Bejelentkezés"),
        "logout": MessageLookupByLibrary.simpleMessage("Kijelentkezés"),
        "makeAModerator":
            MessageLookupByLibrary.simpleMessage("Kinevezés moderátorrá"),
        "makeAnAdmin":
            MessageLookupByLibrary.simpleMessage("Kinevezés adminná"),
        "makeSureTheIdentifierIsValid": MessageLookupByLibrary.simpleMessage(
            "Bizonyosodj meg az azonosító helyességéről"),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "Az üzenet minden résztvevő számára törlődni fog"),
        "moderator": MessageLookupByLibrary.simpleMessage("Moderátor"),
        "monday": MessageLookupByLibrary.simpleMessage("Hétfő"),
        "muteChat": MessageLookupByLibrary.simpleMessage("Csevegés némítása"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(
            "Tájékoztatlak, hogy egyelőre szükséged van a Pantalaimon-ra, hogy a végponttól-végpontig titkosítást hasnzáld."),
        "newMessageInFluffyChat":
            MessageLookupByLibrary.simpleMessage("Új üzenet a FluffyChaten"),
        "newPrivateChat":
            MessageLookupByLibrary.simpleMessage("Új privát csevegés"),
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("Új hitelesítési kérelem!"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "FluffyChat jelenleg nem támogatja a Kereszt-Aláírás bekapcsolását. Kérlek engedélyezd Riot-ból."),
        "noEmotesFound":
            MessageLookupByLibrary.simpleMessage("Nincsenek hangulatjelek. 😕"),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "Úgy tűnik ügyelsz a magánszférádra és nincsenek google szolgáltatások telepítve. Hogy így is kapj azonnali értesítéseket javasoljuk a microG-t: https://microg.org/"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "FluffyChat jelenleg nem támogatja az Online Kulcs Archívumot (backup). Kérlek engedélyezd Riot-ból."),
        "noPermission":
            MessageLookupByLibrary.simpleMessage("Nincsenek engedélyek"),
        "noRoomsFound":
            MessageLookupByLibrary.simpleMessage("Nem találtam szobákat..."),
        "none": MessageLookupByLibrary.simpleMessage("Nincs"),
        "notSupportedInWeb":
            MessageLookupByLibrary.simpleMessage("Nem támogatott a weben"),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Online Kulcs Archívum letiltva"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Online Kulcs Archívum engedélyezve"),
        "oopsSomethingWentWrong": MessageLookupByLibrary.simpleMessage(
            "Hoppá, valami baj történt..."),
        "openAppToReadMessages": MessageLookupByLibrary.simpleMessage(
            "App megnyitása az üzenetek elolvasásához"),
        "openCamera": MessageLookupByLibrary.simpleMessage("Kamera megnyitása"),
        "optionalGroupName":
            MessageLookupByLibrary.simpleMessage("(Nem kötelező) Csoport név"),
        "participatingUserDevices": MessageLookupByLibrary.simpleMessage(
            "Résztvevő felhasználók eszközei"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Jelszó vagy visszaállítási kulcs"),
        "password": MessageLookupByLibrary.simpleMessage("Jelszó"),
        "pickImage": MessageLookupByLibrary.simpleMessage("Válassz egy képet"),
        "play": m39,
        "pleaseChooseAUsername": MessageLookupByLibrary.simpleMessage(
            "Válassz egy felhasználónevet"),
        "pleaseEnterAMatrixIdentifier": MessageLookupByLibrary.simpleMessage(
            "Írj be egy Matrix azonosítót"),
        "pleaseEnterYourPassword":
            MessageLookupByLibrary.simpleMessage("Add meg a jelszavad"),
        "pleaseEnterYourUsername": MessageLookupByLibrary.simpleMessage(
            "Add meg a felhasználónevedet"),
        "publicRooms": MessageLookupByLibrary.simpleMessage("Publikus szoba"),
        "recording": MessageLookupByLibrary.simpleMessage("Felvétel"),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("Visszautasít"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("Újracsatlakozás"),
        "remove": MessageLookupByLibrary.simpleMessage("Eltávolítás"),
        "removeAllOtherDevices": MessageLookupByLibrary.simpleMessage(
            "Minden más eszköz eltávolítása"),
        "removeDevice":
            MessageLookupByLibrary.simpleMessage("Eszköz eltávolítása"),
        "removeExile":
            MessageLookupByLibrary.simpleMessage("Kitiltás feloldása"),
        "removeMessage":
            MessageLookupByLibrary.simpleMessage("Üzenet eltávolítása"),
        "removedBy": m42,
        "renderRichContent": MessageLookupByLibrary.simpleMessage(
            "Formázott üzenetek megjelenítése"),
        "reply": MessageLookupByLibrary.simpleMessage("Válasz"),
        "requestPermission":
            MessageLookupByLibrary.simpleMessage("Jogosultság igénylése"),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(
            "Korábbi üzenetekhez való hozzáférés igénylése"),
        "revokeAllPermissions": MessageLookupByLibrary.simpleMessage(
            "Minden jogosultság megvonása"),
        "roomHasBeenUpgraded":
            MessageLookupByLibrary.simpleMessage("Szoba frissítve lett"),
        "saturday": MessageLookupByLibrary.simpleMessage("Szombat"),
        "searchForAChat":
            MessageLookupByLibrary.simpleMessage("Csevegés keresése"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("Küldés"),
        "sendAMessage": MessageLookupByLibrary.simpleMessage("Üzenet küldése"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Fájl küldése"),
        "sendImage": MessageLookupByLibrary.simpleMessage("Kép küldése"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Munkamenet hitelesítve"),
        "setAProfilePicture":
            MessageLookupByLibrary.simpleMessage("Profilkép beállítása"),
        "setGroupDescription":
            MessageLookupByLibrary.simpleMessage("Csoport leírás beállítása"),
        "setInvitationLink":
            MessageLookupByLibrary.simpleMessage("Meghívó link beállítása"),
        "setStatus": MessageLookupByLibrary.simpleMessage("Állapot beállítása"),
        "settings": MessageLookupByLibrary.simpleMessage("Beállítások"),
        "share": MessageLookupByLibrary.simpleMessage("Megosztás"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("Felíratkozás"),
        "skip": MessageLookupByLibrary.simpleMessage("Kihagy"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Forráskód"),
        "startYourFirstChat":
            MessageLookupByLibrary.simpleMessage("Kezdj el csevegni :-)"),
        "statusExampleMessage":
            MessageLookupByLibrary.simpleMessage("Hogy vagy?"),
        "submit": MessageLookupByLibrary.simpleMessage("Mehet"),
        "sunday": MessageLookupByLibrary.simpleMessage("Vasárnap"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("Rendszer"),
        "tapToShowMenu": MessageLookupByLibrary.simpleMessage(
            "Érintsd meg a menü megnyitásához"),
        "theyDontMatch": MessageLookupByLibrary.simpleMessage("Nem egyeznek"),
        "theyMatch": MessageLookupByLibrary.simpleMessage("Megegyeznek"),
        "thisRoomHasBeenArchived":
            MessageLookupByLibrary.simpleMessage("Ez a szoba archiválva lett."),
        "thursday": MessageLookupByLibrary.simpleMessage("Csütörtök"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain":
            MessageLookupByLibrary.simpleMessage("Próbáld újraküldeni"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Kedd"),
        "unbannedUser": m55,
        "unblockDevice": MessageLookupByLibrary.simpleMessage(
            "Eszköz blokkolásának megszüntetése"),
        "unknownDevice":
            MessageLookupByLibrary.simpleMessage("Ismeretlen eszköz"),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(
            "Ismeretlen titkosítási algoritmus"),
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Ismeretlen munkamenet, kérlek hitelesítsd"),
        "unmuteChat":
            MessageLookupByLibrary.simpleMessage("Csevegés felhangosítása"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(
            "AmoLED kompatibilis színek használata?"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("Felhasználónév"),
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Sikeresen hitelesítetted a munkamenetedet!"),
        "verify": MessageLookupByLibrary.simpleMessage("Hitelesít"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Kézi hitelesítés"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Hitelesítés megkezdése"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Sikeresen hitelesítettél!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Másik fiók hitelesítése"),
        "verifyUser":
            MessageLookupByLibrary.simpleMessage("Felhasználó hitelesítése"),
        "videoCall": MessageLookupByLibrary.simpleMessage("Videó hívás"),
        "visibilityOfTheChatHistory": MessageLookupByLibrary.simpleMessage(
            "Csevegési előzmény láthatósága"),
        "visibleForAllParticipants": MessageLookupByLibrary.simpleMessage(
            "Minden résztvevő számára látható"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("Bárki számára látható"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("Hang üzenet"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Várakozás partnerre, amíg elfogadja a kérést..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Várakozás partnere, amíg elfogadja a hangulatjeleket..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Várakozás partnere, amíg elfogadja a számokat..."),
        "wallpaper": MessageLookupByLibrary.simpleMessage("Háttér"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "Végpontól-végpontig titkosítás egyelőre béta! Csak saját felelősségre!"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Szerda"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Üdv a legcukibb üzenetküldő alkalmazásban az egész Matrixon!"),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(
            "Ki csatlakozhat a csoporthoz"),
        "writeAMessage":
            MessageLookupByLibrary.simpleMessage("Írj egy üzenetet..."),
        "yes": MessageLookupByLibrary.simpleMessage("Igen"),
        "you": MessageLookupByLibrary.simpleMessage("Te"),
        "youAreInvitedToThisChat":
            MessageLookupByLibrary.simpleMessage("Meghívtak ebbe a csevegésbe"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(
                "Nem veszel részt ebben a csevegésben"),
        "youCannotInviteYourself":
            MessageLookupByLibrary.simpleMessage("Nem tudod meghívni magadat"),
        "youHaveBeenBannedFromThisChat": MessageLookupByLibrary.simpleMessage(
            "Kitiltottak ebből a csevegésből"),
        "yourOwnUsername":
            MessageLookupByLibrary.simpleMessage("A saját felhasználóneved")
      };
}
