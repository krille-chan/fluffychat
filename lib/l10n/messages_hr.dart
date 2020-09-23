// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a hr locale. All the
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
  String get localeName => 'hr';

  static m0(username) => "${username} je prihvatio/la poziv";

  static m1(username) => "${username} je aktivirao/la obostrano šifriranje";

  static m2(senderName) => "${senderName} je odgovorio/la na poziv";

  static m3(username) =>
      "Prihvatiti ovaj zahtjev za potvrđivanje od ${username}?";

  static m4(username, targetName) =>
      "${username} je isključio/la ${targetName}";

  static m5(homeserver) => "Standardno ćeš biti povezan/a s ${homeserver}";

  static m6(username) => "${username} je promijenio/la avatar chata";

  static m7(username, description) =>
      "${username} je promijenio/la opis chata u: „${description}”";

  static m8(username, chatname) =>
      "${username} je promijenio/la ime chata u: „${chatname}”";

  static m9(username) => "${username} je promijenio/la dozvole chata";

  static m10(username, displayname) =>
      "${username} je promijenio/la prikazano ime u: ${displayname}";

  static m11(username) =>
      "${username} je promijenio/la pravila pristupa za goste";

  static m12(username, rules) =>
      "${username} je promijenio/la pravila pristupa za goste u: ${rules}";

  static m13(username) => "${username} je promijenio/la vidljivost kronologije";

  static m14(username, rules) =>
      "${username} je promijenio/la vidljivost kronologije u: ${rules}";

  static m15(username) => "${username} je promijenio/la pravila pridruživanja";

  static m16(username, joinRules) =>
      "${username} je promijenio/la pravila pridruživanja u: ${joinRules}";

  static m17(username) => "${username} je promijenio/la svoj avatar";

  static m18(username) => "${username} je promijenio/la pseudonime soba";

  static m19(username) => "${username} je promijenio/la poveznicu poziva";

  static m20(error) => "Neuspjelo dešifriranje poruke: ${error}";

  static m21(count) => "${count} sudionika";

  static m22(username) => "${username} je stvorio/la chat";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${day}. ${month}. ${year}.";

  static m25(month, day) => "${day}. ${month}.";

  static m26(senderName) => "${senderName} je završio/la poziv";

  static m27(displayname) => "Grupa s ${displayname}";

  static m28(username, targetName) =>
      "${username} je povukao/la poziv za ${targetName}";

  static m29(groupName) => "Pozovi kontakt u ${groupName}";

  static m30(username, link) =>
      "${username} te je pozvao/la u FluffyChat. \n1. Instaliraj FluffyChat: https://fluffychat.im \n2. Registriraj ili prijavi se \n3. Otvori poveznicu poziva: ${link}";

  static m31(username, targetName) => "${username} je pozvao/la ${targetName}";

  static m32(username) => "${username} se pridružio/la chatu";

  static m33(username, targetName) => "${username} je izbacio/la ${targetName}";

  static m34(username, targetName) =>
      "${username} je izbacio/la i isključio/la ${targetName}";

  static m35(localizedTimeShort) => "Zadnja aktivnost: ${localizedTimeShort}";

  static m36(count) => "Učitaj još ${count} sudionika";

  static m37(homeserver) => "Prijavi se na ${homeserver}";

  static m38(number) => "${number} odabrano";

  static m39(fileName) => "Sviraj ${fileName}";

  static m40(username) => "${username} je preuredio/la događaj";

  static m41(username) => "${username} je odbio/la poziv";

  static m42(username) => "Uklonjeno od ${username}";

  static m43(username) => "Viđeno od ${username}";

  static m44(username, count) =>
      "Viđeno od ${username} i još ${count} korisnika";

  static m45(username, username2) => "Viđeno od ${username} i ${username2}";

  static m46(username) => "${username} ja poslao/la datoteku";

  static m47(username) => "${username} ja poslao/la sliku";

  static m48(username) => "${username} je poslao/la naljepnicu";

  static m49(username) => "${username} ja poslao/la video";

  static m50(username) => "${username} ja poslao/la audio";

  static m51(senderName) => "${senderName} je poslao/la podatke poziva";

  static m52(username) => "${username} je dijelio/la mjesto";

  static m53(senderName) => "${senderName} ja započeo/la poziv";

  static m54(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m55(username, targetName) =>
      "${username} je ponovo uključio/la ${targetName}";

  static m56(type) => "Nepoznata vrsta događaja „${type}”";

  static m57(unreadCount) => "${unreadCount} nepročitana chata";

  static m58(unreadEvents) => "${unreadEvents} nepročitane poruke";

  static m59(unreadEvents, unreadChats) =>
      "${unreadEvents} nepročitane poruke u ${unreadChats} chata";

  static m60(username, count) => "${username} i još ${count} korisnika pišu …";

  static m61(username, username2) => "${username} i ${username2} pišu …";

  static m62(username) => "${username} piše …";

  static m63(username) => "${username} je napustio/la chat";

  static m64(username, type) => "${username} ja poslao/la ${type} događaj";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("Informacije"),
        "accept": MessageLookupByLibrary.simpleMessage("Prihvati"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Račun"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Podaci računa"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription":
            MessageLookupByLibrary.simpleMessage("Dodaj opis grupe"),
        "admin": MessageLookupByLibrary.simpleMessage("Administrator"),
        "alias": MessageLookupByLibrary.simpleMessage("pseudonim"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Već imaš račun?"),
        "answeredTheCall": m2,
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("Svatko se može pridružiti"),
        "archive": MessageLookupByLibrary.simpleMessage("Arhiva"),
        "archivedRoom": MessageLookupByLibrary.simpleMessage("Arhivirana soba"),
        "areGuestsAllowedToJoin": MessageLookupByLibrary.simpleMessage(
            "Smiju li se gosti pridružiti grupi"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Sigurno?"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Upiši svoju sigurnosnu lozinku ili ključ za obnavljanje, kako bi se ključevi spremili u predmemoriju."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Za potpisivanje druge osobe, upiši svoju sigurnosnu lozinku ili ključ za obnavljanje."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Za potvrđivanje tvoje sesije, upiši svoju sigurnosnu lozinku ili ključ za obnavljanje."),
        "askVerificationRequest": m3,
        "authentication":
            MessageLookupByLibrary.simpleMessage("Autentifikacija"),
        "avatarHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Avatar je promijenjen"),
        "banFromChat":
            MessageLookupByLibrary.simpleMessage("Isključi iz chata"),
        "banned": MessageLookupByLibrary.simpleMessage("Isključen"),
        "bannedUser": m4,
        "blockDevice": MessageLookupByLibrary.simpleMessage("Blokiraj uređaj"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Uspješno međuspremljeni ključevi!"),
        "cancel": MessageLookupByLibrary.simpleMessage("Odustani"),
        "changeTheHomeserver": MessageLookupByLibrary.simpleMessage(
            "Promijeni domaćeg poslužitelja"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("Promijeni ime grupe"),
        "changeTheServer":
            MessageLookupByLibrary.simpleMessage("Promijeni poslužitelja"),
        "changeTheme":
            MessageLookupByLibrary.simpleMessage("Promijeni svoj stil"),
        "changeWallpaper":
            MessageLookupByLibrary.simpleMessage("Promijeni sliku pozadine"),
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
        "changelog": MessageLookupByLibrary.simpleMessage("Zapis promjena"),
        "changesHaveBeenSaved":
            MessageLookupByLibrary.simpleMessage("Promjene nisu spremljene"),
        "channelCorruptedDecryptError":
            MessageLookupByLibrary.simpleMessage("Šifriranje je oštećeno"),
        "chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "chatDetails": MessageLookupByLibrary.simpleMessage("Detalji chata"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("Odaberi snažnu lozinku"),
        "chooseAUsername":
            MessageLookupByLibrary.simpleMessage("Odaberi korisničko ime"),
        "close": MessageLookupByLibrary.simpleMessage("Zatvori"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Usporedi i provjeri, poklapaju li se sljedeći emojiji s onima drugog uređaja:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Usporedi i provjeri, poklapaju li se sljedeći brojevi s onima drugog uređaja:"),
        "confirm": MessageLookupByLibrary.simpleMessage("Potvrdi"),
        "connect": MessageLookupByLibrary.simpleMessage("Spoji"),
        "connectionAttemptFailed":
            MessageLookupByLibrary.simpleMessage("Neuspio pokušaj povezivanja"),
        "contactHasBeenInvitedToTheGroup":
            MessageLookupByLibrary.simpleMessage("Kontakt je pozvan u grupu"),
        "contentViewer":
            MessageLookupByLibrary.simpleMessage("Prikazivač sadržaja"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Kopirano u međuspremnik"),
        "copy": MessageLookupByLibrary.simpleMessage("Kopiraj"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar": MessageLookupByLibrary.simpleMessage(
            "Neuspjelo postavljanje avatara"),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(
            "Neuspjelo postavljanje prikaznog imena"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Stvori"),
        "createAccountNow":
            MessageLookupByLibrary.simpleMessage("Stvori račun sada"),
        "createNewGroup":
            MessageLookupByLibrary.simpleMessage("Stvori novu grupu"),
        "createdTheChat": m22,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "Unakrsno potpisivanje je deaktivirano"),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(
            "Unakrsno potpisivanje je aktivirano"),
        "currentlyActive":
            MessageLookupByLibrary.simpleMessage("Trenutačno aktivni"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Tamna"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "deactivateAccountWarning": MessageLookupByLibrary.simpleMessage(
            "Ovo će nepovratno deaktivirati tvoj korisnički račun. Stvarno to želiš uraditi?"),
        "delete": MessageLookupByLibrary.simpleMessage("Izbriži"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Izbriši račun"),
        "deleteMessage": MessageLookupByLibrary.simpleMessage("Izbriži poruku"),
        "deny": MessageLookupByLibrary.simpleMessage("Odbij"),
        "device": MessageLookupByLibrary.simpleMessage("Uređaj"),
        "devices": MessageLookupByLibrary.simpleMessage("Uređaji"),
        "discardPicture": MessageLookupByLibrary.simpleMessage("Odbaci sliku"),
        "displaynameHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "Prikazno ime je promijenjeno"),
        "donate": MessageLookupByLibrary.simpleMessage("Doniraj"),
        "downloadFile":
            MessageLookupByLibrary.simpleMessage("Preuzmi datoteku"),
        "editDisplayname":
            MessageLookupByLibrary.simpleMessage("Uredi prikazano ime"),
        "editJitsiInstance":
            MessageLookupByLibrary.simpleMessage("Uredi Jitsi primjerak"),
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Emot već postoji!"),
        "emoteInvalid":
            MessageLookupByLibrary.simpleMessage("Neispravna kratica emota!"),
        "emoteSettings":
            MessageLookupByLibrary.simpleMessage("Postavke emojija"),
        "emoteShortcode": MessageLookupByLibrary.simpleMessage("Kratica emota"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Moraš odabrati jednu kraticu emota i sliku!"),
        "emptyChat": MessageLookupByLibrary.simpleMessage("Prazan chat"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "Više nećeš moći deaktivirati šifriranje. Sigurno?"),
        "encryption": MessageLookupByLibrary.simpleMessage("Šifriranje"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Algoritam šifriranja"),
        "encryptionNotEnabled":
            MessageLookupByLibrary.simpleMessage("Šifriranje nije aktivirano"),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "Postavke obostranog šifriranja"),
        "endedTheCall": m26,
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("Upiši ime grupe"),
        "enterAUsername":
            MessageLookupByLibrary.simpleMessage("Upiši korisničko ime"),
        "enterYourHomeserver": MessageLookupByLibrary.simpleMessage(
            "Upiši svog domaćeg poslužitelja"),
        "fileName": MessageLookupByLibrary.simpleMessage("Ime datoteke"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Veličina datoteke"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("Proslijedi"),
        "friday": MessageLookupByLibrary.simpleMessage("Petak"),
        "fromJoining": MessageLookupByLibrary.simpleMessage("Od pridruživanja"),
        "fromTheInvitation": MessageLookupByLibrary.simpleMessage("Od poziva"),
        "group": MessageLookupByLibrary.simpleMessage("Grupiraj"),
        "groupDescription": MessageLookupByLibrary.simpleMessage("Opis grupe"),
        "groupDescriptionHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Opis grupe je promijenjen"),
        "groupIsPublic": MessageLookupByLibrary.simpleMessage("Grupa je javna"),
        "groupWith": m27,
        "guestsAreForbidden":
            MessageLookupByLibrary.simpleMessage("Gosti su zabranjeni"),
        "guestsCanJoin":
            MessageLookupByLibrary.simpleMessage("Gosti se mogu pridružiti"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Pomoć"),
        "homeserverIsNotCompatible": MessageLookupByLibrary.simpleMessage(
            "Domaći poslužitelj nije kompatibilan"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "identity": MessageLookupByLibrary.simpleMessage("Identitet"),
        "ignoreListDescription": MessageLookupByLibrary.simpleMessage(
            "Možeš zanemariti korisnike koji te ometaju. Nećeš moći primiti nijednu poruku ili pozivnice u sobe od korisnika koji se nalaze u tvom osobnom popisu zanemarivanja."),
        "ignoreUsername":
            MessageLookupByLibrary.simpleMessage("Zanemari korisničko ime"),
        "ignoredUsers":
            MessageLookupByLibrary.simpleMessage("Zanemareni korisnici"),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Neispravna lozinka ili ključ za obnavljanje"),
        "inviteContact": MessageLookupByLibrary.simpleMessage("Pozovi kontakt"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("Pozvan/a"),
        "invitedUser": m31,
        "invitedUsersOnly":
            MessageLookupByLibrary.simpleMessage("Samo pozvani korisnici"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Je li sljedeći ključ uređaja ispravan?"),
        "isTyping": MessageLookupByLibrary.simpleMessage("piše …"),
        "joinRoom": MessageLookupByLibrary.simpleMessage("Pridruži se sobi"),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage(
            "Ključevi su spremljeni u predmemoriji"),
        "keysMissing":
            MessageLookupByLibrary.simpleMessage("Nedostaju ključevi"),
        "kickFromChat": MessageLookupByLibrary.simpleMessage("Izbaci iz chata"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp": MessageLookupByLibrary.simpleMessage("Zadnji viđeni IP"),
        "lastSeenLongTimeAgo":
            MessageLookupByLibrary.simpleMessage("Viđeno prije dugo vremena"),
        "leave": MessageLookupByLibrary.simpleMessage("Napusti"),
        "leftTheChat":
            MessageLookupByLibrary.simpleMessage("Napustio/la je chat"),
        "license": MessageLookupByLibrary.simpleMessage("Licenca"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Svjetla"),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage("Učitaj više …"),
        "loadingPleaseWait":
            MessageLookupByLibrary.simpleMessage("Učitava se … Pričekaj"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("Prijava"),
        "logout": MessageLookupByLibrary.simpleMessage("Odjava"),
        "makeAModerator":
            MessageLookupByLibrary.simpleMessage("Postavi kao voditelja"),
        "makeAnAdmin":
            MessageLookupByLibrary.simpleMessage("Postavi kao administratora"),
        "makeSureTheIdentifierIsValid": MessageLookupByLibrary.simpleMessage(
            "Provjeri je li identifikator ispravan"),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "Poruke će se ukloniti za sve sudionike"),
        "moderator": MessageLookupByLibrary.simpleMessage("Voditelj"),
        "monday": MessageLookupByLibrary.simpleMessage("Ponedjeljak"),
        "muteChat": MessageLookupByLibrary.simpleMessage("Isključi zvuk chata"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(
            "Za sada trebaš Pantalaimon za obostrano šifriranje."),
        "newMessageInFluffyChat":
            MessageLookupByLibrary.simpleMessage("Nova poruka u FluffyChatu"),
        "newPrivateChat":
            MessageLookupByLibrary.simpleMessage("Novi privatni chat"),
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("Novi zahtjev za provjeru!"),
        "no": MessageLookupByLibrary.simpleMessage("Ne"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat trenutačno ne podržava unakrsno potpisivanje. Aktiviraj je u Riot."),
        "noEmotesFound": MessageLookupByLibrary.simpleMessage("Nema emota. 😕"),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "Čini se da na mobitelu nemaš google usluge. To je dobra odluka za tvoju privatnost! Za primanje push obavijesti u FluffyChatu preporučujemo upotrebu microG-a: https://microg.org/"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat trenutačno ne podržava aktiviranje online sigurnosnu kopiju ključeva. Aktiviraj je u Riot."),
        "noPermission": MessageLookupByLibrary.simpleMessage("Bez dozvole"),
        "noRoomsFound": MessageLookupByLibrary.simpleMessage("Nema soba …"),
        "none": MessageLookupByLibrary.simpleMessage("Ništa"),
        "notSupportedInWeb":
            MessageLookupByLibrary.simpleMessage("Nije podržano u internetu"),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("u redu"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Online sigurnosna kopija ključeva je deaktivirana"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Online sigurnosna kopija ključeva je aktivirana"),
        "oopsSomethingWentWrong": MessageLookupByLibrary.simpleMessage(
            "Ups, došlo je do neke greške …"),
        "openAppToReadMessages": MessageLookupByLibrary.simpleMessage(
            "Za čitanje poruka, otvori program"),
        "openCamera": MessageLookupByLibrary.simpleMessage("Otvori kameru"),
        "optionalGroupName":
            MessageLookupByLibrary.simpleMessage("(Opcionalno) Ime grupe"),
        "participatingUserDevices": MessageLookupByLibrary.simpleMessage(
            "Sudjelujući korisnički uređaji"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Lozinka ili ključ za obnavljanje"),
        "password": MessageLookupByLibrary.simpleMessage("Lozinka"),
        "passwordHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Lozinka je promijenjena"),
        "pickImage": MessageLookupByLibrary.simpleMessage("Odaberi sliku"),
        "pin": MessageLookupByLibrary.simpleMessage("Prikvači"),
        "play": m39,
        "pleaseChooseAUsername":
            MessageLookupByLibrary.simpleMessage("Odaberi korisničko ime"),
        "pleaseEnterAMatrixIdentifier":
            MessageLookupByLibrary.simpleMessage("Upiši identifikator matrice"),
        "pleaseEnterYourPassword":
            MessageLookupByLibrary.simpleMessage("Upiši svoju lozinku"),
        "pleaseEnterYourUsername":
            MessageLookupByLibrary.simpleMessage("Upiši svoje korisničko ime"),
        "publicRooms": MessageLookupByLibrary.simpleMessage("Javne sobe"),
        "recording": MessageLookupByLibrary.simpleMessage("Snimanje"),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("Odbij"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("Ponovo se pridruži"),
        "remove": MessageLookupByLibrary.simpleMessage("Ukloni"),
        "removeAllOtherDevices":
            MessageLookupByLibrary.simpleMessage("Ukloni sve druge uređaje"),
        "removeDevice": MessageLookupByLibrary.simpleMessage("Ukloni uređaj"),
        "removeExile":
            MessageLookupByLibrary.simpleMessage("Ukloni izbacivanje"),
        "removeMessage": MessageLookupByLibrary.simpleMessage("Ukloni poruku"),
        "removedBy": m42,
        "renderRichContent": MessageLookupByLibrary.simpleMessage(
            "Prikaži formatirani sadržaj poruke"),
        "reply": MessageLookupByLibrary.simpleMessage("Odgovori"),
        "requestPermission":
            MessageLookupByLibrary.simpleMessage("Zatraži dozvolu"),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(
            "Zahtjev za čitanje starijih poruka"),
        "revokeAllPermissions":
            MessageLookupByLibrary.simpleMessage("Opozovi sve dozvole"),
        "roomHasBeenUpgraded":
            MessageLookupByLibrary.simpleMessage("Soba je nadograđena"),
        "saturday": MessageLookupByLibrary.simpleMessage("Subota"),
        "searchForAChat": MessageLookupByLibrary.simpleMessage("Traži chat"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("Pošalji"),
        "sendAMessage": MessageLookupByLibrary.simpleMessage("Pošalji poruku"),
        "sendAudio":
            MessageLookupByLibrary.simpleMessage("Pošalji audio datoteku"),
        "sendBugReports": MessageLookupByLibrary.simpleMessage(
            "Dozvoli slanje izvještaja o greškama sa sentry.io"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Pošalji datoteku"),
        "sendImage": MessageLookupByLibrary.simpleMessage("Pošalji sliku"),
        "sendOriginal":
            MessageLookupByLibrary.simpleMessage("Pošalji original"),
        "sendVideo":
            MessageLookupByLibrary.simpleMessage("Pošalji video datoteku"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sentryInfo": MessageLookupByLibrary.simpleMessage(
            "Podaci o tvojoj privatnosti: https://sentry.io/security/"),
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Sesija je provjerena"),
        "setAProfilePicture":
            MessageLookupByLibrary.simpleMessage("Postavi sliku profila"),
        "setGroupDescription":
            MessageLookupByLibrary.simpleMessage("Postavi opis grupe"),
        "setInvitationLink": MessageLookupByLibrary.simpleMessage(
            "Pošalji poveznicu za pozivnicu"),
        "setStatus": MessageLookupByLibrary.simpleMessage("Postavi stanje"),
        "settings": MessageLookupByLibrary.simpleMessage("Postavke"),
        "share": MessageLookupByLibrary.simpleMessage("Dijeli"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("Prijavi se"),
        "skip": MessageLookupByLibrary.simpleMessage("Preskoči"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Izvorni kȏd"),
        "startYourFirstChat":
            MessageLookupByLibrary.simpleMessage("Počni svoj prvi chat :-)"),
        "startedACall": m53,
        "statusExampleMessage":
            MessageLookupByLibrary.simpleMessage("Kako si danas?"),
        "submit": MessageLookupByLibrary.simpleMessage("Pošalji"),
        "sunday": MessageLookupByLibrary.simpleMessage("Nedjelja"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("Sustav"),
        "tapToShowMenu":
            MessageLookupByLibrary.simpleMessage("Dodirni za prikaz izbornika"),
        "theyDontMatch":
            MessageLookupByLibrary.simpleMessage("Ne poklapaju se"),
        "theyMatch": MessageLookupByLibrary.simpleMessage("Poklapaju se"),
        "thisRoomHasBeenArchived":
            MessageLookupByLibrary.simpleMessage("Ova soba je arhivirana."),
        "thursday": MessageLookupByLibrary.simpleMessage("Četvrtak"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain":
            MessageLookupByLibrary.simpleMessage("Pokušaj ponovo poslati"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Utorak"),
        "unbannedUser": m55,
        "unblockDevice":
            MessageLookupByLibrary.simpleMessage("Deblokiraj uređaj"),
        "unknownDevice":
            MessageLookupByLibrary.simpleMessage("Nepoznat uređaj"),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(
            "Nepoznat algoritam šifriranja"),
        "unknownEvent": m56,
        "unknownSessionVerify":
            MessageLookupByLibrary.simpleMessage("Nepoznata sesija, provjeri"),
        "unmuteChat":
            MessageLookupByLibrary.simpleMessage("Uključi zvuk chata"),
        "unpin": MessageLookupByLibrary.simpleMessage("Otkvači"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(
            "Koristiti Amoled kompatibilne boje?"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("Korisničko ime"),
        "verifiedSession":
            MessageLookupByLibrary.simpleMessage("Uspješno provjerena sesija!"),
        "verify": MessageLookupByLibrary.simpleMessage("Provjeri"),
        "verifyManual": MessageLookupByLibrary.simpleMessage("Provjeri ručno"),
        "verifyStart": MessageLookupByLibrary.simpleMessage("Pokreni provjeru"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Uspješno si provjerio/la!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Provjeravanje drugog računa"),
        "verifyUser":
            MessageLookupByLibrary.simpleMessage("Provjeri korisnika"),
        "videoCall": MessageLookupByLibrary.simpleMessage("Video poziv"),
        "visibilityOfTheChatHistory": MessageLookupByLibrary.simpleMessage(
            "Vidljivost kronologije chata"),
        "visibleForAllParticipants":
            MessageLookupByLibrary.simpleMessage("Vidljivo za sve sudionike"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("Vidljivo za sve"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("Glasovna poruka"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Čekanje na partnera, da prihvati zahtjeva …"),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Čekanje na partnera, da prihvati emoji …"),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Čekanje na partnera, da prihvati brojeve …"),
        "wallpaper": MessageLookupByLibrary.simpleMessage("Slika pozadine"),
        "warning": MessageLookupByLibrary.simpleMessage("Upozorenje!"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "Obostrano šifriranje je trenutačno u beta stanju! Koriti na vlastitu odgovornost!"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Srijeda"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Lijep pozdrav u najslađi program za čavrljanje u mreži matrix."),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(
            "Tko se smije pridružiti grupi"),
        "writeAMessage":
            MessageLookupByLibrary.simpleMessage("Napiši poruku …"),
        "yes": MessageLookupByLibrary.simpleMessage("Da"),
        "you": MessageLookupByLibrary.simpleMessage("Ti"),
        "youAreInvitedToThisChat":
            MessageLookupByLibrary.simpleMessage("Pozvan/a si u ovaj chat"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(
                "Više ne sudjeluješ u ovom chatu"),
        "youCannotInviteYourself":
            MessageLookupByLibrary.simpleMessage("Sebe ne možeš pozvati"),
        "youHaveBeenBannedFromThisChat": MessageLookupByLibrary.simpleMessage(
            "Isključen/a si iz ovog chata"),
        "yourOwnUsername":
            MessageLookupByLibrary.simpleMessage("Tvoje korisničko ime")
      };
}
