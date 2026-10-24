import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/product_search/presentation/view_models/product_search_ui_state.dart';

class ProductGridCard extends StatelessWidget {
  const ProductGridCard({required this.item, this.onTap, super.key});

  final ProductSearchItemViewData item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SrCard(
      title: item.name,
      subtitle: item.priceLabel,
      visualKind: SrCardVisualKind.media,
      visual: const SrImagePlaceholder(
        height: double.infinity,
        borderRadius: SrSpacing.none,
      ),
      mediaHeight: SrSizing.size80 + SrSizing.size24,
      contentPadding: const EdgeInsets.all(SrSpacing.space12),
      titleStyle: SrTypography.bodySmall.copyWith(color: colors.onSurface),
      subtitleStyle: SrTypography.heading5.copyWith(color: colors.onSurface),
      semanticLabel: '${item.name}, ${item.priceLabel}',
      onTap: onTap,
    );
  }
}
