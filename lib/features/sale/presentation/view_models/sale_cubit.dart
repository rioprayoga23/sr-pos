import 'package:bloc/bloc.dart';
import 'package:sr_pos/features/sale/domain/models/sale_product.dart';
import 'package:sr_pos/features/sale/domain/repositories/sale_repository.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_ui_state.dart';

final class SaleCubit extends Cubit<SaleUiState> {
  SaleCubit(this._saleRepository) : super(SaleUiState.initial());

  static const int _suggestedCashIncrement = 50000;

  final SaleRepository _saleRepository;
  var _allProducts = const <SaleProduct>[];
  final Map<String, int> _quantities = <String, int>{};
  final Map<String, int> _customPrices = <String, int>{};
  final Map<String, String> _itemNotes = <String, String>{};

  static String formatRupiah(int amount) {
    final digits = amount.toString();
    final grouped = digits.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp$grouped';
  }

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      final products = await _saleRepository.getProducts();
      _allProducts = List<SaleProduct>.unmodifiable(products);
      _emitUpdatedState(isLoading: false, clearErrorMessage: true);
    } on SaleRepositoryException catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.message));
    }
  }

  void updateQuery(String query) {
    _emitUpdatedState(query: query);
  }

  void selectCategory(SaleCategoryFilter category) {
    _emitUpdatedState(categoryFilter: category);
  }

  void setRecommendedOnly(bool enabled) {
    _emitUpdatedState(recommendedOnly: enabled);
  }

  void addProduct(
    String productId, {
    int quantity = 1,
    int? customPriceInRupiah,
    String? itemNote,
  }) {
    final productExists = _allProducts.any(
      (product) => product.id == productId,
    );
    if (!productExists ||
        quantity <= 0 ||
        (customPriceInRupiah != null && customPriceInRupiah <= 0) ||
        state.receipt != null) {
      return;
    }

    _quantities.update(
      productId,
      (currentQuantity) => currentQuantity + quantity,
      ifAbsent: () => quantity,
    );
    if (customPriceInRupiah != null) {
      _customPrices[productId] = customPriceInRupiah;
    }
    if (itemNote != null) _itemNotes[productId] = itemNote.trim();
    _emitUpdatedState();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity < 0 || state.receipt != null) return;
    if (quantity == 0) {
      _quantities.remove(productId);
      _customPrices.remove(productId);
      _itemNotes.remove(productId);
    } else if (_allProducts.any((product) => product.id == productId)) {
      _quantities[productId] = quantity;
    }
    _emitUpdatedState();
  }

  void removeProduct(String productId) {
    if (state.receipt != null) return;
    _quantities.remove(productId);
    _customPrices.remove(productId);
    _itemNotes.remove(productId);
    _emitUpdatedState();
  }

  void setCustomer(String? customer) {
    if (customer == null ||
        state.receipt != null ||
        !SaleUiState.customers.contains(customer)) {
      return;
    }
    emit(state.copyWith(selectedCustomer: customer));
  }

  void setPaymentMethod(SalePaymentMethod? paymentMethod) {
    if (paymentMethod == null || state.receipt != null) return;
    emit(state.copyWith(paymentMethod: paymentMethod));
  }

  void setCashReceivedInput(String input) {
    if (state.receipt != null) return;
    final digitsOnly = input.replaceAll(RegExp('[^0-9]'), '');
    emit(state.copyWith(cashReceivedInput: digitsOnly));
  }

  void setCashReceivedAmount(int amount) {
    setCashReceivedInput(amount.toString());
  }

  int get suggestedCashAmount {
    final total = state.totalInRupiah;
    if (total <= 0) return _suggestedCashIncrement;
    final rounded =
        ((total + _suggestedCashIncrement - 1) ~/ _suggestedCashIncrement) *
        _suggestedCashIncrement;
    return rounded == total ? total + _suggestedCashIncrement : rounded;
  }

  SaleReceipt? completeSale() {
    if (!state.canCompleteSale) return null;

    final receipt = SaleReceipt(
      itemCount: state.itemCount,
      totalInRupiah: state.totalInRupiah,
      totalLabel: formatRupiah(state.totalInRupiah),
      paymentMethodLabel: state.paymentMethod.label,
      customerName: state.selectedCustomer,
      cashReceivedInRupiah: state.paymentMethod == SalePaymentMethod.cash
          ? state.cashReceivedInRupiah
          : state.totalInRupiah,
      changeInRupiah: state.changeInRupiah,
      items: state.cartItems,
    );
    _quantities.clear();
    _customPrices.clear();
    _itemNotes.clear();
    emit(state.copyWith(cartItems: const [], receipt: receipt));
    return receipt;
  }

  void clearOrder() {
    _quantities.clear();
    _customPrices.clear();
    _itemNotes.clear();
    emit(
      state.copyWith(
        cartItems: const [],
        cashReceivedInput: '',
        clearReceipt: true,
      ),
    );
  }

  void startNewSale() {
    _quantities.clear();
    _customPrices.clear();
    _itemNotes.clear();
    emit(
      state.copyWith(
        cartItems: const [],
        selectedCustomer: SaleUiState.customers.first,
        paymentMethod: SalePaymentMethod.cash,
        cashReceivedInput: '',
        clearReceipt: true,
      ),
    );
  }

  void _emitUpdatedState({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? query,
    SaleCategoryFilter? categoryFilter,
    bool? recommendedOnly,
    String? cashReceivedInput,
  }) {
    final nextQuery = query ?? state.query;
    final nextCategory = categoryFilter ?? state.categoryFilter;
    final nextRecommendedOnly = recommendedOnly ?? state.recommendedOnly;
    final normalizedQuery = nextQuery.trim().toLowerCase();
    final categoryCounts = <SaleCategoryFilter, int>{
      SaleCategoryFilter.all: _allProducts.length,
      SaleCategoryFilter.coffee: _allProducts
          .where((product) => product.category == SaleProductCategory.coffee)
          .length,
      SaleCategoryFilter.nonCoffee: _allProducts
          .where((product) => product.category == SaleProductCategory.nonCoffee)
          .length,
      SaleCategoryFilter.snack: _allProducts
          .where((product) => product.category == SaleProductCategory.snack)
          .length,
    };
    final filteredProducts = _allProducts
        .where((product) {
          final matchesQuery =
              normalizedQuery.isEmpty ||
              product.name.toLowerCase().contains(normalizedQuery);
          final matchesCategory = switch (nextCategory) {
            SaleCategoryFilter.all => true,
            SaleCategoryFilter.coffee =>
              product.category == SaleProductCategory.coffee,
            SaleCategoryFilter.nonCoffee =>
              product.category == SaleProductCategory.nonCoffee,
            SaleCategoryFilter.snack =>
              product.category == SaleProductCategory.snack,
          };
          final matchesRecommendation =
              !nextRecommendedOnly || product.isPopular;
          return matchesQuery && matchesCategory && matchesRecommendation;
        })
        .map(_toProductViewData)
        .toList(growable: false);

    final productsById = <String, SaleProduct>{
      for (final product in _allProducts) product.id: product,
    };
    final cartItems = _quantities.entries
        .map((entry) {
          final product = productsById[entry.key];
          if (product == null) return null;
          final unitPrice = _customPrices[product.id] ?? product.priceInRupiah;
          final lineTotal = unitPrice * entry.value;
          return SaleCartLineViewData(
            productId: product.id,
            name: product.name,
            category: product.category,
            quantity: entry.value,
            itemPriceInRupiah: unitPrice,
            itemPriceLabel: '${formatRupiah(unitPrice)} / item',
            itemNote: _itemNotes[product.id] ?? '',
            totalInRupiah: lineTotal,
            totalLabel: formatRupiah(lineTotal),
          );
        })
        .whereType<SaleCartLineViewData>()
        .toList(growable: false);

    emit(
      state.copyWith(
        isLoading: isLoading,
        errorMessage: errorMessage,
        clearErrorMessage: clearErrorMessage,
        query: nextQuery,
        categoryFilter: nextCategory,
        recommendedOnly: nextRecommendedOnly,
        categoryCounts: categoryCounts,
        products: filteredProducts,
        cartItems: cartItems,
        cashReceivedInput: cashReceivedInput,
      ),
    );
  }

  SaleProductViewData _toProductViewData(SaleProduct product) {
    final categoryLabel = switch (product.category) {
      SaleProductCategory.coffee => 'Kopi',
      SaleProductCategory.nonCoffee => 'Non-kopi',
      SaleProductCategory.snack => 'Camilan',
    };
    return SaleProductViewData(
      id: product.id,
      name: product.name,
      category: product.category,
      categoryLabel: categoryLabel,
      priceInRupiah: product.priceInRupiah,
      priceLabel: formatRupiah(product.priceInRupiah),
      isPopular: product.isPopular,
    );
  }
}
