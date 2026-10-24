import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_text_styles.dart';
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
  Color? fillColor,
}) {
  final colors = Theme.of(context).colorScheme;
  const radius = BorderRadius.all(Radius.circular(SrRadii.medium));

  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    helperText: helperText,
    errorText: errorText,
    hintStyle: SrComponentTextStyles.inputPlaceholder(context),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: fillColor ?? colors.surfaceContainerLow,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: SrSpacing.space16,
      vertical: SrSpacing.space12,
    ),
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
