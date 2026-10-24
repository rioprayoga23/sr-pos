import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/components/sr_component_size.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

enum SrListItemSelectedStyle { subtle, primary }

/// A consistent one- or two-line row for settings, menus, and result lists.
class SrListItem extends StatelessWidget {
  const SrListItem({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showChevron = false,
    this.selected = false,
    this.selectedStyle = SrListItemSelectedStyle.subtle,
    this.size = SrComponentSize.medium,
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
  final SrListItemSelectedStyle selectedStyle;
  final SrComponentSize size;
  final bool enabled;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = enabled
        ? selected && selectedStyle == SrListItemSelectedStyle.primary
              ? scheme.onPrimary
              : scheme.onSurface
        : scheme.onSurface.withValues(alpha: 0.38);
    final secondary = enabled
        ? selected && selectedStyle == SrListItemSelectedStyle.primary
              ? scheme.onPrimary
              : scheme.onSurfaceVariant
        : scheme.onSurfaceVariant.withValues(alpha: 0.38);

    final isSmall = size == SrComponentSize.small;
    final isRoundedPrimarySelection =
        selected && selectedStyle == SrListItemSelectedStyle.primary;
    final leadingSize = isSmall
        ? SrComponentMetrics.smallListItemLeadingSize
        : SrComponentMetrics.avatarSize;
    final isLeadingOnly =
        title.isEmpty &&
        subtitle == null &&
        leading != null &&
        trailing == null &&
        !showChevron;
    final content = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: isSmall
            ? SrComponentMetrics.smallListItemMinHeight
            : SrComponentMetrics.listItemMinHeight,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall
              ? SrComponentMetrics.smallListItemHorizontalPadding
              : SrSpacing.space16,
          vertical: isSmall
              ? SrComponentMetrics.smallListItemVerticalPadding
              : SrSpacing.space8,
        ),
        child: isLeadingOnly
            ? Center(
                child: SizedBox.square(
                  dimension: leadingSize,
                  child: Center(
                    child: IconTheme(
                      data: IconThemeData(color: foreground),
                      child: leading!,
                    ),
                  ),
                ),
              )
            : Row(
                children: [
                  if (leading != null) ...[
                    SizedBox.square(
                      dimension: leadingSize,
                      child: Center(
                        child: IconTheme(
                          data: IconThemeData(color: foreground),
                          child: leading!,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: isSmall ? SrSpacing.space8 : SrSpacing.space12,
                    ),
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
                          style:
                              (isSmall
                                      ? SrTypography.actionMedium
                                      : SrTypography.actionLarge)
                                  .copyWith(color: foreground),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: SrSpacing.space4),
                          Text(
                            subtitle!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: SrTypography.bodySmall.copyWith(
                              color: secondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    SizedBox(
                      width: isSmall ? SrSpacing.space8 : SrSpacing.space12,
                    ),
                    trailing!,
                  ] else if (showChevron) ...[
                    SizedBox(
                      width: isSmall ? SrSpacing.space8 : SrSpacing.space12,
                    ),
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
        color: selected
            ? switch (selectedStyle) {
                SrListItemSelectedStyle.subtle => scheme.primaryContainer,
                SrListItemSelectedStyle.primary => scheme.primary,
              }
            : SrColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: isRoundedPrimarySelection
              ? BorderRadius.circular(SrRadii.medium)
              : BorderRadius.zero,
        ),
        clipBehavior: isRoundedPrimarySelection ? Clip.antiAlias : Clip.none,
        child: InkWell(onTap: enabled ? onTap : null, child: content),
      ),
    );
  }
}
