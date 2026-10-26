final class CatalogIngredient {
  CatalogIngredient({
    required this.name,
    required this.unit,
    required this.stockAlert,
    List<int>? imageBytes,
  }) : imageBytes = imageBytes == null
           ? null
           : List<int>.unmodifiable(imageBytes),
       assert(stockAlert >= 0);

  final String name;
  final String unit;
  final double stockAlert;
  final List<int>? imageBytes;
}
