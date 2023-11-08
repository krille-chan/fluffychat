import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../../config/app_config.dart';
import '../../../pages/chat/chat.dart';

class LanguageDisplayToggle extends StatelessWidget {
  const LanguageDisplayToggle({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ChatController controller;

  get onPressed =>
      controller.choreographer.messageOptions.toggleSelectedDisplayLang;

  @override
  Widget build(BuildContext context) {
    if (!controller.choreographer.translationEnabled) {
      return const SizedBox();
    }
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: controller.choreographer.messageOptions.isTranslationOn
            ? AppConfig.primaryColor
            : null,
      ),
      child: IconButton(
        tooltip: L10n.of(context)!.toggleLanguages,
        onPressed: onPressed,
        icon: const Icon(Icons.translate_outlined),
        selectedIcon: const Icon(Icons.translate),
        isSelected: controller.choreographer.messageOptions.isTranslationOn,
      ),
    );
    // return Tooltip(
    //   message: L10n.of(context)!.toggleLanguages,
    //   waitDuration: const Duration(milliseconds: 1000),
    //   child: FloatingActionButton(
    //     onPressed: onPressed,
    //     backgroundColor: Colors.white,
    //     mini: false,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(200), // <-- Radius
    //     ),
    //     child: LanguageFlag(
    //       flagUrl: controller
    //           .choreographer.messageOptions.displayLang?.languageFlag,
    //       size: 50,
    //     ),
    //   ),
    // );
  }
}
