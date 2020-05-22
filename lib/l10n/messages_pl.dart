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

  static m2(username, targetName) => "${username} zbanował/-a ${targetName}";

  static m3(homeserver) => "Domyślnie łączy się z ${homeserver}";

  static m4(username) => "${username} zmienił/-a zdjęcie profilowe";

  static m5(username, description) =>
      "${username} zmienił/-a opis czatu na: \'${description}\'";

  static m6(username, chatname) =>
      "${username} zmienił/-a nick na: \'${chatname}\'";

  static m7(username) => "${username} zmienił/-a uprawnienia czatu";

  static m8(username, displayname) =>
      "${username} zmienił/-a wyświetlany nick na: ${displayname}";

  static m9(username) => "${username} zmienił/-a zasady dostępu dla gości";

  static m10(username, rules) =>
      "${username} zmienił/-a zasady dostępu dla gości na: ${rules}";

  static m11(username) => "${username} zmienił/-a widoczność historii";

  static m12(username, rules) =>
      "${username} zmienił/-a widoczność historii na: ${rules}";

  static m13(username) => "${username} zmienił/-a zasady wejścia";

  static m14(username, joinRules) =>
      "${username} zmienił/-a zasady wejścia na: ${joinRules}";

  static m15(username) => "${username} zmienił/-a zdjęcie profilowe";

  static m16(username) => "${username} zmienił/-a skrót pokoju";

  static m17(username) =>
      "${username} zmienił/-a link do zaproszenia do pokoju";

  static m18(error) => "Nie można odszyfrować wiadomości: ${error}";

  static m19(count) => "${count} uczestników";

  static m20(username) => "${username} stworzył/-a czat";

  static m21(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m22(year, month, day) => "${day}-${month}-${year}";

  static m23(month, day) => "${month}-${day}";

  static m24(displayname) => "Grupa z ${displayname}";

  static m25(username, targetName) =>
      "${username} wycofał/-a zaproszenie dla ${targetName}";

  static m26(groupName) => "Zaproś kontakty do ${groupName}";

  static m27(username, link) =>
      "${username} zaprosił/-a cię do FluffyChat. \n1. Zainstaluj FluffyChat: http://fluffy.chat \n2. Zarejestuj się lub zaloguj \n3. Otwórz link zaproszenia: ${link}";

  static m28(username, targetName) => "${username} zaprosił/-a ${targetName}";

  static m29(username) => "${username} dołączył/-a do czatu";

  static m30(username, targetName) => "${username} wyrzucił/-a ${targetName}";

  static m31(username, targetName) =>
      "${username} wyrzucił/-a i zbanował/-a ${targetName}";

  static m32(localizedTimeShort) => "Ostatnio widziano: ${localizedTimeShort}";

  static m33(count) => "Załaduj ${count} uczestników więcej";

  static m34(homeserver) => "Zaloguj się do ${homeserver}";

  static m35(number) => "${number} wybrany";

  static m36(fileName) => "Otwórz ${fileName}";

  static m37(username) => "${username} stworzył/-a wydarzenie";

  static m38(username) => "${username} odrzucił/-a zaproszenie";

  static m39(username) => "Usunięta przez ${username}";

  static m40(username) => "Zobaczone przez ${username}";

  static m41(username, count) =>
      "Zobaczone przez ${username} oraz ${count} innych";

  static m42(username, username2) =>
      "Zobaczone przez ${username} oraz ${username2}";

  static m43(username) => "${username} wysłał/-a plik";

  static m44(username) => "${username} wysłał/-a obraz";

  static m45(username) => "${username} wysłał/-a naklejkę";

  static m46(username) => "${username} wysłał/-a wideo";

  static m47(username) => "${username} wysłał/-a plik audio";

  static m48(username) => "${username} udostępnił/-a lokalizacje";

  static m49(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m50(username, targetName) => "${username} odbanował/-a ${targetName}";

  static m51(type) => "Nieznane zdarzenie \'${type}\'";

  static m52(unreadCount) => "${unreadCount} nieprzeczytanych czatów";

  static m53(unreadEvents) => "${unreadEvents} nieprzeczytanych wiadomości";

  static m54(unreadEvents, unreadChats) =>
      "${unreadEvents} nieprzeczytanych wiadomości w ${unreadChats} czatach";

  static m55(username, count) => "${username} oraz ${count} innych pisze...";

  static m56(username, username2) => "${username} oraz ${username2} piszą...";

  static m57(username) => "${username} pisze...";

  static m58(username) => "${username} opuścił/-a czat";

  static m59(username, type) => "${username} wysłał/-a wydarzenie ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "(Optional) Group name":
            MessageLookupByLibrary.simpleMessage("(Opcjonalnie) Nazwa grupy"),
        "About": MessageLookupByLibrary.simpleMessage("O nas"),
        "Account": MessageLookupByLibrary.simpleMessage("Konto"),
        "Account informations":
            MessageLookupByLibrary.simpleMessage("Informacje o koncie"),
        "Add a group description":
            MessageLookupByLibrary.simpleMessage("Dodaj opis grupy"),
        "Admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("Masz już konto?"),
        "Anyone can join":
            MessageLookupByLibrary.simpleMessage("Każdy może dołączyć"),
        "Archive": MessageLookupByLibrary.simpleMessage("Archiwum"),
        "Archived Room":
            MessageLookupByLibrary.simpleMessage("Zarchiwizowane pokoje"),
        "Are guest users allowed to join": MessageLookupByLibrary.simpleMessage(
            "Czy użytkownicy-goście mogą dołączyć"),
        "Are you sure?":
            MessageLookupByLibrary.simpleMessage("Jesteś pewny/-a?"),
        "Authentication": MessageLookupByLibrary.simpleMessage("Autoryzacja"),
        "Avatar has been changed": MessageLookupByLibrary.simpleMessage(
            "Zdjęcie profilowe zostało zmienione"),
        "Ban from chat": MessageLookupByLibrary.simpleMessage("Ban na czacie"),
        "Banned": MessageLookupByLibrary.simpleMessage("Zbanowany/-a"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Anuluj"),
        "Change the homeserver":
            MessageLookupByLibrary.simpleMessage("Zmień serwer domyślny"),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("Zmień nazwę grupy"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Zmień tapetę"),
        "Change wallpaper":
            MessageLookupByLibrary.simpleMessage("Zmień tapetę"),
        "Change your style":
            MessageLookupByLibrary.simpleMessage("Zmień swój styl"),
        "Changelog": MessageLookupByLibrary.simpleMessage("Dziennik zmian"),
        "Chat details": MessageLookupByLibrary.simpleMessage("Szczegóły czatu"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("Wybierz silne hasło"),
        "Choose a username":
            MessageLookupByLibrary.simpleMessage("Wybierz nick"),
        "Close": MessageLookupByLibrary.simpleMessage("Zamknij"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Potwierdź"),
        "Connect": MessageLookupByLibrary.simpleMessage("Połącz"),
        "Connection attempt failed": MessageLookupByLibrary.simpleMessage(
            "Próba połączenia nie powiodła się"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage(
                "Kontakt został zaproszony do grupy"),
        "Content viewer":
            MessageLookupByLibrary.simpleMessage("Przeglądarka treści"),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("Skopiowano do schowka"),
        "Copy": MessageLookupByLibrary.simpleMessage("Kopiuj"),
        "Could not set avatar": MessageLookupByLibrary.simpleMessage(
            "Nie można ustawić zdjęcia profilowego"),
        "Could not set displayname": MessageLookupByLibrary.simpleMessage(
            "Nie można ustawić wyświetlanego nicku"),
        "Create": MessageLookupByLibrary.simpleMessage("Stwórz"),
        "Create account now":
            MessageLookupByLibrary.simpleMessage("Stwórz konto teraz"),
        "Create new group":
            MessageLookupByLibrary.simpleMessage("Stwórz nową grupę"),
        "Dark": MessageLookupByLibrary.simpleMessage("Ciemny"),
        "Delete": MessageLookupByLibrary.simpleMessage("Usuń"),
        "Delete message":
            MessageLookupByLibrary.simpleMessage("Usuń wiadomość"),
        "Deny": MessageLookupByLibrary.simpleMessage("Odrzuć"),
        "Device": MessageLookupByLibrary.simpleMessage("Urządzenie"),
        "Devices": MessageLookupByLibrary.simpleMessage("Urządzenia"),
        "Discard picture":
            MessageLookupByLibrary.simpleMessage("Odrzuć zdjęcie"),
        "Displayname has been changed": MessageLookupByLibrary.simpleMessage(
            "Wyświetlany nick został zmieniony"),
        "Donate": MessageLookupByLibrary.simpleMessage("Wsparcie"),
        "Download file": MessageLookupByLibrary.simpleMessage("Pobierz plik"),
        "Edit Jitsi instance":
            MessageLookupByLibrary.simpleMessage("Edytuj instancje Jitsi"),
        "Edit displayname":
            MessageLookupByLibrary.simpleMessage("Edytuj wyświetlany nick"),
        "Empty chat": MessageLookupByLibrary.simpleMessage("Pusty czat"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Algorytm szyfrowania"),
        "Encryption is not enabled": MessageLookupByLibrary.simpleMessage(
            "Szyfrowanie nie jest włączone"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "Szyfrowanie end-to-end jest obecnie w fazie beta! Używaj na własne ryzyko!"),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "Ustawienia szyfrowania end-to-end"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("Wpisz nazwę grupy"),
        "Enter a username": MessageLookupByLibrary.simpleMessage("Wpisz nick"),
        "Enter your homeserver":
            MessageLookupByLibrary.simpleMessage("Wpisz swój serwer domowy"),
        "File name": MessageLookupByLibrary.simpleMessage("Nazwa pliku"),
        "File size": MessageLookupByLibrary.simpleMessage("Rozmiar pliku"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("Przekaż"),
        "Friday": MessageLookupByLibrary.simpleMessage("Piątek"),
        "From joining": MessageLookupByLibrary.simpleMessage("Od dołączenia"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("Od zaproszenia"),
        "Group": MessageLookupByLibrary.simpleMessage("Grupa"),
        "Group description": MessageLookupByLibrary.simpleMessage("Opis grupy"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage("Opis grupy został zmieniony"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("Grupa jest publiczna"),
        "Guests are forbidden":
            MessageLookupByLibrary.simpleMessage("Goście są zabronieni"),
        "Guests can join":
            MessageLookupByLibrary.simpleMessage("Goście mogą dołączyć"),
        "Help": MessageLookupByLibrary.simpleMessage("Pomoc"),
        "Homeserver is not compatible": MessageLookupByLibrary.simpleMessage(
            "Serwer domowy nie jest kompatybilny"),
        "How are you today?":
            MessageLookupByLibrary.simpleMessage("Jak się masz dziś?"),
        "ID": MessageLookupByLibrary.simpleMessage("ID"),
        "Identity": MessageLookupByLibrary.simpleMessage("Tożsamość"),
        "Invite contact":
            MessageLookupByLibrary.simpleMessage("Zaproś kontakty"),
        "Invited": MessageLookupByLibrary.simpleMessage("Zaproszono"),
        "Invited users only": MessageLookupByLibrary.simpleMessage(
            "Tylko zaproszeni użytkownicy"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(
                "Wygląda na to, że nie masz usług Google w swoim telefonie. To dobra decyzja dla twojej prywatności! Aby otrzymywać powiadomienia wysyłane w FluffyChat, zalecamy korzystanie z microG: https://microg.org/"),
        "Kick from chat":
            MessageLookupByLibrary.simpleMessage("Wyrzuć z czatu"),
        "Last seen IP":
            MessageLookupByLibrary.simpleMessage("Ostatnie widziane IP"),
        "Leave": MessageLookupByLibrary.simpleMessage("wyjdź"),
        "Left the chat":
            MessageLookupByLibrary.simpleMessage("Opuścił/-a czat"),
        "License": MessageLookupByLibrary.simpleMessage("Licencja"),
        "Light": MessageLookupByLibrary.simpleMessage("Jasny"),
        "Loading... Please wait":
            MessageLookupByLibrary.simpleMessage("Ładowanie... Proszę czekąć"),
        "Login": MessageLookupByLibrary.simpleMessage("Zaloguj"),
        "Logout": MessageLookupByLibrary.simpleMessage("Wyloguj"),
        "Make a moderator":
            MessageLookupByLibrary.simpleMessage("Uczyń moderatorem"),
        "Make an admin": MessageLookupByLibrary.simpleMessage("Uczyń adminem"),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(
                "Upewnij się, że identyfikator jest prawidłowy"),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(
                "Wiadomość zostanie usunięta dla wszystkich użytkowników"),
        "Moderator": MessageLookupByLibrary.simpleMessage("Moderator"),
        "Monday": MessageLookupByLibrary.simpleMessage("Poniedziałek"),
        "Mute chat": MessageLookupByLibrary.simpleMessage("Wycisz czat"),
        "New message in FluffyChat":
            MessageLookupByLibrary.simpleMessage("Nowa wiadomość w FluffyChat"),
        "New private chat":
            MessageLookupByLibrary.simpleMessage("Nowy prywatny czat"),
        "No permission": MessageLookupByLibrary.simpleMessage("Brak uprawnień"),
        "No rooms found...":
            MessageLookupByLibrary.simpleMessage("Nie znaleziono pokoi..."),
        "None": MessageLookupByLibrary.simpleMessage("Brak"),
        "Not supported in web":
            MessageLookupByLibrary.simpleMessage("Nie obsługiwane w sieci"),
        "Oops something went wrong...":
            MessageLookupByLibrary.simpleMessage("Ups! Coś poszło nie tak..."),
        "Open app to read messages": MessageLookupByLibrary.simpleMessage(
            "Otwórz aplikację by odczytać wiadomości"),
        "Open camera": MessageLookupByLibrary.simpleMessage("Otwarta kamera"),
        "Participating user devices":
            MessageLookupByLibrary.simpleMessage("Urządzenia użytkowników"),
        "Password": MessageLookupByLibrary.simpleMessage("Hasło"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(
                "Należy pamiętać, że Pantalaimon wymaga na razie szyfrowania end-to-end."),
        "Please choose a username":
            MessageLookupByLibrary.simpleMessage("Wybierz nick"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage(
                "Wprowadź proszę identyfikator matrix"),
        "Please enter your password":
            MessageLookupByLibrary.simpleMessage("Wpisz swoje hasło"),
        "Please enter your username":
            MessageLookupByLibrary.simpleMessage("Wpisz swój nick"),
        "Public Rooms":
            MessageLookupByLibrary.simpleMessage("Publiczne pokoje"),
        "Recording": MessageLookupByLibrary.simpleMessage("Nagranie"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Dołącz ponownie"),
        "Remove": MessageLookupByLibrary.simpleMessage("Usuń"),
        "Remove all other devices": MessageLookupByLibrary.simpleMessage(
            "Usuń wszystkie inne urządzenia"),
        "Remove device":
            MessageLookupByLibrary.simpleMessage("Usuń urządzenie"),
        "Remove exile": MessageLookupByLibrary.simpleMessage("Usuń blokadę"),
        "Remove message":
            MessageLookupByLibrary.simpleMessage("Usuń wiadomość"),
        "Reply": MessageLookupByLibrary.simpleMessage("Odpisz"),
        "Request permission":
            MessageLookupByLibrary.simpleMessage("Prośba o pozwolenie"),
        "Request to read older messages": MessageLookupByLibrary.simpleMessage(
            "Poproś o przeczytanie starszych wiadomości"),
        "Revoke all permissions": MessageLookupByLibrary.simpleMessage(
            "Odwołaj wszystkie uprawnienia"),
        "Saturday": MessageLookupByLibrary.simpleMessage("Sobota"),
        "Search for a chat":
            MessageLookupByLibrary.simpleMessage("Przeszukaj czat"),
        "Send": MessageLookupByLibrary.simpleMessage("Wyślij"),
        "Send a message":
            MessageLookupByLibrary.simpleMessage("Wyślij wiadomość"),
        "Send file": MessageLookupByLibrary.simpleMessage("Wyślij plik"),
        "Send image": MessageLookupByLibrary.simpleMessage("Wyślij obraz"),
        "Set a profile picture":
            MessageLookupByLibrary.simpleMessage("Ustaw zdjęcie profilowe"),
        "Set group description":
            MessageLookupByLibrary.simpleMessage("Ustaw opis grupy"),
        "Set invitation link":
            MessageLookupByLibrary.simpleMessage("Ustaw link zaproszeniowy"),
        "Set status": MessageLookupByLibrary.simpleMessage("Ustaw status"),
        "Settings": MessageLookupByLibrary.simpleMessage("Ustawienia"),
        "Share": MessageLookupByLibrary.simpleMessage("Udostępnij"),
        "Sign up": MessageLookupByLibrary.simpleMessage("Zarejesturuj się"),
        "Source code": MessageLookupByLibrary.simpleMessage("Kod żródłowy"),
        "Start your first chat :-)": MessageLookupByLibrary.simpleMessage(
            "Rozpocznij swój pierwszy czat :-)"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Niedziela"),
        "System": MessageLookupByLibrary.simpleMessage("System"),
        "Tap to show menu":
            MessageLookupByLibrary.simpleMessage("Kliknij by zobaczyć menu"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage(
                "Szyfrowanie zostało uszkodzone"),
        "This room has been archived.": MessageLookupByLibrary.simpleMessage(
            "Ten pokój został przeniesiony do archiwum."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Czwartek"),
        "Try to send again":
            MessageLookupByLibrary.simpleMessage("Spróbuj wysłać ponownie"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("Wtorek"),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Nieznane urządzenie"),
        "Unknown encryption algorithm": MessageLookupByLibrary.simpleMessage(
            "Nieznany algorytm szyfrowania"),
        "Unmute chat":
            MessageLookupByLibrary.simpleMessage("Wyłącz wyciszenie"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "Użyć kolorów kompatybilnych z ekranami Amoled?"),
        "Username": MessageLookupByLibrary.simpleMessage("Nick"),
        "Verify": MessageLookupByLibrary.simpleMessage("zweryfikuj"),
        "Video call": MessageLookupByLibrary.simpleMessage("Rozmowa wideo"),
        "Visibility of the chat history":
            MessageLookupByLibrary.simpleMessage("Widoczność historii czatu"),
        "Visible for all participants": MessageLookupByLibrary.simpleMessage(
            "Widoczny dla wszystkich użytkowników"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("Widoczny dla każdego"),
        "Voice message":
            MessageLookupByLibrary.simpleMessage("Wiadomość głosowa"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("Tapeta"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("Środa"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "Witamy w najładniejszym komunikatorze w sieci matrix."),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage(
                "Kto może dołączyć do tej grupy"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("Pisze wiadomość..."),
        "Yes": MessageLookupByLibrary.simpleMessage("Tak"),
        "You": MessageLookupByLibrary.simpleMessage("Ty"),
        "You are invited to this chat": MessageLookupByLibrary.simpleMessage(
            "Dostałeś/-aś zaproszenie do tego czatu"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(
                "Nie uczestniczysz już w tym czacie"),
        "You cannot invite yourself":
            MessageLookupByLibrary.simpleMessage("Nie możesz zaprosić siebie"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage(
                "Zostałeś zbanowany na tym czacie"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "Nie będziesz już mógł wyłączyć szyfrowania. Jesteś pewny?"),
        "Your own username": MessageLookupByLibrary.simpleMessage("Twój nick"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "bannedUser": m2,
        "byDefaultYouWillBeConnectedTo": m3,
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
        "couldNotDecryptMessage": m18,
        "countParticipants": m19,
        "createdTheChat": m20,
        "dateAndTimeOfDay": m21,
        "dateWithYear": m22,
        "dateWithoutYear": m23,
        "groupWith": m24,
        "hasWithdrawnTheInvitationFor": m25,
        "inviteContactToGroup": m26,
        "inviteText": m27,
        "invitedUser": m28,
        "is typing...": MessageLookupByLibrary.simpleMessage("pisze..."),
        "joinedTheChat": m29,
        "kicked": m30,
        "kickedAndBanned": m31,
        "lastActiveAgo": m32,
        "loadCountMoreParticipants": m33,
        "logInTo": m34,
        "numberSelected": m35,
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
        "sharedTheLocation": m48,
        "timeOfDay": m49,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m50,
        "unknownEvent": m51,
        "unreadChats": m52,
        "unreadMessages": m53,
        "unreadMessagesInChats": m54,
        "userAndOthersAreTyping": m55,
        "userAndUserAreTyping": m56,
        "userIsTyping": m57,
        "userLeftTheChat": m58,
        "userSentUnknownEvent": m59
      };
}
