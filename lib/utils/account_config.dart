import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/setting_keys.dart';

extension ApplicationAccountConfigExtension on Client {
  static const String accountDataKey = 'im.fluffychat.account_config';

  ApplicationAccountConfig get applicationAccountConfig =>
      ApplicationAccountConfig.fromJson(
        accountData[accountDataKey]?.content ?? {},
      );

  Future<void> setApplicationAccountConfig(
    ApplicationAccountConfig config,
  ) =>
      setAccountData(
        userID!,
        accountDataKey,
        config.toJson(),
      );

  /// Only updates the specified values in ApplicationAccountConfig
  Future<void> updateApplicationAccountConfig(
    ApplicationAccountConfig config,
  ) {
    final currentConfig = applicationAccountConfig;
    return setAccountData(
      userID!,
      accountDataKey,
      ApplicationAccountConfig(
        wallpaperUrl: config.wallpaperUrl ?? currentConfig.wallpaperUrl,
        wallpaperOpacity:
            config.wallpaperOpacity ?? currentConfig.wallpaperOpacity,
        unifiedPushEndpoint:
            config.unifiedPushEndpoint ?? currentConfig.unifiedPushEndpoint,
        unifiedPushRegistered:
            config.unifiedPushRegistered ?? currentConfig.unifiedPushRegistered,
      ).toJson(),
    );
  }
}

class ApplicationAccountConfig {
  final Uri? wallpaperUrl;
  final double? wallpaperOpacity;
  final String? unifiedPushEndpoint;
  final bool? unifiedPushRegistered;

  const ApplicationAccountConfig({
    this.wallpaperUrl,
    this.wallpaperOpacity,
    this.unifiedPushEndpoint,
    this.unifiedPushRegistered,
  });

  static double _sanitizedOpacity(double? opacity) {
    if (opacity == null) return 1;
    if (opacity > 1 || opacity < 0) return 1;
    return opacity;
  }

  factory ApplicationAccountConfig.fromJson(Map<String, dynamic> json) =>
      ApplicationAccountConfig(
        wallpaperUrl: json['wallpaper_url'] is String
            ? Uri.tryParse(json['wallpaper_url'])
            : null,
        wallpaperOpacity:
            _sanitizedOpacity(json.tryGet<double>('wallpaper_opacity')),
        unifiedPushEndpoint: json[SettingKeys.unifiedPushEndpoint] is String
            ? json[SettingKeys.unifiedPushEndpoint]
            : "",
        unifiedPushRegistered:
            json.tryGet<bool>(SettingKeys.unifiedPushRegistered),
      );

  Map<String, dynamic> toJson() => {
        'wallpaper_url': wallpaperUrl?.toString(),
        'wallpaper_opacity': wallpaperOpacity,
        SettingKeys.unifiedPushEndpoint: unifiedPushEndpoint,
        SettingKeys.unifiedPushRegistered: unifiedPushRegistered?.toString(),
      };
}
