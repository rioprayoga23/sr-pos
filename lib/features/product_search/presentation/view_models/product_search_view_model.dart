import 'package:flutter/foundation.dart';
import 'package:sr_pos/features/product_search/domain/models/product.dart';
import 'package:sr_pos/features/product_search/domain/repositories/product_repository.dart';
import 'package:sr_pos/features/product_search/presentation/view_models/product_search_ui_state.dart';

final class ProductSearchViewModel extends ChangeNotifier {
  ProductSearchViewModel(
    this._productRepository, {
    String initialQuery = 'Shoes',
    int initialFilterCount = 2,
  }) : _state = ProductSearchUiState.initial(
         query: initialQuery,
         activeFilterCount: initialFilterCount,
       );

  final ProductRepository _productRepository;
  var _products = const <Product>[];
  var _disposed = false;
  ProductSearchUiState _state;

  ProductSearchUiState get state => _state;

  Future<void> load() async {
    _replaceState(_state.copyWith(content: const ProductSearchLoading()));

    try {
      final products = await _productRepository.getProducts();
      if (_disposed) return;
      _products = List<Product>.unmodifiable(products);
      _emitReady();
    } on ProductRepositoryException catch (error) {
      if (_disposed) return;
      _replaceState(
        _state.copyWith(content: ProductSearchFailure(error.message)),
      );
    }
  }

  void updateQuery(String query) {
    _state = _state.copyWith(query: query);
    if (_state.content is ProductSearchReady) {
      _emitReady();
      return;
    }
    notifyListeners();
  }

  void cycleSort() {
    final sort = switch (_state.sort) {
      ProductSortOption.featured => ProductSortOption.priceLowToHigh,
      ProductSortOption.priceLowToHigh => ProductSortOption.priceHighToLow,
      ProductSortOption.priceHighToLow => ProductSortOption.featured,
    };
    _state = _state.copyWith(sort: sort);
    if (_state.content is ProductSearchReady) {
      _emitReady();
      return;
    }
    notifyListeners();
  }

  void toggleFilters() {
    final count = _state.activeFilterCount == 0 ? 2 : 0;
    _replaceState(_state.copyWith(activeFilterCount: count));
  }

  void _emitReady() {
    final normalizedQuery = _state.query.trim().toLowerCase();
    final filtered = _products.where((product) {
      return normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery);
    }).toList();

    final comparator = switch (_state.sort) {
      ProductSortOption.featured => null,
      ProductSortOption.priceLowToHigh => (
        Product a,
        Product b,
      ) => a.priceInCents.compareTo(b.priceInCents),
      ProductSortOption.priceHighToLow => (
        Product a,
        Product b,
      ) => b.priceInCents.compareTo(a.priceInCents),
    };
    if (comparator != null) filtered.sort(comparator);

    final items = filtered.map(_toViewData).toList(growable: false);
    _replaceState(_state.copyWith(content: ProductSearchReady(items)));
  }

  ProductSearchItemViewData _toViewData(Product product) {
    return ProductSearchItemViewData(
      id: product.id,
      name: product.name,
      priceLabel: _formatPrice(product.priceInCents),
    );
  }

  String _formatPrice(int priceInCents) {
    final hasFraction = priceInCents % 100 != 0;
    final price = (priceInCents / 100).toStringAsFixed(hasFraction ? 2 : 0);
    return '€$price';
  }

  void _replaceState(ProductSearchUiState nextState) {
    _state = nextState;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
