// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:http/http.dart' as http;

/// Default HTTP client for platforms without Cronet (e.g. web).
http.Client createPlatformHttpClient() => http.Client();
