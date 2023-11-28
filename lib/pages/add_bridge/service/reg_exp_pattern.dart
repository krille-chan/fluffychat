// For ping Response
class PingPatterns {
  // Instagram
  static RegExp instagramOnlineMatch = RegExp(r"MQTT connection is active");
  static RegExp instagramSuccessfullyMatch = RegExp(r"Successfully logged in");
  static RegExp instagramAlreadySuccessMatch =
      RegExp(r"You're already logged in");
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

  // Facebook Messenger
  static RegExp facebookOnlineMatch =
      RegExp(r"The Messenger MQTT listener is connected.");
  static RegExp facebookSuccessfullyMatch = RegExp(r"You're logged in as");
  static RegExp facebookNotLoggedMatch =
      RegExp(r"That command requires you to be logged in.");
  static RegExp facebookDisconnectMatch = RegExp(r"Successfully logged out");
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
}
