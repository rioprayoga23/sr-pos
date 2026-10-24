import 'package:sr_pos/features/sale/domain/models/sale_product.dart';

abstract interface class SaleRepository {
  Future<List<SaleProduct>> getProducts();
}

final class SaleRepositoryException implements Exception {
  const SaleRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
