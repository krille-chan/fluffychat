// For ping Response
class PingPatterns {
  // Instagram
  static RegExp instagramOnlineMatch = RegExp(r".*You're logged into Meta");
  static RegExp instagramNotLoggedMatch = RegExp(r"You're not logged in");
  static RegExp instagramNotLoggedAnymoreMatch =
      RegExp(r"You were logged in at some point, but are not anymore");

  // WhatsApp
  static RegExp whatsAppOnlineMatch = RegExp(r"connection to WhatsApp OK");
  static RegExp whatsAppNotLoggedMatch =
      RegExp(r"You're not logged into WhatsApp");
  static RegExp whatsAppLoggedButNotConnectedMatch =
      RegExp(r"but not logged in.");

  // Facebook Messenger
  static RegExp facebookOnlineMatch = RegExp(r".*You're logged into Meta");
  static RegExp facebookNotLoggedMatch = RegExp(r"You're not logged in");
  static RegExp facebookNotLoggedAnymoreMatch =
      RegExp(r"You were logged in at some point, but are not anymore");

  // Linkedin
  static RegExp linkedinOnlineMatch = RegExp(r"You are logged in as");
  static RegExp linkedinNotLoggedMatch = RegExp(r"You are not logged in");
}

// For login response
class LoginRegex {
  // Instagram
  static final RegExp instagramSuccessMatch = RegExp(r"Logged in as ([\w\s]+) \((\d+)\)");
  static final RegExp instagramAlreadySuccessMatch =
      RegExp(r"You're already logged in");

  // WhatsApp
  static final RegExp whatsAppSuccessMatch = RegExp(r"Successfully logged");
  static final RegExp whatsAppAlreadySuccessMatch =
      RegExp(r"You're already logged in");
  static final RegExp whatsAppMeansCodeMatch =
      RegExp(r"Scan the code below or enter the following code");
  static final RegExp whatsAppTimeoutMatch =
      RegExp(r"Login timed out. Please restart the login");

  // Facebook
  static final RegExp facebookSuccessMatch = RegExp(r"Logged in as ([\w\s]+) \((\d+)\)");
  static final RegExp facebookAlreadyConnectedMatch =
      RegExp(r"You're already logged in");

  static final RegExp loginUrlMetaMatch = RegExp(r'^Login URL:');

  // Linkedin
  static final RegExp linkedinSuccessMatch = RegExp(r"Successfully logged in");
  static final RegExp linkedinAlreadySuccessMatch =
      RegExp(r"You're already logged in");

  static final RegExp linkedinNotLogged = RegExp(r"You are not logged in");
}

// For logout response
class LogoutRegex {
  // Instagram
  static final RegExp instagramSuccessMatch =
      RegExp(r"Logged out");
  static final RegExp instagramAlreadyLogoutMatch =
      RegExp(r"You weren't logged in, but deleted session anyway");

  // WhatsApp
  static final RegExp whatsappSuccessMatch =
      RegExp(r"Logged out successfully.");
  static final RegExp whatsappAlreadyLogoutMatch =
      RegExp(r"You're not logged in.");

  // Facebook Messenger
  static final RegExp facebookSuccessMatch =
      RegExp(r"Logged out");
  static final RegExp facebookAlreadyLogoutMatch =
      RegExp(r"You weren't logged in, but deleted session anyway");

  // Linkedin
  static final RegExp linkedinSuccessMatch = RegExp(r"Successfully logged out");
  static final RegExp linkedinAlreadyLogoutMatch =
      RegExp(r"You are not logged in.");
}

class RegExpPingPatterns {
  final RegExp onlineMatch;
  final RegExp notLoggedMatch;
  final RegExp? notLoggedAnymoreMatch;
  final RegExp? mQTTNotMatch;

  RegExpPingPatterns(this.onlineMatch, this.notLoggedMatch,
      [this.notLoggedAnymoreMatch,
      this.mQTTNotMatch]); // Modification de cette ligne
}
