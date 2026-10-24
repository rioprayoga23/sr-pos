import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:sr_pos/core/design_system/components/device/device.dart';
import 'package:sr_pos/core/design_system/components/e_commerce/e_commerce.dart';
import 'package:sr_pos/core/design_system/components/map/map.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/previews/sr_preview_wrapper.dart';

@Preview(
  name: 'Map, Commerce, and Device',
  group: 'SR-POS Design System',
  size: Size(390, 1200),
  wrapper: srDesignSystemPreviewWrapper,
)
Widget srMapCommerceDevicePreview() {
  return const _MapCommerceDevicePreview();
}

class _MapCommerceDevicePreview extends StatefulWidget {
  const _MapCommerceDevicePreview();

  @override
  State<_MapCommerceDevicePreview> createState() =>
      _MapCommerceDevicePreviewState();
}

class _MapCommerceDevicePreviewState extends State<_MapCommerceDevicePreview> {
  var _quantity = 2;

  @override
  Widget build(BuildContext context) {
    return SrPreviewPage(
      children: [
        SrPreviewSection(
          title: 'Map and Location Pin',
          child: Column(
            children: [
              SrMapPlaceholder(
                controls: const Icon(Icons.add_rounded),
                markers: [
                  SrMapMarker(
                    position: Alignment.center,
                    child: SrLocationPin(
                      label: 'Store',
                      selected: true,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SrSpacing.space12),
              SizedBox(
                height: 96,
                child: SrMap(
                  child: const ColoredBox(
                    color: SrColors.highlight100,
                    child: Center(child: Text('Provider map content')),
                  ),
                ),
              ),
            ],
          ),
        ),
        SrPreviewSection(
          title: 'Shopping Cart Item',
          child: SrShoppingCartItem(
            item: SrShoppingCartItemData(
              title: 'Amazing Shoes',
              subtitle: 'Blue, 42',
              priceLabel: '€ 12.00',
              quantity: _quantity,
            ),
            size: SrComponentSize.small,
            metadata: const Text('In stock'),
            onQuantityChanged: (value) => setState(() => _quantity = value),
            onRemove: () {},
          ),
        ),
        SrPreviewSection(
          title: 'Overlay',
          child: SizedBox(
            height: 140,
            child: SrOverlay(
              visible: true,
              overlayContent: const Card(
                child: Padding(
                  padding: EdgeInsets.all(SrSpacing.space12),
                  child: Text('Overlay content'),
                ),
              ),
              child: const ColoredBox(
                color: SrColors.neutralLight300,
                child: Center(child: Text('Page content')),
              ),
            ),
          ),
        ),
        const SrPreviewSection(
          title: 'Device Components',
          child: Center(
            child: SrDeviceFrame(
              width: 180,
              child: ColoredBox(
                color: SrColors.neutralLight300,
                child: Center(child: Text('SR-POS')),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
