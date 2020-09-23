// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a et locale. All the
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
  String get localeName => 'et';

  static m0(username) => "${username} võttis kutse vastu";

  static m1(username) => "${username} võttis kasutusele läbiva krüptimise";

  static m2(senderName) => "${senderName} vastas kõnele";

  static m3(username) =>
      "Kas võtad vastu selle verifitseerimispalve kasutajalt ${username}?";

  static m4(username, targetName) =>
      "${username} keelas ligipääsu kasutajale ${targetName}";

  static m5(homeserver) =>
      "Vaikimisi kasutame ühendust koduserveriga ${homeserver}";

  static m6(username) => "${username} muutis vestluse tunnuspilti";

  static m7(username, description) =>
      "${username} muutis vestluse uueks kirjelduseks „${description}“";

  static m8(username, chatname) =>
      "${username} muutis oma uueks kuvatavaks nimeks „${chatname}“";

  static m9(username) => "${username} muutis vestlusega seotud õigusi";

  static m10(username, displayname) =>
      "${username} muutis uueks kuvatavaks nimeks: ${displayname}";

  static m11(username) => "${username} muutis külaliste ligipääsureegleid";

  static m12(username, rules) =>
      "${username} muutis külaliste ligipääsureegleid järgnevalt: ${rules}";

  static m13(username) => "${username} muutis sõnumite ajaloo nähtavust";

  static m14(username, rules) =>
      "${username} muutis sõnumite ajaloo nähtavust järgnevalt: ${rules}";

  static m15(username) => "${username} muutis liitumise reegleid";

  static m16(username, joinRules) =>
      "${username} muutis liitumise reegleid järgnevalt: ${joinRules}";

  static m17(username) => "${username} muutis oma tunnuspilti";

  static m18(username) => "${username} muutis jututoa aliast";

  static m19(username) => "${username} muutis kutse linki";

  static m20(error) => "Sõnumi dekrüptimine ei õnnestunud: ${error}";

  static m21(count) => "${count} osalejat";

  static m22(username) => "${username} algatas vestluse";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${day}.${month}.${year}";

  static m25(month, day) => "${day}.${month}";

  static m26(senderName) => "${senderName} lõpetas kõne";

  static m27(displayname) => "Rühm ${displayname} kasutajanimega";

  static m28(username, targetName) =>
      "${username} on võtnud tagasi ${targetName} kutse";

  static m29(groupName) => "Kutsu neid, keda sa tead ${groupName} liikmeks";

  static m30(username, link) =>
      "${username} kutsus sind kasutama Matrix\'i-põhist suhtlusrakendust FluffyChat. \n1. Paigalda FluffyChat: https://fluffychat.im \n2. Liitu kasutajaks või logi sisse olemasoleva Matrix\'i kasutajaga\n3. Ava kutse link: ${link}";

  static m31(username, targetName) =>
      "${username} kutsus kasutajaks ${targetName}";

  static m32(username) => "${username} liitus vestlusega";

  static m33(username, targetName) =>
      "${username} müksas kasutaja ${targetName} välja";

  static m34(username, targetName) =>
      "${username} müksas kasutaja ${targetName} välja ning seadis talle suhtluskeelu";

  static m35(localizedTimeShort) => "Viimati nähtud: ${localizedTimeShort}";

  static m36(count) => "Lisa veel ${count} osalejat";

  static m37(homeserver) => "Logi sisse ${homeserver} serverisse";

  static m38(number) => "${number} valitud";

  static m39(fileName) => "Esita ${fileName}";

  static m40(username) => "${username} muutis sündmust";

  static m41(username) => "${username} lükkas kutse tagasi";

  static m42(username) => "Eemaldatud ${username} poolt";

  static m43(username) => "Nähtud ${username} poolt";

  static m44(username, count) =>
      "Nähtud ${username} ja ${count} muu kasutaja poolt";

  static m45(username, username2) => "Nähtud ${username} ja ${username2} poolt";

  static m46(username) => "${username} saatis faili";

  static m47(username) => "${username} saatis pildi";

  static m48(username) => "${username} saatis kleepsu";

  static m49(username) => "${username} saatis video";

  static m50(username) => "${username} saatis helifaili";

  static m51(senderName) => "${senderName} saatis teavet kõne kohta";

  static m52(username) => "${username} jagas asukohta";

  static m53(senderName) => "${senderName} alustas kõnet";

  static m54(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m55(username, targetName) =>
      "${username} eemaldas ligipääsukeelu kasutajalt ${targetName}";

  static m56(type) => "Tundmatu sündmuse tüüp „${type}“";

  static m57(unreadCount) => "${unreadCount} lugemata vestlus(t)";

  static m58(unreadEvents) => "${unreadEvents} lugemata sõnum(it)";

  static m59(unreadEvents, unreadChats) =>
      "${unreadEvents} lugemata sõnum(it) ${unreadChats} vestluses";

  static m60(username, count) => "${username} ja ${count} muud kirjutavad...";

  static m61(username, username2) =>
      "${username} ja ${username2} kirjutavad...";

  static m62(username) => "${username} kirjutab...";

  static m63(username) => "${username} lahkus vestlusest";

  static m64(username, type) => "${username} saatis ${type} sündmuse";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("Rakenduse teave"),
        "accept": MessageLookupByLibrary.simpleMessage("Nõustu"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Kasutajakonto"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Kasutajakonto teave"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription":
            MessageLookupByLibrary.simpleMessage("Lisa rühma kirjeldus"),
        "admin": MessageLookupByLibrary.simpleMessage("Peakasutaja"),
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "alreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage(
            "Sul juba on kasutajakonto olemas?"),
        "answeredTheCall": m2,
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("Kõik võivad liituda"),
        "archive": MessageLookupByLibrary.simpleMessage("Arhiiv"),
        "archivedRoom":
            MessageLookupByLibrary.simpleMessage("Arhiveeritud jututuba"),
        "areGuestsAllowedToJoin": MessageLookupByLibrary.simpleMessage(
            "Kas külalised võivad liituda"),
        "areYouSure":
            MessageLookupByLibrary.simpleMessage("Kas sa oled kindel?"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Krüptovõtmete puhverdamiseks palun sisesta oma turvahoidla paroolifraas või taastevõti."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Selleks, et teist osapoolt identifitseerivat allkirja anda, palun sisesta oma turvahoidla paroolifraas või taastevõti."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Oma sessiooni verifitseerimiseks palun sisesta oma turvahoidla paroolifraas või taastevõti."),
        "askVerificationRequest": m3,
        "authentication": MessageLookupByLibrary.simpleMessage("Autentimine"),
        "avatarHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Tunnuspilt on muudetud"),
        "banFromChat":
            MessageLookupByLibrary.simpleMessage("Keela ligipääs vestlusele"),
        "banned": MessageLookupByLibrary.simpleMessage(
            "Ligipääs vestlusele on keelatud"),
        "bannedUser": m4,
        "blockDevice": MessageLookupByLibrary.simpleMessage("Blokeeri seade"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Krüptovõtmed on edukalt puhverdatud!"),
        "cancel": MessageLookupByLibrary.simpleMessage("Tühista"),
        "changeTheHomeserver":
            MessageLookupByLibrary.simpleMessage("Muuda koduserverit"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("Muuda rühma nime"),
        "changeTheServer":
            MessageLookupByLibrary.simpleMessage("Muuda serverit"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("Muuda oma stiili"),
        "changeWallpaper":
            MessageLookupByLibrary.simpleMessage("Muuda taustapilti"),
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
        "changelog": MessageLookupByLibrary.simpleMessage("Muudatuste logi"),
        "changesHaveBeenSaved":
            MessageLookupByLibrary.simpleMessage("Salvestasin muudatused"),
        "channelCorruptedDecryptError": MessageLookupByLibrary.simpleMessage(
            "Kasutatud krüptimine on vigane"),
        "chat": MessageLookupByLibrary.simpleMessage("Vestlus"),
        "chatDetails": MessageLookupByLibrary.simpleMessage("Vestluse teave"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("Vali korralik salasõna"),
        "chooseAUsername":
            MessageLookupByLibrary.simpleMessage("Vali kasutajanimi"),
        "close": MessageLookupByLibrary.simpleMessage("Sulge"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Võrdle ja kontrolli, et emotikonid on teises seadmes täpselt samad:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Võrdle ja kontrolli, et järgnevad numbrid on teises seadmes täpselt samad:"),
        "confirm": MessageLookupByLibrary.simpleMessage("Kinnita"),
        "connect": MessageLookupByLibrary.simpleMessage("Ühenda"),
        "connectionAttemptFailed": MessageLookupByLibrary.simpleMessage(
            "Ühenduse loomise katse ebaõnnestus"),
        "contactHasBeenInvitedToTheGroup": MessageLookupByLibrary.simpleMessage(
            "Sinu kontakt on kutsutud liituma rühmaga"),
        "contentViewer": MessageLookupByLibrary.simpleMessage("Sisukuvaja"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Kopeerisin lõikelauale"),
        "copy": MessageLookupByLibrary.simpleMessage("Kopeeri"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar": MessageLookupByLibrary.simpleMessage(
            "Tunnuspildi seadmine ei õnnestunud"),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(
            "Kuvatava nime määramine ei õnnestunud"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Loo"),
        "createAccountNow":
            MessageLookupByLibrary.simpleMessage("Tee nüüd kasutajakonto"),
        "createNewGroup": MessageLookupByLibrary.simpleMessage("Loo uus rühm"),
        "createdTheChat": m22,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "Risttunnustamine ei ole kasutusel"),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(
            "Risttunnustamine on kasutusel"),
        "currentlyActive":
            MessageLookupByLibrary.simpleMessage("Hetkel aktiivne"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Tume"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "deactivateAccountWarning": MessageLookupByLibrary.simpleMessage(
            "Järgnevaga eemaldatakse sinu konto kasutusest. Seda tegevust ei saa tagasi pöörata! Kas sa ikka oled kindel?"),
        "delete": MessageLookupByLibrary.simpleMessage("Kustuta"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Kustuta kasutajakonto"),
        "deleteMessage": MessageLookupByLibrary.simpleMessage("Kustuta sõnum"),
        "deny": MessageLookupByLibrary.simpleMessage("Keela"),
        "device": MessageLookupByLibrary.simpleMessage("Seade"),
        "devices": MessageLookupByLibrary.simpleMessage("Seadmed"),
        "discardPicture": MessageLookupByLibrary.simpleMessage("Emalda pilt"),
        "displaynameHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Kuvatav nimi on muudetud"),
        "donate": MessageLookupByLibrary.simpleMessage("Toeta"),
        "downloadFile": MessageLookupByLibrary.simpleMessage("Lae fail alla"),
        "editDisplayname":
            MessageLookupByLibrary.simpleMessage("Muuda kuvatavat nime"),
        "editJitsiInstance":
            MessageLookupByLibrary.simpleMessage("Muuda Jitsi liidestust"),
        "emoteExists": MessageLookupByLibrary.simpleMessage(
            "Selline emotsioonitegevus on juba olemas!"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Vigane emotsioonitegevuse lühikood!"),
        "emoteSettings": MessageLookupByLibrary.simpleMessage(
            "Emotsioonitegevuste seadistused"),
        "emoteShortcode":
            MessageLookupByLibrary.simpleMessage("Emotsioonitegevuse lühikood"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Sa pead valima emotsioonitegevuse lühikoodi ja pildi!"),
        "emptyChat":
            MessageLookupByLibrary.simpleMessage("Vestlust pole olnud"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "Sa ei saa hiljem enam krüptimist välja lülitada. Kas oled kindel?"),
        "encryption": MessageLookupByLibrary.simpleMessage("Krüptimine"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Krüptoalgoritm"),
        "encryptionNotEnabled":
            MessageLookupByLibrary.simpleMessage("Krüptimine ei ole kasutusel"),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "Läbiva krüptimise seadistused"),
        "endedTheCall": m26,
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("Sisesta rühma nimi"),
        "enterAUsername":
            MessageLookupByLibrary.simpleMessage("Sisesta kasutajanimi"),
        "enterYourHomeserver": MessageLookupByLibrary.simpleMessage(
            "Sisesta oma koduserveri aadress"),
        "fileName": MessageLookupByLibrary.simpleMessage("Faili nimi"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Faili suurus"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("Edasi"),
        "friday": MessageLookupByLibrary.simpleMessage("Reede"),
        "fromJoining":
            MessageLookupByLibrary.simpleMessage("Alates liitumise hetkest"),
        "fromTheInvitation":
            MessageLookupByLibrary.simpleMessage("Kutse saamisest"),
        "group": MessageLookupByLibrary.simpleMessage("Rühm"),
        "groupDescription":
            MessageLookupByLibrary.simpleMessage("Rühma kirjeldus"),
        "groupDescriptionHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Rühma kirjeldus on muutunud"),
        "groupIsPublic": MessageLookupByLibrary.simpleMessage("Rühm on avalik"),
        "groupWith": m27,
        "guestsAreForbidden":
            MessageLookupByLibrary.simpleMessage("Külalised ei ole lubatud"),
        "guestsCanJoin":
            MessageLookupByLibrary.simpleMessage("Külalised võivad liituda"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Abiteave"),
        "homeserverIsNotCompatible":
            MessageLookupByLibrary.simpleMessage("Koduserver ei ole ühilduv"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "identity": MessageLookupByLibrary.simpleMessage("Identiteet"),
        "ignoreListDescription": MessageLookupByLibrary.simpleMessage(
            "Sul on võimalik eirata neid kasutajaid, kes sind segavad. Oma isiklikku eiramisloendisse lisatud kasutajad ei saa sulle saata sõnumeid ega kutseid."),
        "ignoreUsername":
            MessageLookupByLibrary.simpleMessage("Eira kasutajanime"),
        "ignoredUsers":
            MessageLookupByLibrary.simpleMessage("Eiratud kasutajad"),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Vigane paroolifraas või taastevõti"),
        "inviteContact":
            MessageLookupByLibrary.simpleMessage("Kutsu neid, keda sa tead"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("Kutsutud"),
        "invitedUser": m31,
        "invitedUsersOnly": MessageLookupByLibrary.simpleMessage(
            "Ainult kutsutud kasutajatele"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Kas järgnev seadmevõti on õige?"),
        "isTyping": MessageLookupByLibrary.simpleMessage("kirjutab..."),
        "joinRoom": MessageLookupByLibrary.simpleMessage("Liitu jututoaga"),
        "joinedTheChat": m32,
        "keysCached":
            MessageLookupByLibrary.simpleMessage("Krüptovõtmed on puhverdatud"),
        "keysMissing":
            MessageLookupByLibrary.simpleMessage("Krüptovõtmed on puudu"),
        "kickFromChat":
            MessageLookupByLibrary.simpleMessage("Müksa vestlusest välja"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp":
            MessageLookupByLibrary.simpleMessage("Viimati nähtud IP-aadress"),
        "lastSeenLongTimeAgo":
            MessageLookupByLibrary.simpleMessage("Nähtud ammu aega tagasi"),
        "leave": MessageLookupByLibrary.simpleMessage("Lahku"),
        "leftTheChat":
            MessageLookupByLibrary.simpleMessage("Lahkus vestlusest"),
        "license": MessageLookupByLibrary.simpleMessage("Litsents"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Hele"),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage("Lae veel..."),
        "loadingPleaseWait":
            MessageLookupByLibrary.simpleMessage("Laen andmeid... Palun oota"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("Logi sisse"),
        "logout": MessageLookupByLibrary.simpleMessage("Logi välja"),
        "makeAModerator":
            MessageLookupByLibrary.simpleMessage("Määra moderaatoriks"),
        "makeAnAdmin":
            MessageLookupByLibrary.simpleMessage("Määra peakasutajaks"),
        "makeSureTheIdentifierIsValid": MessageLookupByLibrary.simpleMessage(
            "Kontrolli, et see tunnus oleks õige"),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "Sõnum eemaldatakse kõikidelt kasutajatelt"),
        "moderator": MessageLookupByLibrary.simpleMessage("Moderaator"),
        "monday": MessageLookupByLibrary.simpleMessage("Esmaspäev"),
        "muteChat": MessageLookupByLibrary.simpleMessage("Summuta vestlus"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(
            "Palun arvesta, et sa saad hetkel kasutada läbivat krüptimist vaid siis, kui koduserver kasutab Pantalaimon\'it."),
        "newMessageInFluffyChat": MessageLookupByLibrary.simpleMessage(
            "Uus sõnum FluffyChat\'i vahendusel"),
        "newPrivateChat":
            MessageLookupByLibrary.simpleMessage("Uus privaatne vestlus"),
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("Uus verifitseerimispäring!"),
        "no": MessageLookupByLibrary.simpleMessage("Ei"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "FluffyChat hetkel ei toeta risttunnustamist. Palun võta ta kasutusele Element\'i (vana nimega Riot) vahendusel."),
        "noEmotesFound": MessageLookupByLibrary.simpleMessage(
            "Ühtegi emotsioonitegevust ei leidunud. 😕"),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "Tundub, et sinu nutiseadmes pole Google teenuseid. Sinu privaatsuse mõttes on see kindlasti hea otsus! Kui sa soovid FluffyChat\'is näha tõuketeavitusi, siis soovitame, et selle jaoks kasutad microG liidestust https://microg.org/"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "FluffyChat hetkel ei toeta krüptovõtmete võrgupõhise varunduse kasutusele võtmist. Palun võta ta kasutusele Element\'i (vana nimega Riot) vahendusel."),
        "noPermission":
            MessageLookupByLibrary.simpleMessage("Õigused puuduvad"),
        "noRoomsFound":
            MessageLookupByLibrary.simpleMessage("Jututubasid ei leidunud..."),
        "none": MessageLookupByLibrary.simpleMessage("Mitte midagi"),
        "notSupportedInWeb": MessageLookupByLibrary.simpleMessage(
            "See funktsionaalsus ei ole veebiliideses toetatud"),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("sobib"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Krüptovõtmete veebipõhine varundus ei ole kasutusel"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Krüptovõtmete veebipõhine varundus on kasutusel"),
        "oopsSomethingWentWrong": MessageLookupByLibrary.simpleMessage(
            "Hopsti! Midagi läks nüüd viltu..."),
        "openAppToReadMessages": MessageLookupByLibrary.simpleMessage(
            "Sõnumite lugemiseks ava rakendus"),
        "openCamera": MessageLookupByLibrary.simpleMessage("Ava kaamera"),
        "optionalGroupName":
            MessageLookupByLibrary.simpleMessage("(Kui soovid) Rühma nimi"),
        "participatingUserDevices":
            MessageLookupByLibrary.simpleMessage("Kaasatud kasutajate seadmed"),
        "passphraseOrKey":
            MessageLookupByLibrary.simpleMessage("paroolifraas või taastevõti"),
        "password": MessageLookupByLibrary.simpleMessage("Salasõna"),
        "passwordHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Salasõna on muudetud"),
        "pickImage": MessageLookupByLibrary.simpleMessage("Vali pilt"),
        "pin": MessageLookupByLibrary.simpleMessage("Klammerda"),
        "play": m39,
        "pleaseChooseAUsername":
            MessageLookupByLibrary.simpleMessage("Palun vali kasutajanimi"),
        "pleaseEnterAMatrixIdentifier": MessageLookupByLibrary.simpleMessage(
            "Palun sisesta Matrix\'i kasutajatunnus"),
        "pleaseEnterYourPassword":
            MessageLookupByLibrary.simpleMessage("Palun sisesta oma salasõna"),
        "pleaseEnterYourUsername": MessageLookupByLibrary.simpleMessage(
            "Palun sisesta oma kasutajanimi"),
        "publicRooms":
            MessageLookupByLibrary.simpleMessage("Avalikud jututoad"),
        "recording": MessageLookupByLibrary.simpleMessage("Salvestan"),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("Lükka tagasi"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("Liitu uuesti"),
        "remove": MessageLookupByLibrary.simpleMessage("Eemalda"),
        "removeAllOtherDevices":
            MessageLookupByLibrary.simpleMessage("Eemalda kõik muud seadmed"),
        "removeDevice": MessageLookupByLibrary.simpleMessage("Eemalda seade"),
        "removeExile":
            MessageLookupByLibrary.simpleMessage("Eemalda suhtluskeeld"),
        "removeMessage": MessageLookupByLibrary.simpleMessage("Eemalda sõnum"),
        "removedBy": m42,
        "renderRichContent": MessageLookupByLibrary.simpleMessage(
            "Visualiseeri vormindatud sõnumite sisu"),
        "reply": MessageLookupByLibrary.simpleMessage("Vasta"),
        "requestPermission":
            MessageLookupByLibrary.simpleMessage("Palu õigusi"),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(
            "Palu õigust lugeda vanu sõnumeid"),
        "revokeAllPermissions":
            MessageLookupByLibrary.simpleMessage("Tühista kõik õigused"),
        "roomHasBeenUpgraded":
            MessageLookupByLibrary.simpleMessage("Jututuba on uuendatud"),
        "saturday": MessageLookupByLibrary.simpleMessage("Laupäev"),
        "searchForAChat": MessageLookupByLibrary.simpleMessage("Otsi vestlust"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("Saada"),
        "sendAMessage": MessageLookupByLibrary.simpleMessage("Saada sõnum"),
        "sendAudio": MessageLookupByLibrary.simpleMessage("Saada helifail"),
        "sendBugReports": MessageLookupByLibrary.simpleMessage(
            "Luba veateadete saatmist sentry.io vahendusel"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Saada fail"),
        "sendImage": MessageLookupByLibrary.simpleMessage("Saada pilt"),
        "sendOriginal":
            MessageLookupByLibrary.simpleMessage("Saada algupärane fail"),
        "sendVideo": MessageLookupByLibrary.simpleMessage("Saada videofail"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sentryInfo": MessageLookupByLibrary.simpleMessage(
            "Teave sinu privaatsuse kohta: https://sentry.io/security/"),
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Sessioon on verifitseeritud"),
        "setAProfilePicture":
            MessageLookupByLibrary.simpleMessage("Seadista profiilipilt"),
        "setGroupDescription":
            MessageLookupByLibrary.simpleMessage("Seadista rühma kirjeldus"),
        "setInvitationLink":
            MessageLookupByLibrary.simpleMessage("Tee kutse link"),
        "setStatus": MessageLookupByLibrary.simpleMessage("Määra olek"),
        "settings": MessageLookupByLibrary.simpleMessage("Seadistused"),
        "share": MessageLookupByLibrary.simpleMessage("Jaga"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("Liitu"),
        "skip": MessageLookupByLibrary.simpleMessage("Jäta vahele"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Lähtekood"),
        "startYourFirstChat": MessageLookupByLibrary.simpleMessage(
            "Alusta oma esimest vestlust :-)"),
        "startedACall": m53,
        "statusExampleMessage":
            MessageLookupByLibrary.simpleMessage("Kuidas sul täna läheb?"),
        "submit": MessageLookupByLibrary.simpleMessage("Saada"),
        "sunday": MessageLookupByLibrary.simpleMessage("Pühapäev"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("Süsteem"),
        "tapToShowMenu":
            MessageLookupByLibrary.simpleMessage("Menüü kuvamiseks puuduta"),
        "theyDontMatch":
            MessageLookupByLibrary.simpleMessage("Nad ei klapi omavahel"),
        "theyMatch":
            MessageLookupByLibrary.simpleMessage("Nad klapivad omavahel"),
        "thisRoomHasBeenArchived": MessageLookupByLibrary.simpleMessage(
            "See jututuba on arhiveeritud."),
        "thursday": MessageLookupByLibrary.simpleMessage("Neljapäev"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain":
            MessageLookupByLibrary.simpleMessage("Proovi uuesti saata"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Teisipäev"),
        "unbannedUser": m55,
        "unblockDevice":
            MessageLookupByLibrary.simpleMessage("Eemalda seadmelt blokeering"),
        "unknownDevice": MessageLookupByLibrary.simpleMessage("Tundmatu seade"),
        "unknownEncryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Tundmatu krüptoalgoritm"),
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Tundmatu sessioon, palun verifitseeri"),
        "unmuteChat": MessageLookupByLibrary.simpleMessage(
            "Lõpeta vestluse vaigistamine"),
        "unpin": MessageLookupByLibrary.simpleMessage("Eemalda klammerdus"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(
            "Kas kasutame amoled-tehnoloogiaga ühilduvaid värve?"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("Kasutajanimi"),
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Sessiooni verifitseerimine õnnestus!"),
        "verify": MessageLookupByLibrary.simpleMessage("Verifitseeri"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Verifitseeri käsitsi"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Alusta verifitseerimist"),
        "verifySuccess": MessageLookupByLibrary.simpleMessage(
            "Verifitseerimine õnnestus sinul!"),
        "verifyTitle": MessageLookupByLibrary.simpleMessage(
            "Verifitseerin teist kasutajakontot"),
        "verifyUser":
            MessageLookupByLibrary.simpleMessage("Verifitseeri kasutajat"),
        "videoCall": MessageLookupByLibrary.simpleMessage("Videokõne"),
        "visibilityOfTheChatHistory":
            MessageLookupByLibrary.simpleMessage("Vestluse ajaloo nähtavus"),
        "visibleForAllParticipants": MessageLookupByLibrary.simpleMessage(
            "Nähtav kõikidele osalejatele"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("Nähtav kõikidele"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("Häälsõnum"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Ootan, et teine osapool nõustuks päringuga..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Ootan teise osapoole kinnitust, et tegemist on samade emojidega..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Ootan teise osapoole kinnitust, et tegemist on samade numbritega..."),
        "wallpaper": MessageLookupByLibrary.simpleMessage("Taustapilt"),
        "warning": MessageLookupByLibrary.simpleMessage("Hoiatus!"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "Läbiv krüptimine on parasjagu beetatestimise faasis! Kasuta seda omal vastutusel!"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Kolmapäev"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Tere tulemast kasutama kõige vahvamat sõnumiklienti Matrix\'i võrgus."),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(
            "Kes võivad selle rühmaga liituda"),
        "writeAMessage":
            MessageLookupByLibrary.simpleMessage("Kirjuta üks sõnum..."),
        "yes": MessageLookupByLibrary.simpleMessage("Jah"),
        "you": MessageLookupByLibrary.simpleMessage("Sina"),
        "youAreInvitedToThisChat": MessageLookupByLibrary.simpleMessage(
            "Sa oled kutsutud osalema selles vestluses"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(
                "Sa enam ei osale selles vestluses"),
        "youCannotInviteYourself": MessageLookupByLibrary.simpleMessage(
            "Sa ei saa endale kutset saata"),
        "youHaveBeenBannedFromThisChat": MessageLookupByLibrary.simpleMessage(
            "Sinule on selles vestluses seatud suhtluskeeld"),
        "yourOwnUsername":
            MessageLookupByLibrary.simpleMessage("Sinu oma kasutajanimi")
      };
}
