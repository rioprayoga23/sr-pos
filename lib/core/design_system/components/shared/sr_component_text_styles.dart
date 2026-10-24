import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

abstract final class SrComponentTextStyles {
  static TextStyle inputValue(BuildContext context, {bool enabled = true}) {
    final colors = Theme.of(context).colorScheme;
    return SrTypography.bodyMedium.copyWith(
      color: enabled ? colors.onSurface : colors.onSurfaceVariant,
    );
  }

  static TextStyle inputPlaceholder(BuildContext context) {
    return inputValue(context)
        .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
  }
}
