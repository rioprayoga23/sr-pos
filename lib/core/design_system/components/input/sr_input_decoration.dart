import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_text_styles.dart';
import 'package:sr_pos/core/design_system/components/sr_component_size.dart';
import 'package:sr_pos/core/design_system/foundations/sr_borders.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';

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

  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    helperText: helperText,
    errorText: errorText,
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
