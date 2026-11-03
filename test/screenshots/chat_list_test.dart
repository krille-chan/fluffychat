// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/golden_locales.dart';
import '../utils/test_client.dart';

void main() {
  group('ChatList Golden', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    late Client client;

    setUpAll(() async {
      client = await prepareTestClient();
      client.backgroundSync = false;
    });
    testGoldens('ChatList Screenshot', (tester) async {
      for (final locale in goldenLocals) {
        for (final device in GoldenScreenshotDevices.values) {
          for (final themeMode in {ThemeMode.dark, ThemeMode.light}) {
            client.userDeviceKeys.clear(); // Hide unverified warning
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('theme_mode', themeMode.name);
            await tester.pumpWidget(
              ScreenshotApp.withConditionalTitlebar(
                title: AppSettings.applicationName.value,
                device: device.device,
                home: FluffyChatApp(
                  clients: [client],
                  store: prefs,
                  appLockSettings: (pincode: null, useBiometrics: false),
                  locale: locale,
                ),
              ),
            );
            await tester.pump(const Duration(milliseconds: 100));

            await tester.loadAssets();
            await tester.pump(const Duration(milliseconds: 100));
            await tester.expectScreenshot(
              device.device,
              '${themeMode.name}_chat_list_page',
              finder: find.byType(MaterialApp).first,
              langCode: locale.languageCode,
            );
            await tester.pumpWidget(const SizedBox());
            await tester.pump(const Duration(milliseconds: 100));
          }
        }
      }
    });
  });
}
