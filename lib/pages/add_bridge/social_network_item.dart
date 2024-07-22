import 'package:flutter/material.dart';
import 'package:tawkie/pages/add_bridge/model/social_network.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

Widget buildSubtitle(BuildContext context, SocialNetwork network) {
  if (network.loading) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: CircularProgressIndicator(
        color: Colors.grey,
      ),
    );
  } else {
    if (!network.error) {
      return Text(
        network.connected
            ? L10n.of(context)!.connected
            : L10n.of(context)!.notConnected,
        style: TextStyle(
          color: network.connected ? Colors.green : Colors.grey,
        ),
      );
    } else {
      return Text(
        L10n.of(context)!.errLoading,
        style: const TextStyle(
          color: Colors.red,
        ),
      );
    }
  }
}
