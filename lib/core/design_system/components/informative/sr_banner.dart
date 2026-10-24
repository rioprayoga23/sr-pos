import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/informative/sr_feedback_tone.dart';
import 'package:sr_pos/core/design_system/foundations/sr_borders.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

class SrBanner extends StatelessWidget {
  const SrBanner({
    required this.message,
    this.title,
    this.tone = SrFeedbackTone.info,
    this.leading,
    this.actions = const <Widget>[],
    this.onDismiss,
    this.dismissSemanticLabel,
    this.semanticLabel,
    super.key,
  }) : assert(onDismiss == null || dismissSemanticLabel != null);

  final String? title;
  final String message;
  final SrFeedbackTone tone;
  final Widget? leading;
  final Iterable<Widget> actions;
  final VoidCallback? onDismiss;
  final String? dismissSemanticLabel;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final palette = tone.resolve(context);

    return Semantics(
      label: semanticLabel,
      container: true,
      liveRegion: tone == SrFeedbackTone.error,
      child: Material(
        color: palette.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SrRadii.medium),
          side: BorderSide(color: palette.border, width: SrBorders.thin),
        ),
        child: Padding(
          padding: const EdgeInsets.all(SrSpacing.space16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTheme.merge(
                data: IconThemeData(
                  color: palette.foreground,
                  size: SrSizing.size24,
                ),
                child: leading ?? Icon(tone.icon),
              ),
              const SizedBox(width: SrSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title case final bannerTitle?) ...[
                      Text(
                        bannerTitle,
                        style: SrTypography.heading4.copyWith(
                          color: palette.foreground,
                        ),
                      ),
                      const SizedBox(height: SrSpacing.space4),
                    ],
                    Text(
                      message,
                      style: SrTypography.bodyMedium.copyWith(
                        color: palette.foreground,
                      ),
                    ),
                    if (actions.isNotEmpty) ...[
                      const SizedBox(height: SrSpacing.space12),
                      Wrap(
                        spacing: SrSpacing.space8,
                        runSpacing: SrSpacing.space8,
                        children: actions.toList(growable: false),
                      ),
                    ],
                  ],
                ),
              ),
              if (onDismiss != null) ...[
                const SizedBox(width: SrSpacing.space8),
                IconButton(
                  onPressed: onDismiss,
                  tooltip: dismissSemanticLabel,
                  color: palette.foreground,
                  icon: const Icon(Icons.close_rounded),
                  constraints: const BoxConstraints(
                    minWidth: kMinInteractiveDimension,
                    minHeight: kMinInteractiveDimension,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
