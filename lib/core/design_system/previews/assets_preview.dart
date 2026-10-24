import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:sr_pos/core/design_system/components/assets/assets.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/previews/sr_preview_wrapper.dart';

@Preview(
  name: 'Assets',
  group: 'SR-POS Design System',
  size: Size(390, 700),
  wrapper: srDesignSystemPreviewWrapper,
)
Widget srAssetsPreview() {
  return SrPreviewPage(
    children: [
      const SrPreviewSection(
        title: 'Icon',
        child: Wrap(
          spacing: SrSpacing.space16,
          children: [
            SrIcon(Icons.add_rounded, size: SrIconSize.small),
            SrIcon(Icons.shopping_bag_outlined),
            SrIcon(Icons.receipt_long_outlined, size: SrIconSize.large),
          ],
        ),
      ),
      const SrPreviewSection(
        title: 'Image',
        child: SrImagePlaceholder(
          height: 140,
          semanticLabel: 'Product image placeholder',
        ),
      ),
      SrPreviewSection(
        title: 'Video',
        child: SrVideoPlaceholder(
          height: 140,
          onPlay: () {},
          playSemanticLabel: 'Play video preview',
        ),
      ),
      const SrPreviewSection(
        title: 'Avatar',
        child: Wrap(
          spacing: SrSpacing.space16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SrAvatar(initials: 'RP', size: SrAvatarSize.small),
            SrAvatar(initials: 'SR'),
            SrAvatar(initials: 'PO', size: SrAvatarSize.large),
          ],
        ),
      ),
    ],
  );
}
