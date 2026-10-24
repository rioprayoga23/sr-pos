import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/features/sale/data/repositories/in_memory_sale_repository.dart';
import 'package:sr_pos/features/sale/domain/models/sale_product.dart';

void main() {
  test(
    'returns an immutable demo catalog with category and price data',
    () async {
      final products = await const InMemorySaleRepository().getProducts();

      expect(products, hasLength(8));
      expect(products.first.name, 'Kopi Susu Gula Aren');
      expect(products.first.category, SaleProductCategory.coffee);
      expect(products.first.priceInRupiah, 18000);
      expect(() => products.add(products.first), throwsUnsupportedError);
    },
  );
}
