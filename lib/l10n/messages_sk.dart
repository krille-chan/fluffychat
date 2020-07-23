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

  static m2(username) => "Akcepovať žiadosť o verifikáciu od ${username}?";

  static m3(username, targetName) => "${username} zabanoval ${targetName}";

  static m4(homeserver) =>
      "V základnom nastavení budete pripojený k ${homeserver}";

  static m5(username) => "${username} si zmenili svôj avatar";

  static m6(username, description) =>
      "${username} zmenili popis chatu na: „${description}“";

  static m7(username, chatname) =>
      "${username} zmenili meno chatu na: „${chatname}“";

  static m8(username) => "${username} zmenili nastavenie oprávnení chatu";

  static m9(username, displayname) =>
      "${username} si zmenili prezývku na: ${displayname}";

  static m10(username) => "${username} zmenili prístupové práva pre hosťov";

  static m11(username, rules) =>
      "${username} zmenili prístupové práva pro hosťov na: ${rules}";

  static m12(username) =>
      "${username} zmenili nastavenie viditelnosti histórie chatu";

  static m13(username, rules) =>
      "${username} zmenili nastavenie viditelnosti histórie chatu na: ${rules}";

  static m14(username) => "${username} zmenili nastavenie pravidiel pripojenia";

  static m15(username, joinRules) =>
      "${username} zmenili nastavenie pravidiel pripojenia na: ${joinRules}";

  static m16(username) => "${username} si zmenili profilový obrázok";

  static m17(username) => "${username} zmenili nastavenie aliasov chatu";

  static m18(username) => "${username} zmenili odkaz k pozvánke do miestnosti";

  static m19(error) => "Nebolo možné dešifrovať správu: ${error}";

  static m20(count) => "${count} účastníkov";

  static m21(username) => "${username} založili chat";

  static m22(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m23(year, month, day) => "${day}.${month}.${year}";

  static m24(month, day) => "${day}.${month}.";

  static m25(displayname) => "Skupina s ${displayname}";

  static m26(username, targetName) =>
      "${username} vzal späť pozvánku pre ${targetName}";

  static m27(groupName) => "Pozvať kontakt do ${groupName}";

  static m28(username, link) =>
      "${username} vás pozval na FluffyChat.\n1. Nainštalujte si FluffyChat: http://fluffy.chat\n2. Zaregistrujte sa alebo sa prihláste\n3. Otvorte odkaz na pozvánku: ${link}";

  static m29(username, targetName) => "${username} pozvali ${targetName}";

  static m30(username) => "${username} sa pripojili do chatu";

  static m31(username, targetName) => "${username} vyhodili ${targetName}";

  static m32(username, targetName) =>
      "${username} vyhodili a zabanovali ${targetName}";

  static m33(localizedTimeShort) => "Naposledy prítomní: ${localizedTimeShort}";

  static m34(count) => "Načítať ďalších ${count} účastníkov";

  static m35(homeserver) => "Prihlásenie k ${homeserver}";

  static m36(number) => "${number} označených správ";

  static m37(fileName) => "Prehrať (fileName}";

  static m38(username) => "${username} odstránili udalosť";

  static m39(username) => "${username} odmietli pozvánku";

  static m40(username) => "Odstánené užívateľom ${username}";

  static m41(username) => "Videné užívateľom ${username}";

  static m42(username, count) =>
      "Videné užívateľom ${username} a ${count} dalšími";

  static m43(username, username2) =>
      "Videné užívateľmi ${username} a ${username2}";

  static m44(username) => "${username} poslali súbor";

  static m45(username) => "${username} poslali obrázok";

  static m46(username) => "${username} poslali nálepku";

  static m47(username) => "${username} poslali video";

  static m48(username) => "${username} poslali zvukovú nahrávku";

  static m49(username) => "${username} zdieľa lokáciu";

  static m50(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m51(username, targetName) => "${username} odbanovali ${targetName}";

  static m52(type) => "Neznáma udalosť „${type}“";

  static m53(unreadCount) => "${unreadCount} neprečítaných chatov";

  static m54(unreadEvents) => "${unreadEvents} neprečítaných správ";

  static m55(unreadEvents, unreadChats) =>
      "${unreadEvents} neprečítaných správ v ${unreadChats} chatoch";

  static m56(username, count) => "${username} a ${count} dalších píšu…";

  static m57(username, username2) => "${username} a ${username2} píšu…";

  static m58(username) => "${username} píše…";

  static m59(username) => "${username} opustili chat";

  static m60(username, type) => "${username} poslali udalosť ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "(Optional) Group name":
            MessageLookupByLibrary.simpleMessage("(Voliteľné) Názov skupiny"),
        "About": MessageLookupByLibrary.simpleMessage("O aplikácii"),
        "Accept": MessageLookupByLibrary.simpleMessage("Prijať"),
        "Account": MessageLookupByLibrary.simpleMessage("Účet"),
        "Account informations":
            MessageLookupByLibrary.simpleMessage("Informácie o účte"),
        "Add a group description":
            MessageLookupByLibrary.simpleMessage("Pridať popis skupiny"),
        "Admin": MessageLookupByLibrary.simpleMessage("Administrátor"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("Máte už účet?"),
        "Anyone can join":
            MessageLookupByLibrary.simpleMessage("Ktokoľvek sa môže pripojiť"),
        "Archive": MessageLookupByLibrary.simpleMessage("Archivovať"),
        "Archived Room":
            MessageLookupByLibrary.simpleMessage("Archivovaná miestnosť"),
        "Are guest users allowed to join":
            MessageLookupByLibrary.simpleMessage("Môžu sa pripojiť hostia"),
        "Are you sure?": MessageLookupByLibrary.simpleMessage("Ste si istí?"),
        "Authentication":
            MessageLookupByLibrary.simpleMessage("Autentifikácia"),
        "Avatar has been changed":
            MessageLookupByLibrary.simpleMessage("Avatar bol zmenený"),
        "Ban from chat":
            MessageLookupByLibrary.simpleMessage("Zabanovať z chatu"),
        "Banned": MessageLookupByLibrary.simpleMessage("Zabanovaný"),
        "Block Device":
            MessageLookupByLibrary.simpleMessage("Zakázať zariadenie"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Zrušiť"),
        "Change the homeserver":
            MessageLookupByLibrary.simpleMessage("Zmeniť použitý server"),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("Zmeniť názov skupiny"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Zmeniť server"),
        "Change wallpaper":
            MessageLookupByLibrary.simpleMessage("Zmeniť pozadie"),
        "Change your style":
            MessageLookupByLibrary.simpleMessage("Zmena štýlu"),
        "Changelog": MessageLookupByLibrary.simpleMessage("História zmien"),
        "Chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "Chat details":
            MessageLookupByLibrary.simpleMessage("Podrobnosti o chate"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("Vyberte si silné heslo"),
        "Choose a username":
            MessageLookupByLibrary.simpleMessage("Vyberte si užívateľské meno"),
        "Close": MessageLookupByLibrary.simpleMessage("Zavrieť"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Potvrdiť"),
        "Connect": MessageLookupByLibrary.simpleMessage("Pripojiť"),
        "Connection attempt failed":
            MessageLookupByLibrary.simpleMessage("Pokus o pripojenie zlyhal"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage(
                "Kontakt bol pozvaný do skupiny"),
        "Content viewer":
            MessageLookupByLibrary.simpleMessage("Prehliadač obsahu"),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("Skopírované do schránky"),
        "Copy": MessageLookupByLibrary.simpleMessage("Kopírovať"),
        "Could not set avatar": MessageLookupByLibrary.simpleMessage(
            "Nepodarilo sa nastaviť avatar"),
        "Could not set displayname": MessageLookupByLibrary.simpleMessage(
            "Nepodarilo sa nastaviť prezývku užívateľa"),
        "Create": MessageLookupByLibrary.simpleMessage("Vytvoriť"),
        "Create account now":
            MessageLookupByLibrary.simpleMessage("Vytvoriť účet teraz"),
        "Create new group":
            MessageLookupByLibrary.simpleMessage("Vytvoriť novú skupinu"),
        "Currently active":
            MessageLookupByLibrary.simpleMessage("Momentálne prítomní"),
        "Dark": MessageLookupByLibrary.simpleMessage("Tmavá"),
        "Delete": MessageLookupByLibrary.simpleMessage("Odstrániť"),
        "Delete message":
            MessageLookupByLibrary.simpleMessage("Odstrániť správu"),
        "Deny": MessageLookupByLibrary.simpleMessage("Zamietnuť"),
        "Device": MessageLookupByLibrary.simpleMessage("Zariadenie"),
        "Devices": MessageLookupByLibrary.simpleMessage("Zariadenia"),
        "Discard picture":
            MessageLookupByLibrary.simpleMessage("Zahodiť obrázok"),
        "Displayname has been changed":
            MessageLookupByLibrary.simpleMessage("Prezývka bola zmenená"),
        "Donate": MessageLookupByLibrary.simpleMessage("Prispejte"),
        "Download file": MessageLookupByLibrary.simpleMessage("Stiahnuť súbor"),
        "Edit Jitsi instance":
            MessageLookupByLibrary.simpleMessage("Nastavenie inštancie Jitsi"),
        "Edit displayname":
            MessageLookupByLibrary.simpleMessage("Zmeniť prezývku"),
        "Emote Settings":
            MessageLookupByLibrary.simpleMessage("Nastavenie emotikonov"),
        "Emote shortcode":
            MessageLookupByLibrary.simpleMessage("Kód emotikonu"),
        "Empty chat": MessageLookupByLibrary.simpleMessage("Prázdny chat"),
        "Encryption": MessageLookupByLibrary.simpleMessage("Šifrovanie"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Šifrovací algoritmus"),
        "Encryption is not enabled":
            MessageLookupByLibrary.simpleMessage("Šifrovanie nie je aktívne"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "Konečné šifrovanie je momentálne v Beta verzii! Používajte na vlastné riziko!"),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "Nastavenie koncového šifrovania"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("Zadajte názov skupiny"),
        "Enter a username":
            MessageLookupByLibrary.simpleMessage("Zadajte uživateľské meno"),
        "Enter your homeserver":
            MessageLookupByLibrary.simpleMessage("Zadajte svoj homeserver"),
        "File name": MessageLookupByLibrary.simpleMessage("Názov súboru"),
        "File size": MessageLookupByLibrary.simpleMessage("Veľkosť súboru"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("Preposlať"),
        "Friday": MessageLookupByLibrary.simpleMessage("Piatok"),
        "From joining": MessageLookupByLibrary.simpleMessage("Od pripojenia"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("Od pozvania"),
        "Group": MessageLookupByLibrary.simpleMessage("Skupina"),
        "Group description":
            MessageLookupByLibrary.simpleMessage("Popis skupiny"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage("Popis skupiny bol zmenený"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("Skupina je verejná"),
        "Guests are forbidden":
            MessageLookupByLibrary.simpleMessage("Hostia sú zakázaní"),
        "Guests can join":
            MessageLookupByLibrary.simpleMessage("Hostia sa môžu pripojiť"),
        "Help": MessageLookupByLibrary.simpleMessage("Pomoc"),
        "Homeserver is not compatible": MessageLookupByLibrary.simpleMessage(
            "Homeserver nie je kompatibilný"),
        "How are you today?":
            MessageLookupByLibrary.simpleMessage("Ako sa dnes máte?"),
        "ID": MessageLookupByLibrary.simpleMessage("ID"),
        "Identity": MessageLookupByLibrary.simpleMessage("Identita"),
        "Invite contact":
            MessageLookupByLibrary.simpleMessage("Pozvať kontakt"),
        "Invited": MessageLookupByLibrary.simpleMessage("Pozvanie"),
        "Invited users only":
            MessageLookupByLibrary.simpleMessage("Len pozvaní používatelia"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(
                "Zdá sa, že nemáte žiadne služby Googlu v telefóne. To je dobré rozhodnutie pre vaše súkromie! Ak chcete dostávať push notifikácie vo FluffyChat, odporúčame používať microG: https://microg.org/"),
        "Kick from chat":
            MessageLookupByLibrary.simpleMessage("Vyhodiť z chatu"),
        "Last seen IP": MessageLookupByLibrary.simpleMessage(
            "Naposledy zaznamenaná IP adresa"),
        "Leave": MessageLookupByLibrary.simpleMessage("Opustiť"),
        "Left the chat": MessageLookupByLibrary.simpleMessage("Opustili chat"),
        "License": MessageLookupByLibrary.simpleMessage("Licencia"),
        "Light": MessageLookupByLibrary.simpleMessage("Svetlá"),
        "Load more...": MessageLookupByLibrary.simpleMessage("Načítať viac..."),
        "Loading... Please wait": MessageLookupByLibrary.simpleMessage(
            "Načítava sa... Čakajte prosím"),
        "Login": MessageLookupByLibrary.simpleMessage("Prihlásiť sa"),
        "Logout": MessageLookupByLibrary.simpleMessage("Odhlásiť sa"),
        "Make a moderator":
            MessageLookupByLibrary.simpleMessage("Pridať práva moderátora"),
        "Make an admin":
            MessageLookupByLibrary.simpleMessage("Pridať práva administrátora"),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(
                "Skontrolujte, či je identifikátor platný"),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(
                "Správa bude odstránená pre všetkých účastníkov"),
        "Moderator": MessageLookupByLibrary.simpleMessage("Moderátor"),
        "Monday": MessageLookupByLibrary.simpleMessage("Pondelok"),
        "Mute chat": MessageLookupByLibrary.simpleMessage("Stlmiť chat"),
        "New message in FluffyChat":
            MessageLookupByLibrary.simpleMessage("Nová správa v FluffyChate"),
        "New private chat":
            MessageLookupByLibrary.simpleMessage("Nový súkromný chat"),
        "No emotes found. 😕": MessageLookupByLibrary.simpleMessage(
            "Nenašli sa žiadne emotikony. 😕"),
        "No permission":
            MessageLookupByLibrary.simpleMessage("Chýba povolenie"),
        "No rooms found...": MessageLookupByLibrary.simpleMessage(
            "Nenašli sa žiadne miestnosti..."),
        "None": MessageLookupByLibrary.simpleMessage("Žiadne"),
        "Not supported in web": MessageLookupByLibrary.simpleMessage(
            "Nepodporované vo webovej verzii"),
        "Oops something went wrong...":
            MessageLookupByLibrary.simpleMessage("Och! Niečo sa pokazilo..."),
        "Open app to read messages": MessageLookupByLibrary.simpleMessage(
            "Na prečítanie správy otvorte aplikáciu"),
        "Open camera":
            MessageLookupByLibrary.simpleMessage("Otvoriť fotoaparát"),
        "Participating user devices": MessageLookupByLibrary.simpleMessage(
            "Zúčastnené užívateľské zariadenia"),
        "Password": MessageLookupByLibrary.simpleMessage("Heslo"),
        "Pick image": MessageLookupByLibrary.simpleMessage("Vybrať obrázok"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(
                "Prosím berte na vedomie, že na koncové šifrovanie zatiaľ potrebujete Pantalaimon."),
        "Please choose a username": MessageLookupByLibrary.simpleMessage(
            "Vyberte si používateľské meno"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage(
                "Vyberte si matrix identifkátor"),
        "Please enter your password":
            MessageLookupByLibrary.simpleMessage("Prosím zadajte svoje heslo"),
        "Please enter your username": MessageLookupByLibrary.simpleMessage(
            "Zadajte svoje používateľské meno"),
        "Public Rooms":
            MessageLookupByLibrary.simpleMessage("Verejné miestnosti"),
        "Recording": MessageLookupByLibrary.simpleMessage("Nahrávam"),
        "Reject": MessageLookupByLibrary.simpleMessage("Odmietnuť"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Vrátiť sa"),
        "Remove": MessageLookupByLibrary.simpleMessage("Odstrániť"),
        "Remove all other devices": MessageLookupByLibrary.simpleMessage(
            "Odstráňiť všetky ostatné zariadenia"),
        "Remove device":
            MessageLookupByLibrary.simpleMessage("Odstráňiť zariadenie"),
        "Remove exile": MessageLookupByLibrary.simpleMessage("Odblokovať"),
        "Remove message":
            MessageLookupByLibrary.simpleMessage("Odstrániť správu"),
        "Render rich message content":
            MessageLookupByLibrary.simpleMessage("Zobraziť formátovaný obsah"),
        "Reply": MessageLookupByLibrary.simpleMessage("Odpovedať"),
        "Request permission":
            MessageLookupByLibrary.simpleMessage("Vyžiadať si povolenie"),
        "Request to read older messages": MessageLookupByLibrary.simpleMessage(
            "Žiadosť o prečítanie starších správ"),
        "Revoke all permissions":
            MessageLookupByLibrary.simpleMessage("Zrušiť všetky povolenia"),
        "Room has been upgraded":
            MessageLookupByLibrary.simpleMessage("Miestnosť bola upgradeovaná"),
        "Saturday": MessageLookupByLibrary.simpleMessage("Sobota"),
        "Search for a chat":
            MessageLookupByLibrary.simpleMessage("Vyhladať v chate"),
        "Seen a long time ago":
            MessageLookupByLibrary.simpleMessage("Videný veľmi dávno"),
        "Send": MessageLookupByLibrary.simpleMessage("Odoslať"),
        "Send a message":
            MessageLookupByLibrary.simpleMessage("Odoslať správu"),
        "Send file": MessageLookupByLibrary.simpleMessage("Odoslať súbor"),
        "Send image": MessageLookupByLibrary.simpleMessage("Odoslať obrázok"),
        "Set a profile picture":
            MessageLookupByLibrary.simpleMessage("Nastaviť profilový obrázok"),
        "Set group description":
            MessageLookupByLibrary.simpleMessage("Nastaviť popis skupiny"),
        "Set invitation link":
            MessageLookupByLibrary.simpleMessage("Nastaviť odkaz pre pozvánku"),
        "Set status": MessageLookupByLibrary.simpleMessage("Nastaviť status"),
        "Settings": MessageLookupByLibrary.simpleMessage("Nastavenia"),
        "Share": MessageLookupByLibrary.simpleMessage("Zdieľať"),
        "Sign up": MessageLookupByLibrary.simpleMessage("Zaregistrovať sa"),
        "Skip": MessageLookupByLibrary.simpleMessage("Preskočiť"),
        "Source code": MessageLookupByLibrary.simpleMessage("Zdrojový kód"),
        "Start your first chat :-)":
            MessageLookupByLibrary.simpleMessage("Začnite svoj prvý chat :-)"),
        "Submit": MessageLookupByLibrary.simpleMessage("Odoslať"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Nedeľa"),
        "System": MessageLookupByLibrary.simpleMessage("Systémová farba"),
        "Tap to show menu":
            MessageLookupByLibrary.simpleMessage("Ťuknutím zobrazíte menu"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage("Šifrovanie bolo poškodené"),
        "They Don\'t Match":
            MessageLookupByLibrary.simpleMessage("Sa nezhodujú"),
        "They Match": MessageLookupByLibrary.simpleMessage("Zhodujú sa"),
        "This room has been archived.": MessageLookupByLibrary.simpleMessage(
            "Táto miestnosť bola archivovaná."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Štvrtok"),
        "Try to send again":
            MessageLookupByLibrary.simpleMessage("Skúsiť znova odoslať"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("Utorok"),
        "Unblock Device":
            MessageLookupByLibrary.simpleMessage("Odblokovať zariadenie"),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Neznáme zariadenie"),
        "Unknown encryption algorithm": MessageLookupByLibrary.simpleMessage(
            "Neznámy šifrovací algoritmus"),
        "Unmute chat":
            MessageLookupByLibrary.simpleMessage("Zrušiť stlmenie chatu"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "Použiť Amoled kompatibilné farby?"),
        "Username": MessageLookupByLibrary.simpleMessage("Užívateľské meno"),
        "Verify": MessageLookupByLibrary.simpleMessage("Overiť"),
        "Verify User":
            MessageLookupByLibrary.simpleMessage("Verifikovať používateľa"),
        "Video call": MessageLookupByLibrary.simpleMessage("Videohovor"),
        "Visibility of the chat history":
            MessageLookupByLibrary.simpleMessage("Viditeľnosť histórie chatu"),
        "Visible for all participants": MessageLookupByLibrary.simpleMessage(
            "Viditeľné pre všetkých účastníkov"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("Viditeľné pre každého"),
        "Voice message": MessageLookupByLibrary.simpleMessage("Hlasová správa"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("Pozadie"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("Streda"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "Vítajte v najroztomilejšom instant messengeri v sieti matrix."),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage(
                "Kto môže vstúpiť do tejto skupiny"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("Napísať správu..."),
        "Yes": MessageLookupByLibrary.simpleMessage("Áno"),
        "You": MessageLookupByLibrary.simpleMessage("Vy"),
        "You are invited to this chat":
            MessageLookupByLibrary.simpleMessage("Ste pozvaní do tohto chatu"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(
                "Už sa nezúčastňujete tohto chatu"),
        "You cannot invite yourself":
            MessageLookupByLibrary.simpleMessage("Nemôžete pozvať samých seba"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage(
                "Máte zablokovaný prístup k tomuto chatu"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "Šifrovanie už nebude možné vypnúť. Ste si tým istí?"),
        "Your own username":
            MessageLookupByLibrary.simpleMessage("Vaša vlastná prezývka"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Prosím zadajte vašu prístupovu frázu k \"bezpečému úložisku\" alebo \"kľúč na obnovu\" pre uloženie kľúčov."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Na overenie tejto osoby, prosím zadajte prístupovu frázu k \"bezpečému úložisku\" alebo \"klúč na obnovu\"."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Prosím zadajte vašu prístupovú frázu k \"bezpečnému úložisku\" alebo \"kľúč na obnovu\" pre overenie vašej relácie."),
        "askVerificationRequest": m2,
        "bannedUser": m3,
        "byDefaultYouWillBeConnectedTo": m4,
        "cachedKeys":
            MessageLookupByLibrary.simpleMessage("Klúče sa úspešne uložili!"),
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
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Porovnajte a uistite sa, že nasledujúce emotikony sa zhodujú na oboch zariadeniach:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Porovnajte a uistite sa, že nasledujúce čísla sa zhodujú na oboch zariadeniach:"),
        "couldNotDecryptMessage": m19,
        "countParticipants": m20,
        "createdTheChat": m21,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "Vzájomné overenie je vypnuté"),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(
            "Vzájomné overenie je zapnuté"),
        "dateAndTimeOfDay": m22,
        "dateWithYear": m23,
        "dateWithoutYear": m24,
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Emotikon už existuje"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Nesprávné označenie emotikonu"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Musíte zvoliť kód emotikonu a obrázok"),
        "groupWith": m25,
        "hasWithdrawnTheInvitationFor": m26,
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Nesprávna prístupová fráza alebo kľúč na obnovenie"),
        "inviteContactToGroup": m27,
        "inviteText": m28,
        "invitedUser": m29,
        "is typing...": MessageLookupByLibrary.simpleMessage("píše..."),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Je nasledujúci kód zariadenia správny?"),
        "joinedTheChat": m30,
        "keysCached": MessageLookupByLibrary.simpleMessage("Kľúče sú uložené"),
        "keysMissing": MessageLookupByLibrary.simpleMessage("Kľúče chýbaju"),
        "kicked": m31,
        "kickedAndBanned": m32,
        "lastActiveAgo": m33,
        "loadCountMoreParticipants": m34,
        "logInTo": m35,
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("Nová žiadosť o verifikáciu!"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat v súčasnosti nepodporuje povolenie krížového podpisu. Prosím, povoľte ho z Riot.im."),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat v súčasnosti nepodporuje povolenie online zálohu klúčov. Prosím, povoľte ho z Riot.im."),
        "numberSelected": m36,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Online záloha kľúčov je vypnutá"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Online záloha kľúčov je zapnutá"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "prístupová fráza alebo kľúč na obnovenie"),
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
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Relácia je overená"),
        "sharedTheLocation": m49,
        "timeOfDay": m50,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m51,
        "unknownEvent": m52,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Neznáma relácia, prosím verifikujte ju"),
        "unreadChats": m53,
        "unreadMessages": m54,
        "unreadMessagesInChats": m55,
        "userAndOthersAreTyping": m56,
        "userAndUserAreTyping": m57,
        "userIsTyping": m58,
        "userLeftTheChat": m59,
        "userSentUnknownEvent": m60,
        "verifiedSession":
            MessageLookupByLibrary.simpleMessage("Úspešne overenie relácie!"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Verifikovať manuálne"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Spustiť verifikáciu"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Verifikácia bola úspešná!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Verifikujem protiľahlý účet"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Čaká sa, kým partner prijme požiadavku..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Čaká sa, kým partner prijme emotikon..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Čaká sa na to, kým partner prijme čísla...")
      };
}
