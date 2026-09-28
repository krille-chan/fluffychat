// SPDX-FileCopyrightText: 2024-Present Aerogram Contributors
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:fluffychat/config/premium_settings.dart';
import 'package:fluffychat/models/premium_models.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class SettingsPremium extends StatefulWidget {
  const SettingsPremium({super.key});

  @override
  State<SettingsPremium> createState() => _SettingsPremiumState();
}

class _SettingsPremiumState extends State<SettingsPremium> {
  late Future<bool> _isPremiumFuture;
  late Future<PremiumFeatures> _featuresFuture;

  @override
  void initState() {
    super.initState();
    _isPremiumFuture = PremiumSettings.isPremium();
    _featuresFuture = PremiumSettings.getPremiumFeatures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium'),
      ),
      body: FutureBuilder<bool>(
        future: _isPremiumFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final isPremium = snapshot.data ?? false;

          return ListView(
            children: [
              if (!isPremium) ...[
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        size: 48,
                        color: Colors.blue[800],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Активировать Premium',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Разблокируй все премиум функции',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await showFutureLoadingDialog(
                            context: context,
                            future: () async {
                              await PremiumSettings.setPremiumTier(
                                PremiumTier.premium,
                              );
                            },
                          );
                          setState(() {
                            _isPremiumFuture =
                                PremiumSettings.isPremium();
                            _featuresFuture =
                                PremiumSettings.getPremiumFeatures();
                          });
                        },
                        child: const Text('Активировать'),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified,
                        color: Colors.amber[800],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Premium активирован',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Все премиум функции доступны',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Отключить Premium?'),
                              content: const Text(
                                'Премиум функции станут недоступны',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Отмена'),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Отключить'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await showFutureLoadingDialog(
                              context: context,
                              future: () async {
                                await PremiumSettings.setPremiumTier(
                                  PremiumTier.none,
                                );
                              },
                            );
                            setState(() {
                              _isPremiumFuture =
                                  PremiumSettings.isPremium();
                              _featuresFuture =
                                  PremiumSettings.getPremiumFeatures();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Отключить'),
                      ),
                    ],
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Доступные функции',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              FutureBuilder<PremiumFeatures>(
                future: _featuresFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final features = snapshot.data!;

                  return Column(
                    children: [
                      _FeatureTile(
                        icon: Icons.verified,
                        title: 'Premium значок',
                        enabled: features.premiumIcon,
                      ),
                      _FeatureTile(
                        icon: Icons.emoji_emotions,
                        title: 'Premium эмодзи',
                        enabled: features.premiumEmoji,
                      ),
                      _FeatureTile(
                        icon: Icons.animation,
                        title: 'Анимированный аватар',
                        enabled: features.animatedAvatar,
                      ),
                      _FeatureTile(
                        icon: Icons.person,
                        title: 'Анимированный профиль',
                        enabled: features.animatedProfile,
                      ),
                      _FeatureTile(
                        icon: Icons.sticker_emotion_outlined,
                        title: 'Premium стикеры',
                        enabled: features.premiumStickers,
                      ),
                      _FeatureTile(
                        icon: Icons.favorite,
                        title: 'Premium реакции',
                        enabled: features.premiumReactions,
                      ),
                      _FeatureTile(
                        icon: Icons.extension,
                        title: 'Расширенные реакции',
                        enabled: features.expandedReactions,
                      ),
                      _FeatureTile(
                        icon: Icons.star,
                        title: 'Эксклюзивные эффекты',
                        enabled: features.exclusiveEffects,
                      ),
                      _FeatureTile(
                        icon: Icons.animation_outlined,
                        title: 'Дополнительные анимации',
                        enabled: features.additionalAnimations,
                      ),
                      _FeatureTile(
                        icon: Icons.palette,
                        title: 'Дополнительные темы',
                        enabled: features.additionalThemes,
                      ),
                      _FeatureTile(
                        icon: Icons.color_lens,
                        title: 'Кастомные цвета профиля',
                        enabled: features.customProfileColor,
                      ),
                      _FeatureTile(
                        icon: Icons.chat,
                        title: 'Кастомные цвета чата',
                        enabled: features.customChatColor,
                      ),
                      _FeatureTile(
                        icon: Icons.image,
                        title: 'Свои обои',
                        enabled: features.customWallpaper,
                      ),
                      _FeatureTile(
                        icon: Icons.apps,
                        title: 'Premium иконки приложения',
                        enabled: features.premiumAppIcons,
                      ),
                      _FeatureTile(
                        icon: Icons.storage,
                        title: 'Увеличенные лимиты',
                        enabled: features.increasedLimits,
                      ),
                      _FeatureTile(
                        icon: Icons.cloud_upload,
                        title: 'Более крупные файлы',
                        enabled: features.largerFiles,
                      ),
                      _FeatureTile(
                        icon: Icons.translate,
                        title: 'Перевод сообщений',
                        enabled: features.messageTranslation,
                      ),
                      _FeatureTile(
                        icon: Icons.transcribe,
                        title: 'Расшифровка голоса',
                        enabled: features.voiceTranscription,
                      ),
                      _FeatureTile(
                        icon: Icons.security,
                        title: 'Продвинутая приватность',
                        enabled: features.advancedPrivacy,
                      ),
                      _FeatureTile(
                        icon: Icons.wallpaper,
                        title: 'Профильный баннер',
                        enabled: features.profileBanner,
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool enabled;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: enabled
          ? Icon(Icons.check_circle, color: Colors.green)
          : Icon(Icons.lock, color: Colors.grey),
      enabled: enabled,
    );
  }
}
