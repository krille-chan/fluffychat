import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'settings_multiple_emotes_view.dart';

class MultipleEmotesSettings extends StatefulWidget {
  const MultipleEmotesSettings({super.key});

  @override
  MultipleEmotesSettingsController createState() =>
      MultipleEmotesSettingsController();
}

class MultipleEmotesSettingsController extends State<MultipleEmotesSettings> {
  // #Pangea
  // String? get roomId => GoRouterState.of(context).pathParameters['roomid'];
  String? get roomId {
    final pathParameters = GoRouterState.of(context).pathParameters;
    return pathParameters['roomid'] ?? pathParameters['spaceid'];
  }
  // Pangea#

  @override
  Widget build(BuildContext context) => MultipleEmotesSettingsView(this);
}
