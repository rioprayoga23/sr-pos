import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/sale/data/repositories/in_memory_sale_repository.dart';
import 'package:sr_pos/features/sale/presentation/screens/sale_screen.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_cubit.dart';

@Preview(name: 'Sale · Tablet', group: 'SR-POS Screens', size: Size(1280, 800))
Widget saleScreenPreview() {
  return const _SaleScreenPreview();
}

class _SaleScreenPreview extends StatefulWidget {
  const _SaleScreenPreview();

  @override
  State<_SaleScreenPreview> createState() => _SaleScreenPreviewState();
}

class _SaleScreenPreviewState extends State<_SaleScreenPreview> {
  late final SaleCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = SaleCubit(const InMemorySaleRepository());
    unawaited(_cubit.load());
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: SrTheme.light,
      home: SaleScreen(cubit: _cubit),
    );
  }
}
