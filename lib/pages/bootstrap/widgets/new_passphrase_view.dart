import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';

class NewPassphraseView extends StatelessWidget {
  const NewPassphraseView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'FluffyChat uses end to end encryption. To not lose your messages, please choose a strong passphrase to secure your crypto identity and your encrypted message backup.',
            textAlign: .center,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.visibility_off_outlined),
                onPressed: () {},
              ),
              hintText: 'New passphrase',
            ),
          ),
          const SizedBox(height: 16),
          TextField(decoration: InputDecoration(hintText: 'Repeat passphrase')),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: Text(L10n.of(context).continueText),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: Text(L10n.of(context).skip),
          ),
          const SizedBox(height: 16),
          _PassphraseCheckListTile(
            checked: true,
            label: 'At least 12 characters long.',
          ),
          const SizedBox(height: 16),
          _PassphraseCheckListTile(
            checked: false,
            label: 'Contains uppercase and lowercase characters.',
          ),
          const SizedBox(height: 16),
          _PassphraseCheckListTile(
            checked: false,
            label: 'Contains special characters.',
          ),
          const SizedBox(height: 16),
          _PassphraseCheckListTile(
            checked: true,
            label: 'Contains one numbers.',
          ),
        ],
      ),
    );
  }
}

class _PassphraseCheckListTile extends StatelessWidget {
  final String label;
  final bool checked;
  const _PassphraseCheckListTile({required this.label, required this.checked});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      spacing: 8.0,
      children: [
        Icon(
          checked ? Icons.check_circle_outlined : Icons.circle_outlined,
          color: checked
              ? theme.brightness == Brightness.light
                    ? Colors.green.shade800
                    : Colors.green.shade300
              : theme.colorScheme.error,
          size: 20,
        ),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
