import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/bootstrap/view_model/bootstrap_view_model.dart';
import 'package:fluffychat/pages/bootstrap/widgets/new_passphrase_view.dart';
import 'package:fluffychat/pages/bootstrap/widgets/restore_bootstrap_key.dart';
import 'package:fluffychat/pages/bootstrap/widgets/store_recovery_key_view.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/view_model_builder.dart';

class BootstrapPage extends StatelessWidget {
  const BootstrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder(
      create: () => BootstrapViewModel(client: Matrix.of(context).client),
      builder: (context, viewModel, _) {
        final cryptoIdentityState = viewModel.value.cryptoIdentityState;
        return LoginScaffold(
          appBar: AppBar(title: Text(L10n.of(context).chatBackup)),
          body: cryptoIdentityState == null
              ? Center(child: CircularProgressIndicator.adaptive())
              : !cryptoIdentityState.initialized
              ? viewModel.value.recoveryKey == null
                    ? NewPassphraseView()
                    : StoreRecoveryKeyView()
              : RestoreBootstrapView(),
        );
      },
    );
  }
}
