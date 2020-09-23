// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pl locale. All the
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
  String get localeName => 'pl';

  static m0(username) => "${username} zaakceptował/-a zaproszenie";

  static m1(username) => "${username} aktywował/-a szyfrowanie end-to-end";

  static m4(username, targetName) => "${username} zbanował/-a ${targetName}";

  static m5(homeserver) => "Domyślnie łączy się z ${homeserver}";

  static m6(username) => "${username} zmienił/-a zdjęcie profilowe";

  static m7(username, description) =>
      "${username} zmienił/-a opis czatu na: \'${description}\'";

  static m8(username, chatname) =>
      "${username} zmienił/-a nick na: \'${chatname}\'";

  static m9(username) => "${username} zmienił/-a uprawnienia czatu";

  static m10(username, displayname) =>
      "${username} zmienił/-a wyświetlany nick na: ${displayname}";

  static m11(username) => "${username} zmienił/-a zasady dostępu dla gości";

  static m12(username, rules) =>
      "${username} zmienił/-a zasady dostępu dla gości na: ${rules}";

  static m13(username) => "${username} zmienił/-a widoczność historii";

  static m14(username, rules) =>
      "${username} zmienił/-a widoczność historii na: ${rules}";

  static m15(username) => "${username} zmienił/-a zasady wejścia";

  static m16(username, joinRules) =>
      "${username} zmienił/-a zasady wejścia na: ${joinRules}";

  static m17(username) => "${username} zmienił/-a zdjęcie profilowe";

  static m18(username) => "${username} zmienił/-a skrót pokoju";

  static m19(username) =>
      "${username} zmienił/-a link do zaproszenia do pokoju";

  static m20(error) => "Nie można odszyfrować wiadomości: ${error}";

  static m21(count) => "${count} uczestników";

  static m22(username) => "${username} stworzył/-a czat";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${day}-${month}-${year}";

  static m25(month, day) => "${month}-${day}";

  static m27(displayname) => "Grupa z ${displayname}";

  static m28(username, targetName) =>
      "${username} wycofał/-a zaproszenie dla ${targetName}";

  static m29(groupName) => "Zaproś kontakty do ${groupName}";

  static m30(username, link) =>
      "${username} zaprosił/-a cię do FluffyChat. \n1. Zainstaluj FluffyChat: https://fluffychat.im \n2. Zarejestuj się lub zaloguj \n3. Otwórz link zaproszenia: ${link}";

  static m31(username, targetName) => "${username} zaprosił/-a ${targetName}";

  static m32(username) => "${username} dołączył/-a do czatu";

  static m33(username, targetName) => "${username} wyrzucił/-a ${targetName}";

  static m34(username, targetName) =>
      "${username} wyrzucił/-a i zbanował/-a ${targetName}";

  static m35(localizedTimeShort) => "Ostatnio widziano: ${localizedTimeShort}";

  static m36(count) => "Załaduj jeszcze ${count} uczestników";

  static m37(homeserver) => "Zaloguj się do ${homeserver}";

  static m38(number) => "${number} wybrany";

  static m39(fileName) => "Otwórz ${fileName}";

  static m40(username) => "${username} stworzył/-a wydarzenie";

  static m41(username) => "${username} odrzucił/-a zaproszenie";

  static m42(username) => "Usunięta przez ${username}";

  static m43(username) => "Zobaczone przez ${username}";

  static m44(username, count) =>
      "Zobaczone przez ${username} oraz ${count} innych";

  static m45(username, username2) =>
      "Zobaczone przez ${username} oraz ${username2}";

  static m46(username) => "${username} wysłał/-a plik";

  static m47(username) => "${username} wysłał/-a obraz";

  static m48(username) => "${username} wysłał/-a naklejkę";

  static m49(username) => "${username} wysłał/-a wideo";

  static m50(username) => "${username} wysłał/-a plik audio";

  static m52(username) => "${username} udostępnił/-a lokalizacje";

  static m54(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m55(username, targetName) => "${username} odbanował/-a ${targetName}";

  static m56(type) => "Nieznane zdarzenie \'${type}\'";

  static m57(unreadCount) => "${unreadCount} nieprzeczytanych czatów";

  static m58(unreadEvents) => "${unreadEvents} nieprzeczytanych wiadomości";

  static m59(unreadEvents, unreadChats) =>
      "${unreadEvents} nieprzeczytanych wiadomości w ${unreadChats} czatach";

  static m60(username, count) => "${username} oraz ${count} innych pisze...";

  static m61(username, username2) => "${username} oraz ${username2} piszą...";

  static m62(username) => "${username} pisze...";

  static m63(username) => "${username} opuścił/-a czat";

  static m64(username, type) => "${username} wysłał/-a wydarzenie ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("O nas"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Konto"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Informacje o koncie"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription":
            MessageLookupByLibrary.simpleMessage("Dodaj opis grupy"),
        "admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Masz już konto?"),
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("Każdy może dołączyć"),
        "archive": MessageLookupByLibrary.simpleMessage("Archiwum"),
        "archivedRoom":
            MessageLookupByLibrary.simpleMessage("Zarchiwizowane pokoje"),
        "areGuestsAllowedToJoin": MessageLookupByLibrary.simpleMessage(
            "Czy użytkownicy-goście mogą dołączyć"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Jesteś pewny/-a?"),
        "authentication": MessageLookupByLibrary.simpleMessage("Autoryzacja"),
        "avatarHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "Zdjęcie profilowe zostało zmienione"),
        "banFromChat": MessageLookupByLibrary.simpleMessage("Ban na czacie"),
        "banned": MessageLookupByLibrary.simpleMessage("Zbanowany/-a"),
        "bannedUser": m4,
        "byDefaultYouWillBeConnectedTo": m5,
        "cancel": MessageLookupByLibrary.simpleMessage("Anuluj"),
        "changeTheHomeserver":
            MessageLookupByLibrary.simpleMessage("Zmień serwer domyślny"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("Zmień nazwę grupy"),
        "changeTheServer": MessageLookupByLibrary.simpleMessage("Zmień tapetę"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("Zmień swój styl"),
        "changeWallpaper": MessageLookupByLibrary.simpleMessage("Zmień tapetę"),
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
        "changelog": MessageLookupByLibrary.simpleMessage("Dziennik zmian"),
        "channelCorruptedDecryptError": MessageLookupByLibrary.simpleMessage(
            "Szyfrowanie zostało uszkodzone"),
        "chatDetails": MessageLookupByLibrary.simpleMessage("Szczegóły czatu"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("Wybierz silne hasło"),
        "chooseAUsername": MessageLookupByLibrary.simpleMessage("Wybierz nick"),
        "close": MessageLookupByLibrary.simpleMessage("Zamknij"),
        "confirm": MessageLookupByLibrary.simpleMessage("Potwierdź"),
        "connect": MessageLookupByLibrary.simpleMessage("Połącz"),
        "connectionAttemptFailed": MessageLookupByLibrary.simpleMessage(
            "Próba połączenia nie powiodła się"),
        "contactHasBeenInvitedToTheGroup": MessageLookupByLibrary.simpleMessage(
            "Kontakt został zaproszony do grupy"),
        "contentViewer":
            MessageLookupByLibrary.simpleMessage("Przeglądarka treści"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Skopiowano do schowka"),
        "copy": MessageLookupByLibrary.simpleMessage("Kopiuj"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar": MessageLookupByLibrary.simpleMessage(
            "Nie można ustawić zdjęcia profilowego"),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(
            "Nie można ustawić wyświetlanego nicku"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Stwórz"),
        "createAccountNow":
            MessageLookupByLibrary.simpleMessage("Stwórz konto teraz"),
        "createNewGroup":
            MessageLookupByLibrary.simpleMessage("Stwórz nową grupę"),
        "createdTheChat": m22,
        "darkTheme": MessageLookupByLibrary.simpleMessage("Ciemny"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "delete": MessageLookupByLibrary.simpleMessage("Usuń"),
        "deleteMessage": MessageLookupByLibrary.simpleMessage("Usuń wiadomość"),
        "deny": MessageLookupByLibrary.simpleMessage("Odrzuć"),
        "device": MessageLookupByLibrary.simpleMessage("Urządzenie"),
        "devices": MessageLookupByLibrary.simpleMessage("Urządzenia"),
        "discardPicture":
            MessageLookupByLibrary.simpleMessage("Odrzuć zdjęcie"),
        "displaynameHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "Wyświetlany nick został zmieniony"),
        "donate": MessageLookupByLibrary.simpleMessage("Wsparcie"),
        "downloadFile": MessageLookupByLibrary.simpleMessage("Pobierz plik"),
        "editDisplayname":
            MessageLookupByLibrary.simpleMessage("Edytuj wyświetlany nick"),
        "editJitsiInstance":
            MessageLookupByLibrary.simpleMessage("Edytuj instancje Jitsi"),
        "emptyChat": MessageLookupByLibrary.simpleMessage("Pusty czat"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "Nie będziesz już mógł wyłączyć szyfrowania. Jesteś pewny?"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Algorytm szyfrowania"),
        "encryptionNotEnabled": MessageLookupByLibrary.simpleMessage(
            "Szyfrowanie nie jest włączone"),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "Ustawienia szyfrowania end-to-end"),
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("Wpisz nazwę grupy"),
        "enterAUsername": MessageLookupByLibrary.simpleMessage("Wpisz nick"),
        "enterYourHomeserver":
            MessageLookupByLibrary.simpleMessage("Wpisz swój serwer domowy"),
        "fileName": MessageLookupByLibrary.simpleMessage("Nazwa pliku"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Rozmiar pliku"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("Przekaż"),
        "friday": MessageLookupByLibrary.simpleMessage("Piątek"),
        "fromJoining": MessageLookupByLibrary.simpleMessage("Od dołączenia"),
        "fromTheInvitation":
            MessageLookupByLibrary.simpleMessage("Od zaproszenia"),
        "group": MessageLookupByLibrary.simpleMessage("Grupa"),
        "groupDescription": MessageLookupByLibrary.simpleMessage("Opis grupy"),
        "groupDescriptionHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Opis grupy został zmieniony"),
        "groupIsPublic":
            MessageLookupByLibrary.simpleMessage("Grupa jest publiczna"),
        "groupWith": m27,
        "guestsAreForbidden":
            MessageLookupByLibrary.simpleMessage("Goście są zabronieni"),
        "guestsCanJoin":
            MessageLookupByLibrary.simpleMessage("Goście mogą dołączyć"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Pomoc"),
        "homeserverIsNotCompatible": MessageLookupByLibrary.simpleMessage(
            "Serwer domowy nie jest kompatybilny"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "identity": MessageLookupByLibrary.simpleMessage("Tożsamość"),
        "inviteContact":
            MessageLookupByLibrary.simpleMessage("Zaproś kontakty"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("Zaproszono"),
        "invitedUser": m31,
        "invitedUsersOnly": MessageLookupByLibrary.simpleMessage(
            "Tylko zaproszeni użytkownicy"),
        "isTyping": MessageLookupByLibrary.simpleMessage("pisze..."),
        "joinedTheChat": m32,
        "kickFromChat": MessageLookupByLibrary.simpleMessage("Wyrzuć z czatu"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp":
            MessageLookupByLibrary.simpleMessage("Ostatnie widziane IP"),
        "leave": MessageLookupByLibrary.simpleMessage("Wyjdź"),
        "leftTheChat": MessageLookupByLibrary.simpleMessage("Opuścił/-a czat"),
        "license": MessageLookupByLibrary.simpleMessage("Licencja"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Jasny"),
        "loadCountMoreParticipants": m36,
        "loadingPleaseWait":
            MessageLookupByLibrary.simpleMessage("Ładowanie... Proszę czekąć"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("Zaloguj"),
        "logout": MessageLookupByLibrary.simpleMessage("Wyloguj"),
        "makeAModerator":
            MessageLookupByLibrary.simpleMessage("Uczyń moderatorem"),
        "makeAnAdmin": MessageLookupByLibrary.simpleMessage("Uczyń adminem"),
        "makeSureTheIdentifierIsValid": MessageLookupByLibrary.simpleMessage(
            "Upewnij się, że identyfikator jest prawidłowy"),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "Wiadomość zostanie usunięta dla wszystkich użytkowników"),
        "moderator": MessageLookupByLibrary.simpleMessage("Moderator"),
        "monday": MessageLookupByLibrary.simpleMessage("Poniedziałek"),
        "muteChat": MessageLookupByLibrary.simpleMessage("Wycisz czat"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(
            "Należy pamiętać, że Pantalaimon wymaga na razie szyfrowania end-to-end."),
        "newMessageInFluffyChat":
            MessageLookupByLibrary.simpleMessage("Nowa wiadomość w FluffyChat"),
        "newPrivateChat":
            MessageLookupByLibrary.simpleMessage("Nowy prywatny czat"),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "Wygląda na to, że nie masz usług Google w swoim telefonie. To dobra decyzja dla twojej prywatności! Aby otrzymywać powiadomienia wysyłane w FluffyChat, zalecamy korzystanie z microG: https://microg.org/"),
        "noPermission": MessageLookupByLibrary.simpleMessage("Brak uprawnień"),
        "noRoomsFound":
            MessageLookupByLibrary.simpleMessage("Nie znaleziono pokoi..."),
        "none": MessageLookupByLibrary.simpleMessage("Brak"),
        "notSupportedInWeb":
            MessageLookupByLibrary.simpleMessage("Nie obsługiwane w sieci"),
        "numberSelected": m38,
        "oopsSomethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Ups! Coś poszło nie tak..."),
        "openAppToReadMessages": MessageLookupByLibrary.simpleMessage(
            "Otwórz aplikację by odczytać wiadomości"),
        "openCamera": MessageLookupByLibrary.simpleMessage("Otwarta kamera"),
        "optionalGroupName":
            MessageLookupByLibrary.simpleMessage("(Opcjonalnie) Nazwa grupy"),
        "participatingUserDevices":
            MessageLookupByLibrary.simpleMessage("Urządzenia użytkowników"),
        "password": MessageLookupByLibrary.simpleMessage("Hasło"),
        "play": m39,
        "pleaseChooseAUsername":
            MessageLookupByLibrary.simpleMessage("Wybierz nick"),
        "pleaseEnterAMatrixIdentifier": MessageLookupByLibrary.simpleMessage(
            "Wprowadź proszę identyfikator matrix"),
        "pleaseEnterYourPassword":
            MessageLookupByLibrary.simpleMessage("Wpisz swoje hasło"),
        "pleaseEnterYourUsername":
            MessageLookupByLibrary.simpleMessage("Wpisz swój nick"),
        "publicRooms": MessageLookupByLibrary.simpleMessage("Publiczne pokoje"),
        "recording": MessageLookupByLibrary.simpleMessage("Nagranie"),
        "redactedAnEvent": m40,
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("Dołącz ponownie"),
        "remove": MessageLookupByLibrary.simpleMessage("Usuń"),
        "removeAllOtherDevices": MessageLookupByLibrary.simpleMessage(
            "Usuń wszystkie inne urządzenia"),
        "removeDevice": MessageLookupByLibrary.simpleMessage("Usuń urządzenie"),
        "removeExile": MessageLookupByLibrary.simpleMessage("Usuń blokadę"),
        "removeMessage": MessageLookupByLibrary.simpleMessage("Usuń wiadomość"),
        "removedBy": m42,
        "reply": MessageLookupByLibrary.simpleMessage("Odpisz"),
        "requestPermission":
            MessageLookupByLibrary.simpleMessage("Prośba o pozwolenie"),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(
            "Poproś o przeczytanie starszych wiadomości"),
        "revokeAllPermissions": MessageLookupByLibrary.simpleMessage(
            "Odwołaj wszystkie uprawnienia"),
        "saturday": MessageLookupByLibrary.simpleMessage("Sobota"),
        "searchForAChat":
            MessageLookupByLibrary.simpleMessage("Przeszukaj czat"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("Wyślij"),
        "sendAMessage":
            MessageLookupByLibrary.simpleMessage("Wyślij wiadomość"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Wyślij plik"),
        "sendImage": MessageLookupByLibrary.simpleMessage("Wyślij obraz"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "setAProfilePicture":
            MessageLookupByLibrary.simpleMessage("Ustaw zdjęcie profilowe"),
        "setGroupDescription":
            MessageLookupByLibrary.simpleMessage("Ustaw opis grupy"),
        "setInvitationLink":
            MessageLookupByLibrary.simpleMessage("Ustaw link zaproszeniowy"),
        "setStatus": MessageLookupByLibrary.simpleMessage("Ustaw status"),
        "settings": MessageLookupByLibrary.simpleMessage("Ustawienia"),
        "share": MessageLookupByLibrary.simpleMessage("Udostępnij"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("Zarejesturuj się"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Kod żródłowy"),
        "startYourFirstChat": MessageLookupByLibrary.simpleMessage(
            "Rozpocznij swój pierwszy czat :-)"),
        "statusExampleMessage":
            MessageLookupByLibrary.simpleMessage("Jak się masz dziś?"),
        "sunday": MessageLookupByLibrary.simpleMessage("Niedziela"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("System"),
        "tapToShowMenu":
            MessageLookupByLibrary.simpleMessage("Kliknij by zobaczyć menu"),
        "thisRoomHasBeenArchived": MessageLookupByLibrary.simpleMessage(
            "Ten pokój został przeniesiony do archiwum."),
        "thursday": MessageLookupByLibrary.simpleMessage("Czwartek"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain":
            MessageLookupByLibrary.simpleMessage("Spróbuj wysłać ponownie"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Wtorek"),
        "unbannedUser": m55,
        "unknownDevice":
            MessageLookupByLibrary.simpleMessage("Nieznane urządzenie"),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(
            "Nieznany algorytm szyfrowania"),
        "unknownEvent": m56,
        "unmuteChat": MessageLookupByLibrary.simpleMessage("Wyłącz wyciszenie"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(
            "Użyć kolorów kompatybilnych z ekranami Amoled?"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("Nick"),
        "verify": MessageLookupByLibrary.simpleMessage("zweryfikuj"),
        "videoCall": MessageLookupByLibrary.simpleMessage("Rozmowa wideo"),
        "visibilityOfTheChatHistory":
            MessageLookupByLibrary.simpleMessage("Widoczność historii czatu"),
        "visibleForAllParticipants": MessageLookupByLibrary.simpleMessage(
            "Widoczny dla wszystkich użytkowników"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("Widoczny dla każdego"),
        "voiceMessage":
            MessageLookupByLibrary.simpleMessage("Wiadomość głosowa"),
        "wallpaper": MessageLookupByLibrary.simpleMessage("Tapeta"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "Szyfrowanie end-to-end jest obecnie w fazie beta! Używaj na własne ryzyko!"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Środa"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Witamy w najładniejszym komunikatorze w sieci matrix."),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(
            "Kto może dołączyć do tej grupy"),
        "writeAMessage":
            MessageLookupByLibrary.simpleMessage("Napisz wiadomość…"),
        "yes": MessageLookupByLibrary.simpleMessage("Tak"),
        "you": MessageLookupByLibrary.simpleMessage("Ty"),
        "youAreInvitedToThisChat": MessageLookupByLibrary.simpleMessage(
            "Dostałeś/-aś zaproszenie do tego czatu"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(
                "Nie uczestniczysz już w tym czacie"),
        "youCannotInviteYourself":
            MessageLookupByLibrary.simpleMessage("Nie możesz zaprosić siebie"),
        "youHaveBeenBannedFromThisChat": MessageLookupByLibrary.simpleMessage(
            "Zostałeś zbanowany na tym czacie"),
        "yourOwnUsername": MessageLookupByLibrary.simpleMessage("Twój nick")
      };
}
