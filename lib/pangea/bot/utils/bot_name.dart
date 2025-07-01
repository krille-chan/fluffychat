import 'package:fluffychat/pangea/common/config/environment.dart';

class BotName {
  static String get byEnvironment => Environment.botName != null
      ? Environment.botName!
      : Environment.isStagingEnvironment
          ? "@bot:staging.pangea.chat"
          : "@bot:pangea.chat";
  static String get localBot => "@matrix-bot-test:staging.pangea.chat";
}
