import 'package:flutter/material.dart';

import 'package:fluffychat/widgets/avatar.dart';
import '../models/language_model.dart';

class LanguageFlag extends StatelessWidget {
  final LanguageModel? language;
  final double size;
  const LanguageFlag({
    super.key,
    required this.language,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Avatar(
      name: language?.langCode,
      size: size,
    );
  }
}
