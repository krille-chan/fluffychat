import 'package:fluffychat/utils/database/flutter_famedly_sdk_hive_database.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix_api_lite/fake_matrix_api.dart';

Future<Client> prepareTestClient({
  bool loggedIn = false,
  String homeserver = 'https://fakeserver.notexisting',
  String id = 'FluffyChat Widget Test',
}) async {
  final client = Client(
    'FluffyChat Widget Tests',
    httpClient: FakeMatrixApi(),
    enableE2eeRecovery: true,
    verificationMethods: {
      KeyVerificationMethod.numbers,
      KeyVerificationMethod.emoji,
    },
    importantStateEvents: <String>{
      'im.ponies.room_emotes', // we want emotes to work properly
    },
    databaseBuilder: FlutterFamedlySdkHiveDatabase.hiveDatabaseBuilder,
    supportedLoginTypes: {
      AuthenticationTypes.password,
      AuthenticationTypes.sso
    },
  );
  if (homeserver != null) {
    await client.checkHomeserver(homeserver);
  }
  if (loggedIn) {
    await client.login(
      identifier: AuthenticationUserIdentifier(user: '@alice:example.invalid'),
      password: '1234',
    );
  }
  return client;
}
