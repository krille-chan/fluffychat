<!--
SPDX-FileCopyrightText: 2019-Present svettszx
SPDX-FileCopyrightText: 2019-Present Contributors to Aerogram

SPDX-License-Identifier: AGPL-3.0-or-later
-->

[Aerogram](https://github.com/q876553007-arch/Aerogram) is a forked Matrix-based Messenger app built with Flutter. The goal is to keep the familiar experience of FluffyChat while making the app feel like a rebranded independent client.

### Links:

- 🌐 [[GitHub] Project repository](https://github.com/q876553007-arch/Aerogram)
- 🌍 [[Matrix] Join the community](https://matrix.to/#/#fluffy-space:matrix.org)
- 📰 [[GitHub] Follow svettszx](https://github.com/svettszx)
- 💝 [[Support] Support development](https://github.com/svettszx)

<a href='https://github.com/svettszx' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png' border='0' alt='GitHub profile of svettszx'></a>

### Screenshots:

<img src="https://github.com/krille-chan/fluffychat-website/blob/main/public/img/screenshot_mobile.png?raw=true" height="300">
<img src="https://github.com/krille-chan/fluffychat-website/blob/main/public/img/screenshot_desktop.png?raw=true" height="300">

# Features

- 📩 Send all kinds of messages, images and files
- 🤙 Video calls with Matrix RTC
- 🎙️ Voice messages
- 📍 Location sharing
- 🔔 Push notifications
- 💬 Unlimited private and public group chats
- 📣 Public channels with thousands of participants
- 🛠️ Feature rich group moderation including all matrix features
- 🔍 Discover and join public groups
- 🎨 Material You design
- 😄 Custom emotes and stickers
- 🌌 Spaces
- 🔐 End to end encryption
- 🔒 Encrypted chat backup
- 😀 Emoji verification & cross signing
... and much more.


# Installation

Please use the local build instructions below.

# Configuration and Mobile Device Management (MDM)

Aerogram supports configuration via MDM on Android and iOS and via a `config.json` file on web. An example configuration can be found in `config.sample.json`.

# How to build

1. You need [Flutter](https://flutter.dev) and [Rust](https://www.rust-lang.org/tools/install)

2. Clone the repo:
```
git clone https://github.com/q876553007-arch/Aerogram.git
cd Aerogram
```
3. Choose your target platform below and enable support for it.

4. Debug with: `flutter run`

### Android

* Build with: `flutter build apk`

### iOS / iPadOS

* Have a Mac with Xcode installed, and set up for Xcode-managed app signing
* Run `./scripts/build-ios.sh`

### Web

* Build with:
```bash
./scripts/prepare-web.sh
flutter build web --release
```

### Desktop (Linux, Windows, macOS)

* Enable Desktop support in Flutter: https://flutter.dev/desktop

* Build with one of these:
```bash
flutter build linux --release
flutter build windows --release
flutter build macos --release
```

## How to run integration tests

You need Docker installed locally. Run the preparation script before every test run:

```sh
./scripts/prepare_integration_test.sh
```

Then run all tests with:

```sh
flutter test integration_test/mobile_test.dart
```

# Special thanks

* <a href="https://github.com/fabiyamada">Fabiyamada</a> is a graphics designer and has made the Aerogram logo and banner.

* Also thanks to all translators and testers.

* The Matrix Foundation for making and maintaining the [emoji translations](https://github.com/matrix-org/matrix-spec/blob/main/data-definitions/sas-emoji.json) used for emoji verification.
