import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

/// A consistent one- or two-line row for settings, menus, and result lists.
class SrListItem extends StatelessWidget {
  const SrListItem({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showChevron = false,
    this.selected = false,
    this.enabled = true,
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool showChevron;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = enabled
        ? scheme.onSurface
        : scheme.onSurface.withValues(alpha: 0.38);
    final secondary = enabled
        ? scheme.onSurfaceVariant
        : scheme.onSurfaceVariant.withValues(alpha: 0.38);

    final content = ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: SrComponentMetrics.listItemMinHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SrSpacing.space16,
          vertical: SrSpacing.space8,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              SizedBox.square(
                dimension: SrComponentMetrics.avatarSize,
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(color: foreground),
                    child: leading!,
                  ),
                ),
              ),
              const SizedBox(width: SrSpacing.space12),
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SrTypography.actionLarge.copyWith(color: foreground),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: SrSpacing.space4),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: SrTypography.bodySmall.copyWith(color: secondary),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: SrSpacing.space12),
              trailing!,
            ] else if (showChevron) ...[
              const SizedBox(width: SrSpacing.space12),
              Icon(
                Icons.chevron_right_rounded,
                color: secondary,
                semanticLabel: 'Open',
              ),
            ],
          ],
        ),
      ),
    );

    return Semantics(
      label: semanticLabel ?? [title, subtitle].whereType<String>().join(', '),
      button: onTap != null,
      enabled: enabled,
      selected: selected,
      child: Material(
        color: selected ? scheme.primaryContainer : SrColors.transparent,
        child: InkWell(onTap: enabled ? onTap : null, child: content),
      ),
    );
  }
}
