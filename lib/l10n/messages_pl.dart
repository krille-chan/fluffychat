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

  static m3(username, targetName) => "${username} zbanował/-a ${targetName}";

  static m4(homeserver) => "Domyślnie łączy się z ${homeserver}";

  static m5(username) => "${username} zmienił/-a zdjęcie profilowe";

  static m6(username, description) =>
      "${username} zmienił/-a opis czatu na: \'${description}\'";

  static m7(username, chatname) =>
      "${username} zmienił/-a nick na: \'${chatname}\'";

  static m8(username) => "${username} zmienił/-a uprawnienia czatu";

  static m9(username, displayname) =>
      "${username} zmienił/-a wyświetlany nick na: ${displayname}";

  static m10(username) => "${username} zmienił/-a zasady dostępu dla gości";

  static m11(username, rules) =>
      "${username} zmienił/-a zasady dostępu dla gości na: ${rules}";

  static m12(username) => "${username} zmienił/-a widoczność historii";

  static m13(username, rules) =>
      "${username} zmienił/-a widoczność historii na: ${rules}";

  static m14(username) => "${username} zmienił/-a zasady wejścia";

  static m15(username, joinRules) =>
      "${username} zmienił/-a zasady wejścia na: ${joinRules}";

  static m16(username) => "${username} zmienił/-a zdjęcie profilowe";

  static m17(username) => "${username} zmienił/-a skrót pokoju";

  static m18(username) =>
      "${username} zmienił/-a link do zaproszenia do pokoju";

  static m19(error) => "Nie można odszyfrować wiadomości: ${error}";

  static m20(count) => "${count} uczestników";

  static m21(username) => "${username} stworzył/-a czat";

  static m22(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m23(year, month, day) => "${day}-${month}-${year}";

  static m24(month, day) => "${month}-${day}";

  static m25(displayname) => "Grupa z ${displayname}";

  static m26(username, targetName) =>
      "${username} wycofał/-a zaproszenie dla ${targetName}";

  static m27(groupName) => "Zaproś kontakty do ${groupName}";

  static m28(username, link) =>
      "${username} zaprosił/-a cię do FluffyChat. \n1. Zainstaluj FluffyChat: http://fluffy.chat \n2. Zarejestuj się lub zaloguj \n3. Otwórz link zaproszenia: ${link}";

  static m29(username, targetName) => "${username} zaprosił/-a ${targetName}";

  static m30(username) => "${username} dołączył/-a do czatu";

  static m31(username, targetName) => "${username} wyrzucił/-a ${targetName}";

  static m32(username, targetName) =>
      "${username} wyrzucił/-a i zbanował/-a ${targetName}";

  static m33(localizedTimeShort) => "Ostatnio widziano: ${localizedTimeShort}";

  static m34(count) => "Załaduj ${count} uczestników więcej";

  static m35(homeserver) => "Zaloguj się do ${homeserver}";

  static m36(number) => "${number} wybrany";

  static m37(fileName) => "Otwórz ${fileName}";

  static m38(username) => "${username} stworzył/-a wydarzenie";

  static m39(username) => "${username} odrzucił/-a zaproszenie";

  static m40(username) => "Usunięta przez ${username}";

  static m41(username) => "Zobaczone przez ${username}";

  static m42(username, count) =>
      "Zobaczone przez ${username} oraz ${count} innych";

  static m43(username, username2) =>
      "Zobaczone przez ${username} oraz ${username2}";

  static m44(username) => "${username} wysłał/-a plik";

  static m45(username) => "${username} wysłał/-a obraz";

  static m46(username) => "${username} wysłał/-a naklejkę";

  static m47(username) => "${username} wysłał/-a wideo";

  static m48(username) => "${username} wysłał/-a plik audio";

  static m49(username) => "${username} udostępnił/-a lokalizacje";

  static m50(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m51(username, targetName) => "${username} odbanował/-a ${targetName}";

  static m52(type) => "Nieznane zdarzenie \'${type}\'";

  static m53(unreadCount) => "${unreadCount} nieprzeczytanych czatów";

  static m54(unreadEvents) => "${unreadEvents} nieprzeczytanych wiadomości";

  static m55(unreadEvents, unreadChats) =>
      "${unreadEvents} nieprzeczytanych wiadomości w ${unreadChats} czatach";

  static m56(username, count) => "${username} oraz ${count} innych pisze...";

  static m57(username, username2) => "${username} oraz ${username2} piszą...";

  static m58(username) => "${username} pisze...";

  static m59(username) => "${username} opuścił/-a czat";

  static m60(username, type) => "${username} wysłał/-a wydarzenie ${type}";

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
        "bannedUser": m3,
        "byDefaultYouWillBeConnectedTo": m4,
        "changedTheChatAvatar": m5,
        "changedTheChatDescriptionTo": m6,
        "changedTheChatNameTo": m7,
        "changedTheChatPermissions": m8,
        "changedTheDisplaynameTo": m9,
        "changedTheGuestAccessRules": m10,
        "changedTheGuestAccessRulesTo": m11,
        "changedTheHistoryVisibility": m12,
        "changedTheHistoryVisibilityTo": m13,
        "changedTheJoinRules": m14,
        "changedTheJoinRulesTo": m15,
        "changedTheProfileAvatar": m16,
        "changedTheRoomAliases": m17,
        "changedTheRoomInvitationLink": m18,
        "couldNotDecryptMessage": m19,
        "countParticipants": m20,
        "createdTheChat": m21,
        "dateAndTimeOfDay": m22,
        "dateWithYear": m23,
        "dateWithoutYear": m24,
        "groupWith": m25,
        "hasWithdrawnTheInvitationFor": m26,
        "inviteContactToGroup": m27,
        "inviteText": m28,
        "invitedUser": m29,
        "is typing...": MessageLookupByLibrary.simpleMessage("pisze..."),
        "joinedTheChat": m30,
        "kicked": m31,
        "kickedAndBanned": m32,
        "lastActiveAgo": m33,
        "loadCountMoreParticipants": m34,
        "logInTo": m35,
        "numberSelected": m36,
        "play": m37,
        "redactedAnEvent": m38,
        "rejectedTheInvitation": m39,
        "removedBy": m40,
        "seenByUser": m41,
        "seenByUserAndCountOthers": m42,
        "seenByUserAndUser": m43,
        "sentAFile": m44,
        "sentAPicture": m45,
        "sentASticker": m46,
        "sentAVideo": m47,
        "sentAnAudio": m48,
        "sharedTheLocation": m49,
        "timeOfDay": m50,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m51,
        "unknownEvent": m52,
        "unreadChats": m53,
        "unreadMessages": m54,
        "unreadMessagesInChats": m55,
        "userAndOthersAreTyping": m56,
        "userAndUserAreTyping": m57,
        "userIsTyping": m58,
        "userLeftTheChat": m59,
        "userSentUnknownEvent": m60
      };
}
