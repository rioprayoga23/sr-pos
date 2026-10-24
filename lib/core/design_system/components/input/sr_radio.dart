import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_borders.dart';
import 'package:sr_pos/core/design_system/foundations/sr_motion.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';

/// A controlled radio option.
///
/// Radio options that share a [groupValue] should use the same value type and
/// callback in their parent. A null [onChanged] disables this option.
class SrRadio<T> extends StatelessWidget {
  const SrRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.semanticLabel,
    this.isError = false,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String? label;
  final String? semanticLabel;
  final bool isError;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final selected = value == groupValue;
    final callback = onChanged;
    final enabled = callback != null;
    final indicatorColor = enabled
        ? (isError ? colors.error : colors.primary)
        : theme.disabledColor;

    return Semantics(
      label: semanticLabel ?? label,
      inMutuallyExclusiveGroup: true,
      checked: selected,
      enabled: enabled,
      onTap: callback == null ? null : () => callback(value),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
        child: InkWell(
          onTap: callback == null ? null : () => callback(value),
          borderRadius: const BorderRadius.all(Radius.circular(SrRadii.pill)),
          focusNode: focusNode,
          autofocus: autofocus,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: SrSpacing.space12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: SrMotion.fast,
                  curve: SrMotion.standardCurve,
                  width: SrSizing.size24,
                  height: SrSizing.size24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: indicatorColor,
                      width: SrBorders.focus,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: selected
                      ? Container(
                          width: SrSizing.size12,
                          height: SrSizing.size12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: indicatorColor,
                          ),
                        )
                      : null,
                ),
                if (label case final label?) ...[
                  const SizedBox(width: SrSpacing.space12),
                  Flexible(
                    child: Text(
                      label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: enabled ? colors.onSurface : theme.disabledColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
