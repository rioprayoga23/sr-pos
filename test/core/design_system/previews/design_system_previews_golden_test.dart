import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/previews/assets_preview.dart';
import 'package:sr_pos/core/design_system/previews/content_preview.dart';
import 'package:sr_pos/core/design_system/previews/informative_control_preview.dart';
import 'package:sr_pos/core/design_system/previews/input_navigation_preview.dart';
import 'package:sr_pos/core/design_system/previews/map_commerce_device_preview.dart';
import 'package:sr_pos/core/design_system/previews/progress_chat_preview.dart';
import 'package:sr_pos/core/design_system/previews/sr_preview_wrapper.dart';

import '../../../helpers/load_sr_fonts.dart';

void main() {
  final previewCases = <_PreviewCase>[
    _PreviewCase(
      name: 'assets',
      size: const Size(390, 700),
      builder: srAssetsPreview,
    ),
    _PreviewCase(
      name: 'informative_control',
      size: const Size(390, 1200),
      builder: srInformativeControlPreview,
    ),
    _PreviewCase(
      name: 'input_navigation',
      size: const Size(390, 1400),
      builder: srInputNavigationPreview,
    ),
    _PreviewCase(
      name: 'content',
      size: const Size(390, 1300),
      builder: srContentPreview,
    ),
    _PreviewCase(
      name: 'progress_chat',
      size: const Size(390, 900),
      builder: srProgressChatPreview,
    ),
    _PreviewCase(
      name: 'map_commerce_device',
      size: const Size(390, 1200),
      builder: srMapCommerceDevicePreview,
    ),
  ];

  for (final previewCase in previewCases) {
    testWidgets('${previewCase.name} preview matches its visual contract', (
      tester,
    ) async {
      await tester.runAsync(loadSrFonts);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.binding.setSurfaceSize(previewCase.size);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        srDesignSystemPreviewWrapper(previewCase.builder()),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/${previewCase.name}_preview.png'),
      );
    });
  }
}

final class _PreviewCase {
  const _PreviewCase({
    required this.name,
    required this.size,
    required this.builder,
  });

  final String name;
  final Size size;
  final Widget Function() builder;
}
