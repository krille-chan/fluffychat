// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/app_switcher_privacy.dart';
import 'package:fluffychat/widgets/app_lock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const privacyCover = ValueKey('app_switcher_privacy_cover');
  const secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );

  Future<void> resetSettings() async {
    SharedPreferences.setMockInitialValues({});
    await AppSettings.init(loadWebConfigFile: false);
    await AppSettings.reset(loadWebConfigFile: false);
    AppSwitcherPrivacy.debugIsAndroid = false;
    AppSwitcherPrivacy.debugIsMobile = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, (_) async => null);
  }

  Future<void> pumpAppLock(WidgetTester tester, {String? pincode}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AppLockWidget(
          pincode: pincode,
          clients: const [],
          child: const Text('Private chat content'),
        ),
      ),
    );
  }

  setUp(resetSettings);

  test('app switcher privacy defaults to always', () {
    expect(
      AppSettings.appSwitcherPrivacy.appSwitcherPrivacyMode,
      AppSwitcherPrivacyMode.always,
    );
  });

  testWidgets('privacy cover follows lifecycle when always enabled', (
    tester,
  ) async {
    await pumpAppLock(tester);
    final appLock = tester.state<AppLock>(find.byType(AppLockWidget));

    expect(find.byKey(privacyCover), findsNothing);

    appLock.didChangeAppLifecycleState(AppLifecycleState.inactive);
    await tester.pump();

    expect(find.byKey(privacyCover), findsOneWidget);

    appLock.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();

    expect(find.byKey(privacyCover), findsNothing);
  });

  testWidgets('privacy cover is not shown when setting is off', (tester) async {
    await AppSettings.appSwitcherPrivacy.setAppSwitcherPrivacyMode(
      AppSwitcherPrivacyMode.off,
    );
    await pumpAppLock(tester);
    final appLock = tester.state<AppLock>(find.byType(AppLockWidget));

    appLock.didChangeAppLifecycleState(AppLifecycleState.paused);
    await tester.pump();

    expect(find.byKey(privacyCover), findsNothing);
  });

  testWidgets('app lock mode activates when pincode is set', (tester) async {
    await AppSettings.appSwitcherPrivacy.setAppSwitcherPrivacyMode(
      AppSwitcherPrivacyMode.appLock,
    );
    await pumpAppLock(tester);
    final appLock = tester.state<AppLock>(find.byType(AppLockWidget));

    await appLock.changePincode('1234');
    appLock.didChangeAppLifecycleState(AppLifecycleState.paused);
    await tester.pump();

    expect(find.byKey(privacyCover), findsOneWidget);
  });

  test('android platform channel sends privacy state', () async {
    AppSwitcherPrivacy.debugIsAndroid = true;
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(AppSwitcherPrivacy.channel, (call) async {
          calls.add(call);
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(AppSwitcherPrivacy.channel, null),
    );

    await AppSwitcherPrivacy.setState(enabled: true, foreground: false);

    expect(calls, hasLength(1));
    expect(calls.single.method, 'setState');
    expect(calls.single.arguments, {'enabled': true, 'foreground': false});
  });
}
