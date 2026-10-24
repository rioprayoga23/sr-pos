import 'package:sr_pos/features/product_search/domain/models/product.dart';
import 'package:sr_pos/features/product_search/domain/repositories/product_repository.dart';

final class InMemoryProductRepository implements ProductRepository {
  const InMemoryProductRepository();

  static const _products = <Product>[
    Product(id: 'amazing', name: 'Amazing Shoes', priceInCents: 1200),
    Product(id: 'fabulous', name: 'Fabulous Shoes', priceInCents: 1500),
    Product(id: 'fantastic', name: 'Fantastic Shoes', priceInCents: 1500),
    Product(id: 'spectacular', name: 'Spectacular Shoes', priceInCents: 1200),
    Product(id: 'stunning', name: 'Stunning Shoes', priceInCents: 1200),
    Product(id: 'wonderful', name: 'Wonderful Shoes', priceInCents: 1500),
  ];

  @override
  Future<List<Product>> getProducts() {
    return Future<List<Product>>.value(List<Product>.unmodifiable(_products));
  }
}
