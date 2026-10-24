import 'package:flutter/foundation.dart';
import 'package:sr_pos/features/sale/domain/models/sale_product.dart';

enum SaleCategoryFilter { all, coffee, nonCoffee, snack }

enum SalePaymentMethod { cash, bankTransfer, qris }

extension SalePaymentMethodLabel on SalePaymentMethod {
  String get label => switch (this) {
    SalePaymentMethod.cash => 'Tunai',
    SalePaymentMethod.bankTransfer => 'Bank BCA',
    SalePaymentMethod.qris => 'QRIS',
  };
}

@immutable
final class SaleProductViewData {
  const SaleProductViewData({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryLabel,
    required this.priceInRupiah,
    required this.priceLabel,
    required this.isPopular,
  });

  final String id;
  final String name;
  final SaleProductCategory category;
  final String categoryLabel;
  final int priceInRupiah;
  final String priceLabel;
  final bool isPopular;
}

@immutable
final class SaleCartLineViewData {
  const SaleCartLineViewData({
    required this.productId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.itemPriceInRupiah,
    required this.itemPriceLabel,
    required this.itemNote,
    required this.totalInRupiah,
    required this.totalLabel,
  });

  final String productId;
  final String name;
  final SaleProductCategory category;
  final int quantity;
  final int itemPriceInRupiah;
  final String itemPriceLabel;
  final String itemNote;
  final int totalInRupiah;
  final String totalLabel;
}

@immutable
final class SaleReceipt {
  SaleReceipt({
    required this.itemCount,
    required this.totalInRupiah,
    required this.totalLabel,
    required this.paymentMethodLabel,
    required this.customerName,
    required this.cashReceivedInRupiah,
    required this.changeInRupiah,
    required List<SaleCartLineViewData> items,
  }) : items = List<SaleCartLineViewData>.unmodifiable(items);

  final int itemCount;
  final int totalInRupiah;
  final String totalLabel;
  final String paymentMethodLabel;
  final String customerName;
  final int cashReceivedInRupiah;
  final int changeInRupiah;
  final List<SaleCartLineViewData> items;
}

@immutable
final class SaleUiState {
  SaleUiState({
    required this.isLoading,
    required this.query,
    required this.categoryFilter,
    required this.recommendedOnly,
    required Map<SaleCategoryFilter, int> categoryCounts,
    required List<SaleProductViewData> products,
    required List<SaleCartLineViewData> cartItems,
    required this.selectedCustomer,
    required this.paymentMethod,
    required this.cashReceivedInput,
    this.errorMessage,
    this.receipt,
  }) : categoryCounts = Map<SaleCategoryFilter, int>.unmodifiable(
         categoryCounts,
       ),
       products = List<SaleProductViewData>.unmodifiable(products),
       cartItems = List<SaleCartLineViewData>.unmodifiable(cartItems);

  factory SaleUiState.initial() {
    return SaleUiState(
      isLoading: true,
      query: '',
      categoryFilter: SaleCategoryFilter.all,
      recommendedOnly: false,
      categoryCounts: const {
        SaleCategoryFilter.all: 0,
        SaleCategoryFilter.coffee: 0,
        SaleCategoryFilter.nonCoffee: 0,
        SaleCategoryFilter.snack: 0,
      },
      products: const [],
      cartItems: const [],
      selectedCustomer: SaleUiState.customers.first,
      paymentMethod: SalePaymentMethod.cash,
      cashReceivedInput: '',
    );
  }

  static const customers = <String>[
    'Pelanggan umum',
    'Dina Permata',
    'Raka Aditya',
  ];

  final bool isLoading;
  final String? errorMessage;
  final String query;
  final SaleCategoryFilter categoryFilter;
  final bool recommendedOnly;
  final Map<SaleCategoryFilter, int> categoryCounts;
  final List<SaleProductViewData> products;
  final List<SaleCartLineViewData> cartItems;
  final String selectedCustomer;
  final SalePaymentMethod paymentMethod;
  final String cashReceivedInput;
  final SaleReceipt? receipt;

  int get itemCount =>
      cartItems.fold(0, (total, item) => total + item.quantity);

  int quantityOf(String productId) {
    for (final item in cartItems) {
      if (item.productId == productId) return item.quantity;
    }
    return 0;
  }

  int get totalInRupiah =>
      cartItems.fold(0, (total, item) => total + item.totalInRupiah);

  int get cashReceivedInRupiah =>
      int.tryParse(cashReceivedInput.replaceAll(RegExp('[^0-9]'), '')) ?? 0;

  int get changeInRupiah =>
      paymentMethod == SalePaymentMethod.cash &&
          cashReceivedInRupiah > totalInRupiah
      ? cashReceivedInRupiah - totalInRupiah
      : 0;

  bool get canCompleteSale =>
      !isLoading &&
      errorMessage == null &&
      receipt == null &&
      cartItems.isNotEmpty &&
      (paymentMethod != SalePaymentMethod.cash ||
          cashReceivedInRupiah >= totalInRupiah);

  SaleUiState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? query,
    SaleCategoryFilter? categoryFilter,
    bool? recommendedOnly,
    Map<SaleCategoryFilter, int>? categoryCounts,
    List<SaleProductViewData>? products,
    List<SaleCartLineViewData>? cartItems,
    String? selectedCustomer,
    SalePaymentMethod? paymentMethod,
    String? cashReceivedInput,
    SaleReceipt? receipt,
    bool clearReceipt = false,
  }) {
    return SaleUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      query: query ?? this.query,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      recommendedOnly: recommendedOnly ?? this.recommendedOnly,
      categoryCounts: categoryCounts ?? this.categoryCounts,
      products: products ?? this.products,
      cartItems: cartItems ?? this.cartItems,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cashReceivedInput: cashReceivedInput ?? this.cashReceivedInput,
      receipt: clearReceipt ? null : receipt ?? this.receipt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SaleUiState &&
            isLoading == other.isLoading &&
            errorMessage == other.errorMessage &&
            query == other.query &&
            categoryFilter == other.categoryFilter &&
            recommendedOnly == other.recommendedOnly &&
            mapEquals(categoryCounts, other.categoryCounts) &&
            listEquals(products, other.products) &&
            listEquals(cartItems, other.cartItems) &&
            selectedCustomer == other.selectedCustomer &&
            paymentMethod == other.paymentMethod &&
            cashReceivedInput == other.cashReceivedInput &&
            receipt == other.receipt;
  }

  @override
  int get hashCode => Object.hash(
    isLoading,
    errorMessage,
    query,
    categoryFilter,
    recommendedOnly,
    Object.hashAllUnordered(
      categoryCounts.entries.map(
        (entry) => Object.hash(entry.key, entry.value),
      ),
    ),
    Object.hashAll(products),
    Object.hashAll(cartItems),
    selectedCustomer,
    paymentMethod,
    cashReceivedInput,
    receipt,
  );
}
