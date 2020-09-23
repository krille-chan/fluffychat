// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a cs locale. All the
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
  String get localeName => 'cs';

  static m0(username) => "${username} přijali pozvání";

  static m1(username) => "${username} aktivoval koncové šifrování";

  static m2(senderName) => "${senderName} odpověděl na hovor";

  static m3(username) => "Přijmout žádost o ověření od (username)?";

  static m4(username, targetName) => "${username} zakázal ${targetName}";

  static m5(homeserver) =>
      "V základním nastavení budete připojeni do ${homeserver}";

  static m6(username) => "${username} změnili svůj avatar";

  static m7(username, description) =>
      "${username} změnili popis diskuze na: „${description}“";

  static m8(username, chatname) =>
      "${username} změnili jméno diskuze na: „${chatname}“";

  static m9(username) => "${username} změnili nastavení oprávnění v diskuzi";

  static m10(username, displayname) =>
      "${username} změnili přezdívku na: ${displayname}";

  static m11(username) => "${username} změnili přístupová práva pro hosty";

  static m12(username, rules) =>
      "${username} změnili přístupová práva pro hosty na: ${rules}";

  static m13(username) =>
      "${username} změnili nastavení viditelnosti historie diskuze";

  static m14(username, rules) =>
      "${username} změnili nastavení viditelnosti historie diskuze na: ${rules}";

  static m15(username) => "${username} změnili nastavení pravidel připojení";

  static m16(username, joinRules) =>
      "${username} změnili nastavení pravidel připojení na: ${joinRules}";

  static m17(username) => "${username} změnili svůj avatar";

  static m18(username) => "${username} změnili nastavení aliasů místnosti";

  static m19(username) => "${username} změnili odkaz k pozvání do místnosti";

  static m20(error) => "Nebylo možné dešifrovat zprávu: ${error}";

  static m21(count) => "${count} účastníků";

  static m22(username) => "${username} založil diskuzi";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${day}. ${month}. ${year}";

  static m25(month, day) => "${day}.${month}";

  static m26(senderName) => "${senderName} ukončil hovor";

  static m27(displayname) => "Skupina s ${displayname}";

  static m28(username, targetName) =>
      "${username} vzal zpět pozvání pro ${targetName}";

  static m29(groupName) => "Pozvat kontakt do ${groupName}";

  static m30(username, link) =>
      "${username} vás pozval na FluffyChat.\n1. Nainstalujte si FluffyChat: https://fluffychat.im\n2. Zaregistrujte se anebo se přihlašte\n3. Otevřete odkaz na pozvánce: ${link}";

  static m31(username, targetName) => "${username} pozvali ${targetName}";

  static m32(username) => "${username} se připojili do diskuze";

  static m33(username, targetName) => "${username} vyhodil ${targetName}";

  static m34(username, targetName) =>
      "${username} vyhodil a zakázal ${targetName}";

  static m35(localizedTimeShort) => "Naposledy aktivní: ${localizedTimeShort}";

  static m36(count) => "Načíst dalších ${count} účastníků";

  static m37(homeserver) => "Přihlášení k ${homeserver}";

  static m38(number) => "${number} vybráno";

  static m39(fileName) => "Přehrát (fileName}";

  static m40(username) => "${username} odstranili událost";

  static m41(username) => "${username} odmítli pozvání";

  static m42(username) => "Odstraněno ${username}";

  static m43(username) => "Viděno uživatelem ${username}";

  static m44(username, count) =>
      "Viděno uživateli ${username} a ${count} dalšími";

  static m45(username, username2) =>
      "Viděno uživateli ${username} a ${username2}";

  static m46(username) => "${username} poslali soubor";

  static m47(username) => "${username} poslali obrázek";

  static m48(username) => "${username} poslali samolepku";

  static m49(username) => "${username} poslali video";

  static m50(username) => "${username} poslali zvukovou nahrávku";

  static m51(senderName) => "${senderName} odeslal informace o hovoru";

  static m52(username) => "${username} nasdíleli lokaci";

  static m53(senderName) => "${senderName} zahájil hovor";

  static m54(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m55(username, targetName) =>
      "${username} zrušil zákaz pro ${targetName}";

  static m56(type) => "Neznámá událost „${type}“";

  static m57(unreadCount) => "${unreadCount} nepřečtených diskuzí";

  static m58(unreadEvents) => "${unreadEvents} nepřečtených zpráv";

  static m59(unreadEvents, unreadChats) =>
      "${unreadEvents} nepřečtených zpráv v ${unreadChats}";

  static m60(username, count) => "${username} a ${count} dalších píší…";

  static m61(username, username2) => "${username} a ${username2} píší…";

  static m62(username) => "${username} píše…";

  static m63(username) => "${username} opustili diskuzi";

  static m64(username, type) => "${username} poslal událost ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("O aplikaci"),
        "accept": MessageLookupByLibrary.simpleMessage("Přijmout"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Účet"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Informace o účtu"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription":
            MessageLookupByLibrary.simpleMessage("Přidat popis skupiny"),
        "admin": MessageLookupByLibrary.simpleMessage("Administrátor"),
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Máte již účet?"),
        "answeredTheCall": m2,
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("Kdokoliv se může připojit"),
        "archive": MessageLookupByLibrary.simpleMessage("Archiv"),
        "archivedRoom":
            MessageLookupByLibrary.simpleMessage("Archivované místnosti"),
        "areGuestsAllowedToJoin":
            MessageLookupByLibrary.simpleMessage("Mohou se připojit hosté"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Jste si jisti?"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Prosím zadajte vaší prístupovu frázI k \"bezpečému úložišti\" anebo \"klíč na obnovu\" pro uložení klíčů."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Pro ověření této osoby, zadejte prosím přístupovou frází k “bezpečnému úložišti” anebo “klíč pro obnovu”."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Zadejte prosím vaší přístupovou frází k “bezpečnému úložišti” anebo “klíč pro obnovu” pro ověření vaší relace."),
        "askVerificationRequest": m3,
        "authentication": MessageLookupByLibrary.simpleMessage("Autentizace"),
        "avatarHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Avatar byl změněn"),
        "banFromChat":
            MessageLookupByLibrary.simpleMessage("Zabanovat z diskuze"),
        "banned": MessageLookupByLibrary.simpleMessage("Zakázán"),
        "bannedUser": m4,
        "blockDevice":
            MessageLookupByLibrary.simpleMessage("Blokovat zařízení"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys":
            MessageLookupByLibrary.simpleMessage("Klíče byly úspěšně uloženy!"),
        "cancel": MessageLookupByLibrary.simpleMessage("Zrušit"),
        "changeTheHomeserver":
            MessageLookupByLibrary.simpleMessage("Změnit použitý server"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("Změnit název skupiny"),
        "changeTheServer":
            MessageLookupByLibrary.simpleMessage("Změnit server"),
        "changeTheme":
            MessageLookupByLibrary.simpleMessage("Nastavte svůj styl"),
        "changeWallpaper":
            MessageLookupByLibrary.simpleMessage("Změnit pozadí"),
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
        "changelog": MessageLookupByLibrary.simpleMessage("Historie změn"),
        "changesHaveBeenSaved":
            MessageLookupByLibrary.simpleMessage("Změny byly uloženy"),
        "channelCorruptedDecryptError":
            MessageLookupByLibrary.simpleMessage("Šifrování bylo poškozeno"),
        "chat": MessageLookupByLibrary.simpleMessage("Diskuze"),
        "chatDetails": MessageLookupByLibrary.simpleMessage("Detail diskuze"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("Vyberte silné heslo"),
        "chooseAUsername":
            MessageLookupByLibrary.simpleMessage("Vyberte uživatelské jméno"),
        "close": MessageLookupByLibrary.simpleMessage("Zavřít"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Porovnejte a přesvědčete se, že následující emotikony se shodují na obou zařízeních:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Porovnejte a přesvědčete se, že následující čísla se shodují na obou zařízeních:"),
        "confirm": MessageLookupByLibrary.simpleMessage("Potvrdit"),
        "connect": MessageLookupByLibrary.simpleMessage("Připojit"),
        "connectionAttemptFailed":
            MessageLookupByLibrary.simpleMessage("Pokus o připojení selhal"),
        "contactHasBeenInvitedToTheGroup": MessageLookupByLibrary.simpleMessage(
            "Kontakt byl pozván do skupiny"),
        "contentViewer":
            MessageLookupByLibrary.simpleMessage("Prohlížeč obsahu"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Zkopírováno do schránky"),
        "copy": MessageLookupByLibrary.simpleMessage("Kopírovat"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar": MessageLookupByLibrary.simpleMessage(
            "Nebylo možné nastavit avatar"),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(
            "Nebylo možné nastavit přezdívku uživatele"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Vytvořit"),
        "createAccountNow":
            MessageLookupByLibrary.simpleMessage("Vytvořit účet teď"),
        "createNewGroup":
            MessageLookupByLibrary.simpleMessage("Založit skupinu"),
        "createdTheChat": m22,
        "crossSigningDisabled":
            MessageLookupByLibrary.simpleMessage("Vzájemné ověření je vypnuté"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Vzájemné ověření je zapnuté"),
        "currentlyActive":
            MessageLookupByLibrary.simpleMessage("Momentálně aktivní"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Tmavý"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "delete": MessageLookupByLibrary.simpleMessage("Smazat"),
        "deleteMessage": MessageLookupByLibrary.simpleMessage("Smazat zprávu"),
        "deny": MessageLookupByLibrary.simpleMessage("Zakázat"),
        "device": MessageLookupByLibrary.simpleMessage("Zařízení"),
        "devices": MessageLookupByLibrary.simpleMessage("Zařízení"),
        "discardPicture":
            MessageLookupByLibrary.simpleMessage("Vyřadit obrázek"),
        "displaynameHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Přezdívka byla změněna"),
        "donate": MessageLookupByLibrary.simpleMessage("Přispějte"),
        "downloadFile": MessageLookupByLibrary.simpleMessage("Stáhnout soubor"),
        "editDisplayname":
            MessageLookupByLibrary.simpleMessage("Změnit přezdívku"),
        "editJitsiInstance":
            MessageLookupByLibrary.simpleMessage("Nastavení instance Jitsi"),
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Emotikona již existuje!"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Nesprávné označení emotikony!"),
        "emoteSettings":
            MessageLookupByLibrary.simpleMessage("Nastavení emotikon"),
        "emoteShortcode":
            MessageLookupByLibrary.simpleMessage("Označení emotikony"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Musíte zvolit označení emotikony a obrázek!"),
        "emptyChat": MessageLookupByLibrary.simpleMessage("Prázdná diskuze"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "Šifrování jiš nebude možné vypnout. Jste si tím jisti?"),
        "encryption": MessageLookupByLibrary.simpleMessage("Šifrování"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Šifrovací algoritmus"),
        "encryptionNotEnabled":
            MessageLookupByLibrary.simpleMessage("Šifrování není aktivní"),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "Nastavení koncového šifrování"),
        "endedTheCall": m26,
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("Zadejte jméno skupiny"),
        "enterAUsername":
            MessageLookupByLibrary.simpleMessage("Zadejte uživatelské jméno"),
        "enterYourHomeserver":
            MessageLookupByLibrary.simpleMessage("Zadejte adresu serveru"),
        "fileName": MessageLookupByLibrary.simpleMessage("Název souboru"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Velikost souboru"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("Přeposlat"),
        "friday": MessageLookupByLibrary.simpleMessage("Pátek"),
        "fromJoining": MessageLookupByLibrary.simpleMessage("Od připojení"),
        "fromTheInvitation": MessageLookupByLibrary.simpleMessage("Od pozvání"),
        "group": MessageLookupByLibrary.simpleMessage("Skupina"),
        "groupDescription":
            MessageLookupByLibrary.simpleMessage("Popis skupiny"),
        "groupDescriptionHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Popis skupiny byl změněn"),
        "groupIsPublic":
            MessageLookupByLibrary.simpleMessage("Skupina je veřejná"),
        "groupWith": m27,
        "guestsAreForbidden":
            MessageLookupByLibrary.simpleMessage("Hosté jsou zakázáni"),
        "guestsCanJoin":
            MessageLookupByLibrary.simpleMessage("Hosté se mohou připojit"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Pomoc"),
        "homeserverIsNotCompatible":
            MessageLookupByLibrary.simpleMessage("Server není kompatibilní"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "identity": MessageLookupByLibrary.simpleMessage("Identita"),
        "ignoreListDescription": MessageLookupByLibrary.simpleMessage(
            "Můžete ignorovat uživatele, kteří vás znepokojují. Nebudete moci přijímat žádné zprávy nebo pozvánky od uživatelů na vašem osobním seznamu ignorovaných."),
        "ignoreUsername":
            MessageLookupByLibrary.simpleMessage("Ignorovat uživatelské jméno"),
        "ignoredUsers":
            MessageLookupByLibrary.simpleMessage("Ignorovaní uživatelé"),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Nesprávné přístupové heslo anebo klíč pro obnovu"),
        "inviteContact": MessageLookupByLibrary.simpleMessage("Pozvat kontakt"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("Pozváni"),
        "invitedUser": m31,
        "invitedUsersOnly":
            MessageLookupByLibrary.simpleMessage("Pouze pozvaní uživatelé"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Je následjící kód zařízení správný?"),
        "isTyping": MessageLookupByLibrary.simpleMessage("píše…"),
        "joinRoom":
            MessageLookupByLibrary.simpleMessage("Vstoupil do místnosti"),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage(
            "Klíče jsou uloženy v mezipaměti"),
        "keysMissing": MessageLookupByLibrary.simpleMessage("Chybí klíče"),
        "kickFromChat":
            MessageLookupByLibrary.simpleMessage("Vyhodit z diskuze"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp":
            MessageLookupByLibrary.simpleMessage("Naposledy viděná IP"),
        "lastSeenLongTimeAgo":
            MessageLookupByLibrary.simpleMessage("Viděni velmi dávno"),
        "leave": MessageLookupByLibrary.simpleMessage("Odejít"),
        "leftTheChat": MessageLookupByLibrary.simpleMessage("Odešel z diskuze"),
        "license": MessageLookupByLibrary.simpleMessage("Licence"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Světlý"),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage("Načíst další…"),
        "loadingPleaseWait":
            MessageLookupByLibrary.simpleMessage("Načítání… Prosíme počkejte"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("Přihlášení"),
        "logout": MessageLookupByLibrary.simpleMessage("Odhlásit"),
        "makeAModerator":
            MessageLookupByLibrary.simpleMessage("Učiň moderátorem"),
        "makeAnAdmin": MessageLookupByLibrary.simpleMessage("Učiň adminem"),
        "makeSureTheIdentifierIsValid": MessageLookupByLibrary.simpleMessage(
            "Ujistěte se, že je identifikátor validní"),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "Zpráva bude odstraněna pro všechny účastníky"),
        "moderator": MessageLookupByLibrary.simpleMessage("Moderátor"),
        "monday": MessageLookupByLibrary.simpleMessage("Pondělí"),
        "muteChat": MessageLookupByLibrary.simpleMessage("Ztišit diskuzi"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(
            "Prosím vezměte na vědomí, že pro použití koncového šifrování je prozatím potřeba použít Pantalaimon."),
        "newMessageInFluffyChat":
            MessageLookupByLibrary.simpleMessage("Nová zpráva ve FluffyChatu"),
        "newPrivateChat":
            MessageLookupByLibrary.simpleMessage("Nová soukromá diskuze"),
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("Nová žádost o ověření!"),
        "no": MessageLookupByLibrary.simpleMessage("Ne"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychet momentálně nepodporuje aktivaci křížového podpisu. Prosím aktivujte ho z klientu Riot."),
        "noEmotesFound": MessageLookupByLibrary.simpleMessage(
            "Žádné emotikony nebyly nalezeny. 😕"),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "Vypadá to, že váš telefon nemá nainstalovány google services. Dobré rozhodnutí pro vaši bezpečnost! Pro příjem notifikací doporučujeme použít miocroG: https://microg.org/"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychet momentálně nepodporuje aktivaci online záloh klíčů. Prosím zapněte ji z klientu Riot."),
        "noPermission": MessageLookupByLibrary.simpleMessage("Chybí oprávnění"),
        "noRoomsFound": MessageLookupByLibrary.simpleMessage(
            "Žádné místnosti nebyly nalezeny…"),
        "none": MessageLookupByLibrary.simpleMessage("Nic"),
        "notSupportedInWeb":
            MessageLookupByLibrary.simpleMessage("Nepodporováno na webu"),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Online záloha klíčů je vypnutá"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Online záloha kíčů je zapnuta"),
        "oopsSomethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Ups! Něco se pokazilo…"),
        "openAppToReadMessages": MessageLookupByLibrary.simpleMessage(
            "Otevřete aplikaci pro přečtení zpráv"),
        "openCamera":
            MessageLookupByLibrary.simpleMessage("Otevřít fotoaparát"),
        "optionalGroupName":
            MessageLookupByLibrary.simpleMessage("(Volitelné) Název skupiny"),
        "participatingUserDevices": MessageLookupByLibrary.simpleMessage(
            "Zúčastněná zařízení uživatele"),
        "passphraseOrKey":
            MessageLookupByLibrary.simpleMessage("heslo nebo klíč k ověření"),
        "password": MessageLookupByLibrary.simpleMessage("Heslo"),
        "pickImage": MessageLookupByLibrary.simpleMessage("Zvolit obrázek"),
        "pin": MessageLookupByLibrary.simpleMessage("Připnout zprávu"),
        "play": m39,
        "pleaseChooseAUsername": MessageLookupByLibrary.simpleMessage(
            "Prosíme zvolte si uživatelské jméno"),
        "pleaseEnterAMatrixIdentifier": MessageLookupByLibrary.simpleMessage(
            "Prosíme zadejte identifikátor sítě matrix"),
        "pleaseEnterYourPassword":
            MessageLookupByLibrary.simpleMessage("Prosíme zadejte heslo"),
        "pleaseEnterYourUsername": MessageLookupByLibrary.simpleMessage(
            "Prosíme zadejte uživateslké jméno"),
        "publicRooms":
            MessageLookupByLibrary.simpleMessage("Veřejné místnosti"),
        "recording": MessageLookupByLibrary.simpleMessage("Nahrávání"),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("Zamítnout"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("Připojit znovu"),
        "remove": MessageLookupByLibrary.simpleMessage("Odstranit"),
        "removeAllOtherDevices": MessageLookupByLibrary.simpleMessage(
            "Odstranit všechna další zařízení"),
        "removeDevice":
            MessageLookupByLibrary.simpleMessage("Odstraň zařízení"),
        "removeExile": MessageLookupByLibrary.simpleMessage("Odblokovat"),
        "removeMessage":
            MessageLookupByLibrary.simpleMessage("Odstranit zprávu"),
        "removedBy": m42,
        "renderRichContent":
            MessageLookupByLibrary.simpleMessage("Zobrazit formátovaný obsah"),
        "reply": MessageLookupByLibrary.simpleMessage("Odpovědět"),
        "requestPermission":
            MessageLookupByLibrary.simpleMessage("Vyžádat oprávnění"),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(
            "Vyžádat přečtení starších zpráv"),
        "revokeAllPermissions": MessageLookupByLibrary.simpleMessage(
            "Vezmi zpět všechna oprávnění"),
        "roomHasBeenUpgraded":
            MessageLookupByLibrary.simpleMessage("Místnost byla upgradována"),
        "saturday": MessageLookupByLibrary.simpleMessage("Sobota"),
        "searchForAChat":
            MessageLookupByLibrary.simpleMessage("Hledej diskuzi"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("Odeslat"),
        "sendAMessage": MessageLookupByLibrary.simpleMessage("Odeslat zprávu"),
        "sendAudio": MessageLookupByLibrary.simpleMessage("Odeslat audio"),
        "sendBugReports": MessageLookupByLibrary.simpleMessage(
            "Umožňuje zasílání hlášení o chybách prostřednictvím sentry.io"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Odeslat soubor"),
        "sendImage": MessageLookupByLibrary.simpleMessage("Odeslat obrázek"),
        "sendOriginal":
            MessageLookupByLibrary.simpleMessage("Odeslat originál"),
        "sendVideo": MessageLookupByLibrary.simpleMessage("Odeslat video"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sentryInfo": MessageLookupByLibrary.simpleMessage(
            "Informace o vašem soukromí: https://sentry.io/security/"),
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Sezení je ověřeno"),
        "setAProfilePicture":
            MessageLookupByLibrary.simpleMessage("Nastavit profilový obrázek"),
        "setGroupDescription":
            MessageLookupByLibrary.simpleMessage("Nastavit popis skupiny"),
        "setInvitationLink":
            MessageLookupByLibrary.simpleMessage("Nastavit zvací odkaz"),
        "setStatus": MessageLookupByLibrary.simpleMessage("Nastavit status"),
        "settings": MessageLookupByLibrary.simpleMessage("Nastavení"),
        "share": MessageLookupByLibrary.simpleMessage("Sdílet"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("Registrovat se"),
        "skip": MessageLookupByLibrary.simpleMessage("Přeskočit"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Zdrojové kódy"),
        "startYourFirstChat": MessageLookupByLibrary.simpleMessage(
            "Začněte svou první diskuzi :)"),
        "startedACall": m53,
        "statusExampleMessage":
            MessageLookupByLibrary.simpleMessage("Jak se máte?"),
        "submit": MessageLookupByLibrary.simpleMessage("Potvrdit"),
        "sunday": MessageLookupByLibrary.simpleMessage("Neděle"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("Systém"),
        "tapToShowMenu":
            MessageLookupByLibrary.simpleMessage("Klepněte pro zobrazení menu"),
        "theyDontMatch": MessageLookupByLibrary.simpleMessage("Neshodují se"),
        "theyMatch": MessageLookupByLibrary.simpleMessage("Shodují se"),
        "thisRoomHasBeenArchived": MessageLookupByLibrary.simpleMessage(
            "Tato místnost byla archivována."),
        "thursday": MessageLookupByLibrary.simpleMessage("Čtvrtek"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain":
            MessageLookupByLibrary.simpleMessage("Pokusit se odeslat znovu"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Úterý"),
        "unbannedUser": m55,
        "unblockDevice":
            MessageLookupByLibrary.simpleMessage("Odblokovat zařízení"),
        "unknownDevice":
            MessageLookupByLibrary.simpleMessage("Neznámé zařízení"),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(
            "Neznámý šifrovací algoritmus"),
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Neznámé sezení, prosím o ověření"),
        "unmuteChat": MessageLookupByLibrary.simpleMessage("Zrušit ztišení"),
        "unpin": MessageLookupByLibrary.simpleMessage("Odepnout zprávu"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(
            "Použít barvy kompatibilní s Amoled displayem?"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("Uživatelské jméno"),
        "verifiedSession":
            MessageLookupByLibrary.simpleMessage("Sezení úspěšně ověřeno!"),
        "verify": MessageLookupByLibrary.simpleMessage("Ověř"),
        "verifyManual": MessageLookupByLibrary.simpleMessage("Ověřit ručně"),
        "verifyStart": MessageLookupByLibrary.simpleMessage("Spustit ověření"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Ověření proběhlo úspěšně!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Ověřuji druhý účet"),
        "verifyUser": MessageLookupByLibrary.simpleMessage("Ověřit uživatele"),
        "videoCall": MessageLookupByLibrary.simpleMessage("Video hovor"),
        "visibilityOfTheChatHistory": MessageLookupByLibrary.simpleMessage(
            "Viditelnost historie diskuze"),
        "visibleForAllParticipants": MessageLookupByLibrary.simpleMessage(
            "Viditelné pro všechny účastníky"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("Viditelné pro všechny"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("Hlasová zpráva"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Čeká se na potvrzení žádosti partnerem…"),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Čeká se na potvrzení emoji partnerem…"),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Čeká se na potvrzení čísel partnerem…"),
        "wallpaper": MessageLookupByLibrary.simpleMessage("Pozadí"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "Koncové šifrování je momentálně v Beta verzi! Používejte na vlastní nebezpečí!"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Středa"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Vítejte v nejroztomilejší diskuzní aplikaci pro síť matrix."),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(
            "Kdo se může připojit do této skupiny"),
        "writeAMessage":
            MessageLookupByLibrary.simpleMessage("Napište zprávu…"),
        "yes": MessageLookupByLibrary.simpleMessage("Ano"),
        "you": MessageLookupByLibrary.simpleMessage("Ty"),
        "youAreInvitedToThisChat":
            MessageLookupByLibrary.simpleMessage("Jste zváni do této diskuze"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(
                "Této diskuze se nadále neúčastníte"),
        "youCannotInviteYourself":
            MessageLookupByLibrary.simpleMessage("Nemůžete pozvat sami sebe"),
        "youHaveBeenBannedFromThisChat": MessageLookupByLibrary.simpleMessage(
            "Byl vám zablokován přístup k tomuto chatu"),
        "yourOwnUsername": MessageLookupByLibrary.simpleMessage(
            "Vaše vlastní uživatelské jméno")
      };
}
