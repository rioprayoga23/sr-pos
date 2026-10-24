import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

/// Section heading placed above a list or grouped collection.
class SrListTitle extends StatelessWidget {
  const SrListTitle({
    required this.title,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SrSpacing.space16,
        SrSpacing.space16,
        SrSpacing.space16,
        SrSpacing.space8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: SrTypography.heading4.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: SrSpacing.space4),
                  Text(
                    subtitle!,
                    style: SrTypography.bodySmall.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: SrSpacing.space12),
            trailing!,
          ],
        ],
      ),
    );
  }
}
