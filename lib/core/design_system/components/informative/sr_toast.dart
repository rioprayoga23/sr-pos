import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/informative/sr_feedback_tone.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

class SrToast extends StatelessWidget {
  const SrToast({
    required this.message,
    this.tone = SrFeedbackTone.neutral,
    this.leading,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.dismissSemanticLabel,
    this.semanticLabel,
    super.key,
  }) : assert((actionLabel == null) == (onAction == null)),
       assert(onDismiss == null || dismissSemanticLabel != null);

  final String message;
  final SrFeedbackTone tone;
  final Widget? leading;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;
  final String? dismissSemanticLabel;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final palette = tone.resolve(context);
    final action = switch ((actionLabel, onAction)) {
      (final label?, final callback?) => (label, callback),
      _ => null,
    };

    return Semantics(
      label: semanticLabel,
      liveRegion: true,
      container: true,
      child: Material(
        color: palette.solid,
        borderRadius: BorderRadius.circular(SrRadii.medium),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SrSpacing.space16,
            vertical: SrSpacing.space8,
          ),
          child: Row(
            children: [
              IconTheme.merge(
                data: IconThemeData(
                  color: palette.onSolid,
                  size: SrSizing.size20,
                ),
                child: leading ?? Icon(tone.icon),
              ),
              const SizedBox(width: SrSpacing.space12),
              Expanded(
                child: Text(
                  message,
                  style: SrTypography.bodyMedium.copyWith(
                    color: palette.onSolid,
                  ),
                ),
              ),
              if (action case (final label, final callback)) ...[
                const SizedBox(width: SrSpacing.space8),
                TextButton(
                  onPressed: callback,
                  style: TextButton.styleFrom(
                    foregroundColor: palette.onSolid,
                    minimumSize: const Size(
                      kMinInteractiveDimension,
                      kMinInteractiveDimension,
                    ),
                    textStyle: SrTypography.actionMedium,
                  ),
                  child: Text(label),
                ),
              ],
              if (onDismiss != null)
                IconButton(
                  onPressed: onDismiss,
                  tooltip: dismissSemanticLabel,
                  color: palette.onSolid,
                  icon: const Icon(Icons.close_rounded),
                  constraints: const BoxConstraints(
                    minWidth: kMinInteractiveDimension,
                    minHeight: kMinInteractiveDimension,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSrToast({
  required BuildContext context,
  required String message,
  SrFeedbackTone tone = SrFeedbackTone.neutral,
  Widget? leading,
  String? actionLabel,
  VoidCallback? onAction,
  bool showCloseButton = false,
  String? dismissSemanticLabel,
  String? semanticLabel,
  Duration duration = const Duration(seconds: 4),
}) {
  assert((actionLabel == null) == (onAction == null));
  assert(!showCloseButton || dismissSemanticLabel != null);
  if (!context.mounted) return null;

  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return null;

  late final ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
  controller;
  controller = messenger.showSnackBar(
    SnackBar(
      backgroundColor: SrColors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      padding: EdgeInsets.zero,
      content: SrToast(
        message: message,
        tone: tone,
        leading: leading,
        actionLabel: actionLabel,
        onAction: onAction == null
            ? null
            : () {
                try {
                  onAction();
                } finally {
                  controller.close();
                }
              },
        onDismiss: showCloseButton ? () => controller.close() : null,
        dismissSemanticLabel: dismissSemanticLabel,
        semanticLabel: semanticLabel,
      ),
    ),
  );

  return controller;
}
