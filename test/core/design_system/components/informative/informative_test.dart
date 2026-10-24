import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/control/sr_button.dart';
import 'package:sr_pos/core/design_system/components/informative/informative.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';

import '../../../../helpers/pump_sr_widget.dart';

void main() {
  group('informative components', () {
    testWidgets('banner exposes message and dismiss action', (tester) async {
      var dismissed = false;

      await pumpSrWidget(
        tester,
        SrBanner(
          title: 'Connection issue',
          message: 'Try again in a moment.',
          tone: SrFeedbackTone.warning,
          onDismiss: () => dismissed = true,
          dismissSemanticLabel: 'Dismiss banner',
        ),
      );

      expect(find.text('Connection issue'), findsOneWidget);
      expect(find.text('Try again in a moment.'), findsOneWidget);
      await tester.tap(find.byTooltip('Dismiss banner'));
      expect(dismissed, isTrue);
    });

    testWidgets('badge caps a count and can decorate a child', (tester) async {
      await pumpSrWidget(
        tester,
        SrBadge.count(
          count: 120,
          maximum: 99,
          semanticLabel: '120 notifications',
          child: const Icon(Icons.notifications_outlined),
        ),
      );

      expect(find.text('99+'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(find.bySemanticsLabel('120 notifications'), findsOneWidget);
    });

    testWidgets('single-digit count badge stays perfectly circular', (
      tester,
    ) async {
      await pumpSrWidget(tester, SrBadge.count(count: 2));

      expect(tester.getSize(find.byType(SrBadge)), const Size.square(24));
    });

    testWidgets('dot and multi-digit badge preserve their intended shapes', (
      tester,
    ) async {
      await pumpSrWidget(
        tester,
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SrBadge.dot(),
            SizedBox(width: 8),
            SrBadge(label: '99+'),
          ],
        ),
      );

      final badges = find.byType(SrBadge);
      expect(tester.getSize(badges.at(0)), const Size.square(8));
      final labelBody = find.descendant(
        of: badges.at(1),
        matching: find.byType(DecoratedBox),
      );
      final labelSize = tester.getSize(labelBody);
      expect(labelSize.height, 24);
      expect(labelSize.width, greaterThan(labelSize.height));
    });

    testWidgets('two-action dialog invokes the selected action', (
      tester,
    ) async {
      var confirmed = false;

      await pumpSrWidget(
        tester,
        SrDialog(
          title: 'Remove item?',
          message: 'This action cannot be undone.',
          actions: [
            const SrDialogAction(
              label: 'Cancel',
              onPressed: null,
              variant: SrButtonVariant.secondary,
            ),
            SrDialogAction(label: 'Remove', onPressed: () => confirmed = true),
          ],
        ),
      );

      await tester.tap(find.text('Remove'));
      expect(confirmed, isTrue);
    });

    testWidgets('dialog caps wide layouts and lays out custom children', (
      tester,
    ) async {
      await pumpSrWidget(
        tester,
        SrDialog(
          title: 'Payment complete',
          actions: const [
            SrDialogAction(label: 'Close', onPressed: null),
            SrDialogAction(label: 'New sale', onPressed: null),
          ],
          children: const [Text('8 items · Cash'), Text('General customer')],
        ),
        surfaceSize: const Size(1920, 1080),
      );

      final dialogSurface = find.descendant(
        of: find.byType(Dialog),
        matching: find.byWidgetPredicate(
          (widget) => widget is Material && widget.type == MaterialType.card,
        ),
      );
      expect(tester.getSize(dialogSurface).width, SrSizing.size80 * 8);
      expect(find.text('8 items · Cash'), findsOneWidget);
      expect(find.text('General customer'), findsOneWidget);
    });

    testWidgets('dialog close action uses its compact width and semantics', (
      tester,
    ) async {
      var closed = false;

      await pumpSrWidget(
        tester,
        SrDialog(
          title: 'Payment complete',
          actions: const [
            SrDialogAction(label: 'Close', onPressed: null),
            SrDialogAction(label: 'New sale', onPressed: null),
          ],
          compact: true,
          maxWidth: 560,
          onClose: () => closed = true,
        ),
        surfaceSize: const Size(1920, 1080),
      );

      final dialogSurface = find.descendant(
        of: find.byType(Dialog),
        matching: find.byWidgetPredicate(
          (widget) => widget is Material && widget.type == MaterialType.card,
        ),
      );
      final closeButton = find.byTooltip('Tutup dialog');

      expect(tester.getSize(dialogSurface).width, 560);
      expect(closeButton, findsOneWidget);
      expect(tester.getSize(find.byType(IconButton)), const Size.square(48));

      await tester.tap(closeButton);
      expect(closed, isTrue);
    });

    testWidgets('toast helper presents a floating toast safely', (
      tester,
    ) async {
      late BuildContext context;

      await pumpSrWidget(
        tester,
        Builder(
          builder: (builderContext) {
            context = builderContext;
            return const SizedBox.shrink();
          },
        ),
      );

      final controller = showSrToast(
        context: context,
        message: 'Saved successfully',
        tone: SrFeedbackTone.success,
      );
      await tester.pump();

      expect(controller, isNotNull);
      expect(find.text('Saved successfully'), findsOneWidget);
    });

    testWidgets('toast helper returns null without a messenger', (
      tester,
    ) async {
      late BuildContext context;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (builderContext) {
              context = builderContext;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(showSrToast(context: context, message: 'Message'), isNull);
    });

    testWidgets('tooltip displays its message on tap', (tester) async {
      await pumpSrWidget(
        tester,
        const SrTooltip(
          message: 'More information',
          triggerMode: TooltipTriggerMode.tap,
          child: Icon(Icons.info_outline),
        ),
      );

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pump();
      expect(find.text('More information'), findsOneWidget);
    });
  });
}
