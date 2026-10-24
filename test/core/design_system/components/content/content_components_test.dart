import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/content/content.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';

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

  testWidgets('SrCard omits empty title space for full-height media', (
    tester,
  ) async {
    await pumpSrWidget(
      tester,
      SizedBox(
        width: 180,
        child: SrCard(
          title: '',
          visualKind: SrCardVisualKind.media,
          visual: const ColoredBox(
            key: Key('full-height-media'),
            color: Colors.blue,
          ),
          mediaHeight: 120,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );

    final card = find.byType(SrCard);
    final media = find.byKey(const Key('full-height-media'));

    expect(tester.getSize(card).height, 120);
    expect(tester.getSize(media).height, tester.getSize(card).height);
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

  testWidgets('small primary list selection uses rounded primary surface', (
    tester,
  ) async {
    await pumpSrWidget(
      tester,
      const SrListItem(
        title: 'Kasir',
        leading: Icon(Icons.point_of_sale_rounded),
        selected: true,
        selectedStyle: SrListItemSelectedStyle.primary,
        size: SrComponentSize.small,
      ),
    );

    final primary = Theme.of(tester.element(find.byType(SrListItem)))
        .colorScheme
        .primary;
    final selectedSurface = find.byWidgetPredicate(
      (widget) => widget is Material && widget.color == primary,
    );
    expect(selectedSurface, findsOneWidget);
    expect(tester.getSize(selectedSurface).height, greaterThanOrEqualTo(48));
    expect(
      tester.widget<Material>(selectedSurface).shape,
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SrRadii.medium),
      ),
    );
  });

  testWidgets('icon-only list item centers its leading icon', (tester) async {
    await pumpSrWidget(
      tester,
      const SizedBox(
        width: 64,
        child: SrListItem(
          title: '',
          semanticLabel: 'Kasir',
          leading: Icon(Icons.point_of_sale_rounded),
          selected: true,
          selectedStyle: SrListItemSelectedStyle.primary,
          size: SrComponentSize.small,
        ),
      ),
    );

    final item = find.byType(SrListItem);
    final icon = find.byIcon(Icons.point_of_sale_rounded);

    expect(
      tester.getCenter(icon).dx,
      closeTo(tester.getCenter(item).dx, 0.001),
    );
    expect(find.bySemanticsLabel('Kasir'), findsOneWidget);
  });
}
