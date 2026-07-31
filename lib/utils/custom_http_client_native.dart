// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:cronet_http/cronet_http.dart';
import 'package:http/http.dart' as http;

/// On Android this uses [Cronet], which provides HTTP/2, HTTP/3, and better
/// integration with the platform networking stack (e.g. system proxies).
/// Let's Encrypt roots for older Android versions are added via the Android
/// network security config (`network_security_config.xml`).
///
/// [Cronet]: https://developer.android.com/guide/topics/connectivity/cronet
http.Client createPlatformHttpClient() =>
    Platform.isAndroid ? CronetClient.defaultCronetEngine() : http.Client();
