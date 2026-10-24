import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/content/content.dart';

import '../../../../helpers/pump_sr_widget.dart';

void main() {
  testWidgets('SrCard composes vertical media, metadata, and action', (
    tester,
  ) async {
    var tapped = false;
    await pumpSrWidget(
      tester,
      SizedBox(
        width: 180,
        child: SrCard(
          title: 'Amazing Shoes',
          subtitle: '€ 12.00',
          description: 'Comfortable everyday shoes',
          visualKind: SrCardVisualKind.media,
          visual: const ColoredBox(
            key: Key('product-media'),
            color: Colors.blue,
          ),
          metadata: const Text('In stock'),
          action: const Text('Add to cart'),
          mediaHeight: 112,
          contentPadding: const EdgeInsets.all(8),
          onTap: () => tapped = true,
        ),
      ),
    );

    expect(find.byKey(const Key('product-media')), findsOneWidget);
    expect(find.text('In stock'), findsOneWidget);
    expect(find.text('Add to cart'), findsOneWidget);

    await tester.tap(find.text('Amazing Shoes'));
    expect(tapped, isTrue);
  });

  testWidgets('content controls expose controlled interactions', (
    tester,
  ) async {
    bool? expansion;
    DateTime? selectedDate;
    var deleted = false;

    await pumpSrWidget(
      tester,
      SingleChildScrollView(
        child: Column(
          children: [
            SrAccordion(
              title: 'Details',
              expanded: false,
              onExpansionChanged: (value) => expansion = value,
              child: const Text('Expanded content'),
            ),
            SrTag(label: 'Sale', onDeleted: () => deleted = true),
            SrCalendar(
              visibleMonth: DateTime(2026, 10),
              selectedDate: DateTime(2026, 10, 10),
              onDateSelected: (value) => selectedDate = value,
            ),
          ],
        ),
      ),
      surfaceSize: const Size(390, 1000),
    );

    await tester.tap(find.text('Details'));
    expect(expansion, isTrue);

    await tester.tap(find.byTooltip('Remove Sale'));
    expect(deleted, isTrue);

    await tester.tap(find.text('15').first);
    expect(selectedDate, DateTime(2026, 10, 15));
  });

  testWidgets('list primitives render selection and supporting content', (
    tester,
  ) async {
    await pumpSrWidget(
      tester,
      const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SrListTitle(title: 'Products', subtitle: 'Six items'),
          SrDivider(),
          SrListItem(
            title: 'Amazing Shoes',
            subtitle: '€ 12.00',
            leading: Icon(Icons.inventory_2_outlined),
            selected: true,
            showChevron: true,
          ),
        ],
      ),
    );

    expect(find.text('Products'), findsOneWidget);
    expect(find.text('Amazing Shoes'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
  });
}
