abstract class Users {
  const Users._();

  static const user1 = User(
    String.fromEnvironment(
      'USER1_NAME',
      defaultValue: 'alice',
    ),
    String.fromEnvironment(
      'USER1_PW',
      defaultValue: 'AliceInWonderland',
    ),
  );
  static const user2 = User(
    String.fromEnvironment(
      'USER2_NAME',
      defaultValue: 'bob',
    ),
    String.fromEnvironment(
      'USER2_PW',
      defaultValue: 'JoWirSchaffenDas',
    ),
  );
}

class User {
  final String name;
  final String password;

  const User(this.name, this.password);
}

const homeserver = 'http://${String.fromEnvironment(
  'HOMESERVER',
  defaultValue: 'localhost',
)}';
