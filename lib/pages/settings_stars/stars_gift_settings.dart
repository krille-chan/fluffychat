// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:flutter/material.dart';

class StarsGiftSettings extends StatefulWidget {
  const StarsGiftSettings({super.key});

  @override
  State<StarsGiftSettings> createState() => _StarsGiftSettingsState();
}

class _StarsGiftSettingsState extends State<StarsGiftSettings> {
  int get balance => AppSettings.starsBalance.value;

  Future<void> addStars(int amount) async {
    final nextBalance = balance + amount;
    await AppSettings.starsBalance.setItem(nextBalance);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Добавлено $amount звёзд. Баланс: $nextBalance ✨'),
      ),
    );
  }

  Future<void> sendGift(String name, int price) async {
    if (balance < price) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Недостаточно звёзд для подарка.')),
      );
      return;
    }

    final confirm = await showOkCancelAlertDialog(
      context: context,
      title: 'Отправить подарок?',
      message: 'Отправить «$name» за $price звёзд?',
      okLabel: 'Отправить',
      cancelLabel: 'Отмена',
    );

    if (confirm != OkCancelResult.ok) return;
    if (!mounted) return;

    await AppSettings.starsBalance.setItem(balance - price);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Подарок «$name» отправлен.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = <({String title, int price, String emoji, String desc})>[
      (
        title: 'Стикер «Сердце»',
        price: 25,
        emoji: '💖',
        desc: 'Легкий подарок',
      ),
      (
        title: 'Буст комнаты',
        price: 80,
        emoji: '🚀',
        desc: 'Поднятие статуса',
      ),
      (
        title: 'Рамка профиля',
        price: 120,
        emoji: '✨',
        desc: 'Индивидуальный стиль',
      ),
      (
        title: 'Премиум значок',
        price: 200,
        emoji: '🏆',
        desc: 'Премиальный статус',
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
                  const Text('Баланс', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text(
                    '$balance ✨',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: () => addStars(50),
                        icon: const Icon(Icons.add),
                        label: const Text('50 ✨'),
                      ),
                      FilledButton.icon(
                        onPressed: () => addStars(150),
                        icon: const Icon(Icons.add),
                        label: const Text('150 ✨'),
                      ),
                      FilledButton.icon(
                        onPressed: () => addStars(500),
                        icon: const Icon(Icons.add),
                        label: const Text('500 ✨'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Подарки',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...entries.map((gift) {
            final canBuy = balance >= gift.price;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(child: Text(gift.emoji)),
                title: Text(gift.title),
                subtitle: Text('${gift.desc} • ${gift.price} звёзд'),
                trailing: FilledButton.tonal(
                  onPressed: canBuy ? () => sendGift(gift.title, gift.price) : null,
                  child: Text(canBuy ? 'Отправить' : 'Нет'),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
