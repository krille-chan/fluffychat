import 'package:fluffychat/config/app_config.dart';

class SpaceConstants {
  static const powerLevelOfAdmin = 100;
  static const languageToolPermissions = 1;
  static const defaultDominantLanguage = "en";
  static const defaultTargetLanguage = "es";
  static const String classCode = 'classcode';
  static const String introductionChatAlias = 'introductionChat';
  static const String announcementsChatAlias = 'announcementsChat';

  static List<String> introChatIcons = [
    '${AppConfig.assetsBaseURL}/Introduction_1.jpg',
    '${AppConfig.assetsBaseURL}/Introduction_2.png',
    '${AppConfig.assetsBaseURL}/Introduction_3.jpg',
  ];

  static List<String> announcementChatIcons = [
    '${AppConfig.assetsBaseURL}/Announment_1.png',
    '${AppConfig.assetsBaseURL}/Announment_2.png',
    '${AppConfig.assetsBaseURL}/Announcement_3.jpg',
  ];

  static List<String> publicSpaceIcons = [
    '${AppConfig.assetsBaseURL}/Space+template+1.png',
    '${AppConfig.assetsBaseURL}/Space+template+2.png',
    '${AppConfig.assetsBaseURL}/Space+template+3.png',
    '${AppConfig.assetsBaseURL}/Space+template+4.png',
    '${AppConfig.assetsBaseURL}/Space+template+5.png',
    '${AppConfig.assetsBaseURL}/Space+template+6.png',
  ];
}
