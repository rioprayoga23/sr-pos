import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/sale/domain/models/sale_product.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_ui_state.dart';

class SaleProductCatalog extends StatelessWidget {
  const SaleProductCatalog({
    required this.state,
    required this.searchController,
    required this.onQueryChanged,
    required this.onCategoryChanged,
    required this.onRecommendedChanged,
    required this.onRetry,
    this.onProductSelected,
    this.showRecommendedFilter = true,
    this.searchHint = 'Cari menu',
    this.itemLabel = 'menu',
    super.key,
  });

  final SaleUiState state;
  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<SaleCategoryFilter> onCategoryChanged;
  final ValueChanged<bool> onRecommendedChanged;
  final Future<void> Function() onRetry;
  final ValueChanged<SaleProductViewData>? onProductSelected;
  final bool showRecommendedFilter;
  final String searchHint;
  final String itemLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: SrSpacing.space8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final category in _SaleCategoryOption.values) ...[
                      SrFilter(
                        label:
                            '${category.label} '
                            '(${state.categoryCounts[category.filter] ?? 0})',
                        semanticLabel: 'Filter ${category.label}',
                        selected: state.categoryFilter == category.filter,
                        leading: SrIcon(category.icon, size: SrIconSize.small),
                        onSelected: (_) => onCategoryChanged(category.filter),
                      ),
                      const SizedBox(width: SrSpacing.space8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: SrSpacing.space8),
              Row(
                children: [
                  Expanded(
                    child: SrTextField(
                      controller: searchController,
                      hintText: searchHint,
                      semanticLabel: searchHint,
                      prefixIcon: const SrIcon(
                        Icons.search_rounded,
                        size: SrIconSize.small,
                      ),
                      size: SrComponentSize.small,
                      textInputAction: TextInputAction.search,
                      onChanged: onQueryChanged,
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                    ),
                  ),
                  if (showRecommendedFilter) ...[
                    const SizedBox(width: SrSpacing.space8),
                    SrFilter(
                      label: 'Rekomendasi',
                      semanticLabel: 'Filter menu rekomendasi',
                      selected: state.recommendedOnly,
                      leading: const SrIcon(
                        Icons.star_outline_rounded,
                        size: SrIconSize.small,
                      ),
                      onSelected: onRecommendedChanged,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: SrSpacing.space8),
        Text(
          state.isLoading
              ? 'Menyiapkan $itemLabel'
              : _resultLabel(state.products.length),
          style: SrTypography.bodySmall.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: SrSpacing.space8),
        Expanded(
          child: _SaleProductGrid(
            state: state,
            itemLabel: itemLabel,
            onProductSelected: onProductSelected,
            onRetry: onRetry,
          ),
        ),
      ],
    );
  }

  String _resultLabel(int itemCount) {
    final itemCountText = '$itemCount $itemLabel';
    return onProductSelected == null
        ? itemCountText
        : '$itemCountText · ketuk untuk menambahkan';
  }
}

enum _SaleCategoryOption {
  all(SaleCategoryFilter.all, 'Semua', Icons.apps_rounded),
  coffee(SaleCategoryFilter.coffee, 'Kopi', Icons.coffee_outlined),
  nonCoffee(
    SaleCategoryFilter.nonCoffee,
    'Non-kopi',
    Icons.local_drink_outlined,
  ),
  snack(SaleCategoryFilter.snack, 'Camilan', Icons.bakery_dining_outlined);

  const _SaleCategoryOption(this.filter, this.label, this.icon);

  final SaleCategoryFilter filter;
  final String label;
  final IconData icon;
}

class _SaleProductGrid extends StatelessWidget {
  const _SaleProductGrid({
    required this.state,
    required this.itemLabel,
    required this.onProductSelected,
    required this.onRetry,
  });

