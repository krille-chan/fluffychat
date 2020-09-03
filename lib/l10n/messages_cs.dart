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
        "(Optional) Group name":
            MessageLookupByLibrary.simpleMessage("(Volitelné) Název skupiny"),
        "About": MessageLookupByLibrary.simpleMessage("O aplikaci"),
        "Accept": MessageLookupByLibrary.simpleMessage("Přijmout"),
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
        "Banned": MessageLookupByLibrary.simpleMessage("Zakázán"),
        "Block Device":
            MessageLookupByLibrary.simpleMessage("Blokovat zařízení"),
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
        "Encryption": MessageLookupByLibrary.simpleMessage("Šifrování"),
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
        "Join room":
            MessageLookupByLibrary.simpleMessage("Vstoupil do místnosti"),
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
        "Pin": MessageLookupByLibrary.simpleMessage("Připnout zprávu"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(
                "Prosím vezměte na vědomí, že pro použití koncového šifrování je prozatím potřeba použít Pantalaimon."),
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
        "Reject": MessageLookupByLibrary.simpleMessage("Zamítnout"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Připojit znovu"),
        "Remove": MessageLookupByLibrary.simpleMessage("Odstranit"),
        "Remove all other devices": MessageLookupByLibrary.simpleMessage(
            "Odstranit všechna další zařízení"),
        "Remove device":
            MessageLookupByLibrary.simpleMessage("Odstraň zařízení"),
        "Remove exile": MessageLookupByLibrary.simpleMessage("Odblokovat"),
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
        "Room has been upgraded":
            MessageLookupByLibrary.simpleMessage("Místnost byla upgradována"),
        "Saturday": MessageLookupByLibrary.simpleMessage("Sobota"),
        "Search for a chat":
            MessageLookupByLibrary.simpleMessage("Hledej diskuzi"),
        "Seen a long time ago":
            MessageLookupByLibrary.simpleMessage("Viděni velmi dávno"),
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
        "Skip": MessageLookupByLibrary.simpleMessage("Přeskočit"),
        "Source code": MessageLookupByLibrary.simpleMessage("Zdrojové kódy"),
        "Start your first chat :-)": MessageLookupByLibrary.simpleMessage(
            "Začněte svou první diskuzi :)"),
        "Submit": MessageLookupByLibrary.simpleMessage("Potvrdit"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Neděle"),
        "System": MessageLookupByLibrary.simpleMessage("Systém"),
        "Tap to show menu":
            MessageLookupByLibrary.simpleMessage("Klepněte pro zobrazení menu"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage("Šifrování bylo poškozeno"),
        "They Don\'t Match":
            MessageLookupByLibrary.simpleMessage("Neshodují se"),
        "They Match": MessageLookupByLibrary.simpleMessage("Shodují se"),
        "This room has been archived.": MessageLookupByLibrary.simpleMessage(
            "Tato místnost byla archivována."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Čtvrtek"),
        "Try to send again":
            MessageLookupByLibrary.simpleMessage("Pokusit se odeslat znovu"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("Úterý"),
        "Unblock Device":
            MessageLookupByLibrary.simpleMessage("Odblokovat zařízení"),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Neznámé zařízení"),
        "Unknown encryption algorithm": MessageLookupByLibrary.simpleMessage(
            "Neznámý šifrovací algoritmus"),
        "Unmute chat": MessageLookupByLibrary.simpleMessage("Zrušit ztišení"),
        "Unpin": MessageLookupByLibrary.simpleMessage("Odepnout zprávu"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "Použít barvy kompatibilní s Amoled displayem?"),
        "Username": MessageLookupByLibrary.simpleMessage("Uživatelské jméno"),
        "Verify": MessageLookupByLibrary.simpleMessage("Ověř"),
        "Verify User": MessageLookupByLibrary.simpleMessage("Ověřit uživatele"),
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
                "Byl vám zablokován přístup k tomuto chatu"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "Šifrování jiš nebude možné vypnout. Jste si tím jisti?"),
        "Your own username": MessageLookupByLibrary.simpleMessage(
            "Vaše vlastní uživatelské jméno"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "answeredTheCall": m2,
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Prosím zadajte vaší prístupovu frázI k \"bezpečému úložišti\" anebo \"klíč na obnovu\" pro uložení klíčů."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Pro ověření této osoby, zadejte prosím přístupovou frází k “bezpečnému úložišti” anebo “klíč pro obnovu”."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Zadejte prosím vaší přístupovou frází k “bezpečnému úložišti” anebo “klíč pro obnovu” pro ověření vaší relace."),
        "askVerificationRequest": m3,
        "bannedUser": m4,
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys":
            MessageLookupByLibrary.simpleMessage("Klíče byly úspěšně uloženy!"),
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
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Porovnejte a přesvědčete se, že následující emotikony se shodují na obou zařízeních:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Porovnejte a přesvědčete se, že následující čísla se shodují na obou zařízeních:"),
        "couldNotDecryptMessage": m20,
        "countParticipants": m21,
        "createdTheChat": m22,
        "crossSigningDisabled":
            MessageLookupByLibrary.simpleMessage("Vzájemné ověření je vypnuté"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Vzájemné ověření je zapnuté"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Emotikona již existuje!"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Nesprávné označení emotikony!"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Musíte zvolit označení emotikony a obrázek!"),
        "endedTheCall": m26,
        "groupWith": m27,
        "hasWithdrawnTheInvitationFor": m28,
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Nesprávné přístupové heslo anebo klíč pro obnovu"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invitedUser": m31,
        "is typing...": MessageLookupByLibrary.simpleMessage("píše…"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Je následjící kód zařízení správný?"),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage(
            "Klíče jsou uloženy v mezipaměti"),
        "keysMissing": MessageLookupByLibrary.simpleMessage("Chybí klíče"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "loadCountMoreParticipants": m36,
        "logInTo": m37,
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("Nová žádost o ověření!"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychet momentálně nepodporuje aktivaci křížového podpisu. Prosím aktivujte ho z klientu Riot."),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychet momentálně nepodporuje aktivaci online záloh klíčů. Prosím zapněte ji z klientu Riot."),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Online záloha klíčů je vypnutá"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Online záloha kíčů je zapnuta"),
        "passphraseOrKey":
            MessageLookupByLibrary.simpleMessage("heslo nebo klíč k ověření"),
        "play": m39,
        "redactedAnEvent": m40,
        "rejectedTheInvitation": m41,
        "removedBy": m42,
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Sezení je ověřeno"),
        "sharedTheLocation": m52,
        "startedACall": m53,
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m55,
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Neznámé sezení, prosím o ověření"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "verifiedSession":
            MessageLookupByLibrary.simpleMessage("Sezení úspěšně ověřeno!"),
        "verifyManual": MessageLookupByLibrary.simpleMessage("Ověřit ručně"),
        "verifyStart": MessageLookupByLibrary.simpleMessage("Spustit ověření"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Ověření proběhlo úspěšně!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Ověřuji druhý účet"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Čeká se na potvrzení žádosti partnerem…"),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Čeká se na potvrzení emoji partnerem…"),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Čeká se na potvrzení čísel partnerem…")
      };
}
