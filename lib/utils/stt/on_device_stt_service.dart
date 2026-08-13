// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'on_device_stt_service_stub.dart'
    if (dart.library.io) 'on_device_stt_service_io.dart';
import 'stt_service.dart';

/// Builds the on-device Speech-to-Text service.
///
/// The real implementation (powered by `whisper_ggml`) uses `dart:ffi` and is
/// therefore only compiled on native platforms (`dart:io`). On the web a stub
/// that reports the service as unavailable is used instead.
SttService createOnDeviceSttService() => createOnDeviceSttServiceImpl();
