import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:sr_pos/features/sale/domain/services/catalog_ingredient_image_picker.dart';

// assumption: catalog thumbnails do not need an image larger than 640 px.
// Resize before the Dart cropper decodes the image to keep both opening and
// exporting the crop responsive for high-resolution camera photos.
const double _catalogImageMaxDimension = 640;
const int _catalogImageQuality = 95;

final class ImagePickerCatalogIngredientImagePicker
    implements CatalogIngredientImagePicker {
  ImagePickerCatalogIngredientImagePicker({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  @override
  Future<Uint8List?> pickImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: _catalogImageMaxDimension,
      maxHeight: _catalogImageMaxDimension,
      imageQuality: _catalogImageQuality,
      requestFullMetadata: false,
    );
    if (image == null) return null;

    return image.readAsBytes();
  }
}
