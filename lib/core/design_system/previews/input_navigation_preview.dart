import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:sr_pos/core/design_system/components/input/input.dart';
import 'package:sr_pos/core/design_system/components/navigation/navigation.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/previews/sr_preview_wrapper.dart';

@Preview(
  name: 'Input and Navigation',
  group: 'SR-POS Design System',
  size: Size(390, 1400),
  wrapper: srDesignSystemPreviewWrapper,
)
Widget srInputNavigationPreview() {
  return const _InputNavigationPreview();
}

class _InputNavigationPreview extends StatefulWidget {
  const _InputNavigationPreview();

  @override
  State<_InputNavigationPreview> createState() =>
      _InputNavigationPreviewState();
}

class _InputNavigationPreviewState extends State<_InputNavigationPreview> {
  final _searchController = TextEditingController(text: 'Shoes');
  var _checked = true;
  var _radio = 'cash';
  var _toggle = true;
  var _rating = 4.0;
  var _slider = 0.35;
  var _quantity = 2;
  String? _payment = 'cash';
  var _tabIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SrPreviewPage(
      children: [
        SrPreviewSection(
          title: 'Selection',
          child: Column(
            children: [
              SrCheckbox(
                value: _checked,
                label: 'Remember selection',
                onChanged: (value) => setState(() => _checked = value),
              ),
              SrRadio<String>(
                value: 'cash',
                groupValue: _radio,
                label: 'Cash',
                onChanged: (value) => setState(() => _radio = value),
              ),
              SrToggle(
                value: _toggle,
                label: 'Notifications',
                onChanged: (value) => setState(() => _toggle = value),
              ),
              SrStarRating(
                value: _rating,
                onChanged: (value) => setState(() => _rating = value),
              ),
            ],
          ),
        ),
        SrPreviewSection(
          title: 'Value Controls',
          child: Column(
            children: [
              SrSlider(
                value: _slider,
                onChanged: (value) => setState(() => _slider = value),
              ),
              const SizedBox(height: SrSpacing.space8),
              SrNumberInput(
                value: _quantity,
                min: 1,
                max: 9,
                label: 'Quantity',
                onChanged: (value) => setState(() => _quantity = value),
              ),
            ],
          ),
        ),
        SrPreviewSection(
          title: 'Text Inputs',
          child: Column(
            children: [
              SrTextField(labelText: 'Product name', hintText: 'Enter a name'),
              const SizedBox(height: SrSpacing.space12),
              SrTextArea(labelText: 'Description', hintText: 'Add details'),
              const SizedBox(height: SrSpacing.space12),
              SrDropdown<String>(
                labelText: 'Payment method',
                value: _payment,
                items: const [
                  SrDropdownItem(value: 'cash', label: 'Cash'),
                  SrDropdownItem(value: 'card', label: 'Card'),
                ],
                onChanged: (value) => setState(() => _payment = value),
              ),
              const SizedBox(height: SrSpacing.space12),
              const SrSearchBar(placeholder: 'Search products'),
              const SizedBox(height: SrSpacing.space12),
              SrSearchBar(
                controller: _searchController,
                placeholder: 'Search products',
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
        SrPreviewSection(
          title: 'Navigation',
          child: Column(
            children: [
              SizedBox(
                height: kToolbarHeight,
                child: SrNavBar(
                  title: 'Products',
                  onBack: () {},
                  actions: [
                    SrNavBarAction(
                      icon: const Icon(Icons.add_rounded),
                      tooltip: 'Add product',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SrSpacing.space12),
              SrTabBar(
                currentIndex: _tabIndex,
                onChanged: (value) => setState(() => _tabIndex = value),
                items: const [
                  SrTabBarItem(label: 'Home', icon: Icon(Icons.home_outlined)),
                  SrTabBarItem(
                    label: 'Orders',
                    icon: Icon(Icons.receipt_long_outlined),
                  ),
                  SrTabBarItem(
                    label: 'Profile',
                    icon: Icon(Icons.person_outline_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
