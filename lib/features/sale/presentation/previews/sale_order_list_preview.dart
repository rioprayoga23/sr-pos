import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/sale/domain/models/sale_product.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_ui_state.dart';
import 'package:sr_pos/features/sale/presentation/widgets/sale_order_list.dart';

@Preview(
  name: 'Sale order overflow',
  group: 'SR-POS Screens',
  size: Size(480, 480),
)
Widget saleOrderListOverflowPreview() {
  return MaterialApp(
    theme: SrTheme.light,
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SrSpacing.space16),
          child: SaleOrderList(
            items: const [
              SaleCartLineViewData(
                productId: 'americano',
                name: 'Americano',
                category: SaleProductCategory.coffee,
                quantity: 1,
                itemPriceInRupiah: 16000,
                itemPriceLabel: 'Rp16.000 / item',
                itemNote: '',
                totalInRupiah: 16000,
                totalLabel: 'Rp16.000',
              ),
              SaleCartLineViewData(
                productId: 'lemon-tea',
                name: 'Teh Lemon',
                category: SaleProductCategory.nonCoffee,
                quantity: 1,
                itemPriceInRupiah: 14000,
                itemPriceLabel: 'Rp14.000 / item',
                itemNote: '',
                totalInRupiah: 14000,
                totalLabel: 'Rp14.000',
              ),
              SaleCartLineViewData(
                productId: 'matcha-latte',
                name: 'Matcha Latte',
                category: SaleProductCategory.nonCoffee,
                quantity: 1,
                itemPriceInRupiah: 25000,
                itemPriceLabel: 'Rp25.000 / item',
                itemNote: '',
                totalInRupiah: 25000,
                totalLabel: 'Rp25.000',
              ),
              SaleCartLineViewData(
                productId: 'croissant',
                name: 'Croissant Butter',
                category: SaleProductCategory.snack,
                quantity: 1,
                itemPriceInRupiah: 17000,
                itemPriceLabel: 'Rp17.000 / item',
                itemNote: '',
                totalInRupiah: 17000,
                totalLabel: 'Rp17.000',
              ),
              SaleCartLineViewData(
                productId: 'roti-bakar',
                name: 'Roti Bakar Cokelat',
                category: SaleProductCategory.snack,
                quantity: 1,
                itemPriceInRupiah: 20000,
                itemPriceLabel: 'Rp20.000 / item',
                itemNote: '',
                totalInRupiah: 20000,
                totalLabel: 'Rp20.000',
              ),
              SaleCartLineViewData(
                productId: 'kopi-susu-gula-aren',
                name: 'Kopi Susu Gula Aren',
                category: SaleProductCategory.coffee,
                quantity: 1,
                itemPriceInRupiah: 18000,
                itemPriceLabel: 'Rp18.000 / item',
                itemNote: '',
                totalInRupiah: 18000,
                totalLabel: 'Rp18.000',
              ),
              SaleCartLineViewData(
                productId: 'cappuccino',
                name: 'Cappuccino',
                category: SaleProductCategory.coffee,
                quantity: 1,
                itemPriceInRupiah: 22000,
                itemPriceLabel: 'Rp22.000 / item',
                itemNote: '',
                totalInRupiah: 22000,
                totalLabel: 'Rp22.000',
              ),
              SaleCartLineViewData(
                productId: 'cafe-latte',
                name: 'Café Latte',
                category: SaleProductCategory.coffee,
                quantity: 1,
                itemPriceInRupiah: 24000,
                itemPriceLabel: 'Rp24.000 / item',
                itemNote: '',
                totalInRupiah: 24000,
                totalLabel: 'Rp24.000',
              ),
            ],
            onQuantityChanged: (_, _) {},
            onRemove: (_) {},
          ),
        ),
      ),
    ),
  );
}
