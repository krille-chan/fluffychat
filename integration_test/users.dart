abstract class Users {
  const Users._();
  static const alice = User('alice', 'AliceInWonderland');
  static const bob = User('bob', 'JoWirSchaffenDas');
  static const trudy = User('trudy', 'HaveIBeenPwned');
}

class User {
  final String name;
  final String password;

  const User(this.name, this.password);
}

// https://stackoverflow.com/a/33088657
const homeserver = 'http://10.0.2.2:8008';
