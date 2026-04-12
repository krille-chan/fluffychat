![Скриншот](https://github.com/krille-chan/fluffychat/blob/main/assets/banner_transparent.png?raw=true)

[FluffyChat](https://fluffy.chat) — это милый, некоммерческий клиент для сети [[matrix](https://matrix.org)] с открытым исходным кодом, написанный на [Flutter](https://flutter.dev). Цель приложения — создать простой в использовании мессенджер с открытым исходным кодом, доступный для каждого.

### Ссылки:

- 🌐 [[Weblate] Переведите FluffyChat на ваш язык](https://hosted.weblate.org/projects/fluffychat/)
- 🌍 [[m] Присоединяйтесь к сообществу](https://matrix.to/#/#fluffy-space:matrix.org)
- 📰 [[Mastodon] Получайте обновления в социальных сетях](https://troet.cafe/@krille)
- 🖥️ [[Famedly] Хостинг серверов и профессиональная поддержка](https://famedly.com/kontakt)
- 💝 [[Liberapay] Поддержите разработку FluffyChat](https://de.liberapay.com/KrilleChritzelius)

<a href='https://ko-fi.com/C1C86VN53' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi5.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

### Скриншоты:

<img src="https://github.com/krille-chan/fluffychat-website/blob/main/src/assets/screenshots/mobile.png?raw=true" height="300">
<img src="https://github.com/krille-chan/fluffychat-website/blob/main/src/assets/screenshots/desktop.png?raw=true" height="300">

# Возможности

- 📩 Отправка любых типов сообщений, изображений и файлов
- 🎙️ Голосовые сообщения
- 📍 Обмен геопозицией
- 🔔 Push-уведомления
- 💬 Неограниченные личные и публичные групповые чаты
- 📣 Публичные каналы с тысячами участников
- 🛠️ Богатые возможности модерации групп, включая все функции matrix
- 🔍 Поиск и присоединение к публичным группам
- 🌙 Темная тема
- 🎨 Дизайн Material You
- 📟 Скрывает сложность Matrix ID за простыми QR-кодами
- 😄 Пользовательские эмодзи и стикеры
- 🌌 Пространства
- 🔄 Совместим с Element, Nheko, NeoChat и всеми другими приложениями Matrix
- 🔐 Сквозное шифрование (End-to-end encryption)
- 🔒 Зашифрованное резервное копирование чатов
- 😀 Верификация по эмодзи и перекрестное подписание (cross-signing)

... и многое другое.

# Установка

Инструкции по установке можно найти на нашем сайте:

- https://fluffy.chat

# Как собрать

1. Для сборки FluffyChat вам понадобятся [Flutter](https://flutter.dev) и [Rust](https://www.rust-lang.org/tools/install)

2. Клонируйте репозиторий:
```bash
git clone https://github.com/krille-chan/fluffychat.git
cd fluffychat
```
3. Выберите целевую платформу ниже и включите ее поддержку.
3.1 Если хотите, включите Google Firebase Cloud Messaging:

`./scripts/add-firebase-messaging.sh`

4. Запустите отладку с помощью: `flutter run`

### Android

* Сборка с помощью: `flutter build apk`

### iOS / iPadOS

* Вам понадобится Mac с установленным Xcode, настроенный для подписи приложений, управляемой Xcode
* Если вы хотите автоматически устанавливать приложение на подключенные устройства, убедитесь, что у вас установлен Apple Configurator с включенными Automation Tools (`cfgutil`)
* Задайте несколько переменных окружения
    * FLUFFYCHAT_NEW_TEAM: команда Apple Developer, которой должны принадлежать ваши сертификаты
    * FLUFFYCHAT_NEW_GROUP: группа, в которой должны находиться App ID (например: com.example.fluffychat)
    * FLUFFYCHAT_INSTALL_IPA: установите в `1`, если хотите, чтобы IPA-файл был развернут на подключенных устройствах после сборки, в противном случае оставьте пустым
* Запустите `./scripts/build-ios.sh`

### Web

* Сборка с помощью:
```bash
./scripts/prepare-web.sh # Для установки Vodozemac
flutter build web --release
```

* Опционально можно настроить конфигурацию, предоставив `config.json` по тому же пути, что и fluffychat.
  Пример можно найти в `config.sample.json`. Все значения там необязательны.
  **Пожалуйста, изменяйте только те значения, которые вам действительно нужны**. Если вы, например, хотите
  только изменить homeserver по умолчанию, измените только ключ `defaultHomeserver`.

### Desktop (Linux, Windows, macOS)

* Включите поддержку Desktop во Flutter: https://flutter.dev/desktop

#### Установка пользовательских зависимостей (Linux)

```bash
sudo apt install libjsoncpp1 libsecret-1-dev libsecret-1-0 librhash0 libwebkit2gtk-4.0-dev lld
```

* Соберите приложение одной из следующих команд:
```bash
flutter build linux --release
flutter build windows --release
flutter build macos --release
```

## Как запустить интеграционные тесты

Вам необходимо иметь установленный локально docker! Запускайте скрипт подготовки перед каждым запуском тестов:

```sh
./scripts/prepare_integration_test.sh
```

Затем запустите все тесты с помощью:

```sh
flutter test integration_test/mobile_test.dart
```

# Особая благодарность

* <a href="https://github.com/fabiyamada">Fabiyamada</a> — графический дизайнер, создавшая логотип fluffychat и баннер. Большое спасибо за ее великолепный дизайн.

* <a href="https://github.com/advocatux">Advocatux</a> сделал перевод на испанский язык с большой любовью и заботой. Он всегда поддерживает меня и мою работу с огромной самоотдачей.

* Спасибо MTRNord и Sorunome за разработку.

* Также спасибо всем переводчикам и тестировщикам! С вашей помощью fluffychat теперь доступен более чем на 12 языках.

* <a href="https://github.com/madsrh/WoodenBeaver">WoodenBeaver</a> за звуковую тему, используемую для уведомлений.

* The Matrix Foundation за создание и поддержку [переводов эмодзи](https://github.com/matrix-org/matrix-spec/blob/main/data-definitions/sas-emoji.json), используемых для верификации, лицензия Apache 2.0