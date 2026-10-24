import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/assets/assets.dart';

import '../../../../helpers/pump_sr_widget.dart';

void main() {
  group('assets', () {
    testWidgets('renders icon with the selected semantic size', (tester) async {
      await pumpSrWidget(
        tester,
        const SrIcon(
          Icons.add_rounded,
          size: SrIconSize.large,
          semanticLabel: 'Add item',
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.add_rounded));
      expect(icon.size, 24);
      expect(find.bySemanticsLabel('Add item'), findsOneWidget);
    });

    testWidgets('extra-large icon uses the display check size', (tester) async {
      await pumpSrWidget(
        tester,
        const SrIcon(Icons.check_rounded, size: SrIconSize.extraLarge),
      );

      expect(tester.widget<Icon>(find.byIcon(Icons.check_rounded)).size, 32);
    });

    testWidgets('image placeholder respects its aspect ratio', (tester) async {
      const key = Key('image-placeholder');

      await pumpSrWidget(
        tester,
        const SrImagePlaceholder(
          key: key,
          width: 120,
          aspectRatio: 2,
          semanticLabel: 'Product photo',
        ),
      );

      expect(tester.getSize(find.byKey(key)), const Size(120, 60));
      expect(find.bySemanticsLabel('Product photo'), findsOneWidget);
    });

    testWidgets('video play control invokes its callback', (tester) async {
      var playCount = 0;

      await pumpSrWidget(
        tester,
        SrVideoPlaceholder(
          width: 160,
          onPlay: () => playCount++,
          playSemanticLabel: 'Play preview',
        ),
      );

      await tester.tap(find.bySemanticsLabel('Play preview'));
      expect(playCount, 1);
      expect(tester.getSize(find.byType(InkWell)), const Size.square(48));
    });

    testWidgets('avatar uses initials and configured size', (tester) async {
      const key = Key('avatar');

      await pumpSrWidget(
        tester,
        const SrAvatar(
          key: key,
          initials: 'rp',
          size: SrAvatarSize.large,
          semanticLabel: 'Rio Prayoga',
        ),
      );

      expect(find.text('RP'), findsOneWidget);
      expect(tester.getSize(find.byKey(key)), const Size.square(56));
      expect(find.bySemanticsLabel('Rio Prayoga'), findsOneWidget);
    });
  });
}
