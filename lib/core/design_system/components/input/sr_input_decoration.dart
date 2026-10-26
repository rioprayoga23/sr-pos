import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_text_styles.dart';
import 'package:sr_pos/core/design_system/components/sr_component_size.dart';
import 'package:sr_pos/core/design_system/foundations/sr_borders.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

/// Builds the shared decoration used by SR-POS text-like inputs.
///
/// Kept out of the public barrel: application code should consume a component
/// rather than composing a visually similar field from this helper.
InputDecoration srInputDecoration(
  BuildContext context, {
  String? labelText,
  String? hintText,
  String? helperText,
  String? errorText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  required TextStyle valueStyle,
  Color? fillColor,
  SrComponentSize size = SrComponentSize.medium,
}) {
  final colors = Theme.of(context).colorScheme;
  const radius = BorderRadius.all(Radius.circular(SrRadii.medium));
  final contentPadding = size == SrComponentSize.small
      ? const EdgeInsets.symmetric(
          horizontal: SrComponentMetrics.smallInputHorizontalPadding,
          vertical: SrComponentMetrics.smallInputVerticalPadding,
        )
      : const EdgeInsets.symmetric(
          horizontal: SrSpacing.space16,
          vertical: SrSpacing.space12,
        );
  final placeholderStyle = SrComponentTextStyles.inputPlaceholder(
    context,
    valueStyle: valueStyle,
  );
  final helperStyle = size == SrComponentSize.small
      ? SrTypography.bodyExtraSmall.copyWith(color: colors.onSurfaceVariant)
      : null;
  final helper = helperText == null
      ? null
      : size == SrComponentSize.small
      ? Transform.translate(
          offset: Offset(
            (Directionality.of(context) == TextDirection.rtl ? 1 : -1) *
                (contentPadding.left + SrSpacing.space4),
            0,
          ),
          child: Text(
            helperText,
            style: helperStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      : null;
  final error = errorText == null
      ? null
      : size == SrComponentSize.small
      ? srInputErrorWidget(context, errorText, size: size)
      : null;

  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    helper: errorText == null ? helper : null,
    helperText: size == SrComponentSize.small ? null : helperText,
    helperStyle: helperStyle,
    error: error,
    errorText: size == SrComponentSize.small ? null : errorText,
    labelStyle: placeholderStyle,
    hintStyle: placeholderStyle,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: fillColor ?? colors.surfaceContainerLow,
    contentPadding: contentPadding,
    border: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.outline, width: SrBorders.thin),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.outline, width: SrBorders.thin),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.primary, width: SrBorders.focus),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.error, width: SrBorders.thin),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.error, width: SrBorders.focus),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: colors.outlineVariant,
        width: SrBorders.thin,
      ),
    ),
  );
}

/// Renders validation copy with the same leading edge as small-field helpers.
Widget srInputErrorWidget(
  BuildContext context,
  String message, {
  required SrComponentSize size,
}) {
  final colors = Theme.of(context).colorScheme;
  final isCompact = size == SrComponentSize.small;
  final text = Text(
    message,
    style: (isCompact ? SrTypography.bodyExtraSmall : SrTypography.bodySmall)
        .copyWith(color: colors.error),
    maxLines: isCompact ? 1 : null,
    overflow: isCompact ? TextOverflow.ellipsis : null,
  );
  if (!isCompact) return text;

  final contentPadding = SrComponentMetrics.smallInputHorizontalPadding;
  return Transform.translate(
    offset: Offset(
      (Directionality.of(context) == TextDirection.rtl ? 1 : -1) *
          (contentPadding + SrSpacing.space4),
      0,
    ),
    child: text,
  );
}
