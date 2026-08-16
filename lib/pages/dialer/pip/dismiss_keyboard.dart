// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:material_ui/material_ui.dart';

void dismissKeyboard(BuildContext context) {
  // TODO: Dispose this
  FocusScope.of(context).requestFocus(FocusNode());
}
