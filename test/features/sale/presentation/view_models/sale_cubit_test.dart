import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/features/sale/data/repositories/in_memory_sale_repository.dart';
import 'package:sr_pos/features/sale/domain/models/sale_product.dart';
import 'package:sr_pos/features/sale/domain/repositories/sale_repository.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_cubit.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_ui_state.dart';

void main() {
  group('SaleCubit', () {
    late SaleCubit cubit;

    tearDown(() => cubit.close());

    test('loads demo products with Indonesian rupiah labels', () async {
      cubit = SaleCubit(const InMemorySaleRepository());

      await cubit.load();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.products, hasLength(8));
      expect(cubit.state.products.first.name, 'Kopi Susu Gula Aren');
      expect(cubit.state.products.first.priceLabel, 'Rp18.000');
    });

    test('filters products by query and category', () async {
      cubit = SaleCubit(const InMemorySaleRepository());
      await cubit.load();

      cubit.selectCategory(SaleCategoryFilter.coffee);
      cubit.updateQuery('latte');

      expect(cubit.state.products.map((product) => product.name), [
        'Café Latte',
      ]);
    });

    test('exposes category counts and filters popular products', () async {
      cubit = SaleCubit(const InMemorySaleRepository());
      await cubit.load();

      expect(cubit.state.categoryCounts[SaleCategoryFilter.all], 8);
      expect(cubit.state.categoryCounts[SaleCategoryFilter.coffee], 4);
      expect(cubit.state.categoryCounts[SaleCategoryFilter.nonCoffee], 2);
      expect(cubit.state.categoryCounts[SaleCategoryFilter.snack], 2);
      expect(() => cubit.state.categoryCounts.clear(), throwsUnsupportedError);

      cubit.setRecommendedOnly(true);

      expect(cubit.state.recommendedOnly, isTrue);
      expect(cubit.state.products.map((product) => product.name), [
        'Kopi Susu Gula Aren',
        'Matcha Latte',
      ]);
      expect(cubit.state.categoryCounts[SaleCategoryFilter.all], 8);
    });

    test(
      'keeps an immutable cart and recalculates quantities and totals',
      () async {
        cubit = SaleCubit(const InMemorySaleRepository());
        await cubit.load();

        cubit.addProduct('kopi-susu-gula-aren');
        cubit.addProduct('kopi-susu-gula-aren');
        cubit.addProduct('americano');

        expect(cubit.state.itemCount, 3);
        expect(cubit.state.totalInRupiah, 52000);
        expect(cubit.state.cartItems.first.quantity, 2);
        expect(() => cubit.state.cartItems.clear(), throwsUnsupportedError);

        cubit.updateQuantity('kopi-susu-gula-aren', 1);
        expect(cubit.state.totalInRupiah, 34000);

        cubit.removeProduct('americano');
        expect(cubit.state.itemCount, 1);
        expect(cubit.state.totalInRupiah, 18000);
      },
    );

    test('applies a per-item price and note to the sale line', () async {
      cubit = SaleCubit(const InMemorySaleRepository());
      await cubit.load();

      cubit.addProduct(
        'kopi-susu-gula-aren',
        quantity: 2,
        customPriceInRupiah: 20000,
        itemNote: ' Extra shot ',
      );

      expect(cubit.state.totalInRupiah, 40000);
      expect(cubit.state.cartItems.single.itemPriceInRupiah, 20000);
      expect(cubit.state.cartItems.single.itemNote, 'Extra shot');
    });

    test(
      'requires enough cash and creates a local receipt with change',
      () async {
        cubit = SaleCubit(const InMemorySaleRepository());
        await cubit.load();
        cubit.addProduct('kopi-susu-gula-aren');

        expect(cubit.completeSale(), isNull);

        cubit.setCashReceivedInput('50000');
        final receipt = cubit.completeSale();

        expect(receipt, isNotNull);
        expect(receipt!.totalLabel, 'Rp18.000');
        expect(receipt.itemCount, 1);
        expect(receipt.changeInRupiah, 32000);
        expect(receipt.items.single.name, 'Kopi Susu Gula Aren');
        expect(receipt.items.single.totalLabel, 'Rp18.000');
        expect(() => receipt.items.clear(), throwsUnsupportedError);
        expect(cubit.state.cartItems, isEmpty);
        expect(cubit.state.itemCount, 0);
        expect(cubit.state.totalInRupiah, 0);
        expect(cubit.state.receipt, same(receipt));
        expect(cubit.state.receipt!.items.single.name, 'Kopi Susu Gula Aren');
        expect(cubit.state.canCompleteSale, isFalse);

        cubit.startNewSale();
        expect(cubit.state.cartItems, isEmpty);
        expect(cubit.state.receipt, isNull);
      },
    );

    test('supports non-cash payment without requiring a cash amount', () async {
      cubit = SaleCubit(const InMemorySaleRepository());
      await cubit.load();
      cubit.addProduct('matcha-latte');
      cubit.setPaymentMethod(SalePaymentMethod.qris);

      expect(cubit.state.canCompleteSale, isTrue);
      expect(cubit.completeSale()?.paymentMethodLabel, 'QRIS');
    });

    test('exposes repository failures for the screen to render', () async {
      cubit = SaleCubit(const _FailingSaleRepository());

      await cubit.load();

      expect(cubit.state.errorMessage, 'Menu sedang tidak tersedia');
      expect(cubit.state.isLoading, isFalse);
    });
  });
}

final class _FailingSaleRepository implements SaleRepository {
  const _FailingSaleRepository();

  @override
  Future<List<SaleProduct>> getProducts() {
    throw const SaleRepositoryException('Menu sedang tidak tersedia');
  }
}
