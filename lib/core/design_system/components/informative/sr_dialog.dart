import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/components/control/sr_button.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
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
    super.key,
  }) : assert(actions.length == 2 || actions.length == 3);

  final String title;
  final String? message;
  final Widget? header;
  final Iterable<SrDialogAction> actions;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
        child: Padding(
          padding: const EdgeInsets.all(SrSpacing.space24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (header != null) ...[
                Align(child: header),
                const SizedBox(height: SrSpacing.space16),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: SrTypography.heading2.copyWith(color: colors.onSurface),
              ),
              if (message case final dialogMessage?) ...[
                const SizedBox(height: SrSpacing.space8),
                Text(
                  dialogMessage,
                  textAlign: TextAlign.center,
                  style: SrTypography.bodyMedium.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: SrSpacing.space24),
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
