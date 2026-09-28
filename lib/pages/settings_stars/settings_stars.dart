// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:flutter/material.dart';

class SettingsStars extends StatefulWidget {
  const SettingsStars({super.key});

  @override
  SettingsStarsController createState() => SettingsStarsController();
}

class SettingsStarsController extends State<SettingsStars> {
  int get balance => AppSettings.starsBalance.value;

  Future<void> addStars(int amount) async {
    final nextBalance = balance + amount;
    await AppSettings.starsBalance.setItem(nextBalance);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Добавлено $amount звёзд. Текущий баланс: $nextBalance'),
      ),
    );
  }

  Future<void> sendGift(String name, int price) async {
    if (balance < price) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Недостаточно звёзд для этого подарка.')),
      );
      return;
    }

    await AppSettings.starsBalance.setItem(balance - price);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Подарок «$name» отправлен. Потрачено: $price звёзд.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SettingsStarsView(this);
}

class SettingsStarsView extends StatelessWidget {
  final SettingsStarsController controller;

  const SettingsStarsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catalog = <({String title, int price, String emoji, String desc})>[
      (
        title: 'Стикер «Сердце»',
        price: 25,
        emoji: '💖',
        desc: 'Лёгкий подарок для любимого собеседника',
      ),
      (
        title: 'Буст комнаты',
        price: 80,
        emoji: '🚀',
        desc: 'Поднимает настроение чату на день',
      ),
      (
        title: 'Рамка профиля',
        price: 120,
        emoji: '✨',
        desc: 'Элегантная рамка для профиля',
      ),
      (
        title: 'Премиум значок',
        price: 200,
        emoji: '🏆',
        desc: 'Показатель статуса в чате',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Звёзды и подарки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      const Text(
                        'Текущий баланс',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${controller.balance} ✨',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: () => controller.addStars(50),
                        icon: const Icon(Icons.add),
                        label: const Text('50 ✨'),
                      ),
                      FilledButton.icon(
                        onPressed: () => controller.addStars(150),
                        icon: const Icon(Icons.add),
                        label: const Text('150 ✨'),
                      ),
                      FilledButton.icon(
                        onPressed: () => controller.addStars(500),
                        icon: const Icon(Icons.add),
                        label: const Text('500 ✨'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Подарки',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...catalog.map((gift) {
            final canBuy = controller.balance >= gift.price;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  child: Text(gift.emoji, style: const TextStyle(fontSize: 22)),
                ),
                title: Text(gift.title),
                subtitle: Text('${gift.desc} • ${gift.price} звёзд'),
                trailing: FilledButton.tonal(
                  onPressed: canBuy ? () => controller.sendGift(gift.title, gift.price) : null,
                  child: Text(canBuy ? 'Отправить' : 'Не хватает'),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
