import 'package:matrix/matrix.dart';
import 'package:flutter/material.dart';

class VideoStreamingModel {
  final String title;
  final String playbackUrl;
  final String aspectRatio;

  const VideoStreamingModel({
    required this.title,
    required this.playbackUrl,
    this.aspectRatio = '16:9',
  });

  static final ValueNotifier<Map<String, bool>> liveStatus = ValueNotifier({});
  static const String eventType = 'im.vector.modular.widgets';
  static const String stateKey = 'live_widget';
  static const String contentType = 'live';

  factory VideoStreamingModel.fromWidgetStateEvent(dynamic state) {
    final content = state.content as Map<String, dynamic>? ?? {};
    final data = content['data'] as Map<String, dynamic>? ?? {};

    return VideoStreamingModel(
      title: data['title'] ?? '',
      playbackUrl: data['playbackUrl'] ?? '',
      aspectRatio: data['aspectRatio'] ?? '16:9',
    );
  }

  Map<String, dynamic> toWidgetContent() {
    return {
      'title': title,
      'playbackUrl': playbackUrl,
      'aspectRatio': aspectRatio,
    };
  }

  static Future<void> sendLiveWidget({
    required Room room,
    required VideoStreamingModel model,
  }) async {
    const eventName = 'Transmissão ao vivo';
    final client = room.client;
    final user = client.userID;
    const widgetId = stateKey;

    final widgetContent = {
      'type': contentType,
      'name': eventName,
      'data': model.toWidgetContent(),
      'creatorUserId': user,
      'waitForIframeLoad': true,
    };

    try {
      await client.setRoomStateWithKey(
        room.id,
        eventType,
        widgetId,
        widgetContent,
      );
    } catch (e) {
      debugPrint('Erro ao enviar o widget de live para o Matrix: $e');
      rethrow;
    }
  }

  static Future<void> removeLiveWidget(Room room) async {
    try {
      await room.deleteWidget(stateKey);
    } catch (e) {
      debugPrint('Erro ao remover o widget de live do Matrix: $e');
      rethrow;
    }
  }

  static double parseAspectRatio(String aspectRatioString) {
    final parts = aspectRatioString.split(':');
    if (parts.length != 2) return 16 / 9;

    final width = double.tryParse(parts[0]);
    final height = double.tryParse(parts[1]);

    if (width == null || height == null || height == 0) return 16 / 9;

    return width / height;
  }
}
