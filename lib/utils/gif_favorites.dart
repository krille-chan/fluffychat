// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/utils/gif_api.dart';
import 'package:matrix/matrix.dart';

class GifFavorites {
  static const String favoriteGifsKey = 'im.ponies.favorite_gifs';

  static Future<List<GifItem>> getFavorites({Client? client}) async {
    var list = <GifItem>[];
    if (client != null && client.isLogged()) {
      final content = client.accountData[favoriteGifsKey]?.content;
      final gifsJson = (content?['gifs'] ?? content?['results']) as List?;
      if (gifsJson != null) {
        list = gifsJson
            .whereType<Map<String, dynamic>>()
            .map(GifItem.fromJson)
            .toList();
      }
    }
    return list;
  }

  static bool isFavorite(GifItem gif, List<GifItem> favorites) {
    return favorites.any(
      (f) =>
          (gif.id.isNotEmpty && f.id == gif.id) ||
          (gif.url.isNotEmpty && f.url == gif.url),
    );
  }

  static Future<List<GifItem>> toggleFavorite(
    GifItem gif, {
    Client? client,
  }) async {
    final current = await getFavorites(client: client);
    final exists = isFavorite(gif, current);
    List<GifItem> updated;
    if (exists) {
      updated = current
          .where(
            (f) =>
                !(gif.id.isNotEmpty && f.id == gif.id) &&
                !(gif.url.isNotEmpty && f.url == gif.url),
          )
          .toList();
    } else {
      updated = [gif, ...current];
    }
    await saveFavorites(updated, client: client);
    return updated;
  }

  static Future<void> saveFavorites(
    List<GifItem> gifs, {
    Client? client,
  }) async {
    if (client != null && client.isLogged()) {
      await client.setAccountData(client.userID!, favoriteGifsKey, {
        'gifs': gifs.map((g) => g.toJson()).toList(),
      });
    }
  }
}
