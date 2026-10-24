import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

enum SrLoaderSize { small, medium, large }

class SrLoader extends StatelessWidget {
  const SrLoader({
    this.size = SrLoaderSize.medium,
    this.label,
    this.semanticLabel = 'Loading',
    super.key,
  });

  final SrLoaderSize size;
  final String? label;
  final String semanticLabel;

  double get _dimension => switch (size) {
    SrLoaderSize.small => SrSizing.size16,
    SrLoaderSize.medium => SrSizing.size24,
    SrLoaderSize.large => SrSizing.size40,
  };

  double get _strokeWidth => switch (size) {
    SrLoaderSize.small => 2,
    SrLoaderSize.medium => 3,
    SrLoaderSize.large => 4,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      liveRegion: true,
      label: semanticLabel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: _dimension,
            child: CircularProgressIndicator(
              strokeWidth: _strokeWidth,
              color: scheme.primary,
              backgroundColor: scheme.surfaceContainer,
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: SrSpacing.space8),
            Text(
              label!,
              textAlign: TextAlign.center,
              style: SrTypography.bodySmall.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
