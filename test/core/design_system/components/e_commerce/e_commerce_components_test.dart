import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/e_commerce/e_commerce.dart';

import '../../../../helpers/pump_sr_widget.dart';

void main() {
  testWidgets('shopping cart item exposes quantity and remove actions', (
    tester,
  ) async {
    int? quantity;
    var removed = false;

    await pumpSrWidget(
      tester,
      SrShoppingCartItem(
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

    await tester.tap(find.byTooltip('Increase quantity'));
    expect(quantity, 3);

    await tester.tap(find.byTooltip('Decrease quantity'));
    expect(quantity, 1);

    await tester.tap(find.byTooltip('Remove Amazing Shoes'));
    expect(removed, isTrue);
  });
}
