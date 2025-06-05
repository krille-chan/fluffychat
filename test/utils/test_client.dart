// ignore_for_file: depend_on_referenced_packages

import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Client> prepareTestClient({
  bool loggedIn = false,
  Uri? homeserver,
  String id = 'FluffyChat Widget Test',
}) async {
  homeserver ??= Uri.parse('https://fakeserver.notexisting');
  final client = Client(
    'FluffyChat Widget Tests',
    httpClient: FakeMatrixApi()
      ..api['GET']!['/.well-known/matrix/client'] = (req) => {},
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
  await client.checkHomeserver(homeserver);
  if (loggedIn) {
    await client.login(
      LoginType.mLoginToken,
      identifier: AuthenticationUserIdentifier(user: '@alice:example.invalid'),
      password: '1234',
    );
  }
  return client;
}
