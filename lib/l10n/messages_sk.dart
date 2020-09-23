// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a sk locale. All the
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
  String get localeName => 'sk';

  static m0(username) => "${username} prijali pozvánku";

  static m1(username) => "${username} aktivovali koncové šifrovanie";

  static m3(username) => "Akcepovať žiadosť o verifikáciu od ${username}?";

  static m4(username, targetName) => "${username} zabanoval ${targetName}";

  static m5(homeserver) =>
      "V základnom nastavení budete pripojený k ${homeserver}";

  static m6(username) => "${username} si zmenili svôj avatar";

  static m7(username, description) =>
      "${username} zmenili popis chatu na: „${description}“";

  static m8(username, chatname) =>
      "${username} zmenili meno chatu na: „${chatname}“";

  static m9(username) => "${username} zmenili nastavenie oprávnení chatu";

  static m10(username, displayname) =>
      "${username} si zmenili prezývku na: ${displayname}";

  static m11(username) => "${username} zmenili prístupové práva pre hosťov";

  static m12(username, rules) =>
      "${username} zmenili prístupové práva pro hosťov na: ${rules}";

  static m13(username) =>
      "${username} zmenili nastavenie viditelnosti histórie chatu";

  static m14(username, rules) =>
      "${username} zmenili nastavenie viditelnosti histórie chatu na: ${rules}";

  static m15(username) => "${username} zmenili nastavenie pravidiel pripojenia";

  static m16(username, joinRules) =>
      "${username} zmenili nastavenie pravidiel pripojenia na: ${joinRules}";

  static m17(username) => "${username} si zmenili profilový obrázok";

  static m18(username) => "${username} zmenili nastavenie aliasov chatu";

  static m19(username) => "${username} zmenili odkaz k pozvánke do miestnosti";

  static m20(error) => "Nebolo možné dešifrovať správu: ${error}";

  static m21(count) => "${count} účastníkov";

  static m22(username) => "${username} založili chat";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${day}.${month}.${year}";

  static m25(month, day) => "${day}.${month}.";

  static m27(displayname) => "Skupina s ${displayname}";

  static m28(username, targetName) =>
      "${username} vzal späť pozvánku pre ${targetName}";

  static m29(groupName) => "Pozvať kontakt do ${groupName}";

  static m30(username, link) =>
      "${username} vás pozval na FluffyChat.\n1. Nainštalujte si FluffyChat: https://fluffychat.im\n2. Zaregistrujte sa alebo sa prihláste\n3. Otvorte odkaz na pozvánku: ${link}";

  static m31(username, targetName) => "${username} pozvali ${targetName}";

  static m32(username) => "${username} sa pripojili do chatu";

  static m33(username, targetName) => "${username} vyhodili ${targetName}";

  static m34(username, targetName) =>
      "${username} vyhodili a zabanovali ${targetName}";

  static m35(localizedTimeShort) => "Naposledy prítomní: ${localizedTimeShort}";

  static m36(count) => "Načítať ďalších ${count} účastníkov";

  static m37(homeserver) => "Prihlásenie k ${homeserver}";

  static m38(number) => "${number} označených správ";

  static m39(fileName) => "Prehrať (fileName}";

  static m40(username) => "${username} odstránili udalosť";

  static m41(username) => "${username} odmietli pozvánku";

  static m42(username) => "Odstánené užívateľom ${username}";

  static m43(username) => "Videné užívateľom ${username}";

  static m44(username, count) =>
      "Videné užívateľom ${username} a ${count} dalšími";

  static m45(username, username2) =>
      "Videné užívateľmi ${username} a ${username2}";

  static m46(username) => "${username} poslali súbor";

  static m47(username) => "${username} poslali obrázok";

  static m48(username) => "${username} poslali nálepku";

  static m49(username) => "${username} poslali video";

  static m50(username) => "${username} poslali zvukovú nahrávku";

  static m52(username) => "${username} zdieľa lokáciu";

  static m54(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m55(username, targetName) => "${username} odbanovali ${targetName}";

  static m56(type) => "Neznáma udalosť „${type}“";

  static m57(unreadCount) => "${unreadCount} neprečítaných chatov";

  static m58(unreadEvents) => "${unreadEvents} neprečítaných správ";

  static m59(unreadEvents, unreadChats) =>
      "${unreadEvents} neprečítaných správ v ${unreadChats} chatoch";

  static m60(username, count) => "${username} a ${count} dalších píšu…";

  static m61(username, username2) => "${username} a ${username2} píšu…";

  static m62(username) => "${username} píše…";

  static m63(username) => "${username} opustili chat";

  static m64(username, type) => "${username} poslali udalosť ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("O aplikácii"),
        "accept": MessageLookupByLibrary.simpleMessage("Prijať"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Účet"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Informácie o účte"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription":
            MessageLookupByLibrary.simpleMessage("Pridať popis skupiny"),
        "admin": MessageLookupByLibrary.simpleMessage("Administrátor"),
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Máte už účet?"),
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("Ktokoľvek sa môže pripojiť"),
        "archive": MessageLookupByLibrary.simpleMessage("Archivovať"),
        "archivedRoom":
            MessageLookupByLibrary.simpleMessage("Archivovaná miestnosť"),
        "areGuestsAllowedToJoin":
            MessageLookupByLibrary.simpleMessage("Môžu sa pripojiť hostia"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Ste si istí?"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Prosím zadajte vašu prístupovu frázu k \"bezpečému úložisku\" alebo \"kľúč na obnovu\" pre uloženie kľúčov."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Na overenie tejto osoby, prosím zadajte prístupovu frázu k \"bezpečému úložisku\" alebo \"klúč na obnovu\"."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Prosím zadajte vašu prístupovú frázu k \"bezpečnému úložisku\" alebo \"kľúč na obnovu\" pre overenie vašej relácie."),
        "askVerificationRequest": m3,
        "authentication":
            MessageLookupByLibrary.simpleMessage("Autentifikácia"),
        "avatarHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Avatar bol zmenený"),
        "banFromChat":
            MessageLookupByLibrary.simpleMessage("Zabanovať z chatu"),
        "banned": MessageLookupByLibrary.simpleMessage("Zabanovaný"),
        "bannedUser": m4,
        "blockDevice":
            MessageLookupByLibrary.simpleMessage("Zakázať zariadenie"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys":
            MessageLookupByLibrary.simpleMessage("Klúče sa úspešne uložili!"),
        "cancel": MessageLookupByLibrary.simpleMessage("Zrušiť"),
        "changeTheHomeserver":
            MessageLookupByLibrary.simpleMessage("Zmeniť použitý server"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("Zmeniť názov skupiny"),
        "changeTheServer":
            MessageLookupByLibrary.simpleMessage("Zmeniť server"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("Zmena štýlu"),
        "changeWallpaper":
            MessageLookupByLibrary.simpleMessage("Zmeniť pozadie"),
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
        "changelog": MessageLookupByLibrary.simpleMessage("História zmien"),
        "channelCorruptedDecryptError":
            MessageLookupByLibrary.simpleMessage("Šifrovanie bolo poškodené"),
        "chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "chatDetails":
            MessageLookupByLibrary.simpleMessage("Podrobnosti o chate"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("Vyberte si silné heslo"),
        "chooseAUsername":
            MessageLookupByLibrary.simpleMessage("Vyberte si užívateľské meno"),
        "close": MessageLookupByLibrary.simpleMessage("Zavrieť"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Porovnajte a uistite sa, že nasledujúce emotikony sa zhodujú na oboch zariadeniach:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Porovnajte a uistite sa, že nasledujúce čísla sa zhodujú na oboch zariadeniach:"),
        "confirm": MessageLookupByLibrary.simpleMessage("Potvrdiť"),
        "connect": MessageLookupByLibrary.simpleMessage("Pripojiť"),
        "connectionAttemptFailed":
            MessageLookupByLibrary.simpleMessage("Pokus o pripojenie zlyhal"),
        "contactHasBeenInvitedToTheGroup": MessageLookupByLibrary.simpleMessage(
            "Kontakt bol pozvaný do skupiny"),
        "contentViewer":
            MessageLookupByLibrary.simpleMessage("Prehliadač obsahu"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Skopírované do schránky"),
        "copy": MessageLookupByLibrary.simpleMessage("Kopírovať"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar": MessageLookupByLibrary.simpleMessage(
            "Nepodarilo sa nastaviť avatar"),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(
            "Nepodarilo sa nastaviť prezývku užívateľa"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Vytvoriť"),
        "createAccountNow":
            MessageLookupByLibrary.simpleMessage("Vytvoriť účet teraz"),
        "createNewGroup":
            MessageLookupByLibrary.simpleMessage("Vytvoriť novú skupinu"),
        "createdTheChat": m22,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "Vzájomné overenie je vypnuté"),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(
            "Vzájomné overenie je zapnuté"),
        "currentlyActive":
            MessageLookupByLibrary.simpleMessage("Momentálne prítomní"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Tmavá"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "delete": MessageLookupByLibrary.simpleMessage("Odstrániť"),
        "deleteMessage":
            MessageLookupByLibrary.simpleMessage("Odstrániť správu"),
        "deny": MessageLookupByLibrary.simpleMessage("Zamietnuť"),
        "device": MessageLookupByLibrary.simpleMessage("Zariadenie"),
        "devices": MessageLookupByLibrary.simpleMessage("Zariadenia"),
        "discardPicture":
            MessageLookupByLibrary.simpleMessage("Zahodiť obrázok"),
        "displaynameHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Prezývka bola zmenená"),
        "donate": MessageLookupByLibrary.simpleMessage("Prispejte"),
        "downloadFile": MessageLookupByLibrary.simpleMessage("Stiahnuť súbor"),
        "editDisplayname":
            MessageLookupByLibrary.simpleMessage("Zmeniť prezývku"),
        "editJitsiInstance":
            MessageLookupByLibrary.simpleMessage("Nastavenie inštancie Jitsi"),
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Emotikon už existuje"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Nesprávné označenie emotikonu"),
        "emoteSettings":
            MessageLookupByLibrary.simpleMessage("Nastavenie emotikonov"),
        "emoteShortcode": MessageLookupByLibrary.simpleMessage("Kód emotikonu"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Musíte zvoliť kód emotikonu a obrázok"),
        "emptyChat": MessageLookupByLibrary.simpleMessage("Prázdny chat"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "Šifrovanie už nebude možné vypnúť. Ste si tým istí?"),
        "encryption": MessageLookupByLibrary.simpleMessage("Šifrovanie"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Šifrovací algoritmus"),
        "encryptionNotEnabled":
            MessageLookupByLibrary.simpleMessage("Šifrovanie nie je aktívne"),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "Nastavenie koncového šifrovania"),
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("Zadajte názov skupiny"),
        "enterAUsername":
            MessageLookupByLibrary.simpleMessage("Zadajte uživateľské meno"),
        "enterYourHomeserver":
            MessageLookupByLibrary.simpleMessage("Zadajte svoj homeserver"),
        "fileName": MessageLookupByLibrary.simpleMessage("Názov súboru"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Veľkosť súboru"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("Preposlať"),
        "friday": MessageLookupByLibrary.simpleMessage("Piatok"),
        "fromJoining": MessageLookupByLibrary.simpleMessage("Od pripojenia"),
        "fromTheInvitation":
            MessageLookupByLibrary.simpleMessage("Od pozvania"),
        "group": MessageLookupByLibrary.simpleMessage("Skupina"),
        "groupDescription":
            MessageLookupByLibrary.simpleMessage("Popis skupiny"),
        "groupDescriptionHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Popis skupiny bol zmenený"),
        "groupIsPublic":
            MessageLookupByLibrary.simpleMessage("Skupina je verejná"),
        "groupWith": m27,
        "guestsAreForbidden":
            MessageLookupByLibrary.simpleMessage("Hostia sú zakázaní"),
        "guestsCanJoin":
            MessageLookupByLibrary.simpleMessage("Hostia sa môžu pripojiť"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Pomoc"),
        "homeserverIsNotCompatible": MessageLookupByLibrary.simpleMessage(
            "Homeserver nie je kompatibilný"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "identity": MessageLookupByLibrary.simpleMessage("Identita"),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Nesprávna prístupová fráza alebo kľúč na obnovenie"),
        "inviteContact": MessageLookupByLibrary.simpleMessage("Pozvať kontakt"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("Pozvanie"),
        "invitedUser": m31,
        "invitedUsersOnly":
            MessageLookupByLibrary.simpleMessage("Len pozvaní používatelia"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Je nasledujúci kód zariadenia správny?"),
        "isTyping": MessageLookupByLibrary.simpleMessage("píše..."),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage("Kľúče sú uložené"),
        "keysMissing": MessageLookupByLibrary.simpleMessage("Kľúče chýbaju"),
        "kickFromChat": MessageLookupByLibrary.simpleMessage("Vyhodiť z chatu"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp": MessageLookupByLibrary.simpleMessage(
            "Naposledy zaznamenaná IP adresa"),
        "lastSeenLongTimeAgo":
            MessageLookupByLibrary.simpleMessage("Videný veľmi dávno"),
        "leave": MessageLookupByLibrary.simpleMessage("Opustiť"),
        "leftTheChat": MessageLookupByLibrary.simpleMessage("Opustili chat"),
        "license": MessageLookupByLibrary.simpleMessage("Licencia"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Svetlá"),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage("Načítať viac..."),
        "loadingPleaseWait": MessageLookupByLibrary.simpleMessage(
            "Načítava sa... Čakajte prosím"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("Prihlásiť sa"),
        "logout": MessageLookupByLibrary.simpleMessage("Odhlásiť sa"),
        "makeAModerator":
            MessageLookupByLibrary.simpleMessage("Pridať práva moderátora"),
        "makeAnAdmin":
            MessageLookupByLibrary.simpleMessage("Pridať práva administrátora"),
        "makeSureTheIdentifierIsValid": MessageLookupByLibrary.simpleMessage(
            "Skontrolujte, či je identifikátor platný"),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "Správa bude odstránená pre všetkých účastníkov"),
        "moderator": MessageLookupByLibrary.simpleMessage("Moderátor"),
        "monday": MessageLookupByLibrary.simpleMessage("Pondelok"),
        "muteChat": MessageLookupByLibrary.simpleMessage("Stlmiť chat"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(
            "Prosím berte na vedomie, že na koncové šifrovanie zatiaľ potrebujete Pantalaimon."),
        "newMessageInFluffyChat":
            MessageLookupByLibrary.simpleMessage("Nová správa v FluffyChate"),
        "newPrivateChat":
            MessageLookupByLibrary.simpleMessage("Nový súkromný chat"),
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("Nová žiadosť o verifikáciu!"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat v súčasnosti nepodporuje povolenie krížového podpisu. Prosím, povoľte ho z Riot.im."),
        "noEmotesFound": MessageLookupByLibrary.simpleMessage(
            "Nenašli sa žiadne emotikony. 😕"),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "Zdá sa, že nemáte žiadne služby Googlu v telefóne. To je dobré rozhodnutie pre vaše súkromie! Ak chcete dostávať push notifikácie vo FluffyChat, odporúčame používať microG: https://microg.org/"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat v súčasnosti nepodporuje povolenie online zálohu klúčov. Prosím, povoľte ho z Riot.im."),
        "noPermission": MessageLookupByLibrary.simpleMessage("Chýba povolenie"),
        "noRoomsFound": MessageLookupByLibrary.simpleMessage(
            "Nenašli sa žiadne miestnosti..."),
        "none": MessageLookupByLibrary.simpleMessage("Žiadne"),
        "notSupportedInWeb": MessageLookupByLibrary.simpleMessage(
            "Nepodporované vo webovej verzii"),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Online záloha kľúčov je vypnutá"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Online záloha kľúčov je zapnutá"),
        "oopsSomethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Och! Niečo sa pokazilo..."),
        "openAppToReadMessages": MessageLookupByLibrary.simpleMessage(
            "Na prečítanie správy otvorte aplikáciu"),
        "openCamera":
            MessageLookupByLibrary.simpleMessage("Otvoriť fotoaparát"),
        "optionalGroupName":
            MessageLookupByLibrary.simpleMessage("(Voliteľné) Názov skupiny"),
        "participatingUserDevices": MessageLookupByLibrary.simpleMessage(
            "Zúčastnené užívateľské zariadenia"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "prístupová fráza alebo kľúč na obnovenie"),
        "password": MessageLookupByLibrary.simpleMessage("Heslo"),
        "pickImage": MessageLookupByLibrary.simpleMessage("Vybrať obrázok"),
        "play": m39,
        "pleaseChooseAUsername": MessageLookupByLibrary.simpleMessage(
            "Vyberte si používateľské meno"),
        "pleaseEnterAMatrixIdentifier": MessageLookupByLibrary.simpleMessage(
            "Vyberte si matrix identifkátor"),
        "pleaseEnterYourPassword":
            MessageLookupByLibrary.simpleMessage("Prosím zadajte svoje heslo"),
        "pleaseEnterYourUsername": MessageLookupByLibrary.simpleMessage(
            "Zadajte svoje používateľské meno"),
        "publicRooms":
            MessageLookupByLibrary.simpleMessage("Verejné miestnosti"),
        "recording": MessageLookupByLibrary.simpleMessage("Nahrávam"),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("Odmietnuť"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("Vrátiť sa"),
        "remove": MessageLookupByLibrary.simpleMessage("Odstrániť"),
        "removeAllOtherDevices": MessageLookupByLibrary.simpleMessage(
            "Odstráňiť všetky ostatné zariadenia"),
        "removeDevice":
            MessageLookupByLibrary.simpleMessage("Odstráňiť zariadenie"),
        "removeExile": MessageLookupByLibrary.simpleMessage("Odblokovať"),
        "removeMessage":
            MessageLookupByLibrary.simpleMessage("Odstrániť správu"),
        "removedBy": m42,
        "renderRichContent":
            MessageLookupByLibrary.simpleMessage("Zobraziť formátovaný obsah"),
        "reply": MessageLookupByLibrary.simpleMessage("Odpovedať"),
        "requestPermission":
            MessageLookupByLibrary.simpleMessage("Vyžiadať si povolenie"),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(
            "Žiadosť o prečítanie starších správ"),
        "revokeAllPermissions":
            MessageLookupByLibrary.simpleMessage("Zrušiť všetky povolenia"),
        "roomHasBeenUpgraded":
            MessageLookupByLibrary.simpleMessage("Miestnosť bola upgradeovaná"),
        "saturday": MessageLookupByLibrary.simpleMessage("Sobota"),
        "searchForAChat":
            MessageLookupByLibrary.simpleMessage("Vyhladať v chate"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("Odoslať"),
        "sendAMessage": MessageLookupByLibrary.simpleMessage("Odoslať správu"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Odoslať súbor"),
        "sendImage": MessageLookupByLibrary.simpleMessage("Odoslať obrázok"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Relácia je overená"),
        "setAProfilePicture":
            MessageLookupByLibrary.simpleMessage("Nastaviť profilový obrázok"),
        "setGroupDescription":
            MessageLookupByLibrary.simpleMessage("Nastaviť popis skupiny"),
        "setInvitationLink":
            MessageLookupByLibrary.simpleMessage("Nastaviť odkaz pre pozvánku"),
        "setStatus": MessageLookupByLibrary.simpleMessage("Nastaviť status"),
        "settings": MessageLookupByLibrary.simpleMessage("Nastavenia"),
        "share": MessageLookupByLibrary.simpleMessage("Zdieľať"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("Zaregistrovať sa"),
        "skip": MessageLookupByLibrary.simpleMessage("Preskočiť"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Zdrojový kód"),
        "startYourFirstChat":
            MessageLookupByLibrary.simpleMessage("Začnite svoj prvý chat :-)"),
        "statusExampleMessage":
            MessageLookupByLibrary.simpleMessage("Ako sa dnes máte?"),
        "submit": MessageLookupByLibrary.simpleMessage("Odoslať"),
        "sunday": MessageLookupByLibrary.simpleMessage("Nedeľa"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("Systémová farba"),
        "tapToShowMenu":
            MessageLookupByLibrary.simpleMessage("Ťuknutím zobrazíte menu"),
        "theyDontMatch": MessageLookupByLibrary.simpleMessage("Sa nezhodujú"),
        "theyMatch": MessageLookupByLibrary.simpleMessage("Zhodujú sa"),
        "thisRoomHasBeenArchived": MessageLookupByLibrary.simpleMessage(
            "Táto miestnosť bola archivovaná."),
        "thursday": MessageLookupByLibrary.simpleMessage("Štvrtok"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain":
            MessageLookupByLibrary.simpleMessage("Skúsiť znova odoslať"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Utorok"),
        "unbannedUser": m55,
        "unblockDevice":
            MessageLookupByLibrary.simpleMessage("Odblokovať zariadenie"),
        "unknownDevice":
            MessageLookupByLibrary.simpleMessage("Neznáme zariadenie"),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(
            "Neznámy šifrovací algoritmus"),
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Neznáma relácia, prosím verifikujte ju"),
        "unmuteChat":
            MessageLookupByLibrary.simpleMessage("Zrušiť stlmenie chatu"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(
            "Použiť Amoled kompatibilné farby?"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("Užívateľské meno"),
        "verifiedSession":
            MessageLookupByLibrary.simpleMessage("Úspešne overenie relácie!"),
        "verify": MessageLookupByLibrary.simpleMessage("Overiť"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Verifikovať manuálne"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Spustiť verifikáciu"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Verifikácia bola úspešná!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Verifikujem protiľahlý účet"),
        "verifyUser":
            MessageLookupByLibrary.simpleMessage("Verifikovať používateľa"),
        "videoCall": MessageLookupByLibrary.simpleMessage("Videohovor"),
        "visibilityOfTheChatHistory":
            MessageLookupByLibrary.simpleMessage("Viditeľnosť histórie chatu"),
        "visibleForAllParticipants": MessageLookupByLibrary.simpleMessage(
            "Viditeľné pre všetkých účastníkov"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("Viditeľné pre každého"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("Hlasová správa"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Čaká sa, kým partner prijme požiadavku..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Čaká sa, kým partner prijme emotikon..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Čaká sa na to, kým partner prijme čísla..."),
        "wallpaper": MessageLookupByLibrary.simpleMessage("Pozadie"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "Konečné šifrovanie je momentálne v Beta verzii! Používajte na vlastné riziko!"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Streda"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Vítajte v najroztomilejšom instant messengeri v sieti matrix."),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(
            "Kto môže vstúpiť do tejto skupiny"),
        "writeAMessage":
            MessageLookupByLibrary.simpleMessage("Napísať správu..."),
        "yes": MessageLookupByLibrary.simpleMessage("Áno"),
        "you": MessageLookupByLibrary.simpleMessage("Vy"),
        "youAreInvitedToThisChat":
            MessageLookupByLibrary.simpleMessage("Ste pozvaní do tohto chatu"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(
                "Už sa nezúčastňujete tohto chatu"),
        "youCannotInviteYourself":
            MessageLookupByLibrary.simpleMessage("Nemôžete pozvať samých seba"),
        "youHaveBeenBannedFromThisChat": MessageLookupByLibrary.simpleMessage(
            "Máte zablokovaný prístup k tomuto chatu"),
        "yourOwnUsername":
            MessageLookupByLibrary.simpleMessage("Vaša vlastná prezývka")
      };
}
