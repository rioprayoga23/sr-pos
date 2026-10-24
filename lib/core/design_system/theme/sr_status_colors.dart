import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';

/// Semantic status colors that are not represented by Material [ColorScheme].
@immutable
final class SrStatusColors extends ThemeExtension<SrStatusColors> {
  const SrStatusColors({
    required this.success,
    required this.successAccent,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningAccent,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
  });

  static const SrStatusColors light = SrStatusColors(
    success: SrColors.success700,
    successAccent: SrColors.success500,
    onSuccess: SrColors.neutralLight100,
    successContainer: SrColors.success100,
    onSuccessContainer: SrColors.neutralDark900,
    warning: SrColors.warning700,
    warningAccent: SrColors.warning500,
    onWarning: SrColors.neutralDark900,
    warningContainer: SrColors.warning100,
    onWarningContainer: SrColors.neutralDark900,
  );

  final Color success;
  final Color successAccent;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningAccent;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  @override
  SrStatusColors copyWith({
    Color? success,
    Color? successAccent,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningAccent,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
  }) {
    return SrStatusColors(
      success: success ?? this.success,
      successAccent: successAccent ?? this.successAccent,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      warningAccent: warningAccent ?? this.warningAccent,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
    );
  }

  @override
  SrStatusColors lerp(covariant SrStatusColors? other, double t) {
    if (other == null) {
      return this;
    }

    return SrStatusColors(
      success: Color.lerp(success, other.success, t)!,
      successAccent: Color.lerp(successAccent, other.successAccent, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningAccent: Color.lerp(warningAccent, other.warningAccent, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
    );
  }
}
