import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/control/control.dart';
import 'package:sr_pos/core/design_system/components/informative/sr_badge.dart';

import '../../../../helpers/pump_sr_widget.dart';

void main() {
  group('controls', () {
    testWidgets('button supports variants, icons, and loading state', (
      tester,
    ) async {
      var presses = 0;

      await pumpSrWidget(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SrButton(
              label: 'Add',
              leadingIcon: const Icon(Icons.add_rounded),
              onPressed: () => presses++,
            ),
            const SrButton(
              label: 'Saving',
              onPressed: _noop,
              variant: SrButtonVariant.secondary,
              isLoading: true,
              loadingSemanticLabel: 'Saving in progress',
            ),
          ],
        ),
      );

      await tester.tap(find.text('Add'));
      expect(presses, 1);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.bySemanticsLabel('Saving in progress'), findsOneWidget);
    });

    testWidgets('content switcher reports the selected value', (tester) async {
      String? selected;

      await pumpSrWidget(
        tester,
        SrContentSwitcher<String>(
          items: const [
            SrContentSwitcherItem(value: 'daily', label: 'Daily'),
            SrContentSwitcherItem(value: 'weekly', label: 'Weekly'),
          ],
          selectedValue: 'daily',
          onChanged: (value) => selected = value,
        ),
      );

      await tester.tap(find.text('Weekly'));
      expect(selected, 'weekly');
    });

    testWidgets('filter composes icons and a count badge', (tester) async {
      bool? selected;

      await pumpSrWidget(
        tester,
        SrFilter(
          label: 'Filter',
          selected: false,
          leading: const Icon(Icons.tune_rounded),
          trailing: SrBadge.count(count: 2),
          onSelected: (value) => selected = value,
        ),
      );

      expect(find.text('2'), findsOneWidget);
      expect(tester.getSize(find.byType(SrBadge)), const Size.square(24));
      await tester.tap(find.text('Filter'));
      expect(selected, isTrue);
    });

    testWidgets('tabs work in an unconstrained vertical layout', (
      tester,
    ) async {
      int? selectedIndex;

      await pumpSrWidget(
        tester,
        SrTabs(
          items: const [
            SrTabItem(label: 'Overview'),
            SrTabItem(label: 'Activity'),
          ],
          selectedIndex: 0,
          onChanged: (index) => selectedIndex = index,
        ),
      );

      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Activity'));
      expect(selectedIndex, 1);
    });

    testWidgets('action sheet item invokes its callback', (tester) async {
      var selected = false;

      await pumpSrWidget(
        tester,
        SrActionSheet(
          title: 'Choose an action',
          actions: [
            SrActionSheetItem(
              label: 'Duplicate',
              leading: const Icon(Icons.copy_outlined),
              onPressed: () => selected = true,
            ),
          ],
        ),
      );

      await tester.tap(find.text('Duplicate'));
      expect(selected, isTrue);
    });
  });
}

void _noop() {}
