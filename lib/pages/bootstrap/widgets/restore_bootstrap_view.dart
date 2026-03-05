import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/date_time_extension.dart';

class RestoreBootstrapView extends StatelessWidget {
  final List<({String title, DateTime lastActive, IconData icon})> devices;
  final TextEditingController recoveryKeyInputController;
  final bool obscureText, isLoading;
  final VoidCallback onToggleObscureText, unlockWithRecoveryKey, onResetAccount;
  final String? errorText;

  const RestoreBootstrapView({
    super.key,
    required this.devices,
    required this.recoveryKeyInputController,
    required this.obscureText,
    required this.onToggleObscureText,
    required this.unlockWithRecoveryKey,
    required this.isLoading,
    this.errorText,
    required this.onResetAccount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 16.0,
        crossAxisAlignment: .stretch,
        children: [
          Text(
            devices.isEmpty
                ? L10n.of(context).restoreBootstrapEmptyDevicesDescription
                : L10n.of(context).restoreBootstrapDevicesDescription,
            textAlign: .center,
          ),
          Material(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 128),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: devices.length,
                itemBuilder: (context, i) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    child: Icon(devices[i].icon),
                  ),
                  title: Text(devices[i].title),
                  subtitle: Text(
                    L10n.of(context).lastActiveAgo(
                      devices[i].lastActive.localizedTime(context),
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (devices.isNotEmpty) ...[
            Divider(height: 32),
            Text(
              L10n.of(context).restoreBootstrapAlternativeDescription,
              textAlign: .center,
            ),
          ],
          TextField(
            readOnly: isLoading,
            obscureText: obscureText,
            controller: recoveryKeyInputController,
            decoration: InputDecoration(
              hintText: L10n.of(context).restoreBootstrapHintText,
              prefixIcon: IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: onToggleObscureText,
              ),
              errorText: errorText,
              errorMaxLines: 4,
              suffixIcon: isLoading
                  ? SizedBox.square(
                      dimension: 32,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : IconButton(
                      icon: Icon(Icons.send_outlined),
                      onPressed: unlockWithRecoveryKey,
                    ),
            ),
          ),
          TextButton(
            onPressed: onResetAccount,
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: Text(L10n.of(context).resetAccount),
          ),
        ],
      ),
    );
  }
}
