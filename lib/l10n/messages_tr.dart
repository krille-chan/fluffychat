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
        "about": MessageLookupByLibrary.simpleMessage("Hakkında"),
        "accept": MessageLookupByLibrary.simpleMessage("Kabul et"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Hesap"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Hesap bilgileri"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription":
            MessageLookupByLibrary.simpleMessage("Grup açıklaması ekle"),
        "admin": MessageLookupByLibrary.simpleMessage("Yönetici"),
        "alias": MessageLookupByLibrary.simpleMessage("takma ad"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Hesabınız var mı?"),
        "answeredTheCall": m2,
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("Herkes katılabilir"),
        "archive": MessageLookupByLibrary.simpleMessage("Arşiv"),
        "archivedRoom": MessageLookupByLibrary.simpleMessage("Arşiv Odası"),
        "areGuestsAllowedToJoin": MessageLookupByLibrary.simpleMessage(
            "Misafir kullanıcıların katılmasına izin veriliyor mu"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Emin misiniz?"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Anahtarları önbelleğe almak için lütfen güvenli depolama parolanızı veya kurtarma anahtarınızı girin."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Diğer kişiyi imzalayabilmek için lütfen güvenli depolama parolanızı veya kurtarma anahtarınızı girin."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Lütfen oturumunuzu doğrulamak için güvenli depolama parolanızı veya kurtarma anahtarınızı girin."),
        "askVerificationRequest": m3,
        "authentication": MessageLookupByLibrary.simpleMessage("Doğrulama"),
        "avatarHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Avatar değiştirildi"),
        "banFromChat":
            MessageLookupByLibrary.simpleMessage("Sohbetten engellendiniz"),
        "banned": MessageLookupByLibrary.simpleMessage("Engellendi"),
        "bannedUser": m4,
        "blockDevice": MessageLookupByLibrary.simpleMessage("Cihazı Engelle"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Anahtarlar başarıyla önbelleğe alındı!"),
        "cancel": MessageLookupByLibrary.simpleMessage("İptal"),
        "changeTheHomeserver": MessageLookupByLibrary.simpleMessage(""),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("Grubun adını değiştir"),
        "changeTheServer":
            MessageLookupByLibrary.simpleMessage("Sunucuyu değiştir"),
        "changeTheme":
            MessageLookupByLibrary.simpleMessage("Sitilinizi değiştirin"),
        "changeWallpaper":
            MessageLookupByLibrary.simpleMessage("Duvar kağıdını değiştir"),
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
        "changelog": MessageLookupByLibrary.simpleMessage("Değişiklikler"),
        "channelCorruptedDecryptError":
            MessageLookupByLibrary.simpleMessage(""),
        "chat": MessageLookupByLibrary.simpleMessage("Sohbet"),
        "chatDetails":
            MessageLookupByLibrary.simpleMessage("Sohbet ayrıntıları"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("Güçlü bir parola seçin"),
        "chooseAUsername":
            MessageLookupByLibrary.simpleMessage("Bir kullanıcı adı seçin"),
        "close": MessageLookupByLibrary.simpleMessage("Kapat"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(""),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(""),
        "confirm": MessageLookupByLibrary.simpleMessage("Onayla"),
        "connect": MessageLookupByLibrary.simpleMessage("Bağlan"),
        "connectionAttemptFailed": MessageLookupByLibrary.simpleMessage(
            "Bağlantı denemesi başarısız oldu"),
        "contactHasBeenInvitedToTheGroup":
            MessageLookupByLibrary.simpleMessage("Kişi gruba davet edildi"),
        "contentViewer": MessageLookupByLibrary.simpleMessage(""),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Panoya kopyalandı"),
        "copy": MessageLookupByLibrary.simpleMessage("Kopyala"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar":
            MessageLookupByLibrary.simpleMessage("Avatar ayarlanamadı"),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(""),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Oluştur"),
        "createAccountNow":
            MessageLookupByLibrary.simpleMessage("Şimdi hesap oluştur"),
        "createNewGroup":
            MessageLookupByLibrary.simpleMessage("Yeni grup oluştur"),
        "createdTheChat": m22,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(""),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(""),
        "currentlyActive": MessageLookupByLibrary.simpleMessage(""),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Koyu"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "delete": MessageLookupByLibrary.simpleMessage("Sil"),
        "deleteMessage": MessageLookupByLibrary.simpleMessage("Mesajı sil"),
        "deny": MessageLookupByLibrary.simpleMessage(""),
        "device": MessageLookupByLibrary.simpleMessage("Cihaz"),
        "devices": MessageLookupByLibrary.simpleMessage("Cihazlar"),
        "discardPicture": MessageLookupByLibrary.simpleMessage(""),
        "displaynameHasBeenChanged": MessageLookupByLibrary.simpleMessage(""),
        "donate": MessageLookupByLibrary.simpleMessage("Bağış"),
        "downloadFile": MessageLookupByLibrary.simpleMessage(""),
        "editDisplayname": MessageLookupByLibrary.simpleMessage(""),
        "editJitsiInstance": MessageLookupByLibrary.simpleMessage(""),
        "emoteExists": MessageLookupByLibrary.simpleMessage(""),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(""),
        "emoteSettings": MessageLookupByLibrary.simpleMessage(""),
        "emoteShortcode": MessageLookupByLibrary.simpleMessage(""),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(""),
        "emptyChat": MessageLookupByLibrary.simpleMessage(""),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(""),
        "encryption": MessageLookupByLibrary.simpleMessage("Şifreleme"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Şifreleme algoritması"),
        "encryptionNotEnabled": MessageLookupByLibrary.simpleMessage(""),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "Uçtan uca şifreleme ayarları"),
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("Bir grup adı girin"),
        "enterAUsername":
            MessageLookupByLibrary.simpleMessage("Bir kullanıcı adı girin"),
        "enterYourHomeserver": MessageLookupByLibrary.simpleMessage(""),
        "fileName": MessageLookupByLibrary.simpleMessage("Dosya adı"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Dosya boyutu"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage(""),
        "friday": MessageLookupByLibrary.simpleMessage("Cuma"),
        "fromJoining": MessageLookupByLibrary.simpleMessage(""),
        "fromTheInvitation": MessageLookupByLibrary.simpleMessage(""),
        "group": MessageLookupByLibrary.simpleMessage("Grup"),
        "groupDescription":
            MessageLookupByLibrary.simpleMessage("Grup açıklaması"),
        "groupDescriptionHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "Grup açıklaması değiştirildi"),
        "groupIsPublic": MessageLookupByLibrary.simpleMessage(""),
        "groupWith": m27,
        "guestsAreForbidden": MessageLookupByLibrary.simpleMessage(""),
        "guestsCanJoin":
            MessageLookupByLibrary.simpleMessage("Misafirler katılabilir"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Yardım"),
        "homeserverIsNotCompatible": MessageLookupByLibrary.simpleMessage(""),
        "id": MessageLookupByLibrary.simpleMessage(""),
        "identity": MessageLookupByLibrary.simpleMessage(""),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(""),
        "inviteContact": MessageLookupByLibrary.simpleMessage(""),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage(""),
        "invitedUser": m31,
        "invitedUsersOnly": MessageLookupByLibrary.simpleMessage(
            "Sadece davet edilen kullanıcılar"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(""),
        "isTyping": MessageLookupByLibrary.simpleMessage("yazıyor..."),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage(""),
        "keysMissing": MessageLookupByLibrary.simpleMessage(""),
        "kickFromChat": MessageLookupByLibrary.simpleMessage(""),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp": MessageLookupByLibrary.simpleMessage(""),
        "lastSeenLongTimeAgo":
            MessageLookupByLibrary.simpleMessage("Uzun zaman önce görüldü"),
        "leave": MessageLookupByLibrary.simpleMessage("Ayrıl"),
        "leftTheChat": MessageLookupByLibrary.simpleMessage(""),
        "license": MessageLookupByLibrary.simpleMessage("Lisans"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Açık"),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage("Daha fazla yükle..."),
        "loadingPleaseWait": MessageLookupByLibrary.simpleMessage(
            "Yükleniyor... Lütfen bekleyin"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("Oturum aç"),
        "logout": MessageLookupByLibrary.simpleMessage("Oturumu kapat"),
        "makeAModerator": MessageLookupByLibrary.simpleMessage(""),
        "makeAnAdmin": MessageLookupByLibrary.simpleMessage(""),
        "makeSureTheIdentifierIsValid":
            MessageLookupByLibrary.simpleMessage(""),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "Mesaj tüm katılımcılar için kaldırılacak"),
        "moderator": MessageLookupByLibrary.simpleMessage(""),
        "monday": MessageLookupByLibrary.simpleMessage("Pazartesi"),
        "muteChat": MessageLookupByLibrary.simpleMessage(""),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(""),
        "newMessageInFluffyChat": MessageLookupByLibrary.simpleMessage(""),
        "newPrivateChat": MessageLookupByLibrary.simpleMessage(""),
        "newVerificationRequest": MessageLookupByLibrary.simpleMessage(""),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(""),
        "noEmotesFound": MessageLookupByLibrary.simpleMessage(""),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(""),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(""),
        "noPermission": MessageLookupByLibrary.simpleMessage(""),
        "noRoomsFound": MessageLookupByLibrary.simpleMessage(""),
        "none": MessageLookupByLibrary.simpleMessage(""),
        "notSupportedInWeb": MessageLookupByLibrary.simpleMessage(""),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage(""),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(""),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(""),
        "oopsSomethingWentWrong": MessageLookupByLibrary.simpleMessage(""),
        "openAppToReadMessages": MessageLookupByLibrary.simpleMessage(
            "Mesajları okumak için uygulamayı aç"),
        "openCamera": MessageLookupByLibrary.simpleMessage("Kamerayı aç"),
        "optionalGroupName":
            MessageLookupByLibrary.simpleMessage("(İsteğe bağlı) Grup adı"),
        "participatingUserDevices": MessageLookupByLibrary.simpleMessage(""),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(""),
        "password": MessageLookupByLibrary.simpleMessage("Parola"),
        "pickImage": MessageLookupByLibrary.simpleMessage(""),
        "play": m39,
        "pleaseChooseAUsername": MessageLookupByLibrary.simpleMessage(
            "Lütfen bir kullanıcı adı seçin"),
        "pleaseEnterAMatrixIdentifier":
            MessageLookupByLibrary.simpleMessage(""),
        "pleaseEnterYourPassword":
            MessageLookupByLibrary.simpleMessage("Lütfen parolanızı girin"),
        "pleaseEnterYourUsername": MessageLookupByLibrary.simpleMessage(
            "Lütfen kullanıcı adınızı girin"),
        "publicRooms": MessageLookupByLibrary.simpleMessage(""),
        "recording": MessageLookupByLibrary.simpleMessage(""),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("Reddet"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("Yeniden katıl"),
        "remove": MessageLookupByLibrary.simpleMessage("Kaldır"),
        "removeAllOtherDevices":
            MessageLookupByLibrary.simpleMessage("Diğer tüm cihazları kaldır"),
        "removeDevice": MessageLookupByLibrary.simpleMessage("Cihazı kaldır"),
        "removeExile": MessageLookupByLibrary.simpleMessage(""),
        "removeMessage": MessageLookupByLibrary.simpleMessage("Mesajı kaldır"),
        "removedBy": m42,
        "renderRichContent": MessageLookupByLibrary.simpleMessage(""),
        "reply": MessageLookupByLibrary.simpleMessage(""),
        "requestPermission": MessageLookupByLibrary.simpleMessage("İzin iste"),
        "requestToReadOlderMessages":
            MessageLookupByLibrary.simpleMessage("Eski mesajları okumayı iste"),
        "revokeAllPermissions":
            MessageLookupByLibrary.simpleMessage("Tüm izinleri iptal et"),
        "roomHasBeenUpgraded": MessageLookupByLibrary.simpleMessage(""),
        "saturday": MessageLookupByLibrary.simpleMessage("Cumartesi"),
        "searchForAChat": MessageLookupByLibrary.simpleMessage("Sohbet ara"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("Gönder"),
        "sendAMessage":
            MessageLookupByLibrary.simpleMessage("Bir mesaj gönder"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Dosya gönder"),
        "sendImage": MessageLookupByLibrary.simpleMessage(""),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Oturum doğrulandı"),
        "setAProfilePicture":
            MessageLookupByLibrary.simpleMessage("Profil fotoğrafı ekleyin"),
        "setGroupDescription":
            MessageLookupByLibrary.simpleMessage("Grup açıklaması ekleyin"),
        "setInvitationLink":
            MessageLookupByLibrary.simpleMessage("Davet bağlantısı ayarlayın"),
        "setStatus": MessageLookupByLibrary.simpleMessage("Durumu ayarla"),
        "settings": MessageLookupByLibrary.simpleMessage("Ayarlar"),
        "share": MessageLookupByLibrary.simpleMessage("Paylaş"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("Hesap oluştur"),
        "skip": MessageLookupByLibrary.simpleMessage("Geç"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Kaynak kod"),
        "startYourFirstChat":
            MessageLookupByLibrary.simpleMessage("İlk sohbetini başlat :-)"),
        "statusExampleMessage":
            MessageLookupByLibrary.simpleMessage("Bugün nasılsınız?"),
        "submit": MessageLookupByLibrary.simpleMessage("Gönder"),
        "sunday": MessageLookupByLibrary.simpleMessage("Pazar"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("Sistem"),
        "tapToShowMenu":
            MessageLookupByLibrary.simpleMessage("Menüyü açmak için dokunun"),
        "theyDontMatch": MessageLookupByLibrary.simpleMessage("Eşleşme yok"),
        "theyMatch": MessageLookupByLibrary.simpleMessage("Eşleştiler"),
        "thisRoomHasBeenArchived":
            MessageLookupByLibrary.simpleMessage("Bu sohbet arşivlendi."),
        "thursday": MessageLookupByLibrary.simpleMessage("Perşembe"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain":
            MessageLookupByLibrary.simpleMessage("Tekrar göndermeyi deneyin"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Salı"),
        "unbannedUser": m55,
        "unblockDevice": MessageLookupByLibrary.simpleMessage(""),
        "unknownDevice":
            MessageLookupByLibrary.simpleMessage("Bilinmeyen cihaz"),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(
            "Bilinmeyen şifreleme algoritması"),
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Bilinmeyen oturum, lütfen doğrulayın"),
        "unmuteChat":
            MessageLookupByLibrary.simpleMessage("Sohbeti sessizden çıkart"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(
            "Amolede uyumlu renkler kullanılsın mı?"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("Kullanıcı adı"),
        "verifiedSession": MessageLookupByLibrary.simpleMessage(
            "Oturum başarıyla doğrulandı!"),
        "verify": MessageLookupByLibrary.simpleMessage("Doğrula"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Manuel Olarak Doğrula"),
        "verifyStart":
            MessageLookupByLibrary.simpleMessage("Doğrulamayı Başlat"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Başarıyla doğrulandı!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("Diğer hesap doğrulanıyor"),
        "verifyUser":
            MessageLookupByLibrary.simpleMessage("Kullanıcıyı Doğrula"),
        "videoCall": MessageLookupByLibrary.simpleMessage("Video arama"),
        "visibilityOfTheChatHistory":
            MessageLookupByLibrary.simpleMessage("Sohbet geçmişi görünürlüğü"),
        "visibleForAllParticipants": MessageLookupByLibrary.simpleMessage(
            "Tüm katılımcılar için görünür"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("Herkes için görünür"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("Sesli mesaj"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "İsteği kabul etmesi bekleniyor..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "Emojiyi kabul etmesi bekleniyor..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(""),
        "wallpaper": MessageLookupByLibrary.simpleMessage("Duvar kağıdı"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "Uçtan uca şifreleme şimdilik Beta aşamasında! Risk alarak kullanın!"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Çarşamba"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Matrix ağındaki en şirin anlık mesajlaşma uygulamasına hoş geldiniz."),
        "whoIsAllowedToJoinThisGroup":
            MessageLookupByLibrary.simpleMessage("Bu gruba kimler katılabilir"),
        "writeAMessage": MessageLookupByLibrary.simpleMessage("Mesaj yazın..."),
        "yes": MessageLookupByLibrary.simpleMessage("Evet"),
        "you": MessageLookupByLibrary.simpleMessage("Sen"),
        "youAreInvitedToThisChat":
            MessageLookupByLibrary.simpleMessage("Sohbete davet edildiniz"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(
                "Artık bu sohbette katılımcı değilsiniz"),
        "youCannotInviteYourself":
            MessageLookupByLibrary.simpleMessage("Kendinizi davet edemezsiniz"),
        "youHaveBeenBannedFromThisChat":
            MessageLookupByLibrary.simpleMessage("Bu sohbetten engellendiniz"),
        "yourOwnUsername":
            MessageLookupByLibrary.simpleMessage("Kullanıcı adınız")
      };
}
