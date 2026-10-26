import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/sale/domain/models/catalog_ingredient.dart';
import 'package:sr_pos/features/sale/domain/services/catalog_ingredient_image_picker.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_cubit.dart';
import 'package:sr_pos/features/sale/presentation/widgets/catalog_ingredient_image_crop_dialog.dart';

const _otherUnit = 'Lainnya';
const _ingredientUnitItems = <SrDropdownItem<String>>[
  SrDropdownItem(value: 'g', label: 'g'),
  SrDropdownItem(value: 'kg', label: 'kg'),
  SrDropdownItem(value: 'ml', label: 'ml'),
  SrDropdownItem(value: 'pcs', label: 'pcs'),
  SrDropdownItem(value: 'pack', label: 'pack'),
  SrDropdownItem(value: 'cm', label: 'cm'),
  SrDropdownItem(value: 'm', label: 'm'),
  SrDropdownItem(value: _otherUnit, label: _otherUnit),
];
const _addIngredientDialogMaxWidth = SrSizing.size40 * 12;

Future<void> showAddCatalogIngredientDialog({
  required BuildContext context,
  required SaleCubit cubit,
  required TextEditingController searchController,
  required CatalogIngredientImagePicker? imagePicker,
}) => _showCatalogIngredientDialog(
  context: context,
  cubit: cubit,
  searchController: searchController,
  imagePicker: imagePicker,
);

Future<void> showEditCatalogIngredientDialog({
  required BuildContext context,
  required SaleCubit cubit,
  required TextEditingController searchController,
  required CatalogIngredientImagePicker? imagePicker,
  required CatalogIngredient ingredient,
}) => _showCatalogIngredientDialog(
  context: context,
  cubit: cubit,
  searchController: searchController,
  imagePicker: imagePicker,
  initialIngredient: ingredient,
);

Future<void> _showCatalogIngredientDialog({
  required BuildContext context,
  required SaleCubit cubit,
  required TextEditingController searchController,
  required CatalogIngredientImagePicker? imagePicker,
  CatalogIngredient? initialIngredient,
}) async {
  final isEditing = initialIngredient != null;
  final formKey = GlobalKey<_CatalogIngredientFormState>();
  final didSaveIngredient = await showSrDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: isEditing
        ? 'Tutup form edit bahan baku'
        : 'Tutup form tambah bahan baku',
    dialog: SrDialog(
      title: isEditing ? 'Edit bahan baku' : 'Tambah bahan baku',
      semanticLabel: isEditing
          ? 'Form edit bahan baku'
          : 'Form tambah bahan baku',
      compact: true,
      maxWidth: _addIngredientDialogMaxWidth,
      onClose: () => Navigator.of(context, rootNavigator: true).pop(),
      actions: [
        SrDialogAction(
          label: 'Batal',
          variant: SrButtonVariant.secondary,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        SrDialogAction(
          label: 'Simpan',
          onPressed: () {
            final ingredient = formKey.currentState?.validateAndRead();
            if (ingredient == null) return;
            final didSave = switch (initialIngredient) {
              final currentIngredient? => cubit.updateCatalogIngredient(
                currentIngredient.name,
                ingredient,
              ),
              null => cubit.addCatalogIngredient(ingredient),
            };
            if (!didSave) {
              return;
            }
            Navigator.of(context, rootNavigator: true).pop(true);
          },
        ),
      ],
      children: [
        _CatalogIngredientForm(
          key: formKey,
          cubit: cubit,
          imagePicker: imagePicker,
          initialIngredient: initialIngredient,
        ),
      ],
    ),
  );

  if (didSaveIngredient != true || !context.mounted) return;

  searchController.clear();
  cubit.updateQuery('');
  showSrToast(
    context: context,
    message: isEditing
        ? 'Bahan baku berhasil diperbarui.'
        : 'Bahan baku berhasil ditambahkan.',
    tone: SrFeedbackTone.success,
    leading: const SrIcon(Icons.check_circle_outline_rounded),
  );
}

class _CatalogIngredientForm extends StatefulWidget {
  const _CatalogIngredientForm({
    required this.cubit,
    required this.imagePicker,
    this.initialIngredient,
    super.key,
  });

