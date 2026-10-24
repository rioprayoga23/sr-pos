import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';

class SrPaginationDots extends StatelessWidget {
  const SrPaginationDots({
    required this.itemCount,
    required this.currentIndex,
    this.onDotPressed,
    this.semanticLabel = 'Pagination',
    super.key,
  }) : assert(itemCount > 0),
       assert(currentIndex >= 0 && currentIndex < itemCount);

  final int itemCount;
  final int currentIndex;
  final ValueChanged<int>? onDotPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < itemCount; index++) ...[
            if (index > 0 && onDotPressed == null)
              const SizedBox(width: SrSpacing.space8),
            _PaginationDot(
              selected: index == currentIndex,
              index: index,
              itemCount: itemCount,
              onPressed: onDotPressed == null
                  ? null
                  : () => onDotPressed!(index),
            ),
          ],
        ],
      ),
    );
  }
}

class _PaginationDot extends StatelessWidget {
  const _PaginationDot({
    required this.selected,
    required this.index,
    required this.itemCount,
    required this.onPressed,
  });

  final bool selected;
  final int index;
  final int itemCount;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dot = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: selected
          ? SrComponentMetrics.paginationActiveDotWidth
          : SrComponentMetrics.paginationDotSize,
      height: SrComponentMetrics.paginationDotSize,
      decoration: BoxDecoration(
        color: selected ? scheme.primary : scheme.outline,
        borderRadius: BorderRadius.circular(SrRadii.pill),
      ),
    );

    return Semantics(
      label: 'Page ${index + 1} of $itemCount',
      selected: selected,
      button: onPressed != null,
      child: onPressed == null
          ? dot
          : Material(
              color: SrColors.transparent,
              child: InkResponse(
                onTap: onPressed,
                radius: kMinInteractiveDimension / 2,
                child: SizedBox.square(
                  dimension: kMinInteractiveDimension,
                  child: Center(child: dot),
                ),
              ),
            ),
    );
  }
}