  final SaleUiState state;
  final String itemLabel;
  final ValueChanged<SaleProductViewData>? onProductSelected;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Center(child: SrLoader(label: 'Memuat $itemLabel'));
    }

    if (state.errorMessage case final message?) {
      return Padding(
        padding: const EdgeInsets.all(SrSpacing.space12),
        child: Center(
          child: SrBanner(
            title: '${_titleCase(itemLabel)} belum tersedia',
            message: message,
            tone: SrFeedbackTone.error,
            actions: [
              SrButton(
                label: 'Coba lagi',
                variant: SrButtonVariant.secondary,
                onPressed: () => unawaited(onRetry()),
              ),
            ],
          ),
        ),
      );
    }

    if (state.products.isEmpty) {
      return Center(
        child: Text(
          '${_titleCase(itemLabel)} tidak ditemukan. Coba kata kunci lain.',
          textAlign: TextAlign.center,
          style: SrTypography.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridColumnCount = SaleProductGridLayout.productColumnCount(
          constraints.maxWidth,
        );
        final productCardHeight = gridColumnCount == 3
            ? SaleProductGridLayout.threeColumnCardHeight
            : SaleProductGridLayout.cardHeight;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, SrSpacing.space16),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: SaleProductGridLayout.cardMaxWidth,
            mainAxisExtent: productCardHeight,
            crossAxisSpacing: SrSpacing.space8,
            mainAxisSpacing: SrSpacing.space8,
          ),
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            final product = state.products[index];
            final colors = Theme.of(context).colorScheme;
            final quantity = state.quantityOf(product.id);
            final productCard = SrCard(
              key: ValueKey(product.id),
              title: '',
              visualKind: SrCardVisualKind.media,
              visual: Stack(
                fit: StackFit.expand,
                children: [
                  SrImagePlaceholder(
                    height: double.infinity,
                    icon: product.category == SaleProductCategory.snack
                        ? Icons.bakery_dining_outlined
                        : Icons.coffee_outlined,
                    borderRadius: SrSpacing.none,
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.42, 1],
                          colors: [
                            colors.inverseSurface.withValues(alpha: 0),
                            colors.inverseSurface.withValues(alpha: 0.88),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (product.isPopular)
                    Positioned(
                      top: SrSpacing.space8,
                      left: SrSpacing.space8,
                      child: const SrTag(
                        label: 'Rekomendasi',
                        tone: SrTagTone.primary,
                        size: SrTagSize.small,
                      ),
                    ),
                  Positioned(
                    left: SrSpacing.space12,
                    right: SrSpacing.space12,
                    bottom: SrSpacing.space12,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: SrTypography.heading4.copyWith(
                            color: colors.onInverseSurface,
                          ),
                        ),
                        const SizedBox(height: SrSpacing.space4),
                        Text(
                          product.priceLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: SrTypography.actionMedium.copyWith(
                            color: colors.onInverseSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              mediaHeight: productCardHeight,
              contentPadding: EdgeInsets.zero,
              semanticLabel: onProductSelected == null
                  ? '${product.name}, ${product.priceLabel}'
                  : 'Tambah ${product.name}, ${product.priceLabel}',
              onTap: onProductSelected == null
                  ? null
                  : () => onProductSelected!(product),
            );
            if (onProductSelected == null || quantity == 0) return productCard;

            return SrBadge.count(
              count: quantity,
              offset: const Offset(-SrSpacing.space8, SrSpacing.space8),
              semanticLabel: 'Jumlah di keranjang: $quantity',
              child: productCard,
            );
          },
        );
      },
    );
  }

  String _titleCase(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
}

abstract final class SaleProductGridLayout {
  static const double cardMaxWidth = 212;
  static const double cardHeight = 196;
  // assumption: three columns need shorter tiles to keep the tablet grid dense.
  static const double threeColumnCardHeight = 168;

  static int productColumnCount(double availableWidth) =>
      (availableWidth / (cardMaxWidth + SrSpacing.space8)).ceil();
}
