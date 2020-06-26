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

  static m2(username, targetName) => "${username} zabanoval ${targetName}";

  static m3(homeserver) =>
      "V základním nastavení budete připojeni do ${homeserver}";

  static m4(username) => "${username} změnili svůj avatar";

  static m5(username, description) =>
      "${username} změnili popis diskuze na: „${description}“";

  static m6(username, chatname) =>
      "${username} změnili jméno diskuze na: „${chatname}“";

  static m7(username) => "${username} změnili nastavení oprávnění v diskuzi";

  static m8(username, displayname) =>
      "${username} změnili přezdívku na: ${displayname}";

  static m9(username) => "${username} změnili přístupová práva pro hosty";

  static m10(username, rules) =>
      "${username} změnili přístupová práva pro hosty na: ${rules}";

  static m11(username) =>
      "${username} změnili nastavení viditelnosti historie diskuze";

  static m12(username, rules) =>
      "${username} změnili nastavení viditelnosti historie diskuze na: ${rules}";

  static m13(username) => "${username} změnili nastavení pravidel připojení";

  static m14(username, joinRules) =>
      "${username} změnili nastavení pravidel připojení na: ${joinRules}";

  static m15(username) => "${username} změnili nastavení profilového avataru";

  static m16(username) => "${username} změnili nastavení aliasů místnosti";

  static m17(username) => "${username} změnili odkaz k pozvání do místnosti";

  static m18(error) => "Nebylo možné dešifrovat zprávu: ${error}";

  static m19(count) => "${count} účastníků";

  static m20(username) => "${username} založil diskuzi";

  static m21(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m22(year, month, day) => "${day}. ${month}. ${year}";

  static m23(month, day) => "${day}.${month}";

  static m24(displayname) => "Skupina s ${displayname}";

  static m25(username, targetName) =>
      "${username} vzal zpět pozvání pro ${targetName}";

  static m26(groupName) => "Pozvat kontakt do ${groupName}";

  static m27(username, link) => "";

  static m28(username, targetName) => "${username} pozvali ${targetName}";

  static m29(username) => "${username} se připojili do diskuze";

  static m30(username, targetName) => "${username} vyhodil ${targetName}";

  static m31(username, targetName) =>
      "${username} vyhodil a zabanoval ${targetName}";

  static m32(localizedTimeShort) => "Naposledy aktivní: ${localizedTimeShort}";

  static m33(count) => "Načíst dalších ${count} účastníků";

  static m34(homeserver) => "Přihlášení k ${homeserver}";

  static m35(number) => "${number} vybráno";

  static m36(fileName) => "Přehrát (fileName}";

  static m37(username) => "${username} odstranili událost";

  static m38(username) => "${username} odmítli pozvání";

  static m39(username) => "Odstraněno ${username}";

  static m40(username) => "Viděno uživatelem ${username}";

  static m41(username, count) =>
      "Viděno uživateli ${username} a ${count} dalšími";

  static m42(username, username2) =>
      "Viděno uživateli ${username} a ${username2}";

  static m43(username) => "${username} poslali soubor";

  static m44(username) => "${username} poslali obrázek";

  static m45(username) => "${username} poslali samolepku";

  static m46(username) => "${username} poslali video";

  static m47(username) => "${username} poslali zvukovou nahrávku";

  static m48(username) => "${username} nasdíleli lokaci";

  static m49(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m50(username, targetName) => "";

  static m51(type) => "Neznámá událost „${type}“";

  static m52(unreadCount) => "${unreadCount} nepřečtených diskuzí";

  static m53(unreadEvents) => "${unreadEvents} nepřečtených zpráv";

  static m54(unreadEvents, unreadChats) =>
      "${unreadEvents} nepřečtených zpráv v ${unreadChats}";

  static m55(username, count) => "${username} a ${count} dalších píší…";

  static m56(username, username2) => "${username} a ${username2} píší…";

  static m57(username) => "${username} píše…";

  static m58(username) => "${username} opustili diskuzi";

  static m59(username, type) => "${username} poslal událost ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "(Optional) Group name":
            MessageLookupByLibrary.simpleMessage("(Volitelné) Název skupiny"),
        "About": MessageLookupByLibrary.simpleMessage("O aplikaci"),
        "Account": MessageLookupByLibrary.simpleMessage("Účet"),
        "Account informations":
            MessageLookupByLibrary.simpleMessage("Informace o účtu"),
        "Add a group description":
            MessageLookupByLibrary.simpleMessage("Přidat popis skupiny"),
        "Admin": MessageLookupByLibrary.simpleMessage("Administrátor"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("Máte již účet?"),
        "Anyone can join":
            MessageLookupByLibrary.simpleMessage("Kdokoliv se může připojit"),
        "Archive": MessageLookupByLibrary.simpleMessage("Archiv"),
        "Archived Room":
            MessageLookupByLibrary.simpleMessage("Archivované místnosti"),
        "Are guest users allowed to join":
            MessageLookupByLibrary.simpleMessage("Mohou se připojit hosté"),
        "Are you sure?": MessageLookupByLibrary.simpleMessage("Jste si jisti?"),
        "Authentication": MessageLookupByLibrary.simpleMessage("Autentizace"),
        "Avatar has been changed":
            MessageLookupByLibrary.simpleMessage("Avatar byl změněn"),
        "Ban from chat":
            MessageLookupByLibrary.simpleMessage("Zabanovat z diskuze"),
        "Banned": MessageLookupByLibrary.simpleMessage("Zabanován"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Zrušit"),
        "Change the homeserver":
            MessageLookupByLibrary.simpleMessage("Změnit použitý server"),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("Změnit název skupiny"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Změnit server"),
        "Change wallpaper":
            MessageLookupByLibrary.simpleMessage("Změnit pozadí"),
        "Change your style":
            MessageLookupByLibrary.simpleMessage("Nastavte svůj styl"),
        "Changelog": MessageLookupByLibrary.simpleMessage("Historie změn"),
        "Chat": MessageLookupByLibrary.simpleMessage("Diskuze"),
        "Chat details": MessageLookupByLibrary.simpleMessage("Detail diskuze"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("Vyberte silné heslo"),
        "Choose a username":
            MessageLookupByLibrary.simpleMessage("Vyberte uživatelské jméno"),
        "Close": MessageLookupByLibrary.simpleMessage("Zavřít"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Potvrdit"),
        "Connect": MessageLookupByLibrary.simpleMessage("Připojit"),
        "Connection attempt failed":
            MessageLookupByLibrary.simpleMessage("Pokus o připojení selhal"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage(
                "Kontakt byl pozván do skupiny"),
        "Content viewer":
            MessageLookupByLibrary.simpleMessage("Prohlížeč obsahu"),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("Zkopírováno do schránky"),
        "Copy": MessageLookupByLibrary.simpleMessage("Kopírovat"),
        "Could not set avatar": MessageLookupByLibrary.simpleMessage(
            "Nebylo možné nastavit avatar"),
        "Could not set displayname": MessageLookupByLibrary.simpleMessage(
            "Nebylo možné nastavit přezdívku uživatele"),
        "Create": MessageLookupByLibrary.simpleMessage("Vytvořit"),
        "Create account now":
            MessageLookupByLibrary.simpleMessage("Vytvořit účet teď"),
        "Create new group":
            MessageLookupByLibrary.simpleMessage("Založit skupinu"),
        "Currently active":
            MessageLookupByLibrary.simpleMessage("Momentálně aktivní"),
        "Dark": MessageLookupByLibrary.simpleMessage("Tmavý"),
        "Delete": MessageLookupByLibrary.simpleMessage("Smazat"),
        "Delete message": MessageLookupByLibrary.simpleMessage("Smazat zprávu"),
        "Deny": MessageLookupByLibrary.simpleMessage("Zakázat"),
        "Device": MessageLookupByLibrary.simpleMessage("Zařízení"),
        "Devices": MessageLookupByLibrary.simpleMessage("Zařízení"),
        "Discard picture":
            MessageLookupByLibrary.simpleMessage("Vyřadit obrázek"),
        "Displayname has been changed":
            MessageLookupByLibrary.simpleMessage("Přezdívka byla změněna"),
        "Donate": MessageLookupByLibrary.simpleMessage("Přispějte"),
        "Download file":
            MessageLookupByLibrary.simpleMessage("Stáhnout soubor"),
        "Edit Jitsi instance":
            MessageLookupByLibrary.simpleMessage("Nastavení instance Jitsi"),
        "Edit displayname":
            MessageLookupByLibrary.simpleMessage("Změnit přezdívku"),
        "Emote Settings":
            MessageLookupByLibrary.simpleMessage("Nastavení emotikon"),
        "Emote shortcode":
            MessageLookupByLibrary.simpleMessage("Označení emotikony"),
        "Empty chat": MessageLookupByLibrary.simpleMessage("Prázdná diskuze"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Šifrovací algoritmus"),
        "Encryption is not enabled":
            MessageLookupByLibrary.simpleMessage("Šifrování není aktivní"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "Koncové šifrování je momentálně v Beta verzi! Používejte na vlastní nebezpečí!"),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "Nastavení koncového šifrování"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("Zadejte jméno skupiny"),
        "Enter a username":
            MessageLookupByLibrary.simpleMessage("Zadejte uživatelské jméno"),
        "Enter your homeserver":
            MessageLookupByLibrary.simpleMessage("Zadejte adresu serveru"),
        "File name": MessageLookupByLibrary.simpleMessage("Název souboru"),
        "File size": MessageLookupByLibrary.simpleMessage("Velikost souboru"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("Přeposlat"),
        "Friday": MessageLookupByLibrary.simpleMessage("Pátek"),
        "From joining": MessageLookupByLibrary.simpleMessage("Od připojení"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("Od pozvání"),
        "Group": MessageLookupByLibrary.simpleMessage("Skupina"),
        "Group description":
            MessageLookupByLibrary.simpleMessage("Popis skupiny"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage("Popis skupiny byl změněn"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("Skupina je veřejná"),
        "Guests are forbidden":
            MessageLookupByLibrary.simpleMessage("Hosté jsou zakázáni"),
        "Guests can join":
            MessageLookupByLibrary.simpleMessage("Hosté se mohou připojit"),
        "Help": MessageLookupByLibrary.simpleMessage("Pomoc"),
        "Homeserver is not compatible":
            MessageLookupByLibrary.simpleMessage("Server není kompatibilní"),
        "How are you today?":
            MessageLookupByLibrary.simpleMessage("Jak se máte?"),
        "ID": MessageLookupByLibrary.simpleMessage("ID"),
        "Identity": MessageLookupByLibrary.simpleMessage("Identita"),
        "Invite contact":
            MessageLookupByLibrary.simpleMessage("Pozvat kontakt"),
        "Invited": MessageLookupByLibrary.simpleMessage("Pozváni"),
        "Invited users only":
            MessageLookupByLibrary.simpleMessage("Pouze pozvaní uživatelé"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(
                "Vypadá to, že váš telefon nemá nainstalovány google services. Dobré rozhodnutí pro vaši bezpečnost! Pro příjem notifikací doporučujeme použít miocroG: https://microg.org/"),
        "Kick from chat":
            MessageLookupByLibrary.simpleMessage("Vyhodit z diskuze"),
        "Last seen IP":
            MessageLookupByLibrary.simpleMessage("Naposledy viděná IP"),
        "Leave": MessageLookupByLibrary.simpleMessage("Odejít"),
        "Left the chat":
            MessageLookupByLibrary.simpleMessage("Odešel z diskuze"),
        "License": MessageLookupByLibrary.simpleMessage("Licence"),
        "Light": MessageLookupByLibrary.simpleMessage("Světlý"),
        "Load more...": MessageLookupByLibrary.simpleMessage("Načíst další…"),
        "Loading... Please wait":
            MessageLookupByLibrary.simpleMessage("Načítání… Prosíme počkejte"),
        "Login": MessageLookupByLibrary.simpleMessage("Přihlášení"),
        "Logout": MessageLookupByLibrary.simpleMessage("Odhlásit"),
        "Make a moderator":
            MessageLookupByLibrary.simpleMessage("Učiň moderátorem"),
        "Make an admin": MessageLookupByLibrary.simpleMessage("Učiň adminem"),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(
                "Ujistěte se, že je identifikátor validní"),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(
                "Zpráva bude odstraněna pro všechny účastníky"),
        "Moderator": MessageLookupByLibrary.simpleMessage("Moderátor"),
        "Monday": MessageLookupByLibrary.simpleMessage("Pondělí"),
        "Mute chat": MessageLookupByLibrary.simpleMessage("Ztišit diskuzi"),
        "New message in FluffyChat":
            MessageLookupByLibrary.simpleMessage("Nová zpráva ve FluffyChatu"),
        "New private chat":
            MessageLookupByLibrary.simpleMessage("Nová soukromá diskuze"),
        "No emotes found. 😕": MessageLookupByLibrary.simpleMessage(
            "Žádné emotikony nebyly nalezeny. 😕"),
        "No permission":
            MessageLookupByLibrary.simpleMessage("Chybí oprávnění"),
        "No rooms found...": MessageLookupByLibrary.simpleMessage(
            "Žádné místnosti nebyly nalezeny…"),
        "None": MessageLookupByLibrary.simpleMessage("Nic"),
        "Not supported in web":
            MessageLookupByLibrary.simpleMessage("Nepodporováno na webu"),
        "Oops something went wrong...":
            MessageLookupByLibrary.simpleMessage("Ups! Něco se pokazilo…"),
        "Open app to read messages": MessageLookupByLibrary.simpleMessage(
            "Otevřete aplikaci pro přečtení zpráv"),
        "Open camera":
            MessageLookupByLibrary.simpleMessage("Otevřít fotoaparát"),
        "Participating user devices": MessageLookupByLibrary.simpleMessage(
            "Zúčastněná zařízení uživatele"),
        "Password": MessageLookupByLibrary.simpleMessage("Heslo"),
        "Pick image": MessageLookupByLibrary.simpleMessage("Zvolit obrázek"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(""),
        "Please choose a username": MessageLookupByLibrary.simpleMessage(
            "Prosíme zvolte si uživatelské jméno"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage(
                "Prosíme zadejte identifikátor sítě matrix"),
        "Please enter your password":
            MessageLookupByLibrary.simpleMessage("Prosíme zadejte heslo"),
        "Please enter your username": MessageLookupByLibrary.simpleMessage(
            "Prosíme zadejte uživateslké jméno"),
        "Public Rooms":
            MessageLookupByLibrary.simpleMessage("Veřejné místnosti"),
        "Recording": MessageLookupByLibrary.simpleMessage("Nahrávání"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Připojit znovu"),
        "Remove": MessageLookupByLibrary.simpleMessage("Odstranit"),
        "Remove all other devices": MessageLookupByLibrary.simpleMessage(
            "Odstranit všechna další zařízení"),
        "Remove device":
            MessageLookupByLibrary.simpleMessage("Odstraň zařízení"),
        "Remove exile": MessageLookupByLibrary.simpleMessage(""),
        "Remove message":
            MessageLookupByLibrary.simpleMessage("Odstranit zprávu"),
        "Render rich message content":
            MessageLookupByLibrary.simpleMessage("Zobrazit formátovaný obsah"),
        "Reply": MessageLookupByLibrary.simpleMessage("Odpovědět"),
        "Request permission":
            MessageLookupByLibrary.simpleMessage("Vyžádat oprávnění"),
        "Request to read older messages": MessageLookupByLibrary.simpleMessage(
            "Vyžádat přečtení starších zpráv"),
        "Revoke all permissions": MessageLookupByLibrary.simpleMessage(
            "Vezmi zpět všechna oprávnění"),
        "Saturday": MessageLookupByLibrary.simpleMessage("Sobota"),
        "Search for a chat":
            MessageLookupByLibrary.simpleMessage("Hledej diskuzi"),
        "Seen a long time ago": MessageLookupByLibrary.simpleMessage(""),
        "Send": MessageLookupByLibrary.simpleMessage("Odeslat"),
        "Send a message":
            MessageLookupByLibrary.simpleMessage("Odeslat zprávu"),
        "Send file": MessageLookupByLibrary.simpleMessage("Odeslat soubor"),
        "Send image": MessageLookupByLibrary.simpleMessage("Odeslat obrázek"),
        "Set a profile picture":
            MessageLookupByLibrary.simpleMessage("Nastavit profilový obrázek"),
        "Set group description":
            MessageLookupByLibrary.simpleMessage("Nastavit popis skupiny"),
        "Set invitation link":
            MessageLookupByLibrary.simpleMessage("Nastavit zvací odkaz"),
        "Set status": MessageLookupByLibrary.simpleMessage("Nastavit status"),
        "Settings": MessageLookupByLibrary.simpleMessage("Nastavení"),
        "Share": MessageLookupByLibrary.simpleMessage("Sdílet"),
        "Sign up": MessageLookupByLibrary.simpleMessage("Registrovat se"),
        "Source code": MessageLookupByLibrary.simpleMessage("Zdrojové kódy"),
        "Start your first chat :-)": MessageLookupByLibrary.simpleMessage(
            "Začněte svou první diskuzi :)"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Neděle"),
        "System": MessageLookupByLibrary.simpleMessage("Systém"),
        "Tap to show menu":
            MessageLookupByLibrary.simpleMessage("Klepněte pro zobrazení menu"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage("Šifrování bylo poškozeno"),
        "This room has been archived.": MessageLookupByLibrary.simpleMessage(
            "Tato místnost byla archivována."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Čtvrtek"),
        "Try to send again": MessageLookupByLibrary.simpleMessage(""),
        "Tuesday": MessageLookupByLibrary.simpleMessage(""),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Neznámé zařízení"),
        "Unknown encryption algorithm": MessageLookupByLibrary.simpleMessage(
            "Neznámý šifrovací algoritmus"),
        "Unmute chat": MessageLookupByLibrary.simpleMessage("Zrušit ztišení"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "Použít barvy kompatibilní s Amoled displayem?"),
        "Username": MessageLookupByLibrary.simpleMessage("Uživatelské jméno"),
        "Verify": MessageLookupByLibrary.simpleMessage("Ověř"),
        "Video call": MessageLookupByLibrary.simpleMessage("Video hovor"),
        "Visibility of the chat history": MessageLookupByLibrary.simpleMessage(
            "Viditelnost historie diskuze"),
        "Visible for all participants": MessageLookupByLibrary.simpleMessage(
            "Viditelné pro všechny účastníky"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("Viditelné pro všechny"),
        "Voice message": MessageLookupByLibrary.simpleMessage("Hlasová zpráva"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("Pozadí"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("Středa"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "Vítejte v nejroztomilejší diskuzní aplikaci pro síť matrix."),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage(
                "Kdo se může připojit do této skupiny"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("Napište zprávu…"),
        "Yes": MessageLookupByLibrary.simpleMessage("Ano"),
        "You": MessageLookupByLibrary.simpleMessage("Ty"),
        "You are invited to this chat":
            MessageLookupByLibrary.simpleMessage("Jste zváni do této diskuze"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(
                "Této diskuze se nadále neúčastníte"),
        "You cannot invite yourself":
            MessageLookupByLibrary.simpleMessage("Nemůžete pozvat sami sebe"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage(
                "Byli jste zabanováni z této diskuze"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "Šifrování jiš nebude možné vypnout. Jste si tím jisti?"),
        "Your own username": MessageLookupByLibrary.simpleMessage(
            "Vaše vlastní uživatelské jméno"),
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
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Emotikona již existuje"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Nesprávné označení emotikony"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Musíte zvolit označení emotikony a obrázek"),
        "groupWith": m24,
        "hasWithdrawnTheInvitationFor": m25,
        "inviteContactToGroup": m26,
        "inviteText": m27,
        "invitedUser": m28,
        "is typing...": MessageLookupByLibrary.simpleMessage("píše…"),
        "joinedTheChat": m29,
        "kicked": m30,
        "kickedAndBanned": m31,
        "lastActiveAgo": m32,
        "loadCountMoreParticipants": m33,
        "logInTo": m34,
        "numberSelected": m35,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
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
