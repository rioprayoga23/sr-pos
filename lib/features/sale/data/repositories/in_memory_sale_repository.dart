import 'package:sr_pos/features/sale/domain/models/sale_product.dart';
import 'package:sr_pos/features/sale/domain/repositories/sale_repository.dart';

final class InMemorySaleRepository implements SaleRepository {
  const InMemorySaleRepository();

  static const _products = <SaleProduct>[
    SaleProduct(
      id: 'kopi-susu-gula-aren',
      name: 'Kopi Susu Gula Aren',
      category: SaleProductCategory.coffee,
      priceInRupiah: 18000,
      isPopular: true,
    ),
    SaleProduct(
      id: 'americano',
      name: 'Americano',
      category: SaleProductCategory.coffee,
      priceInRupiah: 16000,
    ),
    SaleProduct(
      id: 'cappuccino',
      name: 'Cappuccino',
      category: SaleProductCategory.coffee,
      priceInRupiah: 22000,
    ),
    SaleProduct(
      id: 'cafe-latte',
      name: 'Café Latte',
      category: SaleProductCategory.coffee,
      priceInRupiah: 24000,
    ),
    SaleProduct(
      id: 'matcha-latte',
      name: 'Matcha Latte',
      category: SaleProductCategory.nonCoffee,
      priceInRupiah: 25000,
      isPopular: true,
    ),
    SaleProduct(
      id: 'lemon-tea',
      name: 'Teh Lemon',
      category: SaleProductCategory.nonCoffee,
      priceInRupiah: 14000,
    ),
    SaleProduct(
      id: 'roti-bakar',
      name: 'Roti Bakar Cokelat',
      category: SaleProductCategory.snack,
      priceInRupiah: 20000,
    ),
    SaleProduct(
      id: 'croissant',
      name: 'Croissant Butter',
      category: SaleProductCategory.snack,
      priceInRupiah: 17000,
    ),
  ];

  @override
  Future<List<SaleProduct>> getProducts() {
    return Future<List<SaleProduct>>.value(
      List<SaleProduct>.unmodifiable(_products),
    );
  }
}
