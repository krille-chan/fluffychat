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
        "(Optional) Group name": MessageLookupByLibrary.simpleMessage(""),
        "About": MessageLookupByLibrary.simpleMessage("Про програму"),
        "Accept": MessageLookupByLibrary.simpleMessage("Прийняти"),
        "Account": MessageLookupByLibrary.simpleMessage("Обліковий запис"),
        "Account informations": MessageLookupByLibrary.simpleMessage(
            "Інформація про обліковий запис"),
        "Add a group description":
            MessageLookupByLibrary.simpleMessage("Додати опис групи"),
        "Admin": MessageLookupByLibrary.simpleMessage("Адміністратор"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("Вже маєте обліковий запис?"),
        "Anyone can join":
            MessageLookupByLibrary.simpleMessage("Будь-хто може приєднатись"),
        "Archive": MessageLookupByLibrary.simpleMessage("Архів"),
        "Archived Room":
            MessageLookupByLibrary.simpleMessage("Заархівована кімната"),
        "Are guest users allowed to join": MessageLookupByLibrary.simpleMessage(
            "Чи дозволено гостям приєднуватись"),
        "Are you sure?": MessageLookupByLibrary.simpleMessage("Ви впевнені?"),
        "Authentication":
            MessageLookupByLibrary.simpleMessage("Аутентифікація"),
        "Avatar has been changed":
            MessageLookupByLibrary.simpleMessage("Аватар був змінений"),
        "Ban from chat":
            MessageLookupByLibrary.simpleMessage("Заблокувати в чаті"),
        "Banned": MessageLookupByLibrary.simpleMessage("Заблокований(на)"),
        "Block Device":
            MessageLookupByLibrary.simpleMessage("Заблокувати пристрій"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Скасувати"),
        "Change the homeserver":
            MessageLookupByLibrary.simpleMessage("Змінити сервер Matrix"),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("Змінити назву групи"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Змінити сервер"),
        "Change wallpaper":
            MessageLookupByLibrary.simpleMessage("Змінити фон чатів"),
        "Change your style": MessageLookupByLibrary.simpleMessage(""),
        "Changelog": MessageLookupByLibrary.simpleMessage("Журнал змін"),
        "Chat": MessageLookupByLibrary.simpleMessage("Чат"),
        "Chat details": MessageLookupByLibrary.simpleMessage("Деталі чату"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("Виберіть надійний пароль"),
        "Choose a username":
            MessageLookupByLibrary.simpleMessage("Виберіть ім\'я користувача"),
        "Close": MessageLookupByLibrary.simpleMessage("Закрити"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Підтвердити"),
        "Connect": MessageLookupByLibrary.simpleMessage("Приєднатись"),
        "Connection attempt failed": MessageLookupByLibrary.simpleMessage(
            "Спроба підключення не вдалась"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage(
                "Контакт був запрошений в групу"),
        "Content viewer":
            MessageLookupByLibrary.simpleMessage("Перегляд вмісту"),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("Скопійовано в буфер обміну"),
        "Copy": MessageLookupByLibrary.simpleMessage("Копіювати"),
        "Could not set avatar": MessageLookupByLibrary.simpleMessage(
            "Помилка при встановленні аватара"),
        "Could not set displayname": MessageLookupByLibrary.simpleMessage(
            "Помилка при встановленні відображуваного імені"),
        "Create": MessageLookupByLibrary.simpleMessage("Створити"),
        "Create account now": MessageLookupByLibrary.simpleMessage(
            "Створити обліковий запис зараз"),
        "Create new group": MessageLookupByLibrary.simpleMessage("Нова група"),
        "Currently active":
            MessageLookupByLibrary.simpleMessage("Зараз активний(на)"),
        "Dark": MessageLookupByLibrary.simpleMessage(""),
        "Delete": MessageLookupByLibrary.simpleMessage("Видалити"),
        "Delete message":
            MessageLookupByLibrary.simpleMessage("Видалити повідомлення"),
        "Deny": MessageLookupByLibrary.simpleMessage("Відхилити"),
        "Device": MessageLookupByLibrary.simpleMessage("Пристрій"),
        "Devices": MessageLookupByLibrary.simpleMessage("Пристрої"),
        "Discard picture":
            MessageLookupByLibrary.simpleMessage("Видалити зображення"),
        "Displayname has been changed": MessageLookupByLibrary.simpleMessage(
            "Відображуване ім\'я було змінено"),
        "Donate": MessageLookupByLibrary.simpleMessage(""),
        "Download file":
            MessageLookupByLibrary.simpleMessage("Завантажити файл"),
        "Edit Jitsi instance": MessageLookupByLibrary.simpleMessage(""),
        "Edit displayname":
            MessageLookupByLibrary.simpleMessage("Змінити відображуване ім\'я"),
        "Emote Settings":
            MessageLookupByLibrary.simpleMessage("Налаштування емодзі"),
        "Emote shortcode":
            MessageLookupByLibrary.simpleMessage("Короткий код для емодзі"),
        "Empty chat": MessageLookupByLibrary.simpleMessage("Пустий чат"),
        "Encryption": MessageLookupByLibrary.simpleMessage("Шифрування"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Алгоритм шифрування"),
        "Encryption is not enabled":
            MessageLookupByLibrary.simpleMessage("Шифрування вимкнено"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(""),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "Налаштування наскрізного шифрування"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("Введіть назву групи"),
        "Enter a username":
            MessageLookupByLibrary.simpleMessage("Введіть ім\'я користувача"),
        "Enter your homeserver": MessageLookupByLibrary.simpleMessage(
            "Введіть адресу вашого сервера Matrix"),
        "File name": MessageLookupByLibrary.simpleMessage("Ім\'я файлу"),
        "File size": MessageLookupByLibrary.simpleMessage("Розмір файлу"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("Переслати"),
        "Friday": MessageLookupByLibrary.simpleMessage("П\'ятниця"),
        "From joining":
            MessageLookupByLibrary.simpleMessage("З моменту приєднання"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("З моменту запрошення"),
        "Group": MessageLookupByLibrary.simpleMessage("Група"),
        "Group description": MessageLookupByLibrary.simpleMessage("Опис групи"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage("Опис групи було змінено"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("Публічна група"),
        "Guests are forbidden": MessageLookupByLibrary.simpleMessage(
            "Гості не можуть приєднуватись"),
        "Guests can join":
            MessageLookupByLibrary.simpleMessage("Гості можуть приєднуватись"),
        "Help": MessageLookupByLibrary.simpleMessage("Допомога"),
        "Homeserver is not compatible":
            MessageLookupByLibrary.simpleMessage(""),
        "How are you today?": MessageLookupByLibrary.simpleMessage(""),
        "ID": MessageLookupByLibrary.simpleMessage(""),
        "Identity": MessageLookupByLibrary.simpleMessage(""),
        "Invite contact": MessageLookupByLibrary.simpleMessage(""),
        "Invited": MessageLookupByLibrary.simpleMessage(""),
        "Invited users only": MessageLookupByLibrary.simpleMessage(""),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(""),
        "Kick from chat": MessageLookupByLibrary.simpleMessage(""),
        "Last seen IP": MessageLookupByLibrary.simpleMessage(""),
        "Leave": MessageLookupByLibrary.simpleMessage(""),
        "Left the chat": MessageLookupByLibrary.simpleMessage(""),
        "License": MessageLookupByLibrary.simpleMessage(""),
        "Light": MessageLookupByLibrary.simpleMessage(""),
        "Load more...": MessageLookupByLibrary.simpleMessage(""),
        "Loading... Please wait": MessageLookupByLibrary.simpleMessage(""),
        "Login": MessageLookupByLibrary.simpleMessage(""),
        "Logout": MessageLookupByLibrary.simpleMessage(""),
        "Make a moderator": MessageLookupByLibrary.simpleMessage(""),
        "Make an admin": MessageLookupByLibrary.simpleMessage(""),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(""),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(""),
        "Moderator": MessageLookupByLibrary.simpleMessage(""),
        "Monday": MessageLookupByLibrary.simpleMessage(""),
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
        "Open app to read messages": MessageLookupByLibrary.simpleMessage(""),
        "Open camera": MessageLookupByLibrary.simpleMessage(""),
        "Participating user devices": MessageLookupByLibrary.simpleMessage(""),
        "Password": MessageLookupByLibrary.simpleMessage(""),
        "Pick image": MessageLookupByLibrary.simpleMessage(""),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(""),
        "Please choose a username": MessageLookupByLibrary.simpleMessage(""),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage(""),
        "Please enter your password": MessageLookupByLibrary.simpleMessage(""),
        "Please enter your username": MessageLookupByLibrary.simpleMessage(""),
        "Public Rooms": MessageLookupByLibrary.simpleMessage(""),
        "Recording": MessageLookupByLibrary.simpleMessage(""),
        "Reject": MessageLookupByLibrary.simpleMessage(""),
        "Rejoin": MessageLookupByLibrary.simpleMessage(""),
        "Remove": MessageLookupByLibrary.simpleMessage(""),
        "Remove all other devices": MessageLookupByLibrary.simpleMessage(""),
        "Remove device": MessageLookupByLibrary.simpleMessage(""),
        "Remove exile": MessageLookupByLibrary.simpleMessage(""),
        "Remove message": MessageLookupByLibrary.simpleMessage(""),
        "Render rich message content": MessageLookupByLibrary.simpleMessage(""),
        "Reply": MessageLookupByLibrary.simpleMessage(""),
        "Request permission": MessageLookupByLibrary.simpleMessage(""),
        "Request to read older messages":
            MessageLookupByLibrary.simpleMessage(""),
        "Revoke all permissions": MessageLookupByLibrary.simpleMessage(""),
        "Room has been upgraded": MessageLookupByLibrary.simpleMessage(""),
        "Saturday": MessageLookupByLibrary.simpleMessage(""),
        "Search for a chat": MessageLookupByLibrary.simpleMessage(""),
        "Seen a long time ago": MessageLookupByLibrary.simpleMessage(""),
        "Send": MessageLookupByLibrary.simpleMessage(""),
        "Send a message": MessageLookupByLibrary.simpleMessage(""),
        "Send file": MessageLookupByLibrary.simpleMessage(""),
        "Send image": MessageLookupByLibrary.simpleMessage(""),
        "Set a profile picture": MessageLookupByLibrary.simpleMessage(""),
        "Set group description": MessageLookupByLibrary.simpleMessage(""),
        "Set invitation link": MessageLookupByLibrary.simpleMessage(""),
        "Set status": MessageLookupByLibrary.simpleMessage(""),
        "Settings": MessageLookupByLibrary.simpleMessage(""),
        "Share": MessageLookupByLibrary.simpleMessage(""),
        "Sign up": MessageLookupByLibrary.simpleMessage(""),
        "Skip": MessageLookupByLibrary.simpleMessage(""),
        "Source code": MessageLookupByLibrary.simpleMessage(""),
        "Start your first chat :-)": MessageLookupByLibrary.simpleMessage(""),
        "Submit": MessageLookupByLibrary.simpleMessage(""),
        "Sunday": MessageLookupByLibrary.simpleMessage(""),
        "System": MessageLookupByLibrary.simpleMessage(""),
        "Tap to show menu": MessageLookupByLibrary.simpleMessage(""),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage("Шифрування було пошкоджено"),
        "They Don\'t Match": MessageLookupByLibrary.simpleMessage(""),
        "They Match": MessageLookupByLibrary.simpleMessage(""),
        "This room has been archived.":
            MessageLookupByLibrary.simpleMessage(""),
        "Thursday": MessageLookupByLibrary.simpleMessage(""),
        "Try to send again": MessageLookupByLibrary.simpleMessage(""),
        "Tuesday": MessageLookupByLibrary.simpleMessage(""),
        "Unblock Device": MessageLookupByLibrary.simpleMessage(""),
        "Unknown device": MessageLookupByLibrary.simpleMessage(""),
        "Unknown encryption algorithm":
            MessageLookupByLibrary.simpleMessage(""),
        "Unmute chat": MessageLookupByLibrary.simpleMessage(""),
        "Use Amoled compatible colors?":
            MessageLookupByLibrary.simpleMessage(""),
        "Username": MessageLookupByLibrary.simpleMessage(""),
        "Verify": MessageLookupByLibrary.simpleMessage(""),
        "Verify User": MessageLookupByLibrary.simpleMessage(""),
        "Video call": MessageLookupByLibrary.simpleMessage(""),
        "Visibility of the chat history":
            MessageLookupByLibrary.simpleMessage(""),
        "Visible for all participants":
            MessageLookupByLibrary.simpleMessage(""),
        "Visible for everyone": MessageLookupByLibrary.simpleMessage(""),
        "Voice message": MessageLookupByLibrary.simpleMessage(""),
        "Wallpaper": MessageLookupByLibrary.simpleMessage(""),
        "Wednesday": MessageLookupByLibrary.simpleMessage(""),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(""),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage(""),
        "Write a message...": MessageLookupByLibrary.simpleMessage(""),
        "Yes": MessageLookupByLibrary.simpleMessage(""),
        "You": MessageLookupByLibrary.simpleMessage(""),
        "You are invited to this chat":
            MessageLookupByLibrary.simpleMessage(""),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(""),
        "You cannot invite yourself": MessageLookupByLibrary.simpleMessage(""),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage(
                "Ви були заблоковані в цьому чаті"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "Ви більше не зможете відключити шифрування. Ви впевнені?"),
        "Your own username": MessageLookupByLibrary.simpleMessage(""),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("псевдонім"),
        "answeredTheCall": m2,
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Будь ласка, введіть вашу парольну фразу або ключ відновлення для кешування ключів."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Для підпису ключа іншого користувача, будь ласка, введіть вашу парольну фразу або ключ відновлення."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Будь ласка, введіть вашу парольну фразу або ключ відновлення для підтвердження сесії."),
        "askVerificationRequest": m3,
        "bannedUser": m4,
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(
            "Ключі було успішно збережено в кеші"),
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
            "Порівняйте і переконайтесь, що наступні емодзі відповідають емодзі на іншому пристрої:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Порівняйте і переконайтесь, що наступні числа відповідають числам на іншому пристрої:"),
        "couldNotDecryptMessage": m20,
        "countParticipants": m21,
        "createdTheChat": m22,
        "crossSigningDisabled":
            MessageLookupByLibrary.simpleMessage("Крос-підпис вимкнено"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Крос-підпис ввімкнено"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "emoteExists": MessageLookupByLibrary.simpleMessage("Емодзі вже існує"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Неприпустимий короткий код емодзі"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Виберіть короткий код емодзі і зображення"),
        "endedTheCall": m26,
        "groupWith": m27,
        "hasWithdrawnTheInvitationFor": m28,
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(""),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invitedUser": m31,
        "is typing...": MessageLookupByLibrary.simpleMessage(""),
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
        "sessionVerified": MessageLookupByLibrary.simpleMessage(""),
        "sharedTheLocation": m52,
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage(""),
        "unbannedUser": m55,
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(""),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "verifiedSession": MessageLookupByLibrary.simpleMessage(""),
        "verifyManual": MessageLookupByLibrary.simpleMessage(""),
        "verifyStart": MessageLookupByLibrary.simpleMessage(""),
        "verifySuccess": MessageLookupByLibrary.simpleMessage(""),
        "verifyTitle": MessageLookupByLibrary.simpleMessage(""),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(""),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(""),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage("")
      };
}
