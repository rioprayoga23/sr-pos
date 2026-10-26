import 'dart:math' as math;
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/design_system.dart';

// assumption: ingredient photos use a square crop to match catalog thumbnails.
const double _ingredientImageCropAspectRatio = 1;
const double _ingredientImageCropViewportMax = SrSizing.size80 * 4;
const double _ingredientImageCropDialogMax = SrSizing.size80 * 6;

Future<Uint8List?> showCatalogIngredientImageCropDialog({
  required BuildContext context,
  required Uint8List imageBytes,
}) {
  final editorKey = GlobalKey<_CatalogIngredientCropEditorState>();

  return showSrDialog<Uint8List>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Tutup penyesuaian foto bahan baku',
    dialog: SrDialog(
      title: 'Sesuaikan foto',
      semanticLabel: 'Sesuaikan foto bahan baku',
      compact: true,
      maxWidth: _ingredientImageCropDialogMax,
      onClose: () => Navigator.of(context, rootNavigator: true).pop(),
      actions: [
        SrDialogAction(
          label: 'Batal',
          variant: SrButtonVariant.secondary,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        SrDialogAction(
          label: 'Gunakan foto',
          onPressed: () => editorKey.currentState?.crop(),
        ),
      ],
      children: [
        Text(
          'Geser atau perbesar foto agar pas dengan thumbnail katalog.',
          textAlign: TextAlign.center,
          style: SrTypography.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        _CatalogIngredientCropEditor(key: editorKey, imageBytes: imageBytes),
      ],
    ),
  );
}

class _CatalogIngredientCropEditor extends StatefulWidget {
  const _CatalogIngredientCropEditor({required this.imageBytes, super.key});

  final Uint8List imageBytes;

  @override
  State<_CatalogIngredientCropEditor> createState() =>
      _CatalogIngredientCropEditorState();
}

class _CatalogIngredientCropEditorState
    extends State<_CatalogIngredientCropEditor> {
  final _cropController = CropController();
  var _cropStatus = CropStatus.nothing;
  var _isCropping = false;

  void crop() {
    if (_cropStatus != CropStatus.ready || _isCropping) return;
    setState(() => _isCropping = true);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // On web, cropping runs on the main event loop. Yield once after the
      // loading frame so the browser can paint the spinner before encoding.
      await Future<void>.delayed(Duration.zero);
      if (!mounted || !_isCropping) return;
      _cropController.crop();
    });
  }

  void _handleCropped(CropResult result) {
    // A crop operation can finish after its dialog was dismissed. Its result
    // must never close or update a newer dialog.
    if (!mounted) return;

    switch (result) {
      case CropSuccess(:final croppedImage):
        Navigator.of(context, rootNavigator: true).pop(croppedImage);
      case CropFailure():
        setState(() => _isCropping = false);
        showSrToast(
          context: context,
          message: 'Foto tidak dapat dipotong. Coba gambar lain.',
          tone: SrFeedbackTone.error,
          leading: const SrIcon(Icons.error_outline_rounded),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportSize = math.min(
          _ingredientImageCropViewportMax,
          constraints.maxWidth,
        );

        return Center(
          child: SizedBox.square(
            dimension: viewportSize,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SrRadii.small),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Crop(
                    image: widget.imageBytes,
                    controller: _cropController,
                    aspectRatio: _ingredientImageCropAspectRatio,
                    interactive: true,
                    fixCropRect: true,
                    baseColor: colors.surface,
                    maskColor: colors.scrim,
                    radius: SrRadii.small,
                    progressIndicator: Text(
                      'Loading...',
                      style: SrTypography.bodySmall.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    cornerDotBuilder: (size, edgeAlignment) =>
                        DotControl(color: colors.primary),
                    onStatusChanged: (status) => _cropStatus = status,
                    onCropped: _handleCropped,
                  ),
                  if (_isCropping)
                    ColoredBox(
                      color: colors.surface,
                      child: Center(
                        child: Semantics(
                          liveRegion: true,
                          child: Text(
                            'Loading...',
                            style: SrTypography.bodySmall.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
