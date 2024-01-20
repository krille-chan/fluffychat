import 'package:fluffychat/pangea/widgets/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../../config/app_config.dart';
import '../../../pages/chat/chat.dart';

class LanguageDisplayToggle extends StatelessWidget {
  const LanguageDisplayToggle({
    super.key,
    required this.controller,
  });

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

class LanguageToggleSwitch extends StatefulWidget {
  final ChatController controller;

  const LanguageToggleSwitch({super.key, required this.controller});

  @override
  _LanguageToggleSwitchState createState() => _LanguageToggleSwitchState();
}

class _LanguageToggleSwitchState extends State<LanguageToggleSwitch> {
  @override
  Widget build(BuildContext context) {
    final borderRadius =
        BorderRadius.circular(20.0); // Use the same radius as your LanguageFlag

    return Tooltip(
      message: L10n.of(context)!.toggleLanguages,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent, // No background color
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: EdgeInsets.zero, // Aligns with your custom padding
        ),
        onPressed: _toggleLanguage, // Use the onTap logic for onPressed
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .background, // Adapt to your app theme or custom color
            borderRadius: borderRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //trranslatte icon
              Opacity(
                opacity: isL1Selected ? 1.0 : 0.6,
                child: LanguageFlag(
                  language: widget.controller.choreographer.l1Lang,
                ),
              ),
              const SizedBox(width: 8.0), // Spacing between flags
              Opacity(
                opacity: isL1Selected ? 0.6 : 1.0,
                child: LanguageFlag(
                  language: widget.controller.choreographer.l2Lang,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get isL1Selected =>
      widget.controller.choreographer.messageOptions.isTranslationOn;

  void _toggleLanguage() {
    setState(() {
      widget.controller.choreographer.messageOptions
          .toggleSelectedDisplayLang();
    });
  }
}
