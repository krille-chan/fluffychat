import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

// AddBridge page title and subtitle

Widget buildHeaderBridgeText(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text(
      L10n.of(context)!.addSocialMessagingAccounts,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        // color: Color(0xFFFAAB22),
      ),
    ),
  );
}

Widget buildHeaderBridgeSubText(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text(
      L10n.of(context)!.addSocialMessagingAccountsText,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16.0),
    ),
  );
}
