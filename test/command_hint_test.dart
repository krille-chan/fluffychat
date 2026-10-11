// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:matrix/matrix.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  test('Check for missing /command hints', () async {
    final translated =
        jsonDecode(File('lib/l10n/intl_en.arb').readAsStringSync()).keys
            .where((String k) => k.startsWith('commandHint_'))
            .map((k) => k.replaceFirst('commandHint_', ''));
    final commands = (Client(
      'commands',
      database: await MatrixSdkDatabase.init(
        'test',
        database: await databaseFactoryFfi.openDatabase(':memory:'),
        sqfliteFactory: databaseFactoryFfi,
      ),
    )).commands.keys;
    final missing = commands.where((c) => !translated.contains(c)).toList();

    expect(
      0,
      missing.length,
      reason:
          'missing hints for $missing\nAdding hints? See scripts/generate_command_hints_glue.sh',
    );
  });
}
