import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class SocialNetwork {
  final Widget logo; // The path to social media image
  final String name; // Social media name
  final String chatBot; // ChatBot for send demand
  bool? loading; // To find out if state is loading
  bool? connected; // To find out if state is disconnected

  SocialNetwork({
    required this.logo,
    required this.name,
    required this.chatBot,
    this.loading = true, // Default value true for loading
    this.connected = false, // Default value false for connected
  });
}

final List<SocialNetwork> socialNetwork = [
  SocialNetwork(
    logo: Logo(Logos.facebook_messenger),
    name: "Facebook Messenger",
    chatBot: "",
  ),
  SocialNetwork(
    logo: Logo(Logos.instagram),
    name: "Instagram",
    chatBot: "@instagrambot:loveto.party",
  ),
  SocialNetwork(
    logo: Logo(Logos.whatsapp),
    name: "Whatsapp",
    chatBot: "@whatsappbot:loveto.party",
  ),
];

class WhatsAppResult {
  final String result;
  final String? code;
  final String? qrCode;

  WhatsAppResult(this.result, this.code, this.qrCode);
}
