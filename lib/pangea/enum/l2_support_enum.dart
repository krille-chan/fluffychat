import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

enum L2SupportEnum {
  na,
  alpha,
  beta,
  full,
}

extension L2SupportEnumExtension on L2SupportEnum {
  String get storageString {
    switch (this) {
      case L2SupportEnum.na:
        return 'na';
      case L2SupportEnum.alpha:
        return 'alpha';
      case L2SupportEnum.beta:
        return 'beta';
      case L2SupportEnum.full:
        return 'full';
    }
  }

  L2SupportEnum fromStorageString(String storageString) {
    switch (storageString) {
      case 'na':
      case 'L2SupportEnum.na':
        return L2SupportEnum.na;
      case 'alpha':
      case 'L2SupportEnum.alpha':
        return L2SupportEnum.alpha;
      case 'beta':
      case 'L2SupportEnum.beta':
        return L2SupportEnum.beta;
      case 'full':
      case 'L2SupportEnum.full':
        return L2SupportEnum.full;
      default:
        throw Exception('Unknown L2SupportEnum storage string: $storageString');
    }
  }

  String toLocalizedString(BuildContext context) {
    final l10n = L10n.of(context);

    switch (this) {
      case L2SupportEnum.na:
        return l10n.l2SupportNa;
      case L2SupportEnum.alpha:
        return l10n.l2SupportAlpha;
      case L2SupportEnum.beta:
        return l10n.l2SupportBeta;
      case L2SupportEnum.full:
        return l10n.l2SupportFull;
    }
  }

  Badge toBadge(BuildContext context) {
    final theme = Theme.of(context);
    Color color;
    String label;

    switch (this) {
      case L2SupportEnum.na:
        color = theme.colorScheme.onSurface.withAlpha(100); // Muted grey
        label = toLocalizedString(context);
        break;
      case L2SupportEnum.alpha:
        color = theme.colorScheme.primary.withAlpha(100); // Subtle primary
        label = toLocalizedString(context);
        break;
      case L2SupportEnum.beta:
        color = theme.colorScheme.secondary.withAlpha(100); // Subtle secondary
        label = toLocalizedString(context);
        break;
      case L2SupportEnum.full:
        color = theme.colorScheme.tertiary.withAlpha(100); // Subtle tertiary
        label = toLocalizedString(context);
        break;
    }

    return Badge(
      label: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withAlpha(200), // Dimmed text
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      smallSize: 20, // A smaller badge for subtlety
    );
  }
}
