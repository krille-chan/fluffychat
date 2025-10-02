import 'package:flutter/material.dart';

import 'package:hermes/config/app_config.dart';
import 'package:hermes/config/setting_keys.dart';
import 'package:hermes/widgets/matrix.dart';

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
    swipeDurationMs = AppConfig.swipePopDuration.inMilliseconds.toDouble();
    swipeEnableFullScreenDrag = AppConfig.swipePopEnableFullScreenDrag;
    swipeMinimumDragFraction = AppConfig.swipePopMinimumDragFraction;
    swipeVelocityThreshold = AppConfig.swipePopVelocityThreshold;
  }

  void setSwipeEnableFullScreenDrag(bool value) {
    setState(() => swipeEnableFullScreenDrag = value);
    AppConfig.swipePopEnableFullScreenDrag = value;
    Matrix.of(context)
        .store
        .setBool(SettingKeys.swipePopEnableFullScreenDrag, value);
  }

  void updateSwipeDuration(double value) {
    setState(() => swipeDurationMs = value);
  }

  Future<void> saveSwipeDuration(double value) async {
    final milliseconds = value.round().clamp(120, 600).toInt();
    final normalized = milliseconds.toDouble();
    setState(() => swipeDurationMs = normalized);
    AppConfig.swipePopDurationMs = milliseconds;
    await Matrix.of(context)
        .store
        .setInt(SettingKeys.swipePopDurationMs, milliseconds);
  }

  void updateSwipeMinimumDragFraction(double value) {
    setState(() => swipeMinimumDragFraction = value);
  }

  Future<void> saveSwipeMinimumDragFraction(double value) async {
    final clamped = value.clamp(0.05, 1.0).toDouble();
    setState(() => swipeMinimumDragFraction = clamped);
    AppConfig.swipePopMinimumDragFraction = clamped;
    await Matrix.of(context)
        .store
        .setDouble(SettingKeys.swipePopMinimumDragFraction, clamped);
  }

  void updateSwipeVelocityThreshold(double value) {
    setState(() => swipeVelocityThreshold = value);
  }

  Future<void> saveSwipeVelocityThreshold(double value) async {
    final clamped = value.clamp(50.0, 2000.0).toDouble();
    setState(() => swipeVelocityThreshold = clamped);
    AppConfig.swipePopVelocityThreshold = clamped;
    await Matrix.of(context)
        .store
        .setDouble(SettingKeys.swipePopVelocityThreshold, clamped);
  }

  @override
  Widget build(BuildContext context) => SettingsChatView(this);
}
