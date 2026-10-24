import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/product_search/data/repositories/in_memory_product_repository.dart';
import 'package:sr_pos/features/product_search/presentation/screens/product_search_screen.dart';
import 'package:sr_pos/features/product_search/presentation/view_models/product_search_view_model.dart';

@Preview(
  name: 'Product Search Screen',
  group: 'SR-POS Screens',
  size: Size(375, 812),
)
Widget productSearchScreenPreview() {
  return const _ProductSearchScreenPreview();
}

class _ProductSearchScreenPreview extends StatefulWidget {
  const _ProductSearchScreenPreview();

  @override
  State<_ProductSearchScreenPreview> createState() =>
      _ProductSearchScreenPreviewState();
}

class _ProductSearchScreenPreviewState
    extends State<_ProductSearchScreenPreview> {
  late final ProductSearchViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProductSearchViewModel(const InMemoryProductRepository());
    unawaited(_viewModel.load());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: SrTheme.light,
      home: ProductSearchScreen(viewModel: _viewModel),
    );
  }
}
