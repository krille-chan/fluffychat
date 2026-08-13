// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/utils/stt/stt_manager.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

import 'settings_chat_view.dart';

class SettingsChat extends StatefulWidget {
  const SettingsChat({super.key});

  @override
  SettingsChatController createState() => SettingsChatController();
}

class SettingsChatController extends State<SettingsChat> {
  void updateState() => setState(() {});

  /// Cached download status + size per model, refreshed on init and whenever
  /// the set of downloaded models changes ([SttManager.modelRevision]).
  Map<String, bool> sttModelDownloadStatus = {};
  Map<String, int?> sttModelSizes = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Matrix.of(context).stt.modelRevision.addListener(_onModelRevision);
      _refreshModelStatus();
    });
  }

  void _onModelRevision() => _refreshModelStatus();

  Future<void> _refreshModelStatus() async {
    if (!mounted) return;
    final stt = Matrix.of(context).stt;
    final status = <String, bool>{};
    final sizes = <String, int?>{};
    for (final name in SttManager.models) {
      status[name] = await stt.isModelDownloaded(name);
      sizes[name] = await stt.modelSizeBytes(name);
    }
    if (!mounted) return;
    setState(() {
      sttModelDownloadStatus = status;
      sttModelSizes = sizes;
    });
  }

  @override
  void dispose() {
    try {
      Matrix.of(context).stt.modelRevision.removeListener(_onModelRevision);
    } catch (_) {}
    super.dispose();
  }

  Future<void> selectModel(String model) async {
    await Matrix.of(context).stt.activateModel(model);
    updateState();
  }

  /// Triggers a model download. Progress is reported via
  /// [SttManager.modelDownloads] (observed by the row), so this is fire-and-forget.
  void downloadModel(String model) =>
      Matrix.of(context).stt.downloadModel(model);

  Future<void> deleteModel(String model) async {
    await Matrix.of(context).stt.deleteModel(model);
    await _refreshModelStatus();
  }

  @override
  Widget build(BuildContext context) => SettingsChatView(this);
}
