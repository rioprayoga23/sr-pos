import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/sale/data/repositories/in_memory_sale_repository.dart';
import 'package:sr_pos/features/sale/presentation/screens/sale_screen.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_cubit.dart';

import '../../../../helpers/load_sr_fonts.dart';

void main() {
  testWidgets('payment success dialog stays compact with a full receipt', (
    tester,
  ) async {
    await tester.runAsync(loadSrFonts);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = SaleCubit(const InMemorySaleRepository());
    addTearDown(cubit.close);
    await cubit.load();
    for (final product in cubit.state.products) {
      cubit.addProduct(product.id);
    }
    cubit.setCashReceivedAmount(200000);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: SrTheme.light,
        home: SaleScreen(cubit: cubit),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Bayar · Rp156.000'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(SrDialog), findsOneWidget);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/payment_success_dialog.png'),
    );
  });
}
