import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/theme/sr_theme.dart';
import 'package:sr_pos/features/product_search/data/repositories/in_memory_product_repository.dart';
import 'package:sr_pos/features/product_search/presentation/screens/product_search_screen.dart';
import 'package:sr_pos/features/product_search/presentation/view_models/product_search_view_model.dart';

import '../../../../helpers/load_sr_fonts.dart';

void main() {
  testWidgets('matches the product search reference layout', (tester) async {
    await tester.runAsync(loadSrFonts);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.binding.setSurfaceSize(const Size(375, 812));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final viewModel = ProductSearchViewModel(const InMemoryProductRepository());
    addTearDown(viewModel.dispose);
    await viewModel.load();

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: SrTheme.light,
        home: ProductSearchScreen(viewModel: viewModel),
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(ProductSearchScreen),
      matchesGoldenFile('goldens/product_search_screen.png'),
    );
  });
}
