import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/sale/data/repositories/in_memory_sale_repository.dart';
import 'package:sr_pos/features/sale/data/services/image_picker_catalog_ingredient_image_picker.dart';
import 'package:sr_pos/features/sale/domain/repositories/sale_repository.dart';
import 'package:sr_pos/features/sale/domain/services/catalog_ingredient_image_picker.dart';
import 'package:sr_pos/features/sale/presentation/screens/sale_screen.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_cubit.dart';
import 'package:toastification/toastification.dart';

const double _toastMaximumWidth = SrSizing.size80 * 5;

class SrPosApp extends StatefulWidget {
  const SrPosApp({
    this.saleRepository = const InMemorySaleRepository(),
    this.catalogIngredientImagePicker,
    super.key,
  });

  final SaleRepository saleRepository;
  final CatalogIngredientImagePicker? catalogIngredientImagePicker;

  @override
  State<SrPosApp> createState() => _SrPosAppState();
}

class _SrPosAppState extends State<SrPosApp> {
  late final SaleCubit _saleCubit;
  late final CatalogIngredientImagePicker _catalogIngredientImagePicker;

  @override
  void initState() {
    super.initState();
    _saleCubit = SaleCubit(widget.saleRepository);
    _catalogIngredientImagePicker =
        widget.catalogIngredientImagePicker ??
        ImagePickerCatalogIngredientImagePicker();
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
      builder: (context, child) {
        final safePadding = MediaQuery.viewPaddingOf(context);
        final availableWidth =
            MediaQuery.sizeOf(context).width -
            safePadding.horizontal -
            SrSpacing.space32;
        return ToastificationConfigProvider(
          config: ToastificationConfig(
            alignment: Alignment.topRight,
            itemWidth: math.min(_toastMaximumWidth, availableWidth),
            animationDuration: SrMotion.standard,
            maxToastLimit: 3,
            maxTitleLines: 3,
            marginBuilder: (context, _) {
              final safeArea = MediaQuery.viewPaddingOf(context);
              return EdgeInsets.only(
                top: safeArea.top + SrSpacing.space16,
                right: safeArea.right + SrSpacing.space16,
                left: safeArea.left + SrSpacing.space16,
              );
            },
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: SaleScreen(
        cubit: _saleCubit,
        catalogIngredientImagePicker: _catalogIngredientImagePicker,
      ),
    );
  }
}
