// For ping Response
class PingPatterns {
  // Instagram
  static RegExp instagramOnlineMatch = RegExp(r"MQTT connection is active");
  static RegExp instagramMQTTNotMatch = RegExp(r"MQTT not connected");
  static RegExp instagramSuccessfullyMatch = RegExp(r"Successfully logged in");
  static RegExp instagramAlreadySuccessMatch =
      RegExp(r"You're already logged in");
  static RegExp instagramSyncComplete = RegExp(r"Synchronization complete");
  static RegExp instagramNotLoggedMatch =
      RegExp(r"You're not logged into Instagram");
  static RegExp instagramDisconnectMatch = RegExp(r"Successfully logged out");

  // WhatsApp
  static RegExp whatsAppOnlineMatch = RegExp(r"connection to WhatsApp OK");
  static RegExp whatsAppSuccessfullyMatch = RegExp(r"Successfully logged in");
  static RegExp whatsAppAlreadySuccessMatch =
      RegExp(r"You're already logged in");
  static RegExp whatsAppNotLoggedMatch =
      RegExp(r"You're not logged into WhatsApp");
  static RegExp whatsAppDisconnectMatch = RegExp(r"Logged out successfully");
  static RegExp whatsAppConnectedButNotLoggedMatch =
      RegExp(r"Connected to WhatsApp, but not logged in");
  static RegExp whatsAppLoggedButNotConnectedMatch =
      RegExp(r"but you don't have a WhatsApp connection.");

  // Facebook Messenger
  static RegExp facebookOnlineMatch =
      RegExp(r"The Messenger MQTT listener is connected.");
  static RegExp facebookMQTTNotMatch =
      RegExp(r"You don't have a Messenger MQTT connection.");
  static RegExp facebookSuccessfullyMatch = RegExp(r"You're logged in as");
  static RegExp facebookNotLoggedMatch =
      RegExp(r"That command requires you to be logged in.");
  static RegExp facebookDisconnectMatch = RegExp(r"Successfully logged out");

  // Linkedin
  static RegExp linkedinOnlineMatch = RegExp(r"You are logged in as");
  static RegExp linkedinNotLoggedMatch = RegExp(r"You are not logged in");
  static RegExp linkedinDisconnectMatch = RegExp(r"Successfully logged out");
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
  static final RegExp facebookSuccessMatch = RegExp(r"Successfully logged in");
  static final RegExp facebookSendPasswordMatch =
      RegExp(r"Please send your password here to log in");
  static final RegExp facebookTwoFactorMatch =
      RegExp(r"You have two-factor authentication turned on.");
  static final RegExp facebookNameOrPasswordErrorMatch =
      RegExp(r"Invalid username or password");
  static final RegExp facebookRateLimitErrorMatch = RegExp(r"rate_limit_error");
  static final RegExp facebookAlreadyConnectedMatch =
      RegExp(r"You're already logged in");
  static final RegExp facebookIncorrectTwoFactorMatch =
      RegExp(r"Incorrect two-factor authentication code. Please try again");

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
      RegExp(r"Successfully logged out");
  static final RegExp instagramAlreadyLogoutMatch =
      RegExp(r"That command requires you to be logged in.");

  // WhatsApp
  static final RegExp whatsappSuccessMatch =
      RegExp(r"Logged out successfully.");
  static final RegExp whatsappAlreadyLogoutMatch =
      RegExp(r"You're not logged in.");

  // Facebook Messenger
  static final RegExp facebookSuccessMatch = RegExp(r"Successfully logged out");
  static final RegExp facebookAlreadyLogoutMatch =
      RegExp(r"That command requires you to be logged in.");

  // Linkedin
  static final RegExp linkedinSuccessMatch = RegExp(r"Successfully logged out");
  static final RegExp linkedinAlreadyLogoutMatch =
  RegExp(r"You are not logged in.");
}
