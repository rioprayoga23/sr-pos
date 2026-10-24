import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/design_system.dart';

import '../../../../helpers/pump_sr_widget.dart';

void main() {
  testWidgets('small cart item keeps text and actions in a compact rhythm', (
    tester,
  ) async {
    await pumpSrWidget(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 390,
            child: SrShoppingCartItem(
              size: SrComponentSize.small,
              item: const SrShoppingCartItemData(
                title: 'Kopi Susu Gula Aren Extra Shot',
                subtitle: 'Rp18.000 / item',
                priceLabel: 'Rp36.000',
                quantity: 2,
              ),
              onQuantityChanged: (_) {},
              onRemove: () {},
            ),
          ),
        ],
      ),
    );

    final cartItem = find.byType(SrShoppingCartItem);
    final cartRow = find
        .descendant(of: cartItem, matching: find.byType(Row))
        .first;
    final cartMedia = find.descendant(
      of: cartItem,
      matching: find.byType(ClipRRect),
    );
    expect(tester.getSize(cartMedia), const Size.square(SrSizing.size64));
    expect(
      tester.getBottomLeft(cartRow).dy - tester.getBottomLeft(cartMedia).dy,
      lessThanOrEqualTo(SrSpacing.space8),
    );
    expect(tester.getSize(cartItem).height, lessThan(88));
    expect(
      tester.getTopLeft(cartRow).dy - tester.getTopLeft(cartItem).dy,
      SrSpacing.space4,
    );
    expect(
      tester.getBottomLeft(cartItem).dy - tester.getBottomLeft(cartRow).dy,
      SrSpacing.none,
    );
    expect(
      tester.widget<Text>(find.text('Kopi Susu Gula Aren Extra Shot')).maxLines,
      1,
    );
    final subtitle = find.text('Rp18.000 / item');
    expect(
      tester.getTopRight(subtitle).dx,
      closeTo(tester.getTopRight(cartItem).dx, 1),
    );
    expect(
      tester.getTopRight(find.text('Kopi Susu Gula Aren Extra Shot')).dx,
      lessThan(tester.getTopLeft(subtitle).dx),
    );
    expect(
      (tester
                  .getCenter(
                    find.byTooltip('Remove Kopi Susu Gula Aren Extra Shot'),
                  )
                  .dy -
              tester.getCenter(find.byTooltip('Increase quantity')).dy)
          .abs(),
      lessThan(1),
    );
    final quantityButtonFinder = find.ancestor(
      of: find.byTooltip('Increase quantity'),
      matching: find.byType(IconButton),
    );
    final quantityButton = tester.widget<IconButton>(quantityButtonFinder);
    final colors = Theme.of(tester.element(cartItem)).colorScheme;
    expect(
      quantityButton.style!.foregroundColor!.resolve(const <WidgetState>{}),
      colors.primary,
    );
    expect(
      quantityButton.style!.shape!.resolve(const <WidgetState>{}),
      isA<CircleBorder>(),
    );
    expect(
      tester.getSize(quantityButtonFinder).width,
      SrSizing.minimumTouchTarget,
    );
    final quantitySurface = find.descendant(
      of: quantityButtonFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.width == SrSizing.size32 &&
            widget.height == SrSizing.size32,
      ),
    );
    expect(tester.getSize(quantitySurface), const Size.square(SrSizing.size32));
    final surfaceDecoration = tester.widget<DecoratedBox>(
      find.descendant(of: quantitySurface, matching: find.byType(DecoratedBox)),
    );
    expect(
      (surfaceDecoration.decoration as BoxDecoration).color,
      colors.primaryContainer,
    );
    expect(
      (surfaceDecoration.decoration as BoxDecoration).shape,
      BoxShape.circle,
    );
    expect(
      tester.widget<Text>(find.text('2')).style!.fontSize,
      SrTypography.bodyExtraLarge.fontSize,
    );
    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
    final removeButton = find.ancestor(
      of: find.byTooltip('Remove Kopi Susu Gula Aren Extra Shot'),
      matching: find.byType(IconButton),
    );
    expect(
      tester.widget<IconButton>(removeButton).color,
      Theme.of(tester.element(cartItem)).colorScheme.error,
    );
  });

  testWidgets('shopping cart item exposes quantity and remove actions', (
    tester,
  ) async {
    int? quantity;
    var removed = false;

    await pumpSrWidget(
      tester,
      SrShoppingCartItem(
        size: SrComponentSize.small,
        item: const SrShoppingCartItemData(
          title: 'Amazing Shoes',
          subtitle: 'Blue, 42',
          priceLabel: '€ 12.00',
          quantity: 2,
        ),
        metadata: const Text('In stock'),
        onQuantityChanged: (value) => quantity = value,
        onRemove: () => removed = true,
      ),
    );

    expect(tester.getSize(find.byType(ClipRRect)).width, SrSizing.size64);

    await tester.tap(find.byTooltip('Increase quantity'));
    expect(quantity, 3);

    await tester.tap(find.byTooltip('Decrease quantity'));
    expect(quantity, 1);

    await tester.tap(find.byTooltip('Remove Amazing Shoes'));
    expect(removed, isTrue);
  });
}
