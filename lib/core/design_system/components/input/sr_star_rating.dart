import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';

/// A controlled star rating.
class SrStarRating extends StatelessWidget {
  const SrStarRating({
    required this.value,
    required this.onChanged,
    this.itemCount = 5,
    this.semanticLabel = 'Rating',
    this.filledIcon = Icons.star_rounded,
    this.halfFilledIcon = Icons.star_half_rounded,
    this.emptyIcon = Icons.star_outline_rounded,
    super.key,
  }) : assert(itemCount > 0),
       assert(value >= 0 && value <= itemCount);

  final double value;
  final ValueChanged<double>? onChanged;
  final int itemCount;
  final String semanticLabel;
  final IconData filledIcon;
  final IconData halfFilledIcon;
  final IconData emptyIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final callback = onChanged;
    final enabled = callback != null;

    return Semantics(
      label: semanticLabel,
      value:
          '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)} '
          'of $itemCount',
      enabled: enabled,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(itemCount, (index) {
          final lowerBound = index.toDouble();
          final upperBound = index + 1.0;
          final icon = value >= upperBound
              ? filledIcon
              : value > lowerBound
              ? halfFilledIcon
              : emptyIcon;

          return IconButton(
            onPressed: callback == null ? null : () => callback(upperBound),
            tooltip: '$semanticLabel ${index + 1} of $itemCount',
            iconSize: SrSizing.size24,
            color: enabled ? colors.primary : theme.disabledColor,
            icon: Icon(icon),
          );
        }),
      ),
    );
  }
}
