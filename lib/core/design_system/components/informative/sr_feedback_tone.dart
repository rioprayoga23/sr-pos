import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/theme/sr_theme_context.dart';

enum SrFeedbackTone { neutral, info, success, warning, error }

@immutable
final class SrFeedbackPalette {
  const SrFeedbackPalette({
    required this.background,
    required this.foreground,
    required this.border,
    required this.solid,
    required this.onSolid,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final Color solid;
  final Color onSolid;
}

extension SrFeedbackToneTheme on SrFeedbackTone {
  SrFeedbackPalette resolve(BuildContext context) {
    final colors = context.srColors;
    final statusColors = context.srStatusColors;
    final colorScheme = Theme.of(context).colorScheme;

    return switch (this) {
      SrFeedbackTone.neutral => SrFeedbackPalette(
        background: colors.surfaceSubtle,
        foreground: colors.textPrimary,
        border: colors.borderSubtle,
        solid: colors.textPrimary,
        onSolid: colors.surface,
      ),
      SrFeedbackTone.info => SrFeedbackPalette(
        background: colors.brandSubtle,
        foreground: colors.brand,
        border: colors.brandAccent,
        solid: colors.brand,
        onSolid: colorScheme.onPrimary,
      ),
      SrFeedbackTone.success => SrFeedbackPalette(
        background: statusColors.successContainer,
        foreground: statusColors.success,
        border: statusColors.successAccent,
        solid: statusColors.success,
        onSolid: statusColors.onSuccess,
      ),
      SrFeedbackTone.warning => SrFeedbackPalette(
        background: statusColors.warningContainer,
        foreground: statusColors.warning,
        border: statusColors.warningAccent,
        solid: statusColors.warning,
        onSolid: statusColors.onWarning,
      ),
      SrFeedbackTone.error => SrFeedbackPalette(
        background: colorScheme.errorContainer,
        foreground: colorScheme.error,
        border: colorScheme.error,
        solid: colorScheme.error,
        onSolid: colorScheme.onError,
      ),
    };
  }

  IconData get icon {
    return switch (this) {
      SrFeedbackTone.neutral => Icons.notifications_none_rounded,
      SrFeedbackTone.info => Icons.info_outline_rounded,
      SrFeedbackTone.success => Icons.check_circle_outline_rounded,
      SrFeedbackTone.warning => Icons.warning_amber_rounded,
      SrFeedbackTone.error => Icons.error_outline_rounded,
    };
  }
}
