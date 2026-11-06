// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/utils/recent_stickers_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = await SharedPreferences.getInstance();
  });

  test('stores recent stickers in MRU order without duplicates', () async {
    const userId = '@alice:example.org';
    final first = Uri.parse('mxc://example.org/first');
    final second = Uri.parse('mxc://example.org/second');

    await RecentStickersStore.add(store, userId, first);
    await RecentStickersStore.add(store, userId, second);
    await RecentStickersStore.add(store, userId, first);

    expect(RecentStickersStore.read(store, userId), [
      first.toString(),
      second.toString(),
    ]);
  });

  test('keeps recent stickers separate per Matrix user', () async {
    final aliceSticker = Uri.parse('mxc://example.org/alice');
    final bobSticker = Uri.parse('mxc://example.org/bob');

    await RecentStickersStore.add(store, '@alice:example.org', aliceSticker);
    await RecentStickersStore.add(store, '@bob:example.org', bobSticker);

    expect(RecentStickersStore.read(store, '@alice:example.org'), [
      aliceSticker.toString(),
    ]);
    expect(RecentStickersStore.read(store, '@bob:example.org'), [
      bobSticker.toString(),
    ]);
  });

  test('ignores invalid sticker URLs and missing users', () async {
    await RecentStickersStore.add(
      store,
      '@alice:example.org',
      Uri.parse('https://example.org/not-mxc'),
    );
    await RecentStickersStore.add(
      store,
      null,
      Uri.parse('mxc://example.org/ignored'),
    );

    expect(RecentStickersStore.read(store, '@alice:example.org'), isEmpty);
    expect(RecentStickersStore.read(store, null), isEmpty);
  });

  test('normalizes invalid and duplicate persisted entries', () async {
    const userId = '@alice:example.org';
    final first = Uri.parse('mxc://example.org/first');
    final second = Uri.parse('mxc://example.org/second');

    await RecentStickersStore.add(store, userId, first);
    final storageKey = store.getKeys().single;
    await store.setStringList(storageKey, [
      first.toString(),
      'https://example.org/not-mxc',
      first.toString(),
      second.toString(),
    ]);

    expect(RecentStickersStore.read(store, userId), [
      first.toString(),
      second.toString(),
    ]);
  });

  test('keeps only the 30 most recent stickers', () async {
    const userId = '@alice:example.org';

    for (var index = 0; index < 31; index++) {
      await RecentStickersStore.add(
        store,
        userId,
        Uri.parse('mxc://example.org/sticker-$index'),
      );
    }

    final recent = RecentStickersStore.read(store, userId);
    expect(recent, hasLength(30));
    expect(recent.first, 'mxc://example.org/sticker-30');
    expect(recent.last, 'mxc://example.org/sticker-1');
  });
}
