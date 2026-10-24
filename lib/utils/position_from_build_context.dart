// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/widgets.dart';

extension PositionFromBuildContext on BuildContext {
  RelativeRect get position {
    final overlay = Overlay.of(this).context.findRenderObject() as RenderBox;

    final button = findRenderObject() as RenderBox;

    return RelativeRect.fromRect(
      button.localToGlobal(Offset.zero, ancestor: overlay) & button.size,
      Offset.zero & overlay.size,
    );
  }
}
