// For ping Response
class PingPatterns {
  // Instagram
  static RegExp instagramOnlineMatch = RegExp(r"MQTT connection is active");
  static RegExp instagramNotLoggedMatch = RegExp(r"You're not logged in");

  // WhatsApp
  static RegExp whatsAppOnlineMatch = RegExp(r"connection to WhatsApp OK");
  static RegExp whatsAppNotLoggedMatch =
      RegExp(r"You're not logged into WhatsApp");
  static RegExp whatsAppLoggedButNotConnectedMatch =
      RegExp(r"but you don't have a WhatsApp connection.");

  // Facebook Messenger
  static RegExp facebookOnlineMatch = RegExp(r".*You're logged into Meta");
  static RegExp facebookNotLoggedMatch = RegExp(r"You're not logged in");
}

// For login response
class LoginRegex {
  // Instagram
  static final RegExp instagramSuccessMatch = RegExp(r"Successfully logged in");
  static final RegExp instagramAlreadySuccessMatch =
      RegExp(r"You're already logged in");

  static final RegExp instagramUsernameErrorMatch = RegExp(r"Invalid username");
  static final RegExp instagramPasswordErrorMatch =
      RegExp(r"Incorrect password");
  static final RegExp instagramNameOrPasswordErrorMatch =
      RegExp(r"Incorrect username or password");
  static final RegExp instagramAccountNotExistErrorMatch = RegExp(
      r"The username you entered doesn't appear to belong to an account. Please check your username and try again.");
  static final RegExp instagramRateLimitErrorMatch =
      RegExp(r"rate_limit_error");

  static final RegExp instagramTwoFactorMatch =
      RegExp(r"Send the code from your authenticator app here.");
  static final RegExp instagramIncorrectTwoFactorMatch =
      RegExp(r"Invalid 2-factor authentication code. Please try again");

  // WhatsApp
  static final RegExp whatsAppSuccessMatch = RegExp(r"Successfully logged");
  static final RegExp whatsAppAlreadySuccessMatch =
      RegExp(r"You're already logged in");
  static final RegExp whatsAppMeansCodeMatch =
      RegExp(r"Scan the code below or enter the following code");
  static final RegExp whatsAppTimeoutMatch =
      RegExp(r"Login timed out. Please restart the login");

  // Facebook
  static final RegExp facebookSuccessMatch = RegExp(r".*Successfully logged");
  static final RegExp facebookAlreadyConnectedMatch =
      RegExp(r"You're already logged in");
  static final RegExp facebookPasteCookies =
      RegExp(r'^.*Paste your cookies here.*');
}

// For logout response
class LogoutRegex {
  // Instagram
  static final RegExp instagramSuccessMatch =
      RegExp(r"Successfully logged out");
  static final RegExp instagramAlreadyLogoutMatch =
      RegExp(r"That command requires you to be logged in.");

  // WhatsApp
  static final RegExp whatsappSuccessMatch =
      RegExp(r"Logged out successfully.");
  static final RegExp whatsappAlreadyLogoutMatch =
      RegExp(r"You're not logged in.");

  // Facebook Messenger
  static final RegExp facebookSuccessMatch = RegExp(r".*Disconnected");
  static final RegExp facebookAlreadyLogoutMatch =
      RegExp(r"That command requires you to be logged in.");
}
