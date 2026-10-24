import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/features/sale/presentation/previews/sale_order_list_preview.dart';

import '../../../../helpers/load_sr_fonts.dart';

void main() {
  testWidgets('Sale order overflow preview matches its visual contract', (
    tester,
  ) async {
    await tester.runAsync(loadSrFonts);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.binding.setSurfaceSize(const Size(480, 480));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(saleOrderListOverflowPreview());
    await tester.pumpAndSettle();

    expect(find.byTooltip('Gulir ke sisa pesanan'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/sale_order_list_overflow.png'),
    );
  });
}
