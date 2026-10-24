import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

class SrFilter extends StatelessWidget {
  const SrFilter({
    required this.label,
    required this.selected,
    this.onSelected,
    this.leading,
    this.trailing,
    this.semanticLabel,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final Widget? leading;
  final Widget? trailing;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final enabled = onSelected != null;
    final foreground = !enabled
        ? theme.disabledColor
        : selected
        ? colors.onPrimaryContainer
        : colors.onSurface;

    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      selected: selected,
      enabled: enabled,
      child: ExcludeSemantics(
        child: FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading case final leadingWidget?) ...[
                IconTheme.merge(
                  data: IconThemeData(color: foreground, size: SrSizing.size16),
                  child: leadingWidget,
                ),
                const SizedBox(width: SrSpacing.space8),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: SrTypography.actionMedium.copyWith(color: foreground),
                ),
              ),
              if (trailing case final trailingWidget?) ...[
                const SizedBox(width: SrSpacing.space8),
                IconTheme.merge(
                  data: IconThemeData(color: foreground, size: SrSizing.size16),
                  child: trailingWidget,
                ),
              ],
            ],
          ),
          selected: selected,
          onSelected: onSelected,
          showCheckmark: false,
          backgroundColor: colors.surface,
          selectedColor: colors.primaryContainer,
          disabledColor: colors.surfaceContainerHighest,
          side: BorderSide(color: selected ? colors.primary : colors.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SrRadii.pill),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SrSpacing.space8,
            vertical: SrSpacing.space4,
          ),
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
    );
  }
}
