// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a hu locale. All the
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
  String get localeName => 'hu';

  static m0(username) => "${username} elfogadta a meghívást";

  static m1(username) =>
      "${username} aktiválta a végpontól-végpontig titkosítást";

  static m60(username) => "Elfogadod ${username} hitelesítési kérelmét?";

  static m2(username, targetName) => "${username} kitiltotta ${targetName}-t";

  static m3(homeserver) => "Alapértelmezésben ${homeserver}-hoz csatlakozol";

  static m4(username) => "${username} módosította a csevegés képét";

  static m5(username, description) =>
      "${username} módosította a csevegés leírását erre: \'${description}\'";

  static m6(username, chatname) =>
      "${username} módosította a csevegés nevét erre: \'${chatname}\'";

  static m7(username) => "${username} módosította a csevegési enegedélyeket";

  static m8(username, displayname) =>
      "${username} módosította a megjenelítési nevét erre: ${displayname}";

  static m9(username) =>
      "${username} módosította a vendégek hozzáférési jogait";

  static m10(username, rules) =>
      "${username} módosította a vendégek hozzáférési jogait, így: ${rules}";

  static m11(username) =>
      "${username} módosította a múltbéli események láthatóságát";

  static m12(username, rules) =>
      "${username} módosította a múltbéli események láthatóságát, így: ${rules}";

  static m13(username) => "${username} módosított a csatlakozási szabályokat";

  static m14(username, joinRules) =>
      "${username} módosította a csatlakozási szabályokat, így: ${joinRules}";

  static m15(username) => "${username} módosította a profil képét";

  static m16(username) => "${username} módosítottaa szoba álnevét";

  static m17(username) => "${username} módosította a meghívó linket";

  static m18(error) =>
      "Nem sikerült visszafejteni a titkosított üzenetet: ${error}";

  static m19(count) => "${count} résztvevő";

  static m20(username) => "${username} létrehozta a csevegést";

  static m21(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m22(year, month, day) => "${year}-${month}-${day}";

  static m23(month, day) => "${month}-${day}";

  static m24(displayname) => "Csoport ${displayname}-vel";

  static m25(username, targetName) =>
      "${username} visszavonta ${targetName} meghívását";

  static m26(groupName) => "Ismerős meghívása a ${groupName} csoportba";

  static m27(username, link) =>
      "${username} meghívott a FluffyChatre. \n1. FluffyChat telepítése: http://fluffy.chat \n2. Jelentkezz be vagy regisztrálj. \n3. Nyisd meg a meghívó linket: ${link}";

  static m28(username, targetName) => "${username} meghívta ${targetName}-t";

  static m29(username) => "${username} csatalakozott a csevegéshez";

  static m30(username, targetName) => "${username} kirúgta ${targetName}-t";

  static m31(username, targetName) =>
      "${username} kirúgta és kitiltotta ${targetName}-t";

  static m32(localizedTimeShort) => "Utoljára aktív: ${localizedTimeShort}";

  static m33(count) => "További ${count} résztvevő betöltése";

  static m34(homeserver) => "Bejelentkezés ${homeserver} Matrix szerverre";

  static m35(number) => "${number} kijelölve";

  static m36(fileName) => "${fileName} lejátszása";

  static m37(username) => "${username} visszavont egy eseményt";

  static m38(username) => "${username} elutasította a meghívást";

  static m39(username) => "Törölve ${username} által";

  static m40(username) => "${username} látta";

  static m41(username, count) =>
      "${username} és ${count} másik résztvevő látta";

  static m42(username, username2) => "${username} és ${username2} látta";

  static m43(username) => "${username} fájlt küldött";

  static m44(username) => "${username} képet küldött";

  static m45(username) => "${username} matricát küldött";

  static m46(username) => "${username} videót küldött";

  static m47(username) => "${username} hangüzenetet küldött";

  static m48(username) => "${username} megosztotta a pozícióját";

  static m49(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m50(username, targetName) =>
      "${username} feloldotta ${targetName} kitiltását";

  static m51(type) => "Ismeretlen esemény \'${type}\'";

  static m52(unreadCount) => "${unreadCount} olvasatlan üzenet";

  static m53(unreadEvents) => "${unreadEvents} olvasatlan üzenet";

  static m54(unreadEvents, unreadChats) =>
      "${unreadEvents} olvastlan üzenet van ${unreadChats}-ban";

  static m55(username, count) =>
      "${username} és ${count} másik résztvevő gépel...";

  static m56(username, username2) => "${username} és ${username2} gépel...";

  static m57(username) => "${username} gépel...";

  static m58(username) => "${username} elhagyta a csevegést";

  static m59(username, type) => "${username} ${type} eseményt küldött";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "(Optional) Group name":
            MessageLookupByLibrary.simpleMessage("(Nem kötelező) Csoport név"),
        "About": MessageLookupByLibrary.simpleMessage("Névjegy"),
        "Accept": MessageLookupByLibrary.simpleMessage("Elfogad"),
        "Account": MessageLookupByLibrary.simpleMessage("Fiók"),
        "Account informations":
            MessageLookupByLibrary.simpleMessage("Fiók információk"),
        "Add a group description":
            MessageLookupByLibrary.simpleMessage("Csoport leírás hozzáadása"),
        "Admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("Van már fiókod?"),
        "Anyone can join":
            MessageLookupByLibrary.simpleMessage("Bárki csatlakozhat"),
        "Archive": MessageLookupByLibrary.simpleMessage("Archív"),
        "Archived Room":
            MessageLookupByLibrary.simpleMessage("Archivált szoba"),
        "Are guest users allowed to join": MessageLookupByLibrary.simpleMessage(
            "Csatlakozhatnak vendég felhasználók"),
        "Are you sure?": MessageLookupByLibrary.simpleMessage("Biztos?"),
        "Authentication": MessageLookupByLibrary.simpleMessage("Hitelesítés"),
        "Avatar has been changed":
            MessageLookupByLibrary.simpleMessage("Az avatar megváltozott"),
        "Ban from chat":
            MessageLookupByLibrary.simpleMessage("Csevegésből kitiltás"),
        "Banned": MessageLookupByLibrary.simpleMessage("Kitiltva"),
        "Block Device":
            MessageLookupByLibrary.simpleMessage("Eszköz blokkolása"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Mégsem"),
        "Change the homeserver":
            MessageLookupByLibrary.simpleMessage("Matrix szerver váltás"),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("Csoport nevének módosítása"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Szerver módosítás"),
        "Change wallpaper":
            MessageLookupByLibrary.simpleMessage("Háttér módosítása"),
        "Change your style":
            MessageLookupByLibrary.simpleMessage("Stílus módosítása"),
        "Changelog": MessageLookupByLibrary.simpleMessage("Változás napló"),
        "Chat": MessageLookupByLibrary.simpleMessage("Csevegés"),
        "Chat details":
            MessageLookupByLibrary.simpleMessage("Csevegés részletei"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("Válassz egy erős jelszót"),
        "Choose a username": MessageLookupByLibrary.simpleMessage(
            "Válassz egy felhasználónevet"),
        "Close": MessageLookupByLibrary.simpleMessage("Bezárás"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Megerősítés"),
        "Connect": MessageLookupByLibrary.simpleMessage("Csatlakozás"),
        "Connection attempt failed": MessageLookupByLibrary.simpleMessage(
            "Csatlakozási kísérlet meghiusult"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage(
                "Meghívtad ismerősödet a csoportba"),
        "Content viewer":
            MessageLookupByLibrary.simpleMessage("Tartalom nézegető"),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("Vágólapra másolva"),
        "Copy": MessageLookupByLibrary.simpleMessage("Másolás"),
        "Could not set avatar": MessageLookupByLibrary.simpleMessage(
            "Nem sikerült beállítani a képet"),
        "Could not set displayname": MessageLookupByLibrary.simpleMessage(
            "Nem sikerült beállítani a megjelenítési nevet"),
        "Create": MessageLookupByLibrary.simpleMessage("Létrehozás"),
        "Create account now":
            MessageLookupByLibrary.simpleMessage("Új fiók létrehozása"),
        "Create new group":
            MessageLookupByLibrary.simpleMessage("Új csoport létrehozása"),
        "Currently active":
            MessageLookupByLibrary.simpleMessage("Jelenleg aktív"),
        "Dark": MessageLookupByLibrary.simpleMessage("Sötét"),
        "Delete": MessageLookupByLibrary.simpleMessage("Törlés"),
        "Delete message":
            MessageLookupByLibrary.simpleMessage("Üzenet törlése"),
        "Deny": MessageLookupByLibrary.simpleMessage("Elutasítás"),
        "Device": MessageLookupByLibrary.simpleMessage("Eszköz"),
        "Devices": MessageLookupByLibrary.simpleMessage("Eszközök"),
        "Discard picture": MessageLookupByLibrary.simpleMessage("Kép elvetése"),
        "Displayname has been changed": MessageLookupByLibrary.simpleMessage(
            "Megjelenítési név megváltozott"),
        "Donate": MessageLookupByLibrary.simpleMessage("Támogatom"),
        "Download file": MessageLookupByLibrary.simpleMessage("File letöltése"),
        "Edit Jitsi instance":
            MessageLookupByLibrary.simpleMessage("Jitsi példány módosítása"),
        "Edit displayname": MessageLookupByLibrary.simpleMessage(
            "Megjelenítési név módosítása"),
        "Emote Settings":
            MessageLookupByLibrary.simpleMessage("Hangulatjel beállítások"),
        "Emote shortcode":
            MessageLookupByLibrary.simpleMessage("Rövid kód a hangulatjelhez"),
        "Empty chat": MessageLookupByLibrary.simpleMessage("Üres csevegés"),
        "Encryption": MessageLookupByLibrary.simpleMessage("Titkosítás"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Titkosítási algoritmus"),
        "Encryption is not enabled": MessageLookupByLibrary.simpleMessage(
            "Titkosítás nincs engedélyezve"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "Végpontól-végpontig titkosítás egyelőre béta! Csak saját felelősségre!"),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "Végpontól-végpontig titkosítás beállításai"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("Adj meg egy csoport nevet"),
        "Enter a username": MessageLookupByLibrary.simpleMessage(
            "Adj meg egy felhasználónevet"),
        "Enter your homeserver": MessageLookupByLibrary.simpleMessage(
            "Add meg a Matrix szervered nevét"),
        "File name": MessageLookupByLibrary.simpleMessage("Fájl név"),
        "File size": MessageLookupByLibrary.simpleMessage("Fájl méret"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("Továbbítás"),
        "Friday": MessageLookupByLibrary.simpleMessage("Péntek"),
        "From joining": MessageLookupByLibrary.simpleMessage("Belépés óta"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("Meghívás óta"),
        "Group": MessageLookupByLibrary.simpleMessage("Csoport"),
        "Group description":
            MessageLookupByLibrary.simpleMessage("Csoport leírás"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage(
                "Csoport leírása megváltozott"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("A csoport publikus"),
        "Guests are forbidden":
            MessageLookupByLibrary.simpleMessage("Vendégeknek tilos a belépés"),
        "Guests can join":
            MessageLookupByLibrary.simpleMessage("Vendégek csatlakozhatnak"),
        "Help": MessageLookupByLibrary.simpleMessage("Segítség"),
        "Homeserver is not compatible": MessageLookupByLibrary.simpleMessage(
            "Ez a Matrix szerver nem kompatibilis"),
        "How are you today?":
            MessageLookupByLibrary.simpleMessage("Hogy vagy?"),
        "ID": MessageLookupByLibrary.simpleMessage("ID"),
        "Identity": MessageLookupByLibrary.simpleMessage("Azonosság"),
        "Invite contact":
            MessageLookupByLibrary.simpleMessage("Ismerős meghívása"),
        "Invited": MessageLookupByLibrary.simpleMessage("Meghívott"),
        "Invited users only":
            MessageLookupByLibrary.simpleMessage("Csak meghívottak"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(
                "Úgy tűnik ügyelsz a magánszférádra és nincsenek google szolgáltatások telepítve. Hogy így is kapj azonnali értesítéseket javasoljuk a microG-t: https://microg.org/"),
        "Kick from chat":
            MessageLookupByLibrary.simpleMessage("Csevegésből kirúgás"),
        "Last seen IP":
            MessageLookupByLibrary.simpleMessage("Utoljára látott IP"),
        "Leave": MessageLookupByLibrary.simpleMessage("Csevegés elhagyása"),
        "Left the chat":
            MessageLookupByLibrary.simpleMessage("Elhagyta a csevegést"),
        "License": MessageLookupByLibrary.simpleMessage("Licenc"),
        "Light": MessageLookupByLibrary.simpleMessage("Világos"),
        "Load more...":
            MessageLookupByLibrary.simpleMessage("Továbbiak betöltése..."),
        "Loading... Please wait":
            MessageLookupByLibrary.simpleMessage("Betöltés... Kérlek várj"),
        "Login": MessageLookupByLibrary.simpleMessage("Bejelentkezés"),
        "Logout": MessageLookupByLibrary.simpleMessage("Kijelentkezés"),
        "Make a moderator":
            MessageLookupByLibrary.simpleMessage("Kinevezés moderátorrá"),
        "Make an admin":
            MessageLookupByLibrary.simpleMessage("Kinevezés adminná"),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(
                "Bizonyosodj meg az azonosító helyességéről"),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(
                "Az üzenet minden résztvevő számára törlődni fog"),
        "Moderator": MessageLookupByLibrary.simpleMessage("Moderátor"),
        "Monday": MessageLookupByLibrary.simpleMessage("Hétfő"),
        "Mute chat": MessageLookupByLibrary.simpleMessage("Csevegés némítása"),
        "New message in FluffyChat":
            MessageLookupByLibrary.simpleMessage("Új üzenet a FluffyChaten"),
        "New private chat":
            MessageLookupByLibrary.simpleMessage("Új privát csevegés"),
        "No emotes found. 😕":
            MessageLookupByLibrary.simpleMessage("Nincsenek hangulatjelek. 😕"),
        "No permission":
            MessageLookupByLibrary.simpleMessage("Nincsenek engedélyek"),
        "No rooms found...":
            MessageLookupByLibrary.simpleMessage("Nem találtam szobákat..."),
        "None": MessageLookupByLibrary.simpleMessage("Nincs"),
        "Not supported in web":
            MessageLookupByLibrary.simpleMessage("Nem támogatott a weben"),
        "Oops something went wrong...": MessageLookupByLibrary.simpleMessage(
            "Hoppá, valami baj történt..."),
        "Open app to read messages": MessageLookupByLibrary.simpleMessage(
            "App megnyitása az üzenetek elolvasásához"),
        "Open camera":
            MessageLookupByLibrary.simpleMessage("Kamera megnyitása"),
        "Participating user devices": MessageLookupByLibrary.simpleMessage(
            "Résztvevő felhasználók eszközei"),
        "Password": MessageLookupByLibrary.simpleMessage("Jelszó"),
        "Pick image": MessageLookupByLibrary.simpleMessage("Válassz egy képet"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(
                "Tájékoztatlak, hogy egyelőre szükséged van a Pantalaimon-ra, hogy a végponttól-végpontig titkosítást hasnzáld."),
        "Please choose a username": MessageLookupByLibrary.simpleMessage(
            "Válassz egy felhasználónevet"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage(
                "Írj be egy Matrix azonosítót"),
        "Please enter your password":
            MessageLookupByLibrary.simpleMessage("Add meg a jelszavad"),
        "Please enter your username": MessageLookupByLibrary.simpleMessage(
            "Add meg a felhasználónevedet"),
        "Public Rooms": MessageLookupByLibrary.simpleMessage("Publikus szoba"),
        "Recording": MessageLookupByLibrary.simpleMessage("Felvétel"),
        "Reject": MessageLookupByLibrary.simpleMessage("Visszautasít"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Újracsatlakozás"),
        "Remove": MessageLookupByLibrary.simpleMessage("Eltávolítás"),
        "Remove all other devices": MessageLookupByLibrary.simpleMessage(
            "Minden más eszköz eltávolítása"),
        "Remove device":
            MessageLookupByLibrary.simpleMessage("Eszköz eltávolítása"),
        "Remove exile":
            MessageLookupByLibrary.simpleMessage("Kitiltás feloldása"),
        "Remove message":
            MessageLookupByLibrary.simpleMessage("Üzenet eltávolítása"),
        "Render rich message content": MessageLookupByLibrary.simpleMessage(
            "Formázott üzenetek megjelenítése"),
        "Reply": MessageLookupByLibrary.simpleMessage("Válasz"),
        "Request permission":
            MessageLookupByLibrary.simpleMessage("Jogosultság igénylése"),
        "Request to read older messages": MessageLookupByLibrary.simpleMessage(
            "Korábbi üzenetekhez való hozzáférés igénylése"),
        "Revoke all permissions": MessageLookupByLibrary.simpleMessage(
            "Minden jogosultság megvonása"),
        "Room has been upgraded":
            MessageLookupByLibrary.simpleMessage("Szoba frissítve lett"),
        "Saturday": MessageLookupByLibrary.simpleMessage("Szombat"),
        "Search for a chat":
            MessageLookupByLibrary.simpleMessage("Csevegés keresése"),
        "Seen a long time ago":
            MessageLookupByLibrary.simpleMessage("Már régen látta"),
        "Send": MessageLookupByLibrary.simpleMessage("Küldés"),
        "Send a message":
            MessageLookupByLibrary.simpleMessage("Üzenet küldése"),
        "Send file": MessageLookupByLibrary.simpleMessage("Fájl küldése"),
        "Send image": MessageLookupByLibrary.simpleMessage("Kép küldése"),
        "Set a profile picture":
            MessageLookupByLibrary.simpleMessage("Profilkép beállítása"),
        "Set group description":
            MessageLookupByLibrary.simpleMessage("Csoport leírás beállítása"),
        "Set invitation link":
            MessageLookupByLibrary.simpleMessage("Meghívó link beállítása"),
        "Set status":
            MessageLookupByLibrary.simpleMessage("Állapot beállítása"),
        "Settings": MessageLookupByLibrary.simpleMessage("Beállítások"),
        "Share": MessageLookupByLibrary.simpleMessage("Megosztás"),
        "Sign up": MessageLookupByLibrary.simpleMessage("Felíratkozás"),
        "Skip": MessageLookupByLibrary.simpleMessage("Kihagy"),
        "Source code": MessageLookupByLibrary.simpleMessage("Forráskód"),
        "Start your first chat :-)":
            MessageLookupByLibrary.simpleMessage("Kezdj el csevegni :-)"),
        "Submit": MessageLookupByLibrary.simpleMessage("Mehet"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Vasárnap"),
        "System": MessageLookupByLibrary.simpleMessage("Rendszer"),
        "Tap to show menu": MessageLookupByLibrary.simpleMessage(
            "Érintsd meg a menü megnyitásához"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage(
                "A titkosítás sérült és megbízhatatlan"),
        "They Don\'t Match":
            MessageLookupByLibrary.simpleMessage("Nem egyeznek"),
        "They Match": MessageLookupByLibrary.simpleMessage("Megegyeznek"),
        "This room has been archived.":
            MessageLookupByLibrary.simpleMessage("Ez a szoba archiválva lett."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Csütörtök"),
        "Try to send again":
            MessageLookupByLibrary.simpleMessage("Próbáld újraküldeni"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("Kedd"),
        "Unblock Device": MessageLookupByLibrary.simpleMessage(
            "Eszköz blokkolásának megszüntetése"),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Ismeretlen eszköz"),
        "Unknown encryption algorithm": MessageLookupByLibrary.simpleMessage(
            "Ismeretlen titkosítási algoritmus"),
        "Unmute chat":
            MessageLookupByLibrary.simpleMessage("Csevegés felhangosítása"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "AmoLED kompatibilis színek használata?"),
        "Username": MessageLookupByLibrary.simpleMessage("Felhasználónév"),
        "Verify": MessageLookupByLibrary.simpleMessage("Hitelesít"),
        "Verify User":
            MessageLookupByLibrary.simpleMessage("Felhasználó hitelesítése"),
        "Video call": MessageLookupByLibrary.simpleMessage("Videó hívás"),
        "Visibility of the chat history": MessageLookupByLibrary.simpleMessage(
            "Csevegési előzmény láthatósága"),
        "Visible for all participants": MessageLookupByLibrary.simpleMessage(
            "Minden résztvevő számára látható"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("Bárki számára látható"),
        "Voice message": MessageLookupByLibrary.simpleMessage("Hang üzenet"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("Háttér"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("Szerda"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "Üdv a legcukibb üzenetküldő alkalmazásban az egész Matrixon!"),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage(
                "Ki csatlakozhat a csoporthoz"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("Írj egy üzenetet..."),
        "Yes": MessageLookupByLibrary.simpleMessage("Igen"),
        "You": MessageLookupByLibrary.simpleMessage("Te"),
        "You are invited to this chat":
            MessageLookupByLibrary.simpleMessage("Meghívtak ebbe a csevegésbe"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(
                "Nem veszel részt ebben a csevegésben"),
        "You cannot invite yourself":
            MessageLookupByLibrary.simpleMessage("Nem tudod meghívni magadat"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage(
                "Kitiltottak ebből a csevegésből"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "Többé nem tudod kikapcsolni a titkosítás. Biztosan folytatod?"),
        "Your own username":
            MessageLookupByLibrary.simpleMessage("A saját felhasználóneved"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("álnév"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Add meg a biztonságos tárolóhoz tartozó vagy a visszaállítási jelszavadat, hogy betöltsük a kulcsaidat."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "A másik személy igazolásához, kérlek add meg jelszavadat vagy visszaállítási kulcsodat."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Add meg a biztonságos tárolóhoz tartozó vagy a visszaállítási jelszavadat, a munkamenet hitelesítéséhez."),
        "askVerificationRequest": m60,
        "bannedUser": m2,
        "byDefaultYouWillBeConnectedTo": m3,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Sikeresen betöltöttük a kulcsokat!"),
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
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Hasonlítsd össze a hangulatjeleket a másik eszközön lévőkkel:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Hasonlítsd össze a számokat a másik eszközön lévőkkel:"),
        "couldNotDecryptMessage": m18,
        "countParticipants": m19,
        "createdTheChat": m20,
        "crossSigningDisabled":
            MessageLookupByLibrary.simpleMessage("Kereszt-Aláírás kikapcsolva"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Kereszt-Aláírás bekapcsolva"),
        "dateAndTimeOfDay": m21,
        "dateWithYear": m22,
        "dateWithoutYear": m23,
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("A hangulatjel már létezik!"),
        "emoteInvalid":
            MessageLookupByLibrary.simpleMessage("Érvénytelen rövid kód!"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "A hangulatjelhez válassz egy képet és egy rövid kód"),
        "groupWith": m24,
        "hasWithdrawnTheInvitationFor": m25,
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Hibás jelszó vagy visszaállítási kulcs"),
        "inviteContactToGroup": m26,
        "inviteText": m27,
        "invitedUser": m28,
        "is typing...": MessageLookupByLibrary.simpleMessage("gépel..."),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Helyes az alábbi eszköz kulcs?"),
        "joinedTheChat": m29,
        "keysCached": MessageLookupByLibrary.simpleMessage("Kulcsok betöltve"),
        "keysMissing":
            MessageLookupByLibrary.simpleMessage("Kulcsok hiányoznak"),
        "kicked": m30,
        "kickedAndBanned": m31,
        "lastActiveAgo": m32,
        "loadCountMoreParticipants": m33,
        "logInTo": m34,
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("Új hitelesítési kérelem!"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "FluffyChat jelenleg nem támogatja a Kereszt-Aláírás bekapcsolását. Kérlek engedélyezd Riot-ból."),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "FluffyChat jelenleg nem támogatja az Online Kulcs Archívumot (backup). Kérlek engedélyezd Riot-ból."),
        "numberSelected": m35,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Online Kulcs Archívum letiltva"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Online Kulcs Archívum engedélyezve"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Jelszó vagy visszaállítási kulcs"),
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
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Munkamenet hitelesítve"),
        "sharedTheLocation": m48,
        "timeOfDay": m49,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m50,
        "unknownEvent": m51,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Ismeretlen munkamenet, kérlek hitelesítsd"),
        "unreadChats": m52,
        "unreadMessages": m53,
        "unreadMessagesInChats": m54,
        "userAndOthersAreTyping": m55,
        "userAndUserAreTyping": m56,
        "userIsTyping": m57,
        "userLeftTheChat": m58,
        "userSentUnknownEvent": m59,
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Sikeresen hitelesítetted a munkamenetedet!"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Kézi hitelesítés"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Hitelesítés megkezdése"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Sikeresen hitelesítettél!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Másik fiók hitelesítése"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Várakozás partnerre, amíg elfogadja a kérést..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Várakozás partnere, amíg elfogadja a hangulatjeleket..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Várakozás partnere, amíg elfogadja a számokat...")
      };
}
