import 'package:fluffychat/pangea/config/environment.dart';

class BotName {
  static String get byEnvironment =>
      Environment.isStaging ? "@bot:staging.pangea.chat" : "@bot:pangea.chat";
  static String get localBot => "@matrix-bot-test:staging.pangea.chat";
}
