enum SaleProductCategory { coffee, nonCoffee, snack }

final class SaleProduct {
  const SaleProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.priceInRupiah,
    this.isPopular = false,
  }) : assert(priceInRupiah >= 0);

  final String id;
  final String name;
  final SaleProductCategory category;
  final int priceInRupiah;
  final bool isPopular;
}
