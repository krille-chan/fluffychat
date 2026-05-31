// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import 'attachment_style.dart';

abstract class AttachmentRenderer {
  const AttachmentRenderer();
  Widget build(BuildContext context, Event event, AttachmentStyle style);
}
