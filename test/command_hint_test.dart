import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'utils/test_client.dart';

void main() async {
  test('Check for missing /command hints', () async {
    final translated =
        jsonDecode(File('assets/l10n/intl_en.arb').readAsStringSync())
            .keys
            .where((String k) => k.startsWith('commandHint_'))
            .map((k) => k.replaceFirst('commandHint_', ''));
    final commands = (await prepareTestClient()).commands.keys;
    final missing = commands.where((c) => !translated.contains(c)).toList();

    expect(
      0,
      missing.length,
      reason:
          'missing hints for $missing\nAdding hints? See scripts/generate_command_hints_glue.sh',
    );
  });
}
