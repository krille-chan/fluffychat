// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/bootstrap/view_model/bootstrap_view_model.dart';
import 'package:flutter/material.dart';

class NewPassphraseView extends StatelessWidget {
  final BootstrapViewModel viewModel;

  const NewPassphraseView(this.viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canCreatePassphrase =
        viewModel.value.newPassphraseEqualsRepeatPassphrase &&
        viewModel.value.newPassphraseNumbers &&
        viewModel.value.newPassphraseSpecialCharacters &&
        viewModel.value.newPassphraseUpperAndLowerCase &&
        viewModel.value.newPassphraseLongEnough;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(L10n.of(context).newPassphraseDescription, textAlign: .center),
        const SizedBox(height: 16),
        TextField(
          obscureText: viewModel.value.obscureText,
          readOnly: viewModel.value.isLoading,
          controller: viewModel.newPassphraseController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.value.obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: viewModel.toggleObscureText,
            ),
            hintText: L10n.of(context).newPassphrase,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: viewModel.value.obscureText,
          readOnly: viewModel.value.isLoading,
          controller: viewModel.repeatPassphraseController,
          decoration: InputDecoration(
            hintText: L10n.of(context).repeatPassphrase,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: canCreatePassphrase && !viewModel.value.isLoading
              ? () => viewModel.setOrSkipPassphrase(
                  viewModel.newPassphraseController.text,
                  context,
                )
              : null,
          child: viewModel.value.isLoading
              ? CircularProgressIndicator.adaptive()
              : Text(L10n.of(context).continueText),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: viewModel.value.isLoading
              ? null
              : () => viewModel.setOrSkipPassphrase(null, context),
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
          child: Text(L10n.of(context).skip),
        ),
        const SizedBox(height: 16),
        _PassphraseCheckListTile(
          checked: viewModel.value.newPassphraseEqualsRepeatPassphrase,
          label: L10n.of(context).passphrasesMatch,
        ),
        const SizedBox(height: 16),
        _PassphraseCheckListTile(
          checked: viewModel.value.newPassphraseLongEnough,
          label: L10n.of(context).passphraseLengthRequirement,
        ),
        const SizedBox(height: 16),
        _PassphraseCheckListTile(
          checked: viewModel.value.newPassphraseUpperAndLowerCase,
          label: L10n.of(context).passphraseUpperAndLowerCaseRequirement,
        ),
        const SizedBox(height: 16),
        _PassphraseCheckListTile(
          checked: viewModel.value.newPassphraseSpecialCharacters,
          label: L10n.of(context).passphraseSpecialCharactersRequirement,
        ),
        const SizedBox(height: 16),
        _PassphraseCheckListTile(
          checked: viewModel.value.newPassphraseNumbers,
          label: L10n.of(context).passphraseNumberRequirement,
        ),
      ],
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
