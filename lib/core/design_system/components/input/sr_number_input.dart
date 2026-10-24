import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

/// A controlled integer stepper.
class SrNumberInput extends StatelessWidget {
  const SrNumberInput({
    required this.value,
    required this.onChanged,
    this.min,
    this.max,
    this.step = 1,
    this.label,
    this.errorText,
    this.semanticLabel,
    super.key,
  }) : assert(step > 0),
       assert(min == null || max == null || min <= max),
       assert(min == null || value >= min),
       assert(max == null || value <= max);

  final int value;
  final int? min;
  final int? max;
  final int step;
  final String? label;
  final String? errorText;
  final String? semanticLabel;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final callback = onChanged;
    final enabled = callback != null;
    final minimum = min;
    final maximum = max;
    final decrement =
        callback == null || (minimum != null && value - step < minimum)
        ? null
        : () => callback(value - step);
    final increment =
        callback == null || (maximum != null && value + step > maximum)
        ? null
        : () => callback(value + step);
    final borderColor = errorText == null ? colors.outline : colors.error;

    final stepper = Semantics(
      label: semanticLabel ?? label,
      value: value.toString(),
      enabled: enabled,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          border: Border.all(color: borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(SrRadii.medium)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: decrement,
              tooltip: 'Decrease',
              icon: const Icon(Icons.remove_rounded),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: kMinInteractiveDimension,
                minHeight: kMinInteractiveDimension,
              ),
              child: Center(
                child: Text(
                  value.toString(),
                  style: SrTypography.actionLarge.copyWith(
                    color: enabled ? colors.onSurface : theme.disabledColor,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: increment,
              tooltip: 'Increase',
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label case final label?) ...[
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: enabled ? colors.onSurface : theme.disabledColor,
            ),
          ),
          const SizedBox(height: SrSpacing.space8),
        ],
        stepper,
        if (errorText case final errorText?) ...[
          const SizedBox(height: SrSpacing.space4),
          Text(
            errorText,
            style: theme.textTheme.bodySmall?.copyWith(color: colors.error),
          ),
        ],
      ],
    );
  }
}
