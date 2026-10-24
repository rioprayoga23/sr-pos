import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/sale/data/repositories/in_memory_sale_repository.dart';
import 'package:sr_pos/features/sale/presentation/screens/sale_screen.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_cubit.dart';

void main() {
  group('SaleScreen', () {
    late SaleCubit cubit;

    setUp(() async {
      cubit = SaleCubit(const InMemorySaleRepository());
      await cubit.load();
    });

    tearDown(() => cubit.close());

    testWidgets('shows the tablet sale layout and local product catalog', (
      tester,
    ) async {
      await _pumpSaleScreen(tester, cubit);

      expect(find.text('Sale · Kasir'), findsNothing);
      expect(find.text('Kopi Yo'), findsOneWidget);
      expect(find.text('Kasir'), findsOneWidget);
      expect(find.text('Pesanan Aktif'), findsOneWidget);
      expect(find.text('Pelanggan'), findsNothing);
      expect(find.text('Pelanggan umum'), findsNothing);
      expect(find.text('Kopi Susu Gula Aren'), findsOneWidget);
      expect(find.text('Matcha Latte'), findsOneWidget);
      expect(find.text('Semua (8)'), findsOneWidget);
      expect(find.text('Rekomendasi'), findsWidgets);
      expect(find.text('Favorit'), findsNothing);
      expect(find.text('Pesanan masih kosong'), findsOneWidget);
      expect(find.text('Pilih menu untuk mulai'), findsOneWidget);
      final clearOrderButton = find.byWidgetPredicate(
        (widget) => widget is SrButton && widget.label == 'Hapus',
      );
      expect(clearOrderButton, findsOneWidget);
      expect(
        tester.widget<SrButton>(clearOrderButton).variant,
        SrButtonVariant.destructive,
      );

      final activeMenu = find.byWidgetPredicate(
        (widget) => widget is SrListItem && widget.title == 'Kasir',
      );
      final selectedSurface = tester.widget<Material>(
        find.descendant(of: activeMenu, matching: find.byType(Material)).first,
      );
      expect(selectedSurface.color, SrTheme.light.colorScheme.primary);
      expect(
        selectedSurface.shape,
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SrRadii.medium),
        ),
      );
      final sidebar = find.byKey(const ValueKey('sale-sidebar'));
      expect(
        tester.getTopLeft(activeMenu).dy - tester.getTopLeft(sidebar).dy,
        SrSpacing.space8,
      );
    });

    testWidgets('sidebar collapses to icons and can show labels again', (
      tester,
    ) async {
      await _pumpSaleScreen(tester, cubit);

      final sidebar = find.byKey(const ValueKey('sale-sidebar'));
      expect(
        tester.getSize(sidebar).width,
        lessThan(SrSizing.size96 * 2 + SrSizing.size48),
      );
      expect(find.text('Riwayat'), findsOneWidget);

      final collapseButton = find.byTooltip('Sembunyikan label menu');
      expect(collapseButton, findsOneWidget);
      final outletLabel = find.text('Outlet utama');
      expect(outletLabel, findsOneWidget);
      final header = find.byType(SrNavBar);
      final sidebarToggleTarget = find.ancestor(
        of: collapseButton,
        matching: find.byType(IconButton),
      );
      final sidebarToggleBounds = tester.getRect(sidebarToggleTarget);
      final outletLabelBounds = tester.getRect(outletLabel);
      final headerBounds = tester.getRect(header);
      final activeMenu = find.byWidgetPredicate(
        (widget) => widget is SrListItem && widget.title == 'Kasir',
      );
      final activeMenuBounds = tester.getRect(activeMenu);
      expect(
        find.ancestor(of: collapseButton, matching: header),
        findsOneWidget,
      );
      expect(sidebarToggleBounds.top, greaterThanOrEqualTo(headerBounds.top));
      expect(
        sidebarToggleBounds.bottom,
        lessThanOrEqualTo(headerBounds.bottom),
      );
      expect(
        sidebarToggleBounds.left,
        greaterThanOrEqualTo(outletLabelBounds.right),
      );
      expect(
        sidebarToggleBounds.right,
        closeTo(activeMenuBounds.right, SrSpacing.space2),
      );
      expect(sidebarToggleBounds.right, lessThan(headerBounds.center.dx));
      await tester.tap(collapseButton);
      await tester.pumpAndSettle();

      expect(tester.getSize(sidebar).width, SrSizing.size80);
      expect(find.text('Riwayat'), findsNothing);
      for (final icon in [
        Icons.point_of_sale_rounded,
        Icons.pending_actions_outlined,
        Icons.local_cafe_outlined,
        Icons.inventory_2_outlined,
        Icons.account_balance_wallet_outlined,
        Icons.receipt_long_outlined,
      ]) {
        expect(
          find.descendant(of: sidebar, matching: find.byIcon(icon)),
          findsOneWidget,
        );
      }
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SrListItem &&
              widget.title.isEmpty &&
              widget.semanticLabel == 'Kasir',
        ),
        findsOneWidget,
      );

      final expandButton = find.byTooltip('Tampilkan label menu');
      expect(expandButton, findsOneWidget);
      await tester.tap(expandButton);
      await tester.pumpAndSettle();

      expect(
        tester.getSize(sidebar).width,
        lessThan(SrSizing.size96 * 2 + SrSizing.size48),
      );
      expect(find.text('Riwayat'), findsOneWidget);
    });

    testWidgets('rounds the order panel wrapper like shared inputs', (
      tester,
    ) async {
      await _pumpSaleScreen(tester, cubit);

      final orderPanel = find.ancestor(
        of: find.text('Pesanan Aktif'),
        matching: find.byType(ClipRRect),
      );

      expect(orderPanel, findsOneWidget);
      expect(
        tester.widget<ClipRRect>(orderPanel).borderRadius,
        BorderRadius.circular(SrRadii.medium),
      );
    });

    testWidgets('filters by the recommendation chip', (tester) async {
      await _pumpSaleScreen(tester, cubit);

      await tester.tap(
        find.byWidgetPredicate(
          (widget) => widget is SrFilter && widget.label == 'Rekomendasi',
        ),
      );
      await tester.pump();

      expect(cubit.state.recommendedOnly, isTrue);
      expect(find.text('Kopi Susu Gula Aren'), findsOneWidget);
      expect(find.text('Matcha Latte'), findsOneWidget);
      expect(find.text('Americano'), findsNothing);
    });

    testWidgets('product media fills its card and uses recommendation tag', (
      tester,
    ) async {
      await _pumpSaleScreen(tester, cubit);

      final card = find.byKey(const ValueKey('kopi-susu-gula-aren'));
      final media = find.descendant(of: card, matching: find.byType(Stack));

      expect(card, findsOneWidget);
      expect(media, findsOneWidget);
      expect(tester.getSize(media).height, tester.getSize(card).height);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SrTag && widget.label == 'Rekomendasi',
        ),
        findsWidgets,
      );
      expect(find.text('Favorit'), findsNothing);
    });

    testWidgets('uses shorter cards when the product grid has three columns', (
      tester,
    ) async {
      await _pumpSaleScreen(tester, cubit, size: const Size(1280, 800));

      final firstCard = find.byKey(const ValueKey('kopi-susu-gula-aren'));
      final thirdCard = find.byKey(const ValueKey('cappuccino'));
      final fourthCard = find.byKey(const ValueKey('cafe-latte'));

      expect(tester.getSize(firstCard).height, 168);
      expect(tester.getTopLeft(thirdCard).dy, tester.getTopLeft(firstCard).dy);
      expect(
        tester.getTopLeft(fourthCard).dy,
        greaterThan(tester.getTopLeft(firstCard).dy),
      );
    });

    testWidgets('keeps the default card height outside three-column grids', (
      tester,
    ) async {
      await _pumpSaleScreen(tester, cubit, size: const Size(1500, 800));

      final firstCard = find.byKey(const ValueKey('kopi-susu-gula-aren'));
      final fifthCard = find.byKey(const ValueKey('matcha-latte'));
      final fourthCard = find.byKey(const ValueKey('cafe-latte'));

      expect(tester.getSize(firstCard).height, 196);
      expect(tester.getTopLeft(fourthCard).dy, tester.getTopLeft(firstCard).dy);
      expect(
        tester.getTopLeft(fifthCard).dy,
        greaterThan(tester.getTopLeft(firstCard).dy),
      );
    });

    testWidgets('aligns catalog filters and count with product grid edges', (
      tester,
    ) async {
      await _pumpSaleScreen(tester, cubit, size: const Size(1280, 800));

      final firstCard = tester.getRect(
        find.byKey(const ValueKey('kopi-susu-gula-aren')),
      );
      final lastCard = tester.getRect(find.byKey(const ValueKey('cappuccino')));
      final categoryFilter = tester.getRect(
        find.byWidgetPredicate(
          (widget) => widget is SrFilter && widget.label == 'Semua (8)',
        ),
      );
      final searchField = tester.getRect(find.byType(SrTextField).first);
      final recommendationFilter = tester.getRect(
        find.byWidgetPredicate(
          (widget) => widget is SrFilter && widget.label == 'Rekomendasi',
        ),
      );
      final menuCount = tester.getRect(
        find.text('8 menu · ketuk untuk menambahkan'),
      );

      expect(categoryFilter.left, firstCard.left);
      expect(searchField.left, firstCard.left);
      expect(recommendationFilter.right, closeTo(lastCard.right, 0.001));
      expect(menuCount.left, firstCard.left);
    });

    testWidgets('cart rows have compact breathing room around dividers', (
      tester,
    ) async {
      cubit.addProduct('kopi-susu-gula-aren');
      cubit.addProduct('americano');
      await _pumpSaleScreen(tester, cubit);

      final firstRow = find.byType(SrShoppingCartItem).at(0);
      final secondRow = find.byType(SrShoppingCartItem).at(1);
      final gap =
          tester.getTopLeft(secondRow).dy - tester.getBottomLeft(firstRow).dy;

      expect(gap, greaterThanOrEqualTo(SrSpacing.space8));
    });

    testWidgets(
      'scroll action appears for overflow and scrolls to the bottom',
      (tester) async {
        for (final productId in [
          'kopi-susu-gula-aren',
          'americano',
          'cappuccino',
          'cafe-latte',
          'matcha-latte',
          'lemon-tea',
          'roti-bakar',
          'croissant',
        ]) {
          cubit.addProduct(productId);
        }
        await _pumpSaleScreen(tester, cubit);
        await tester.pumpAndSettle();

        final scrollAction = find.byTooltip('Gulir ke sisa pesanan');
        expect(scrollAction, findsOneWidget);
        final scrollButton = find.ancestor(
          of: scrollAction,
          matching: find.byType(IconButton),
        );
        final iconButton = tester.widget<IconButton>(scrollButton);
        final colors = Theme.of(tester.element(scrollAction)).colorScheme;
        expect(
          iconButton.style!.foregroundColor!.resolve(const <WidgetState>{}),
          colors.primary,
        );
        expect(
          tester.getSize(scrollButton),
          const Size.square(SrSizing.minimumTouchTarget),
        );
        final scrollSurface = find.descendant(
          of: scrollButton,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is SizedBox &&
                widget.width == SrSizing.size32 &&
                widget.height == SrSizing.size32,
          ),
        );
        expect(
          tester.getSize(scrollSurface),
          const Size.square(SrSizing.size32),
        );
        expect(
          tester.getBottomLeft(scrollButton).dy,
          lessThan(tester.getBottomLeft(find.byType(ListView).last).dy),
        );

        await tester.tap(scrollButton);
        await tester.pumpAndSettle();

        expect(find.byTooltip('Gulir ke sisa pesanan'), findsNothing);
        final lastCartItem = find.byType(SrShoppingCartItem).last;
        expect(
          find.descendant(
            of: lastCartItem,
            matching: find.text('Croissant Butter'),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);

        await tester.drag(find.byType(ListView).last, const Offset(0, 240));
        await tester.pumpAndSettle();

        expect(find.byTooltip('Gulir ke sisa pesanan'), findsOneWidget);
      },
    );

    testWidgets('scroll action stays hidden when the order fits', (
      tester,
    ) async {
      cubit.addProduct('kopi-susu-gula-aren');
      await _pumpSaleScreen(tester, cubit);

      expect(find.byTooltip('Gulir ke sisa pesanan'), findsNothing);
    });

    testWidgets('scroll action respects the reduced-motion preference', (
      tester,
    ) async {
      for (final productId in [
        'kopi-susu-gula-aren',
        'americano',
        'cappuccino',
        'cafe-latte',
        'matcha-latte',
        'lemon-tea',
        'roti-bakar',
        'croissant',
      ]) {
        cubit.addProduct(productId);
      }
      await _pumpSaleScreen(tester, cubit, disableAnimations: true);
      await tester.pumpAndSettle();

      final scrollButton = find.ancestor(
        of: find.byTooltip('Gulir ke sisa pesanan'),
        matching: find.byType(IconButton),
      );
      expect(scrollButton, findsOneWidget);

      await tester.tap(scrollButton);
      await tester.pumpAndSettle();

      expect(find.byTooltip('Gulir ke sisa pesanan'), findsNothing);
    });

    testWidgets('omits subtotal and separates the payment inputs', (
      tester,
    ) async {
      cubit.addProduct('kopi-susu-gula-aren');
      await _pumpSaleScreen(tester, cubit);

      expect(find.text('Subtotal'), findsNothing);

      final paymentMethodInput = find.byWidgetPredicate(
        (widget) =>
            widget is InputDecorator &&
            widget.decoration.labelText == 'Metode pembayaran',
      );
      final cashReceivedInput = find.byWidgetPredicate(
        (widget) =>
            widget is InputDecorator &&
            widget.decoration.labelText == 'Uang diterima',
      );

      expect(paymentMethodInput, findsOneWidget);
      expect(cashReceivedInput, findsOneWidget);
      final inputGap =
          tester.getTopLeft(cashReceivedInput).dy -
          tester.getBottomLeft(paymentMethodInput).dy;
      expect(inputGap, SrSpacing.space12);

      final total = find.text('Total');
      final change = find.text('Kembalian');
      final changeAmount = find.text(
        SaleCubit.formatRupiah(cubit.state.changeInRupiah),
      );
      final checkout = find.byType(SrButton).last;
      expect(
        tester.getTopLeft(total).dy,
        greaterThan(tester.getBottomLeft(cashReceivedInput).dy),
      );
      expect(
        tester.getTopLeft(change).dy,
        greaterThan(tester.getBottomLeft(total).dy),
      );
      expect(
        tester.getBottomLeft(change).dy,
        lessThanOrEqualTo(tester.getTopLeft(checkout).dy),
      );
      final changeLabelStyle = tester.widget<Text>(change).style!;
      final changeAmountStyle = tester.widget<Text>(changeAmount).style!;
      expect(changeLabelStyle.fontSize, changeAmountStyle.fontSize);
      expect(changeLabelStyle.fontWeight, changeAmountStyle.fontWeight);
    });

    testWidgets('formats received cash while typing and keeps numeric state', (
      tester,
    ) async {
      cubit.addProduct('kopi-susu-gula-aren');
      await _pumpSaleScreen(tester, cubit);

      final cashDecorator = find.byWidgetPredicate(
        (widget) =>
            widget is InputDecorator &&
            widget.decoration.labelText == 'Uang diterima',
      );
      final cashInput = find.ancestor(
        of: cashDecorator,
        matching: find.byType(TextFormField),
      );
      expect(cashInput, findsOneWidget);
      await tester.enterText(cashInput, '50000');
      await tester.pump();

      final field = tester.widget<TextFormField>(cashInput);
      expect(field.controller!.text, '50.000');
      expect(field.controller!.selection.extentOffset, 6);
      expect(cubit.state.cashReceivedInput, '50000');
      expect(cubit.state.canCompleteSale, isTrue);
    });

    testWidgets('adds a product, accepts cash, and starts a new sale', (
      tester,
    ) async {
      await _pumpSaleScreen(tester, cubit);

      await tester.tap(find.text('Kopi Susu Gula Aren'));
      await tester.pump();

      expect(find.text('Atur menu'), findsNothing);
      expect(cubit.state.itemCount, 1);
      expect(cubit.state.totalInRupiah, 18000);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SrBadge && widget.label == '1',
        ),
        findsOneWidget,
      );
      expect(
        tester.getSize(find.byType(SrShoppingCartItem).first).height,
        lessThan(88),
      );

      await tester.tap(find.byTooltip('Increase quantity'));
      await tester.pump();

      expect(cubit.state.itemCount, 2);
      expect(cubit.state.totalInRupiah, 36000);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SrBadge && widget.label == '2',
        ),
        findsOneWidget,
      );
      expect(find.text('Rp36.000'), findsWidgets);

      await tester.tap(find.text('Pas'));
      await tester.pump();
      expect(cubit.state.cashReceivedInRupiah, 36000);
      expect(cubit.state.canCompleteSale, isTrue);

      await tester.tap(find.text('Bayar · Rp36.000'));
      await tester.pumpAndSettle();

      expect(find.text('Pembayaran berhasil'), findsOneWidget);
      expect(cubit.state.cartItems, isEmpty);
      expect(cubit.state.itemCount, 0);
      expect(cubit.state.receipt?.items.single.quantity, 2);
      expect(find.text('Pesanan masih kosong'), findsOneWidget);
      expect(find.byTooltip('Tutup dialog'), findsOneWidget);
      final successDialog = find.byType(SrDialog);
      expect(
        tester
            .widget<Icon>(
              find.descendant(
                of: successDialog,
                matching: find.byIcon(Icons.check_rounded),
              ),
            )
            .size,
        32,
      );
      expect(
        find.descendant(
          of: successDialog,
          matching: find.text('Metode pembayaran'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(of: successDialog, matching: find.text('2 × Rp18.000')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: successDialog, matching: find.text('Total')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: successDialog, matching: find.text('Rp36.000')),
        findsNWidgets(2),
      );
      final printButton = find.ancestor(
        of: find.byIcon(Icons.print_outlined),
        matching: find.byType(IconButton),
      );
      expect(
        find.descendant(of: successDialog, matching: printButton),
        findsOneWidget,
      );
      expect(find.byTooltip('Cetak struk'), findsOneWidget);
      expect(tester.getSize(printButton), const Size.square(48));
      expect(
        tester.getRect(printButton).center,
        tester.getRect(find.byIcon(Icons.print_outlined)).center,
      );
      final successDialogSurface = find.descendant(
        of: successDialog,
        matching: find.byWidgetPredicate(
          (widget) => widget is Material && widget.type == MaterialType.card,
        ),
      );
      expect(tester.getSize(successDialogSurface).width, SrSizing.size80 * 7);

      await tester.tap(find.text('Transaksi baru'));
      await tester.pumpAndSettle();

      expect(cubit.state.cartItems, isEmpty);
      expect(find.text('Pesanan masih kosong'), findsOneWidget);
    });

    testWidgets(
      'print action explains that receipt printing is not connected',
      (tester) async {
        cubit.addProduct('kopi-susu-gula-aren');
        cubit.setCashReceivedAmount(50000);
        await _pumpSaleScreen(tester, cubit);

        await tester.tap(find.text('Bayar · Rp18.000'));
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Cetak struk'));
        await tester.pumpAndSettle();

        expect(find.byType(SrDialog), findsNothing);
        expect(
          find.text('Integrasi cetak struk belum tersedia.'),
          findsOneWidget,
        );
      },
    );

    testWidgets('success dialog closes through its core close button', (
      tester,
    ) async {
      cubit.addProduct('kopi-susu-gula-aren');
      cubit.setCashReceivedAmount(50000);
      await _pumpSaleScreen(tester, cubit);

      await tester.tap(find.text('Bayar · Rp18.000'));
      await tester.pumpAndSettle();
      expect(find.byType(SrDialog), findsOneWidget);

      await tester.tap(find.byTooltip('Tutup dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(SrDialog), findsNothing);
    });

    testWidgets('keeps a full receipt list scrollable inside the core dialog', (
      tester,
    ) async {
      for (final product in cubit.state.products) {
        cubit.addProduct(product.id);
      }
      cubit.setCashReceivedAmount(200000);
      await _pumpSaleScreen(tester, cubit, size: const Size(1280, 800));

      await tester.tap(find.text('Bayar · Rp156.000'));
      await tester.pumpAndSettle();

      final dialog = find.byType(SrDialog);
      final receiptList = find.descendant(
        of: dialog,
        matching: find.byType(SingleChildScrollView),
      );
      expect(dialog, findsOneWidget);
      expect(receiptList, findsOneWidget);
      expect(tester.getSize(receiptList).height, lessThanOrEqualTo(320));
      expect(
        find.descendant(of: dialog, matching: find.text('Croissant Butter')),
        findsOneWidget,
      );
    });

    testWidgets('aligns item price to the right of its product name', (
      tester,
    ) async {
      cubit.addProduct('cappuccino');
      await _pumpSaleScreen(tester, cubit);

      final cartItem = find.byType(SrShoppingCartItem).first;
      final productName = find.descendant(
        of: cartItem,
        matching: find.text('Cappuccino'),
      );
      final unitPrice = find.descendant(
        of: cartItem,
        matching: find.text('Rp22.000 / item'),
      );

      expect(productName, findsOneWidget);
      expect(unitPrice, findsOneWidget);
      expect(
        tester.getTopLeft(unitPrice).dx - tester.getTopRight(productName).dx,
        greaterThanOrEqualTo(SrSpacing.space8),
      );
      expect(
        tester.getTopRight(unitPrice).dx,
        closeTo(tester.getTopRight(cartItem).dx, 1),
      );
    });

    testWidgets('search narrows visible products', (tester) async {
      await _pumpSaleScreen(tester, cubit);

      await tester.enterText(find.byType(TextField).first, 'Matcha');
      await tester.pump();

      expect(find.text('Matcha Latte'), findsOneWidget);
      expect(find.text('Kopi Susu Gula Aren'), findsNothing);
    });

    testWidgets('menu search uses the outlined shared text field', (
      tester,
    ) async {
      await _pumpSaleScreen(tester, cubit);

      final searchField = find.byWidgetPredicate(
        (widget) => widget is SrTextField && widget.hintText == 'Cari menu',
      );
      expect(searchField, findsOneWidget);
      expect(tester.widget<SrTextField>(searchField).prefixIcon, isA<SrIcon>());

      final decorator = find.byWidgetPredicate(
        (widget) =>
            widget is InputDecorator &&
            widget.decoration.hintText == 'Cari menu',
      );
      expect(decorator, findsOneWidget);
      final decoration = tester.widget<InputDecorator>(decorator).decoration;
      expect(decoration.enabledBorder, isA<OutlineInputBorder>());
      expect(
        (decoration.enabledBorder! as OutlineInputBorder).borderSide.style,
        BorderStyle.solid,
      );
    });

    testWidgets('fits a portrait tablet viewport', (tester) async {
      cubit.addProduct('kopi-susu-gula-aren');
      await _pumpSaleScreen(tester, cubit, size: const Size(800, 1280));

      expect(find.text('Pesanan Aktif'), findsOneWidget);
      expect(find.byType(SrShoppingCartItem), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

Future<void> _pumpSaleScreen(
  WidgetTester tester,
  SaleCubit cubit, {
  Size size = const Size(1280, 800),
  bool disableAnimations = false,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: SrTheme.light,
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(disableAnimations: disableAnimations),
          child: SaleScreen(cubit: cubit),
        ),
      ),
    ),
  );
  await tester.pump();
}
