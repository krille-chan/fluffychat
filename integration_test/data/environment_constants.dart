const homeserver = String.fromEnvironment(
  'HOMESERVER',
  defaultValue: '10.0.2.2',
);
const user1Name = String.fromEnvironment('USER1_NAME', defaultValue: 'alice');
const user1Pw = String.fromEnvironment(
  'USER1_PW',
  defaultValue: 'AliceInWonderland',
);
const user2Name = String.fromEnvironment('USER2_NAME', defaultValue: 'bob');
const user2Pw = String.fromEnvironment(
  'USER2_PW',
  defaultValue: 'JoWirSchaffenDas',
);
