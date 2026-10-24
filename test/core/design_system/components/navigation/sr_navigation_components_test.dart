import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/navigation/navigation.dart';
import 'package:sr_pos/core/design_system/theme/sr_theme.dart';

import '../../../../helpers/pump_sr_widget.dart';

void main() {
  testWidgets('tab bar reports an enabled destination', (tester) async {
    int? selectedIndex;

    await pumpSrWidget(
      tester,
      SizedBox(
        width: 390,
        child: SrTabBar(
          currentIndex: 0,
          onChanged: (index) => selectedIndex = index,
          items: const [
            SrTabBarItem(label: 'Home', icon: Icon(Icons.home_outlined)),
            SrTabBarItem(
              label: 'Orders',
              icon: Icon(Icons.receipt_long_outlined),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Orders'));

    expect(selectedIndex, 1);
  });

  testWidgets('tab bar ignores a disabled destination', (tester) async {
    int? selectedIndex;

    await pumpSrWidget(
      tester,
      SizedBox(
        width: 390,
        child: SrTabBar(
          currentIndex: 0,
          onChanged: (index) => selectedIndex = index,
          items: const [
            SrTabBarItem(label: 'Home', icon: Icon(Icons.home_outlined)),
            SrTabBarItem(
              label: 'Reports',
              icon: Icon(Icons.analytics_outlined),
              enabled: false,
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Reports'));

    expect(selectedIndex, isNull);
  });

  testWidgets('tab bar keeps a finite height in a scrollable layout', (
    tester,
  ) async {
    await pumpSrWidget(
      tester,
      SingleChildScrollView(
        child: SrTabBar(
          currentIndex: 0,
          onChanged: (_) {},
          items: const [
            SrTabBarItem(label: 'Home', icon: Icon(Icons.home_outlined)),
            SrTabBarItem(
              label: 'Orders',
              icon: Icon(Icons.receipt_long_outlined),
            ),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(SrTabBar)).height, 64);
  });

  testWidgets('nav bar dispatches back and action callbacks', (tester) async {
    var backPressed = false;
    var addPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: SrTheme.light,
        home: Scaffold(
          appBar: SrNavBar(
            title: 'Products',
            onBack: () => backPressed = true,
            actions: [
              SrNavBarAction(
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Add product',
                onPressed: () => addPressed = true,
              ),
            ],
          ),
          body: const SizedBox.expand(),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Back'));
    await tester.tap(find.byTooltip('Add product'));

    expect(backPressed, isTrue);
    expect(addPressed, isTrue);
    expect(find.text('Products'), findsOneWidget);
  });

  testWidgets('nav bar places title actions before trailing title content', (
    tester,
  ) async {
    var actionPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: SrTheme.light,
        home: Scaffold(
          appBar: SrNavBar(
            titleWidget: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Kopi Yo')],
            ),
            titleActions: [
              SrNavBarAction(
                icon: const Icon(Icons.chevron_left_rounded),
                tooltip: 'Toggle menu labels',
                onPressed: () => actionPressed = true,
              ),
            ],
            titleTrailing: const Text('Online'),
          ),
          body: const SizedBox.expand(),
        ),
      ),
    );

    final titleBounds = tester.getRect(find.text('Kopi Yo'));
    final action = find.byTooltip('Toggle menu labels');
    final actionBounds = tester.getRect(action);
    final trailingBounds = tester.getRect(find.text('Online'));

    expect(titleBounds.right, lessThanOrEqualTo(actionBounds.left));
    expect(actionBounds.right, lessThanOrEqualTo(trailingBounds.left));
    expect(tester.takeException(), isNull);

    await tester.tap(action);

    expect(actionPressed, isTrue);
  });
}
