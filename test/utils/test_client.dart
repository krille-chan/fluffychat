import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/fluffy_client.dart';

Future<FluffyClient> testClient({
  bool loggedIn = false,
  String homeserver = 'https://fakeserver.notexisting',
  String id = 'FluffyChat Widget Test',
}) async {
  final client = FluffyClient(testMode: true);
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
