import 'package:sr_pos/features/product_search/domain/models/product.dart';

abstract interface class ProductRepository {
  Future<List<Product>> getProducts();
}

final class ProductRepositoryException implements Exception {
  const ProductRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
