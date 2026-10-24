import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/product_search/data/repositories/in_memory_product_repository.dart';
import 'package:sr_pos/features/product_search/domain/repositories/product_repository.dart';
import 'package:sr_pos/features/product_search/presentation/screens/product_search_screen.dart';
import 'package:sr_pos/features/product_search/presentation/view_models/product_search_view_model.dart';

class SrPosApp extends StatefulWidget {
  const SrPosApp({
    this.productRepository = const InMemoryProductRepository(),
    super.key,
  });

  final ProductRepository productRepository;

  @override
  State<SrPosApp> createState() => _SrPosAppState();
}

class _SrPosAppState extends State<SrPosApp> {
  late final ProductSearchViewModel _productSearchViewModel;

  @override
  void initState() {
    super.initState();
    _productSearchViewModel = ProductSearchViewModel(widget.productRepository);
    unawaited(_productSearchViewModel.load());
  }

  @override
  void dispose() {
    _productSearchViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SR-POS',
      debugShowCheckedModeBanner: false,
      theme: SrTheme.light,
      home: ProductSearchScreen(viewModel: _productSearchViewModel),
    );
  }
}
