<!--
SPDX-FileCopyrightText: 2019-Present Christian Kußowski
SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat

SPDX-License-Identifier: AGPL-3.0-or-later
-->

<img src="https://raw.githubusercontent.com/krille-chan/fluffychat/refs/heads/main/assets/logo/img/banner.png">

[FluffyChat](https://fluffychat.im) is an open source, nonprofit and cute [[matrix](https://matrix.org)] client written in [Flutter](https://flutter.dev). The goal of the app is to create an easy to use instant messenger which is open source and accessible for everyone.

### Links:

- 🌐 [[Weblate] Translate FluffyChat into your language](https://hosted.weblate.org/projects/fluffychat/)
- 🌍 [[m] Join the community](https://matrix.to/#/#fluffy-space:matrix.org)
- 📰 [[Mastodon] Get updates on social media](https://troet.cafe/@krille)
- 💝 [[Liberapay] Support FluffyChat development](https://de.liberapay.com/KrilleChritzelius)

<a href='https://ko-fi.com/krille' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi5.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

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

Please visit the website for installation instructions:

- https://fluffychat.im

# Configuration and Mobile Device Management (MDM)

FluffyChat supports configuration via MDM on Android&iOS (since v2.10.0) and via a config.json file on web. You can see the populated configuration for MDM on Android in this file under `/android/app/src/main/res/xml/app_restrictions.xml`.
An example configuration can be found in the `config.sample.json` file.

# How to build

1. To build FluffyChat you need [Flutter](https://flutter.dev) and [Rust](https://www.rust-lang.org/tools/install)

2. Clone the repo:
```
git clone https://github.com/krille-chan/fluffychat.git
cd fluffychat
```
3. Debug on your platform with: `flutter run`

### Web

* Execute once before run or build:
```bash
./scripts/prepare-web.sh # To install Vodozemac
```

* Optionally configure by serving a `config.json` at the same path as fluffychat.
  An example can be found at `config.sample.json`. All values there are optional.
  **Please only the values, you really need**. If you e.g. only want
  to change the default homeserver, then only modify the `defaultHomeserver` key.

## How to run integration tests

You need to have docker installed locally! Run the preparation script before every test run:

```sh
./scripts/prepare_integration_test.sh
```

Then run all tests with:

```sh
flutter test integration_test/mobile_test.dart
```


# Special thanks

* <a href="https://github.com/fabiyamada">Fabiyamada</a> is a graphics designer and has made the fluffychat logo and the banner. Big thanks for her great designs.

* Also thanks to all translators and testers! With your help, fluffychat is now available in more than 12 languages.

* The Matrix Foundation for making and maintaining the [emoji translations](https://github.com/matrix-org/matrix-spec/blob/main/data-definitions/sas-emoji.json) used for emoji verification, licensed Apache 2.0

* Special thanks to MTRNord, Sorunome and Advocatux.