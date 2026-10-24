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

    testWidgets('small button keeps the 48 pixel touch target', (tester) async {
      await pumpSrWidget(
        tester,
        const SrButton(
          label: 'Compact action',
          size: SrComponentSize.small,
          onPressed: _noop,
        ),
      );

      expect(
        tester.getSize(find.byType(FilledButton)).height,
        greaterThanOrEqualTo(48),
      );
    });

    testWidgets('destructive button applies error color to label and icon', (
      tester,
    ) async {
      var pressed = false;

      await pumpSrWidget(
        tester,
        SrButton(
          label: 'Hapus',
          variant: SrButtonVariant.destructive,
          leadingIcon: const Icon(Icons.delete_outline_rounded),
          size: SrComponentSize.small,
          onPressed: () => pressed = true,
        ),
      );

      final colors = Theme.of(tester.element(find.byType(SrButton)))
          .colorScheme;
      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(
        button.style!.foregroundColor!.resolve(const <WidgetState>{}),
        colors.error,
      );
      expect(
        IconTheme.of(tester.element(find.byIcon(Icons.delete_outline_rounded)))
            .color,
        colors.error,
      );
      expect(
        tester.getSize(find.byType(TextButton)).height,
        greaterThanOrEqualTo(48),
      );

      await tester.tap(find.text('Hapus'));
      expect(pressed, isTrue);
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
