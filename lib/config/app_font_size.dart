import 'package:flutter/widgets.dart';

import 'setting_keys.dart';

/// Listenable mirror of [AppSettings.fontSizeFactor] so the global
/// [MediaQuery.textScaler] wrapper rebuilds when the slider moves.
final ValueNotifier<double> fontSizeFactorNotifier = ValueNotifier<double>(
  AppSettings.fontSizeFactor.value,
);

/// Multiplies an inner [TextScaler] by a linear factor, preserving
/// non-linear OS behavior (e.g. iOS Dynamic Type) on top of the user
/// font-size preference.
@immutable
class ScaledTextScaler extends TextScaler {
  const ScaledTextScaler(this.inner, this.factor);

  final TextScaler inner;
  final double factor;

  @override
  double scale(double fontSize) => inner.scale(fontSize) * factor;

  @override
  // ignore: deprecated_member_use
  double get textScaleFactor => inner.textScaleFactor * factor;

  @override
  bool operator ==(Object other) =>
      other is ScaledTextScaler &&
      other.inner == inner &&
      other.factor == factor;

  @override
  int get hashCode => Object.hash(inner, factor);
}
