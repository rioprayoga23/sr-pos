import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/map/map.dart';

import '../../../../helpers/pump_sr_widget.dart';

void main() {
  testWidgets('map placeholder composes markers and controls', (tester) async {
    var pinPressed = false;
    await pumpSrWidget(
      tester,
      SizedBox(
        width: 340,
        child: SrMapPlaceholder(
          controls: const Icon(Icons.add_rounded),
          markers: [
            SrMapMarker(
              position: Alignment.center,
              child: SrLocationPin(
                label: 'Store',
                selected: true,
                onPressed: () => pinPressed = true,
              ),
            ),
          ],
        ),
      ),
    );

    expect(find.byType(CustomPaint), findsWidgets);
    expect(find.text('Store'), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);

    await tester.tap(find.text('Store'));
    expect(pinPressed, isTrue);
  });

  testWidgets('map accepts provider-owned map content', (tester) async {
    await pumpSrWidget(
      tester,
      SizedBox(
        width: 320,
        child: SrMap(
          child: const ColoredBox(
            key: Key('provider-map'),
            color: Colors.green,
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('provider-map')), findsOneWidget);
  });
}
