# SPDX-FileCopyrightText: 2019-Present Christian Kußowski
# SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
#
# SPDX-License-Identifier: AGPL-3.0-or-later

flutter doctor
flutter config --enable-windows-desktop
flutter clean
flutter pub get

flutter build windows --release -v

