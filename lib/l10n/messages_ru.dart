// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static m0(username) => "${username} принял(а) приглашение войти в чат";

  static m1(username) => "${username} активировал(а) сквозное шифрование";

  static m2(senderName) => "${senderName} ответил(а) на звонок";

  static m3(username) => "Принять этот запрос подтверждения от ${username}?";

  static m4(username, targetName) =>
      "${username} заблокировал(а) ${targetName}";

  static m5(homeserver) => "По умолчанию вы будете подключены к ${homeserver}";

  static m6(username) => "${username} изменил(а) аватар чата";

  static m7(username, description) =>
      "${username} изменил(а) описание чата на: \"${description}\"";

  static m8(username, chatname) =>
      "${username} изменил(а) имя чата на: \"${chatname}\"";

  static m9(username) => "${username} изменил(а) права доступа к чату";

  static m10(username, displayname) =>
      "${username} изменил(а) отображаемое имя на: ${displayname}";

  static m11(username) => "${username} изменил(а) правила гостевого доступа";

  static m12(username, rules) =>
      "${username} изменил(а) правила гостевого доступа на: ${rules}";

  static m13(username) => "${username} изменил(а) видимость истории";

  static m14(username, rules) =>
      "${username} изменил(а) видимость истории на: ${rules}";

  static m15(username) => "${username} изменил(а) правила присоединения";

  static m16(username, joinRules) =>
      "${username} изменил(а) правила присоединения на: ${joinRules}";

  static m17(username) => "${username} изменил(а) аватар";

  static m18(username) => "${username} изменил(а) псевдонимы комнаты";

  static m19(username) => "${username} изменил(а) ссылку для приглашения";

  static m20(error) => "Не удалось расшифровать сообщение: ${error}";

  static m21(count) => "${count} участника(ов)";

  static m22(username) => "${username} создал(а) чат";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${day}.${month}.${year}";

  static m25(month, day) => "${day}.${month}";

  static m26(senderName) => "${senderName} завершил(а) звонок";

  static m27(displayname) => "Группа с ${displayname}";

  static m28(username, targetName) =>
      "${username} отозвал(а) приглашение для ${targetName}";

  static m29(groupName) => "Пригласить контакт в ${groupName}";

  static m30(username, link) =>
      "${username} пригласил(а) вас в FluffyChat. \n1. Установите FluffyChat: https://fluffychat.im \n2. Зарегистрируйтесь или войдите \n3. Откройте ссылку приглашения: ${link}";

  static m31(username, targetName) => "${username} пригласил(а) ${targetName}";

  static m32(username) => "${username} присоединился(ась) к чату";

  static m33(username, targetName) => "${username} исключил(а) ${targetName}";

  static m34(username, targetName) =>
      "${username} исключил(а) и заблокировал(а) ${targetName}";

  static m35(localizedTimeShort) =>
      "Последнее посещение: ${localizedTimeShort}";

  static m36(count) => "Загрузить еще ${count} участника(ов)";

  static m37(homeserver) => "Войти в ${homeserver}";

  static m38(number) => "${number} выбран(о)";

  static m39(fileName) => "Проиграть ${fileName}";

  static m40(username) => "${username} отредактировал(а) событие";

  static m41(username) => "${username} отклонил(а) приглашение";

  static m42(username) => "Удалено пользователем ${username}";

  static m43(username) => "Просмотрено пользователем ${username}";

  static m44(username, count) =>
      "Просмотрено пользователями ${username} и ${count} другими";

  static m45(username, username2) =>
      "Просмотрено пользователями ${username} и ${username2}";

  static m46(username) => "${username} отправил(а) файл";

  static m47(username) => "${username} отправил(а) изображение";

  static m48(username) => "${username} отправил(а) стикер";

  static m49(username) => "${username} отправил(а) видео";

  static m50(username) => "${username} отправил(а) аудио";

  static m51(senderName) => "${senderName} отправил(а) информацию о звонке";

  static m52(username) => "${username} поделился(ась) местоположением";

  static m53(senderName) => "${senderName} начал(а) звонок";

  static m54(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m55(username, targetName) =>
      "${username} разблокировал(а) ${targetName}";

  static m56(type) => "Неизвестное событие \"${type}\"";

  static m57(unreadCount) => "${unreadCount} непрочитанных чата(ов)";

  static m58(unreadEvents) => "${unreadEvents} непрочитанных сообщения(ий)";

  static m59(unreadEvents, unreadChats) =>
      "${unreadEvents} непрочитанное(ых) сообщение(ий) в ${unreadChats} чате(ах)";

  static m60(username, count) =>
      "${username} и ${count} других участников печатают...";

  static m61(username, username2) => "${username} и ${username2} печатают...";

  static m62(username) => "${username} печатает...";

  static m63(username) => "${username} покинул(а) чат";

  static m64(username, type) =>
      "${username} отправил(а) событие типа \"${type}\"";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("О приложении"),
        "accept": MessageLookupByLibrary.simpleMessage("Принять"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("Учётная запись"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Сведения об учётной записи"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription":
            MessageLookupByLibrary.simpleMessage("Добавить описание группы"),
        "admin": MessageLookupByLibrary.simpleMessage("Администратор"),
        "alias": MessageLookupByLibrary.simpleMessage("псевдоним"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Уже есть учётная запись?"),
        "answeredTheCall": m2,
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("Каждый может присоединиться"),
        "archive": MessageLookupByLibrary.simpleMessage("Архив"),
        "archivedRoom":
            MessageLookupByLibrary.simpleMessage("Архивированная комната"),
        "areGuestsAllowedToJoin": MessageLookupByLibrary.simpleMessage(
            "Разрешено ли гостям присоединяться"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Вы уверены?"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите вашу парольную фразу или ключ восстановления для кэширования ключей."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Для подписи ключа другого пользователя, пожалуйста, введите вашу парольную фразу или ключ восстановления."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите вашу парольную фразу или ключ восстановления для подтвердждения сессии."),
        "askVerificationRequest": m3,
        "authentication":
            MessageLookupByLibrary.simpleMessage("Аутентификация"),
        "avatarHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("Аватар был изменён"),
        "banFromChat":
            MessageLookupByLibrary.simpleMessage("Заблокировать в чате"),
        "banned": MessageLookupByLibrary.simpleMessage("Заблокирован(а)"),
        "bannedUser": m4,
        "blockDevice":
            MessageLookupByLibrary.simpleMessage("Заблокировать устройство"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys":
            MessageLookupByLibrary.simpleMessage("Ключи успешно кэшированы"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "changeTheHomeserver":
            MessageLookupByLibrary.simpleMessage("Изменить сервер Matrix"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("Изменить название группы"),
        "changeTheServer":
            MessageLookupByLibrary.simpleMessage("Изменить сервер"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("Тема"),
        "changeWallpaper":
            MessageLookupByLibrary.simpleMessage("Изменить фон чатов"),
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
        "changelog": MessageLookupByLibrary.simpleMessage("Журнал изменений"),
        "changesHaveBeenSaved":
            MessageLookupByLibrary.simpleMessage("Изменения были сохранены"),
        "channelCorruptedDecryptError":
            MessageLookupByLibrary.simpleMessage("Шифрование было повреждено"),
        "chat": MessageLookupByLibrary.simpleMessage("Чат"),
        "chatDetails": MessageLookupByLibrary.simpleMessage("Детали чата"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("Выберите надёжный пароль"),
        "chooseAUsername":
            MessageLookupByLibrary.simpleMessage("Выберите имя пользователя"),
        "close": MessageLookupByLibrary.simpleMessage("Закрыть"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "Сравните и убедитесь, что следующие эмодзи соответствуют эмодзи на другом устройстве:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Сравните и убедитесь, что следующие числа соответствуют числам на другом устройстве:"),
        "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
        "connect": MessageLookupByLibrary.simpleMessage("Присоединиться"),
        "connectionAttemptFailed": MessageLookupByLibrary.simpleMessage(
            "Попытка подключения не удалась"),
        "contactHasBeenInvitedToTheGroup": MessageLookupByLibrary.simpleMessage(
            "Контакт был приглашен в группу"),
        "contentViewer":
            MessageLookupByLibrary.simpleMessage("Просмотр содержимого"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Скопировано в буфер обмена"),
        "copy": MessageLookupByLibrary.simpleMessage("Скопировать"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar": MessageLookupByLibrary.simpleMessage(
            "Не удалось установить аватар"),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(
            "Не удалось установить отображаемое имя"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("Создать"),
        "createAccountNow": MessageLookupByLibrary.simpleMessage(
            "Создать учётную запись сейчас"),
        "createNewGroup": MessageLookupByLibrary.simpleMessage("Новая группа"),
        "createdTheChat": m22,
        "crossSigningDisabled":
            MessageLookupByLibrary.simpleMessage("Кросс-подпись отключена"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Кросс-подпись включена"),
        "currentlyActive": MessageLookupByLibrary.simpleMessage(
            "В настоящее время активен(а)"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Тёмная"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "deleteMessage":
            MessageLookupByLibrary.simpleMessage("Удалить сообщение"),
        "deny": MessageLookupByLibrary.simpleMessage("Отклонить"),
        "device": MessageLookupByLibrary.simpleMessage("Устройство"),
        "devices": MessageLookupByLibrary.simpleMessage("Устройства"),
        "discardPicture":
            MessageLookupByLibrary.simpleMessage("Удалить изображение"),
        "displaynameHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "Отображаемое имя было изменено"),
        "donate": MessageLookupByLibrary.simpleMessage("Пожертвовать"),
        "downloadFile": MessageLookupByLibrary.simpleMessage("Скачать файл"),
        "editDisplayname":
            MessageLookupByLibrary.simpleMessage("Отображаемое имя"),
        "editJitsiInstance":
            MessageLookupByLibrary.simpleMessage("Сервер Jitsi"),
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Эмодзи уже существует"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Недопустимый краткий код эмодзи"),
        "emoteSettings":
            MessageLookupByLibrary.simpleMessage("Настройки эмодзи"),
        "emoteShortcode":
            MessageLookupByLibrary.simpleMessage("Краткий код для эмодзи"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Выберите краткий код эмодзи и изображение"),
        "emptyChat": MessageLookupByLibrary.simpleMessage("Пустой чат"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "Вы больше не сможете отключить шифрование. Вы уверены?"),
        "encryption": MessageLookupByLibrary.simpleMessage("Шифрование"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("Алгоритм шифрования"),
        "encryptionNotEnabled":
            MessageLookupByLibrary.simpleMessage("Шифрование не включено"),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(
            "Настройки сквозного шифрования"),
        "endedTheCall": m26,
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("Введите название группы"),
        "enterAUsername":
            MessageLookupByLibrary.simpleMessage("Введите имя пользователя"),
        "enterYourHomeserver": MessageLookupByLibrary.simpleMessage(
            "Введите адрес вашего сервера Matrix"),
        "fileName": MessageLookupByLibrary.simpleMessage("Имя файла"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Размер файла"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("Переслать"),
        "friday": MessageLookupByLibrary.simpleMessage("Пятница"),
        "fromJoining":
            MessageLookupByLibrary.simpleMessage("С момента присоединения"),
        "fromTheInvitation":
            MessageLookupByLibrary.simpleMessage("С момента приглашения"),
        "group": MessageLookupByLibrary.simpleMessage("Группа"),
        "groupDescription":
            MessageLookupByLibrary.simpleMessage("Описание группы"),
        "groupDescriptionHasBeenChanged": MessageLookupByLibrary.simpleMessage(
            "Описание группы было изменено"),
        "groupIsPublic":
            MessageLookupByLibrary.simpleMessage("Публичная группа"),
        "groupWith": m27,
        "guestsAreForbidden": MessageLookupByLibrary.simpleMessage(
            "Гости не могут присоединиться"),
        "guestsCanJoin":
            MessageLookupByLibrary.simpleMessage("Гости могут присоединиться"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("Помощь"),
        "homeserverIsNotCompatible":
            MessageLookupByLibrary.simpleMessage("Несовместимый сервер Matrix"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "identity": MessageLookupByLibrary.simpleMessage("Идентификация"),
        "ignoreListDescription": MessageLookupByLibrary.simpleMessage(
            "Вы можете игнорировать пользователей, которые вам мешают. Вы не сможете получать сообщения или приглашения в комнату от пользователей из вашего личного списка игнорирования."),
        "ignoreUsername": MessageLookupByLibrary.simpleMessage(
            "Игнорировать имя пользователя"),
        "ignoredUsers":
            MessageLookupByLibrary.simpleMessage("Игнорируемые пользователи"),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Неверный пароль или ключ восстановления"),
        "inviteContact":
            MessageLookupByLibrary.simpleMessage("Пригласить контакт"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("Приглашён"),
        "invitedUser": m31,
        "invitedUsersOnly": MessageLookupByLibrary.simpleMessage(
            "Только приглашённым пользователям"),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Правильно ли указан следующий ключ устройства?"),
        "isTyping": MessageLookupByLibrary.simpleMessage("Печатает..."),
        "joinRoom":
            MessageLookupByLibrary.simpleMessage("Присоединиться к комнате"),
        "joinedTheChat": m32,
        "keysCached":
            MessageLookupByLibrary.simpleMessage("Ключи сохранены в кэше"),
        "keysMissing":
            MessageLookupByLibrary.simpleMessage("Ключи отсутствуют"),
        "kickFromChat":
            MessageLookupByLibrary.simpleMessage("Исключить из чата"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp": MessageLookupByLibrary.simpleMessage(
            "Последний IP, с которого заходили"),
        "lastSeenLongTimeAgo":
            MessageLookupByLibrary.simpleMessage("был(а) в сети давно"),
        "leave": MessageLookupByLibrary.simpleMessage("Покинуть"),
        "leftTheChat": MessageLookupByLibrary.simpleMessage("Покинуть чат"),
        "license": MessageLookupByLibrary.simpleMessage("Лицензия"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("Светлая"),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage("Загрузить больше..."),
        "loadingPleaseWait":
            MessageLookupByLibrary.simpleMessage("Пожалуйста, подождите..."),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("Вход"),
        "logout": MessageLookupByLibrary.simpleMessage("Выйти"),
        "makeAModerator":
            MessageLookupByLibrary.simpleMessage("Сделать модератором"),
        "makeAnAdmin":
            MessageLookupByLibrary.simpleMessage("Сделать администратором"),
        "makeSureTheIdentifierIsValid": MessageLookupByLibrary.simpleMessage(
            "Убедитесь, что идентификатор действителен"),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "Сообщение будет удалено для всех участников"),
        "moderator": MessageLookupByLibrary.simpleMessage("Модератор"),
        "monday": MessageLookupByLibrary.simpleMessage("Понедельник"),
        "muteChat":
            MessageLookupByLibrary.simpleMessage("Отключить уведомления"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(
            "Помните, что вам нужен Pantalaimon для использования сквозного шифрования."),
        "newMessageInFluffyChat": MessageLookupByLibrary.simpleMessage(
            "Новое сообщение во FluffyChat"),
        "newPrivateChat":
            MessageLookupByLibrary.simpleMessage("Новый приватный чат"),
        "newVerificationRequest": MessageLookupByLibrary.simpleMessage(
            "Новый запрос на подтверждение"),
        "no": MessageLookupByLibrary.simpleMessage("Нет"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "FluffyChat в настоящее время не поддерживает включение кросс-подписи. Пожалуйста, включите его в Element."),
        "noEmotesFound":
            MessageLookupByLibrary.simpleMessage("Эмодзи не найдены 😕"),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "Похоже, у вас нет служб Google на вашем телефоне. Это хорошее решение для вашей конфиденциальности! Для получения push-уведомлений во FluffyChat мы рекомендуем использовать microG: https://microg.org/"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "В настоящее время FluffyChat не поддерживает функцию резервного копирования онлайн-ключей. Пожалуйста, включите её в Element."),
        "noPermission":
            MessageLookupByLibrary.simpleMessage("Нет прав доступа"),
        "noRoomsFound":
            MessageLookupByLibrary.simpleMessage("Комнаты не найдены..."),
        "none": MessageLookupByLibrary.simpleMessage("Ничего"),
        "notSupportedInWeb": MessageLookupByLibrary.simpleMessage(
            "Не поддерживается в веб-версии"),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Резервное копирование ключей на сервере отключено"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Резервное копирование ключей на сервере включено"),
        "oopsSomethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Упс! Что-то пошло не так..."),
        "openAppToReadMessages": MessageLookupByLibrary.simpleMessage(
            "Откройте приложение для чтения сообщений"),
        "openCamera": MessageLookupByLibrary.simpleMessage("Открыть камеру"),
        "optionalGroupName": MessageLookupByLibrary.simpleMessage(
            "(необязательно) Название группы"),
        "participatingUserDevices":
            MessageLookupByLibrary.simpleMessage("Участвующие устройства"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "пароль или ключ восстановления"),
        "password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "pickImage":
            MessageLookupByLibrary.simpleMessage("Выбрать изображение"),
        "pin": MessageLookupByLibrary.simpleMessage("Закрепить"),
        "play": m39,
        "pleaseChooseAUsername": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, выберите имя пользователя"),
        "pleaseEnterAMatrixIdentifier": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите идентификатор Matrix"),
        "pleaseEnterYourPassword": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите ваш пароль"),
        "pleaseEnterYourUsername": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите имя пользователя"),
        "publicRooms":
            MessageLookupByLibrary.simpleMessage("Публичные комнаты"),
        "recording": MessageLookupByLibrary.simpleMessage("Запись"),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("Отклонить"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("Зайти повторно"),
        "remove": MessageLookupByLibrary.simpleMessage("Удалить"),
        "removeAllOtherDevices": MessageLookupByLibrary.simpleMessage(
            "Удалить все другие устройства"),
        "removeDevice":
            MessageLookupByLibrary.simpleMessage("Удалить устройство"),
        "removeExile":
            MessageLookupByLibrary.simpleMessage("Разблокировать в чате"),
        "removeMessage":
            MessageLookupByLibrary.simpleMessage("Удалить сообщение"),
        "removedBy": m42,
        "renderRichContent": MessageLookupByLibrary.simpleMessage(
            "Показывать текст с форматированием"),
        "reply": MessageLookupByLibrary.simpleMessage("Ответить"),
        "requestPermission":
            MessageLookupByLibrary.simpleMessage("Запросить разрешение"),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(
            "Запросить доступ к предыдущим сообщениям"),
        "revokeAllPermissions":
            MessageLookupByLibrary.simpleMessage("Отменить все права доступа"),
        "roomHasBeenUpgraded":
            MessageLookupByLibrary.simpleMessage("Комната обновлена"),
        "saturday": MessageLookupByLibrary.simpleMessage("Суббота"),
        "searchForAChat": MessageLookupByLibrary.simpleMessage("Поиск чата"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("Отправить"),
        "sendAMessage":
            MessageLookupByLibrary.simpleMessage("Отправить сообщение"),
        "sendAudio": MessageLookupByLibrary.simpleMessage("Отправить аудио"),
        "sendBugReports": MessageLookupByLibrary.simpleMessage(
            "Разрешить отправку отчетов об ошибках в sentry.io"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Отправить файл"),
        "sendImage":
            MessageLookupByLibrary.simpleMessage("Отправить изображение"),
        "sendOriginal":
            MessageLookupByLibrary.simpleMessage("Отправить оригинал"),
        "sendVideo": MessageLookupByLibrary.simpleMessage("Отправить видео"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sentryInfo": MessageLookupByLibrary.simpleMessage(
            "Информация о вашей конфиденциальности: https://sentry.io/security/"),
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("Сессия подтверждена"),
        "setAProfilePicture": MessageLookupByLibrary.simpleMessage(
            "Установить изображение профиля"),
        "setGroupDescription":
            MessageLookupByLibrary.simpleMessage("Задать описание группы"),
        "setInvitationLink": MessageLookupByLibrary.simpleMessage(
            "Установить ссылку для приглашения"),
        "setStatus": MessageLookupByLibrary.simpleMessage("Задать статус"),
        "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
        "share": MessageLookupByLibrary.simpleMessage("Поделиться"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
        "skip": MessageLookupByLibrary.simpleMessage("Пропустить"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Исходный код"),
        "startYourFirstChat":
            MessageLookupByLibrary.simpleMessage("Начните свой первый чат :-)"),
        "startedACall": m53,
        "statusExampleMessage":
            MessageLookupByLibrary.simpleMessage("Как у вас сегодня дела?"),
        "submit": MessageLookupByLibrary.simpleMessage("Отправить"),
        "sunday": MessageLookupByLibrary.simpleMessage("Воскресенье"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("Системная"),
        "tapToShowMenu": MessageLookupByLibrary.simpleMessage(
            "Нажмите, чтобы показать меню"),
        "theyDontMatch":
            MessageLookupByLibrary.simpleMessage("Они не совпадают"),
        "theyMatch": MessageLookupByLibrary.simpleMessage("Они совпадают"),
        "thisRoomHasBeenArchived": MessageLookupByLibrary.simpleMessage(
            "Эта комната была заархивирована."),
        "thursday": MessageLookupByLibrary.simpleMessage("Четверг"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain": MessageLookupByLibrary.simpleMessage(
            "Попробуйте отправить ещё раз"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Вторник"),
        "unbannedUser": m55,
        "unblockDevice":
            MessageLookupByLibrary.simpleMessage("Разблокировать устройство"),
        "unknownDevice":
            MessageLookupByLibrary.simpleMessage("Неизвестное устройство"),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(
            "Неизвестный алгоритм шифрования"),
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Неизвестная сессия, пожалуйста, проверьте"),
        "unmuteChat":
            MessageLookupByLibrary.simpleMessage("Включить уведомления"),
        "unpin": MessageLookupByLibrary.simpleMessage("Открепить"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme":
            MessageLookupByLibrary.simpleMessage("AMOLED-совместимые цвета"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("Имя пользователя"),
        "verifiedSession":
            MessageLookupByLibrary.simpleMessage("Сессия успешно проверена"),
        "verify": MessageLookupByLibrary.simpleMessage("Проверить"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Проверить вручную"),
        "verifyStart": MessageLookupByLibrary.simpleMessage("Начать проверку"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Проверка успешно завершена"),
        "verifyTitle": MessageLookupByLibrary.simpleMessage(
            "Проверка другой учётной записи"),
        "verifyUser":
            MessageLookupByLibrary.simpleMessage("Проверить пользователя"),
        "videoCall": MessageLookupByLibrary.simpleMessage("Видеозвонок"),
        "visibilityOfTheChatHistory":
            MessageLookupByLibrary.simpleMessage("Видимость истории чата"),
        "visibleForAllParticipants":
            MessageLookupByLibrary.simpleMessage("Видима для всех участников"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("Видна всем"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage(
            "Отправить голосовое сообщение"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "В ожидании партнёра, чтобы принять запрос..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "В ожидании партнёра, чтобы принять эмодзи..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "В ожидании партнёра, чтобы принять числа..."),
        "wallpaper": MessageLookupByLibrary.simpleMessage("Обои"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "Сквозное шифрование в настоящее время в бета-версии! Используйте на свой риск!"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Среда"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Добро пожаловать в самый симпатичный мессенджер в сети Matrix."),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(
            "Кому разрешено вступать в эту группу"),
        "writeAMessage":
            MessageLookupByLibrary.simpleMessage("Напишите сообщение..."),
        "yes": MessageLookupByLibrary.simpleMessage("Да"),
        "you": MessageLookupByLibrary.simpleMessage("Вы"),
        "youAreInvitedToThisChat":
            MessageLookupByLibrary.simpleMessage("Вы приглашены в этот чат"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(
                "Вы больше не участвуете в этом чате"),
        "youCannotInviteYourself": MessageLookupByLibrary.simpleMessage(
            "Вы не можете пригласить себя"),
        "youHaveBeenBannedFromThisChat": MessageLookupByLibrary.simpleMessage(
            "Вы были заблокированы в этом чате"),
        "yourOwnUsername":
            MessageLookupByLibrary.simpleMessage("Ваше имя пользователя")
      };
}
