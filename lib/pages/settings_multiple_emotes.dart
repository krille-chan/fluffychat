import 'package:flutter/material.dart';

import 'views/settings_multiple_emotes_view.dart';

class MultipleEmotesSettings extends StatefulWidget {
  final String roomId;

  MultipleEmotesSettings(this.roomId, {Key key}) : super(key: key);

  @override
  MultipleEmotesSettingsController createState() =>
      MultipleEmotesSettingsController();
}

class MultipleEmotesSettingsController extends State<MultipleEmotesSettings> {
  @override
  Widget build(BuildContext context) => MultipleEmotesSettingsUI(this);
}
