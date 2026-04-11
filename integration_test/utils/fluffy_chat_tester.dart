import 'package:fluffychat/main.dart' as app;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

extension type FluffyChatTester(WidgetTester tester) {
  static int _printCounter = 1;

  void _print(String message) {
    debugPrint(
      '[INTEGRATION TEST] ${DateTime.now().toIso8601String()} | Step ${_printCounter++} -  $message',
    );
  }

  Future<bool> isVisible(
    Object object, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final end = DateTime.now().add(timeout);
    while (object.toFinder().evaluate().isEmpty) {
      if (DateTime.now().isAfter(end)) {
        return false;
      }
      await tester.pump(const Duration(milliseconds: 500));
    }
    return true;
  }

  Future<void> waitFor(
    Object object, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    _print('👀 Waiting for "$object" (${timeout.inSeconds}s)');
    final end = DateTime.now().add(timeout);
    while (object.toFinder().evaluate().isEmpty) {
      if (DateTime.now().isAfter(end)) {
        throw Exception('⏱️ Timed out waiting for "$object"!');
      }
      await tester.pump(const Duration(milliseconds: 500));
    }
  }

  Future<Finder> _ensureVisible(Object object, {int? index}) async {
    var finder = object.toFinder();
    if (finder.evaluate().isEmpty) await waitFor(object);

    if (finder.evaluate().length > 1) {
      if (index == null) {
        throw Exception(
          '⚠️ Found ${finder.evaluate().length} "$object" objects. Please specify an index!',
        );
      }
      if (finder.evaluate().length <= index) {
        throw Exception(
          '⚠️ Found ${finder.evaluate().length} "$object" objects. So index $index does not exist!',
        );
      }
      finder = finder.at(index);
    }
    return finder;
  }

  Future<void> tapOn(Object object, {int? index}) async {
    final finder = await _ensureVisible(object, index: index);

    _print('👆 Tapping on "$object"');
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> goBack() => tapOn(find.byTooltip('Back'));

  Future<void> enterText(Object object, String text, {int? index}) async {
    final finder = await _ensureVisible(object, index: index);

    _print('⌨️ Enter "$text" into "$object"');
    await tester.enterText(finder, text);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
  }

  Future<void> scrollUntilVisible(
    Object object, {
    int? index,
    Object? scrollable,
  }) async {
    _print('📜 Scrolling to "$object"');
    await tester.scrollUntilVisible(
      object.toFinder(),
      500.0,
      scrollable: scrollable?.toFinder() ?? find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
  }

  Future<void> sendKeyCombo(
    LogicalKeyboardKey modifier,
    LogicalKeyboardKey key,
  ) async {
    _print('➕ Sending ${modifier.keyLabel}+${key.keyLabel}');
    await tester.sendKeyDownEvent(modifier);
    await tester.sendKeyDownEvent(key);
    await tester.sendKeyUpEvent(key);
    await tester.sendKeyUpEvent(modifier);
    await tester.pumpAndSettle();
  }
}

extension on Object {
  Finder toFinder() => switch (this) {
    final Finder finder => finder,
    final String string => find.text(string),
    final Key key => find.byKey(key),
    final IconData icon => find.byIcon(icon),
    final Type type => find.byType(type),
    final Widget widget => find.byWidget(widget),
    _ => throw Exception('Unsupported finder type: $runtimeType'),
  };
}

extension StartTest on WidgetTester {
  Future<FluffyChatTester> startFluffyChatTest() async {
    app.main();

    return FluffyChatTester(this);
  }
}
