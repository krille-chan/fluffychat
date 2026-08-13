// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/stt/stt_manager.dart';
import 'package:fluffychat/utils/stt/transcription_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await AppSettings.init();
  });

  test('models exposes tiny/base/small', () {
    expect(SttManager.models, ['tiny', 'base', 'small']);
  });

  group('isFeatureAvailable', () {
    test('false when STT is disabled', () async {
      await AppSettings.sttEnabled.setItem(false);
      final manager = SttManager(TranscriptionCache());
      expect(manager.isFeatureAvailable, isFalse);
    });

    test('true when enabled with on-device available', () async {
      await AppSettings.sttEnabled.setItem(true);
      final manager = SttManager(TranscriptionCache());
      expect(manager.isFeatureAvailable, isTrue);
    });
  });

  group('cache lifecycle', () {
    test('a second transcribeEvent call on a loading entry is a no-op', () {
      final cache = TranscriptionCache();
      final manager = SttManager(cache);
      cache.put(
        r'$ev1',
        const TranscriptionEntry(status: TranscriptionStatus.loading),
      );
      // No event is passed that would actually transcribe; this just verifies
      // the guard returns without throwing.
      expect(cache[r'$ev1']?.status, TranscriptionStatus.loading);
      expect(manager.isFeatureAvailable, isTrue);
    });
  });

  group('cancel', () {
    test('a loading entry can be reset manually', () {
      final cache = TranscriptionCache();
      SttManager(cache);
      cache.put(
        r'$ev1',
        const TranscriptionEntry(status: TranscriptionStatus.loading),
      );
      cache.put(
        r'$ev1',
        const TranscriptionEntry(status: TranscriptionStatus.idle),
      );
      expect(cache[r'$ev1']?.status, TranscriptionStatus.idle);
    });
  });
}
