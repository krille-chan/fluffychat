class RegExpPatterns {

  // For ping Response
  static RegExp pingWhatsAppOnlineMatch = RegExp(r"connection to WhatsApp OK");
  static RegExp pingWhatsAppSuccessfullyMatch = RegExp(r"Successfully logged in");
  static RegExp pingWhatsAppAlreadySuccessMatch = RegExp(r"You're already logged in");
  static RegExp pingWhatsAppNotLoggedMatch = RegExp(r"You're not logged into WhatsApp");
  static RegExp pingWhatsAppDisconnectMatch = RegExp(r"Logged out successfully");
  static RegExp pingWhatsAppConnectedButNotLoggedMatch = RegExp(r"Connected to WhatsApp, but not logged in");

  static RegExp pingFacebookOnlineMatch = RegExp(r"The Messenger MQTT listener is connected.");
  static RegExp pingFacebookSuccessfullyMatch = RegExp(r"You're logged in as");
  static RegExp pingFacebookNotLoggedMatch = RegExp(r"That command requires you to be logged in.");
  static RegExp pingFacebookDisconnectMatch = RegExp(r"Successfully logged out");

  static RegExp pingInstagramOnlineMatch = RegExp(r"MQTT connection is active");
  static RegExp pingInstagramSuccessfullyMatch = RegExp(r"Successfully logged in");
  static RegExp pingInstagramAlreadySuccessMatch = RegExp(r"You're already logged in");
  static RegExp pingInstagramNotLoggedMatch = RegExp(r"You're not logged into Instagram");
  static RegExp pingInstagramDisconnectMatch = RegExp(r"Successfully logged out");

}
