/*
 *   Famedly
 *   Copyright (C) 2019, 2020, 2021 Famedly GmbH
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as
 *   published by the Free Software Foundation, either version 3 of the
 *   License, or (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

extension LocalizationForLocaleExtension on PlatformDispatcher {
  /// Loads the right L10n delegate for the current locale or falls back to a default otherwise. This reuses the Flutter locale selection algorithm. Usually you should not call this. Only do that if you have no access to a build context.
  Future<L10n> loadL10n() {
    final locale = basicLocaleListResolution(locales, L10n.supportedLocales);

    return L10n.delegate.load(locale);
  }
}
