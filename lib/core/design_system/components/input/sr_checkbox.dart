import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';

/// A controlled SR-POS checkbox with an optional text label.
class SrCheckbox extends StatelessWidget {
  const SrCheckbox({
    required this.value,
    required this.onChanged,
    this.label,
    this.semanticLabel,
    this.isError = false,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? semanticLabel;
  final bool isError;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final callback = onChanged;
    final enabled = callback != null;

    void toggle() => callback?.call(!value);

    return Semantics(
      label: semanticLabel ?? label,
      checked: value,
      enabled: enabled,
      onTap: enabled ? toggle : null,
      child: ExcludeSemantics(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: kMinInteractiveDimension,
          ),
          child: InkWell(
            onTap: enabled ? toggle : null,
            borderRadius: BorderRadius.circular(kMinInteractiveDimension / 2),
            focusNode: focusNode,
            autofocus: autofocus,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IgnorePointer(
                  child: Checkbox(
                    value: value,
                    onChanged: callback == null
                        ? null
                        : (nextValue) => callback(nextValue ?? false),
                    activeColor: colors.primary,
                    checkColor: colors.onPrimary,
                    side: BorderSide(
                      color: isError ? colors.error : colors.outline,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                  ),
                ),
                if (label case final label?) ...[
                  const SizedBox(width: SrSpacing.space8),
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
