import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

class SrProgressBar extends StatelessWidget {
  const SrProgressBar({
    this.value,
    this.label,
    this.showPercentage = false,
    this.semanticLabel,
    super.key,
  }) : assert(value == null || (value >= 0 && value <= 1));

  final double? value;
  final String? label;
  final bool showPercentage;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final percentage = value == null ? null : '${(value! * 100).round()}%';

    return Semantics(
      label: semanticLabel ?? label ?? 'Progress',
      value: percentage ?? 'In progress',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null || (showPercentage && percentage != null)) ...[
            Row(
              children: [
                if (label != null)
                  Expanded(
                    child: Text(
                      label!,
                      style: SrTypography.actionMedium.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  )
                else
                  const Spacer(),
                if (showPercentage && percentage != null)
                  Text(
                    percentage,
                    style: SrTypography.captionMedium.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: SrSpacing.space8),
          ],
          ClipRRect(
            borderRadius: BorderRadius.circular(SrRadii.pill),
            child: LinearProgressIndicator(
              value: value,
              minHeight: SrComponentMetrics.progressTrackHeight,
              color: scheme.primary,
              backgroundColor: scheme.surfaceContainer,
            ),
          ),
        ],
      ),
    );
  }
}
