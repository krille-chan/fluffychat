// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/stt/stt_manager.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

/// Human-readable description of a model, for users who can't tell
/// "tiny"/"base"/"small" apart.
String sttModelDescription(BuildContext context, String model) {
  final l10n = L10n.of(context);
  switch (model) {
    case 'tiny':
      return l10n.sttModelTinyDesc;
    case 'base':
      return l10n.sttModelBaseDesc;
    case 'small':
      return l10n.sttModelSmallDesc;
    default:
      return '';
  }
}

/// Opens a dialog to pick the active STT model (tiny/base/small), showing the
/// download status of each. Selecting a model persists it as the default.
Future<void> showSttModelPicker(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const _SttModelPickerDialog(),
  );
}

class _SttModelPickerDialog extends StatefulWidget {
  const _SttModelPickerDialog();

  @override
  State<_SttModelPickerDialog> createState() => _SttModelPickerDialogState();
}

class _SttModelPickerDialogState extends State<_SttModelPickerDialog> {
  final Map<String, bool> _status = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStatus());
  }

  Future<void> _loadStatus() async {
    if (!mounted) return;
    final stt = Matrix.of(context).stt;
    final status = <String, bool>{};
    for (final name in SttManager.models) {
      status[name] = await stt.isModelDownloaded(name);
    }
    if (!mounted) return;
    setState(
      () => _status
        ..clear()
        ..addAll(status),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(l10n.sttModel),
      content: SizedBox(
        width: double.maxFinite,
        child: RadioGroup<String>(
          groupValue: AppSettings.sttModel.value,
          onChanged: (value) async {
            await Matrix.of(context).stt.activateModel(value!);
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final model in SttManager.models)
                RadioListTile<String>.adaptive(
                  value: model,
                  title: Row(
                    children: [
                      Text(model),
                      const SizedBox(width: 8),
                      if (_status[model] == null)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        Icon(
                          _status[model]!
                              ? Icons.download_done
                              : Icons.cloud_download_outlined,
                          size: 16,
                          color: _status[model]!
                              ? Colors.green
                              : theme.colorScheme.outline,
                        ),
                    ],
                  ),
                  subtitle: Text(sttModelDescription(context, model)),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
