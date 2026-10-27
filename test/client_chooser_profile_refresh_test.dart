// SPDX-FileCopyrightText: 2026 Brandon Dick
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/client_chooser_button.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

import 'utils/test_client.dart';

class _ProfileClient extends Client {
  _ProfileClient(Client seed)
    : super('profile-refresh-test', database: seed.database);

  Uri? currentAvatar;
  int cachedFetches = 0;
  int freshFetches = 0;
  Duration? lastCacheAge;

  @override
  String? get userID => '@alice:example.invalid';

  @override
  bool isLogged() => true;

  @override
  Future<Profile> fetchOwnProfile({
    bool getFromRooms = true,
    bool cache = true,
  }) async {
    cachedFetches++;
    return Profile(userId: userID!, avatarUrl: currentAvatar);
  }

  @override
  Future<Profile> getProfileFromUserId(
    String userId, {
    bool? getFromRooms,
    bool? cache,
    Duration timeout = const Duration(seconds: 30),
    Duration maxCacheAge = const Duration(days: 1),
  }) async {
    freshFetches++;
    lastCacheAge = maxCacheAge;
    return Profile(userId: userId, avatarUrl: currentAvatar);
  }
}

class _ProfileMatrixState extends MatrixState {
  _ProfileMatrixState(this.client);

  @override
  final Client client;

  @override
  Map<String?, List<Client?>> get accountBundles => {};
}

void main() {
  testWidgets('account avatar refreshes immediately after profile update', (
    tester,
  ) async {
    final seed = (await tester.runAsync(prepareTestClient))!;
    final client = _ProfileClient(seed);
    final matrix = _ProfileMatrixState(client);

    await tester.pumpWidget(
      Provider<MatrixState>.value(
        value: matrix,
        child: MaterialApp(
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          home: Scaffold(body: ClientChooserButton(ChatListController())),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(client.cachedFetches, 1);
    expect(client.freshFetches, 0);
    expect(tester.widget<Avatar>(find.byType(Avatar)).mxContent, isNull);

    // Rebuilding the search bar should not re-fetch a cached profile.
    await tester.pumpWidget(
      Provider<MatrixState>.value(
        value: matrix,
        child: MaterialApp(
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          home: Scaffold(body: ClientChooserButton(ChatListController())),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(client.cachedFetches, 1);

    client.currentAvatar = Uri.parse('mxc://example.invalid/new-avatar');
    client.onUserProfileUpdate.add('@another:example.invalid');
    await tester.pump();
    expect(client.freshFetches, 0);

    client.onUserProfileUpdate.add(client.userID!);
    await tester.pumpAndSettle();

    expect(client.freshFetches, 1);
    expect(client.lastCacheAge, Duration.zero);
    expect(
      tester.widget<Avatar>(find.byType(Avatar)).mxContent,
      client.currentAvatar,
    );
    expect(tester.takeException(), isNull);
  });
}
