import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/theme/sr_theme.dart';

Future<void> pumpSrWidget(
  WidgetTester tester,
  Widget child, {
  Size surfaceSize = const Size(390, 844),
}) async {
  await tester.binding.setSurfaceSize(surfaceSize);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      theme: SrTheme.light,
      home: Scaffold(body: Center(child: child)),
    ),
  );
}
