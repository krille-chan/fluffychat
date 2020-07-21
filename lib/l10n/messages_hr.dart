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

  static m60(username) =>
      "Prihvatiti ovaj zahtjev za potvrđivanje od ${username}?";

  static m2(username, targetName) =>
      "${username} je isključio/la ${targetName}";

  static m3(homeserver) => "Standardno ćeš biti povezan/a s ${homeserver}";

  static m4(username) => "${username} je promijenio/la avatar chata";

  static m5(username, description) =>
      "${username} je promijenio/la opis chata u: „${description}”";

  static m6(username, chatname) =>
      "${username} je promijenio/la ime chata u: „${chatname}”";

  static m7(username) => "${username} je promijenio/la dozvole chata";

  static m8(username, displayname) =>
      "${username} je promijenio/la prikazano ime u: ${displayname}";

  static m9(username) =>
      "${username} je promijenio/la pravila pristupa za goste";

  static m10(username, rules) =>
      "${username} je promijenio/la pravila pristupa za goste u: ${rules}";

  static m11(username) => "${username} je promijenio/la vidljivost kronologije";

  static m12(username, rules) =>
      "${username} je promijenio/la vidljivost kronologije u: ${rules}";

  static m13(username) => "${username} je promijenio/la pravila pridruživanja";

  static m14(username, joinRules) =>
      "${username} je promijenio/la pravila pridruživanja u: ${joinRules}";

  static m15(username) => "${username} je promijenio/la avatar profila";

  static m16(username) => "${username} je promijenio/la pseudonime soba";

  static m17(username) => "${username} je promijenio/la poveznicu poziva";

  static m18(error) => "Neuspjelo dešifriranje poruke: ${error}";

  static m19(count) => "${count} sudionika";

  static m20(username) => "${username} je stvorio/la chat";

  static m21(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m22(year, month, day) => "${day}. ${month}. ${year}.";

  static m23(month, day) => "${day}. ${month}.";

  static m24(displayname) => "Grupa s ${displayname}";

  static m25(username, targetName) =>
      "${username} je povukao/la poziv za ${targetName}";

  static m26(groupName) => "Pozovi kontakt u ${groupName}";

  static m27(username, link) =>
      "${username} te je pozvao/la u FluffyChat. \n1. Instaliraj FluffyChat: http://fluffy.chat \n2. Registriraj ili prijavi se \n3. Otvori poveznicu poziva: ${link}";

  static m28(username, targetName) => "${username} je pozvao/la ${targetName}";

  static m29(username) => "${username} se pridružio/la chatu";

  static m30(username, targetName) => "${username} je izbacio/la ${targetName}";

  static m31(username, targetName) =>
      "${username} je izbacio/la i isključio/la ${targetName}";

  static m32(localizedTimeShort) => "Zadnja aktivnost: ${localizedTimeShort}";

  static m33(count) => "Učitaj još ${count} sudionika";

  static m34(homeserver) => "Prijavi se na ${homeserver}";

  static m35(number) => "${number} odabrano";

  static m36(fileName) => "Sviraj ${fileName}";

  static m37(username) => "${username} je preuredio/la događaj";

  static m38(username) => "${username} je odbio/la poziv";

  static m39(username) => "Uklonjeno od ${username}";

  static m40(username) => "Viđeno od ${username}";

  static m41(username, count) =>
      "Viđeno od ${username} i još ${count} korisnika";

  static m42(username, username2) => "Viđeno od ${username} i ${username2}";

  static m43(username) => "${username} ja poslao/la datoteku";

  static m44(username) => "${username} ja poslao/la sliku";

  static m45(username) => "${username} je poslao/la naljepnicu";

  static m46(username) => "${username} ja poslao/la video";

  static m47(username) => "${username} ja poslao/la audio";

  static m48(username) => "${username} je dijelio/la mjesto";

  static m49(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m50(username, targetName) =>
      "${username} je ponovo uključio/la ${targetName}";

  static m51(type) => "Nepoznata vrsta događaja „${type}”";

  static m52(unreadCount) => "${unreadCount} nepročitana chata";

  static m53(unreadEvents) => "${unreadEvents} nepročitane poruke";

  static m54(unreadEvents, unreadChats) =>
      "${unreadEvents} nepročitane poruke u ${unreadChats} chata";

  static m55(username, count) => "${username} i još ${count} korisnika pišu …";

  static m56(username, username2) => "${username} i ${username2} pišu …";

  static m57(username) => "${username} piše …";

  static m58(username) => "${username} je napustio/la chat";

  static m59(username, type) => "${username} ja poslao/la ${type} događaj";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "(Optional) Group name":
            MessageLookupByLibrary.simpleMessage("(Opcionalno) Ime grupe"),
        "About": MessageLookupByLibrary.simpleMessage("Informacije"),
        "Accept": MessageLookupByLibrary.simpleMessage("Prihvati"),
        "Account": MessageLookupByLibrary.simpleMessage("Račun"),
        "Account informations":
            MessageLookupByLibrary.simpleMessage("Podaci računa"),
        "Add a group description":
            MessageLookupByLibrary.simpleMessage("Dodaj opis grupe"),
        "Admin": MessageLookupByLibrary.simpleMessage("Administrator"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("Već imaš račun?"),
        "Anyone can join":
            MessageLookupByLibrary.simpleMessage("Svatko se može pridružiti"),
        "Archive": MessageLookupByLibrary.simpleMessage("Arhiva"),
        "Archived Room":
            MessageLookupByLibrary.simpleMessage("Arhivirana soba"),
        "Are guest users allowed to join": MessageLookupByLibrary.simpleMessage(
            "Smiju li se gosti pridružiti grupi"),
        "Are you sure?": MessageLookupByLibrary.simpleMessage("Sigurno?"),
        "Authentication":
            MessageLookupByLibrary.simpleMessage("Autentifikacija"),
        "Avatar has been changed":
            MessageLookupByLibrary.simpleMessage("Avatar je promijenjen"),
        "Ban from chat":
            MessageLookupByLibrary.simpleMessage("Isključi iz chata"),
        "Banned": MessageLookupByLibrary.simpleMessage("Isključen"),
        "Block Device": MessageLookupByLibrary.simpleMessage("Blokiraj uređaj"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Odustani"),
        "Change the homeserver": MessageLookupByLibrary.simpleMessage(
            "Promijeni domaćeg poslužitelja"),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("Promijeni ime grupe"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Promijeni poslužitelja"),
        "Change wallpaper":
            MessageLookupByLibrary.simpleMessage("Promijeni sliku pozadine"),
        "Change your style":
            MessageLookupByLibrary.simpleMessage("Promijeni svoj stil"),
        "Changelog": MessageLookupByLibrary.simpleMessage("Zapis promjena"),
        "Chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "Chat details": MessageLookupByLibrary.simpleMessage("Detalji chata"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("Odaberi snažnu lozinku"),
        "Choose a username":
            MessageLookupByLibrary.simpleMessage("Odaberi korisničko ime"),
        "Close": MessageLookupByLibrary.simpleMessage("Zatvori"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Potvrdi"),
        "Connect": MessageLookupByLibrary.simpleMessage("Spoji"),
        "Connection attempt failed":
            MessageLookupByLibrary.simpleMessage("Neuspio pokušaj povezivanja"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage("Kontakt je pozvan u grupu"),
        "Content viewer":
            MessageLookupByLibrary.simpleMessage("Prikazivač sadržaja"),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("Kopirano u međuspremnik"),
        "Copy": MessageLookupByLibrary.simpleMessage("Kopiraj"),
        "Could not set avatar": MessageLookupByLibrary.simpleMessage(
            "Neuspjelo postavljanje avatara"),
        "Could not set displayname": MessageLookupByLibrary.simpleMessage(
            "Neuspjelo postavljanje prikaznog imena"),
        "Create": MessageLookupByLibrary.simpleMessage("Stvori"),
        "Create account now":
            MessageLookupByLibrary.simpleMessage("Stvori račun sada"),
        "Create new group":
            MessageLookupByLibrary.simpleMessage("Stvori novu grupu"),
        "Currently active":
            MessageLookupByLibrary.simpleMessage("Trenutačno aktivni"),
        "Dark": MessageLookupByLibrary.simpleMessage("Tamna"),
        "Delete": MessageLookupByLibrary.simpleMessage("Izbriži"),
        "Delete message":
            MessageLookupByLibrary.simpleMessage("Izbriži poruku"),
        "Deny": MessageLookupByLibrary.simpleMessage("Odbij"),
        "Device": MessageLookupByLibrary.simpleMessage("Uređaj"),
        "Devices": MessageLookupByLibrary.simpleMessage("Uređaji"),
        "Discard picture": MessageLookupByLibrary.simpleMessage("Odbaci sliku"),
        "Displayname has been changed": MessageLookupByLibrary.simpleMessage(
            "Prikazno ime je promijenjeno"),
        "Donate": MessageLookupByLibrary.simpleMessage("Doniraj"),
        "Download file":
            MessageLookupByLibrary.simpleMessage("Preuzmi datoteku"),
        "Edit Jitsi instance":
            MessageLookupByLibrary.simpleMessage("Uredi Jitsi primjerak"),
        "Edit displayname":
            MessageLookupByLibrary.simpleMessage("Uredi prikazano ime"),
        "Emote Settings":
            MessageLookupByLibrary.simpleMessage("Postavke emojija"),
        "Emote shortcode":
            MessageLookupByLibrary.simpleMessage("Kratica emota"),
        "Empty chat": MessageLookupByLibrary.simpleMessage("Prazan chat"),
        "Encryption": MessageLookupByLibrary.simpleMessage("Šifriranje"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Algoritam šifriranja"),
        "Encryption is not enabled":
            MessageLookupByLibrary.simpleMessage("Šifriranje nije aktivirano"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "Obostrano šifriranje je trenutačno u beta stanju! Koriti na vlastitu odgovornost!"),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "Postavke obostranog šifriranja"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("Upiši ime grupe"),
        "Enter a username":
            MessageLookupByLibrary.simpleMessage("Upiši korisničko ime"),
        "Enter your homeserver": MessageLookupByLibrary.simpleMessage(
            "Upiši svog domaćeg poslužitelja"),
        "File name": MessageLookupByLibrary.simpleMessage("Ime datoteke"),
        "File size": MessageLookupByLibrary.simpleMessage("Veličina datoteke"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("Proslijedi"),
        "Friday": MessageLookupByLibrary.simpleMessage("Petak"),
        "From joining":
            MessageLookupByLibrary.simpleMessage("Od pridruživanja"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("Od poziva"),
        "Group": MessageLookupByLibrary.simpleMessage("Grupiraj"),
        "Group description": MessageLookupByLibrary.simpleMessage("Opis grupe"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage("Opis grupe je promijenjen"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("Grupa je javna"),
        "Guests are forbidden":
            MessageLookupByLibrary.simpleMessage("Gosti su zabranjeni"),
        "Guests can join":
            MessageLookupByLibrary.simpleMessage("Gosti se mogu pridružiti"),
        "Help": MessageLookupByLibrary.simpleMessage("Pomoć"),
        "Homeserver is not compatible": MessageLookupByLibrary.simpleMessage(
            "Domaći poslužitelj nije kompatibilan"),
        "How are you today?":
            MessageLookupByLibrary.simpleMessage("Kako si danas?"),
        "ID": MessageLookupByLibrary.simpleMessage("ID"),
        "Identity": MessageLookupByLibrary.simpleMessage("Identitet"),
        "Invite contact":
            MessageLookupByLibrary.simpleMessage("Pozovi kontakt"),
        "Invited": MessageLookupByLibrary.simpleMessage("Pozvan/a"),
        "Invited users only":
            MessageLookupByLibrary.simpleMessage("Samo pozvani korisnici"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(
                "Čini se da na mobitelu nemaš google usluge. To je dobra odluka za tvoju privatnost! Za primanje push obavijesti u FluffyChatu preporučujemo upotrebu microG-a: https://microg.org/"),
        "Kick from chat":
            MessageLookupByLibrary.simpleMessage("Izbaci iz chata"),
        "Last seen IP":
            MessageLookupByLibrary.simpleMessage("Zadnji viđeni IP"),
        "Leave": MessageLookupByLibrary.simpleMessage("Napusti"),
        "Left the chat":
            MessageLookupByLibrary.simpleMessage("Napustio/la je chat"),
        "License": MessageLookupByLibrary.simpleMessage("Licenca"),
        "Light": MessageLookupByLibrary.simpleMessage("Svjetla"),
        "Load more...": MessageLookupByLibrary.simpleMessage("Učitaj više …"),
        "Loading... Please wait":
            MessageLookupByLibrary.simpleMessage("Učitava se … Pričekaj"),
        "Login": MessageLookupByLibrary.simpleMessage("Prijava"),
        "Logout": MessageLookupByLibrary.simpleMessage("Odjava"),
        "Make a moderator":
            MessageLookupByLibrary.simpleMessage("Postavi kao voditelja"),
        "Make an admin":
            MessageLookupByLibrary.simpleMessage("Postavi kao administratora"),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(
                "Provjeri je li identifikator ispravan"),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(
                "Poruke će se ukloniti za sve sudionike"),
        "Moderator": MessageLookupByLibrary.simpleMessage("Voditelj"),
        "Monday": MessageLookupByLibrary.simpleMessage("Ponedjeljak"),
        "Mute chat":
            MessageLookupByLibrary.simpleMessage("Isključi zvuk chata"),
        "New message in FluffyChat":
            MessageLookupByLibrary.simpleMessage("Nova poruka u FluffyChatu"),
        "New private chat":
            MessageLookupByLibrary.simpleMessage("Novi privatni chat"),
        "No emotes found. 😕":
            MessageLookupByLibrary.simpleMessage("Nema emota. 😕"),
        "No permission": MessageLookupByLibrary.simpleMessage("Bez dozvole"),
        "No rooms found...":
            MessageLookupByLibrary.simpleMessage("Nema pronađenih soba …"),
        "None": MessageLookupByLibrary.simpleMessage("Ništa"),
        "Not supported in web":
            MessageLookupByLibrary.simpleMessage("Nije podržano u internetu"),
        "Oops something went wrong...": MessageLookupByLibrary.simpleMessage(
            "Ups, došlo je do neke greške …"),
        "Open app to read messages": MessageLookupByLibrary.simpleMessage(
            "Za čitanje poruka, otvori program"),
        "Open camera": MessageLookupByLibrary.simpleMessage("Otvori kameru"),
        "Participating user devices": MessageLookupByLibrary.simpleMessage(
            "Sudjelujući korisnički uređaji"),
        "Password": MessageLookupByLibrary.simpleMessage("Lozinka"),
        "Pick image": MessageLookupByLibrary.simpleMessage("Odaberi sliku"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(
                "Za sada trebaš Pantalaimon za obostrano šifriranje."),
        "Please choose a username":
            MessageLookupByLibrary.simpleMessage("Odaberi korisničko ime"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage("Upiši identifikator matrice"),
        "Please enter your password":
            MessageLookupByLibrary.simpleMessage("Upiši svoju lozinku"),
        "Please enter your username":
            MessageLookupByLibrary.simpleMessage("Upiši svoje korisničko ime"),
        "Public Rooms": MessageLookupByLibrary.simpleMessage("Javne sobe"),
        "Recording": MessageLookupByLibrary.simpleMessage("Snimanje"),
        "Reject": MessageLookupByLibrary.simpleMessage("Odbij"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Ponovo se pridruži"),
        "Remove": MessageLookupByLibrary.simpleMessage("Ukloni"),
        "Remove all other devices":
            MessageLookupByLibrary.simpleMessage("Ukloni sve druge uređaje"),
        "Remove device": MessageLookupByLibrary.simpleMessage("Ukloni uređaj"),
        "Remove exile":
            MessageLookupByLibrary.simpleMessage("Ukloni izbacivanje"),
        "Remove message": MessageLookupByLibrary.simpleMessage("Ukloni poruku"),
        "Render rich message content": MessageLookupByLibrary.simpleMessage(
            "Prikaži formatirani sadržaj poruke"),
        "Reply": MessageLookupByLibrary.simpleMessage("Odgovori"),
        "Request permission":
            MessageLookupByLibrary.simpleMessage("Zatraži dozvolu"),
        "Request to read older messages": MessageLookupByLibrary.simpleMessage(
            "Zahtjev za čitanje starijih poruka"),
        "Revoke all permissions":
            MessageLookupByLibrary.simpleMessage("Opozovi sve dozvole"),
        "Room has been upgraded":
            MessageLookupByLibrary.simpleMessage("Ova soba je nadograđena"),
        "Saturday": MessageLookupByLibrary.simpleMessage("Subota"),
        "Search for a chat": MessageLookupByLibrary.simpleMessage("Traži chat"),
        "Seen a long time ago":
            MessageLookupByLibrary.simpleMessage("Viđeno prije dugo vremena"),
        "Send": MessageLookupByLibrary.simpleMessage("Pošalji"),
        "Send a message":
            MessageLookupByLibrary.simpleMessage("Pošalji poruku"),
        "Send file": MessageLookupByLibrary.simpleMessage("Pošalji datoteku"),
        "Send image": MessageLookupByLibrary.simpleMessage("Pošalji sliku"),
        "Set a profile picture":
            MessageLookupByLibrary.simpleMessage("Postavi sliku profila"),
        "Set group description":
            MessageLookupByLibrary.simpleMessage("Postavi opis grupe"),
        "Set invitation link": MessageLookupByLibrary.simpleMessage(
            "Pošalji poveznicu za pozivnicu"),
        "Set status": MessageLookupByLibrary.simpleMessage("Postavi stanje"),
        "Settings": MessageLookupByLibrary.simpleMessage("Postavke"),
        "Share": MessageLookupByLibrary.simpleMessage("Dijeli"),
        "Sign up": MessageLookupByLibrary.simpleMessage("Prijavi se"),
        "Skip": MessageLookupByLibrary.simpleMessage("Preskoči"),
        "Source code": MessageLookupByLibrary.simpleMessage("Izvorni kȏd"),
        "Start your first chat :-)":
            MessageLookupByLibrary.simpleMessage("Počni svoj prvi chat :-)"),
        "Submit": MessageLookupByLibrary.simpleMessage("Pošalji"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Nedjelja"),
        "System": MessageLookupByLibrary.simpleMessage("Sustav"),
        "Tap to show menu":
            MessageLookupByLibrary.simpleMessage("Dodirni za prikaz izbornika"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage("Šifriranje je oštećeno"),
        "They Don\'t Match":
            MessageLookupByLibrary.simpleMessage("Ne poklapaju se"),
        "They Match": MessageLookupByLibrary.simpleMessage("Poklapaju se"),
        "This room has been archived.":
            MessageLookupByLibrary.simpleMessage("Ova soba je arhivirana."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Četvrtak"),
        "Try to send again":
            MessageLookupByLibrary.simpleMessage("Pokušaj ponovo poslati"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("Utorak"),
        "Unblock Device":
            MessageLookupByLibrary.simpleMessage("Deblokiraj uređaj"),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Nepoznat uređaj"),
        "Unknown encryption algorithm": MessageLookupByLibrary.simpleMessage(
            "Nepoznat algoritam šifriranja"),
        "Unmute chat":
            MessageLookupByLibrary.simpleMessage("Uključi zvuk chata"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "Koristiti Amoled kompatibilne boje?"),
        "Username": MessageLookupByLibrary.simpleMessage("Korisničko ime"),
        "Verify": MessageLookupByLibrary.simpleMessage("Provjeri"),
        "Verify User":
            MessageLookupByLibrary.simpleMessage("Provjeri korisnika"),
        "Video call": MessageLookupByLibrary.simpleMessage("Video poziv"),
        "Visibility of the chat history": MessageLookupByLibrary.simpleMessage(
            "Vidljivost kronologije chata"),
        "Visible for all participants":
            MessageLookupByLibrary.simpleMessage("Vidljivo za sve sudionike"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("Vidljivo za sve"),
        "Voice message":
            MessageLookupByLibrary.simpleMessage("Glasovna poruka"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("Slika pozadine"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("Srijeda"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "Lijep pozdrav u najslađi program za čavrljanje u matrix-mreži."),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage(
                "Tko se smije pridružiti grupi"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("Napiši poruku …"),
        "Yes": MessageLookupByLibrary.simpleMessage("Da"),
        "You": MessageLookupByLibrary.simpleMessage("Ti"),
        "You are invited to this chat":
            MessageLookupByLibrary.simpleMessage("Pozvan/a si u ovaj chat"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(
                "Više ne sudjeluješ u ovom chatu"),
        "You cannot invite yourself":
            MessageLookupByLibrary.simpleMessage("Sebe ne možeš pozvati"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage(
                "Isključen/a si iz ovog chata"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "Više nećeš moći deaktivirati šifriranje. Sigurno?"),
        "Your own username":
            MessageLookupByLibrary.simpleMessage("Tvoje korisničko ime"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("pseudonim"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Upiši svoju sigurnosnu lozinku ili ključ za obnavljanje, kako bi se ključevi spremili u predmemoriju."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Za potpisivanje druge osobe, upiši svoju sigurnosnu lozinku ili ključ za obnavljanje."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Za potvrđivanje tvoje sesije, upiši svoju sigurnosnu lozinku ili ključ za obnavljanje."),
        "askVerificationRequest": m60,
        "bannedUser": m2,
        "byDefaultYouWillBeConnectedTo": m3,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Uspješno međuspremljeni ključevi!"),
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
            "Usporedi i provjeri, poklapaju li se sljedeći emojiji s onima drugog uređaja:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Usporedi i provjeri, poklapaju li se sljedeći brojevi s onima drugog uređaja:"),
        "couldNotDecryptMessage": m18,
        "countParticipants": m19,
        "createdTheChat": m20,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(
            "Unakrsno potpisivanje je deaktivirano"),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(
            "Unakrsno potpisivanje je aktivirano"),
        "dateAndTimeOfDay": m21,
        "dateWithYear": m22,
        "dateWithoutYear": m23,
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Emot već postoji!"),
        "emoteInvalid":
            MessageLookupByLibrary.simpleMessage("Neispravna kratica emota!"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Moraš odabrati jednu kraticu emota i sliku!"),
        "groupWith": m24,
        "hasWithdrawnTheInvitationFor": m25,
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Neispravna lozinka ili ključ za obnavljanje"),
        "inviteContactToGroup": m26,
        "inviteText": m27,
        "invitedUser": m28,
        "is typing...": MessageLookupByLibrary.simpleMessage("piše …"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Je li sljedeći ključ uređaja ispravan?"),
        "joinedTheChat": m29,
        "keysCached": MessageLookupByLibrary.simpleMessage(
            "Ključevi su spremljeni u predmemoriji"),
        "keysMissing":
            MessageLookupByLibrary.simpleMessage("Nedostaju ključevi"),
        "kicked": m30,
        "kickedAndBanned": m31,
        "lastActiveAgo": m32,
        "loadCountMoreParticipants": m33,
        "logInTo": m34,
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("Novi zahtjev za provjeru!"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat trenutačno ne podržava unakrsno potpisivanje. Aktiviraj je pomoću Element-a."),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat trenutačno ne podržava online sigurnosnu kopiju ključeva. Aktiviraj je pomoću Element-a."),
        "numberSelected": m35,
        "ok": MessageLookupByLibrary.simpleMessage("u redu"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Online sigurnosna kopija ključeva je deaktivirana"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Online sigurnosna kopija ključeva je aktivirana"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Lozinka ili ključ za obnavljanje"),
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
            MessageLookupByLibrary.simpleMessage("Sesija je provjerena"),
        "sharedTheLocation": m48,
        "timeOfDay": m49,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m50,
        "unknownEvent": m51,
        "unknownSessionVerify":
            MessageLookupByLibrary.simpleMessage("Nepoznata sesija, provjeri"),
        "unreadChats": m52,
        "unreadMessages": m53,
        "unreadMessagesInChats": m54,
        "userAndOthersAreTyping": m55,
        "userAndUserAreTyping": m56,
        "userIsTyping": m57,
        "userLeftTheChat": m58,
        "userSentUnknownEvent": m59,
        "verifiedSession":
            MessageLookupByLibrary.simpleMessage("Uspješno provjerena sesija!"),
        "verifyManual": MessageLookupByLibrary.simpleMessage("Provjeri ručno"),
        "verifyStart": MessageLookupByLibrary.simpleMessage("Pokreni provjeru"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Uspješno si provjerio/la!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Provjeravanje drugog računa"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "Čekanje na partnera, da prihvati zahtjeva …"),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Čekanje na partnera, da prihvati emoji …"),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "Čekanje na partnera, da prihvati brojeve …")
      };
}
