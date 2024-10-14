import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tawkie/config/themes.dart';

class SocialNetwork {
  final Widget logo; // The path to social media image
  final String chatIconPath; // The path to chat icon asset
  final Color color; // The color of the social media displayed in chat list
  final String name; // Social media name
  final bool available; // Whether to display on add bridge page
  final String chatBot; // ChatBot for send demand
  final String mxidPrefix; // The matrix ID prefix used to identify puppets
  final String
      displayNameSuffix; // The `(Network)` suffix to remove from displayname)
  final String? urlLogin;
  final String? urlRedirect;
  final RegExp? urlRedirectPattern;
  final String flowId;
  final String apiPath;
  bool loading; // To find out if state is loading
  bool connected; // To find out if state is disconnected
  bool error; // Bool to indicate if there is an error

  SocialNetwork({
    required this.logo,
    required this.chatIconPath,
    required this.color,
    required this.name,
    required this.available,
    required this.chatBot,
    required this.mxidPrefix,
    this.displayNameSuffix = "",
    this.urlLogin,
    this.urlRedirect,
    this.urlRedirectPattern,
    this.flowId = "",
    this.apiPath = "",
    this.loading = true, // Default value true for loading
    this.connected = false, // Default value false for connected
    this.error = false, // Défaut à false
  });

  // How to update connection results
  void updateConnectionResult(bool connectedValue) {
    loading = false;
    connected = connectedValue;
  }

  // Error update
  void setError(bool errorValue) {
    loading = false;
    error = errorValue;
  }

  // Remove `(Network)` suffix from displayname
  String removeSuffix(String displayname) {
    if (displayNameSuffix.isNotEmpty) {
      return displayname.replaceAll(displayNameSuffix, ''); // Delete (Network)
    }
    return displayname;
  }
}

// Model for WhatsApp message response
class WhatsAppResult {
  final String result;
  final String? code;
  final String? qrCode;

  WhatsAppResult(this.result, this.code, this.qrCode);
}

class SocialNetworkManager {
  static final List<SocialNetwork> socialNetworks = [
    SocialNetwork(
      logo: Logo(Logos.facebook_messenger),
      chatIconPath: "assets/facebook-messenger.png",
      color: FluffyThemes.facebookColor,
      name: "Facebook Messenger",
      available: true,
      chatBot: "@messenger2bot:",
      displayNameSuffix: "(FB)",
      mxidPrefix: "@messenger2_",
      urlLogin: "https://www.messenger.com/login/",
      urlRedirect: "https://www.messenger.com/t/",
      urlRedirectPattern: RegExp(r'^https:\/\/www\.messenger\.com\/.*t\/.*$'),
      flowId: "cookies-messenger",
      apiPath: "matrix-mautrix-meta-messenger",
    ),
    SocialNetwork(
      logo: Logo(Logos.instagram),
      chatIconPath: "assets/instagram.png",
      color: FluffyThemes.instagramColor,
      name: "Instagram",
      available: true,
      chatBot: "@instagram2bot:",
      displayNameSuffix: "(IG)",
      mxidPrefix: "@instagram2_",
      urlLogin: "https://www.instagram.com/accounts/login/",
      urlRedirect: "https://www.instagram.com/",
      urlRedirectPattern: RegExp(r'^https:\/\/www\.instagram\.com\/.*$'),
    ),
    SocialNetwork(
      logo: Logo(Logos.whatsapp),
      chatIconPath: "assets/whatsapp.png",
      color: FluffyThemes.whatsAppColor,
      name: "WhatsApp",
      available: true,
      chatBot: "@whatsappbot:",
      displayNameSuffix: "(WhatsApp)",
      mxidPrefix: "@whatsapp_",
    ),
    SocialNetwork(
      logo: Logo(Logos.linkedin),
      chatIconPath: "assets/linkedin.png",
      name: "Linkedin",
      available: true,
      color: FluffyThemes.linkedinColor,
      chatBot: "@linkedinbot:",
      displayNameSuffix: "(LinkedIn)",
      mxidPrefix: "@linkedin_",
      urlLogin: "https://www.linkedin.com/login/",
      urlRedirect: "https://www.linkedin.com/feed/",
      urlRedirectPattern: RegExp(r'^https:\/\/www\.linkedin\.com\/feed\/.*$'),
    ),
    SocialNetwork(
      logo: Container(),
      chatIconPath: "assets/discord.png",
      name: "Discord",
      available: false,
      color: FluffyThemes.dicordColor,
      chatBot: "@discordbot:",
      mxidPrefix: "@discord_",
    ),
    SocialNetwork(
      logo: Container(),
      chatIconPath: "assets/signal.png",
      name: "Signal",
      available: false,
      color: FluffyThemes.signalColor,
      chatBot: "@signalbot:",
      mxidPrefix: "@signal_",
    ),
    // Tawkie must be last to be default
    SocialNetwork(
      logo: Container(),
      chatIconPath: "assets/tawkie.png",
      name: "Tawkie",
      available: false,
      color: FluffyThemes.tawkieColor,
      chatBot: "",
      mxidPrefix: "@",
    ),
  ];

  static SocialNetwork? fromName(String name) {
    return socialNetworks.firstWhere(
      (network) => network.name == name,
    );
  }

  static bool isBridgeBotId(String? matrixId) {
    if (matrixId == null) return false;

    return socialNetworks.any(
      (network) =>
          network.chatBot.isNotEmpty && matrixId.startsWith(network.chatBot),
    );
  }
}
