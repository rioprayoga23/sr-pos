import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/components/assets/sr_icon.dart';
import 'package:sr_pos/core/design_system/components/control/sr_button.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

@immutable
final class SrDialogAction {
  const SrDialogAction({
    required this.label,
    required this.onPressed,
    this.variant = SrButtonVariant.primary,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final SrButtonVariant variant;
  final String? semanticLabel;
}

class SrDialog extends StatelessWidget {
  const SrDialog({
    required this.title,
    required this.actions,
    this.message,
    this.header,
    this.semanticLabel,
    this.children = const [],
    this.onClose,
    this.closeSemanticLabel = 'Tutup dialog',
    this.compact = false,
    this.maxWidth,
    super.key,
  }) : assert(actions.length == 2 || actions.length == 3),
       assert(maxWidth == null || maxWidth >= SrSizing.size40 * 7);

  final String title;
  final String? message;
  final Widget? header;
  final List<Widget> children;
  final Iterable<SrDialogAction> actions;
  final String? semanticLabel;

  /// Optional close affordance placed in the dialog's upper-right corner.
  final VoidCallback? onClose;

  /// Accessible label and tooltip shown for the optional close affordance.
  final String closeSemanticLabel;

  /// Reduces dialog insets and section spacing for denser workflows.
  final bool compact;

  /// Optional per-dialog width cap; defaults to the shared dialog width.
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final contentPadding = compact ? SrSpacing.space16 : SrSpacing.space24;
    final headerSpacing = compact ? SrSpacing.space8 : SrSpacing.space16;
    final contentSpacing = compact ? SrSpacing.space4 : SrSpacing.space8;
    final actionSpacing = compact ? SrSpacing.space16 : SrSpacing.space24;

    return Semantics(
      label: semanticLabel,
      namesRoute: true,
      scopesRoute: true,
      container: true,
      explicitChildNodes: true,
      child: Dialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SrRadii.large),
        ),
        constraints: BoxConstraints(
          minWidth: SrSizing.size40 * 7,
          maxWidth: maxWidth ?? SrComponentMetrics.dialogMaxWidth,
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(contentPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (header != null) ...[
                    Align(child: header),
                    SizedBox(height: headerSpacing),
                  ],
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: SrTypography.heading2.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  if (message case final dialogMessage?) ...[
                    SizedBox(height: contentSpacing),
                    Text(
                      dialogMessage,
                      textAlign: TextAlign.center,
                      style: SrTypography.bodyMedium.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                  for (final child in children) ...[
                    SizedBox(height: contentSpacing),
                    child,
                  ],
                  SizedBox(height: actionSpacing),
                  if (actions.length == 2)
                    Row(
                      children: [
                        Expanded(child: _ActionButton(action: actions.first)),
                        const SizedBox(width: SrSpacing.space8),
                        Expanded(child: _ActionButton(action: actions.last)),
                      ],
                    )
                  else
                    ...actions.indexed.map((entry) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: entry.$1 == 0 ? 0 : SrSpacing.space8,
                        ),
                        child: _ActionButton(action: entry.$2),
                      );
                    }),
                ],
              ),
            ),
            if (onClose != null)
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: onClose,
                  tooltip: closeSemanticLabel,
                  constraints: const BoxConstraints(
                    minWidth: SrSizing.minimumTouchTarget,
                    minHeight: SrSizing.minimumTouchTarget,
                  ),
                  padding: EdgeInsets.zero,
                  icon: SrIcon(
                    Icons.close_rounded,
                    size: SrIconSize.medium,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action});

  final SrDialogAction action;

  @override
  Widget build(BuildContext context) {
    return SrButton(
      label: action.label,
      onPressed: action.onPressed,
      variant: action.variant,
      semanticLabel: action.semanticLabel,
      expand: true,
    );
  }
}

Future<T?> showSrDialog<T>({
  required BuildContext context,
  required SrDialog dialog,
  bool barrierDismissible = false,
  String? barrierLabel,
}) {
  if (!context.mounted) return Future<T?>.value();

  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    builder: (_) => dialog,
  );
}
