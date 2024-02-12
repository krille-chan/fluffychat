import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class SocialNetwork {
  final Widget logo; // The path to social media image
  final String name; // Social media name
  final String chatBot; // ChatBot for send demand
  bool? loading; // To find out if state is loading
  bool? connected; // To find out if state is disconnected
  bool error; // Bool to indicate if there is an error

  SocialNetwork({
    required this.logo,
    required this.name,
    required this.chatBot,
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
}

final List<SocialNetwork> socialNetwork = [
  SocialNetwork(
    logo: Logo(Logos.facebook_messenger),
    name: "Facebook Messenger",
    chatBot: "@facebookbot:",
  ),
  SocialNetwork(
    logo: Logo(Logos.instagram),
    name: "Instagram",
    chatBot: "@instagrambot:",
  ),
  SocialNetwork(
    logo: Logo(Logos.whatsapp),
    name: "WhatsApp",
    chatBot: "@whatsappbot:",
  ),
  SocialNetwork(
    logo: Logo(Logos.linkedin),
    name: "Linkedin",
    chatBot: "@linkedinbot:alpha.tawkie.fr",
  ),
];

// Model for WhatsApp message response
class WhatsAppResult {
  final String result;
  final String? code;
  final String? qrCode;

  WhatsAppResult(this.result, this.code, this.qrCode);
}
