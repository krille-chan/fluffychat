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

  static m0(username) => "${username} принял(а) приглашение";

  static m1(username) => "${username} активировал(а) сквозное шифрование";

  static m60(username) => "Принять этот запрос подтверждения от ${username}?";

  static m2(username, targetName) => "${username} забанил(а) ${targetName}";

  static m3(homeserver) => "По умолчанию вы будете подключены к ${homeserver}";

  static m4(username) => "${username} изменил(а) аватар чата";

  static m5(username, description) =>
      "${username} изменил(а) описание чата на: \'${description}\'";

  static m6(username, chatname) =>
      "${username} изменил(а) имя чата на: \'${chatname}\'";

  static m7(username) => "${username} изменил(а) права чата";

  static m8(username, displayname) =>
      "${username} изменил(а) отображаемое имя на: ${displayname}";

  static m9(username) => "${username} изменил(а) правила гостевого доступа";

  static m10(username, rules) =>
      "${username} изменил(а) правила гостевого доступа на: ${rules}";

  static m11(username) => "${username} изменил(а) видимость истории";

  static m12(username, rules) =>
      "${username} изменил(а) видимость истории на: ${rules}";

  static m13(username) => "${username} изменил(а) правила присоединения";

  static m14(username, joinRules) =>
      "${username} изменил(а) правила присоединения на: ${joinRules}";

  static m15(username) => "${username} сменил(а) аватар профиля";

  static m16(username) => "${username} изменил(а) псевдонимы комнаты";

  static m17(username) => "${username} изменил(а) ссылку приглашения";

  static m18(error) => "Не удалось расшифровать сообщение: ${error}";

  static m19(count) => "${count} участника(-ов)";

  static m20(username) => "${username} создал(а) чат";

  static m21(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m22(year, month, day) => "${day}. ${month}. ${year}";

  static m23(month, day) => "${day}. ${month}";

  static m24(displayname) => "Группа с ${displayname}";

  static m25(username, targetName) =>
      "${username} отозвал(а) приглашение для ${targetName}";

  static m26(groupName) => "Пригласить контакт в ${groupName}";

  static m27(username, link) =>
      "${username} пригласил(а) вас в FluffyChat. \n1. Установите FluffyChat: http://fluffy.chat \n2. Зарегистрируйтесь или войдите \n3. Откройте ссылку приглашения: ${link}";

  static m28(username, targetName) => "${username} пригласил(а) ${targetName}";

  static m29(username) => "${username} присоединился(-ась) к чату";

  static m30(username, targetName) => "${username} исключил(а) ${targetName}";

  static m31(username, targetName) =>
      "${username} исключил(а) и забанил(а) ${targetName}";

  static m32(localizedTimeShort) =>
      "Последнее посещение: ${localizedTimeShort}";

  static m33(count) => "Загрузить еще ${count} участников";

  static m34(homeserver) => "Войти в ${homeserver}";

  static m35(number) => "${number} выбрано";

  static m36(fileName) => "Играть ${fileName}";

  static m37(username) => "${username} отредактировал(а) событие";

  static m38(username) => "${username} отклонил(а) приглашение";

  static m39(username) => "Удалено пользователем ${username}";

  static m40(username) => "Просмотрено пользователем ${username}";

  static m41(username, count) =>
      "Просмотрено пользователями ${username} и ${count} другими";

  static m42(username, username2) =>
      "Просмотрено пользователями ${username} и ${username2}";

  static m43(username) => "${username} отправил(а) файл";

  static m44(username) => "${username} отправил(а) картинку";

  static m45(username) => "${username} отправил(а) стикер";

  static m46(username) => "${username} отправил(а) видео";

  static m47(username) => "${username} отправил(а) аудио";

  static m48(username) => "${username} поделился(-ась) местоположением";

  static m49(hours12, hours24, minutes, suffix) => "${hours24}:${minutes}";

  static m50(username, targetName) => "${username} разбанил(а) ${targetName}";

  static m51(type) => "Неизвестное событие \'${type}\'";

  static m52(unreadCount) => "${unreadCount} непрочитанных чатов";

  static m53(unreadEvents) => "${unreadEvents} непрочитанных сообщений";

  static m54(unreadEvents, unreadChats) =>
      "${unreadEvents} непрочитанных сообщений в ${unreadChats} чатах";

  static m55(username, count) =>
      "${username} и ${count} других участников печатают...";

  static m56(username, username2) => "${username} и ${username2} печатают...";

  static m57(username) => "${username} печатает...";

  static m58(username) => "${username} покинул(а) чат";

  static m59(username, type) => "${username} отправил(а) событие типа ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "(Optional) Group name": MessageLookupByLibrary.simpleMessage(
            "(Необязательно) Название группы"),
        "About": MessageLookupByLibrary.simpleMessage("О приложении"),
        "Accept": MessageLookupByLibrary.simpleMessage("Принять"),
        "Account": MessageLookupByLibrary.simpleMessage("Учётная запись"),
        "Account informations":
            MessageLookupByLibrary.simpleMessage("Сведения об учётной записи"),
        "Add a group description":
            MessageLookupByLibrary.simpleMessage("Добавить описание группы"),
        "Admin": MessageLookupByLibrary.simpleMessage("Админ"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("Уже есть учётная запись?"),
        "Anyone can join":
            MessageLookupByLibrary.simpleMessage("Каждый может присоединиться"),
        "Archive": MessageLookupByLibrary.simpleMessage("Архив"),
        "Archived Room":
            MessageLookupByLibrary.simpleMessage("Архивированная комната"),
        "Are guest users allowed to join": MessageLookupByLibrary.simpleMessage(
            "Разрешено ли гостям присоединяться"),
        "Are you sure?": MessageLookupByLibrary.simpleMessage("Вы уверены?"),
        "Authentication":
            MessageLookupByLibrary.simpleMessage("Аутентификация"),
        "Avatar has been changed":
            MessageLookupByLibrary.simpleMessage("Аватар был изменен"),
        "Ban from chat": MessageLookupByLibrary.simpleMessage("Бан чата"),
        "Banned": MessageLookupByLibrary.simpleMessage("Забанен"),
        "Block Device":
            MessageLookupByLibrary.simpleMessage("Заблокировать устройство"),
        "Cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "Change the homeserver":
            MessageLookupByLibrary.simpleMessage("Изменить домашний сервер"),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("Изменить название группы"),
        "Change the server":
            MessageLookupByLibrary.simpleMessage("Сменить сервер"),
        "Change wallpaper":
            MessageLookupByLibrary.simpleMessage("Сменить обои"),
        "Change your style":
            MessageLookupByLibrary.simpleMessage("Изменить свой стиль"),
        "Changelog": MessageLookupByLibrary.simpleMessage("Изменения"),
        "Chat": MessageLookupByLibrary.simpleMessage("Чат"),
        "Chat details": MessageLookupByLibrary.simpleMessage("Детали чата"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("Выберите надёжный пароль"),
        "Choose a username":
            MessageLookupByLibrary.simpleMessage("Выберете имя пользователя"),
        "Close": MessageLookupByLibrary.simpleMessage("Закрыть"),
        "Confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
        "Connect": MessageLookupByLibrary.simpleMessage("Присоединиться"),
        "Connection attempt failed": MessageLookupByLibrary.simpleMessage(
            "Попытка подключения не удалась"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage(
                "Контакт был приглашен в группу"),
        "Content viewer":
            MessageLookupByLibrary.simpleMessage("Просмотр содержимого"),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("Скопировано в буфер обмена"),
        "Copy": MessageLookupByLibrary.simpleMessage("Скопировать"),
        "Could not set avatar": MessageLookupByLibrary.simpleMessage(
            "Не удалось установить аватар"),
        "Could not set displayname": MessageLookupByLibrary.simpleMessage(
            "Не удалось установить отображаемое имя"),
        "Create": MessageLookupByLibrary.simpleMessage("Создать"),
        "Create account now": MessageLookupByLibrary.simpleMessage(
            "Создать учётную запись сейчас"),
        "Create new group":
            MessageLookupByLibrary.simpleMessage("Создать новую группу"),
        "Currently active":
            MessageLookupByLibrary.simpleMessage("В настоящее время активен"),
        "Dark": MessageLookupByLibrary.simpleMessage("Тёмный"),
        "Delete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "Delete message":
            MessageLookupByLibrary.simpleMessage("Удалить сообщение"),
        "Deny": MessageLookupByLibrary.simpleMessage("Отклонить"),
        "Device": MessageLookupByLibrary.simpleMessage("Устройство"),
        "Devices": MessageLookupByLibrary.simpleMessage("Устройства"),
        "Discard picture":
            MessageLookupByLibrary.simpleMessage("Сбросить картинку"),
        "Displayname has been changed": MessageLookupByLibrary.simpleMessage(
            "Отображаемое имя было изменено"),
        "Donate": MessageLookupByLibrary.simpleMessage("Пожертвовать"),
        "Download file": MessageLookupByLibrary.simpleMessage("Скачать файл"),
        "Edit Jitsi instance":
            MessageLookupByLibrary.simpleMessage("Изменить экземпляр Jitsi"),
        "Edit displayname":
            MessageLookupByLibrary.simpleMessage("Изменить отображаемое имя"),
        "Emote Settings":
            MessageLookupByLibrary.simpleMessage("Настройки смайликов"),
        "Emote shortcode":
            MessageLookupByLibrary.simpleMessage("Краткий код для смайлика"),
        "Empty chat": MessageLookupByLibrary.simpleMessage("Пустой чат"),
        "Encryption": MessageLookupByLibrary.simpleMessage("Шифрование"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("Алгоритм шифрования"),
        "Encryption is not enabled":
            MessageLookupByLibrary.simpleMessage("Шифрование не включено"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "Сквозное шифрование в настоящее время в бета-версии! Используйте на свой риск!"),
        "End-to-end encryption settings": MessageLookupByLibrary.simpleMessage(
            "Сквозные настройки шифрования"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("Введите название группы"),
        "Enter a username":
            MessageLookupByLibrary.simpleMessage("Введите имя пользователя"),
        "Enter your homeserver":
            MessageLookupByLibrary.simpleMessage("Введите ваш домашний сервер"),
        "File name": MessageLookupByLibrary.simpleMessage("Имя файла"),
        "File size": MessageLookupByLibrary.simpleMessage("Размер файла"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("Переслать"),
        "Friday": MessageLookupByLibrary.simpleMessage("Пятница"),
        "From joining":
            MessageLookupByLibrary.simpleMessage("С момента присоединения"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("С момента приглашения"),
        "Group": MessageLookupByLibrary.simpleMessage("Группа"),
        "Group description":
            MessageLookupByLibrary.simpleMessage("Описание группы"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage(
                "Описание группы было изменено"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("Публичная группа"),
        "Guests are forbidden":
            MessageLookupByLibrary.simpleMessage("Гости запрещены"),
        "Guests can join":
            MessageLookupByLibrary.simpleMessage("Гости могут присоединиться"),
        "Help": MessageLookupByLibrary.simpleMessage("Помощь"),
        "Homeserver is not compatible": MessageLookupByLibrary.simpleMessage(
            "Домашний сервер не совместим"),
        "How are you today?":
            MessageLookupByLibrary.simpleMessage("Как у вас сегодня дела?"),
        "ID": MessageLookupByLibrary.simpleMessage("ID"),
        "Identity": MessageLookupByLibrary.simpleMessage("Идентификация"),
        "Invite contact":
            MessageLookupByLibrary.simpleMessage("Пригласить контакт"),
        "Invited": MessageLookupByLibrary.simpleMessage("Приглашён"),
        "Invited users only": MessageLookupByLibrary.simpleMessage(
            "Только приглашённым пользователям"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(
                "Похоже, у вас нет служб Google на вашем телефоне. Это хорошее решение для вашей конфиденциальности! Для получения push-уведомлений в FluffyChat мы рекомендуем использовать microG: https://microg.org/"),
        "Kick from chat":
            MessageLookupByLibrary.simpleMessage("Исключить из чата"),
        "Last seen IP":
            MessageLookupByLibrary.simpleMessage("Последний увиденный IP"),
        "Leave": MessageLookupByLibrary.simpleMessage("Покинуть"),
        "Left the chat": MessageLookupByLibrary.simpleMessage("Покинуть чат"),
        "License": MessageLookupByLibrary.simpleMessage("Лицензия"),
        "Light": MessageLookupByLibrary.simpleMessage("Светлый"),
        "Load more...":
            MessageLookupByLibrary.simpleMessage("Загрузить больше..."),
        "Loading... Please wait": MessageLookupByLibrary.simpleMessage(
            "Загрузка... Пожалуйста подождите"),
        "Login": MessageLookupByLibrary.simpleMessage("Вход"),
        "Logout": MessageLookupByLibrary.simpleMessage("Выйти"),
        "Make a moderator":
            MessageLookupByLibrary.simpleMessage("Сделать модератором"),
        "Make an admin":
            MessageLookupByLibrary.simpleMessage("Сделать админом"),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage(
                "Убедитесь, что идентификатор действителен"),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage(
                "Сообщение будет удалено для всех участников"),
        "Moderator": MessageLookupByLibrary.simpleMessage("Модератор"),
        "Monday": MessageLookupByLibrary.simpleMessage("Понедельник"),
        "Mute chat": MessageLookupByLibrary.simpleMessage("Замутить чат"),
        "New message in FluffyChat": MessageLookupByLibrary.simpleMessage(
            "Новое сообщение в FluffyChat"),
        "New private chat":
            MessageLookupByLibrary.simpleMessage("Новый приватный чат"),
        "No emotes found. 😕":
            MessageLookupByLibrary.simpleMessage("Смайликов не найдено. 😕"),
        "No permission": MessageLookupByLibrary.simpleMessage("Нет разрешений"),
        "No rooms found...":
            MessageLookupByLibrary.simpleMessage("Комнаты не найдены..."),
        "None": MessageLookupByLibrary.simpleMessage("Ничего"),
        "Not supported in web": MessageLookupByLibrary.simpleMessage(
            "Не поддерживается в веб-версии"),
        "Oops something went wrong...":
            MessageLookupByLibrary.simpleMessage("Упс! Что-то пошло не так..."),
        "Open app to read messages": MessageLookupByLibrary.simpleMessage(
            "Откройте приложение для чтения сообщений"),
        "Open camera": MessageLookupByLibrary.simpleMessage("Открыть камеру"),
        "Participating user devices":
            MessageLookupByLibrary.simpleMessage("Участвующие устройства"),
        "Password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "Pick image": MessageLookupByLibrary.simpleMessage("Выбрать картинку"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(
                "Помните, что вам нужен Pantalaimon для использования сквозного шифрования."),
        "Please choose a username": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, выберите имя пользователя"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage(
                "Пожалуйста, введите matrix идентификатор"),
        "Please enter your password": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста введите ваш пароль"),
        "Please enter your username": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите имя пользователя"),
        "Public Rooms":
            MessageLookupByLibrary.simpleMessage("Публичные комнаты"),
        "Recording": MessageLookupByLibrary.simpleMessage("Запись"),
        "Reject": MessageLookupByLibrary.simpleMessage("Отклонить"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("Перезайти"),
        "Remove": MessageLookupByLibrary.simpleMessage("Удалить"),
        "Remove all other devices": MessageLookupByLibrary.simpleMessage(
            "Удалить все другие устройства"),
        "Remove device":
            MessageLookupByLibrary.simpleMessage("Удалить устройство"),
        "Remove exile": MessageLookupByLibrary.simpleMessage("Удалить ссылку"),
        "Remove message":
            MessageLookupByLibrary.simpleMessage("Удалить сообщение"),
        "Render rich message content": MessageLookupByLibrary.simpleMessage(
            "Показать отформатированные сообщения"),
        "Reply": MessageLookupByLibrary.simpleMessage("Ответить"),
        "Request permission":
            MessageLookupByLibrary.simpleMessage("Запросить разрешение"),
        "Request to read older messages": MessageLookupByLibrary.simpleMessage(
            "Запросить доступ к предыдущим сообщениям"),
        "Revoke all permissions":
            MessageLookupByLibrary.simpleMessage("Отменить все разрешения"),
        "Room has been upgraded":
            MessageLookupByLibrary.simpleMessage("Комната обновлена"),
        "Saturday": MessageLookupByLibrary.simpleMessage("Суббота"),
        "Search for a chat": MessageLookupByLibrary.simpleMessage("Поиск чата"),
        "Seen a long time ago":
            MessageLookupByLibrary.simpleMessage("Просматривали давно"),
        "Send": MessageLookupByLibrary.simpleMessage("Отправить"),
        "Send a message":
            MessageLookupByLibrary.simpleMessage("Отправить сообщение"),
        "Send file": MessageLookupByLibrary.simpleMessage("Отправить файл"),
        "Send image":
            MessageLookupByLibrary.simpleMessage("Отправить картинку"),
        "Set a profile picture": MessageLookupByLibrary.simpleMessage(
            "Установить изображение профиля"),
        "Set group description":
            MessageLookupByLibrary.simpleMessage("Задать описание группы"),
        "Set invitation link": MessageLookupByLibrary.simpleMessage(
            "Установить ссылку для приглашения"),
        "Set status": MessageLookupByLibrary.simpleMessage("Задать статус"),
        "Settings": MessageLookupByLibrary.simpleMessage("Настройки"),
        "Share": MessageLookupByLibrary.simpleMessage("Поделиться"),
        "Sign up": MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
        "Skip": MessageLookupByLibrary.simpleMessage("Пропустить"),
        "Source code": MessageLookupByLibrary.simpleMessage("Исходный код"),
        "Start your first chat :-)":
            MessageLookupByLibrary.simpleMessage("Начни свой первый чат :-)"),
        "Submit": MessageLookupByLibrary.simpleMessage("Отправить"),
        "Sunday": MessageLookupByLibrary.simpleMessage("Воскресенье"),
        "System": MessageLookupByLibrary.simpleMessage("Системный"),
        "Tap to show menu": MessageLookupByLibrary.simpleMessage(
            "Нажмите, чтобы показать меню"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage("Шифрование было повреждено"),
        "They Don\'t Match":
            MessageLookupByLibrary.simpleMessage("Они не совпадают"),
        "They Match": MessageLookupByLibrary.simpleMessage("Они совпадают"),
        "This room has been archived.": MessageLookupByLibrary.simpleMessage(
            "Эта комната была заархивирована."),
        "Thursday": MessageLookupByLibrary.simpleMessage("Четверг"),
        "Try to send again": MessageLookupByLibrary.simpleMessage(
            "Попробуйте отправить еще раз"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("Вторник"),
        "Unblock Device":
            MessageLookupByLibrary.simpleMessage("Разблокировать устройство"),
        "Unknown device":
            MessageLookupByLibrary.simpleMessage("Неизвестное устройство"),
        "Unknown encryption algorithm": MessageLookupByLibrary.simpleMessage(
            "Неизвестный алгоритм шифрования"),
        "Unmute chat": MessageLookupByLibrary.simpleMessage("Размутить чат"),
        "Use Amoled compatible colors?": MessageLookupByLibrary.simpleMessage(
            "Использовать Amoled совместимые цвета?"),
        "Username": MessageLookupByLibrary.simpleMessage("Имя пользователя"),
        "Verify": MessageLookupByLibrary.simpleMessage("Проверить"),
        "Verify User":
            MessageLookupByLibrary.simpleMessage("Проверить пользователя"),
        "Video call": MessageLookupByLibrary.simpleMessage("Видеозвонок"),
        "Visibility of the chat history":
            MessageLookupByLibrary.simpleMessage("Видимость истории чата"),
        "Visible for all participants":
            MessageLookupByLibrary.simpleMessage("Видима для всех участников"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("Видна всем"),
        "Voice message":
            MessageLookupByLibrary.simpleMessage("Голосовое сообщение"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("Обои"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("Среда"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "Добро пожаловать в самый симпатичный мессенджер в сети matrix."),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage(
                "Кому разрешено вступать в эту группу"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("Напишите сообщение..."),
        "Yes": MessageLookupByLibrary.simpleMessage("Да"),
        "You": MessageLookupByLibrary.simpleMessage("Вы"),
        "You are invited to this chat":
            MessageLookupByLibrary.simpleMessage("Вы приглашены в этот чат"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage(
                "Вы больше не участвуете в этом чате"),
        "You cannot invite yourself": MessageLookupByLibrary.simpleMessage(
            "Вы не можете пригласить себя"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage(
                "Вы были забанены в этом чате"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "Вы больше не сможете отключить шифрование. Вы уверены?"),
        "Your own username":
            MessageLookupByLibrary.simpleMessage("Ваше имя пользователя"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("псевдоним"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите секретную фразу безопасного хранилища или ключ восстановления для кеширования ключей."),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "Чтобы иметь возможность подписать другое лицо, пожалуйста, введите пароль или ключ восстановления вашего безопасного хранилища."),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите вашу безопасную парольную фразу или ключ восстановления, чтобы подтвердить ваш сеанс."),
        "askVerificationRequest": m60,
        "bannedUser": m2,
        "byDefaultYouWillBeConnectedTo": m3,
        "cachedKeys":
            MessageLookupByLibrary.simpleMessage("Ключи успешно кэшированы!"),
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
            "Сравните и убедитесь, что следующие эмодзи соответствуют таковым на другом устройстве:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "Сравните и убедитесь, что следующие числа соответствуют числам на другом устройстве:"),
        "couldNotDecryptMessage": m18,
        "countParticipants": m19,
        "createdTheChat": m20,
        "crossSigningDisabled":
            MessageLookupByLibrary.simpleMessage("Кросс-подпись отключена"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("Кросс-подпись включена"),
        "dateAndTimeOfDay": m21,
        "dateWithYear": m22,
        "dateWithoutYear": m23,
        "emoteExists":
            MessageLookupByLibrary.simpleMessage("Смайлик уже существует!"),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(
            "Недопустимый краткий код смайлика!"),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(
            "Вам нужно выбрать краткий код смайлика и картинку!"),
        "groupWith": m24,
        "hasWithdrawnTheInvitationFor": m25,
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "Неверный пароль или ключ восстановления"),
        "inviteContactToGroup": m26,
        "inviteText": m27,
        "invitedUser": m28,
        "is typing...": MessageLookupByLibrary.simpleMessage("Печатает..."),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(
            "Правильно ли указан следующий ключ устройства?"),
        "joinedTheChat": m29,
        "keysCached": MessageLookupByLibrary.simpleMessage("Ключи кэшированы"),
        "keysMissing":
            MessageLookupByLibrary.simpleMessage("Ключи отсутствуют"),
        "kicked": m30,
        "kickedAndBanned": m31,
        "lastActiveAgo": m32,
        "loadCountMoreParticipants": m33,
        "logInTo": m34,
        "newVerificationRequest": MessageLookupByLibrary.simpleMessage(
            "Новый запрос на подтверждение!"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "Fluffychat в настоящее время не поддерживает включение кросс-подписи. Пожалуйста, включите его в Element."),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "В настоящее время Fluffychat не поддерживает функцию резервного копирования онлайн-ключей. Пожалуйста, включите его из Element."),
        "numberSelected": m35,
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(
            "Резервное копирование онлайн-ключей отключено"),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(
            "Резервное копирование онлайн ключей включено"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(
            "пароль или ключ восстановления"),
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
            MessageLookupByLibrary.simpleMessage("Сессия подтверждена"),
        "sharedTheLocation": m48,
        "timeOfDay": m49,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m50,
        "unknownEvent": m51,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(
            "Неизвестная сессия, пожалуйста, проверьте"),
        "unreadChats": m52,
        "unreadMessages": m53,
        "unreadMessagesInChats": m54,
        "userAndOthersAreTyping": m55,
        "userAndUserAreTyping": m56,
        "userIsTyping": m57,
        "userLeftTheChat": m58,
        "userSentUnknownEvent": m59,
        "verifiedSession":
            MessageLookupByLibrary.simpleMessage("Успешно проверенная сессия!"),
        "verifyManual":
            MessageLookupByLibrary.simpleMessage("Проверить вручную"),
        "verifyStart": MessageLookupByLibrary.simpleMessage("Начать проверку"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("Вы успешно проверили!"),
        "verifyTitle": MessageLookupByLibrary.simpleMessage(
            "Проверка другой учётной записи"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(
            "В ожидании партнера, чтобы принять запрос..."),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(
            "В ожидании партнера, чтобы принять смайлики..."),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(
            "В ожидании партнера, чтобы принять числа...")
      };
}
