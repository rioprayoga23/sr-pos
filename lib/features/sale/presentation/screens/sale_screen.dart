import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/sale/domain/services/catalog_ingredient_image_picker.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_cubit.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_ui_state.dart';
import 'package:sr_pos/features/sale/presentation/widgets/catalog_workspace.dart';
import 'package:sr_pos/features/sale/presentation/widgets/sale_order_list.dart';
import 'package:sr_pos/features/sale/presentation/widgets/sale_product_catalog.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({
    required this.cubit,
    this.catalogIngredientImagePicker,
    super.key,
  });

  final SaleCubit cubit;
  final CatalogIngredientImagePicker? catalogIngredientImagePicker;

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  late final TextEditingController _searchController;
  late final TextEditingController _cashController;
  bool _isSidebarExpanded = true;
  _MainNavigationDestination _selectedMainDestination =
      _MainNavigationDestination.cashier;
  CatalogSection _selectedCatalogSection = CatalogSection.items;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _cashController = TextEditingController(
      text: _CashAmountInputFormatter.formatDigits(
        widget.cubit.state.cashReceivedInput,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: SrSizing.size64,
              child: _SaleHeader(
                isSidebarExpanded: _isSidebarExpanded,
                onSidebarToggle: () =>
                    setState(() => _isSidebarExpanded = !_isSidebarExpanded),
              ),
            ),
            SrDivider(),
            Expanded(
              child: Row(
                children: [
                  _SaleSidebar(
                    isExpanded: _isSidebarExpanded,
                    selectedDestination: _selectedMainDestination,
                    onDestinationSelected: _selectMainDestination,
                  ),
                  SrDivider(axis: Axis.vertical),
                  Expanded(
                    child: StreamBuilder<SaleUiState>(
                      stream: widget.cubit.stream,
                      initialData: widget.cubit.state,
                      builder: (context, snapshot) {
                        final state = snapshot.data ?? widget.cubit.state;
                        if (_selectedMainDestination ==
                            _MainNavigationDestination.cashier) {
                          return _SaleWorkspace(
                            state: state,
                            cubit: widget.cubit,
                            searchController: _searchController,
                            cashController: _cashController,
                            onProductSelected: _addProduct,
                            onCashAmountSelected: _setCashAmount,
                            onClearOrder: _confirmClearOrder,
                            onCompleteSale: _completeSale,
                          );
                        }
                        return CatalogWorkspace(
                          state: state,
                          cubit: widget.cubit,
                          searchController: _searchController,
                          selectedSection: _selectedCatalogSection,
                          onSectionSelected: _selectCatalogSection,
                          catalogIngredientImagePicker:
                              widget.catalogIngredientImagePicker,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectMainDestination(_MainNavigationDestination destination) {
    if (_selectedMainDestination == destination) return;

    _searchController.clear();
    widget.cubit.updateQuery('');
    if (destination == _MainNavigationDestination.catalog) {
      widget.cubit.selectCategory(SaleCategoryFilter.all);
      widget.cubit.setRecommendedOnly(false);
    }
    setState(() {
      _selectedMainDestination = destination;
      _selectedCatalogSection = CatalogSection.items;
    });
  }

  void _selectCatalogSection(CatalogSection section) {
    setState(() => _selectedCatalogSection = section);
  }

  void _setCashAmount(int amount) {
    final input = _CashAmountInputFormatter.formatDigits(amount.toString());
    _cashController.value = TextEditingValue(
      text: input,
      selection: TextSelection.collapsed(offset: input.length),
    );
    widget.cubit.setCashReceivedAmount(amount);
  }

  void _addProduct(SaleProductViewData product) {
    widget.cubit.addProduct(product.id);
  }

  Future<void> _confirmClearOrder(BuildContext context) async {
    await showSrDialog<void>(
      context: context,
      barrierDismissible: true,
      dialog: SrDialog(
        title: 'Hapus pesanan?',
        message: 'Semua menu di pesanan ini akan dihapus.',
        actions: [
          SrDialogAction(
            label: 'Kembali',
            variant: SrButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          SrDialogAction(
            label: 'Hapus pesanan',
            onPressed: () {
              widget.cubit.clearOrder();
              _cashController.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _completeSale(BuildContext context) async {
    final receipt = widget.cubit.completeSale();
    if (receipt == null) return;
    final colors = Theme.of(context).colorScheme;
    final supportingTextStyle = SrTypography.bodySmall.copyWith(
      color: colors.onSurfaceVariant,
    );
    final itemTotalStyle = SrTypography.actionMedium.copyWith(
      color: colors.onSurface,
    );
    final totalStyle = SrTypography.heading3.copyWith(color: colors.onSurface);
    final receiptDetails = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Metode pembayaran', style: supportingTextStyle),
            Text(receipt.paymentMethodLabel, style: itemTotalStyle),
          ],
        ),
        const SizedBox(height: SrSpacing.space4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pelanggan', style: supportingTextStyle),
            Text(receipt.customerName, style: itemTotalStyle),
          ],
        ),
        const SizedBox(height: SrSpacing.space12),
        const SrDivider(),
        Padding(
          padding: const EdgeInsets.only(
            top: SrSpacing.space8,
            bottom: SrSpacing.space4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rincian pesanan', style: supportingTextStyle),
              Text('${receipt.itemCount} item', style: supportingTextStyle),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: _SaleLayout.receiptLinesMaxHeight,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (final (index, item) in receipt.items.indexed) ...[
                  SrListItem(
                    title: item.name,
                    subtitle:
                        '${item.quantity} × '
                        '${SaleCubit.formatRupiah(item.itemPriceInRupiah)}',
                    trailing: Text(item.totalLabel, style: itemTotalStyle),
                    size: SrComponentSize.small,
                    semanticLabel:
                        '${item.name}, ${item.quantity} × '
                        '${SaleCubit.formatRupiah(item.itemPriceInRupiah)}, '
                        '${item.totalLabel}',
                  ),
                  if (index < receipt.items.length - 1)
                    const SrDivider(
                      indent: SrSpacing.space12,
                      endIndent: SrSpacing.space12,
                    ),
                ],
              ],
            ),
          ),
        ),
        const SrDivider(),
        Padding(
          padding: const EdgeInsets.only(top: SrSpacing.space8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: totalStyle),
              Text(receipt.totalLabel, style: totalStyle),
            ],
          ),
        ),
        const SizedBox(height: SrSpacing.space12),
        Align(
          child: IconButton.filledTonal(
            onPressed: () {
              Navigator.of(context).pop();
              showSrToast(
                context: context,
                message: 'Integrasi cetak struk belum tersedia.',
                tone: SrFeedbackTone.info,
                leading: const SrIcon(Icons.print_outlined),
              );
            },
            tooltip: 'Cetak struk',
            style: IconButton.styleFrom(
              backgroundColor: colors.primaryContainer,
              fixedSize: const Size.square(SrSizing.minimumTouchTarget),
              foregroundColor: colors.primary,
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
            ),
            icon: const SrIcon(Icons.print_outlined),
          ),
        ),
      ],
    );

    await showSrDialog<void>(
      context: context,
      barrierDismissible: true,
      dialog: SrDialog(
        title: 'Pembayaran berhasil',
        semanticLabel: 'Pembayaran berhasil, ${receipt.totalLabel}',
        compact: true,
        maxWidth: _SaleLayout.paymentDialogMaxWidth,
        onClose: () => Navigator.of(context).pop(),
        header: DecoratedBox(
          decoration: BoxDecoration(
            color: context.srStatusColors.success,
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(
            dimension: SrSizing.size64,
            child: Center(
              child: SrIcon(
                Icons.check_rounded,
                size: SrIconSize.extraLarge,
                color: context.srStatusColors.onSuccess,
                semanticLabel: 'Berhasil',
              ),
            ),
          ),
        ),
        actions: [
          SrDialogAction(
            label: 'Tutup',
            variant: SrButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          SrDialogAction(
            label: 'Transaksi baru',
            onPressed: () {
              widget.cubit.startNewSale();
              _cashController.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
        children: [receiptDetails],
      ),
    );
  }
}

class _SaleHeader extends StatelessWidget {
  const _SaleHeader({
    required this.isSidebarExpanded,
    required this.onSidebarToggle,
  });

  final bool isSidebarExpanded;
  final VoidCallback onSidebarToggle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final animationDuration = MediaQuery.of(context).disableAnimations
        ? SrMotion.instant
        : SrMotion.standard;
    final toggleLabel = isSidebarExpanded
        ? 'Sembunyikan label menu'
        : 'Tampilkan label menu';
    return SrNavBar(
      centerTitle: false,
      titleActions: [
        SrNavBarAction(
          icon: AnimatedRotation(
            turns: isSidebarExpanded ? 0 : 0.5,
            duration: animationDuration,
            curve: SrMotion.emphasizedCurve,
            child: SrIcon(
              Icons.chevron_left_rounded,
              size: SrIconSize.medium,
              color: colors.primary,
            ),
          ),
          tooltip: toggleLabel,
          semanticLabel: toggleLabel,
          onPressed: onSidebarToggle,
        ),
      ],
      titleWidget: SizedBox(
        width: _SaleLayout.sidebarAlignedHeaderIdentityWidth,
        child: Row(
          children: [
            const SrIcon(Icons.local_cafe_outlined),
            const SizedBox(width: SrSpacing.space8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kopi Yo',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SrTypography.actionLarge.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  Text(
                    'Outlet utama',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SrTypography.captionMedium.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleWorkspace extends StatelessWidget {
  const _SaleWorkspace({
    required this.state,
    required this.cubit,
    required this.searchController,
    required this.cashController,
    required this.onProductSelected,
    required this.onCashAmountSelected,
    required this.onClearOrder,
    required this.onCompleteSale,
  });

  final SaleUiState state;
  final SaleCubit cubit;
  final TextEditingController searchController;
  final TextEditingController cashController;
  final ValueChanged<SaleProductViewData> onProductSelected;
  final ValueChanged<int> onCashAmountSelected;
  final Future<void> Function(BuildContext) onClearOrder;
  final Future<void> Function(BuildContext) onCompleteSale;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final catalog = SaleProductCatalog(
      state: state,
      searchController: searchController,
      onQueryChanged: cubit.updateQuery,
      onCategoryChanged: cubit.selectCategory,
      onRecommendedChanged: cubit.setRecommendedOnly,
      onProductSelected: onProductSelected,
      onRetry: cubit.load,
    );
    final order = _OrderPanel(
      state: state,
      cubit: cubit,
      cashController: cashController,
      onCashAmountSelected: onCashAmountSelected,
      onClearOrder: onClearOrder,
      onCompleteSale: onCompleteSale,
    );

    return ColoredBox(
      color: colors.surfaceContainerLow,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= _SaleLayout.wideBreakpoint;
          return Padding(
            padding: const EdgeInsets.all(SrSpacing.space16),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: catalog),
                      const SizedBox(width: SrSpacing.space16),
                      SizedBox(
                        width: _SaleLayout.orderPanelWidth,
                        child: order,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: catalog),
                      const SizedBox(height: SrSpacing.space16),
                      SizedBox(
                        height: _SaleLayout.compactOrderPanelHeight,
                        child: order,
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _SaleSidebar extends StatelessWidget {
  const _SaleSidebar({
    required this.isExpanded,
    required this.selectedDestination,
    required this.onDestinationSelected,
  });

  final bool isExpanded;
  final _MainNavigationDestination selectedDestination;
  final ValueChanged<_MainNavigationDestination> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final animationDuration = MediaQuery.of(context).disableAnimations
        ? SrMotion.instant
        : SrMotion.standard;

    return AnimatedContainer(
      key: const ValueKey('sale-sidebar'),
      width: isExpanded
          ? _SaleLayout.sidebarExpandedWidth
          : _SaleLayout.sidebarCollapsedWidth,
      duration: animationDuration,
      curve: SrMotion.emphasizedCurve,
      child: Padding(
        padding: const EdgeInsets.all(SrSpacing.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _navigationItem(
              destination: _MainNavigationDestination.cashier,
              title: 'Kasir',
              icon: Icons.point_of_sale_rounded,
            ),
            const SizedBox(height: SrSpacing.space8),
            _navigationItem(
              destination: _MainNavigationDestination.catalog,
              title: 'Katalog',
              icon: Icons.inventory_2_outlined,
            ),
            const Spacer(),
            if (isExpanded)
              const Align(
                child: SrTag(
                  label: 'V 1.0.0',
                  tone: SrTagTone.primary,
                  size: SrTagSize.small,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _navigationItem({
    required _MainNavigationDestination destination,
    required String title,
    required IconData icon,
  }) {
    return SrListItem(
      title: isExpanded ? title : '',
      semanticLabel: title,
      leading: SrIcon(icon, size: SrIconSize.small),
      selected: selectedDestination == destination,
      selectedStyle: SrListItemSelectedStyle.primary,
      size: SrComponentSize.small,
      onTap: () => onDestinationSelected(destination),
    );
  }
}

enum _MainNavigationDestination { cashier, catalog }

class _OrderPanel extends StatelessWidget {
  const _OrderPanel({
    required this.state,
    required this.cubit,
    required this.cashController,
    required this.onCashAmountSelected,
    required this.onClearOrder,
    required this.onCompleteSale,
  });

  final SaleUiState state;
  final SaleCubit cubit;
  final TextEditingController cashController;
  final ValueChanged<int> onCashAmountSelected;
  final Future<void> Function(BuildContext) onClearOrder;
  final Future<void> Function(BuildContext) onCompleteSale;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final amountSuggestions = <int>{
      state.totalInRupiah,
      cubit.suggestedCashAmount,
    };
    final checkoutLabel = state.receipt != null
        ? 'Transaksi selesai'
        : state.cartItems.isEmpty
        ? 'Pilih menu untuk mulai'
        : 'Bayar · ${SaleCubit.formatRupiah(state.totalInRupiah)}';
    final checkoutIcon = state.receipt != null
        ? Icons.check_rounded
        : state.cartItems.isEmpty
        ? Icons.shopping_bag_outlined
        : Icons.lock_outline_rounded;

    return ClipRRect(
      borderRadius: BorderRadius.circular(SrRadii.medium),
      child: ColoredBox(
        color: colors.surface,
        child: Padding(
          padding: const EdgeInsets.all(SrSpacing.space12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pesanan Aktif',
                      style: SrTypography.heading3.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  if (state.itemCount > 0)
                    SrTag(
                      label: '${state.itemCount} item',
                      tone: SrTagTone.primary,
                      size: SrTagSize.small,
                    ),
                  const SizedBox(width: SrSpacing.space4),
                  SrButton(
                    label: 'Hapus',
                    variant: SrButtonVariant.destructive,
                    leadingIcon: const SrIcon(
                      Icons.delete_outline_rounded,
                      size: SrIconSize.small,
                    ),
                    size: SrComponentSize.small,
                    onPressed: state.cartItems.isEmpty
                        ? null
                        : () => unawaited(onClearOrder(context)),
                  ),
                ],
              ),
              const SizedBox(height: SrSpacing.space8),
              Expanded(
                child: state.cartItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SrIcon(
                              Icons.shopping_bag_outlined,
                              size: SrIconSize.large,
                              color: colors.onSurfaceVariant,
                            ),
                            const SizedBox(height: SrSpacing.space8),
                            Text(
                              'Pesanan masih kosong',
                              style: SrTypography.actionLarge.copyWith(
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: SrSpacing.space4),
                            Text(
                              'Pilih menu untuk mulai transaksi.',
                              textAlign: TextAlign.center,
                              style: SrTypography.bodySmall.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SaleOrderList(
                        items: state.cartItems,
                        onQuantityChanged: state.receipt == null
                            ? cubit.updateQuantity
                            : null,
                        onRemove: state.receipt == null
                            ? cubit.removeProduct
                            : null,
                      ),
              ),
              SrDivider(),
              const SizedBox(height: SrSpacing.space8),
              if (state.cartItems.isNotEmpty) ...[
                SrDropdown<SalePaymentMethod>(
                  items: SalePaymentMethod.values
                      .map(
                        (method) => SrDropdownItem(
                          value: method,
                          label: method.label,
                          leading: SrIcon(switch (method) {
                            SalePaymentMethod.cash => Icons.payments_outlined,
                            SalePaymentMethod.bankTransfer =>
                              Icons.account_balance_outlined,
                            SalePaymentMethod.qris => Icons.qr_code_2_rounded,
                          }, size: SrIconSize.small),
                        ),
                      )
                      .toList(growable: false),
                  value: state.paymentMethod,
                  labelText: 'Metode pembayaran',
                  semanticLabel: 'Pilih metode pembayaran',
                  size: SrComponentSize.small,
                  onChanged: state.receipt == null
                      ? cubit.setPaymentMethod
                      : null,
                ),
                if (state.paymentMethod == SalePaymentMethod.cash) ...[
                  const SizedBox(height: SrSpacing.space12),
                  SrTextField(
                    controller: cashController,
                    labelText: 'Uang diterima',
                    hintText: 'Contoh: 50000',
                    semanticLabel: 'Jumlah uang diterima dalam rupiah',
                    size: SrComponentSize.small,
                    keyboardType: TextInputType.number,
                    inputFormatters: const [_CashAmountInputFormatter()],
                    enabled: state.receipt == null,
                    onChanged: cubit.setCashReceivedInput,
                  ),
                  const SizedBox(height: SrSpacing.space8),
                  Wrap(
                    spacing: SrSpacing.space8,
                    runSpacing: SrSpacing.space4,
                    children: amountSuggestions
                        .map((amount) {
                          final isExact = amount == state.totalInRupiah;
                          return SrFilter(
                            label: isExact
                                ? 'Pas'
                                : SaleCubit.formatRupiah(amount),
                            semanticLabel:
                                'Isi ${SaleCubit.formatRupiah(amount)}',
                            selected: state.cashReceivedInRupiah == amount,
                            onSelected: state.receipt == null
                                ? (_) => onCashAmountSelected(amount)
                                : null,
                          );
                        })
                        .toList(growable: false),
                  ),
                ],
              ],
              const SizedBox(height: SrSpacing.space8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total',
                      style: SrTypography.heading4.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    SaleCubit.formatRupiah(state.totalInRupiah),
                    style: SrTypography.heading3.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
              if (state.cartItems.isNotEmpty &&
                  state.paymentMethod == SalePaymentMethod.cash) ...[
                const SizedBox(height: SrSpacing.space8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Kembalian',
                        style: SrTypography.actionMedium.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Text(
                      SaleCubit.formatRupiah(state.changeInRupiah),
                      style: SrTypography.actionMedium.copyWith(
                        color: colors.tertiary,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: SrSpacing.space8),
              SrButton(
                label: checkoutLabel,
                leadingIcon: SrIcon(checkoutIcon),
                expand: true,
                onPressed: state.canCompleteSale
                    ? () => unawaited(onCompleteSale(context))
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

abstract final class _SaleLayout {
  static const double orderPanelWidth = 420;
  static const double compactOrderPanelHeight = 560;
  static const double sidebarCollapsedWidth = SrSizing.size80;
  // assumption: keeps labels readable while trimming unused sidebar space.
  static const double sidebarExpandedWidth = 208;
  // assumption: title identity plus toggle align to the expanded menu inset.
  static const double sidebarAlignedHeaderIdentityWidth =
      sidebarExpandedWidth -
      SrSpacing.pageHorizontal -
      SrSpacing.space8 -
      SrSizing.minimumTouchTarget;
  static const double wideBreakpoint = 900;
  // assumption: scroll area keeps a full receipt and its actions within tablet height.
  static const double receiptLinesMaxHeight = 320;
  // assumption: keeps the payment receipt comfortably inset on tablet screens.
  static const double paymentDialogMaxWidth = SrSizing.size80 * 7;
}

class _CashAmountInputFormatter extends TextInputFormatter {
  const _CashAmountInputFormatter();

  static String formatDigits(String input) {
    final digits = input.replaceAll(RegExp('[^0-9]'), '');
    return digits.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = formatDigits(newValue.text);
    final selection = newValue.selection;
    if (!selection.isValid) {
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection(
        baseOffset: _formattedOffset(
          formatted,
          _digitCountBefore(newValue.text, selection.baseOffset),
        ),
        extentOffset: _formattedOffset(
          formatted,
          _digitCountBefore(newValue.text, selection.extentOffset),
        ),
        affinity: selection.affinity,
        isDirectional: selection.isDirectional,
      ),
    );
  }

  static int _digitCountBefore(String text, int offset) {
    final safeOffset = offset.clamp(0, text.length).toInt();
    var count = 0;
    for (var index = 0; index < safeOffset; index++) {
      if (_isDigit(text.codeUnitAt(index))) count++;
    }
    return count;
  }

  static int _formattedOffset(String text, int digitCount) {
    if (digitCount == 0) return 0;
    var count = 0;
    for (var index = 0; index < text.length; index++) {
      if (_isDigit(text.codeUnitAt(index))) {
        count++;
        if (count == digitCount) return index + 1;
      }
    }
    return text.length;
  }

  static bool _isDigit(int codeUnit) => codeUnit >= 48 && codeUnit <= 57;
}
