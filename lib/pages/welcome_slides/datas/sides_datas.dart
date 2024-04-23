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
    textKey: (context) => L10n.of(context)!.slideOne,
  ),
  WelcomeSlide(
    gifAsset: "assets/welcome_slide_2.gif",
    textKey: (context) => L10n.of(context)!.slideTwo,
  ),
  WelcomeSlide(
    gifAsset: "assets/welcome_slide_3.gif",
    textKey: (context) => L10n.of(context)!.slideThree,
  ),
  WelcomeSlide(
    gifAsset: "assets/welcome_slide_4.gif",
    textKey: (context) => L10n.of(context)!.slideFour,
  ),
];
