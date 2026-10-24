import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/sale/data/repositories/in_memory_sale_repository.dart';
import 'package:sr_pos/features/sale/domain/repositories/sale_repository.dart';
import 'package:sr_pos/features/sale/presentation/screens/sale_screen.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_cubit.dart';

class SrPosApp extends StatefulWidget {
  const SrPosApp({
    this.saleRepository = const InMemorySaleRepository(),
    super.key,
  });

  final SaleRepository saleRepository;

  @override
  State<SrPosApp> createState() => _SrPosAppState();
}

class _SrPosAppState extends State<SrPosApp> {
  late final SaleCubit _saleCubit;

  @override
  void initState() {
    super.initState();
    _saleCubit = SaleCubit(widget.saleRepository);
    unawaited(_saleCubit.load());
  }

  @override
  void dispose() {
    unawaited(_saleCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SR-POS',
      debugShowCheckedModeBanner: false,
      theme: SrTheme.light,
      home: SaleScreen(cubit: _saleCubit),
    );
  }
}
