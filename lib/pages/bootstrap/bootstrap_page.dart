import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/bootstrap/view_model/bootstrap_view_model.dart';
import 'package:fluffychat/pages/bootstrap/widgets/new_passphrase_view.dart';
import 'package:fluffychat/pages/bootstrap/widgets/restore_bootstrap_view.dart';
import 'package:fluffychat/pages/bootstrap/widgets/store_recovery_key_view.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/device_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
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

        final title = cryptoIdentityState == null
            ? L10n.of(context).loadingPleaseWait
            : cryptoIdentityState.initialized && !viewModel.value.reset
            ? L10n.of(context).restoreCryptoIdentity
            : viewModel.value.reset
            ? L10n.of(context).resetCryptoIdentity
            : L10n.of(context).setUpCryptoIdentity;

        return LoginScaffold(
          appBar: AppBar(
            leading: CloseButton(
              onPressed: () async {
                final consent = await showOkCancelAlertDialog(
                  context: context,
                  title: L10n.of(context).skipChatBackup,
                  message: L10n.of(context).skipChatBackupWarning,
                  okLabel: L10n.of(context).skip,
                  isDestructive: true,
                );
                if (consent != OkCancelResult.ok) return;
                if (!context.mounted) return;
                context.go('/rooms');
              },
            ),
            title: Text(title),
          ),
          body: cryptoIdentityState == null
              ? Center(child: CircularProgressIndicator.adaptive())
              : !cryptoIdentityState.initialized || viewModel.value.reset
              ? viewModel.value.recoveryKey == null
                    ? NewPassphraseView()
                    : StoreRecoveryKeyView()
              : RestoreBootstrapView(
                  onToggleObscureText: viewModel.toggleObscureText,
                  unlockWithRecoveryKey: () async {
                    final success = await viewModel.unlock();
                    if (!success) return;
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Device has been verified and message backup is unlocked!',
                        ),
                      ),
                    );
                    context.go('/rooms');
                  },
                  recoveryKeyInputController:
                      viewModel.enterPassphraseOrRecovController,
                  obscureText: viewModel.value.obscureText,
                  isLoading: viewModel.value.isLoading,
                  errorText: viewModel.value.unlockWithError?.toLocalizedString(
                    context,
                  ),
                  onResetAccount: () async {
                    final consent = await showOkCancelAlertDialog(
                      context: context,
                      title: L10n.of(context).warning,
                      message:
                          'When you reset your account you will lose the access to your old messages forever. All your current devices need to be verified again. Please only perform this action when you have no other devices left to verify your session and you have lost your recovery key and passphrase!',
                      isDestructive: true,
                      okLabel: L10n.of(context).resetAccount,
                    );
                    if (consent != OkCancelResult.ok) return;
                    if (!context.mounted) return;
                    viewModel.startResetAccount();
                  },
                  devices:
                      viewModel.value.connectedDevices
                          ?.map(
                            (device) => (
                              title: device.displayname,
                              lastActive: device.lastActive,
                              icon: device.icon,
                            ),
                          )
                          .toList() ??
                      [],
                ),
        );
      },
    );
  }
}