  final SaleCubit cubit;
  final CatalogIngredientImagePicker? imagePicker;
  final CatalogIngredient? initialIngredient;

  @override
  State<_CatalogIngredientForm> createState() => _CatalogIngredientFormState();
}

class _CatalogIngredientFormState extends State<_CatalogIngredientForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _otherUnitController = TextEditingController();
  final _stockAlertController = TextEditingController();
  Uint8List? _imageBytes;
  String? _selectedUnit;
  String? _unitErrorText;
  var _isImageFlowActive = false;
  var _isPreparingImage = false;
  var _imageSelectionRequest = 0;

  String get _displayUnit {
    if (_selectedUnit == null) return 'satuan';
    if (_selectedUnit != _otherUnit) return _selectedUnit!;
    final customUnit = _otherUnitController.text.trim();
    return customUnit.isEmpty ? 'satuan' : customUnit;
  }

  @override
  void initState() {
    super.initState();
    _otherUnitController.addListener(_handleOtherUnitChanged);
    final ingredient = widget.initialIngredient;
    if (ingredient == null) return;

    _nameController.text = ingredient.name;
    _stockAlertController.text = _formatStockAlert(ingredient.stockAlert);
    if (ingredient.imageBytes case final imageBytes?) {
      _imageBytes = Uint8List.fromList(imageBytes);
    }
    final isStandardUnit = _ingredientUnitItems.any(
      (item) => item.value == ingredient.unit && item.value != _otherUnit,
    );
    if (isStandardUnit) {
      _selectedUnit = ingredient.unit;
    } else {
      _selectedUnit = _otherUnit;
      _otherUnitController.text = ingredient.unit;
    }
  }

  @override
  void dispose() {
    _otherUnitController
      ..removeListener(_handleOtherUnitChanged)
      ..dispose();
    _nameController.dispose();
    _stockAlertController.dispose();
    super.dispose();
  }

  void _handleOtherUnitChanged() {
    if (mounted) setState(() {});
  }

  CatalogIngredient? validateAndRead() {
    if (_isImageFlowActive) return null;

    final form = _formKey.currentState;
    final fieldsAreValid = form?.validate() ?? false;
    final selectedUnit = _selectedUnit;
    setState(() {
      _unitErrorText = selectedUnit == null ? 'Pilih unit bahan baku.' : null;
    });
    if (!fieldsAreValid || selectedUnit == null) return null;

    final unit = selectedUnit == _otherUnit
        ? _otherUnitController.text.trim()
        : selectedUnit;
    final stockAlert = double.tryParse(
      _stockAlertController.text.trim().replaceAll(',', '.'),
    );
    if (stockAlert == null || !stockAlert.isFinite) return null;

    return CatalogIngredient(
      name: _nameController.text.trim(),
      unit: unit,
      stockAlert: stockAlert,
      imageBytes: _imageBytes,
    );
  }

  Future<void> _pickImage() async {
    final imagePicker = widget.imagePicker;
    if (imagePicker == null || _isImageFlowActive) return;

    final request = ++_imageSelectionRequest;
    _isImageFlowActive = true;

    try {
      final imageBytes = await imagePicker.pickImage();
      if (!mounted || request != _imageSelectionRequest || imageBytes == null) {
        return;
      }
      setState(() => _isPreparingImage = true);
      await WidgetsBinding.instance.endOfFrame;
      await Future<void>.delayed(Duration.zero);
      if (!mounted || request != _imageSelectionRequest) return;

      final croppedImageBytes = await showCatalogIngredientImageCropDialog(
        context: context,
        imageBytes: imageBytes,
      );
      if (!mounted ||
          request != _imageSelectionRequest ||
          croppedImageBytes == null) {
        return;
      }
      setState(() => _imageBytes = croppedImageBytes);
    } on Exception {
      if (!mounted || request != _imageSelectionRequest) return;
      showSrToast(
        context: context,
        message: 'Foto tidak dapat dibuka. Coba pilih gambar lain.',
        tone: SrFeedbackTone.error,
        leading: const SrIcon(Icons.error_outline_rounded),
      );
    } finally {
      if (mounted && request == _imageSelectionRequest) {
        setState(() {
          _isImageFlowActive = false;
          _isPreparingImage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: SrSpacing.space12),
          ClipRRect(
            borderRadius: BorderRadius.circular(SrRadii.medium),
            child: Stack(
              children: [
                SrFilePicker(
                  key: const ValueKey('catalog-ingredient-image-upload'),
                  onPressed: widget.imagePicker == null || _isImageFlowActive
                      ? null
                      : _pickImage,
                  image: switch (_imageBytes) {
                    final imageBytes? => MemoryImage(imageBytes),
                    null => null,
                  },
                  title: 'Unggah foto bahan baku',
                  supportingText: 'Pilih gambar dari galeri',
                  replacementText: 'Ketuk untuk mengganti foto',
                  icon: Icons.photo_camera_rounded,
                  semanticLabel: _imageBytes == null
                      ? 'Pilih foto bahan baku'
                      : 'Ganti foto bahan baku',
                ),
                if (_isPreparingImage)
                  Positioned.fill(
                    child: ColoredBox(
                      color: Theme.of(context).colorScheme.surface,
                      child: Center(
                        child: Semantics(
                          liveRegion: true,
                          child: Text(
                            'Loading...',
                            style: SrTypography.bodySmall.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: SrSpacing.space12),
          SrTextField(
            key: const ValueKey('catalog-ingredient-name'),
            controller: _nameController,
            labelText: 'Nama',
            hintText: 'Contoh: Air galon',
            semanticLabel: 'Nama bahan baku',
            size: SrComponentSize.small,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: (value) {
              final name = value?.trim() ?? '';
              if (name.isEmpty) return 'Nama bahan baku wajib diisi.';
              if (widget.cubit.hasCatalogIngredient(
                name,
                excludingName: widget.initialIngredient?.name,
              )) {
                return 'Bahan baku ini sudah terdaftar.';
              }
              return null;
            },
          ),
          const SizedBox(height: SrSpacing.space12),
          SrDropdown<String>(
            key: const ValueKey('catalog-ingredient-unit'),
            items: _ingredientUnitItems,
            value: _selectedUnit,
            labelText: 'Unit',
            hintText: 'Pilih unit',
            errorText: _unitErrorText,
            semanticLabel: 'Unit bahan baku',
            size: SrComponentSize.small,
            onChanged: (unit) {
              if (unit == null) return;
              setState(() {
                _selectedUnit = unit;
                _unitErrorText = null;
              });
            },
          ),
          if (_selectedUnit == _otherUnit) ...[
            const SizedBox(height: SrSpacing.space12),
            SrTextField(
              key: const ValueKey('catalog-ingredient-other-unit'),
              controller: _otherUnitController,
              labelText: 'Unit lainnya',
              hintText: 'Masukkan nama unit',
              semanticLabel: 'Unit lainnya',
              size: SrComponentSize.small,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: (value) => value?.trim().isNotEmpty == true
                  ? null
                  : 'Nama unit wajib diisi.',
            ),
          ],
          const SizedBox(height: SrSpacing.space12),
          SrTextField(
            key: const ValueKey('catalog-ingredient-stock-alert'),
            controller: _stockAlertController,
            labelText:
                _selectedUnit == null ||
                    (_selectedUnit == _otherUnit &&
                        _otherUnitController.text.trim().isEmpty)
                ? 'Stok alert'
                : 'Stok alert ($_displayUnit)',
            hintText: 'Masukkan jumlah minimum',
            helperText: 'Peringatan muncul saat stok mencapai batas ini.',
            semanticLabel: 'Batas peringatan stok menipis dalam $_displayUnit',
            size: SrComponentSize.small,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
            ],
            validator: (value) {
              final stockAlert = double.tryParse(
                (value?.trim() ?? '').replaceAll(',', '.'),
              );
              return stockAlert == null ||
                      !stockAlert.isFinite ||
                      stockAlert < 0
                  ? 'Masukkan jumlah stok yang valid.'
                  : null;
            },
          ),
        ],
      ),
    );
  }
}

String _formatStockAlert(double value) => value == value.truncateToDouble()
    ? value.toInt().toString()
    : value.toString();
