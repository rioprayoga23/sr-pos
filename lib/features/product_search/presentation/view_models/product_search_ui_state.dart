import 'package:flutter/foundation.dart';

enum ProductSortOption { featured, priceLowToHigh, priceHighToLow }

extension ProductSortOptionLabel on ProductSortOption {
  String get label => switch (this) {
    ProductSortOption.featured => 'Featured',
    ProductSortOption.priceLowToHigh => 'Price: low to high',
    ProductSortOption.priceHighToLow => 'Price: high to low',
  };
}

@immutable
final class ProductSearchItemViewData {
  const ProductSearchItemViewData({
    required this.id,
    required this.name,
    required this.priceLabel,
  });

  final String id;
  final String name;
  final String priceLabel;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProductSearchItemViewData &&
            id == other.id &&
            name == other.name &&
            priceLabel == other.priceLabel;
  }

  @override
  int get hashCode => Object.hash(id, name, priceLabel);
}

sealed class ProductSearchContentState {
  const ProductSearchContentState();
}

final class ProductSearchInitial extends ProductSearchContentState {
  const ProductSearchInitial();
}

final class ProductSearchLoading extends ProductSearchContentState {
  const ProductSearchLoading();
}

final class ProductSearchReady extends ProductSearchContentState {
  ProductSearchReady(List<ProductSearchItemViewData> items)
    : items = List<ProductSearchItemViewData>.unmodifiable(items);

  final List<ProductSearchItemViewData> items;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProductSearchReady && listEquals(items, other.items);
  }

  @override
  int get hashCode => Object.hashAll(items);
}

final class ProductSearchFailure extends ProductSearchContentState {
  const ProductSearchFailure(this.message);

  final String message;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProductSearchFailure && message == other.message;
  }

  @override
  int get hashCode => message.hashCode;
}

@immutable
final class ProductSearchUiState {
  const ProductSearchUiState({
    required this.content,
    required this.query,
    required this.sort,
    required this.activeFilterCount,
  });

  const ProductSearchUiState.initial({
    this.query = 'Shoes',
    this.sort = ProductSortOption.featured,
    this.activeFilterCount = 2,
  }) : content = const ProductSearchInitial();

  final ProductSearchContentState content;
  final String query;
  final ProductSortOption sort;
  final int activeFilterCount;

  ProductSearchUiState copyWith({
    ProductSearchContentState? content,
    String? query,
    ProductSortOption? sort,
    int? activeFilterCount,
  }) {
    return ProductSearchUiState(
      content: content ?? this.content,
      query: query ?? this.query,
      sort: sort ?? this.sort,
      activeFilterCount: activeFilterCount ?? this.activeFilterCount,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProductSearchUiState &&
            content == other.content &&
            query == other.query &&
            sort == other.sort &&
            activeFilterCount == other.activeFilterCount;
  }

  @override
  int get hashCode => Object.hash(content, query, sort, activeFilterCount);
}
