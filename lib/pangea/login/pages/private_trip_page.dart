import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PrivateTripPage extends StatefulWidget {
  const PrivateTripPage({
    super.key,
  });

  @override
  State<PrivateTripPage> createState() => PrivateTripPageState();
}

class PrivateTripPageState extends State<PrivateTripPage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _codeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String get _code => _codeController.text.trim();

  Future<void> _submit() async {
    if (_code.isEmpty) {
      return;
    }

    await MatrixState.pangeaController.classController.joinClasswithCode(
      context,
      _code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 10.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined),
            Text(L10n.of(context).unlockPrivateTripTitle),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            constraints: const BoxConstraints(
              maxWidth: 350,
              maxHeight: 600,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PangeaLogoSvg(
                  width: 100.0,
                  forceColor: theme.colorScheme.onSurface,
                ),
                Column(
                  spacing: 16.0,
                  children: [
                    Text(
                      L10n.of(context).courseCode,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        hintText: L10n.of(context).courseCodeHint,
                      ),
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    ElevatedButton(
                      onPressed: _code.isNotEmpty ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.colorScheme.onSurface,
                        side: BorderSide(
                          width: 1,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(L10n.of(context).unlockMyTrip),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
