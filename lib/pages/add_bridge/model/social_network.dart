import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class SocialNetwork {
  final Widget logo; // The path to social media image
  final String name; // Social media name
  final String chatBot; // ChatBot for send demand

  SocialNetwork({
    required this.logo,
    required this.name,
    required this.chatBot,
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
    chatBot: "",
  ),
];