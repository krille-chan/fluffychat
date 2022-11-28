import 'dart:io';

abstract class Users {
  const Users._();

  static final user1 = User(
    Platform.environment['USER1_NAME'] ?? 'alice',
    Platform.environment['USER1_PW'] ?? 'AliceInWonderland',
  );
  static final user2 = User(
    Platform.environment['USER2_NAME'] ?? 'bob',
    Platform.environment['USER2_PW'] ?? 'JoWirSchaffenDas',
  );
}

class User {
  final String name;
  final String password;

  const User(this.name, this.password);
}

final homeserver =
    'http://${Platform.environment['HOMESERVER'] ?? 'localhost'}';
