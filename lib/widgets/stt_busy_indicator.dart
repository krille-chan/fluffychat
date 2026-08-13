// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'matrix.dart';

/// A small spinner shown in the chat app bar while the STT engine is busy
/// (downloading or loading a model), so there is a single, calm indicator
/// instead of per-message loading states.
class SttBusyIndicator extends StatelessWidget {
  const SttBusyIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final stt = Matrix.of(context).stt;
    if (!stt.isFeatureAvailable) return const SizedBox.shrink();
    return ValueListenableBuilder<bool>(
      valueListenable: stt.isBusy,
      builder: (context, busy, _) => busy
          ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
