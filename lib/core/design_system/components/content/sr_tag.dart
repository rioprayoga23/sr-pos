import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';
import 'package:sr_pos/core/design_system/theme/sr_status_colors.dart';

enum SrTagTone { neutral, primary, success, warning, error }

enum SrTagSize { small, medium }

/// Compact label used to communicate category, filter, or status metadata.
class SrTag extends StatelessWidget {
  const SrTag({
    required this.label,
    this.tone = SrTagTone.neutral,
    this.size = SrTagSize.medium,
    this.leading,
    this.onPressed,
    this.onDeleted,
    this.semanticLabel,
    super.key,
  });

  final String label;
  final SrTagTone tone;
  final SrTagSize size;
  final Widget? leading;
  final VoidCallback? onPressed;
  final VoidCallback? onDeleted;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = theme.extension<SrStatusColors>() ?? SrStatusColors.light;
    final colors = switch (tone) {
      SrTagTone.neutral => (
        background: theme.colorScheme.surfaceContainerLow,
        foreground: theme.colorScheme.onSurfaceVariant,
        border: theme.colorScheme.outlineVariant,
      ),
      SrTagTone.primary => (
        background: theme.colorScheme.primaryContainer,
        foreground: theme.colorScheme.onPrimaryContainer,
        border: theme.colorScheme.primary.withValues(alpha: 0.24),
      ),
      SrTagTone.success => (
        background: status.successContainer,
        foreground: status.onSuccessContainer,
        border: status.success.withValues(alpha: 0.24),
      ),
      SrTagTone.warning => (
        background: status.warningContainer,
        foreground: status.onWarningContainer,
        border: status.warning.withValues(alpha: 0.24),
      ),
      SrTagTone.error => (
        background: theme.colorScheme.errorContainer,
        foreground: theme.colorScheme.onErrorContainer,
        border: theme.colorScheme.error.withValues(alpha: 0.24),
      ),
    };
    final horizontalPadding = size == SrTagSize.small
        ? SrSpacing.space8
        : SrSpacing.space12;
    final verticalPadding = size == SrTagSize.small
        ? SrSpacing.space4
        : SrSpacing.space8;
    final textStyle = size == SrTagSize.small
        ? SrTypography.actionSmall
        : SrTypography.actionMedium;

    final content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            IconTheme(
              data: IconThemeData(
                color: colors.foreground,
                size: size == SrTagSize.small ? 14 : 16,
              ),
              child: leading!,
            ),
            const SizedBox(width: SrSpacing.space4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle.copyWith(color: colors.foreground),
            ),
          ),
          if (onDeleted != null) ...[
            const SizedBox(width: SrSpacing.space4),
            IconButton(
              onPressed: onDeleted,
              tooltip: 'Remove $label',
              visualDensity: VisualDensity.compact,
              iconSize: 16,
              color: colors.foreground,
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ],
      ),
    );

    final shape = StadiumBorder(
      side: BorderSide(
        color: colors.border,
        width: SrComponentMetrics.borderWidth,
      ),
    );

    return Semantics(
      label: semanticLabel ?? label,
      button: onPressed != null,
      child: Material(
        color: colors.background,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: onPressed == null
            ? content
            : InkWell(
                onTap: onPressed,
                customBorder: const StadiumBorder(),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: kMinInteractiveDimension,
                  ),
                  child: content,
                ),
              ),
      ),
    );
  }
}
