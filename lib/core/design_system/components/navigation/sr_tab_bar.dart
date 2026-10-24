import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

@immutable
final class SrTabBarItem {
  const SrTabBarItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.semanticLabel,
    this.enabled = true,
  });

  final String label;
  final Widget icon;
  final Widget? selectedIcon;
  final String? semanticLabel;
  final bool enabled;
}

/// A controlled bottom tab bar for primary app destinations.
class SrTabBar extends StatelessWidget {
  SrTabBar({
    required List<SrTabBarItem> items,
    required this.currentIndex,
    required this.onChanged,
    this.semanticLabel,
    this.showLabels = true,
    this.backgroundColor,
    super.key,
  }) : items = List<SrTabBarItem>.unmodifiable(items),
       assert(items.length >= 2),
       assert(currentIndex >= 0 && currentIndex < items.length);

  final List<SrTabBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onChanged;
  final String? semanticLabel;
  final bool showLabels;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final callback = onChanged;

    return Semantics(
      label: semanticLabel,
      container: true,
      explicitChildNodes: true,
      child: Material(
        color: backgroundColor ?? colors.surface,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: SrSizing.size64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = 0; index < items.length; index++)
                  Expanded(
                    child: _TabBarDestination(
                      item: items[index],
                      selected: index == currentIndex,
                      showLabel: showLabels,
                      onTap: callback == null || !items[index].enabled
                          ? null
                          : () => callback(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabBarDestination extends StatelessWidget {
  const _TabBarDestination({
    required this.item,
    required this.selected,
    required this.showLabel,
    required this.onTap,
  });

  final SrTabBarItem item;
  final bool selected;
  final bool showLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final enabled = onTap != null;
    final foreground = !enabled
        ? theme.disabledColor
        : selected
        ? colors.primary
        : colors.onSurfaceVariant;

    return Semantics(
      label: item.semanticLabel ?? item.label,
      button: true,
      selected: selected,
      enabled: enabled,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SrSpacing.space4,
              vertical: SrSpacing.space8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconTheme.merge(
                  data: IconThemeData(
                    size: SrSizing.iconLarge,
                    color: foreground,
                  ),
                  child: selected ? item.selectedIcon ?? item.icon : item.icon,
                ),
                if (showLabel) ...[
                  const SizedBox(height: SrSpacing.space4),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: SrTypography.actionSmall.copyWith(color: foreground),
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
