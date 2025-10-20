import 'package:flutter/material.dart';

import 'package:hermes/config/setting_keys.dart';

import 'settings_chat_view.dart';

class SettingsChat extends StatefulWidget {
  const SettingsChat({super.key});

  @override
  SettingsChatController createState() => SettingsChatController();
}

class SettingsChatController extends State<SettingsChat> {
  late double swipeDurationMs;
  late bool swipeEnableFullScreenDrag;
  late double swipeMinimumDragFraction;
  late double swipeVelocityThreshold;

  @override
  void initState() {
    super.initState();
    swipeDurationMs = AppSettings.swipePopDuration.value.toDouble();
    swipeMinimumDragFraction = AppSettings.swipePopMinimumDragFraction.value;
    swipeVelocityThreshold = AppSettings.swipePopVelocityThreshold.value;
  }

  void updateSwipeDuration(double value) {
    setState(() => swipeDurationMs = value);
  }

  void saveSwipeDuration(double value) {
    final milliseconds = value.round().clamp(120, 600).toInt();
    final normalized = milliseconds.toDouble();
    setState(() => swipeDurationMs = normalized);
    AppSettings.swipePopDuration.setItem(milliseconds);
  }

  void updateSwipeMinimumDragFraction(double value) {
    setState(() => swipeMinimumDragFraction = value);
  }

  saveSwipeMinimumDragFraction(double value) {
    final clamped = value.clamp(0.05, 1.0).toDouble();
    setState(() => swipeMinimumDragFraction = clamped);
    AppSettings.swipePopMinimumDragFraction.setItem(clamped);
  }

  void updateSwipeVelocityThreshold(double value) {
    setState(() => swipeVelocityThreshold = value);
  }

  saveSwipeVelocityThreshold(double value) {
    final clamped = value.clamp(50.0, 2000.0).toDouble();
    setState(() => swipeVelocityThreshold = clamped);
    AppSettings.swipePopVelocityThreshold.setItem(clamped);
  }

  @override
  Widget build(BuildContext context) => SettingsChatView(this);
}
