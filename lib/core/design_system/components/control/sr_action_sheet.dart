import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

enum SrActionSheetItemTone { normal, destructive }

class SrActionSheetItem extends StatelessWidget {
  const SrActionSheetItem({
    required this.label,
    this.onPressed,
    this.leading,
    this.trailing,
    this.tone = SrActionSheetItemTone.normal,
    this.semanticLabel,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final SrActionSheetItemTone tone;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final enabled = onPressed != null;
    final foreground = !enabled
        ? theme.disabledColor
        : switch (tone) {
            SrActionSheetItemTone.normal => colors.onSurface,
            SrActionSheetItemTone.destructive => colors.error,
          };

    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      enabled: enabled,
      child: ExcludeSemantics(
        child: Material(
          color: colors.surface,
          borderRadius: BorderRadius.circular(SrRadii.small),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(SrRadii.small),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: kMinInteractiveDimension,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SrSpacing.space16,
                  vertical: SrSpacing.space12,
                ),
                child: Row(
                  children: [
                    if (leading case final leadingWidget?) ...[
                      IconTheme.merge(
                        data: IconThemeData(
                          color: foreground,
                          size: SrSizing.size24,
                        ),
                        child: leadingWidget,
                      ),
                      const SizedBox(width: SrSpacing.space12),
                    ],
                    Expanded(
                      child: Text(
                        label,
                        style: SrTypography.actionLarge.copyWith(
                          color: foreground,
                        ),
                      ),
                    ),
                    if (trailing case final trailingWidget?) ...[
                      const SizedBox(width: SrSpacing.space12),
                      IconTheme.merge(
                        data: IconThemeData(
                          color: foreground,
                          size: SrSizing.size24,
                        ),
                        child: trailingWidget,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SrActionSheet extends StatelessWidget {
  const SrActionSheet({
    required this.actions,
    this.title,
    this.message,
    this.cancelAction,
    this.semanticLabel,
    super.key,
  }) : assert(actions.length > 0);

  final String? title;
  final String? message;
  final Iterable<SrActionSheetItem> actions;
  final SrActionSheetItem? cancelAction;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      label: semanticLabel,
      container: true,
      explicitChildNodes: true,
      child: Material(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(SrRadii.large),
        ),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              SrSpacing.space16,
              SrSpacing.space24,
              SrSpacing.space16,
              SrSpacing.space16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title case final sheetTitle?)
                  Text(
                    sheetTitle,
                    style: SrTypography.heading2.copyWith(
                      color: colors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (message case final sheetMessage?) ...[
                  if (title != null) const SizedBox(height: SrSpacing.space8),
                  Text(
                    sheetMessage,
                    style: SrTypography.bodyMedium.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (title != null || message != null)
                  const SizedBox(height: SrSpacing.space16),
                ..._withSpacing(actions),
                if (cancelAction case final cancel?) ...[
                  const SizedBox(height: SrSpacing.space8),
                  cancel,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static List<Widget> _withSpacing(Iterable<SrActionSheetItem> items) {
    final children = <Widget>[];
    for (final item in items) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: SrSpacing.space4));
      }
      children.add(item);
    }
    return children;
  }
}

Future<T?> showSrActionSheet<T>({
  required BuildContext context,
  required SrActionSheet child,
}) {
  if (!context.mounted) return Future<T?>.value();

  final colors = Theme.of(context).colorScheme;

  return showModalBottomSheet<T>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(SrRadii.large)),
    ),
    builder: (_) => child,
  );
}
