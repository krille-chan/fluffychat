import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_summary/level_dialog_content.dart';

class LevelBarPopup extends StatelessWidget {
  const LevelBarPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 600,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: const LevelDialogContent(),
        ),
      ),
    );
  }
}
