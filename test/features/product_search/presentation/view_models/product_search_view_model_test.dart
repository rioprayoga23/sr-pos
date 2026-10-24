import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/features/product_search/data/repositories/in_memory_product_repository.dart';
import 'package:sr_pos/features/product_search/domain/models/product.dart';
import 'package:sr_pos/features/product_search/domain/repositories/product_repository.dart';
import 'package:sr_pos/features/product_search/presentation/view_models/product_search_ui_state.dart';
import 'package:sr_pos/features/product_search/presentation/view_models/product_search_view_model.dart';

void main() {
  group('ProductSearchViewModel', () {
    late ProductSearchViewModel viewModel;

    tearDown(() => viewModel.dispose());

    test('loads and maps products into ready state', () async {
      viewModel = ProductSearchViewModel(const InMemoryProductRepository());

      await viewModel.load();

      final content = viewModel.state.content as ProductSearchReady;
      expect(content.items, hasLength(6));
      expect(content.items.first.name, 'Amazing Shoes');
      expect(content.items.first.priceLabel, '€12');
    });

    test('filters products using the current query', () async {
      viewModel = ProductSearchViewModel(const InMemoryProductRepository());
      await viewModel.load();

      viewModel.updateQuery('fantastic');

      final content = viewModel.state.content as ProductSearchReady;
      expect(content.items.map((item) => item.name), ['Fantastic Shoes']);
    });

    test('cycles price sorting in both directions', () async {
      viewModel = ProductSearchViewModel(const InMemoryProductRepository());
      await viewModel.load();

      viewModel.cycleSort();
      expect(viewModel.state.sort, ProductSortOption.priceLowToHigh);
      expect(_priceLabels(viewModel.state), [
        '€12',
        '€12',
        '€12',
        '€15',
        '€15',
        '€15',
      ]);

      viewModel.cycleSort();
      expect(viewModel.state.sort, ProductSortOption.priceHighToLow);
      expect(_priceLabels(viewModel.state), [
        '€15',
        '€15',
        '€15',
        '€12',
        '€12',
        '€12',
      ]);
    });

    test('toggles the active filter count', () {
      viewModel = ProductSearchViewModel(const InMemoryProductRepository());

      viewModel.toggleFilters();
      expect(viewModel.state.activeFilterCount, 0);

      viewModel.toggleFilters();
      expect(viewModel.state.activeFilterCount, 2);
    });

    test('exposes repository failures as UI state', () async {
      viewModel = ProductSearchViewModel(const _FailingProductRepository());

      await viewModel.load();

      expect(
        viewModel.state.content,
        const ProductSearchFailure('Products are unavailable'),
      );
    });
  });
}

List<String> _priceLabels(ProductSearchUiState state) {
  final content = state.content as ProductSearchReady;
  return content.items.map((item) => item.priceLabel).toList();
}

final class _FailingProductRepository implements ProductRepository {
  const _FailingProductRepository();

  @override
  Future<List<Product>> getProducts() {
    throw const ProductRepositoryException('Products are unavailable');
  }
}
