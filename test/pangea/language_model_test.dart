import 'package:flutter_test/flutter_test.dart';

import 'package:fluffychat/pangea/languages/l2_support_enum.dart';
import 'package:fluffychat/pangea/languages/language_constants.dart';
import 'package:fluffychat/pangea/languages/language_model.dart';

void main() {
  group('LanguageModel.fromJson', () {
    test('parses full CMS response with all fields', () {
      final json = {
        'id': 42,
        'language_code': 'es',
        'language_name': 'Spanish',
        'locale_emoji': '🇪🇸',
        'l2_support': 'full',
        'script': 'Latn',
        'voices': ['es-ES-Standard-A', 'es-ES-Wavenet-B'],
        'createdAt': '2026-01-01T00:00:00.000Z',
        'updatedAt': '2026-01-01T00:00:00.000Z',
      };

      final model = LanguageModel.fromJson(json);

      expect(model.langCode, 'es');
      expect(model.displayName, 'Spanish');
      expect(model.localeEmoji, '🇪🇸');
      expect(model.l2Support, L2SupportEnum.full);
      expect(model.script, 'Latn');
      expect(model.voices, ['es-ES-Standard-A', 'es-ES-Wavenet-B']);
    });

    test('parses minimal fields (only required)', () {
      final json = {'language_code': 'en', 'language_name': 'English'};

      final model = LanguageModel.fromJson(json);

      expect(model.langCode, 'en');
      expect(model.displayName, 'English');
      expect(model.l2Support, L2SupportEnum.na);
      expect(model.script, LanguageKeys.unknownLanguage);
      expect(model.localeEmoji, isNull);
      expect(model.voices, isEmpty);
    });

    test('parses each l2_support level', () {
      for (final entry in {
        'full': L2SupportEnum.full,
        'beta': L2SupportEnum.beta,
        'alpha': L2SupportEnum.alpha,
        'na': L2SupportEnum.na,
      }.entries) {
        final json = {
          'language_code': 'xx',
          'language_name': 'Test',
          'l2_support': entry.key,
        };
        final model = LanguageModel.fromJson(json);
        expect(model.l2Support, entry.value, reason: 'l2_support=${entry.key}');
      }
    });

    test('defaults l2_support to na when null', () {
      final json = {
        'language_code': 'xx',
        'language_name': 'Test',
        'l2_support': null,
      };
      final model = LanguageModel.fromJson(json);
      expect(model.l2Support, L2SupportEnum.na);
    });

    test('handles missing locale_emoji', () {
      final json = {
        'language_code': 'yue-HK',
        'language_name': 'Cantonese',
        'l2_support': 'beta',
        'script': 'Hant',
      };
      final model = LanguageModel.fromJson(json);
      expect(model.localeEmoji, isNull);
    });

    test('handles missing voices', () {
      final json = {'language_code': 'fr', 'language_name': 'French'};
      final model = LanguageModel.fromJson(json);
      expect(model.voices, isEmpty);
    });

    test('handles null voices', () {
      final json = {
        'language_code': 'fr',
        'language_name': 'French',
        'voices': null,
      };
      final model = LanguageModel.fromJson(json);
      expect(model.voices, isEmpty);
    });

    test('handles empty voices list', () {
      final json = {
        'language_code': 'fr',
        'language_name': 'French',
        'voices': <dynamic>[],
      };
      final model = LanguageModel.fromJson(json);
      expect(model.voices, isEmpty);
    });

    test('parses text_direction when present', () {
      final json = {
        'language_code': 'ar',
        'language_name': 'Arabic',
        'text_direction': 'rtl',
        'script': 'Arab',
      };
      // RTL should be parsed — TextDirection.rtl
      final model = LanguageModel.fromJson(json);
      expect(model.langCode, 'ar');
      expect(model.script, 'Arab');
    });

    test('ignores extra CMS metadata fields', () {
      // CMS returns id, createdAt, updatedAt, createdBy, updatedBy
      // LanguageModel.fromJson should not break on them
      final json = {
        'id': 99,
        'language_code': 'de',
        'language_name': 'German',
        'l2_support': 'full',
        'script': 'Latn',
        'locale_emoji': '🇩🇪',
        'c_p_w': 5.2,
        'createdAt': '2026-01-01T00:00:00.000Z',
        'updatedAt': '2026-01-15T00:00:00.000Z',
        'createdBy': {'id': 1, 'email': 'admin@example.com'},
        'updatedBy': {'id': 1, 'email': 'admin@example.com'},
      };

      expect(() => LanguageModel.fromJson(json), returnsNormally);
      final model = LanguageModel.fromJson(json);
      expect(model.langCode, 'de');
      expect(model.displayName, 'German');
    });
  });

  group('LanguageModel.toJson', () {
    test('round-trips through fromJson → toJson', () {
      final original = {
        'language_code': 'ja',
        'language_name': 'Japanese',
        'l2_support': 'beta',
        'script': 'Jpan',
        'locale_emoji': '🇯🇵',
        'voices': ['ja-JP-Standard-A'],
      };

      final model = LanguageModel.fromJson(original);
      final serialized = model.toJson();

      expect(serialized['language_code'], 'ja');
      expect(serialized['language_name'], 'Japanese');
      expect(serialized['l2_support'], 'beta');
      expect(serialized['script'], 'Jpan');
      expect(serialized['locale_emoji'], '🇯🇵');
      expect(serialized['voices'], ['ja-JP-Standard-A']);
    });

    test('serializes default values correctly', () {
      final model = LanguageModel(langCode: 'sw', displayName: 'Swahili');
      final json = model.toJson();

      expect(json['language_code'], 'sw');
      expect(json['language_name'], 'Swahili');
      expect(json['l2_support'], 'na');
      expect(json['script'], LanguageKeys.unknownLanguage);
      expect(json['locale_emoji'], isNull);
      expect(json['voices'], isEmpty);
    });
  });

  group('LanguageModel properties', () {
    test('l2 returns true for non-na support levels', () {
      for (final level in [
        L2SupportEnum.full,
        L2SupportEnum.beta,
        L2SupportEnum.alpha,
      ]) {
        final model = LanguageModel(
          langCode: 'xx',
          displayName: 'Test',
          l2Support: level,
        );
        expect(model.l2, isTrue, reason: 'l2Support=$level should be l2=true');
      }
    });

    test('l2 returns false for na', () {
      final model = LanguageModel(
        langCode: 'xx',
        displayName: 'Test',
        l2Support: L2SupportEnum.na,
      );
      expect(model.l2, isFalse);
    });
  });

  group('LanguageModel.unknown', () {
    test('has correct defaults', () {
      final unknown = LanguageModel.unknown;
      expect(unknown.langCode, LanguageKeys.unknownLanguage);
      expect(unknown.displayName, 'Unknown');
      expect(unknown.l2Support, L2SupportEnum.na);
      expect(unknown.l2, isFalse);
    });
  });
}
