import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';

/// A controlled on/off toggle with an optional label.
class SrToggle extends StatelessWidget {
  const SrToggle({
    required this.value,
    required this.onChanged,
    this.label,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final callback = onChanged;
    final enabled = callback != null;

    return Semantics(
      label: semanticLabel ?? label,
      toggled: value,
      enabled: enabled,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: value,
              onChanged: callback,
              focusNode: focusNode,
              autofocus: autofocus,
              activeThumbColor: colors.onPrimary,
              activeTrackColor: colors.primary,
              inactiveThumbColor: enabled
                  ? colors.onSurfaceVariant
                  : theme.disabledColor,
              inactiveTrackColor: colors.surfaceContainerHighest,
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
    );
  }
}
