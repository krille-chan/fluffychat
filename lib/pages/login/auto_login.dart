import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

    final homeserverUrl = dotenv.env['MATRIX_HOMESERVER_URL'] ?? '';
    final homeserver = Uri.parse(homeserverUrl);

    await client.checkHomeserver(homeserver);

    if (!mounted) return;

    final state = GoRouterState.of(context);
    final from = state.uri.queryParameters['from'];

    if (from == 'register') {
      context.go('/register', extra: client);
    } else {
      context.go('/login', extra: client);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
