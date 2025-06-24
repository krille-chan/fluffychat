import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AutoLoginScreen extends StatefulWidget {
  const AutoLoginScreen({super.key});

  @override
  State<AutoLoginScreen> createState() => _AutoLoginScreenState();
}

class _AutoLoginScreenState extends State<AutoLoginScreen> {
  @override
  void initState() {
    super.initState();
    _setupClient();
  }

  Future<void> _setupClient() async {
    final client = await Matrix.of(context).getLoginClient();
    final homeserver = Uri.https('matrix.radiohemp.com', '');
    await client.checkHomeserver(homeserver);

    if (!mounted) return;
    context.go('/login', extra: client);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
