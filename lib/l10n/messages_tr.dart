// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a tr locale. All the
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
  String get localeName => 'tr';

  static m0(username) => "${username} katılma davetini kabul etti";

  static m1(username) => "${username} uçtan uca şifrelemeyi etkinleştirdi";

  static m2(senderName) => "${senderName} aramayı yanıtladı";

  static m3(username) =>
      "${username}\'den gelen doğrulama talebini kabul etmek istiyor musunuz?";

  static m4(username, targetName) => "${username} engelledi: ${targetName}";

  static m5(homeserver) =>
      "Varsayılan olarak ${homeserver} sunucusuna bağlanacaksınız";

  static m6(username) => "${username} sohbet resmini değiştirdi";

  static m7(username, description) =>
      "${username} sohbet açıklamasını değiştirdi: \'${description}\'";

  static m8(username, chatname) =>
      "${username} sohbet adını değiştirdi: \'${chatname}\'";

  static m9(username) => "${username} sohbet izinlerini değiştirdi";

  static m10(username, displayname) =>
      "${username} görünen adını ${displayname} olarak değiştirdi";

  static m11(username) => "${username} misafir erişim kurallarını değiştirdi";

  static m12(username, rules) =>
      "${username} misafir erişim kurallarını değiştirdi: ${rules}";

  static m13(username) => "${username} geçmiş görünürlüğünü değiştirdi";

  static m14(username, rules) =>
      "${username} geçmiş görünürlüğünü değiştirdi: ${rules}";

  static m15(username) => "${username} katılım kurallarını değiştirdi";

  static m16(username, joinRules) =>
      "${username} katılım kurallarını değiştirdi: ${joinRules}";

  static m17(username) => "${username} avatarını değiştirdi";

  static m18(username) => "";

  static m19(username) => "${username} davet bağlantısını değiştirdi";

  static m20(error) => "Mesajın şifresi çözülemedi: ${error}";

  static m21(count) => "${count} katılımcı";

  static m22(username) => "${username} sohbeti oluşturdu";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${day}/${month}/${year}";

  static m25(month, day) => "${day} ${month}";

  static m27(displayname) => "";

  static m28(username, targetName) => "";

  static m29(groupName) => "";

  static m30(username, link) => "";

  static m31(username, targetName) => "";

  static m32(username) => "${username} sohbete katıldı";

  static m33(username, targetName) => "";

  static m34(username, targetName) => "";

  static m35(localizedTimeShort) => "";

  static m36(count) => "";

  static m37(homeserver) => "";

  static m38(number) => "";

  static m39(fileName) => "";

  static m40(username) => "";

  static m41(username) => "${username} daveti reddetti";

  static m42(username) => "${username} tarafından kaldırıldı";

  static m43(username) => "${username} tarafından görüldü";

  static m44(username, count) =>
      "${username} ve ${count} diğerleri tarafından görüldü";

  static m45(username, username2) =>
      "${username} ve ${username2} tarafından görüldü";

  static m46(username) => "${username} bir dosya gönderdi";

  static m47(username) => "${username} bir resim gönderdi";

  static m48(username) => "${username} bir çıkartma gönderdi";

  static m49(username) => "${username} bir video gönderdi";

  static m50(username) => "${username} bir ses gönderdi";

  static m52(username) => "${username} konumu paylaştı";

  static m54(hours12, hours24, minutes, suffix) =>
      "${hours12}:${minutes} ${suffix}";

  static m55(username, targetName) =>
      "${username} engeli kaldırdı: ${targetName}";

  static m56(type) => "";

  static m57(unreadCount) => "${unreadCount} okunmamış sohbet";

  static m58(unreadEvents) => "${unreadEvents} okunmamış mesaj";

  static m59(unreadEvents, unreadChats) =>
      "${unreadChats} sohbetten ${unreadEvents} okunmamış mesaj";

  static m60(username, count) =>
      "${username} ve ${count} diğer kişi yazıyor...";

  static m61(username, username2) => "${username} ve ${username2} yazıyor...";

  static m62(username) => "${username} yazıyor...";

  static m63(username) => "${username} sohbetten ayrıldı";

  static m64(username, type) => "";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "(Optional) Group name":
            MessageLookupByLibrary.simpleMessage("(İsteğe bağlı) Grup adı"),
        "About": MessageLookupByLibrary.simpleMessage("Hakkında"),
        "Accept": MessageLookupByLibrary.simpleMessage("Kabul et"),
        "Account": MessageLookupByLibrary.simpleMessage("Hesap"),
        "Account informations":
            MessageLookupByLibrary.simpleMessage("Hesap bilgileri"),
        "Add a group description":
            MessageLookupByLibrary.simpleMessage("Grup açıklaması ekle"),
        "Admin": MessageLookupByLibrary.simpleMessage("Yönetici"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("Hesabınız var mı?"),
        "Anyone can join":
            MessageLookupByLibrary.simpleMessage("Herkes katılabilir"),
        "Archive": MessageLookupByLibrary.simpleMessage("Arşiv"),
        "Archived Room": MessageLookupByLibrary.simpleMessage("Arşiv Odası"),
        "Are guest users allowed to join": MessageLookupByLibrary.simpleMessage(
            "Misafir kullanıcıların katılmasına izin veriliyor mu"),
        "Are you sure?": MessageLookupByLibrary.simpleMessage("Emin misiniz?"),
        "Authentication": MessageLookupByLibrary.simpleMessage("Doğrulama"),
        "Avatar has been changed":
            MessageLookupByLibrary.simpleMessage("Avatar değiştirildi"),
        "Ban from chat":
            MessageLookupByLibrary.simpleMessage("Sohbetten engellendiniz"),
        "Banned": MessageLookupByLibrary.simpleMessage("Engellendi"),
        "Block Device": MessageLookupByLibrary.simpleMessage("Cihazı Engelle"),
        "Cancel": MessageLookupByLibrary.simpleMessage("İptal"),
        "Change the homeserver": MessageLookupByLibrary.simpleMessage(""),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("Grubun adını değiştir"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Sunucuyu değiştir"),
        "Change wallpaper":
            MessageLookupByLibrary.simpleMessage("Duvar kağıdını değiştir"),
        "Change your style":
            MessageLookupByLibrary.simpleMessage("Sitilinizi değiştirin"),
        "Changelog": MessageLookupByLibrary.simpleMessage("Değişiklikler"),
        "Chat": MessageLookupByLibrary.simpleMessage("Sohbet"),
        "Chat details":
            MessageLookupByLibrary.simpleMessage("Sohbet ayrıntıları"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("Güçlü bir parola seçin"),
        "Choose a username":
            MessageLookupByLibrary.simpleMessage("Bir kullanıcı adı seçin"),
        "Close": MessageLookupByLibrary.simpleMessage("Kapat"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Onayla"),
        "Connect": MessageLookupByLibrary.simpleMessage("Bağlan"),
        "Connection attempt failed": MessageLookupByLibrary.simpleMessage(
            "Bağlantı denemesi başarısız oldu"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage("Kişi gruba davet edildi"),
        "Content viewer": MessageLookupByLibrary.simpleMessage(""),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("Panoya kopyalandı"),
        "Copy": MessageLookupByLibrary.simpleMessage("Kopyala"),
        "Could not set avatar":
            MessageLookupByLibrary.simpleMessage("Avatar ayarlanamadı"),
        "Could not set displayname": MessageLookupByLibrary.simpleMessage(""),
        "Create": MessageLookupByLibrary.simpleMessage("Oluştur"),
        "Create account now":
            MessageLookupByLibrary.simpleMessage("Şimdi hesap oluştur"),
        "Create new group":
            MessageLookupByLibrary.simpleMessage("Yeni grup oluştur"),
        "Currently active": MessageLookupByLibrary.simpleMessage(""),
        "Dark": MessageLookupByLibrary.simpleMessage("Koyu"),
        "Delete": MessageLookupByLibrary.simpleMessage("Sil"),
        "Delete message": MessageLookupByLibrary.simpleMessage("Mesajı sil"),
        "Deny": MessageLookupByLibrary.simpleMessage(""),
        "Device": MessageLookupByLibrary.simpleMessage("Cihaz"),
        "Devices": MessageLookupByLibrary.simpleMessage("Cihazlar"),
        "Discard picture": MessageLookupByLibrary.simpleMessage(""),
        "Displayname has been changed":
            MessageLookupByLibrary.simpleMessage(""),
        "Donate": MessageLookupByLibrary.simpleMessage("Bağış"),
        "Download file": MessageLookupByLibrary.simpleMessage(""),
        "Edit Jitsi instance": MessageLookupByLibrary.simpleMessage(""),
        "Edit displayname": MessageLookupByLibrary.simpleMessage(""),
        "Emote Settings": MessageLookupByLibrary.simpleMessage(""),
        "Emote shortcode": MessageLookupByLibrary.simpleMessage(""),
        "Empty chat": MessageLookupByLibrary.simpleMessage(""),
        "Encryption": MessageLookupByLibrary.simpleMessage("Şifreleme"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Şifreleme algoritması"),
        "Encryption is not enabled": MessageLookupByLibrary.simpleMessage(""),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "Uçtan uca şifreleme şimdilik Beta aşamasında! Risk alarak kullanın!"),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "Uçtan uca şifreleme ayarları"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("Bir grup adı girin"),
        "Enter a username":
            MessageLookupByLibrary.simpleMessage("Bir kullanıcı adı girin"),
        "Enter your homeserver": MessageLookupByLibrary.simpleMessage(""),
        "File name": MessageLookupByLibrary.simpleMessage("Dosya adı"),
        "File size": MessageLookupByLibrary.simpleMessage("Dosya boyutu"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage(""),
        "Friday": MessageLookupByLibrary.simpleMessage("Cuma"),
        "From joining": MessageLookupByLibrary.simpleMessage(""),
        "From the invitation": MessageLookupByLibrary.simpleMessage(""),
        "Group": MessageLookupByLibrary.simpleMessage("Grup"),
        "Group description":
            MessageLookupByLibrary.simpleMessage("Grup açıklaması"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage(
                "Grup açıklaması değiştirildi"),
        "Group is public": MessageLookupByLibrary.simpleMessage(""),
        "Guests are forbidden": MessageLookupByLibrary.simpleMessage(""),
        "Guests can join":
            MessageLookupByLibrary.simpleMessage("Misafirler katılabilir"),
        "Help": MessageLookupByLibrary.simpleMessage("Yardım"),
        "Homeserver is not compatible":
            MessageLookupByLibrary.simpleMessage(""),
        "How are you today?":
            MessageLookupByLibrary.simpleMessage("Bugün nasılsınız?"),
        "ID": MessageLookupByLibrary.simpleMessage(""),
        "Identity": MessageLookupByLibrary.simpleMessage(""),
        "Invite contact": MessageLookupByLibrary.simpleMessage(""),
        "Invited": MessageLookupByLibrary.simpleMessage(""),
        "Invited users only": MessageLookupByLibrary.simpleMessage(
            "Sadece davet edilen kullanıcılar"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(""),
        "Kick from chat": MessageLookupByLibrary.simpleMessage(""),
        "Last seen IP": MessageLookupByLibrary.simpleMessage(""),
        "Leave": MessageLookupByLibrary.simpleMessage("Ayrıl"),
        "Left the chat": MessageLookupByLibrary.simpleMessage(""),
        "License": MessageLookupByLibrary.simpleMessage("Lisans"),
        "Light": MessageLookupByLibrary.simpleMessage("Açık"),
        "Load more...":
            MessageLookupByLibrary.simpleMessage("Daha fazla yükle..."),
        "Loading... Please wait": MessageLookupByLibrary.simpleMessage(
            "Yükleniyor... Lütfen bekleyin"),
        "Login": MessageLookupByLibrary.simpleMessage("Oturum aç"),
        "Logout": MessageLookupByLibrary.simpleMessage("Oturumu kapat"),
        "Make a moderator": MessageLookupByLibrary.simpleMessage(""),
        "Make an admin": MessageLookupByLibrary.simpleMessage(""),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(""),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(
                "Mesaj tüm katılımcılar için kaldırılacak"),
        "Moderator": MessageLookupByLibrary.simpleMessage(""),
        "Monday": MessageLookupByLibrary.simpleMessage("Pazartesi"),
        "Mute chat": MessageLookupByLibrary.simpleMessage(""),
        "New message in FluffyChat": MessageLookupByLibrary.simpleMessage(""),
        "New private chat": MessageLookupByLibrary.simpleMessage(""),
        "No emotes found. 😕": MessageLookupByLibrary.simpleMessage(""),
        "No permission": MessageLookupByLibrary.simpleMessage(""),
        "No rooms found...": MessageLookupByLibrary.simpleMessage(""),
        "None": MessageLookupByLibrary.simpleMessage(""),
        "Not supported in web": MessageLookupByLibrary.simpleMessage(""),
        "Oops something went wrong...":
            MessageLookupByLibrary.simpleMessage(""),
        "Open app to read messages": MessageLookupByLibrary.simpleMessage(
            "Mesajları okumak için uygulamayı aç"),
        "Open camera": MessageLookupByLibrary.simpleMessage("Kamerayı aç"),
        "Participating user devices": MessageLookupByLibrary.simpleMessage(""),
        "Password": MessageLookupByLibrary.simpleMessage("Parola"),
        "Pick image": MessageLookupByLibrary.simpleMessage(""),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(""),
        "Please choose a username": MessageLookupByLibrary.simpleMessage(
            "Lütfen bir kullanıcı adı seçin"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage(""),
        "Please enter your password":
            MessageLookupByLibrary.simpleMessage("Lütfen parolanızı girin"),
        "Please enter your username": MessageLookupByLibrary.simpleMessage(
            "Lütfen kullanıcı adınızı girin"),
        "Public Rooms": MessageLookupByLibrary.simpleMessage(""),
        "Recording": MessageLookupByLibrary.simpleMessage(""),
        "Reject": MessageLookupByLibrary.simpleMessage("Reddet"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Yeniden katıl"),
        "Remove": MessageLookupByLibrary.simpleMessage("Kaldır"),
        "Remove all other devices":
            MessageLookupByLibrary.simpleMessage("Diğer tüm cihazları kaldır"),
        "Remove device": MessageLookupByLibrary.simpleMessage("Cihazı kaldır"),
        "Remove exile": MessageLookupByLibrary.simpleMessage(""),
        "Remove message": MessageLookupByLibrary.simpleMessage("Mesajı kaldır"),
        "Render rich message content": MessageLookupByLibrary.simpleMessage(""),
        "Reply": MessageLookupByLibrary.simpleMessage(""),
        "Request permission": MessageLookupByLibrary.simpleMessage("İzin iste"),
        "Request to read older messages":
            MessageLookupByLibrary.simpleMessage("Eski mesajları okumayı iste"),
        "Revoke all permissions":
            MessageLookupByLibrary.simpleMessage("Tüm izinleri iptal et"),
        "Room has been upgraded": MessageLookupByLibrary.simpleMessage(""),
        "Saturday": MessageLookupByLibrary.simpleMessage("Cumartesi"),
        "Search for a chat": MessageLookupByLibrary.simpleMessage("Sohbet ara"),
        "Seen a long time ago":
            MessageLookupByLibrary.simpleMessage("Uzun zaman önce görüldü"),
        "Send": MessageLookupByLibrary.simpleMessage("Gönder"),
        "Send a message":
            MessageLookupByLibrary.simpleMessage("Bir mesaj gönder"),
        "Send file": MessageLookupByLibrary.simpleMessage("Dosya gönder"),
        "Send image": MessageLookupByLibrary.simpleMessage(""),
        "Set a profile picture":
            MessageLookupByLibrary.simpleMessage("Profil fotoğrafı ekleyin"),
        "Set group description":
            MessageLookupByLibrary.simpleMessage("Grup açıklaması ekleyin"),
        "Set invitation link":
            MessageLookupByLibrary.simpleMessage("Davet bağlantısı ayarlayın"),
        "Set status": MessageLookupByLibrary.simpleMessage("Durumu ayarla"),
        "Settings": MessageLookupByLibrary.simpleMessage("Ayarlar"),
        "Share": MessageLookupByLibrary.simpleMessage("Paylaş"),
        "Sign up": MessageLookupByLibrary.simpleMessage("Hesap oluştur"),
        "Skip": MessageLookupByLibrary.simpleMessage("Geç"),
        "Source code": MessageLookupByLibrary.simpleMessage("Kaynak kod"),
        "Start your first chat :-)":
            MessageLookupByLibrary.simpleMessage("İlk sohbetini başlat :-)"),
        "Submit": MessageLookupByLibrary.simpleMessage("Gönder"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Pazar"),
        "System": MessageLookupByLibrary.simpleMessage("Sistem"),
        "Tap to show menu":
            MessageLookupByLibrary.simpleMessage("Menüyü açmak için dokunun"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage(""),
        "They Don\'t Match":
            MessageLookupByLibrary.simpleMessage("Eşleşme yok"),
        "They Match": MessageLookupByLibrary.simpleMessage("Eşleştiler"),
        "This room has been archived.":
            MessageLookupByLibrary.simpleMessage("Bu sohbet arşivlendi."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Perşembe"),
        "Try to send again":
            MessageLookupByLibrary.simpleMessage("Tekrar göndermeyi deneyin"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("Salı"),
        "Unblock Device": MessageLookupByLibrary.simpleMessage(""),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Bilinmeyen cihaz"),
        "Unknown encryption algorithm": MessageLookupByLibrary.simpleMessage(
            "Bilinmeyen şifreleme algoritması"),
        "Unmute chat":
            MessageLookupByLibrary.simpleMessage("Sohbeti sessizden çıkart"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "Amolede uyumlu renkler kullanılsın mı?"),
        "Username": MessageLookupByLibrary.simpleMessage("Kullanıcı adı"),
        "Verify": MessageLookupByLibrary.simpleMessage("Doğrula"),
        "Verify User":
            MessageLookupByLibrary.simpleMessage("Kullanıcıyı Doğrula"),
        "Video call": MessageLookupByLibrary.simpleMessage("Video arama"),
        "Visibility of the chat history":
            MessageLookupByLibrary.simpleMessage("Sohbet geçmişi görünürlüğü"),
        "Visible for all participants": MessageLookupByLibrary.simpleMessage(
            "Tüm katılımcılar için görünür"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("Herkes için görünür"),
        "Voice message": MessageLookupByLibrary.simpleMessage("Sesli mesaj"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("Duvar kağıdı"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("Çarşamba"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "Matrix ağındaki en şirin anlık mesajlaşma uygulamasına hoş geldiniz."),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage("Bu gruba kimler katılabilir"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("Mesaj yazın..."),
        "Yes": MessageLookupByLibrary.simpleMessage("Evet"),
        "You": MessageLookupByLibrary.simpleMessage("Sen"),
        "You are invited to this chat":
            MessageLookupByLibrary.simpleMessage("Sohbete davet edildiniz"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(
                "Artık bu sohbette katılımcı değilsiniz"),
        "You cannot invite yourself":
            MessageLookupByLibrary.simpleMessage("Kendinizi davet edemezsiniz"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage("Bu sohbetten engellendiniz"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(""),
        "Your own username":
            MessageLookupByLibrary.simpleMessage("Kullanıcı adınız"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("takma ad"),
        "answeredTheCall": m2,
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Anahtarları önbelleğe almak için lütfen güvenli depolama parolanızı veya kurtarma anahtarınızı girin."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Diğer kişiyi imzalayabilmek için lütfen güvenli depolama parolanızı veya kurtarma anahtarınızı girin."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Lütfen oturumunuzu doğrulamak için güvenli depolama parolanızı veya kurtarma anahtarınızı girin."),
        "askVerificationRequest": m3,
        "bannedUser": m4,
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Anahtarlar başarıyla önbelleğe alındı!"),
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
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(""),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(""),
        "couldNotDecryptMessage": m20,
        "countParticipants": m21,
        "createdTheChat": m22,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(""),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(""),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "emoteExists": MessageLookupByLibrary.simpleMessage(""),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(""),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(""),
        "groupWith": m27,
        "hasWithdrawnTheInvitationFor": m28,
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(""),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invitedUser": m31,
        "is typing...": MessageLookupByLibrary.simpleMessage("yazıyor..."),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(""),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage(""),
        "keysMissing": MessageLookupByLibrary.simpleMessage(""),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "loadCountMoreParticipants": m36,
        "logInTo": m37,
        "newVerificationRequest": MessageLookupByLibrary.simpleMessage(""),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(""),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(""),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage(""),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(""),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(""),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(""),
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
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Oturum doğrulandı"),
        "sharedTheLocation": m52,
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m55,
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Bilinmeyen oturum, lütfen doğrulayın"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Oturum başarıyla doğrulandı!"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Manuel Olarak Doğrula"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Doğrulamayı Başlat"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Başarıyla doğrulandı!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Diğer hesap doğrulanıyor"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "İsteği kabul etmesi bekleniyor..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Emojiyi kabul etmesi bekleniyor..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage("")
      };
}
