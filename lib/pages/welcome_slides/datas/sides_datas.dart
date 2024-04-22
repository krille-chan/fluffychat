import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class WelcomeSlide {
  final String gifAsset;
  final String Function(BuildContext) textKey;

  WelcomeSlide({
    required this.gifAsset,
    required this.textKey,
  });
}

final List<WelcomeSlide> slidesData = [
  WelcomeSlide(
    gifAsset: "assets/welcome_slide_1.gif",
    textKey: (context) => L10n.of(context)!.slide_one,
  ),
  WelcomeSlide(
    gifAsset: "assets/welcome_slide_2.gif",
    textKey: (context) => L10n.of(context)!.slide_two,
  ),
  WelcomeSlide(
    gifAsset: "assets/welcome_slide_3.gif",
    textKey: (context) => L10n.of(context)!.slide_three,
  ),
  WelcomeSlide(
    gifAsset: "assets/welcome_slide_4.gif",
    textKey: (context) => L10n.of(context)!.slide_four,
  ),
];
