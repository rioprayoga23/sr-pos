import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

abstract final class SrComponentTextStyles {
  static TextStyle inputValue(BuildContext context, {bool enabled = true}) {
    final colors = Theme.of(context).colorScheme;
    return SrTypography.bodyMedium.copyWith(
      inherit: false,
      color: enabled ? colors.onSurface : colors.onSurfaceVariant,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: SrTypography.bodyMedium.letterSpacing ?? 0,
      wordSpacing: SrTypography.bodyMedium.wordSpacing ?? 0,
    );
  }

  static TextStyle inputPlaceholder(
    BuildContext context, {
    required TextStyle valueStyle,
  }) {
    return valueStyle.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}
