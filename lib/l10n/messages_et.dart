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
        "(Optional) Group name":
            MessageLookupByLibrary.simpleMessage("(Kui soovid) Rühma nimi"),
        "About": MessageLookupByLibrary.simpleMessage("Rakenduse teave"),
        "Accept": MessageLookupByLibrary.simpleMessage("Nõustu"),
        "Account": MessageLookupByLibrary.simpleMessage("Kasutajakonto"),
        "Account informations":
            MessageLookupByLibrary.simpleMessage("Kasutajakonto teave"),
        "Add a group description":
            MessageLookupByLibrary.simpleMessage("Lisa rühma kirjeldus"),
        "Admin": MessageLookupByLibrary.simpleMessage("Peakasutaja"),
        "Allow sending bug reports with sentry.io":
            MessageLookupByLibrary.simpleMessage(
                "Luba veateadete saatmist sentry.io vahendusel"),
        "Already have an account?": MessageLookupByLibrary.simpleMessage(
            "Sul juba on kasutajakonto olemas?"),
        "Anyone can join":
            MessageLookupByLibrary.simpleMessage("Kõik võivad liituda"),
        "Archive": MessageLookupByLibrary.simpleMessage("Arhiiv"),
        "Archived Room":
            MessageLookupByLibrary.simpleMessage("Arhiveeritud jututuba"),
        "Are guest users allowed to join": MessageLookupByLibrary.simpleMessage(
            "Kas külalised võivad liituda"),
        "Are you sure?":
            MessageLookupByLibrary.simpleMessage("Kas sa oled kindel?"),
        "Authentication": MessageLookupByLibrary.simpleMessage("Autentimine"),
        "Avatar has been changed":
            MessageLookupByLibrary.simpleMessage("Tunnuspilt on muudetud"),
        "Ban from chat":
            MessageLookupByLibrary.simpleMessage("Keela ligipääs vestlusele"),
        "Banned": MessageLookupByLibrary.simpleMessage(
            "Ligipääs vestlusele on keelatud"),
        "Block Device": MessageLookupByLibrary.simpleMessage("Blokeeri seade"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Tühista"),
        "Change the homeserver":
            MessageLookupByLibrary.simpleMessage("Muuda koduserverit"),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("Muuda rühma nime"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Muuda serverit"),
        "Change wallpaper":
            MessageLookupByLibrary.simpleMessage("Muuda taustapilti"),
        "Change your style":
            MessageLookupByLibrary.simpleMessage("Muuda oma stiili"),
        "Changelog": MessageLookupByLibrary.simpleMessage("Muudatuste logi"),
        "Changes have been saved":
            MessageLookupByLibrary.simpleMessage("Salvestasin muudatused"),
        "Chat": MessageLookupByLibrary.simpleMessage("Vestlus"),
        "Chat details": MessageLookupByLibrary.simpleMessage("Vestluse teave"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("Vali korralik salasõna"),
        "Choose a username":
            MessageLookupByLibrary.simpleMessage("Vali kasutajanimi"),
        "Close": MessageLookupByLibrary.simpleMessage("Sulge"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Kinnita"),
        "Connect": MessageLookupByLibrary.simpleMessage("Ühenda"),
        "Connection attempt failed": MessageLookupByLibrary.simpleMessage(
            "Ühenduse loomise katse ebaõnnestus"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage(
                "Sinu kontakt on kutsutud liituma rühmaga"),
        "Content viewer": MessageLookupByLibrary.simpleMessage("Sisukuvaja"),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("Kopeerisin lõikelauale"),
        "Copy": MessageLookupByLibrary.simpleMessage("Kopeeri"),
        "Could not set avatar": MessageLookupByLibrary.simpleMessage(
            "Tunnuspildi seadmine ei õnnestunud"),
        "Could not set displayname": MessageLookupByLibrary.simpleMessage(
            "Kuvatava nime määramine ei õnnestunud"),
        "Create": MessageLookupByLibrary.simpleMessage("Loo"),
        "Create account now":
            MessageLookupByLibrary.simpleMessage("Tee nüüd kasutajakonto"),
        "Create new group":
            MessageLookupByLibrary.simpleMessage("Loo uus rühm"),
        "Currently active":
            MessageLookupByLibrary.simpleMessage("Hetkel aktiivne"),
        "Dark": MessageLookupByLibrary.simpleMessage("Tume"),
        "Delete": MessageLookupByLibrary.simpleMessage("Kustuta"),
        "Delete message": MessageLookupByLibrary.simpleMessage("Kustuta sõnum"),
        "Deny": MessageLookupByLibrary.simpleMessage("Keela"),
        "Device": MessageLookupByLibrary.simpleMessage("Seade"),
        "Devices": MessageLookupByLibrary.simpleMessage("Seadmed"),
        "Discard picture": MessageLookupByLibrary.simpleMessage("Emalda pilt"),
        "Displayname has been changed":
            MessageLookupByLibrary.simpleMessage("Kuvatav nimi on muudetud"),
        "Donate": MessageLookupByLibrary.simpleMessage("Toeta"),
        "Download file": MessageLookupByLibrary.simpleMessage("Lae fail alla"),
        "Edit Jitsi instance":
            MessageLookupByLibrary.simpleMessage("Muuda Jitsi liidestust"),
        "Edit displayname":
            MessageLookupByLibrary.simpleMessage("Muuda kuvatavat nime"),
        "Emote Settings": MessageLookupByLibrary.simpleMessage(
            "Emotsioonitegevuste seadistused"),
        "Emote shortcode":
            MessageLookupByLibrary.simpleMessage("Emotsioonitegevuse lühikood"),
        "Empty chat":
            MessageLookupByLibrary.simpleMessage("Vestlust pole olnud"),
        "Encryption": MessageLookupByLibrary.simpleMessage("Krüptimine"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Krüptoalgoritm"),
        "Encryption is not enabled":
            MessageLookupByLibrary.simpleMessage("Krüptimine ei ole kasutusel"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "Läbiv krüptimine on parasjagu beetatestimise faasis! Kasuta seda omal vastutusel!"),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "Läbiva krüptimise seadistused"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("Sisesta rühma nimi"),
        "Enter a username":
            MessageLookupByLibrary.simpleMessage("Sisesta kasutajanimi"),
        "Enter your homeserver": MessageLookupByLibrary.simpleMessage(
            "Sisesta oma koduserveri aadress"),
        "File name": MessageLookupByLibrary.simpleMessage("Faili nimi"),
        "File size": MessageLookupByLibrary.simpleMessage("Faili suurus"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("Edasi"),
        "Friday": MessageLookupByLibrary.simpleMessage("Reede"),
        "From joining":
            MessageLookupByLibrary.simpleMessage("Alates liitumise hetkest"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("Kutse saamisest"),
        "Group": MessageLookupByLibrary.simpleMessage("Rühm"),
        "Group description":
            MessageLookupByLibrary.simpleMessage("Rühma kirjeldus"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage("Rühma kirjeldus on muutunud"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("Rühm on avalik"),
        "Guests are forbidden":
            MessageLookupByLibrary.simpleMessage("Külalised ei ole lubatud"),
        "Guests can join":
            MessageLookupByLibrary.simpleMessage("Külalised võivad liituda"),
        "Help": MessageLookupByLibrary.simpleMessage("Abiteave"),
        "Homeserver is not compatible":
            MessageLookupByLibrary.simpleMessage("Koduserver ei ole ühilduv"),
        "How are you today?":
            MessageLookupByLibrary.simpleMessage("Kuidas sul täna läheb?"),
        "ID": MessageLookupByLibrary.simpleMessage("ID"),
        "Identity": MessageLookupByLibrary.simpleMessage("Identiteet"),
        "Informations about your privacy: https://sentry.io/security/":
            MessageLookupByLibrary.simpleMessage(
                "Teave sinu privaatsuse kohta: https://sentry.io/security/"),
        "Invite contact":
            MessageLookupByLibrary.simpleMessage("Kutsu neid, keda sa tead"),
        "Invited": MessageLookupByLibrary.simpleMessage("Kutsutud"),
        "Invited users only": MessageLookupByLibrary.simpleMessage(
            "Ainult kutsutud kasutajatele"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(
                "Tundub, et sinu nutiseadmes pole Google teenuseid. Sinu privaatsuse mõttes on see kindlasti hea otsus! Kui sa soovid FluffyChat\'is näha tõuketeavitusi, siis soovitame, et selle asemel kasutad microG liidestust https://microg.org/"),
        "Join room": MessageLookupByLibrary.simpleMessage("Liitu jututoaga"),
        "Kick from chat":
            MessageLookupByLibrary.simpleMessage("Müksa vestlusest välja"),
        "Last seen IP":
            MessageLookupByLibrary.simpleMessage("Viimati nähtud IP-aadress"),
        "Leave": MessageLookupByLibrary.simpleMessage("Lahku"),
        "Left the chat":
            MessageLookupByLibrary.simpleMessage("Lahkus vestlusest"),
        "License": MessageLookupByLibrary.simpleMessage("Litsents"),
        "Light": MessageLookupByLibrary.simpleMessage("Hele"),
        "Load more...": MessageLookupByLibrary.simpleMessage("Lae veel..."),
        "Loading... Please wait":
            MessageLookupByLibrary.simpleMessage("Laen andmeid... Palun oota"),
        "Login": MessageLookupByLibrary.simpleMessage("Logi sisse"),
        "Logout": MessageLookupByLibrary.simpleMessage("Logi välja"),
        "Make a moderator":
            MessageLookupByLibrary.simpleMessage("Määra moderaatoriks"),
        "Make an admin":
            MessageLookupByLibrary.simpleMessage("Määra peakasutajaks"),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(
                "Kontrolli, et see tunnus oleks õige"),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(
                "Sõnum eemaldatakse kõikidelt kasutajatelt"),
        "Moderator": MessageLookupByLibrary.simpleMessage("Moderaator"),
        "Monday": MessageLookupByLibrary.simpleMessage("Esmaspäev"),
        "Mute chat": MessageLookupByLibrary.simpleMessage("Summuta vestlus"),
        "New message in FluffyChat": MessageLookupByLibrary.simpleMessage(
            "Uus sõnum FluffyChat\'i vahendusel"),
        "New private chat":
            MessageLookupByLibrary.simpleMessage("Uus privaatne vestlus"),
        "No": MessageLookupByLibrary.simpleMessage("Ei"),
        "No emotes found. 😕": MessageLookupByLibrary.simpleMessage(
            "Ühtegi emotsioonitegevust ei leidunud. 😕"),
        "No permission":
            MessageLookupByLibrary.simpleMessage("Õigused puuduvad"),
        "No rooms found...":
            MessageLookupByLibrary.simpleMessage("Jututubasid ei leidunud..."),
        "None": MessageLookupByLibrary.simpleMessage("Mitte midagi"),
        "Not supported in web": MessageLookupByLibrary.simpleMessage(
            "See funktsionaalsus ei ole veebiliideses toetatud"),
        "Oops something went wrong...": MessageLookupByLibrary.simpleMessage(
            "Hopsti! Midagi läks nüüd viltu..."),
        "Open app to read messages": MessageLookupByLibrary.simpleMessage(
            "Sõnumite lugemiseks ava rakendus"),
        "Open camera": MessageLookupByLibrary.simpleMessage("Ava kaamera"),
        "Participating user devices":
            MessageLookupByLibrary.simpleMessage("Kaasatud kasutajate seadmed"),
        "Password": MessageLookupByLibrary.simpleMessage("Salasõna"),
        "Pick image": MessageLookupByLibrary.simpleMessage("Vali pilt"),
        "Pin": MessageLookupByLibrary.simpleMessage("Klammerda"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(
                "Palun arvesta, et hetkel saad kasutada läbivat krüptimist vaid siis, kui koduserver töötab Pantalaimon\'il."),
        "Please choose a username":
            MessageLookupByLibrary.simpleMessage("Palun vali kasutajanimi"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage(
                "Palun sisesta Matrix\'i kasutajatunnus"),
        "Please enter your password":
            MessageLookupByLibrary.simpleMessage("Palun sisesta oma salasõna"),
        "Please enter your username": MessageLookupByLibrary.simpleMessage(
            "Palun sisesta oma kasutajanimi"),
        "Public Rooms":
            MessageLookupByLibrary.simpleMessage("Avalikud jututoad"),
        "Recording": MessageLookupByLibrary.simpleMessage("Salvestan"),
        "Reject": MessageLookupByLibrary.simpleMessage("Lükka tagasi"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Liitu uuesti"),
        "Remove": MessageLookupByLibrary.simpleMessage("Eemalda"),
        "Remove all other devices":
            MessageLookupByLibrary.simpleMessage("Eemalda kõik muud seadmed"),
        "Remove device": MessageLookupByLibrary.simpleMessage("Eemalda seade"),
        "Remove exile":
            MessageLookupByLibrary.simpleMessage("Eemalda suhtluskeeld"),
        "Remove message": MessageLookupByLibrary.simpleMessage("Eemalda sõnum"),
        "Render rich message content": MessageLookupByLibrary.simpleMessage(
            "Visualiseeri vormindatud sõnumite sisu"),
        "Reply": MessageLookupByLibrary.simpleMessage("Vasta"),
        "Request permission":
            MessageLookupByLibrary.simpleMessage("Palu õigusi"),
        "Request to read older messages": MessageLookupByLibrary.simpleMessage(
            "Palu õigust lugeda vanu sõnumeid"),
        "Revoke all permissions":
            MessageLookupByLibrary.simpleMessage("Tühista kõik õigused"),
        "Room has been upgraded":
            MessageLookupByLibrary.simpleMessage("Jututuba on uuendatud"),
        "Saturday": MessageLookupByLibrary.simpleMessage("Laupäev"),
        "Search for a chat":
            MessageLookupByLibrary.simpleMessage("Otsi vestlust"),
        "Seen a long time ago":
            MessageLookupByLibrary.simpleMessage("Nähtud ammu aega tagasi"),
        "Send": MessageLookupByLibrary.simpleMessage("Saada"),
        "Send a message": MessageLookupByLibrary.simpleMessage("Saada sõnum"),
        "Send audio": MessageLookupByLibrary.simpleMessage("Saada helifail"),
        "Send file": MessageLookupByLibrary.simpleMessage("Saada fail"),
        "Send image": MessageLookupByLibrary.simpleMessage("Saada pilt"),
        "Send original":
            MessageLookupByLibrary.simpleMessage("Saada algupärane fail"),
        "Send video": MessageLookupByLibrary.simpleMessage("Saada videofail"),
        "Set a profile picture":
            MessageLookupByLibrary.simpleMessage("Seadista profiilipilt"),
        "Set group description":
            MessageLookupByLibrary.simpleMessage("Seadista rühma kirjeldus"),
        "Set invitation link":
            MessageLookupByLibrary.simpleMessage("Tee kutse link"),
        "Set status": MessageLookupByLibrary.simpleMessage("Määra olek"),
        "Settings": MessageLookupByLibrary.simpleMessage("Seadistused"),
        "Share": MessageLookupByLibrary.simpleMessage("Jaga"),
        "Sign up": MessageLookupByLibrary.simpleMessage("Liitu"),
        "Skip": MessageLookupByLibrary.simpleMessage("Jäta vahele"),
        "Source code": MessageLookupByLibrary.simpleMessage("Lähtekood"),
        "Start your first chat :-)": MessageLookupByLibrary.simpleMessage(
            "Alusta oma esimest vestlust :-)"),
        "Submit": MessageLookupByLibrary.simpleMessage("Saada"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Pühapäev"),
        "System": MessageLookupByLibrary.simpleMessage("Süsteem"),
        "Tap to show menu":
            MessageLookupByLibrary.simpleMessage("Menüü kuvamiseks puuduta"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage(
                "Kasutatud krüptimine on vigane"),
        "They Don\'t Match":
            MessageLookupByLibrary.simpleMessage("Nad ei klapi omavahel"),
        "They Match":
            MessageLookupByLibrary.simpleMessage("Nad klapivad omavahel"),
        "This room has been archived.": MessageLookupByLibrary.simpleMessage(
            "See jututuba on arhiveeritud."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Neljapäev"),
        "Try to send again":
            MessageLookupByLibrary.simpleMessage("Proovi uuesti saata"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("Teisipäev"),
        "Unblock Device":
            MessageLookupByLibrary.simpleMessage("Eemalda seadmelt blokeering"),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Tundmatu seade"),
        "Unknown encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Tundmatu krüptoalgoritm"),
        "Unmute chat": MessageLookupByLibrary.simpleMessage(
            "Lõpeta vestluse vaigistamine"),
        "Unpin": MessageLookupByLibrary.simpleMessage("Eemalda klammerdus"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "Kas kasutame amoled-tehnoloogiaga ühilduvaid värve?"),
        "Username": MessageLookupByLibrary.simpleMessage("Kasutajanimi"),
        "Verify": MessageLookupByLibrary.simpleMessage("Verifitseeri"),
        "Verify User":
            MessageLookupByLibrary.simpleMessage("Verifitseeri kasutajat"),
        "Video call": MessageLookupByLibrary.simpleMessage("Videokõne"),
        "Visibility of the chat history":
            MessageLookupByLibrary.simpleMessage("Vestluse ajaloo nähtavus"),
        "Visible for all participants": MessageLookupByLibrary.simpleMessage(
            "Nähtav kõikidele osalejatele"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("Nähtav kõikidele"),
        "Voice message": MessageLookupByLibrary.simpleMessage("Häälsõnum"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("Taustapilt"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("Kolmapäev"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "Tere tulemast kasutama kõige vahvamat sõnumiklienti Matrix\'i võrgus."),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage(
                "Kes võivad selle rühmaga liituda"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("Kirjuta üks sõnum..."),
        "Yes": MessageLookupByLibrary.simpleMessage("Jah"),
        "You": MessageLookupByLibrary.simpleMessage("Sina"),
        "You are invited to this chat": MessageLookupByLibrary.simpleMessage(
            "Sa oled kutsutud osalema selles vestluses"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(
                "Sa enam ei osale selles vestluses"),
        "You cannot invite yourself": MessageLookupByLibrary.simpleMessage(
            "Sa ei saa endale kutset saata"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage(
                "Sinule on selles vestluses seatud suhtluskeeld"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "Sa ei saa hiljem enam krüptimist välja lülitada. Kas oled kindel?"),
        "Your own username":
            MessageLookupByLibrary.simpleMessage("Sinu oma kasutajanimi"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("alias"),
        "answeredTheCall": m2,
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Krüptovõtmete puhverdamiseks palun sisesta oma turvahoidla paroolifraas või taastevõti."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Selleks, et teist osapoolt identifitseerivat allkirja anda, palun sisesta oma turvahoidla paroolifraas või taastevõti."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Oma sessiooni verifitseerimiseks palun sisesta oma turvahoidla paroolifraas või taastevõti."),
        "askVerificationRequest": m3,
        "bannedUser": m4,
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Krüptovõtmed on edukalt puhverdatud!"),
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
            "Võrdle ja kontrolli, et emotikonid on teises seadmes täpselt samad:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Võrdle ja kontrolli, et järgnevad numbrid on teises seadmes täpselt samad:"),
        "couldNotDecryptMessage": m20,
        "countParticipants": m21,
        "createdTheChat": m22,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "Risttunnustamine ei ole kasutusel"),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(
            "Risttunnustamine on kasutusel"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "emoteExists": MessageLookupByLibrary.simpleMessage(
            "Selline emotsioonitegevus on juba olemas!"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Vigane emotsioonitegevuse lühikood!"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Sa pead valima emotsioonitegevuse lühikoodi ja pildi!"),
        "endedTheCall": m26,
        "groupWith": m27,
        "hasWithdrawnTheInvitationFor": m28,
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Vigane paroolifraas või taastevõti"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invitedUser": m31,
        "is typing...": MessageLookupByLibrary.simpleMessage("kirjutab..."),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Kas järgnev seadmevõti on õige?"),
        "joinedTheChat": m32,
        "keysCached":
            MessageLookupByLibrary.simpleMessage("Krüptovõtmed on puhverdatud"),
        "keysMissing":
            MessageLookupByLibrary.simpleMessage("Krüptovõtmed on puudu"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "loadCountMoreParticipants": m36,
        "logInTo": m37,
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("Uus verifitseerimispäring!"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "FluffyChat hetkel ei toeta risttunnustamist. Palun võta ta kasutusele Element\'i (vana nimega Riot) vahendusel."),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "FluffyChat hetkel ei toeta krüptovõtmete võrgupõhise varunduse kasutusele võtmist. Palun võta ta kasutusele Element\'i (vana nimega Riot) vahendusel."),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("sobib"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Krüptovõtmete veebipõhine varundus ei ole kasutusel"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Krüptovõtmete veebipõhine varundus on kasutusel"),
        "passphraseOrKey":
            MessageLookupByLibrary.simpleMessage("paroolifraas või taastevõti"),
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
            MessageLookupByLibrary.simpleMessage("Sessioon on verifitseeritud"),
        "sharedTheLocation": m52,
        "startedACall": m53,
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m55,
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Tundmatu sessioon, palun verifitseeri"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Sessiooni verifitseerimine õnnestus!"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Verifitseeri käsitsi"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Alusta verifitseerimist"),
        "verifySuccess": MessageLookupByLibrary.simpleMessage(
            "Verifitseerimine õnnestus sinul!"),
        "verifyTitle": MessageLookupByLibrary.simpleMessage(
            "Verifitseerin teist kasutajakontot"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Ootan, et teine osapool nõustuks päringuga..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Ootan teise osapoole kinnitust, et tegemist on samade emojidega..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Ootan teise osapoole kinnitust, et tegemist on samade numbritega...")
      };
}
