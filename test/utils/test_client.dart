// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

// ignore_for_file: depend_on_referenced_packages

import 'package:fluffychat/config/setting_keys.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'set_up_vodozemac.dart';

// key @test:fakeServer.notExisting
const pickledOlmAccount =
    'huxcPifHlyiQsX7cZeMMITbka3hLeUT3ss6DLL6dV7knaD4wgAYK6gcWknkixnX8C5KMIyxzytxiNqAOhDFRE5NsET8hr2dQ8OvXX7M95eQ7/3dPi7FkPUIbvneTSGgJYNDxJdHsDJ8OBHZ3BoqUJFDbTzFfVJjEzN4G9XQwPDafZ2p5WyerOK8Twj/rvk5N+ERmkt1XgVLQl66we/BO1ugTeM3YpDHm5lTzFUitJGTIuuONsKG9mmzdAmVUJ9YIrSxwmOBdegbGA+LAl5acg5VOol3KxRgZUMJQRQ58zpBAs72oauHizv1QVoQ7uIUiCUeb9lym+TEjmApvhru/1CPHU90K5jHNZ57wb/4V9VsqBWuoNibzDWG35YTFLcx0o+1lrCIjm1QjuC0777G+L1HNw5wnppV3z/k0YujjuPS3wvOA30TjHg';

class _FakeNotifications extends FlutterLocalNotificationsPlatform {}

Future<Client> prepareTestClient({
  bool loggedIn = false,
  Uri? homeserver,
  String id = 'FluffyChat Widget Test',
}) async {
  await setUpVodozemac();
  SharedPreferences.setMockInitialValues({});
  FlutterLocalNotificationsPlatform.instance = _FakeNotifications();
  await AppSettings.init(loadWebConfigFile: false);

  homeserver ??= Uri.parse('https://fakeserver.notexisting');
  final client = Client(
    'FluffyChat Widget Tests',
    httpClient: FakeMatrixApi(),
    verificationMethods: {
      KeyVerificationMethod.numbers,
      KeyVerificationMethod.emoji,
    },
    importantStateEvents: <String>{
      'im.ponies.room_emotes', // we want emotes to work properly
    },
    database: await MatrixSdkDatabase.init(
      'test',
      database: await databaseFactoryFfi.openDatabase(':memory:'),
      sqfliteFactory: databaseFactoryFfi,
    ),
    supportedLoginTypes: {
      AuthenticationTypes.password,
      AuthenticationTypes.sso,
    },
  );
  await client.init(
    newHomeserver: Uri.parse('https://fakeServer.notExisting'),
    newDeviceID: 'ABCD1234',
    newDeviceName: 'Screenshot Tester',
    newToken: '1234',
    newUserID: '@test:fakeServer.notExisting',
    newOlmAccount: pickledOlmAccount,
  );
  return client;
}
