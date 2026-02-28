import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Auto login entrypoint for embedding inside Refaland.
/// 
/// Usage:
///   /autologin?st=<one-time-token>
/// 
/// It will:
/// 1) Show a loading UI (no login page).
/// 2) Exchange `st` with Refaland backend to obtain a Matrix loginToken.
/// 3) Login to the homeserver (default: AppSettings.defaultHomeserver).
class AutoLoginPage extends StatefulWidget {
  const AutoLoginPage({super.key});

  @override
  State<AutoLoginPage> createState() => _AutoLoginPageState();
}

class _AutoLoginPageState extends State<AutoLoginPage> {
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    final matrix = Matrix.of(context);
    final st = GoRouterState.of(context).uri.queryParameters['st'] ??
        Uri.base.queryParameters['st'];

    if (st == null || st.isEmpty) {
      _fail('Missing token');
      return;
    }

    try {
      // 1) Exchange the short-lived token with Refaland backend.
      // Recommended: keep this same-origin (reverse proxy ZedChat under Refaland domain).
      final exchangeUri = Uri.parse('/api/zedchat/exchange?st=$st');
      final res = await http.get(exchangeUri, headers: const {
        'Accept': 'application/json',
      });

      if (res.statusCode != 200) {
        _fail('Exchange failed: ${res.statusCode}');
        return;
      }

      final data = jsonDecode(res.body) as Map<String, dynamic>;

      // 2) Determine homeserver.
      final hs = (data['homeserver'] ?? data['homeserverUrl'] ?? AppSettings.defaultHomeserver.value)
          .toString()
          .trim();
      final homeserverUri = Uri.parse(hs.startsWith('http') ? hs : 'https://$hs');

      // 3) Matrix login token (preferred).
      final loginToken = (data['loginToken'] ?? data['token'])?.toString();

      if (loginToken == null || loginToken.isEmpty) {
        _fail('No loginToken in response');
        return;
      }

      // 4) Login using Matrix login token (no password in the client).
      final client = await matrix.getLoginClient();
      await client.checkHomeserver(homeserverUri);
      await client.login(
        LoginType.mLoginToken,
        token: loginToken,
        initialDeviceDisplayName: PlatformInfos.clientName,
      );

      if (!mounted) return;
      context.go('/rooms');
    } catch (e) {
      _fail(e.toString());
    }
  }

  void _fail(String msg) {
    if (!mounted) return;
    setState(() => _error = msg);
    // Fallback: go to home (intro/sign-in).
    // Keep it slightly delayed so user sees a brief error if needed.
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _error == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(
                    width: 42,
                    height: 42,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(height: 16),
                  Text('در حال ورود به ZedChat...'),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    'مشکل در ورود خودکار',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
