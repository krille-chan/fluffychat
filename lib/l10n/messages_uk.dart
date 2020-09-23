// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a uk locale. All the
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
  String get localeName => 'uk';

  static m0(username) => "${username} прийняв(ла) запрошення увійти в чат";

  static m1(username) => "${username} активував(ла) наскрізне шифрування";

  static m2(senderName) => "${senderName} відповів(ла) на дзвінок";

  static m3(username) => "Прийняти цей запит на підтвердження від ${username}?";

  static m4(username, targetName) => "${username} заблокував(ла) ${targetName}";

  static m5(homeserver) =>
      "За замовчуванням ви будете підключені до ${homeserver}";

  static m6(username) => "${username} змінив(ла) аватар чату";

  static m7(username, description) =>
      "${username} змінив(ла) опис чату на: \"${description}\"";

  static m8(username, chatname) =>
      "${username} змінив(ла) ім\'я чату на: \"${chatname}\"";

  static m9(username) => "${username} змінив(ла) права доступу чату";

  static m10(username, displayname) =>
      "${username} змінив(ла) відображуване ім\'я на: ${displayname}";

  static m11(username) => "${username} змінив(ла) правила гостьового доступу";

  static m12(username, rules) =>
      "${username} змінив(ла) правила гостьового доступу на: ${rules}";

  static m13(username) => "${username} змінив(ла) видимість історії";

  static m14(username, rules) =>
      "${username} змінив(ла) видимість історії на: ${rules}";

  static m15(username) => "${username} змінив(ла) правила щодо приєднання";

  static m16(username, joinRules) =>
      "${username} змінив(ла) правила щодо приєднання на: ${joinRules}";

  static m17(username) => "${username} змінив(ла) аватар";

  static m18(username) => "${username} змінив(ла) псевдоніми кімнати";

  static m19(username) => "${username} змінив(ла) посилання для запрошення";

  static m20(error) => "Помилка при розшифруванні повідомлення: ${error}";

  static m21(count) => "${count} учасника(ів)";

  static m22(username) => "${username} створив(ла) чат";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${day}.${month}.${year}";

  static m25(month, day) => "${day}.${month}";

  static m26(senderName) => "${senderName} завершив(ла) дзвінок";

  static m27(displayname) => "Група з ${displayname}";

  static m28(username, targetName) =>
      "${username} відкликав(ла) запрошення для ${targetName}";

  static m29(groupName) => "";

  static m30(username, link) =>
      "${username} запросив(ла) вас у FluffyChat. \n1. Встановіть FluffyChat: http://fluffychat.im \n2. Зареєструйтесь або увійдіть \n3. Відкрийте посилання для запрошення: ${link}";

  static m31(username, targetName) => "";

  static m32(username) => "";

  static m33(username, targetName) => "";

  static m34(username, targetName) =>
      "${username} виключив(ла) та заблокував(ла) ${targetName}";

  static m35(localizedTimeShort) => "";

  static m36(count) => "";

  static m37(homeserver) => "";

  static m38(number) => "";

  static m39(fileName) => "";

  static m40(username) => "";

  static m41(username) => "";

  static m42(username) => "";

  static m43(username) => "";

  static m44(username, count) => "";

  static m45(username, username2) => "";

  static m46(username) => "";

  static m47(username) => "";

  static m48(username) => "";

  static m49(username) => "";

  static m50(username) => "";

  static m52(username) => "";

  static m54(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m55(username, targetName) =>
      "${username} розблокував(ла) ${targetName}";

  static m56(type) => "";

  static m57(unreadCount) => "";

  static m58(unreadEvents) => "";

  static m59(unreadEvents, unreadChats) => "";

  static m60(username, count) => "";

  static m61(username, username2) => "";

  static m62(username) => "";

  static m63(username) => "";

  static m64(username, type) => "";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("Про програму"),
        "accept": MessageLookupByLibrary.simpleMessage("Прийняти"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Обліковий запис"),
        "accountInformation": MessageLookupByLibrary.simpleMessage(
            "Інформація про обліковий запис"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription":
            MessageLookupByLibrary.simpleMessage("Додати опис групи"),
        "admin": MessageLookupByLibrary.simpleMessage("Адміністратор"),
        "alias": MessageLookupByLibrary.simpleMessage("псевдонім"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Вже маєте обліковий запис?"),
        "answeredTheCall": m2,
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("Будь-хто може приєднатись"),
        "archive": MessageLookupByLibrary.simpleMessage("Архів"),
        "archivedRoom":
            MessageLookupByLibrary.simpleMessage("Заархівована кімната"),
        "areGuestsAllowedToJoin": MessageLookupByLibrary.simpleMessage(
            "Чи дозволено гостям приєднуватись"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Ви впевнені?"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Будь ласка, введіть вашу парольну фразу або ключ відновлення для кешування ключів."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Для підпису ключа іншого користувача, будь ласка, введіть вашу парольну фразу або ключ відновлення."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Будь ласка, введіть вашу парольну фразу або ключ відновлення для підтвердження сесії."),
        "askVerificationRequest": m3,
        "authentication":
            MessageLookupByLibrary.simpleMessage("Аутентифікація"),
        "avatarHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Аватар був змінений"),
        "banFromChat":
            MessageLookupByLibrary.simpleMessage("Заблокувати в чаті"),
        "banned": MessageLookupByLibrary.simpleMessage("Заблокований(на)"),
        "bannedUser": m4,
        "blockDevice":
            MessageLookupByLibrary.simpleMessage("Заблокувати пристрій"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Ключі було успішно збережено в кеші"),
        "cancel": MessageLookupByLibrary.simpleMessage("Скасувати"),
        "changeTheHomeserver":
            MessageLookupByLibrary.simpleMessage("Змінити сервер Matrix"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("Змінити назву групи"),
        "changeTheServer":
            MessageLookupByLibrary.simpleMessage("Змінити сервер"),
        "changeTheme": MessageLookupByLibrary.simpleMessage(""),
        "changeWallpaper":
            MessageLookupByLibrary.simpleMessage("Змінити фон чатів"),
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
        "changelog": MessageLookupByLibrary.simpleMessage("Журнал змін"),
        "channelCorruptedDecryptError":
            MessageLookupByLibrary.simpleMessage("Шифрування було пошкоджено"),
        "chat": MessageLookupByLibrary.simpleMessage("Чат"),
        "chatDetails": MessageLookupByLibrary.simpleMessage("Деталі чату"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("Виберіть надійний пароль"),
        "chooseAUsername":
            MessageLookupByLibrary.simpleMessage("Виберіть ім\'я користувача"),
        "close": MessageLookupByLibrary.simpleMessage("Закрити"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Порівняйте і переконайтесь, що наступні емодзі відповідають емодзі на іншому пристрої:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Порівняйте і переконайтесь, що наступні числа відповідають числам на іншому пристрої:"),
        "confirm": MessageLookupByLibrary.simpleMessage("Підтвердити"),
        "connect": MessageLookupByLibrary.simpleMessage("Приєднатись"),
        "connectionAttemptFailed": MessageLookupByLibrary.simpleMessage(
            "Спроба підключення не вдалась"),
        "contactHasBeenInvitedToTheGroup": MessageLookupByLibrary.simpleMessage(
            "Контакт був запрошений в групу"),
        "contentViewer":
            MessageLookupByLibrary.simpleMessage("Перегляд вмісту"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Скопійовано в буфер обміну"),
        "copy": MessageLookupByLibrary.simpleMessage("Копіювати"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar": MessageLookupByLibrary.simpleMessage(
            "Помилка при встановленні аватара"),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(
            "Помилка при встановленні відображуваного імені"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Створити"),
        "createAccountNow": MessageLookupByLibrary.simpleMessage(
            "Створити обліковий запис зараз"),
        "createNewGroup": MessageLookupByLibrary.simpleMessage("Нова група"),
        "createdTheChat": m22,
        "crossSigningDisabled":
            MessageLookupByLibrary.simpleMessage("Крос-підпис вимкнено"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Крос-підпис ввімкнено"),
        "currentlyActive":
            MessageLookupByLibrary.simpleMessage("Зараз активний(на)"),
        "darkTheme": MessageLookupByLibrary.simpleMessage(""),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "delete": MessageLookupByLibrary.simpleMessage("Видалити"),
        "deleteMessage":
            MessageLookupByLibrary.simpleMessage("Видалити повідомлення"),
        "deny": MessageLookupByLibrary.simpleMessage("Відхилити"),
        "device": MessageLookupByLibrary.simpleMessage("Пристрій"),
        "devices": MessageLookupByLibrary.simpleMessage("Пристрої"),
        "discardPicture":
            MessageLookupByLibrary.simpleMessage("Видалити зображення"),
        "displaynameHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "Відображуване ім\'я було змінено"),
        "donate": MessageLookupByLibrary.simpleMessage(""),
        "downloadFile":
            MessageLookupByLibrary.simpleMessage("Завантажити файл"),
        "editDisplayname":
            MessageLookupByLibrary.simpleMessage("Змінити відображуване ім\'я"),
        "editJitsiInstance": MessageLookupByLibrary.simpleMessage(""),
        "emoteExists": MessageLookupByLibrary.simpleMessage("Емодзі вже існує"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Неприпустимий короткий код емодзі"),
        "emoteSettings":
            MessageLookupByLibrary.simpleMessage("Налаштування емодзі"),
        "emoteShortcode":
            MessageLookupByLibrary.simpleMessage("Короткий код для емодзі"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Виберіть короткий код емодзі і зображення"),
        "emptyChat": MessageLookupByLibrary.simpleMessage("Пустий чат"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "Ви більше не зможете відключити шифрування. Ви впевнені?"),
        "encryption": MessageLookupByLibrary.simpleMessage("Шифрування"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Алгоритм шифрування"),
        "encryptionNotEnabled":
            MessageLookupByLibrary.simpleMessage("Шифрування вимкнено"),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "Налаштування наскрізного шифрування"),
        "endedTheCall": m26,
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("Введіть назву групи"),
        "enterAUsername":
            MessageLookupByLibrary.simpleMessage("Введіть ім\'я користувача"),
        "enterYourHomeserver": MessageLookupByLibrary.simpleMessage(
            "Введіть адресу вашого сервера Matrix"),
        "fileName": MessageLookupByLibrary.simpleMessage("Ім\'я файлу"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Розмір файлу"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("Переслати"),
        "friday": MessageLookupByLibrary.simpleMessage("П\'ятниця"),
        "fromJoining":
            MessageLookupByLibrary.simpleMessage("З моменту приєднання"),
        "fromTheInvitation":
            MessageLookupByLibrary.simpleMessage("З моменту запрошення"),
        "group": MessageLookupByLibrary.simpleMessage("Група"),
        "groupDescription": MessageLookupByLibrary.simpleMessage("Опис групи"),
        "groupDescriptionHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Опис групи було змінено"),
        "groupIsPublic": MessageLookupByLibrary.simpleMessage("Публічна група"),
        "groupWith": m27,
        "guestsAreForbidden": MessageLookupByLibrary.simpleMessage(
            "Гості не можуть приєднуватись"),
        "guestsCanJoin":
            MessageLookupByLibrary.simpleMessage("Гості можуть приєднуватись"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Допомога"),
        "homeserverIsNotCompatible": MessageLookupByLibrary.simpleMessage(""),
        "id": MessageLookupByLibrary.simpleMessage(""),
        "identity": MessageLookupByLibrary.simpleMessage(""),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(""),
        "inviteContact": MessageLookupByLibrary.simpleMessage(""),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage(""),
        "invitedUser": m31,
        "invitedUsersOnly": MessageLookupByLibrary.simpleMessage(""),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(""),
        "isTyping": MessageLookupByLibrary.simpleMessage(""),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage(""),
        "keysMissing": MessageLookupByLibrary.simpleMessage(""),
        "kickFromChat": MessageLookupByLibrary.simpleMessage(""),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp": MessageLookupByLibrary.simpleMessage(""),
        "lastSeenLongTimeAgo": MessageLookupByLibrary.simpleMessage(""),
        "leave": MessageLookupByLibrary.simpleMessage(""),
        "leftTheChat": MessageLookupByLibrary.simpleMessage(""),
        "license": MessageLookupByLibrary.simpleMessage(""),
        "lightTheme": MessageLookupByLibrary.simpleMessage(""),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage(""),
        "loadingPleaseWait": MessageLookupByLibrary.simpleMessage(""),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage(""),
        "logout": MessageLookupByLibrary.simpleMessage(""),
        "makeAModerator": MessageLookupByLibrary.simpleMessage(""),
        "makeAnAdmin": MessageLookupByLibrary.simpleMessage(""),
        "makeSureTheIdentifierIsValid":
            MessageLookupByLibrary.simpleMessage(""),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(""),
        "moderator": MessageLookupByLibrary.simpleMessage(""),
        "monday": MessageLookupByLibrary.simpleMessage(""),
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
        "openAppToReadMessages": MessageLookupByLibrary.simpleMessage(""),
        "openCamera": MessageLookupByLibrary.simpleMessage(""),
        "optionalGroupName": MessageLookupByLibrary.simpleMessage(""),
        "participatingUserDevices": MessageLookupByLibrary.simpleMessage(""),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(""),
        "password": MessageLookupByLibrary.simpleMessage(""),
        "pickImage": MessageLookupByLibrary.simpleMessage(""),
        "play": m39,
        "pleaseChooseAUsername": MessageLookupByLibrary.simpleMessage(""),
        "pleaseEnterAMatrixIdentifier":
            MessageLookupByLibrary.simpleMessage(""),
        "pleaseEnterYourPassword": MessageLookupByLibrary.simpleMessage(""),
        "pleaseEnterYourUsername": MessageLookupByLibrary.simpleMessage(""),
        "publicRooms": MessageLookupByLibrary.simpleMessage(""),
        "recording": MessageLookupByLibrary.simpleMessage(""),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage(""),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage(""),
        "remove": MessageLookupByLibrary.simpleMessage(""),
        "removeAllOtherDevices": MessageLookupByLibrary.simpleMessage(""),
        "removeDevice": MessageLookupByLibrary.simpleMessage(""),
        "removeExile": MessageLookupByLibrary.simpleMessage(""),
        "removeMessage": MessageLookupByLibrary.simpleMessage(""),
        "removedBy": m42,
        "renderRichContent": MessageLookupByLibrary.simpleMessage(""),
        "reply": MessageLookupByLibrary.simpleMessage(""),
        "requestPermission": MessageLookupByLibrary.simpleMessage(""),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(""),
        "revokeAllPermissions": MessageLookupByLibrary.simpleMessage(""),
        "roomHasBeenUpgraded": MessageLookupByLibrary.simpleMessage(""),
        "saturday": MessageLookupByLibrary.simpleMessage(""),
        "searchForAChat": MessageLookupByLibrary.simpleMessage(""),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage(""),
        "sendAMessage": MessageLookupByLibrary.simpleMessage(""),
        "sendFile": MessageLookupByLibrary.simpleMessage(""),
        "sendImage": MessageLookupByLibrary.simpleMessage(""),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sessionVerified": MessageLookupByLibrary.simpleMessage(""),
        "setAProfilePicture": MessageLookupByLibrary.simpleMessage(""),
        "setGroupDescription": MessageLookupByLibrary.simpleMessage(""),
        "setInvitationLink": MessageLookupByLibrary.simpleMessage(""),
        "setStatus": MessageLookupByLibrary.simpleMessage(""),
        "settings": MessageLookupByLibrary.simpleMessage(""),
        "share": MessageLookupByLibrary.simpleMessage(""),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage(""),
        "skip": MessageLookupByLibrary.simpleMessage(""),
        "sourceCode": MessageLookupByLibrary.simpleMessage(""),
        "startYourFirstChat": MessageLookupByLibrary.simpleMessage(""),
        "statusExampleMessage": MessageLookupByLibrary.simpleMessage(""),
        "submit": MessageLookupByLibrary.simpleMessage(""),
        "sunday": MessageLookupByLibrary.simpleMessage(""),
        "systemTheme": MessageLookupByLibrary.simpleMessage(""),
        "tapToShowMenu": MessageLookupByLibrary.simpleMessage(""),
        "theyDontMatch": MessageLookupByLibrary.simpleMessage(""),
        "theyMatch": MessageLookupByLibrary.simpleMessage(""),
        "thisRoomHasBeenArchived": MessageLookupByLibrary.simpleMessage(""),
        "thursday": MessageLookupByLibrary.simpleMessage(""),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage(""),
        "tryToSendAgain": MessageLookupByLibrary.simpleMessage(""),
        "tuesday": MessageLookupByLibrary.simpleMessage(""),
        "unbannedUser": m55,
        "unblockDevice": MessageLookupByLibrary.simpleMessage(""),
        "unknownDevice": MessageLookupByLibrary.simpleMessage(""),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(""),
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(""),
        "unmuteChat": MessageLookupByLibrary.simpleMessage(""),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(""),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage(""),
        "verifiedSession": MessageLookupByLibrary.simpleMessage(""),
        "verify": MessageLookupByLibrary.simpleMessage(""),
        "verifyManual": MessageLookupByLibrary.simpleMessage(""),
        "verifyStart": MessageLookupByLibrary.simpleMessage(""),
        "verifySuccess": MessageLookupByLibrary.simpleMessage(""),
        "verifyTitle": MessageLookupByLibrary.simpleMessage(""),
        "verifyUser": MessageLookupByLibrary.simpleMessage(""),
        "videoCall": MessageLookupByLibrary.simpleMessage(""),
        "visibilityOfTheChatHistory": MessageLookupByLibrary.simpleMessage(""),
        "visibleForAllParticipants": MessageLookupByLibrary.simpleMessage(""),
        "visibleForEveryone": MessageLookupByLibrary.simpleMessage(""),
        "voiceMessage": MessageLookupByLibrary.simpleMessage(""),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(""),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(""),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(""),
        "wallpaper": MessageLookupByLibrary.simpleMessage(""),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(""),
        "wednesday": MessageLookupByLibrary.simpleMessage(""),
        "welcomeText": MessageLookupByLibrary.simpleMessage(""),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(""),
        "writeAMessage": MessageLookupByLibrary.simpleMessage(""),
        "yes": MessageLookupByLibrary.simpleMessage(""),
        "you": MessageLookupByLibrary.simpleMessage(""),
        "youAreInvitedToThisChat": MessageLookupByLibrary.simpleMessage(""),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(""),
        "youCannotInviteYourself": MessageLookupByLibrary.simpleMessage(""),
        "youHaveBeenBannedFromThisChat": MessageLookupByLibrary.simpleMessage(
            "Ви були заблоковані в цьому чаті"),
        "yourOwnUsername": MessageLookupByLibrary.simpleMessage("")
      };
}
