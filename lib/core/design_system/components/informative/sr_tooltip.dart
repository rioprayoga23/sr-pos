import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';
import 'package:sr_pos/core/design_system/theme/sr_theme_context.dart';

class SrTooltip extends StatelessWidget {
  const SrTooltip({
    required this.message,
    required this.child,
    this.waitDuration,
    this.showDuration,
    this.preferBelow,
    this.triggerMode,
    super.key,
  });

  final String message;
  final Widget child;
  final Duration? waitDuration;
  final Duration? showDuration;
  final bool? preferBelow;
  final TooltipTriggerMode? triggerMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.srColors;

    return Tooltip(
      message: message,
      waitDuration: waitDuration,
      showDuration: showDuration,
      preferBelow: preferBelow,
      triggerMode: triggerMode,
      padding: const EdgeInsets.symmetric(
        horizontal: SrSpacing.space12,
        vertical: SrSpacing.space8,
      ),
      decoration: BoxDecoration(
        color: colors.textPrimary,
        borderRadius: BorderRadius.circular(SrRadii.small),
      ),
      textStyle: SrTypography.bodySmall.copyWith(color: colors.surface),
      child: child,
    );
  }
}
