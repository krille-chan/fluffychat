// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:ui';

import 'package:crop_image/crop_image.dart';

/// Pure coordinate/rotation helpers for the image editor in
/// `send_file_dialog.dart`. Kept dependency-free (only `dart:ui` and
/// `crop_image`) so they can be unit-tested without spinning up the app.

/// Maps a quarter-turn count (positive = clockwise) to the [CropRotation] used
/// when baking the final image, so the on-screen `RotatedBox` preview and the
/// saved result always rotate the same way.
CropRotation imageEditorRotationForQuarterTurns(int quarterTurns) {
  switch (((quarterTurns % 4) + 4) % 4) {
    case 1:
      return CropRotation.right;
    case 2:
      return CropRotation.down;
    case 3:
      return CropRotation.left;
    default:
      return CropRotation.up;
  }
}

/// Maps a pointer position on the draw surface (logical pixels) to a coordinate
/// in the source image's pixel space, given the currently shown crop region
/// [cropPx] displayed at [displaySize]. The mapping is a uniform scale plus
/// translation because the draw surface preserves the crop's aspect ratio.
Offset imageEditorLocalToImagePx(Offset local, Size displaySize, Rect cropPx) {
  final scale = cropPx.width / displaySize.width;
  return Offset(cropPx.left + local.dx * scale, cropPx.top + local.dy * scale);
}
