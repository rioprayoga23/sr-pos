import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/components/sr_component_size.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

@immutable
final class SrShoppingCartItemData {
  const SrShoppingCartItemData({
    required this.title,
    required this.priceLabel,
    required this.quantity,
    this.subtitle,
    this.semanticLabel,
  }) : assert(quantity >= 0);

  final String title;
  final String priceLabel;
  final int quantity;
  final String? subtitle;
  final String? semanticLabel;
}

class SrShoppingCartItem extends StatelessWidget {
  const SrShoppingCartItem({
    required this.item,
    this.image,
    this.metadata,
    this.size = SrComponentSize.medium,
    this.minimumQuantity = 1,
    this.maximumQuantity,
    this.onQuantityChanged,
    this.onRemove,
    this.enabled = true,
    super.key,
  }) : assert(minimumQuantity >= 0),
       assert(maximumQuantity == null || maximumQuantity >= minimumQuantity);

  final SrShoppingCartItemData item;
  final Widget? image;
  final Widget? metadata;
  final SrComponentSize size;
  final int minimumQuantity;
  final int? maximumQuantity;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback? onRemove;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final canDecrease =
        enabled && onQuantityChanged != null && item.quantity > minimumQuantity;
    final canIncrease =
        enabled &&
        onQuantityChanged != null &&
        (maximumQuantity == null || item.quantity < maximumQuantity!);
    final foreground = enabled
        ? scheme.onSurface
        : scheme.onSurface.withValues(alpha: 0.38);
    final secondary = enabled
        ? scheme.onSurfaceVariant
        : scheme.onSurfaceVariant.withValues(alpha: 0.38);
    final isSmall = size == SrComponentSize.small;
    final mediaSize = isSmall
        ? SrComponentMetrics.smallCartMediaSize
        : SrComponentMetrics.cartMediaSize;

    return Semantics(
      container: true,
      enabled: enabled,
      label:
          item.semanticLabel ??
          '${item.title}, ${item.priceLabel}, quantity ${item.quantity}',
      child: Padding(
        padding: isSmall
            ? const EdgeInsets.only(
                top: SrComponentMetrics.smallCartTopPadding,
                bottom: SrSpacing.none,
              )
            : const EdgeInsets.symmetric(vertical: SrSpacing.space8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(SrRadii.medium),
              child: SizedBox.square(
                dimension: mediaSize,
                child: ColoredBox(
                  color: scheme.primaryContainer,
                  child:
                      image ??
                      Icon(
                        Icons.image_outlined,
                        size: SrSizing.size32,
                        color: scheme.onPrimaryContainer,
                      ),
                ),
              ),
            ),
            SizedBox(
              width: isSmall
                  ? SrComponentMetrics.smallCartHorizontalGap
                  : SrSpacing.space12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: isSmall && item.subtitle != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: SrTypography.heading5.copyWith(
                                        color: foreground,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: SrSpacing.space8),
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      item.subtitle!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                      style: SrTypography.bodySmall.copyWith(
                                        color: secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                item.title,
                                maxLines: isSmall ? 1 : 2,
                                overflow: TextOverflow.ellipsis,
                                style: SrTypography.heading5.copyWith(
                                  color: foreground,
                                ),
                              ),
                      ),
                      if (!isSmall && onRemove != null)
                        IconButton(
                          onPressed: enabled ? onRemove : null,
                          tooltip: 'Remove ${item.title}',
                          color: scheme.error,
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                    ],
                  ),
                  if (item.subtitle != null && !isSmall) ...[
                    const SizedBox(height: SrSpacing.space4),
                    Text(
                      item.subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: SrTypography.bodySmall.copyWith(color: secondary),
                    ),
                  ],
                  if (metadata != null) ...[
                    const SizedBox(height: SrSpacing.space4),
                    metadata!,
                  ],
                  SizedBox(
                    height: isSmall ? SrSpacing.space4 : SrSpacing.space8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.priceLabel,
                          style: SrTypography.heading4.copyWith(
                            color: foreground,
                          ),
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.remove_rounded,
                        tooltip: 'Decrease quantity',
                        compact: isSmall,
                        onPressed: canDecrease
                            ? () => onQuantityChanged!(item.quantity - 1)
                            : null,
                      ),
                      Semantics(
                        label: 'Quantity',
                        value: '${item.quantity}',
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: isSmall
                                ? SrSizing.size32
                                : SrSizing.size48,
                          ),
                          child: Text(
                            '${item.quantity}',
                            textAlign: TextAlign.center,
                            style: SrTypography.bodyExtraLarge.copyWith(
                              color: foreground,
                            ),
                          ),
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.add_rounded,
                        tooltip: 'Increase quantity',
                        compact: isSmall,
                        onPressed: canIncrease
                            ? () => onQuantityChanged!(item.quantity + 1)
                            : null,
                      ),
                      if (isSmall && onRemove != null)
                        IconButton(
                          onPressed: enabled ? onRemove : null,
                          tooltip: 'Remove ${item.title}',
                          color: scheme.error,
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.tooltip,
    required this.compact,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final bool compact;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        foregroundColor: scheme.primary,
        disabledForegroundColor: theme.disabledColor,
        minimumSize: const Size.square(SrSizing.minimumTouchTarget),
        padding: EdgeInsets.zero,
        shape: const CircleBorder(),
      ),
      icon: SizedBox.square(
        dimension: compact ? SrSizing.size32 : SrSizing.minimumTouchTarget,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              size: compact ? SrSizing.iconSmall : SrSizing.iconMedium,
            ),
          ),
        ),
      ),
    );
  }
}
