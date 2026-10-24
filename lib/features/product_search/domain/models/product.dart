final class Product {
  const Product({
    required this.id,
    required this.name,
    required this.priceInCents,
  }) : assert(priceInCents >= 0);

  final String id;
  final String name;
  final int priceInCents;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Product &&
            id == other.id &&
            name == other.name &&
            priceInCents == other.priceInCents;
  }

  @override
  int get hashCode => Object.hash(id, name, priceInCents);
}
