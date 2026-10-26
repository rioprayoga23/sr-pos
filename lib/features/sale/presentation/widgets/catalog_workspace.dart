import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/sale/domain/models/catalog_ingredient.dart';
import 'package:sr_pos/features/sale/domain/services/catalog_ingredient_image_picker.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_cubit.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_ui_state.dart';
import 'package:sr_pos/features/sale/presentation/widgets/catalog_ingredient_form.dart';
import 'package:sr_pos/features/sale/presentation/widgets/sale_product_catalog.dart';

enum CatalogSection {
  items('Daftar Menu', Icons.storage_outlined, CatalogNavigationGroup.items),
  ingredients(
    'Bahan baku',
    Icons.soup_kitchen_outlined,
    CatalogNavigationGroup.inventory,
  ),
  supplier(
    'Pemasok',
    Icons.local_shipping_outlined,
    CatalogNavigationGroup.inventory,
  ),
  categories(
    'Kategori',
    Icons.category_outlined,
    CatalogNavigationGroup.settings,
  ),
  addOnGroups(
    'Grup tambahan',
    Icons.layers_outlined,
    CatalogNavigationGroup.settings,
  ),
  feesAndCharges(
    'Biaya & pungutan',
    Icons.payments_outlined,
    CatalogNavigationGroup.settings,
  );

  const CatalogSection(this.label, this.icon, this.group);

  final String label;
  final IconData icon;
  final CatalogNavigationGroup group;
}

class CatalogWorkspace extends StatelessWidget {
  const CatalogWorkspace({
    required this.state,
    required this.cubit,
    required this.searchController,
    required this.selectedSection,
    required this.onSectionSelected,
    this.catalogIngredientImagePicker,
    super.key,
  });

  final SaleUiState state;
  final SaleCubit cubit;
  final TextEditingController searchController;
  final CatalogSection selectedSection;
  final ValueChanged<CatalogSection> onSectionSelected;
  final CatalogIngredientImagePicker? catalogIngredientImagePicker;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final preferredNavigationWidth =
            constraints.maxWidth * _CatalogLayout.navigationWidthFactor;
        final navigationWidth =
            constraints.maxWidth < _CatalogLayout.compactBreakpoint
            ? constraints.maxWidth * _CatalogLayout.compactNavigationWidthFactor
            : preferredNavigationWidth < _CatalogLayout.navigationMinWidth
            ? _CatalogLayout.navigationMinWidth
            : preferredNavigationWidth;

