import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/features/product_search/data/repositories/in_memory_product_repository.dart';
import 'package:sr_pos/features/product_search/domain/models/product.dart';

void main() {
  group('InMemoryProductRepository', () {
    test('returns the six reference products', () async {
      const repository = InMemoryProductRepository();

      final products = await repository.getProducts();

      expect(products, hasLength(6));
      expect(
        products.first,
        const Product(id: 'amazing', name: 'Amazing Shoes', priceInCents: 1200),
      );
      expect(products.last.name, 'Wonderful Shoes');
    });

    test('returns an immutable collection', () async {
      const repository = InMemoryProductRepository();
      final products = await repository.getProducts();

      expect(
        () => products.add(
          const Product(id: 'new', name: 'New Shoes', priceInCents: 1000),
        ),
        throwsUnsupportedError,
      );
    });
  });
}
