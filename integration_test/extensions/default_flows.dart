import 'dart:developer';

import 'package:fluffychat/pages/chat_list/chat_list_body.dart';
import 'package:fluffychat/pages/homeserver_picker/homeserver_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../users.dart';
import 'wait_for.dart';

extension DefaultFlowExtensions on WidgetTester {
  Future<void> login() async {
    final tester = this;

    await tester.pumpAndSettle();

    await tester.waitFor(find.text('Let\'s start'));

    expect(find.text('Let\'s start'), findsOneWidget);

    final input = find.byType(TextField);

    expect(input, findsOneWidget);

    // getting the placeholder in place
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(input, homeserver);
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // in case registration is allowed
    // try {
    await Future.delayed(const Duration(milliseconds: 50));

    await tester.scrollUntilVisible(
      find.text('Login'),
      500,
      scrollable: find.descendant(
        of: find.byKey(const Key('ConnectPageListView')),
        matching: find.byType(Scrollable).first,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    /*} catch (e) {
      log('Registration is not allowed. Proceeding with login...');
    }*/
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(milliseconds: 50));

    final inputs = find.byType(TextField);

    await tester.enterText(inputs.first, Users.user1.name);
    await tester.enterText(inputs.last, Users.user1.password);
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);

    try {
      // pumpAndSettle does not work in here as setState is called
      // asynchronously
      await tester.waitFor(
        find.byType(LinearProgressIndicator),
        timeout: const Duration(milliseconds: 1500),
        skipPumpAndSettle: true,
      );
    } catch (_) {
      // in case the input action does not work on the desired platform
      if (find.text('Login').evaluate().isNotEmpty) {
        await tester.tap(find.text('Login'));
      }
    }

    try {
      await tester.pumpAndSettle();
    } catch (_) {
      // may fail because of ongoing animation below dialog
    }

    await tester.waitFor(
      find.byType(ChatListViewBody),
      skipPumpAndSettle: true,
    );
  }

  /// ensure PushProvider check passes
  Future<void> acceptPushWarning() async {
    final tester = this;

    final matcher = find.maybeUppercaseText('Do not show again');

    try {
      await tester.waitFor(matcher, timeout: const Duration(seconds: 5));

      // the FCM push error dialog to be handled...
      await tester.tap(matcher);
      await tester.pumpAndSettle();
    } catch (_) {}
  }

  Future<void> ensureLoggedOut() async {
    final tester = this;
    await tester.pumpAndSettle();
    if (find.byType(ChatListViewBody).evaluate().isNotEmpty) {
      await tester.tap(find.byTooltip('Show menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Account'),
        500,
        scrollable: find.descendant(
          of: find.byKey(const Key('SettingsListViewContent')),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();
      await tester.tap(find.maybeUppercaseText('Yes'));
      await tester.pumpAndSettle();
    }
  }

  Future<void> ensureAppStartedHomescreen({
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final tester = this;
    await tester.pumpAndSettle();

    final homeserverPickerFinder = find.byType(HomeserverPicker);
    final chatListFinder = find.byType(ChatListViewBody);

    final end = DateTime.now().add(timeout);

    log(
      'Waiting for HomeserverPicker or ChatListViewBody...',
      name: 'Test Runner',
    );
    do {
      if (DateTime.now().isAfter(end)) {
        throw Exception(
          'Timed out waiting for HomeserverPicker or ChatListViewBody',
        );
      }

      await pumpAndSettle();
      await Future.delayed(const Duration(milliseconds: 100));
    } while (homeserverPickerFinder.evaluate().isEmpty &&
        chatListFinder.evaluate().isEmpty);

    if (homeserverPickerFinder.evaluate().isNotEmpty) {
      log(
        'Found HomeserverPicker, performing login.',
        name: 'Test Runner',
      );
      await tester.login();
    } else {
      log(
        'Found ChatListViewBody, skipping login.',
        name: 'Test Runner',
      );
    }

    await tester.acceptPushWarning();
  }
}