        return ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Row(
            key: const ValueKey('catalog-workspace'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                key: const ValueKey('catalog-navigation-panel'),
                width: navigationWidth,
                child: _CatalogNavigationPanel(
                  itemCount:
                      state.categoryCounts[SaleCategoryFilter.all] ??
                      state.products.length,
                  ingredientCount: cubit.catalogIngredientCount,
                  selectedSection: selectedSection,
                  showSectionChevrons:
                      navigationWidth >=
                      _CatalogLayout.sectionChevronBreakpoint,
                  onSectionSelected: onSectionSelected,
                ),
              ),
              const SrDivider(axis: Axis.vertical),
              Expanded(
                child: _CatalogItemsPanel(
                  state: state,
                  cubit: cubit,
                  searchController: searchController,
                  selectedSection: selectedSection,
                  catalogIngredientImagePicker: catalogIngredientImagePicker,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CatalogNavigationPanel extends StatelessWidget {
  const _CatalogNavigationPanel({
    required this.itemCount,
    required this.ingredientCount,
    required this.selectedSection,
    required this.showSectionChevrons,
    required this.onSectionSelected,
  });

  final int itemCount;
  final int ingredientCount;
  final CatalogSection selectedSection;
  final bool showSectionChevrons;
  final ValueChanged<CatalogSection> onSectionSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: SrSpacing.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final group in CatalogNavigationGroup.values) ...[
              SrListTitle(title: group.label),
              for (final section in CatalogSection.values.where(
                (section) => section.group == group,
              )) ...[
                SrListItem(
                  key: ValueKey('catalog-section-${section.name}'),
                  title: section.label,
                  leading: SrIcon(section.icon, size: SrIconSize.small),
                  trailing:
                      section == CatalogSection.items ||
                          section == CatalogSection.ingredients
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${section == CatalogSection.items ? itemCount : ingredientCount}',
                              style: SrTypography.actionMedium.copyWith(
                                color: colors.primary,
                              ),
                            ),
                            const SizedBox(width: SrSpacing.space4),
                            SrIcon(
                              Icons.chevron_right_rounded,
                              size: SrIconSize.small,
                              color: colors.onSurfaceVariant,
                            ),
                          ],
                        )
                      : null,
                  showChevron:
                      showSectionChevrons &&
                      section != CatalogSection.items &&
                      section != CatalogSection.ingredients,
                  selected: selectedSection == section,
                  size: SrComponentSize.small,
                  onTap: () => onSectionSelected(section),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _CatalogItemsPanel extends StatelessWidget {
  const _CatalogItemsPanel({
    required this.state,
    required this.cubit,
    required this.searchController,
    required this.selectedSection,
    required this.catalogIngredientImagePicker,
  });

  final SaleUiState state;
  final SaleCubit cubit;
  final TextEditingController searchController;
  final CatalogSection selectedSection;
  final CatalogIngredientImagePicker? catalogIngredientImagePicker;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(SrSpacing.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  selectedSection.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SrTypography.heading2.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ),
              if (selectedSection == CatalogSection.ingredients) ...[
                const SizedBox(width: SrSpacing.space8),
                SrButton(
                  label: 'Tambah',
                  leadingIcon: const SrIcon(Icons.add_rounded),
                  variant: SrButtonVariant.primary,
                  size: SrComponentSize.small,
                  isLoading: false,
                  semanticLabel: 'Tambah bahan baku',
                  onPressed: () => showAddCatalogIngredientDialog(
                    context: context,
                    cubit: cubit,
                    searchController: searchController,
                    imagePicker: catalogIngredientImagePicker,
                  ),
                ),
              ],
            ],
          ),
          if (selectedSection == CatalogSection.items)
            Expanded(
              child: SaleProductCatalog(
                state: state,
                searchController: searchController,
                onQueryChanged: cubit.updateQuery,
                onCategoryChanged: cubit.selectCategory,
                onRecommendedChanged: cubit.setRecommendedOnly,
                onRetry: cubit.load,
                showRecommendedFilter: false,
                searchHint: 'Cari nama, SKU, atau barcode',
                itemLabel: 'menu',
              ),
            )
          else if (selectedSection == CatalogSection.ingredients)
            Expanded(
              child: _IngredientCatalog(
                ingredients: cubit.filteredCatalogIngredients,
                searchController: searchController,
                onQueryChanged: cubit.updateQuery,
                onEditIngredient: (ingredient) =>
                    showEditCatalogIngredientDialog(
                      context: context,
                      cubit: cubit,
                      searchController: searchController,
                      imagePicker: catalogIngredientImagePicker,
                      ingredient: ingredient,
                    ),
              ),
            )
          else ...[
            const SizedBox(height: SrSpacing.space12),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SrIcon(
                      selectedSection.icon,
                      size: SrIconSize.large,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(height: SrSpacing.space8),
                    Text(
                      'Belum ada data',
                      style: SrTypography.heading4.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: SrSpacing.space4),
                    Text(
                      selectedSection.label,
                      style: SrTypography.bodySmall.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _IngredientCatalog extends StatelessWidget {
  const _IngredientCatalog({
    required this.ingredients,
    required this.searchController,
    required this.onQueryChanged,
    required this.onEditIngredient,
  });

  final List<CatalogIngredient> ingredients;
  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<CatalogIngredient> onEditIngredient;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: SrSpacing.space8),
          child: SrTextField(
            key: const ValueKey('catalog-ingredients-search'),
            controller: searchController,
            hintText: 'Cari bahan baku',
            semanticLabel: 'Cari bahan baku',
            prefixIcon: const SrIcon(
              Icons.search_rounded,
              size: SrIconSize.small,
            ),
            size: SrComponentSize.small,
            textInputAction: TextInputAction.search,
            onChanged: onQueryChanged,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          ),
        ),
        const SizedBox(height: SrSpacing.space8),
        Text(
          '${ingredients.length} bahan baku',
          style: SrTypography.bodySmall.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: SrSpacing.space8),
        Expanded(
          child: ingredients.isEmpty
              ? Center(
                  child: Text(
                    'Bahan baku tidak ditemukan. Coba kata kunci lain.',
                    textAlign: TextAlign.center,
                    style: SrTypography.bodyMedium.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final columnCount =
                        SaleProductGridLayout.productColumnCount(
                          constraints.maxWidth,
                        );
                    final cardHeight = columnCount == 3
                        ? SaleProductGridLayout.threeColumnCardHeight
                        : SaleProductGridLayout.cardHeight;

                    return GridView.builder(
                      key: const ValueKey('catalog-ingredients-grid'),
                      padding: const EdgeInsets.only(bottom: SrSpacing.space16),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: SaleProductGridLayout.cardMaxWidth,
                        mainAxisExtent: cardHeight,
                        crossAxisSpacing: SrSpacing.space8,
                        mainAxisSpacing: SrSpacing.space8,
                      ),
                      itemCount: ingredients.length,
                      itemBuilder: (context, index) {
                        final ingredient = ingredients[index];
                        return LayoutBuilder(
                          builder: (context, cardConstraints) {
                            final popupWidth =
                                cardConstraints.maxWidth <
                                    _IngredientLayout.popupWidth
                                ? cardConstraints.maxWidth
                                : _IngredientLayout.popupWidth;
                            return _IngredientCard(
                              key: ValueKey(
                                'ingredient-${_ingredientKey(ingredient.name)}',
                              ),
                              name: ingredient.name,
                              imageBytes: ingredient.imageBytes,
                              mediaHeight: cardHeight,
                              popupWidth: popupWidth,
                              onEdit: () => onEditIngredient(ingredient),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _IngredientCard extends StatefulWidget {
  const _IngredientCard({
    required this.name,
    required this.imageBytes,
    required this.mediaHeight,
    required this.popupWidth,
    required this.onEdit,
    super.key,
  });

  final String name;
  final List<int>? imageBytes;
  final double mediaHeight;
  final double popupWidth;
  final VoidCallback onEdit;

  @override
  State<_IngredientCard> createState() => _IngredientCardState();
}

class _IngredientCardState extends State<_IngredientCard> {
  final OverlayPortalController _popupController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  final Object _tapRegionGroup = Object();

  void _togglePopup() {
    if (_popupController.isShowing) {
      _popupController.hide();
    } else {
      _popupController.show();
    }
  }

  void _hidePopup() => _popupController.hide();

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      groupId: _tapRegionGroup,
      onTapOutside: (_) => _hidePopup(),
      child: OverlayPortal(
        controller: _popupController,
        overlayChildBuilder: (context) => CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, SrSpacing.space4),
          showWhenUnlinked: false,
          child: Align(
            alignment: Alignment.topLeft,
            child: TapRegion(
              groupId: _tapRegionGroup,
              child: SizedBox(
                key: const ValueKey('ingredient-action-popup'),
                width: widget.popupWidth,
                child: _IngredientActionPopup(
                  onDismiss: _hidePopup,
                  onEdit: () {
                    _hidePopup();
                    widget.onEdit();
                  },
                ),
              ),
            ),
          ),
        ),
        child: CompositedTransformTarget(
          link: _layerLink,
          child: Builder(
            builder: (context) {
              final colors = Theme.of(context).colorScheme;
              final thumbnailColors = _ingredientThumbnailColors(
                colors,
                widget.name,
              );
              final imageBytes = widget.imageBytes;
              return SrCard(
                title: '',
                layout: SrCardLayout.vertical,
                visualKind: SrCardVisualKind.media,
                visual: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: imageBytes == null
                          ? ColoredBox(
                              key: ValueKey(
                                'ingredient-thumbnail-${_ingredientKey(widget.name)}',
                              ),
                              color: thumbnailColors.background,
                            )
                          : Image.memory(
                              Uint8List.fromList(imageBytes),
                              key: ValueKey(
                                'ingredient-thumbnail-${_ingredientKey(widget.name)}',
                              ),
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  ColoredBox(color: thumbnailColors.background),
                            ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.42, 1],
                            colors: [
                              colors.inverseSurface.withValues(alpha: 0),
                              colors.inverseSurface.withValues(alpha: 0.88),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (imageBytes == null)
                      Center(
                        child: Text(
                          _ingredientInitials(widget.name),
                          maxLines: 1,
                          style: SrTypography.heading1.copyWith(
                            color: thumbnailColors.foreground,
                          ),
                        ),
                      ),
                    Positioned(
                      left: SrSpacing.space12,
                      right: SrSpacing.space12,
                      bottom: SrSpacing.space12,
                      child: Text(
                        widget.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: SrTypography.heading4.copyWith(
                          color: colors.onInverseSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                mediaHeight: widget.mediaHeight,
                contentPadding: EdgeInsets.zero,
                onTap: _togglePopup,
                semanticLabel: 'Tampilkan aksi untuk ${widget.name}',
              );
            },
          ),
        ),
      ),
    );
  }
}

class _IngredientActionPopup extends StatelessWidget {
  const _IngredientActionPopup({required this.onDismiss, required this.onEdit});

  final VoidCallback onDismiss;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      key: const ValueKey('ingredient-action-popup-surface'),
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SrRadii.medium),
        side: BorderSide(color: colors.outlineVariant, width: SrBorders.thin),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SrListItem(
            title: 'Kelola stok',
            leading: const SrIcon(Icons.inventory_2_outlined),
            size: SrComponentSize.small,
            semanticLabel: 'Kelola stok: masuk, keluar, lihat riwayat',
            onTap: onDismiss,
          ),
          const SrDivider(),
          SrListItem(
            title: 'Edit Bahan',
            leading: const SrIcon(Icons.edit_outlined),
            size: SrComponentSize.small,
            onTap: onEdit,
          ),
          const SrDivider(),
          Theme(
            data: Theme.of(
              context,
            ).copyWith(colorScheme: colors.copyWith(onSurface: colors.error)),
            child: SrListItem(
              title: 'Hapus Bahan',
              leading: const SrIcon(Icons.delete_outline_rounded),
              size: SrComponentSize.small,
              onTap: onDismiss,
            ),
          ),
        ],
      ),
    );
  }
}

abstract final class _IngredientLayout {
  static const double popupWidth = SrSizing.size80 * 2;
}

String _ingredientKey(String name) =>
    name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');

String _ingredientInitials(String name) {
  final words = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty);
  final nonEmptyWords = words.toList(growable: false);
  if (nonEmptyWords.isEmpty) return '';
  if (nonEmptyWords.length > 1) {
    return '${nonEmptyWords.first[0]}${nonEmptyWords[1][0]}'.toUpperCase();
  }

  return nonEmptyWords.single.runes
      .take(2)
      .map(String.fromCharCode)
      .join()
      .toUpperCase();
}

({Color background, Color foreground}) _ingredientThumbnailColors(
  ColorScheme colors,
  String name,
) {
  final palette = [
    (
      background: colors.primaryContainer,
      foreground: colors.onPrimaryContainer,
    ),
    (
      background: colors.tertiaryContainer,
      foreground: colors.onTertiaryContainer,
    ),
    (background: colors.surfaceContainerHigh, foreground: colors.onSurface),
  ];
  var paletteIndex = 0;
  for (final codeUnit in name.toLowerCase().codeUnits) {
    paletteIndex = (paletteIndex * 31 + codeUnit) % palette.length;
  }
  return palette[paletteIndex];
}

abstract final class _CatalogLayout {
  static const double navigationWidthFactor = 0.2;
  // assumption: a compact viewport reserves more room so section labels remain legible.
  static const double compactNavigationWidthFactor = 0.4;
  // assumption: preserve the longest group labels on the default tablet viewport.
  static const double navigationMinWidth = 224;
  static const double sectionChevronBreakpoint = 280;
  static const double compactBreakpoint = 900;
}

enum CatalogNavigationGroup {
  items('MENU'),
  inventory('PERSEDIAAN'),
  settings('PENGATURAN');

  const CatalogNavigationGroup(this.label);

  final String label;
}
