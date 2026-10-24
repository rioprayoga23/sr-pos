import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/product_search/presentation/view_models/product_search_ui_state.dart';
import 'package:sr_pos/features/product_search/presentation/view_models/product_search_view_model.dart';
import 'package:sr_pos/features/product_search/presentation/widgets/product_grid_card.dart';

class ProductSearchScreen extends StatelessWidget {
  const ProductSearchScreen({required this.viewModel, super.key});

  final ProductSearchViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: _ProductSearchLayout.maxContentWidth,
            ),
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                return _ProductSearchContent(
                  state: viewModel.state,
                  onQueryChanged: viewModel.updateQuery,
                  onSortPressed: viewModel.cycleSort,
                  onFilterPressed: viewModel.toggleFilters,
                  onRetry: viewModel.load,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductSearchContent extends StatelessWidget {
  const _ProductSearchContent({
    required this.state,
    required this.onQueryChanged,
    required this.onSortPressed,
    required this.onFilterPressed,
    required this.onRetry,
  });

  final ProductSearchUiState state;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onSortPressed;
  final VoidCallback onFilterPressed;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final resultSliver = switch (state.content) {
      ProductSearchInitial() ||
      ProductSearchLoading() => const _SliverLoadingState(),
      ProductSearchFailure(:final message) => _SliverErrorState(
        message: message,
        onRetry: onRetry,
      ),
      ProductSearchReady(:final items) when items.isEmpty =>
        const _SliverEmptyState(),
      ProductSearchReady(:final items) => _ProductGrid(items: items),
    };

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            SrSpacing.pageHorizontal,
            SrSpacing.space8,
            SrSpacing.pageHorizontal,
            SrSpacing.space16,
          ),
          sliver: SliverToBoxAdapter(
            child: _SearchControls(
              query: state.query,
              sort: state.sort,
              activeFilterCount: state.activeFilterCount,
              onQueryChanged: onQueryChanged,
              onSortPressed: onSortPressed,
              onFilterPressed: onFilterPressed,
            ),
          ),
        ),
        resultSliver,
      ],
    );
  }
}

class _SearchControls extends StatelessWidget {
  const _SearchControls({
    required this.query,
    required this.sort,
    required this.activeFilterCount,
    required this.onQueryChanged,
    required this.onSortPressed,
    required this.onFilterPressed,
  });

  final String query;
  final ProductSortOption sort;
  final int activeFilterCount;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onSortPressed;
  final VoidCallback onFilterPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SrSearchBar(
          initialValue: query,
          placeholder: 'Search products',
          semanticLabel: 'Search products',
          onChanged: onQueryChanged,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        ),
        const SizedBox(height: SrSpacing.space12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SrFilter(
              label: 'Sort',
              semanticLabel: 'Sort products, ${sort.label}',
              selected: false,
              leading: const SrIcon(Icons.sort_rounded, size: SrIconSize.small),
              trailing: const SrIcon(
                Icons.keyboard_arrow_down_rounded,
                size: SrIconSize.small,
              ),
              onSelected: (_) => onSortPressed(),
            ),
            SrFilter(
              label: 'Filter',
              semanticLabel: 'Filter products, $activeFilterCount active',
              selected: false,
              leading: const SrIcon(Icons.tune_rounded, size: SrIconSize.small),
              trailing: activeFilterCount > 0
                  ? SrBadge.count(count: activeFilterCount)
                  : null,
              onSelected: (_) => onFilterPressed(),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.items});

  final List<ProductSearchItemViewData> items;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        SrSpacing.pageHorizontal,
        0,
        SrSpacing.pageHorizontal,
        SrSpacing.space24,
      ),
      sliver: SliverGrid.builder(
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: _ProductSearchLayout.maxCardWidth,
          mainAxisExtent: _ProductSearchLayout.cardHeight,
          crossAxisSpacing: SrSpacing.gridGap,
          mainAxisSpacing: SrSpacing.gridGap,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return ProductGridCard(key: ValueKey(item.id), item: item);
        },
      ),
    );
  }
}

class _SliverLoadingState extends StatelessWidget {
  const _SliverLoadingState();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(child: SrLoader(label: 'Loading products')),
    );
  }
}

class _SliverEmptyState extends StatelessWidget {
  const _SliverEmptyState();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(child: Text('No products found')),
    );
  }
}

class _SliverErrorState extends StatelessWidget {
  const _SliverErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(SrSpacing.space24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: SrSpacing.space16),
              SrButton(
                label: 'Try again',
                onPressed: () => unawaited(onRetry()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

abstract final class _ProductSearchLayout {
  static const double maxContentWidth = 600;
  static const double maxCardWidth = 180;
  static const double cardHeight = 184;
}
