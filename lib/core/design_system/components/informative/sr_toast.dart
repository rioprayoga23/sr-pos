import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/assets/sr_icon.dart';
import 'package:sr_pos/core/design_system/components/control/sr_button.dart';
import 'package:sr_pos/core/design_system/components/informative/sr_feedback_tone.dart';
import 'package:sr_pos/core/design_system/components/sr_component_size.dart';
import 'package:sr_pos/core/design_system/foundations/sr_borders.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';
import 'package:toastification/toastification.dart';

// assumption: compact mobile toasts stay within a 320 px reading width.
const double _smallToastMaxWidth = SrSizing.size80 * 4;

class SrToast extends StatelessWidget {
  const SrToast({
    required this.message,
    this.title,
    this.content,
    this.tone = SrFeedbackTone.neutral,
    this.size = SrComponentSize.small,
    this.leading,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.dismissSemanticLabel,
    this.semanticLabel,
    super.key,
  }) : assert((actionLabel == null) == (onAction == null));

  /// The supporting message. It can be used on its own or below [title].
  final String message;

  /// Optional short heading that gives the notification a clear hierarchy.
  final String? title;

  /// Optional content for richer notifications, composed from core components.
  final Widget? content;

  final SrFeedbackTone tone;
  final SrComponentSize size;
  final Widget? leading;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;
  final String? dismissSemanticLabel;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final palette = tone.resolve(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isSmall = size == SrComponentSize.small;
    final titleStyle = (isSmall ? SrTypography.heading5 : SrTypography.heading4)
        .copyWith(color: colorScheme.onSurface);
    final messageStyle =
        (isSmall
                ? SrTypography.bodySmall
                : title != null
                ? SrTypography.bodySmall
                : SrTypography.bodyMedium)
            .copyWith(color: colorScheme.onSurface);
    final statusLabel =
        semanticLabel ??
        [
          title,
          message,
        ].whereType<String>().where((value) => value.isNotEmpty).join('. ');
    final iconSize = isSmall ? SrIconSize.small : SrIconSize.medium;
    final icon = leading ?? SrIcon(_toastIconFor(tone), size: iconSize);
    final toastPadding = SrSpacing.space8;
    final iconTileSize = isSmall ? SrSizing.size32 : SrSizing.size56;
    final iconGap = isSmall ? SrSpacing.space8 : SrSpacing.space12;
    final cardRadius = isSmall ? SrRadii.medium : SrRadii.extraLarge;
    final iconTileRadius = isSmall ? SrRadii.small : SrRadii.large;
    final iconTile = Material(
      color: palette.solid,
      borderRadius: BorderRadius.circular(iconTileRadius),
      child: SizedBox.square(
        dimension: iconTileSize,
        child: Center(
          child: IconTheme.merge(
            data: IconThemeData(color: palette.onSolid, size: iconSize.value),
            child: icon,
          ),
        ),
      ),
    );

    final toastCard = Material(
      color: palette.background,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
        side: BorderSide(color: palette.border, width: SrBorders.thin),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: toastPadding,
          vertical: isSmall ? SrSpacing.none : toastPadding,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconTile,
            SizedBox(width: iconGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title case final toastTitle?) ...[
                    Text(
                      toastTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titleStyle,
                    ),
                    if (message.isNotEmpty || content != null)
                      const SizedBox(height: SrSpacing.space2),
                  ],
                  if (message.isNotEmpty)
                    Text(
                      message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: messageStyle,
                    ),
                  if (content case final toastContent?) ...[
                    if (message.isNotEmpty)
                      SizedBox(
                        height: isSmall ? SrSpacing.space4 : SrSpacing.space8,
                      ),
                    DefaultTextStyle.merge(
                      style:
                          (isSmall
                                  ? SrTypography.bodyExtraSmall
                                  : SrTypography.bodySmall)
                              .copyWith(color: colorScheme.onSurfaceVariant),
                      child: IconTheme.merge(
                        data: IconThemeData(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        child: toastContent,
                      ),
                    ),
                  ],
                  if (actionLabel case final label?) ...[
                    SizedBox(
                      height: isSmall ? SrSpacing.space2 : SrSpacing.space4,
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: colorScheme.copyWith(
                            primary: palette.foreground,
                            onPrimary: palette.onSolid,
                          ),
                        ),
                        child: SrButton(
                          label: label,
                          size: SrComponentSize.small,
                          variant: SrButtonVariant.tertiary,
                          semanticLabel: label,
                          onPressed: onAction,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onDismiss case final dismiss?) ...[
              SizedBox(width: isSmall ? SrSpacing.space2 : SrSpacing.space4),
              SizedBox.square(
                dimension: SrSizing.minimumTouchTarget,
                child: IconButton(
                  onPressed: dismiss,
                  tooltip: dismissSemanticLabel ?? 'Tutup notifikasi',
                  padding: EdgeInsets.zero,
                  color: colorScheme.onSurfaceVariant,
                  icon: SrIcon(Icons.close_rounded, size: iconSize),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    return Semantics(
      label: statusLabel,
      liveRegion: true,
      container: true,
      explicitChildNodes: true,
      child: isSmall
          ? Align(
              alignment: AlignmentDirectional.centerEnd,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: _smallToastMaxWidth,
                ),
                child: toastCard,
              ),
            )
          : toastCard,
    );
  }
}

IconData _toastIconFor(SrFeedbackTone tone) => switch (tone) {
  SrFeedbackTone.neutral => Icons.notifications_none_rounded,
  SrFeedbackTone.info => Icons.info_outline_rounded,
  SrFeedbackTone.success => Icons.check_circle_outline_rounded,
  SrFeedbackTone.warning => Icons.warning_amber_outlined,
  SrFeedbackTone.error => Icons.error_outline_rounded,
};

ToastificationItem? showSrToast({
  required BuildContext context,
  required String message,
  String? title,
  Widget? content,
  SrFeedbackTone tone = SrFeedbackTone.neutral,
  SrComponentSize? size,
  Widget? leading,
  String? actionLabel,
  VoidCallback? onAction,
  bool showCloseButton = true,
  String? dismissSemanticLabel,
  String? semanticLabel,
  Duration duration = const Duration(seconds: 4),
}) {
  assert((actionLabel == null) == (onAction == null));
  if (!context.mounted || Overlay.maybeOf(context) == null) return null;

  final toastSize = size ?? SrComponentSize.small;

  return toastification.showCustom(
    context: context,
    alignment: Alignment.topCenter,
    autoCloseDuration: duration,
    builder: (_, toastItem) => SrToast(
      title: title,
      message: message,
      content: content,
      tone: tone,
      size: toastSize,
      leading: leading,
      actionLabel: actionLabel,
      onAction: actionLabel == null
          ? null
          : () {
              try {
                onAction?.call();
              } finally {
                toastification.dismiss(toastItem);
              }
            },
      onDismiss: showCloseButton
          ? () => toastification.dismiss(toastItem)
          : null,
      dismissSemanticLabel: dismissSemanticLabel,
      semanticLabel: semanticLabel,
    ),
  );
}
