import 'dart:typed_data';

abstract interface class CatalogIngredientImagePicker {
  Future<Uint8List?> pickImage();
}
