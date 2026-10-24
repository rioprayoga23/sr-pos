import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

@immutable
final class SrTabItem {
  const SrTabItem({required this.label, this.icon, this.semanticLabel});

  final String label;
  final Widget? icon;
  final String? semanticLabel;
}

class SrTabs extends StatelessWidget {
  const SrTabs({
    required this.items,
    required this.selectedIndex,
    this.onChanged,
    this.semanticLabel,
    super.key,
  }) : assert(items.length >= 2),
       assert(selectedIndex >= 0 && selectedIndex < items.length);

  final Iterable<SrTabItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final callback = onChanged;

    return Semantics(
      label: semanticLabel,
      container: true,
      child: Material(
        color: colors.surface,
        child: Row(
          children: [
            for (final entry in items.indexed)
              Expanded(
                child: _Tab(
                  item: entry.$2,
                  selected: entry.$1 == selectedIndex,
                  onTap: callback == null ? null : () => callback(entry.$1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.item, required this.selected, required this.onTap});

  final SrTabItem item;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final foreground = selected ? colors.primary : colors.onSurfaceVariant;

    return Semantics(
      label: item.semanticLabel ?? item.label,
      button: true,
      selected: selected,
      enabled: onTap != null,
      inMutuallyExclusiveGroup: true,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SrRadii.small),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: kMinInteractiveDimension,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                SrSpacing.space8,
                SrSpacing.space8,
                SrSpacing.space8,
                SrSpacing.space4,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (item.icon case final icon?) ...[
                    IconTheme.merge(
                      data: IconThemeData(
                        color: foreground,
                        size: SrSizing.size24,
                      ),
                      child: icon,
                    ),
                    const SizedBox(height: SrSpacing.space4),
                  ],
                  Text(
                    item.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: SrTypography.actionMedium.copyWith(
                      color: foreground,
                    ),
                  ),
                  const SizedBox(height: SrSpacing.space8),
                  if (selected)
                    Container(
                      height: SrSizing.size4,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(SrRadii.pill),
                      ),
                    )
                  else
                    const SizedBox(height: SrSizing.size4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
