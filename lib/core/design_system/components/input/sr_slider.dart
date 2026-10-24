import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';

/// A controlled slider with optional label and validation message.
class SrSlider extends StatelessWidget {
  const SrSlider({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.label,
    this.errorText,
    this.semanticFormatterCallback,
    this.onChangeStart,
    this.onChangeEnd,
    super.key,
  }) : assert(min < max),
       assert(value >= min && value <= max),
       assert(divisions == null || divisions > 0);

  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final String? errorText;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final SemanticFormatterCallback? semanticFormatterCallback;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final enabled = onChanged != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label case final label?) ...[
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: enabled ? colors.onSurface : theme.disabledColor,
            ),
          ),
          const SizedBox(height: SrSpacing.space4),
        ],
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: errorText == null ? colors.primary : colors.error,
            inactiveTrackColor: colors.surfaceContainerHighest,
            thumbColor: errorText == null ? colors.primary : colors.error,
            disabledActiveTrackColor: theme.disabledColor,
            disabledInactiveTrackColor: colors.surfaceContainerHigh,
            disabledThumbColor: theme.disabledColor,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: divisions == null ? null : value.toString(),
            onChanged: onChanged,
            onChangeStart: enabled ? onChangeStart : null,
            onChangeEnd: enabled ? onChangeEnd : null,
            semanticFormatterCallback: semanticFormatterCallback,
          ),
        ),
        if (errorText case final errorText?)
          Padding(
            padding: const EdgeInsets.only(left: SrSpacing.space16),
            child: Text(
              errorText,
              style: theme.textTheme.bodySmall?.copyWith(color: colors.error),
            ),
          ),
      ],
    );
  }
}
