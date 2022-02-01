import 'package:flutter/material.dart';

import 'package:vrouter/vrouter.dart';

import 'settings_multiple_emotes_view.dart';

class MultipleEmotesSettings extends StatefulWidget {
  const MultipleEmotesSettings({Key? key}) : super(key: key);

  @override
  MultipleEmotesSettingsController createState() =>
      MultipleEmotesSettingsController();
}

class MultipleEmotesSettingsController extends State<MultipleEmotesSettings> {
  String? get roomId => VRouter.of(context).pathParameters['roomid'];
  @override
  Widget build(BuildContext context) => MultipleEmotesSettingsView(this);
}
