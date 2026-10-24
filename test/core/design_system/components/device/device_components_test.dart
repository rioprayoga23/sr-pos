import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/device/device.dart';

import '../../../../helpers/pump_sr_widget.dart';

void main() {
  testWidgets('device frame composes status and home components', (
    tester,
  ) async {
    await pumpSrWidget(
      tester,
      const SrDeviceFrame(
        width: 180,
        child: ColoredBox(key: Key('screen-content'), color: Colors.white),
      ),
    );

    expect(find.byType(SrDeviceStatusBar), findsOneWidget);
    expect(find.byType(SrDeviceHomeIndicator), findsOneWidget);
    expect(find.byKey(const Key('screen-content')), findsOneWidget);
  });

  testWidgets('overlay keeps content compositional and dismissible', (
    tester,
  ) async {
    var dismissed = false;
    await pumpSrWidget(
      tester,
      SrOverlay(
        visible: true,
        onDismiss: () => dismissed = true,
        overlayContent: const Text('Confirm order'),
        child: const SizedBox.expand(child: ColoredBox(color: Colors.white)),
      ),
    );

    expect(find.text('Confirm order'), findsOneWidget);
    await tester.tapAt(const Offset(20, 20));
    await tester.pump();
    expect(dismissed, isTrue);
  });
}
