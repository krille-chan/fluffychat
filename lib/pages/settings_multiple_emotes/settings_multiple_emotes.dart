// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'settings_multiple_emotes_view.dart';

class MultipleEmotesSettings extends StatefulWidget {
  const MultipleEmotesSettings({super.key});

  @override
  MultipleEmotesSettingsController createState() =>
      MultipleEmotesSettingsController();
}

class MultipleEmotesSettingsController extends State<MultipleEmotesSettings> {
  String? get roomId => GoRouterState.of(context).pathParameters['roomid'];
  @override
  Widget build(BuildContext context) => MultipleEmotesSettingsView(this);
}
